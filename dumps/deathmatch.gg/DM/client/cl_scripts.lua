local ScriptsToLoad = {
    "Admin-Menu",
    "Callmanager",
    "Main-Menu",
    "Spawn-Manage",
    "Killfeed",
    "Selector",
    "Core",
}

local TeamsAssign = {
    {"Backgarages:TeamA", "Backgarages:TeamB"}, 
    {"ChickenFactory:TeamA", "ChickenFactory:TeamB"}, 
    {"PigFactory:TeamA", "PigFactory:TeamB"},
    {"Player", "Player"}
}


for k,v in pairs(TeamsAssign) do
    AddRelationshipGroup(v[1])
    AddRelationshipGroup(v[2])
    SetRelationshipBetweenGroups(5, v[1], v[2])
    SetRelationshipBetweenGroups(5, v[2], v[1])
end

for k,v in pairs(ScriptsToLoad) do
    print("[^1DM^7] Module ^4" .. v .." Successfully Loaded")
end
print("Client Authenticated\nServer Owner/Developer: Vrxith\nYoutube: youtube.com/vrxith\nDonate: store.deathmatch.com/packages\nEnjoy Your Time On The Server.")


local handsup = false
local TimeStr = "00:00"
local Kills = 0
local Deaths = 0
KDR = true

function DMclient.ModifyKDR(type)
    if type == "kills" then
        Kills = Kills + 1
    elseif type == "deaths" then
        Deaths = Deaths + 1
    end
end

Citizen.CreateThread(function()
    RequestAnimDict('mp_arresting')
	RequestAnimDict('random@arrests')
	RequestAnimDict('missminuteman_1ig_2')
    while true do 
        Wait(0)
        if KDR and not HudActive and SelectedZone ~= "gunGame" then
            DrawTimerBar("~g~Kills", Kills, 1)
            DrawTimerBar("~r~Deaths", Deaths, 2)
            DrawTimerBar("Time Played:", TimeStr, 3)
        end

        if IsPedArmed(PlayerPedId(), 6) then
            DisableControlAction(1, 140, true)
        	DisableControlAction(1, 141, true)
        	DisableControlAction(1, 142, true)
        end

        SetPlayerLockon(PlayerId(), false) -- // Disables Controller Lock On + Anti-Cheat //
        SetPedConfigFlag(PlayerPedId(), 149, true) -- // 1/2 Fix for head shot tanking //
        SetPedConfigFlag(PlayerPedId(), 438, true) -- // 2/2 Fix for headshot tanking // 
        RestorePlayerStamina(PlayerId(), 1.0) -- // Sets All Clients Stamina To Infinite // 
        NetworkSetTalkerProximity(12.0) -- // Sets All Clients Voice Chat Proximity To 12.0m //
        SetPedDropsWeaponsWhenDead(GetPlayerPed(-1), 0) -- // All Clients Requests To Drops Weapons Is Rejected //

        if ConfigScripts.DisablePunching then
            -- // Disable Punching // 
            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_UNARMED") then -- // Checks for unarmed player // 
                DisableControlAction(0,263,true)
                DisableControlAction(0,264,true)
                DisableControlAction(0,257,true)
                DisableControlAction(0,140,true) 
                DisableControlAction(0,141,true) 
                DisableControlAction(0,142,true)
                DisableControlAction(0,143,true) 
                DisableControlAction(0,24,true)
                DisableControlAction(0,25,true) 
            end
            SetPedCanBeDraggedOut(PlayerPedId(),false)
        end

        if ConfigScripts.NoNpcs then
            SetPedDensityMultiplierThisFrame(0.0) 
            SetRandomVehicleDensityMultiplierThisFrame(0.0) 
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0) 
            SetGarbageTrucks(false) 
            SetRandomBoats(false) 
            SetCreateRandomCops(false)
            SetCreateRandomCopsNotOnScenarios(false) 
            SetCreateRandomCopsOnScenarios(false) 
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            ClearAreaOfVehicles(x, y, z, 1000, false, false, false, false, false)
            RemoveVehiclesFromGeneratorsInArea(x - 500.0, y - 500.0, z - 500.0, x + 500.0, y + 500.0, z + 500.0);
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false),-1) == GetPlayerPed(-1) then
                    SetVehicleDensityMultiplierThisFrame(0.0)
                    SetParkedVehicleDensityMultiplierThisFrame(0.0)
                else
                    SetVehicleDensityMultiplierThisFrame(0.0)
                    SetParkedVehicleDensityMultiplierThisFrame(0.0)
                end
            else
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetVehicleDensityMultiplierThisFrame(0.0)
            end
        end

        if SelectedZone == "Casual" then
            if IsControlPressed(1, 323) then
                DisablePlayerFiring(PlayerPedId(), true)
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 25, true)
                if GetEntityHealth(PlayerPedId()) == 102 then
                    --print("DEAD NO HANDS UP")
                else
                    if not IsEntityDead(PlayerPedId()) then
                        -- if not IsPedReloading(PlayerPedId()) then
                            if not handsup then
                                handsup = true

                                TaskPlayAnim(PlayerPedId(), 'missminuteman_1ig_2', 'handsup_enter', 7.0, 1.0, -1, 50, 0, false, false, false)
                            end
                        -- end
                    end
                end
            end


            if IsControlReleased(1, 323) and handsup then
                handsup = false

                CreateThread(function()
                    local enableFiring = false

                    CreateThread(function()
                        Wait(1000)

                        enableFiring = true
                    end)
                    
                    while not enableFiring do
                        DisablePlayerFiring(PlayerPedId(), true)

                        Wait(1)
                    end
                end)

                DisableControlAction(0, 21, true)
                DisableControlAction(0, 137, true)

                ClearPedTasks(PlayerPedId())
            end
        end
        
        if ConfigScripts.HealthRegen == false then
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        end

        if ConfigScripts.WantedLevels then
            for i = 1, 12 do
                EnableDispatchService(i, false)
            end
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
            SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
        end

        if ConfigScripts.RenderDistance then
            Citizen.InvokeNative(0xA76359FC80B2438E, ConfigMain.Settings.DistanceFind[ConfigMain.Settings.DistanceIndex][2])
        end

        if HudActive then
            HideHudAndRadarThisFrame()
            TriggerEvent("chat:clear")
        end

        if #(GetEntityCoords(PlayerPedId()) - vector3(-75.11897, -818.991, 326.1751)) < 50 then
            DrawMissionText("You are in an admin situation, if you leave the server you will be banned.")
            DisableControlAction(2, 37, true)
			DisablePlayerFiring(PlayerPedId(), true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 140, true)
        end

        if #(GetEntityCoords(PlayerPedId()) - vector3(1407.463, 3079.604, 129.6792)) < 11.7 then 
            DisableControlAction(2, 37, true)
			DisablePlayerFiring(PlayerPedId(), true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 140, true)
            SetEntityInvincible(PlayerPedId(), true)
        else
            SetEntityInvincible(PlayerPedId(), false)
        end

        if ConfigScripts.WeatherCustom then
            SetWeatherTypePersist(ConfigMain.Settings.WeatherFind[ConfigMain.Settings.WeatherIndex][2])
            SetWeatherTypeNowPersist(ConfigMain.Settings.WeatherFind[ConfigMain.Settings.WeatherIndex][2])
            SetWeatherTypeNow(ConfigMain.Settings.WeatherFind[ConfigMain.Settings.WeatherIndex][2])
            SetOverrideWeather(ConfigMain.Settings.WeatherFind[ConfigMain.Settings.WeatherIndex][2])
        end
    end
end)


function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end



Citizen.CreateThread(function()
    local starttick = GetGameTimer()
    while true do
        local tick = GetGameTimer()
		local uptimeHour = math.floor((tick-starttick)/3600000)
		local uptimeMinute = math.floor((tick-starttick)/60000) % 60
		local uptimeSecond = math.floor((tick-starttick)/1000) % 60

        if uptimeHour <= 9 then
            uptimeHour = "0"..uptimeHour
        end

        if uptimeMinute <= 9 then
            uptimeMinute = "0"..uptimeMinute
        end
        if uptimeSecond <= 9 then
            uptimeSecond = "0"..uptimeSecond
        end
        TimeStr = uptimeHour..":"..uptimeMinute..":"..uptimeSecond
        Wait(1000)
    end
end)
