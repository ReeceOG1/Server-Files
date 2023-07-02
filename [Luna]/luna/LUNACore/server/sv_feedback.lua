RegisterServerEvent("LUNA:adminTicketFeedback")
AddEventHandler("LUNA:adminTicketFeedback", function(AdminID, FeedBackType, Message)
    if AdminID == nil then
        return
    end
    local PlayerName = GetPlayerName(source)
    local AdminName = GetPlayerName(AdminID)
    local AdminPermID = LUNA.getUserId(AdminID)
    local PlayerID = LUNA.getUserId(source)
    print(AdminPermID)
    if FeedBackType == "good" then
        LUNA.giveBankMoney(AdminPermID, 25000)
        LUNAclient.notify(AdminID, {"~g~You have received £25000 for a good feedback."})
        LUNAclient.notify(source, {"~g~You have given a Good feedback."})
    elseif FeedBackType == "neutral" then
        LUNA.giveBankMoney(AdminPermID, 10000)
        LUNAclient.notify(AdminID, {"~g~You have received £10000 for a good feedback."})
        LUNAclient.notify(source, {"~y~You have given a Neutral feedback."})
    elseif FeedBackType == "bad" then
        LUNA.giveBankMoney(AdminPermID, 5000)
        LUNAclient.notify(AdminID, {"~g~You have received £5000 for a good feedback."})
        LUNAclient.notify(source, {"~r~You have given a Bad feedback."})
    end
    local ticketembed = {
        {
            ["color"] = "16777215",
            ["title"] = "Admin Ticket Feedback",
            ["description"] = "**Admin ID: **" ..AdminPermID.. "\n**Perm ID: **" ..PlayerID.. "\n**FeedBack Type: **" ..FeedBackType.. "\n**Message: **" ..Message.. "\n\n**Created By WattSkill**",
            ["footer"] = {
            ["text"] = "LUNA - "..os.date("%X"),
            ["icon_url"] = "",
            }
        }
    }
    PerformHttpRequest("https://discord.com/api/webhooks/1123627559117135953/vQWWm5caF4-MiSvKHH75khDyLGj1IPEefdA0aoEeiN8iSOAK7FgJ0QrHy4NwY5N_-044", function(err, text, headers) end, "POST", json.encode({username = "Smiley Logs", embeds = ticketembed}), { ["Content-Type"] = "application/json" })

end)