local tickets = {}
local callID = 0
local cooldown = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(cooldown) do
            if cooldown[k].time > 0 then
                cooldown[k].time = cooldown[k].time - 1
            end
        end
    end
end)

RegisterCommand("calladmin", function(source)
    local user_id = GMT.getUserId(source)
    local user_source = GMT.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            GMTclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    GMT.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 25 then
                callID = callID + 1
                tickets[callID] = {
                    name = GetPlayerName(user_source),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(GMT.getUsers({})) do
                    TriggerClientEvent("GMT:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                GMTclient.notify(user_source,{"~b~Your request has been sent."})
                GMTclient.notify(user_source,{"~y~If you are reporting a player you can also create a report at www.gmtstudios.uk/forums"})
            else
                GMTclient.notify(user_source,{"~r~Please enter a minimum of 25 characters."})
            end
        else
            GMTclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("999", function(source)
    local user_id = GMT.getUserId(source)
    local user_source = GMT.getUserSource(user_id)
    GMT.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'met'
            }
            for k, v in pairs(GMT.getUsers({})) do
                TriggerClientEvent("GMT:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'met')
            end
            GMTclient.notify(user_source,{"~b~Sent Police Call."})
        else
            GMTclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("111", function(source)
    local user_id = GMT.getUserId(source)
    local user_source = GMT.getUserSource(user_id)
    GMT.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = GetPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'nhs'
            }
            for k, v in pairs(GMT.getUsers({})) do
                TriggerClientEvent("GMT:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
            end
            GMTclient.notify(user_source,{"~g~Sent NHS Call."})
        else
            GMTclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

local savedPositions = {}
RegisterCommand("return", function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.tickets') then
        if savedPositions[user_id] then
            tGMT.setBucket(source, savedPositions[user_id].bucket)
            GMTclient.teleport(source, {table.unpack(savedPositions[user_id].coords)})
            GMTclient.notify(source, {'~g~Returned to position.'})
            savedPositions[user_id] = nil
        else
            GMTclient.notify(source, {"~r~Unable to find last location."})
        end
        TriggerClientEvent('GMT:sendTicketInfo', source)
        GMTclient.staffMode(source, {false})
        SetTimeout(1000, function() 
            GMTclient.setPlayerCombatTimer(source, {0})
        end)
    end
end)


RegisterNetEvent("GMT:TakeTicket")
AddEventHandler("GMT:TakeTicket", function(ticketID)
    local user_id = GMT.getUserId(source)
    local admin_source = GMT.getUserSource(user_id)
    if tickets[ticketID] ~= nil then
        for k, v in pairs(tickets) do
            if ticketID == k then
                if tickets[ticketID].type == 'admin' and GMT.hasPermission(user_id, "admin.tickets") then
                    if GMT.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            savedPositions[user_id] = {bucket = adminbucket, coords = GetEntityCoords(GetPlayerPed(admin_source))}
                            if adminbucket ~= playerbucket then
                                tGMT.setBucket(admin_source, playerbucket)
                                GMTclient.notify(admin_source, {'~g~Player was in another bucket, you have been set into their bucket.'})
                            end
                            GMTclient.getPosition(v.tempID, {}, function(coords)
                                GMTclient.staffMode(admin_source, {true})
                                TriggerClientEvent('GMT:sendTicketInfo', admin_source, v.permID, v.name)
                                local ticketPay = 0
                                if os.date('%A') == 'Saturday' or os.date('%A') == 'Sunday' then
                                    ticketPay = 20000
                                else
                                    ticketPay = 10000
                                end
                                exports['ghmattimysql']:execute("SELECT * FROM `gmt_staff_tickets` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                    if result ~= nil then 
                                        for k,v in pairs(result) do
                                            if v.user_id == user_id then
                                                exports['ghmattimysql']:execute("UPDATE gmt_staff_tickets SET ticket_count = @ticket_count, username = @username WHERE user_id = @user_id", {user_id = user_id, ticket_count = v.ticket_count + 1, username = GetPlayerName(admin_source)}, function() end)
                                                return
                                            end
                                        end
                                        exports['ghmattimysql']:execute("INSERT INTO gmt_staff_tickets (`user_id`, `ticket_count`, `username`) VALUES (@user_id, @ticket_count, @username);", {user_id = user_id, ticket_count = 1, username = GetPlayerName(admin_source)}, function() end) 
                                    end
                                end)
                                GMT.giveBankMoney(user_id, ticketPay)
                                GMTclient.notify(admin_source,{"~g~£"..getMoneyStringFormatted(ticketPay).." earned for being cute. ❤️"})
                                GMTclient.notify(v.tempID,{"~g~An admin has taken your ticket."})
                                TriggerClientEvent('GMT:smallAnnouncement', v.tempID, 'ticket accepted', "Your admin ticket has been accepted by "..GetPlayerName(admin_source), 33, 10000)
                                tGMT.sendWebhook('ticket-logs',"GMT Ticket Logs", "> Admin Name: **"..GetPlayerName(admin_source).."**\n> Admin TempID: **"..admin_source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..v.name.."**\n> Player PermID: **"..v.permID.."**\n> Player TempID: **"..v.tempID.."**\n> Reason: **"..v.reason.."**")
                                GMTclient.teleport(admin_source, {table.unpack(coords)})
                                TriggerClientEvent("GMT:removeEmergencyCall", -1, ticketID)
                                tickets[ticketID] = nil
                            end)
                        else
                            GMTclient.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        GMTclient.notify(admin_source,{"You cannot take a ticket from an offline player."})
                        TriggerClientEvent("GMT:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'met' and GMT.hasPermission(user_id, "police.armoury") then
                    if GMT.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            if v.tempID ~= nil then
                                GMTclient.notify(v.tempID,{"~b~Your MET Police call has been accepted!"})
                            end
                            tickets[ticketID] = nil
                            TriggerClientEvent("GMT:removeEmergencyCall", -1, ticketID)
                        else
                            GMTclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("GMT:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'nhs' and GMT.hasPermission(user_id, "nhs.menu") then
                    if GMT.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            GMTclient.notify(v.tempID,{"~g~Your NHS call has been accepted!"})
                            tickets[ticketID] = nil
                            TriggerClientEvent("GMT:removeEmergencyCall", -1, ticketID)
                        else
                            GMTclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("GMT:removeEmergencyCall", -1, ticketID)
                    end
                end
            end
        end
    end         
end)

RegisterNetEvent("GMT:PDRobberyCall")
AddEventHandler("GMT:PDRobberyCall", function(source, store, position)
    local source = source
    local user_id = GMT.getUserId(source)
    callID = callID + 1
    tickets[callID] = {
        name = 'Store Robbery',
        permID = 999,
        tempID = nil,
        reason = 'Robbery in progress at '..store,
        type = 'met'
    }
    for k, v in pairs(GMT.getUsers({})) do
        TriggerClientEvent("GMT:addEmergencyCall", v, callID, 'Store Robbery', 999, position, 'Robbery in progress at '..store, 'met')
    end
end)

RegisterNetEvent("GMT:NHSComaCall")
AddEventHandler("GMT:NHSComaCall", function()
    local user_id = GMT.getUserId(source)
    local user_source = GMT.getUserSource(user_id)
    local reason = 'Immediate Attention'
    callID = callID + 1
    tickets[callID] = {
        name = GetPlayerName(user_source),
        permID = user_id,
        tempID = user_source,
        reason = reason,
        type = 'nhs'
    }
    for k, v in pairs(GMT.getUsers({})) do
        TriggerClientEvent("GMT:addEmergencyCall", v, callID, GetPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
    end
end)