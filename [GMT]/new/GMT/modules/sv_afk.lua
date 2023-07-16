function getPlayerFaction(user_id)
    if GMT.hasPermission(user_id, 'police.armoury') then
        return 'pd'
    elseif GMT.hasPermission(user_id, 'nhs.menu') then
        return 'nhs'
    elseif GMT.hasPermission(user_id, 'hmp.menu') then
        return 'hmp'
    elseif GMT.hasPermission(user_id, 'lfb.onduty.permission') then
        return 'lfb'
    end
    return nil
end

RegisterServerEvent('GMT:factionAfkAlert')
AddEventHandler('GMT:factionAfkAlert', function(text)
    local source = source
    local user_id = GMT.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tGMT.sendWebhook(getPlayerFaction(user_id)..'-afk', 'GMT AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('GMT:setNoLongerAFK')
AddEventHandler('GMT:setNoLongerAFK', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        tGMT.sendWebhook(getPlayerFaction(user_id)..'-afk', 'GMT AFK Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('kick:AFK')
AddEventHandler('kick:AFK', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if not GMT.hasPermission(user_id, 'group.add') then
        DropPlayer(source, 'You have been kicked for being AFK for too long.')
    end
end)