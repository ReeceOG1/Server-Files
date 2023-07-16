RegisterNetEvent('adminAnnounce')
AddEventHandler('adminAnnounce', function(message)
    TriggerClientEvent('showAnnouncement', -1, message)
end)

RegisterServerEvent('checkPermissionAnnounceMenu')
AddEventHandler('checkPermissionAnnounceMenu', function()
    local user = LUNA.getUserId(source)
    if user then
        if LUNA.hasPermission(user, "dev.menu") then
            TriggerClientEvent('openAnnounceMenu', source)
        end
    end
end)

RegisterServerEvent('adminAnnouncePrompt')
AddEventHandler('adminAnnouncePrompt', function()
    local player = source
    if player and LUNA.hasPermission(player, "dev.menu") then
        -- Trigger the client event to open the announcement menu
        TriggerClientEvent('openAnnounceMenu', player)
    end
end)
