RegisterNetEvent("GMT:requestSpinLuckyWheel")
AddEventHandler("GMT:requestSpinLuckyWheel", function()
    local source = source
    local user_id = GMT.getUserId(source)
    local chips = nil
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            local chips = rows[1].chips
            if chips < 50000 then
                GMTclient.notify(source,{"You don't have enough chips."})
            else
                MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = 50000})
                TriggerClientEvent('GMT:chipsUpdated', source)
                TriggerClientEvent('GMT:spinLuckyWheel', source)
                TriggerClientEvent('GMT:syncLuckyWheel', source, 2) -- the number correlates to the item on the wheel
            end
        end
    end)
end)