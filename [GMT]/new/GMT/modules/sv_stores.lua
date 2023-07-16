local cfg = module("cfg/cfg_stores")


RegisterNetEvent("GMT:BuyStoreItem")
AddEventHandler("GMT:BuyStoreItem", function(item, amount)
    local user_id = GMT.getUserId(source)
    local ped = GetPlayerPed(source)
    for k,v in pairs(cfg.shopItems) do
        if item == v.itemID then
            if GMT.getInventoryWeight(user_id) <= 25 then
                if GMT.tryPayment(user_id,v.price*amount) then
                    GMT.giveInventoryItem(user_id, item, amount, false)
                    GMTclient.notify(source, {"~g~Paid ".. '£' ..getMoneyStringFormatted(v.price*amount)..'.'})
                    TriggerClientEvent("gmt:PlaySound", source, 1)
                else
                    GMTclient.notify(source, {"Not enough money."})
                    TriggerClientEvent("gmt:PlaySound", source, 2)
                end
            else
                GMTclient.notify(source,{'Not enough inventory space.'})
                TriggerClientEvent("gmt:PlaySound", source, 2)
            end
        end
    end
end)