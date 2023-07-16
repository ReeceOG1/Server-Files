MySQL.createCommand("subscription/set_plushours","UPDATE luna_club SET plushours = @plushours WHERE user_id = @user_id")
MySQL.createCommand("subscription/set_plathours","UPDATE luna_club SET plathours = @plathours WHERE user_id = @user_id")
MySQL.createCommand("subscription/set_lastused","UPDATE luna_club SET last_used = @last_used WHERE user_id = @user_id")
MySQL.createCommand("subscription/get_subscription","SELECT * FROM luna_club WHERE user_id = @user_id")
MySQL.createCommand("subscription/get_all_subscriptions","SELECT * FROM luna_club")
MySQL.createCommand("subscription/add_id", "INSERT IGNORE INTO luna_club SET user_id = @user_id, plushours = 0, plathours = 0, last_used = ''")

AddEventHandler("playerJoining", function()
    local user_id = LUNA.getUserId(source)
    MySQL.execute("subscription/add_id", {user_id = user_id})
end)

RegisterNetEvent("LUNA:setPlayerSubscription")
AddEventHandler("LUNA:setPlayerSubscription", function(playerid, subtype)
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)
    if LUNA.hasGroup(user_id, 'dev') or LUNA.hasGroup(user_id, 'founder') then
        LUNA.prompt(player,"Number of hours ","",function(player, hours)
            if tonumber(hours) and tonumber(hours) > 0 then
                if subtype == "Plus" then
                    MySQL.execute("subscription/set_plushours", {user_id = playerid, plushours = hours})
                elseif subtype == "Platinum" then
                    MySQL.execute("subscription/set_plathours", {user_id = playerid, plathours = hours})
                end
                TriggerClientEvent('LUNA:userSubscriptionUpdated', player)
            else
                LUNAclient.notify(player,{"~r~Number of hours must be a number."})
            end
        end)
    end
end)

RegisterNetEvent("LUNA:getPlayerSubscription")
AddEventHandler("LUNA:getPlayerSubscription", function(playerid)
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)
    if playerid ~= nil then
        MySQL.query("subscription/get_subscription", {user_id = playerid}, function(rows, affected)
            if #rows > 0 then
                local plushours = rows[1].plushours
                local plathours = rows[1].plathours
                TriggerClientEvent('LUNA:getUsersSubscription', player, playerid, plushours, plathours)
            else
                LUNAclient.notify(player, {"~r~Player not found."})
            end
        end)
    else
        MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
            local plushours = rows[1].plushours
            local plathours = rows[1].plathours
            TriggerClientEvent('LUNA:setlunaclubData', player, plushours, plathours)
        end)
    end
end)


RegisterNetEvent("LUNA:beginSellSubscriptionToPlayer")
AddEventHandler("LUNA:beginSellSubscriptionToPlayer", function(subtype)
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)
    local buyerplathours = 0
    local buyerplushours = 0
    local sellerplathours = 0
    local sellerplushours = 0
    LUNAclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
        usrList = ""
        for k, v in pairs(nplayers) do
            usrList = usrList .. "[" .. LUNA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | " --add ids to usrList
        end
        if usrList ~= "" then
            LUNA.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, target_id) --ask for id
                target_id = target_id
                if target_id ~= nil and target_id ~= "" then --validation
                    local target = LUNA.getUserSource(tonumber(target_id)) --get source of the new owner id
                    if target ~= nil then
                        LUNA.prompt(player,"Number of hours ","",function(player, hours) -- ask for number of hours
                            if tonumber(hours) and tonumber(hours) > 0 then
                                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                                    sellerplushours = rows[1].plushours
                                    sellerplathours = rows[1].plathours
                                    if (subtype == 'Plus' and sellerplushours >= tonumber(hours)) or (subtype == 'Platinum' and sellerplathours >= tonumber(hours)) then
                                        LUNA.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                            if tonumber(amount) and tonumber(amount) > 0 then
                                                LUNA.request(target,GetPlayerName(player).." wants to sell: " ..hours.. " of "..subtype.." subscription for £"..amount, 30, function(target,ok) --request player if they want to buy sub
                                                    if ok then --bought
                                                        local buyer_id = LUNA.getUserId(target)
                                                        amount = tonumber(amount) 
                                                        MySQL.query("subscription/get_subscription", {user_id = buyer_id}, function(rows, affected)
                                                            buyerplushours = rows[1].plushours
                                                            buyerplathours = rows[1].plathours
                                                            if subtype == "Plus" then
                                                                if LUNA.tryFullPayment(buyer_id,amount) then
                                                                    MySQL.execute("subscription/set_plushours", {user_id = buyer_id, plushours = buyerplushours + tonumber(hours)})
                                                                    MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = sellerplushours - tonumber(hours)})
                                                                    LUNAclient.notify(player,{'~g~You have sold '..hours..' hours of '..subtype..' subscription to '..GetPlayerName(target)..' for £'..amount})
                                                                    LUNAclient.notify(target, {'~g~'..GetPlayerName(player)..' has sold '..hours..' hours of '..subtype..' subscription to you for £'..amount})
                                                                else
                                                                    LUNAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    LUNAclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            elseif subtype == "Platinum" then
                                                                if LUNA.tryFullPayment(buyer_id,amount) then
                                                                    MySQL.execute("subscription/set_plathours", {user_id = buyer_id, plathours = buyerplathours + tonumber(hours)})
                                                                    MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = sellerplathours - tonumber(hours)})
                                                                    LUNAclient.notify(player,{'~g~You have sold '..hours..' hours of '..subtype..' subscription to '..GetPlayerName(target)..' for £'..amount})
                                                                    LUNAclient.notify(target, {'~g~'..GetPlayerName(player)..' has sold '..hours..' hours of '..subtype..' subscription to you for £'..amount})
                                                                else
                                                                    LUNAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    LUNAclient.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            end
                                                        end)
                                                    else
                                                        LUNAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy " ..hours.. " of "..subtype.." subscription for £"..amount}) --notify owner that refused
                                                        LUNAclient.notify(target,{"~r~You have refused to buy " ..hours.. " of "..subtype.." subscription for £"..amount}) --notify new owner that refused
                                                    end
                                                end)
                                            else
                                                LUNAclient.notify(player,{"~r~Price of subscription must be a number."})
                                            end
                                        end)
                                    else
                                        LUNAclient.notify(player,{"~r~You do not have "..hours.." hours of "..subtype.."."})
                                    end
                                end)
                            else
                                LUNAclient.notify(player,{"~r~Number of hours must be a number."})
                            end
                        end)
                    else
                        LUNAclient.notify(player,{"~r~That Perm ID seems to be invalid!"}) --couldnt find perm id
                    end
                else
                    LUNAclient.notify(player,{"~r~No Perm ID selected!"}) --no perm id selected
                end
            end)
        else
            LUNAclient.notify(player,{"~r~No players nearby!"}) --no players nearby
        end
    end)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        MySQL.query("subscription/get_all_subscriptions", {}, function(rows, affected)
            if #rows > 0 then
                for k,v in pairs(rows) do
                    local plushours = v.plushours
                    local plathours = v.plathours
                    local user_id = v.user_id
                    local user = LUNA.getUserSource(user_id)
                    if plushours >= 1/60 then
                        MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = plushours-1/60})
                    else
                        MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = 0})
                    end
                    if plathours >= 1/60 then
                        MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours-1/60})
                    else
                        MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = 0})
                    end
                    if user ~= nil then
                        TriggerClientEvent('LUNA:setlunaclubData', user, plushours, plathours)
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent("LUNA:claimWeeklyKit") -- need to add a thing for restricting the kit to actually being weekly 12 Gauge
AddEventHandler("LUNA:claimWeeklyKit", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            local plushours = rows[1].plushours
            local plathours = rows[1].plathours
            --local amount = 1000000
            if plathours >= 168 or plushours >= 168 then
                if rows[1].last_used == '' or (os.time() >= tonumber(rows[1].last_used+24*60*60*7)) then
                    if plathours >= 168 then
                        LUNA.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_MOSIN', 1, false)
                        LUNA.giveInventoryItem({user_id, '7,62 Bullets', 250, false})
                        LUNA.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_FNTACSHOTGUN', 1, false)
                        LUNA.giveInventoryItem({user_id, '7,62 Bullets', 250, true})
                        LUNA.giveInventoryItem({user_id, '9mm Bullets', 250, false})
                        LUNA.giveInventoryItem({user_id, '12 Gauge', 250, false})
                        LUNA.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_UMP45', 1, false)
                        LUNAclient.notify(source, {"~g~You have claimed your weeekly kit!"})
                        MySQL.execute("subscription/set_lastused", {user_id = user_id, last_used = os.time()})
                    elseif plushours >= 168 then
                        LUNA.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_MOSIN', 1, false)
                        LUNA.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_FNTACSHOTGUN', 1, false)
                        LUNA.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_UMP45', 1, false)
                        LUNA.giveInventoryItem({user_id, '7,62 Bullets', 250, true})
                        LUNA.giveInventoryItem({user_id, '9mm Bullets', 250, false})
                        LUNA.giveInventoryItem({user_id, '12 Gauge', 250, false})
                        LUNAclient.notify(source, {"~g~You have claimed your weeekly kit!"})
                        MySQL.execute("subscription/set_lastused", {user_id = user_id, last_used = os.time()})
                    else
                        LUNAclient.notify(source,{"~r~You can only claim your weekly kit once a week."})
                    end
                else
                    LUNAclient.notify(source,{"~r~You can only claim your weekly kit once a week."})
                end
            end
        else
            LUNAclient.notify(player, {"~r~Player not found."})
        end
    end)
end)