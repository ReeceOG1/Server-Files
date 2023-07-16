netObjects = {}

RegisterServerEvent("GMT:spawnVehicleCallback")
AddEventHandler('GMT:spawnVehicleCallback', function(a, b)
    netObjects[b] = {source = GMT.getUserSource(a), id = a, name = GetPlayerName(GMT.getUserSource(a))}
end)

RegisterServerEvent("GMT:delGunDelete")
AddEventHandler("GMT:delGunDelete", function(object)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("GMT:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("GMT:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..'~w~. Temp ID: ~b~'..netObjects[object].source..'~w~.\nPerm ID: ~b~'..netObjects[object].id..'~w~.')
        end
    end
end)