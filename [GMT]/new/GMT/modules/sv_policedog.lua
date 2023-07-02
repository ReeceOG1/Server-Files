RegisterCommand('k9', function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('GMT:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('GMT:policeDogAttack', source)
    end
end)

RegisterNetEvent("GMT:serverDogAttack")
AddEventHandler("GMT:serverDogAttack", function(player)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('GMT:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("GMT:policeDogSniffPlayer")
AddEventHandler("GMT:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = GMT.getUserId(playerSrc)
        local cdata = GMT.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('GMT:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)

RegisterNetEvent("GMT:performDogLog")
AddEventHandler("GMT:performDogLog", function(text)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'K9 Trained') then
        tGMT.sendWebhook('police-k9', 'GMT Police Dog Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)