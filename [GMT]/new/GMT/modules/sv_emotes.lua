RegisterNetEvent('GMT:sendSharedEmoteRequest')
AddEventHandler('GMT:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('GMT:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('GMT:receiveSharedEmoteRequest')
AddEventHandler('GMT:receiveSharedEmoteRequest', function(i, a)
    local source = source
    TriggerClientEvent('GMT:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('GMT:receiveSharedEmoteRequest', source, a)
end)

local shavedPlayers = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(shavedPlayers) do
            if shavedPlayers[k] then
                if shavedPlayers[k].cooldown > 0 then
                    shavedPlayers[k].cooldown = shavedPlayers[k].cooldown - 1
                else
                    shavedPlayers[k] = nil
                end
            end
        end
    end
end)

AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = GMT.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('GMT:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function GMT.ShaveHead(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.getInventoryItemAmount(user_id, 'Shaver') >= 1 then
        GMTclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                GMTclient.globalSurrenderring(nplayer,{},function(surrendering)
                    if surrendering then
                        GMT.tryGetInventoryItem(user_id, 'Shaver', 1)
                        TriggerClientEvent('GMT:startShavingPlayer', source, nplayer)
                        TriggerClientEvent('GMT:startBeingShaved', nplayer, source)
                        TriggerClientEvent('GMT:playDelayedShave', -1, source)
                        shavedPlayers[GMT.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        GMTclient.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                GMTclient.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end
