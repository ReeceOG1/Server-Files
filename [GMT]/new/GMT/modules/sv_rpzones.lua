local rpZones = {}
local numRP = 0
RegisterServerEvent("GMT:createRPZone")
AddEventHandler("GMT:createRPZone", function(a)
	local source = source
	local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'group.remove') then
        numRP = numRP + 1
        a['uuid'] = numRP
        rpZones[numRP] = a
        TriggerClientEvent('GMT:createRPZone', -1, a)
    end
end)

RegisterServerEvent("GMT:removeRPZone")
AddEventHandler("GMT:removeRPZone", function(b)
	local source = source
	local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'group.remove') then
        if next(rpZones) then
            for k,v in pairs(rpZones) do
                if v.uuid == b then
                    rpZones[k] = nil
                    TriggerClientEvent('GMT:removeRPZone', -1, b)
                end
            end
        end
    end
end)

AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(rpZones) do
            TriggerClientEvent('GMT:createRPZone', source, rpZones)
        end
    end
end)
