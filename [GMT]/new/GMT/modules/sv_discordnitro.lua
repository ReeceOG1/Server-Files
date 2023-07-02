RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("GMT:spawnNitroBMX", source)
    else
        if GMT.checkForRole(user_id, '1075186598125252730') then
            TriggerClientEvent("GMT:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    GMTclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("GMT:spawnMoped", source)
        end
    end)
end)