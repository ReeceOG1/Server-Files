RegisterCommand("Delgun", function(source, args)
    local source = source 
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, "admin.tickets") then 
        TriggerClientEvent('LUNA:EntityCleanupGun', source)
    end
end)