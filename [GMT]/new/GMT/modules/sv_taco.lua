local tacoDrivers = {}

RegisterNetEvent('GMT:addTacoSeller')
AddEventHandler('GMT:addTacoSeller', function(coords, price)
    local source = source
    local user_id = GMT.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('GMT:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('GMT:RemoveMeFromTacoPositions')
AddEventHandler('GMT:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = GMT.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('GMT:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('GMT:payTacoSeller')
AddEventHandler('GMT:payTacoSeller', function(id)
    local source = source
    local user_id = GMT.getUserId(source)
    if tacoDrivers[id] then
        if GMT.getInventoryWeight(user_id)+1 <= GMT.getInventoryMaxWeight(user_id) then
            if GMT.tryFullPayment(user_id,15000) then
                GMT.giveInventoryItem(user_id, 'Taco', 1)
                GMT.giveBankMoney(id, 15000)
                TriggerClientEvent("gmt:PlaySound", source, "money")
            else
                GMTclient.notify(source, {'You do not have enough money.'})
            end
        else
            GMTclient.notify(source, {'Not enough inventory space.'})
        end
    end
end)