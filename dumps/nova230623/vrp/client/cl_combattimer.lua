globalInRedzone = false

local a = false

local b = 0

local c = false

local d = {

    ["Rebel"] = {type = "radius", pos = vector3(1468.5318603516, 6328.529296875, 18.894895553589), radius = 100.0, blipColour = 1,alpha =175},

    ["Heroin"] = {type = "radius", pos = vector3(3545.048828125, 3724.0776367188, 36.64262008667), radius = 170.0,blipColour = 1,alpha =175},

    ["LargeArms"] = {type = "radius", pos = vector3(-1118.4926757813, 4926.1889648438, 218.35691833496), radius = 170.0,blipColour = 1,alpha =175},

    ["LargeArmsCayo"] = {type = "radius",pos = vector3(5115.7465820312, -4623.2915039062, 2.642692565918),radius = 85.0,blipColour = 1,alpha =175},

    ["RebelCayo"] = {type = "radius", pos = vector3(4982.5634765625, -5175.1079101562, 2.4887988567352), radius = 120.0,blipColour = 1,alpha =175},

    ["LSDNorth"] = {type = "radius", pos = vector3(1317.0300292969, 4309.8359375, 38.005485534668), radius = 90.0,blipColour = 1,alpha =175},

    ["LSDSouth"] = {type = "radius", pos = vector3(2539.0964355469, -376.51586914063, 92.986785888672), radius = 120.0,blipColour = 1,alpha =175},

}

function tvRP.setRedzoneTimerDisabled(e) a = e end



function tvRP.isPlayerInRedZone() return globalInRedzone end



local f = 0

function tvRP.setPlayerCombatTimer(g, h)

    



b = g if h then c = true end

if GetGameTimer() - f > 2500  then 

TriggerServerEvent("NOVA:setCombatTimer", g)

f = GetGameTimer() end end



function tvRP.getPlayerCombatTimer() return b, c end

local function i(j, k, l)

if k.type == "radius" then

if l then return #(j.xy - k.pos.xy) <= k.radius else

return #(j - k.pos) <= k.radius end

elseif k.type == "area" then

local m = k.width / 2.0

local n = k.height / 2.0

if #(j - k.pos) <= m + n then

local o = vector3(m, n, 0.0)

local p = k.pos + o

local q = k.pos - o

return j.x < p.x and j.y < p.y and j.x > q.x and j.y > q.y

end end return false end



CreateThread(function() while true do

if not a then

local r = GetEntityCoords(GetPlayerPed(-1))

globalInRedzone = false

for s, k in pairs(d) do

local blip = AddBlipForRadius(k.pos, k.radius)

SetBlipColour(blip, k.blipColour)

SetBlipAlpha(blip, k.alpha)

if i(r, k, false) then

globalInRedzone = true

inredzone = false

local r = GetEntityCoords(GetPlayerPed(-1))

tvRP.setPlayerCombatTimer(30, false)

local t

local u = false

while not u do

r = GetEntityCoords(GetPlayerPed(-1))

while i(r, k, true) do

r = GetEntityCoords(GetPlayerPed(-1))

t = r

if IsPedShooting(GetPlayerPed(-1)) and GetSelectedPedWeapon(GetPlayerPed(-1)) ~= GetHashKey("WEAPON_UNARMED") then

tvRP.setPlayerCombatTimer(60, true) end

if b == 0 then DrawAdvancedText(0.931,0.914,0.005,0.0028,0.49,"Combat Timer ended, you may leave.",255,51,51,255,7,0) end Wait(0) end

if b == 0 then

u = true

outtaredzone = false else

local playerPed = GetPlayerPed(-1)

outtaredzone = true

TaskGoStraightToCoord(playerPed, k.pos, 10.0,-1, GetEntityHeading(playerPed), 0.0)

local soundId = GetSoundId()

PlaySoundFrontend(soundId, "End_Zone_Flash", "DLC_BTL_RB_Remix_Sounds", true)

ReleaseSoundId(soundId)        

SetTimeout(200,function()

ClearPedTasks(GetPlayerPed(-1))

outtaredzone = false

end) end Wait(0) end end end end Wait(200) end end)



CreateThread(function() while true do Wait(1)

if outtaredzone and globalInRedzone then DisableAllControlActions(0)

elseif not outtaredzone then  EnableAllControlActions(0) end end end)



CreateThread(function()

    while true do

        if b > 0 then

            if a then

                tvRP.setPlayerCombatTimer(0, false)

            else

                b = b - 1

                if b == 0 then

                    c = false

                end

            end

        end

        Wait(1000)

    end

end)

local x = {["WEAPON_UNARMED"] = true, ["WEAPON_PETROLCAN"] = true, ["WEAPON_SNOWBALL"] = true}
local function k()
    return globalOnPoliceDuty or globalOnPrisonDuty or globalNHSOnDuty or globalLFBOnDuty
end

AddEventHandler("NOVA:startCombatTimer",function(h)

    if true then --and not tvRP.isInPaintball() then   // not tvRP.isEmergencyService()

        tvRP.setPlayerCombatTimer(60, h)

    end

end)

local function y()

    if not k() and not tvRP.isInComa() then

        local z = GetPlayerPed(-1)

        if HasEntityBeenDamagedByWeapon(z, 0, 2) then

            CreateThread(function()

                ClearEntityLastDamageEntity(z)

                ClearEntityLastWeaponDamage(z)

            end)

            tvRP.setPlayerCombatTimer(60, true)

        end

        local A = GetSelectedPedWeapon(z)

        if IsPedShooting(z) and not x[A] then

            tvRP.setPlayerCombatTimer(60, true)

        elseif GetPlayerTargetEntity(tvRP.getPlayerId()) and IsControlPressed(0, 24) then

            tvRP.setPlayerCombatTimer(60, true)

        end

    end

    if b > 0 then

        DrawAdvancedText(0.985,0.965,0.005,0.0028,0.467,"COMBAT TIMER: " .. b .. " seconds",246,74,70,255,7,0)

    end

end

createThreadOnTick(y)

local function B()

    local z = GetPlayerPed(-1)

    SetCanPedEquipWeapon(z, "WEAPON_MOLOTOV", false)

    if GetSelectedPedWeapon(z) == GetHashKey("WEAPON_MOLOTOV") then

        tvRP.setWeapon(z, "WEAPON_UNARMED", true)

    end

end

local function C()

    SetCanPedEquipWeapon(GetPlayerPed(-1), "WEAPON_MOLOTOV", true)

end