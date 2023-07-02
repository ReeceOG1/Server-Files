local a = false
local b = true
RegisterCommand("togglekillfeed",function()
        if not a then
            b = not b
            if b then
                tLUNA.notify("~g~Killfeed is now enabled")
                SendNUIMessage({type = "killFeedEnable"})
            else
                tLUNA.notify("~r~Killfeed is now disabled")
                SendNUIMessage({type = "killFeedDisable"})
            end
        end
    end)
RegisterNetEvent("LUNA:showHUD",function(c)
        a = not c
        if b then
            if c then
                SendNUIMessage({type = "killFeedEnable"})
            else
                SendNUIMessage({type = "killFeedDisable"})
            end
        end
    end)
RegisterNetEvent("LUNA:newKillFeed",function(killer, victim, weapon, suicide, range, victimGroup, killerGroup)
        if GetIsLoadingScreenActive() then
            return
        end
        local category = "other"
        local playername = GetPlayerName(tLUNA.getPlayerId())
        if victim == playername or killer == playername then
            category = "self"
        end
        SendNUIMessage(
            {type = "addKill",
            victim = victim,
            killer = killer,
            weapon = weapon,
            suicide = suicide,
            victimGroup = victimGroup,
            killerGroup = killerGroup,
            range = range,
            uuid = tLUNA.generateUUID("kill", 10, "alphabet"),
            category = category})
    end)