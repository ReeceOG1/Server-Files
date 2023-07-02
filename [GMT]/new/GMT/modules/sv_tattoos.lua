RegisterServerEvent('GMT:saveTattoos')
AddEventHandler('GMT:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.tryFullPayment(user_id, price) then
        GMT.setUData(user_id, "GMT:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('GMT:getPlayerTattoos')
AddEventHandler('GMT:getPlayerTattoos', function()
    local source = source
    local user_id = GMT.getUserId(source)
    GMT.getUData(user_id, "GMT:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent('GMT:setTattoos', source, json.decode(data))
        end
    end)
end)
