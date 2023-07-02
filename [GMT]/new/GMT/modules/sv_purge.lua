local purgeLB = {[1] = {"gmt", 10}}

RegisterServerEvent('GMT:getTopFraggers')
AddEventHandler('GMT:getTopFraggers', function()
    local source = source
    local user_id = GMT.getUserId(source)
    TriggerClientEvent('GMT:gotTopFraggers', source, purgeLB)
end)

RegisterCommand('addkill', function()
    TriggerClientEvent('GMT:incrementPurgeKills', -1)
end)

RegisterCommand('purgespawn', function()
    TriggerClientEvent('GMT:purgeSpawnClient', -1)
end)