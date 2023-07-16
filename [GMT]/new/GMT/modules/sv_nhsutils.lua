local bodyBags = {}

RegisterServerEvent("GMT:requestBodyBag")
AddEventHandler('GMT:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('GMT:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("GMT:removeBodybag")
AddEventHandler('GMT:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = GMT.getUserId(source)
    TriggerClientEvent('GMT:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("GMT:playNhsSound")
AddEventHandler('GMT:playNhsSound', function(sound)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('GMT:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        TriggerEvent("GMT:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Play NHS Sound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("GMT:attachLifepakServer")
AddEventHandler('GMT:attachLifepakServer', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        GMTclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = GMT.getUserId(nplayer)
            if nuser_id ~= nil then
                GMTclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('GMT:attachLifepak', source, in_coma, nuser_id, nplayer, GetPlayerName(nplayer))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                GMTclient.notify(source, {"There is no player nearby"})
            end
        end)
    else
        TriggerEvent("GMT:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Attack Lifepak')
    end
end)


RegisterServerEvent("GMT:finishRevive")
AddEventHandler('GMT:finishRevive', function(permid)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then 
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and v.permid == permid then
                TriggerClientEvent('GMT:returnRevive', source)
                GMT.giveBankMoney(user_id, 5000)
                GMTclient.notify(source, {"~g~You have been paid £5,000 for reviving this person."})
                lifePaksConnected[k] = nil
                Wait(15000)
                GMTclient.RevivePlayer(GMT.getUserSource(permid), {})
            end
        end
    else
        TriggerEvent("GMT:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger Finish Revive')
    end
end)


RegisterServerEvent("GMT:nhsRevive") -- nhs radial revive
AddEventHandler('GMT:nhsRevive', function(playersrc)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        GMTclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('GMT:beginRevive', source, in_coma, GMT.getUserId(playersrc), playersrc, GetPlayerName(playersrc))
                lifePaksConnected[user_id] = {permid = GMT.getUserId(playersrc)} 
            end
        end)
    else
        TriggerEvent("GMT:acBan", user_id, 11, GetPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

local playersInCPR = {}
RegisterServerEvent("GMT:attemptCPR")
AddEventHandler('GMT:attemptCPR', function(playersrc)
    local source = source
    local user_id = GMT.getUserId(source)
    GMTclient.getNearestPlayers(source,{15},function(nplayers)
        if nplayers[playersrc] then
            if GetEntityHealth(GetPlayerPed(playersrc)) > 102 then
                GMTclient.notify(source, {"This person already healthy."})
            else
                playersInCPR[user_id] = true
                TriggerClientEvent('GMT:attemptCPR', source)
                Wait(15000)
                if playersInCPR[user_id] then
                    local cprChance = math.random(1,5)
                    if cprChance == 1 then
                        GMTclient.RevivePlayer(playersrc, {})
                        GMTclient.notify(playersrc, {"~b~Your life has been saved."})
                        GMTclient.notify(source, {"~b~You have saved this Person's Life."})
                    else
                        GMTclient.notify(source, {'Failed to CPR.'})
                    end
                    playersInCPR[user_id] = nil
                    TriggerClientEvent('GMT:cancelCPRAttempt', source)
                end
            end
        else
            GMTclient.notify(source, {"Player not found."})
        end
    end)
end)

RegisterServerEvent("GMT:cancelCPRAttempt")
AddEventHandler('GMT:cancelCPRAttempt', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if playersInCPR[user_id] then
        playersInCPR[user_id] = nil
        TriggerClientEvent('GMT:cancelCPRAttempt', source)
    end
end)

RegisterServerEvent("GMT:syncWheelchairPosition")
AddEventHandler('GMT:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = GMT.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("GMT:wheelchairAttachPlayer")
AddEventHandler('GMT:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = GMT.getUserId(source)
    TriggerClientEvent('GMT:wheelchairAttachPlayer', -1, entity, source)
end)