RegisterServerEvent("GMT:adminTicketFeedback")
AddEventHandler("GMT:adminTicketFeedback", function(AdminID, FeedBackType, Message)
    if AdminID == nil then
        return
    end
    local PlayerName = GetPlayerName(source)
    local AdminName = GetPlayerName(AdminID)
    local AdminPermID = GMT.getUserId(AdminID)
    local PlayerID = GMT.getUserId(source)
    print(AdminPermID)
    if FeedBackType == "good" then
        GMT.giveBankMoney(AdminPermID, 25000)
        GMTclient.notify(AdminID, {"~g~You have received £25000 for a good feedback."})
        GMTclient.notify(source, {"~g~You have given a Good feedback."})
    elseif FeedBackType == "neutral" then
        GMT.giveBankMoney(AdminPermID, 10000)
        GMTclient.notify(AdminID, {"~g~You have received £10000 for a good feedback."})
        GMTclient.notify(source, {"~y~You have given a Neutral feedback."})
    elseif FeedBackType == "bad" then
        GMT.giveBankMoney(AdminPermID, 5000)
        GMTclient.notify(AdminID, {"~g~You have received £5000 for a good feedback."})
        GMTclient.notify(source, {"~r~You have given a Bad feedback."})
    end
    tGMT.sendWebhook('feedback', 'GMT Feedback Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player Discord: **"..discord_id.."**\n> Player PermID: **"..user_id.."**\n> **Feedback Type**"..FeedbackType.."\n> **Admin Perm ID: **"..AdminID)
end)