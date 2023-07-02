local flaggedVehicles = {}

AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if GMT.hasPermission(user_id, 'police.armoury') then
            TriggerClientEvent('GMT:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("GMT:flagVehicleAnpr")
AddEventHandler("GMT:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('GMT:setFlagVehicles', -1, flaggedVehicles)
    end
end)