local h = {
  "Front Left",
  "Front Right",
  "Back Left",
  "Back Right",
  "Hood",
  "Trunk",
  "Second Trunk",
  "Windows",
  "Close All"
}
local j = {43, 427, 60, 786603, 1074528293, 262716, 537133628, 524860, 1076}
local k = {
  vehicle = nil,
  adSpeed = 1,
  autoDrive = false,
  limiterSpeed = 1,
  limiter = false,
  predictedMax = nil,
  door = 1,
  limitingVehicle = nil,
  currentLimit = nil,
  cruise = false,
  adMode = 1
}
local l = false
local m = false
local n = false
local o = false
local p = false
local q = 0
local r = true
local s = false
local t = 1
Citizen.CreateThread(function()
    while true do
        if m and tGMT.getPlayerVehicle() ~= k.limitingVehicle then
            m = false
            SetVehicleMaxSpeed(tGMT.getPlayerVehicle(), k.predictedMax)
            predictedMax = nil
            tGMT.notify("Vehicle Changed, stopping limiter")
        end
        Wait(500)
    end
end)
function convert(speed)
  return speed * 10 * 0.44704 - 0.5
end

function limiter()
    Citizen.CreateThread(function()
        while k.limiter do
            local z = tGMT.getPlayerVehicle()
            local speed = k.limiterSpeed
            if z ~= 0 then
                k.limitingVehicle = z
                m = true
                k.predictedMax = GetVehicleEstimatedMaxSpeed(z)
                if convert(speed) > k.predictedMax then
                    SetVehicleMaxSpeed(z, k.predictedMax)
                    k.currentLimit = k.predictedMax
                else
                    SetVehicleMaxSpeed(z, convert(speed))
                    k.currentLimit = convert(speed)
                end
            else
                tGMT.notify("You are not in a vehicle!")
                k.limiter = false
            end
            Wait(100)
        end
        SetVehicleMaxSpeed(k.limitingVehicle, k.predictedMax)
        p = false
        m = false
    end)
end

RMenu.Add("vehicle_menu", "main", RageUI.CreateMenu("Vehicle", "", tGMT.getRageUIMenuWidth(), tGMT.getRageUIMenuHeight()))
RMenu:Get("vehicle_menu", "main"):SetSubtitle("~b~VEHICLE OPTIONS")
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("vehicle_menu", "main")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Toggle Door Lock", "Select to toggle between doors locked and unlocked",{RightLabel=""},true,function(o,p,q)
                if q then
                    local L = tGMT.getPlayerVehicle()
                    if L ~= 0 then
                        if GetVehicleDoorLockStatus(L) ~= 2 then
                            SetVehicleDoorsLocked(L, 2)
                            tGMT.notify("~w~Doors are now ~r~Locked")
                        else
                            SetVehicleDoorsLocked(L, 0)
                            tGMT.notify("~w~Doors are now ~g~Unlocked")
                        end
                    end
                end
            end)
            RageUI.List("Toggle Door",h,k.door,"Select the door you want to toggle open/closed.",{}, true, function(I, J, K, M)
                if K then
                    local L = tGMT.getPlayerVehicle()
                    if L ~= 0 then
                        local N = M - 1
                        if M == 9 then
                            SetVehicleDoorsShut(L, false)
                            tGMT.notify("Closed ~w~all doors.")
                        elseif M == 8 then
                            if r then
                                r = false
                                RollDownWindow(L, 0)
                                RollDownWindow(L, 1)
                                tGMT.notify("Rolled windows ~r~Down")
                            else
                                r = true
                                RollUpWindow(L, 0)
                                RollUpWindow(L, 1)
                                tGMT.notify("Rolled windows ~g~Up")
                            end
                        elseif IsVehicleDoorDamaged(L, N) then
                            tGMT.notify("Cannot shut this door when the door is damaged")
                        elseif GetVehicleDoorAngleRatio(L, N) == 0 then
                            SetVehicleDoorOpen(L, N, false, false)
                            tGMT.notify(string.format("The ~b~%s ~w~door is now ~g~Open", h[M]))
                        else
                            SetVehicleDoorShut(L, N, false)
                            tGMT.notify(string.format("The ~b~%s ~w~door is now ~r~Closed", h[M]))
                        end
                    end
                end
                k.door = M
            end)
            RageUI.Checkbox("Activate Speed Limiter","Select to turn on Speed Limiter",k.limiter,{Style = RageUI.CheckboxStyle.Tick},function(I, K, J, O)
                if K then
                    if k.limiter then
                        RageUI.Text({message = string.format("~w~Speed Limiter is currently ~g~~h~Active")})
                        k.autoDrive = false
                        k.cruise = false
                        if not p then
                            local speed = GetEntitySpeed(tGMT.getPlayerVehicle())
                            if convert(speed) < 10.0 then
                                p = true
                                limiter()
                            else
                                p = false
                                tGMT.notify("Alert~w~: Please slow down to enable the speed limiter.")
                            end
                        end
                    else
                        RageUI.Text({message = string.format("~w~Speed Limiter is currently ~r~~h~Inactive")})
                    end
                end
                k.limiter = O
            end)
            RageUI.SliderProgress("Speed Limiter",k.limiterSpeed,25,"Select the speed you wish to limit your vehicle to.",{ProgressBackgroundColor = {R = 0, G = 0, B = 0, A = 255},ProgressColor = {R = 0, G = 117, B = 194, A = 255}},true,function(I, K, J, M)
                if K then
                    if M ~= k.limiterSpeed then
                        k.limiterSpeed = M
                        RageUI.Text({message = string.format("Setting Limiter Speed to: ~r~%s ~w~mph",k.limiterSpeed * 10)})
                    end
                end
            end)
            RageUI.Button("Toggle Engine","Select to toggle current vehicle engine on/off",{Style = RageUI.BadgeStyle.Key},true,function(I, J, K)
                if K then
                    local L = tGMT.getPlayerVehicle()
                    if GetIsVehicleEngineRunning(L) then
                        if L ~= 0 then
                            SetVehicleEngineOn(L, false, true, true)
                            tGMT.notify("You've turned the ignition into the ~r~off ~w~position.")
                        end
                    else
                        if L then
                            SetVehicleEngineOn(L, true, false, true)
                            tGMT.notify("You've turned the ignition to the ~g~on ~w~position.")
                        end
                    end
                end
            end)
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 244) then
            if IsPedInAnyVehicle(tGMT.getPlayerPed(), false) or RageUI.Visible(RMenu:Get("vehicle_menu", "main")) then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("vehicle_menu", "main"), not RageUI.Visible(RMenu:Get("vehicle_menu", "main")))
            else
                tGMT.notify("You are not in a vehicle!")
            end
        end
    end
end)