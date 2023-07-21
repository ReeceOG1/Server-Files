local a = {{entryPosition = vector3(1109.76, 227.89, -49.64)}}
local b
local c
local d = false
local prizes = {
    [1] = "car",
    [2] = "rock",
    [3] = "rebel_revolver",
    [4] = "handcuff_keys",
    [5] = "chips_50000",
    [6] = "cash_50000",
    [7] = "shaver",
}
c = "m4lb"
RMenu.Add("luckywheel", "casino", RageUI.CreateMenu("", "", 0, 100, "casinoui_lucky_wheel", "casinoui_lucky_wheel"))
RMenu:Get("luckywheel", "casino"):SetSubtitle("~b~You may only spin the wheel once per restart.")
RegisterNetEvent("GMT:frameworkCleanup")
AddEventHandler("GMT:frameworkCleanup",function()
    DeleteEntity(b)
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('luckywheel', 'casino')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Spin the wheel of GMT (50,000 Chips)","",{RightLabel = "→→→"},true,function(e, f, g)
                if g then
                    TriggerServerEvent("GMT:requestSpinLuckyWheel")
                end
            end)
        end)
    end
end)

function showCasinoLuckyWheelUI(h)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("luckywheel", "casino"), h)
end
Citizen.CreateThread(function()
    while not insideDiamondCasino do
        Wait(1000)
    end
    local i = tGMT.loadModel("vw_prop_vw_luckywheel_02a")
    local j = tGMT.loadModel(c)
    b = CreateObject(i, 1111.05, 229.81, -50.38, false, false, true)
    SetEntityHeading(b, 0.0)
    SetModelAsNoLongerNeeded(i)
    local k = CreateVehicle(j, 1100.39, 220.09, -51.25, 0.0, false, false)
    DecorSetInt(k,"GMTACVeh",955)
    SetModelAsNoLongerNeeded(j)
    FreezeEntityPosition(k, true)
    local l = GetEntityCoords(k)
    SetEntityCoords(k, l.x, l.y, l.z + 1, false, false, true, true)
    SetVehicleOnGroundProperly(k, 5.0)
    c = k
end)

Citizen.CreateThread(function()
    while not insideDiamondCasino do
        Wait(1000)
    end
    while true do
        if insideDiamondCasino then
            if c ~= nil then
                local m = GetEntityHeading(c)
                local n = m - 0.1
                SetEntityHeading(c, n)
            end
        end
        Citizen.Wait(5)
    end
end)

function actuallyRollWheel()
    SetEntityHeading(b, -30.9754)
    Citizen.CreateThread(function()
        local p = 1
        local q
        local r = math.random(1, 360)
        local s = r + 360 * 8
        local t = s / 2
        local u = 0
        local v = -20
        local finalPosition = math.floor((GetEntityHeading(b) / 360) * 10) + 1
        finalPosition = ((finalPosition - 1) % 10) + 1
        while p > 0 do
            local w = GetEntityRotation(b, 1)
            if s > t then
                p = p + 1
            else
                p = p - 1
                if p < 0 then
                    p = 0
                end
            end
            u = u + 1
            q = p / 200
            local x = w.y - q
            if x - v < 5 and x - v > -5 then
                local soundId = PlaySoundFromCoord(GetSoundId(), "Spin_Single_Ticks", 1109.76, 227.89, -49.64, "dlc_vw_casino_lucky_wheel_sounds", 0, 0, 0)
                SetTimeout(100, function()
                    ReleaseSoundId(soundId)
                end)
                v = v - 20
                if v == -180 then
                    v = 180
                end
            else
                if v == 180 then
                    angleCounter2 = -180
                    if x - angleCounter2 < 5 and x - angleCounter2 > -5 then
                        local soundId = PlaySoundFromCoord(GetSoundId(), "Spin_Single_Ticks", 1109.76, 227.89, -49.64, "dlc_vw_casino_lucky_wheel_sounds", 0, 0, 0)
                        SetTimeout(100, function()
                            ReleaseSoundId(soundId)
                        end)
                    end
                    v = v - 20
                end
            end
            s = s - q
            SetEntityHeading(b, -30.9754)
            SetEntityRotation(b, 0.0, x, 0.0, 2, true)
            Citizen.Wait(5)
        end

        -- Randomly select a prize with 1 out of 20 chance
        local prizeIndex = math.random(1, #prizes)
        local prizeWon = prizes[prizeIndex]

        TriggerServerEvent('GMT:wheelStopped', prizeIndex)
        PlaySoundFromCoord(GetSoundId(), "Win", 1109.76, 227.89, -49.64, "dlc_vw_casino_lucky_wheel_sounds", 0, 0, 0)
        d = false
    end)
end


function goToWheel()
    if not d then
        d = true
        local y = tGMT.getPlayerPed()
        local z = "anim_casino_a@amb@casino@games@lucky7wheel@female"
        if IsPedMale(y) then
            z = "anim_casino_a@amb@casino@games@lucky7wheel@male"
        end
        local A, B = z, "enter_right_to_baseidle"
        RequestAnimDict(A)
        Wait(50)
        local C = vector3(1109.55, 228.88, -49.64)
        TaskGoStraightToCoord(y, C.x, C.y, C.z, 1.0, -1, 312.2, 0.0)
        local D = false
        while not D do
            local E = GetEntityCoords(tGMT.getPlayerPed())
            if E.x >= C.x - 0.01 and E.x <= C.x + 0.01 and E.y >= C.y - 0.01 and E.y <= C.y + 0.01 then
                D = true
            end
            Citizen.Wait(0)
        end
        TaskPlayAnim(y, A, B, 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(y, A, B, 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        TaskPlayAnim(y, A, "enter_to_armraisedidle", 8.0, -8.0, -1, 0, 0, false, false, false)
        while IsEntityPlayingAnim(y, A, "enter_to_armraisedidle", 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        TaskPlayAnim(y, A, "armraisedidle_to_spinningidle_high", 8.0, -8.0, -1, 0, 0, false, false, false)
        SetEntityHeading(tGMT.getPlayerPed(), 10.9754)
        Wait(2000)
        TaskPlayAnim(y, A, "baseidle_variation_02", 8.0, -8.0, -1, 1, 0, false, false, false)
    end
end

AddEventHandler("GMT:onClientSpawn",function(D, E)
    if E then
		local H = function(I)
            showCasinoLuckyWheelUI(true)
        end
        local J = function(I)
            showCasinoLuckyWheelUI(false)
        end
        local K = function(I)
        end
        local L = function(I)
        end
        for M, N in pairs(a) do
            tGMT.addBlip(N.entryPosition.x, N.entryPosition.y, N.entryPosition.z, 681, 0, "GMT Wheel", 0.7, true)
            tGMT.createArea("gmtwheel_" .. M, N.entryPosition, 1.5, 6, H, J, K, {})
        end
	end
end)

RegisterNetEvent("GMT:syncLuckyWheel")
AddEventHandler("GMT:syncLuckyWheel",function(prizeIndex)
    Wait(1150)
    actuallyRollWheel(prizeIndex)
end)

RegisterNetEvent("GMT:spinLuckyWheel")
AddEventHandler("GMT:spinLuckyWheel",function()
    goToWheel()
end)

RegisterNetEvent("GMT:playLuckyWheelReactionAnimation")
AddEventHandler("GMT:playLuckyWheelReactionAnimation", function(prizeWon)
    local playerPed = PlayerPedId()
    local animDict = "anim_casino_a@amb@casino@games@lucky7wheel@female"
  
    if IsPedMale(playerPed) then
        animDict = "anim_casino_a@amb@casino@games@lucky7wheel@male"
    end

    local animationName = "win" .. prizeWon

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(playerPed, animDict, animationName, 8.0, -8.0, -1, 0, 0, false, false, false)
    Citizen.Wait(3000) -- Adjust the duration if necessary

    ClearPedTasks(playerPed)
end)
