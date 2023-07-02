RegisterServerEvent("GMT:getCommunityPotAmount")
AddEventHandler("GMT:getCommunityPotAmount", function()
    local source = source
    local user_id = GMT.getUserId(source)
    exports['ghmattimysql']:execute("SELECT value FROM gmt_community_pot", function(potbalance)
        TriggerClientEvent('GMT:gotCommunityPotAmount', source, parseInt(potbalance[1].value))
    end)
end)

RegisterServerEvent("GMT:tryDepositCommunityPot")
AddEventHandler("GMT:tryDepositCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['ghmattimysql']:execute("SELECT value FROM gmt_community_pot", function(potbalance)
            if GMT.tryFullPayment(user_id,amount) then
                local newpotbalance = parseInt(potbalance[1].value) + amount
                exports['ghmattimysql']:execute("UPDATE gmt_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('GMT:gotCommunityPotAmount', source, newpotbalance)
                tGMT.sendWebhook('com-pot', 'GMT Community Pot Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Deposit**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("GMT:tryWithdrawCommunityPot")
AddEventHandler("GMT:tryWithdrawCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['ghmattimysql']:execute("SELECT value FROM gmt_community_pot", function(potbalance)
            if parseInt(potbalance[1].value) >= amount then
                local newpotbalance = parseInt(potbalance[1].value) - amount
                exports['ghmattimysql']:execute("UPDATE gmt_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('GMT:gotCommunityPotAmount', source, newpotbalance)
                GMT.giveMoney(user_id, amount)
                tGMT.sendWebhook('com-pot', 'GMT Community Pot Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Withdraw**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("GMT:addToCommunityPot")
AddEventHandler("GMT:addToCommunityPot", function(amount)
    if source ~= '' then return end
    exports['ghmattimysql']:execute("SELECT value FROM gmt_community_pot", function(potbalance)
        local newpotbalance = parseInt(potbalance[1].value) + amount
        exports['ghmattimysql']:execute("UPDATE gmt_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
    end)
end)