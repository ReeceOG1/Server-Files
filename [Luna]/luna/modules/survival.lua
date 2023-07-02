local cfg = module("cfg/survival")
local lang = LUNA.lang

-- api

function tLUNA.respawnPlayer()
    exports.spawnmanager:forceRespawn()
    exports.spawnmanager:spawnPlayer()
    playerCanRespawn = false 
    DeathString = ""
    secondsTilBleedout = 60
    TriggerEvent("LUNA:FixClient")
    local ped = GetPlayerPed(-1)
    tLUNA.reviveComa()
end


-- tunnel api (expose some functions to clients)


-- tasks


-- handlers

-- init values
AddEventHandler("LUNA:playerJoin", function(user_id, source, name, last_login)
    local data = LUNA.getUserDataTable(user_id)
end)

-- add survival progress bars on spawn
AddEventHandler("LUNA:playerSpawn", function(user_id, source, first_spawn)
    local data = LUNA.getUserDataTable(user_id)
    LUNAclient.setPolice(source, {cfg.police})
    LUNAclient.setFriendlyFire(source, {cfg.pvp})
end)

-- EMERGENCY

---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil then
        LUNAclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = LUNA.getUserId(nplayer)
            if nuser_id ~= nil then
                LUNAclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if LUNA.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            LUNAclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                LUNAclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        LUNAclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                LUNAclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

-- add choices to the main menu (emergency)
LUNA.registerMenuBuilder("main", function(add, data)
    local user_id = LUNA.getUserId(data.player)
    if user_id ~= nil then
        local choices = {}
        if LUNA.hasPermission(user_id, "nhs.menu") then
            choices[lang.emergency.menu.revive.title()] = choice_revive
        end

        add(choices)
    end
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerID, deathData)
    local killer = GetPlayerFromServerId(killerID)
    local killerName = GetPlayerName(killer)

    TriggerEvent('onPlayerKilled', killerName)
end)


RegisterNetEvent("LUNA:KillLogsCommitedSuicide")
AddEventHandler('LUNA:KillLogsCommitedSuicide', function(killed)
    local source = source
    local name = GetPlayerName(killed)
    local user_id = LUNA.getUserId(killed)
    local KillEmbed = {
        {
            ["color"] = "16777215",
            ["title"] = "**Player Name: **"..name.."\n**Player Perm ID:** "..user_id.."\n**Death Reason: ** Committed Suicide",
            ["description"] = "",
            ["footer"] = {
                ["text"] = os.date("%x %X %p"),
    
            }
        }
    }
    PerformHttpRequest("https://ptb.discord.com/api/webhooks/1110524510584713266/wqgGJke7kWm6vGKgEHNeLGaedVcCCwN189BJ7Der9I5N_E9a71i2rVbdmin5mk7W8nHz", function(err, text, headers) end, "POST", json.encode({username = "Kill Logs", embeds = KillEmbed}), { ["Content-Type"] = "application/json" })
end)


RegisterNetEvent("LUNA:KillLogsKilledBy")
AddEventHandler('LUNA:KillLogsKilledBy', function(killed, killer, weapon)
    local source = source
    local name = GetPlayerName(killed)
    local user_id = LUNA.getUserId(killed)
    local killername = GetPlayerName(killer)
    local killerpermid = LUNA.getUserId(killer)
 
    local KillEmbed = {
        {
            ["color"] = "16777215",
            ["title"] = "**Player Name: **"..name.."\n**Player Perm ID:** "..user_id.."\n**Killer Name: **"..killername.."\n**Killer Perm ID: **"..killerpermid.."**\nWeapon** "..weapon,
            ["description"] = "",
            ["footer"] = {
                ["text"] = os.date("%x %X %p"),
    
            }
        }
    }
    PerformHttpRequest("https://ptb.discord.com/api/webhooks/1110524510584713266/wqgGJke7kWm6vGKgEHNeLGaedVcCCwN189BJ7Der9I5N_E9a71i2rVbdmin5mk7W8nHz", function(err, text, headers) end, "POST", json.encode({username = "Kill Logs", embeds = KillEmbed}), { ["Content-Type"] = "application/json" })
TriggerClientEvent('onPlayerKilled', killer, name)

end)



