playingGunGame = false
serverReturnedTimeLeft = "00:00"
gunGameWeapons = {
    ["Group 1"] = {
        [1] = {Name = "M1911", SpawnCode = "WEAPON_M1911DM", Kills = 3},
        [2] = {Name = "Glock 17", SpawnCode = "WEAPON_GLOCK17DM", Kills = 2},
        [3] = {Name = "UMP-45", SpawnCode = "WEAPON_UMP45DM", Kills = 5},
        [4] = {Name = "Winchester 12", SpawnCode = "WEAPON_WINCHESTER12DM", Kills = 3},
        [5] = {Name = "MP5", SpawnCode = "WEAPON_MP5DM", Kills = 4}, 
        [6] = {Name = "AK-200", SpawnCode = "WEAPON_AK200DM", Kills = 7},
        [7] = {Name = "HK-416", SpawnCode = "WEAPON_HK416DM", Kills = 7},
        [8] = {Name = "M16-SP1", SpawnCode = "WEAPON_SP1DM", Kills = 9},
        [9] = {Name = "Mosin Nagant", SpawnCode = "WEAPON_MOSINNAGANTDM", Kills = 4},
        [10] = {Name = "Knife", SpawnCode = "WEAPON_KNIFE", Kills = 1},
    },
    ["Group 2"] = {
        [1] = {Name = "UZI", SpawnCode = "WEAPON_UZIDM", Kills = 4},
        [2] = {Name = "Glock 17", SpawnCode = "WEAPON_GLOCK17DM", Kills = 3},
        [3] = {Name = "Spar-16", SpawnCode = "WEAPON_SPAR16DM", Kills = 4},
        [4] = {Name = "Winchester 12", SpawnCode = "WEAPON_WINCHESTER12DM", Kills = 2},
        [5] = {Name = "SIG-516", SpawnCode = "WEAPON_SIG516DM", Kills = 4}, 
        [6] = {Name = "M60", SpawnCode = "WEAPON_COMBATMG", Kills = 3},
        [7] = {Name = "MG", SpawnCode = "WEAPON_MG", Kills = 5},
        [8] = {Name = "Special Carbine", SpawnCode = "WEAPON_SPECIALCARBINE", Kills = 3},
        [9] = {Name = "Mosin Nagant", SpawnCode = "WEAPON_MOSINNAGANTDM", Kills = 5},
        [10] = {Name = "Knife", SpawnCode = "WEAPON_KNIFE", Kills = 1},
    },
    ["Group 3"] = {
        [1] = {Name = "Combat Pistol", SpawnCode = "WEAPON_COMBATPISTOL", Kills = 4},
        [2] = {Name = "RE6", SpawnCode = "WEAPON_RE6DM", Kills = 3},
        [3] = {Name = "Marksman Rifle", SpawnCode = "WEAPON_MARKSMANRIFLE", Kills = 4}, -- not in kf
        [4] = {Name = "SVD Dragunov", SpawnCode = "WEAPON_SVDDM", Kills = 2},
        [5] = {Name = "AK-74", SpawnCode = "WEAPON_AK74DM", Kills = 4}, 
        [6] = {Name = "Bullpup Rifle", SpawnCode = "WEAPON_BULLPUPRIFLE", Kills = 5},
        [7] = {Name = "Marksman Rifle MK2", SpawnCode = "WEAPON_MARKSMANRIFLE_MK2", Kills = 3}, -- not in kf
        [8] = {Name = "Musket", SpawnCode = "WEAPON_MUSKET", Kills = 2},
        [9] = {Name = "Mosin Nagant", SpawnCode = "WEAPON_MOSINNAGANTDM", Kills = 5},
        [10] = {Name = "Knife", SpawnCode = "WEAPON_KNIFE", Kills = 1},
    },
    ["Group 4"] = {
        [1] = {Name = "Pistol", SpawnCode = "WEAPON_PISTOL", Kills = 3}, -- not in kf
        [2] = {Name = "Glock 17", SpawnCode = "WEAPON_GLOCK17DM", Kills = 3},
        [3] = {Name = "AK-74 Gold", SpawnCode = "WEAPON_AK74GOLDDM", Kills = 4},
        [4] = {Name = "Mosin Nagant", SpawnCode = "WEAPON_MOSINNAGANTDM", Kills = 5},
        [5] = {Name = "Spar-16", SpawnCode = "WEAPON_SPAR16DM", Kills = 4}, 
        [6] = {Name = "Special Carbine", SpawnCode = "WEAPON_SPECIALCARBINE", Kills = 5},
        [7] = {Name = "Sniper Rifle", SpawnCode = "WEAPON_SNIPERRIFLE", Kills = 3}, -- not in kf
        [8] = {Name = "Musket", SpawnCode = "WEAPON_MUSKET", Kills = 2},
        [9] = {Name = "Heavy Revolver", SpawnCode = "WEAPON_HEAVYREVOLVER", Kills = 5},
        [10] = {Name = "Knife", SpawnCode = "WEAPON_KNIFE", Kills = 1},
    },
}
gunGameLocation = {}
currentKills = 0
currentDeaths = 0
currentGroup = 0
maxWeaponLvl = 0
previousGroup = 0
currentWeaponIndex = 1
currentGameStarting = false
gunGameCurrents = {
    -- Weapon = spawnCode
    -- Idex = wepIndex
    -- Kills = killsLeft
}
gunGamePlayers = {

}


RegisterNetEvent("gunGameJoinGamePhase")
AddEventHandler("gunGameJoinGamePhase", function(phase, currentMap, Group)
    if phase == "Voting" then
    elseif phase == "Playing" then
        DoScreenFadeIn(500)
        gunGameLocation = gunGameConfig.locations[currentMap]
        playingGunGame = true
        currentGroup = Group
        gunGameSpawn()
    end
end)

RegisterNetEvent("gunGameStartGamePhase")
AddEventHandler("gunGameStartGamePhase", function(phase, currentMap, Group)
    if phase == "Playing" then
        RemoveAllPedWeapons(PlayerPedId(), true)
        gunGameLocation = gunGameConfig.locations[currentMap]
        playingGunGame = true
        currentGroup = Group
        if currentGroup ~= 0 then
            clientInfo = {
                currentWep = currentWeaponIndex,
                KillStr = currentWeaponIndex.."/"..#gunGameWeapons[currentGroup],
            }
        else
            clientInfo = {
                currentWep = currentWeaponIndex,
                KillStr = "1/10",
            }
        end
        TriggerServerEvent("DM-GunGame:Module:Update", clientInfo)
        gunGameSpawn()
        DoScreenFadeIn(900)
        currentGameStarting = true
        FreezeEntityPosition(PlayerPedId(), true)
        gameEnd = false
        TriggerEvent("cS.Countdown", 0, 195, 255, 5, true)
        Wait(5000)
        currentGameStarting = false
        FreezeEntityPosition(PlayerPedId(), false)
    end
end)


Citizen.CreateThread(function()
    while true do
        if currentGameStarting and SelectedZone == "gunGame" then
            DisablePlayerFiring(PlayerPedId(), true)
        end
        Wait(1)
    end
end)


-- RegisterCommand("a", function()
--     currentKills = currentKills + 1
--     gunGameCurrents.Kills = gunGameCurrents.Kills - 1

--     if currentGroup ~= 0 then
--         print(currentWeaponIndex, #gunGameWeapons[currentGroup], gunGameCurrents.Kills, gameEnd, currentWeaponIndex == #gunGameWeapons[currentGroup], gunGameCurrents.Kills == 0)
--         if currentWeaponIndex == #gunGameWeapons[currentGroup] and gunGameCurrents.Kills == 0 then
--             TriggerServerEvent("DM-GunGame:Module:Won")
--             gameEnd = true
--             return
--         end
--     end
--     if gunGameCurrents.Kills == 0 and not gameEnd then
--         RemoveAllPedWeapons(PlayerPedId(), true)
--         weaponUpgraded()
--     end
-- end)

RegisterCommand("die", function() die() end)
RegisterCommand("suicide", function() die() end)
RegisterCommand("kill", function() die() end)

function die()
    SetEntityHealth(PlayerPedId(), 0)
end


-- RegisterCommand("fullDebug", function()
--     print("^1CG: " ..currentGroup)
--     print("^1CWI: " ..currentWeaponIndex)
--     print("^1CWSC: " ..gunGameWeapons[currentGroup][currentWeaponIndex]["SpawnCode"])
--     print("^1CWN: " ..gunGameWeapons[currentGroup][currentWeaponIndex]["Name"])
-- end)

function gunGameSpawn()
    gunGameCurrents.Weapon = gunGameWeapons[currentGroup][currentWeaponIndex]["Name"]
    gunGameCurrents.Idex = currentWeaponIndex
    gunGameCurrents.Kills = gunGameWeapons[currentGroup][currentWeaponIndex]["Kills"]
    GiveWeaponToPed(PlayerPedId(), gunGameWeapons[currentGroup][currentWeaponIndex]["SpawnCode"], globalWeaponList[gunGameWeapons[currentGroup][currentWeaponIndex]["SpawnCode"]][4], false, true)
    Draw_Native_Notify("Recieved ~g~".. gunGameCurrents.Weapon)

    --- // Locations Randomised \\ --
    RandomLoc = math.random(1, #gunGameLocation)
    x,y,z = table.unpack(gunGameLocation[RandomLoc])
    SetEntityCoords(PlayerPedId(), x,y,z)
end

function gunGameRespawn()
    GiveWeaponToPed(PlayerPedId(), gunGameWeapons[currentGroup][currentWeaponIndex]["SpawnCode"], globalWeaponList[gunGameWeapons[currentGroup][currentWeaponIndex]["SpawnCode"]][4], false, true)
    Draw_Native_Notify("Recieved ~g~".. gunGameCurrents.Weapon)

    --- // Locations Randomised \\ --
    RandomLoc = math.random(1, #gunGameLocation)
    x,y,z = table.unpack(gunGameLocation[RandomLoc])
    SetEntityCoords(PlayerPedId(), x,y,z)
end

function weaponUpgraded()
    currentWeaponIndex = currentWeaponIndex + 1
    -- print(gunGameWeapons, currentGroup, currentWeaponIndex)
    gunGameCurrents.Weapon = gunGameWeapons[currentGroup][currentWeaponIndex]["Name"]
    gunGameCurrents.Idex = currentWeaponIndex
    gunGameCurrents.Kills = gunGameWeapons[currentGroup][currentWeaponIndex]["Kills"]
    GiveWeaponToPed(PlayerPedId(), gunGameWeapons[currentGroup][currentWeaponIndex]["SpawnCode"], 250, false, true)
    Draw_Native_Notify("Recieved ~g~".. gunGameCurrents.Weapon)

    clientInfo = {
        currentWep = currentWeaponIndex,
        KillStr = currentWeaponIndex.."/"..#gunGameWeapons[currentGroup],
    }

    TriggerServerEvent("DM-GunGame:Module:Update", clientInfo)
    Citizen.CreateThread(function()
        local ScaleForm = RequestScaleformMovie("mp_big_message_freemode")
        local ShowMessage = true
        while not HasScaleformMovieLoaded(ScaleForm) do
            Citizen.Wait(0)
        end
        SetTimeout(3500, function()
            ShowMessage = false
        end)
        while HasScaleformMovieLoaded(ScaleForm) do
            Citizen.Wait(0)
            if ShowMessage and not gameEnd then
                BeginScaleformMovieMethod(ScaleForm, "SHOW_SHARD_WASTED_MP_MESSAGE")
                PushScaleformMovieFunctionParameterString("NEW WEAPON [~r~"..gunGameWeapons[currentGroup][currentWeaponIndex]["Kills"].." Kills~w~]")
                PushScaleformMovieFunctionParameterString("Get "..gunGameWeapons[currentGroup][currentWeaponIndex]["Kills"].. " Kills with ".. gunGameWeapons[currentGroup][currentWeaponIndex]["Name"].. " to upgrade your gun.")
                PushScaleformMovieMethodParameterInt(5)
                EndScaleformMovieMethod()
                DrawScaleformMovieFullscreen(ScaleForm, 255, 255, 255, 255)
            else
                break;
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        if SelectedZone == "gunGame" then
            if gunGamePlayers[1] ~= nil then
                DrawTimerBar("~y~1st: ".. gunGamePlayers[1].Name, gunGamePlayers[1].currentWep, 6)
            else
                DrawTimerBar("~y~1st: N/A", 0, 6)
            end

            if gunGamePlayers[2] ~= nil then
                DrawTimerBar("~s~2nd: ".. gunGamePlayers[2].Name, gunGamePlayers[2].currentWep, 5)
            else
                DrawTimerBar("~s~2nd: N/A", 0, 5)
            end

            if gunGamePlayers[3] ~= nil then
                DrawTimerBar("~o~3rd: ".. gunGamePlayers[3].Name, gunGamePlayers[3].currentWep, 4)
            else
                DrawTimerBar("~o~3rd: N/A", 0, 4)
            end

            if currentGroup ~= 0 then
                DrawTimerBar("~y~WEAPON LEVEL:", currentWeaponIndex.."/"..#gunGameWeapons[currentGroup], 3)
            else
                DrawTimerBar("~y~Phase: ", "VOTING", 3)
            end
            DrawTimerBar("KILLS LEFT:", (gunGameCurrents.Kills or 0), 2)
            DrawTimerBar("~g~TIME PLAYED:", serverReturnedTimeLeft, 1)
        end
        Wait(1)
    end
end)

function DMclient.updateGunGameKills(type)
    if type == "+" then
        currentKills = currentKills + 1
        gunGameCurrents.Kills = gunGameCurrents.Kills - 1
    
        if currentGroup ~= 0 then
            --print(currentWeaponIndex, #gunGameWeapons[currentGroup], gunGameCurrents.Kills)
            if currentWeaponIndex == #gunGameWeapons[currentGroup] and gunGameCurrents.Kills == 0 then
                TriggerServerEvent("DM-GunGame:Module:Won")
                gameEnd = true
                return
            end
        end
        if gunGameCurrents.Kills == 0 and not gameEnd then
            RemoveAllPedWeapons(PlayerPedId(), true)
            weaponUpgraded()
        end
    elseif type == "-" then
        currentKills = currentKills - 1
        gunGameCurrents.Kills = gunGameCurrents.Kills + 1
        if gunGameCurrents.Kills == gunGameWeapons[currentGroup][currentWeaponIndex]["Kills"] and not currentWeaponIndex == 1 then
            weaponDegraded()
        end
    end
end

function DMclient.updateGunGameDeaths(type)
    if type == "+" then
        currentDeaths = currentDeaths + 1
    end
end

RegisterNetEvent("gunGameUpdateLeaderboard")
AddEventHandler("gunGameUpdateLeaderboard", function(playerInfo)
    gunGamePlayers = playerInfo
    if #gunGamePlayers > 1 then 
        table.sort(gunGamePlayers, function (k1, k2) return k1.currentWep > k2.currentWep end )
    end
end)

RegisterNetEvent("gunGameUpdateTimer")
    AddEventHandler("gunGameUpdateTimer", function(gunGameTimer)
    serverReturnedTimeLeft = gunGameTimer
end)


Citizen.CreateThread(function()
	local blips = {}
	local currentPlayer = PlayerId()
	while true do
		Wait(100)
        if SelectedZone == "gunGame" then
            for _, player in ipairs(GetActivePlayers()) do
                if player ~= currentPlayer and NetworkIsPlayerActive(player) then
                    local playerPed = GetPlayerPed(player)
                    local playerName = GetPlayerName(player)
                    RemoveBlip(blips[player])
                    local new_blip = AddBlipForEntity(playerPed)
                    SetBlipNameToPlayerName(new_blip, player)
                    SetBlipColour(new_blip, 1)
                    SetBlipCategory(new_blip, 0)
                    SetBlipScale(new_blip, 0.85)
                    blips[player] = new_blip
                end
            end
        end
	end
end)

RegisterCommand("gunGameFinish", function()
    TriggerEvent("gunGameFinish")
end)

RegisterNetEvent("gunGameResetGame(TimeUp)")
AddEventHandler("gunGameResetGame(TimeUp)", function()
    
    if currentGroup ~= 0 then
        clientInfo = {
            currentWep = currentWeaponIndex,
            KillStr = currentWeaponIndex.."/"..#gunGameWeapons[currentGroup],
        }
    else
        clientInfo = {
            currentWep = currentWeaponIndex,
            KillStr = "1/10",
        }
    end
    TriggerServerEvent("DM-GunGame:Module:Update", clientInfo)
    FinishGame()

    previousGroup = currentGroup
    gunGameLocation = {}
    currentKills = 0
    currentDeaths = 0
    currentGroup = 0
    currentWeaponIndex = 1

    --TriggerServerEvent("DM-GunGame:Module:Won")
end)


function FinishGame()
    if SelectedZone == "gunGame" then
        currentGameStarting = true
        if gunGamePlayers[1] ~= nil then
            _initialText = { --first slide. Consists of 3 text lines.
                missionTextLabel = "~y~"..gunGamePlayers[1].Name.."~s~", 
                passFailTextLabel = "Placed 1st",
                messageLabel = "",
            }
        else
            _initialText = { --first slide. Consists of 3 text lines.
            missionTextLabel = "~y~No-One~s~", 
            passFailTextLabel = "Placed 1st",
            messageLabel = "",
        }
        end
        local _table = { --second slide. You can add as many "stats" as you want. They will appear from botton to top, so keep that in mind.
            {stat = "Kills: ", value = "~w~"..currentKills},
            {stat = "Deaths: ", value = "~w~"..currentDeaths},
            {stat = "~y~Weapon Level: ", value = "~w~"..currentWeaponIndex.."/"..#gunGameWeapons[currentGroup]..""},
        }
        local _money = { --third slide. Incremental money. It will start from startMoney and increment to finishMoney. top and bottom text appear above/below the money string.
            -- startMoney = 3000,
            -- finishMoney = 53000,
            -- topText = "",
            -- bottomText = "",
            -- rightHandStat = "woah",
            -- rightHandStatIcon = 2, --0 or 1 = checked, 2 = X, 3 = no icon
        }
        local _xp = { --fourth and final slide. XP Bar slide. Will start with currentRank and a xp bar filled with (xpBeforeGain - minLevelXP) and will add xpGained. If you rank up, it goes to "Level Up" slide.
            xpGained = 0,
            xpBeforeGain = 0,
            minLevelXP = 0,
            maxLevelXP = 0,
            currentRank = 0,
            nextRank = 0,
            rankTextSmall = "LEVEL UP.",
            rankTextBig = "~b~Nice.~s~",
        }
        TriggerEvent("cS.HeistFinale", _initialText, _table, _money, _xp, 6, true)
        Wait(6500)
        TriggerEvent("toggleVote:GG")
        Wait(13000)
        DoScreenFadeOut(900)
        TriggerEvent("toggleVote:GG")
    end
end
