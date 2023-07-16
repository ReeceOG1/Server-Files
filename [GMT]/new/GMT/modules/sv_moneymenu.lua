RegisterServerEvent("GMT:getUserinformation")
AddEventHandler("GMT:getUserinformation",function(id)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.moneymenu') then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('GMT:receivedUserInformation', source, GMT.getUserSource(id), GetPlayerName(GMT.getUserSource(id)), math.floor(GMT.getBankMoney(id)), math.floor(GMT.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("GMT:ManagePlayerBank")
AddEventHandler("GMT:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = GMT.getUserId(source)
    local userstemp = GMT.getUserSource(id)
    if GMT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            GMT.giveBankMoney(id, amount)
            GMTclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
            tGMT.sendWebhook('manage-balance',"GMT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            GMT.tryBankPayment(id, amount)
            GMTclient.notify(source, {'Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
            tGMT.sendWebhook('manage-balance',"GMT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('GMT:receivedUserInformation', source, GMT.getUserSource(id), GetPlayerName(GMT.getUserSource(id)), math.floor(GMT.getBankMoney(id)), math.floor(GMT.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("GMT:ManagePlayerCash")
AddEventHandler("GMT:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = GMT.getUserId(source)
    local userstemp = GMT.getUserSource(id)
    if GMT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            GMT.giveMoney(id, amount)
            GMTclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
            tGMT.sendWebhook('manage-balance',"GMT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            GMT.tryPayment(id, amount)
            GMTclient.notify(source, {'Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
            tGMT.sendWebhook('manage-balance',"GMT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('GMT:receivedUserInformation', source, GMT.getUserSource(id), GetPlayerName(GMT.getUserSource(id)), math.floor(GMT.getBankMoney(id)), math.floor(GMT.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("GMT:ManagePlayerChips")
AddEventHandler("GMT:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = GMT.getUserId(source)
    local userstemp = GMT.getUserSource(id)
    if GMT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            MySQL.execute("casinochips/add_chips", {user_id = id, amount = amount})
            GMTclient.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            tGMT.sendWebhook('manage-balance',"GMT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('GMT:receivedUserInformation', source, GMT.getUserSource(id), GetPlayerName(GMT.getUserSource(id)), math.floor(GMT.getBankMoney(id)), math.floor(GMT.getMoney(id)), chips)
                end
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            GMTclient.notify(source, {'Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            tGMT.sendWebhook('manage-balance',"GMT Money Menu Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(userstemp).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('GMT:receivedUserInformation', source, GMT.getUserSource(id), GetPlayerName(GMT.getUserSource(id)), math.floor(GMT.getBankMoney(id)), math.floor(GMT.getMoney(id)), chips)
                end
            end)
        end
    end
end)