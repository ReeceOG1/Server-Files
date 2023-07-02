local a = {
    ["burger"] = {
        [1] = 'bun',
        [2] = 'lettuce',
        [3] = 'tomato',
        [4] = 'onion',
        [5] = 'cheese',
        [6] = 'beef_patty',
        [7] = 'bbq',
    }
}

local cookingStages = {}
RegisterNetEvent('GMT:requestStartCooking')
AddEventHandler('GMT:requestStartCooking', function(recipe)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'Burger Shot Cook') then
        for k,v in pairs(a) do
            if k == recipe then
                cookingStages[user_id] = 1
                TriggerClientEvent('GMT:beginCooking', source, recipe)
                TriggerClientEvent('GMT:cookingInstruction', source, v[cookingStages[user_id]])
            end
        end
    else
        GMTclient.notify(source, {"You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)

RegisterNetEvent('GMT:pickupCookingIngredient')
AddEventHandler('GMT:pickupCookingIngredient', function(recipe, ingredient)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'Burger Shot Cook') then
        if ingredient == 'bbq' and cookingStages[user_id] == 7 then
            cookingStages[user_id] = nil
            TriggerClientEvent('GMT:finishedCooking', source)
            GMT.giveBankMoney(user_id, grindBoost*4000)
        else
            for k,v in pairs(a) do
                if k == recipe then
                    cookingStages[user_id] = cookingStages[user_id] + 1
                    TriggerClientEvent('GMT:cookingInstruction', source, v[cookingStages[user_id]])
                end
            end
        end
    else
        GMTclient.notify(source, {"You aren't clocked on as a Burger Shot Cook, head to cityhall to sign up."})
    end
end)