RegisterServerEvent("GMT:stretcherAttachPlayer")
AddEventHandler('GMT:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('GMT:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("GMT:toggleAmbulanceDoors")
AddEventHandler('GMT:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('GMT:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("GMT:updateHasStretcherInsideDecor")
AddEventHandler('GMT:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('GMT:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("GMT:updateStretcherLocation")
AddEventHandler('GMT:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('GMT:GMT:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("GMT:removeStretcher")
AddEventHandler('GMT:removeStretcher', function(stretcher)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('GMT:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("GMT:forcePlayerOnToStretcher")
AddEventHandler('GMT:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('GMT:forcePlayerOnToStretcher', id, stretcher)
    end
end)