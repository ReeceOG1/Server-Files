MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO LUNA_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM LUNA_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE LUNA_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE LUNA_casino_chips SET chips = (chips - @amount) WHERE user_id = @user_id")


AddEventHandler("playerJoining", function()
    local user_id = LUNA.getUserId(source)
    MySQL.execute("casinochips/add_id", {user_id = user_id})
end)

RegisterNetEvent("LUNA:enterDiamondCasino")
AddEventHandler("LUNA:enterDiamondCasino", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    SetPlayerRoutingBucket(source, 50)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('LUNA:setDisplayChips', source, rows[1].chips)
        end
    end)
end)

RegisterNetEvent("LUNA:exitDiamondCasino")
AddEventHandler("LUNA:exitDiamondCasino", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    SetPlayerRoutingBucket(source, 0)
end)

RegisterNetEvent("LUNA:getChips")
AddEventHandler("LUNA:getChips", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('LUNA:setDisplayChips', source, rows[1].chips)
        end
    end)
end)

RegisterNetEvent("LUNA:buyChips")
AddEventHandler("LUNA:buyChips", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        LUNA.prompt(source, "Amount: ", "", function(source, Amount)
            if Amount ~= nil then
                local ChipsAmount =tonumber(Amount)
                if LUNA.tryPayment(user_id, ChipsAmount) then
                    MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = ChipsAmount})
                    TriggerClientEvent('LUNA:chipsUpdated', source)
                else
                    LUNAclient.notify(source,{"~r~You don't have enough money."})
                end
            end
        end)
    end
end)

RegisterNetEvent("LUNA:sellChips")
AddEventHandler("LUNA:sellChips", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    local chips = nil
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            local chips = rows[1].chips
            LUNA.prompt(source, "Amount To Sell: ", "", function(source, Amount)
                if Amount ~= nil then
                    local ChipsAmount = tonumber(Amount)
                    if ChipsAmount > chips then
                        LUNAclient.notify(source,{"~r~You don't have enough chips."})
                    else
                        MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = ChipsAmount})
                        TriggerClientEvent('LUNA:chipsUpdated', source)
                        LUNA.giveMoney(user_id, ChipsAmount)
                    end
                end
            end)
        end
    end)
end)