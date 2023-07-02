RegisterNetEvent('sendWardrobe')
AddEventHandler('sendWardrobe', function()
        user_id = LUNA.getUserId({source})
        if LUNA.hasGroup({user_id, 'vip'}) then 
        TriggerClientEvent('returnWardrobe', source, true)
    else
        TriggerClientEvent('returnWardrobe', source, false)
    end
end)