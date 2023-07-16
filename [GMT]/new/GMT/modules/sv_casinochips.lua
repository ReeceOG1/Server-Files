MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO gmt_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM gmt_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE gmt_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE gmt_casino_chips SET chips = CASE WHEN ((chips - @amount)>0) THEN (chips - @amount) ELSE 0 END WHERE user_id = @user_id")


AddEventHandler("playerJoining", function()
    local user_id = GMT.getUserId(source)
    MySQL.execute("casinochips/add_id", {user_id = user_id})
end)

RegisterNetEvent("GMT:enterDiamondCasino")
AddEventHandler("GMT:enterDiamondCasino", function()
    local source = source
    local user_id = GMT.getUserId(source)
    tGMT.setBucket(source, 777)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('GMT:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("GMT:exitDiamondCasino")
AddEventHandler("GMT:exitDiamondCasino", function()
    local source = source
    local user_id = GMT.getUserId(source)
    tGMT.setBucket(source, 0)
end)

RegisterNetEvent("GMT:getChips")
AddEventHandler("GMT:getChips", function()
    local source = source
    local user_id = GMT.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('GMT:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("GMT:buyChips")
AddEventHandler("GMT:buyChips", function(amount)
    local source = source
    local user_id = GMT.getUserId(source)
    if not amount then amount = GMT.getMoney(user_id) end
    if GMT.tryPayment(user_id, amount) then
        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
        TriggerClientEvent('GMT:chipsUpdated', source)
        tGMT.sendWebhook('purchase-chips',"GMT Chip Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
        return
    else
        GMTclient.notify(source,{"You don't have enough money."})
        return
    end
end)

local sellingChips = {}
RegisterNetEvent("GMT:sellChips")
AddEventHandler("GMT:sellChips", function(amount)
    local source = source
    local user_id = GMT.getUserId(source)
    local chips = nil
    if not sellingChips[source] then
        sellingChips[source] = true
        MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                if not amount then amount = chips end
                if amount > 0 and chips > 0 and chips >= amount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = amount})
                    TriggerClientEvent('GMT:chipsUpdated', source)
                    tGMT.sendWebhook('sell-chips',"GMT Chip Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
                    GMT.giveMoney(user_id, amount)
                else
                    GMTclient.notify(source,{"You don't have enough chips."})
                end
                sellingChips[source] = nil
            end
        end)
    end
end)