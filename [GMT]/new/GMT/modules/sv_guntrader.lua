RegisterNetEvent('GMT:gunTraderSell')
AddEventHandler('GMT:gunTraderSell', function()
    local source = source
	local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'weapon') > 0 then
            GMT.tryGetInventoryItem(user_id, 'weapon', 1, false)
            GMTclient.notify(source, {'~g~Sold weapon for £'..getMoneyStringFormatted(a.refundPercentage)})
            GMT.giveBankMoney(user_id, defaultPrices['weapon'])
        else
            GMTclient.notify(source, {'You do not have a weapon.'})
        end
    end
end)