local cfg = module("cfg/cfg_backpacks")

local function buyBackpack(source,prop0,prop1,prop2,backpackname,price,size,backpackstorename)
    local user_id = GMT.getUserId(source)
    local data = GMT.getUserDataTable(user_id)
    for a,b in pairs(cfg.stores[backpackstorename]) do
        if a == backpackname then
            tGMT.getSubscriptions(user_id, function(cb, plushours, plathours)
                if cb then
                    local invcap = 30
                    if plathours > 0 then
                        invcap = 50
                    elseif plushours > 0 then
                        invcap = 40
                    end
                    if data.invcap > invcap then
                        GMTclient.notify(source, {'~r~You cannot use this item as you have a backpack already!'}) return
                    end
                    if GMT.tryPayment(user_id, b[4]) then
                        GMT.updateInvCap(user_id, (GMT.getInventoryMaxWeight(user_id)+b[5]))
                        TriggerClientEvent('GMT:boughtBackpack', source, prop0, prop1, prop2, size, backpackname)
                        GMTclient.notify(source, {"~g~" .. backpackname .. " Purchased"})
                    else
                        GMTclient.notify(source, {'~r~You do not have enough money.'})
                    end
                end
            end)  
        end
    end
end

RegisterServerEvent("GMT:BuyBackpack")
AddEventHandler("GMT:BuyBackpack",function(prop0,prop1,prop2,backpackname,price,size,backpackstorename)
    local source = source
    local user_id = GMT.getUserId(source)
    local hasPerm = false
    for k,v in pairs(cfg.stores) do
        if backpackstorename == 'Rebel' and k == 'Rebel' then
            if GMT.hasPermission(user_id, 'rebellicense.whitelisted') then
                buyBackpack(source, prop0,prop1,prop2,backpackname,price,size,backpackstorename)
            else
                GMTclient.notify(source, {'~r~You do not have permissions to purchase from this store.'})
            end
        elseif backpackstorename == 'JDSports' and k == 'JDSports' then
            buyBackpack(source, prop0,prop1,prop2,backpackname,price,size,backpackstorename)
        end
    end
end)