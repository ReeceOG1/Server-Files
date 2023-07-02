RegisterNetEvent('GMT:purchaseHighRollersMembership')
AddEventHandler('GMT:purchaseHighRollersMembership', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if not GMT.hasGroup(user_id, 'Highroller') then
        if GMT.tryFullPayment(user_id,10000000) then
            GMT.addUserGroup(user_id, 'Highroller')
            GMTclient.notify(source, {'~g~You have purchased the ~b~High Rollers ~g~membership.'})
            tGMT.sendWebhook('purchase-highrollers',"GMT Purchased Highrollers Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**")
        else
            GMTclient.notify(source, {'You do not have enough money to purchase this membership.'})
        end
    else
        GMTclient.notify(source, {"You already have High Roller's License."})
    end
end)

RegisterNetEvent('GMT:removeHighRollersMembership')
AddEventHandler('GMT:removeHighRollersMembership', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'Highroller') then
        GMT.removeUserGroup(user_id, 'Highroller')
    else
        GMTclient.notify(source, {"You do not have High Roller's License."})
    end
end)