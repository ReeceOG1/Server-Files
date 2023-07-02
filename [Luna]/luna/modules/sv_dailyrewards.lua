RegisterServerEvent('LUNA:hoursReward')
AddEventHandler('LUNA:hoursReward', function(reward)
    local source = source
    local user_id = LUNA.getUserId(source)
    local hours = math.ceil(LUNA.getUserDataTable(user_id).PlayerTime/60) or 0

    if hours < reward then LUNAclient.notify(source,{'~r~You do not have enough hours to claim this reward.'}) return end
    if not LUNA.hasGroup(user_id, reward..'hrs') then
        if hours >= reward then
            LUNA.giveBankMoney(user_id,reward*100)
        end
        LUNA.addUserGroup(user_id, reward..'hrs')
        LUNAclient.notify(source,{'You have clamimed '..reward..' from the login reward'})
    else
        LUNAclient.notify(source,{'~r~You have already claimed the '..reward..' login reward'})
    end
end)


RegisterServerEvent('LUNA:getHoursReward')
AddEventHandler('LUNA:getHoursReward', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    local hours = math.ceil(LUNA.getUserDataTable(user_id).PlayerTime/60) or 0
    TriggerClientEvent('LUNA:sendHoursReward', source, hours)
end)


