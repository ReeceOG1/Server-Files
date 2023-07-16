RegisterNetEvent('GMT:checkTutorial')
AddEventHandler('GMT:checkTutorial', function()
    local source = source
    local user_id = GMT.getUserId(source)
    local discord_id = "Coming Soon"
    if not GMT.hasGroup(user_id, 'TutorialDone') then
        TriggerClientEvent('GMT:playTutorial', source)
        tGMT.setBucket(source, user_id)
        TriggerClientEvent('GMT:setBucket', source, user_id)
        tGMT.sendWebhook('tutorial', 'GMT Tutorial Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player Discord: **"..discord_id.."**\n> Player PermID: **"..user_id.."**\n> Info: **Started the Tutorial**")
    end
end)

RegisterNetEvent('GMT:setCompletedTutorial')
AddEventHandler('GMT:setCompletedTutorial', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if not GMT.hasGroup(user_id, 'TutorialDone') then
        GMT.addUserGroup(user_id, 'TutorialDone')
        tGMT.setBucket(source, 0)
        TriggerClientEvent('GMT:setBucket', source, 0)
    end
end)