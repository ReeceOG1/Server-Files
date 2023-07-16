local spikes = 0
local speedzones = 0

RegisterNetEvent("GMT:placeSpike")
AddEventHandler("GMT:placeSpike", function(heading, coords)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('GMT:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("GMT:removeSpike")
AddEventHandler("GMT:removeSpike", function(entity)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('GMT:deleteSpike', -1, entity)
        TriggerClientEvent("GMT:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("GMT:requestSceneObjectDelete")
AddEventHandler("GMT:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') or GMT.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent("GMT:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("GMT:createSpeedZone")
AddEventHandler("GMT:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') or GMT.hasPermission(user_id, 'hmp.menu') then
        speedzones = speedzones + 1
        TriggerClientEvent('GMT:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("GMT:deleteSpeedZone")
AddEventHandler("GMT:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') or GMT.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('GMT:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

