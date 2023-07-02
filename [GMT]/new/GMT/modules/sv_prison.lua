MySQL.createCommand("GMT/get_prison_time","SELECT prison_time FROM gmt_prison WHERE user_id = @user_id")
MySQL.createCommand("GMT/set_prison_time","UPDATE gmt_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("GMT/add_prisoner", "INSERT IGNORE INTO gmt_prison SET user_id = @user_id")
MySQL.createCommand("GMT/get_current_prisoners", "SELECT * FROM gmt_prison WHERE prison_time > 0")
MySQL.createCommand("GMT/add_jail_stat","UPDATE gmt_police_hours SET total_player_jailed = (total_player_jailed+1) WHERE user_id = @user_id")

local cfg = module("cfg/cfg_prison")
local newDoors = {}
for k,v in pairs(cfg.doors) do
    for a,b in pairs(v) do
        newDoors[b.doorHash] = b
        newDoors[b.doorHash].currentState = 0
    end
end  
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}

local lastCellUsed = 0

AddEventHandler("playerJoining", function()
    local user_id = GMT.getUserId(source)
    MySQL.execute("GMT/add_prisoner", {user_id = user_id})
end)

AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("GMT/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('GMT:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('GMT:forcePlayerInPrison', source, true)
                    TriggerClientEvent('GMT:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('GMT:prisonUpdateClientTimer', source, prisontime[1].prison_time)
                    local prisonItemsTable = {}
                    for k,v in pairs(cfg.prisonItems) do
                        local item = math.random(1, #prisonItems)
                        prisonItemsTable[prisonItems[item]] = v
                    end
                    TriggerClientEvent('GMT:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
        TriggerClientEvent('GMT:prisonUpdateGuardNumber', -1, #GMT.getUsersByPermission('hmp.menu'))
        TriggerClientEvent('GMT:prisonSyncAllDoors', source, newDoors)
    end
end)

RegisterNetEvent("GMT:getNumOfNHSOnline")
AddEventHandler("GMT:getNumOfNHSOnline", function()
    local source = source
    local user_id = GMT.getUserId(source)
    MySQL.query("GMT/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('GMT:prisonSpawnInMedicalBay', source)
                GMTclient.RevivePlayer(source, {})
            else
                TriggerClientEvent('GMT:getNumberOfDocsOnline', source, #GMT.getUsersByPermission('nhs.menu'))
            end
        end
    end)
end)

RegisterServerEvent("GMT:prisonArrivedForJail")
AddEventHandler("GMT:prisonArrivedForJail", function()
    local source = source
    local user_id = GMT.getUserId(source)
    MySQL.query("GMT/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                tGMT.setBucket(source, 0)
                TriggerClientEvent('GMT:forcePlayerInPrison', source, true)
                TriggerClientEvent('GMT:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('GMT:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("GMT:prisonStartJob")
AddEventHandler("GMT:prisonStartJob", function(job)
    local source = source
    local user_id = GMT.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("GMT:prisonEndJob")
AddEventHandler("GMT:prisonEndJob", function(job)
    local source = source
    local user_id = GMT.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("GMT/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("GMT/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('GMT:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    GMTclient.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("GMT:jailPlayer")
AddEventHandler("GMT:jailPlayer", function(player)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') then
        GMTclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                GMTclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("GMT/get_prison_time", {user_id = GMT.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    GMT.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 0 and jailtime <= cfg.maxTimeNotGc then
                                            -- check if gc then compare jailtime to 
                                            -- maxTimeGc = 7200,
                                            MySQL.execute("GMT/set_prison_time", {user_id = GMT.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('GMT:prisonTransportWithBus', player, lastCellUsed+1)
                                            tGMT.setBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            TriggerClientEvent('GMT:prisonCreateItemAreas', player, prisonItemsTable)
                                            GMTclient.notify(source, {"~g~Jailed Player."})
                                            tGMT.sendWebhook('jail-player', 'GMT Jail Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..GetPlayerName(player).."**\n> Criminal PermID: **"..GMT.getUserId(player).."**\n> Criminal TempID: **"..player.."**\n> Duration: **"..math.floor(jailtime/60).." minutes**")
                                        else
                                            GMTclient.notify(source, {"Invalid time."})
                                        end
                                    end)
                                else
                                    GMTclient.notify(source, {"Player is already in prison."})
                                end
                            end
                        end)
                    else
                        GMTclient.notify(source, {"You must have the player handcuffed."})
                    end
                end)
            else
                GMTclient.notify(source, {"Player not found."})
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        MySQL.query("GMT/get_current_prisoners", {}, function(currentPrisoners)
            if #currentPrisoners > 0 then 
                for k,v in pairs(currentPrisoners) do
                    MySQL.execute("GMT/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                    if v.prison_time-1 == 0 and GMT.getUserSource(v.user_id) ~= nil then
                        TriggerClientEvent('GMT:prisonStopClientTimer', GMT.getUserSource(v.user_id))
                        TriggerClientEvent('GMT:prisonReleased', GMT.getUserSource(v.user_id))
                        TriggerClientEvent('GMT:forcePlayerInPrison', GMT.getUserSource(v.user_id), false)
                        GMTclient.setHandcuffed(GMT.getUserSource(v.user_id), {false})
                    end
                end
            end
        end)
        Citizen.Wait(1000)
    end
end)

RegisterCommand('unjail', function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.noclip') then
        GMT.prompt(source,"Enter Temp ID:","",function(source, player) 
            local player = tonumber(player)
            if player ~= nil then
                MySQL.execute("GMT/set_prison_time", {user_id = GMT.getUserId(player), prison_time = 0})
                TriggerClientEvent('GMT:prisonStopClientTimer', player)
                TriggerClientEvent('GMT:prisonReleased', player)
                TriggerClientEvent('GMT:forcePlayerInPrison', player, false)
                GMTclient.setHandcuffed(player, {false})
                GMTclient.notify(source, {"~g~Target will be released soon."})
            else
                GMTclient.notify(source, {"Invalid ID."})
            end
        end)
    end
end)


AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('GMT:prisonUpdateGuardNumber', -1, #GMT.getUsersByPermission('hmp.menu'))
    end
end)

local currentLockdown = false
RegisterServerEvent("GMT:prisonToggleLockdown")
AddEventHandler("GMT:prisonToggleLockdown", function(lockdownState)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'dev.menu') then -- change this to the hmp hq permission
        currentLockdown = lockdownState
        if currentLockdown then
            TriggerClientEvent('GMT:prisonSetAllDoorStates', -1, 1)
        else
            TriggerClientEvent('GMT:prisonSetAllDoorStates', -1)
        end
    end
end)

RegisterServerEvent("GMT:prisonSetDoorState")
AddEventHandler("GMT:prisonSetDoorState", function(doorHash, state)
    local source = source
    local user_id = GMT.getUserId(source)
    TriggerClientEvent('GMT:prisonSyncDoor', -1, doorHash, state)
end)

RegisterServerEvent("GMT:enterPrisonAreaSyncDoors")
AddEventHandler("GMT:enterPrisonAreaSyncDoors", function()
    local source = source
    local user_id = GMT.getUserId(source)
    TriggerClientEvent('GMT:prisonAreaSyncDoors', source, doors)
end)

-- on pickup 
-- GMT:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- GMT:requestPrisonerData