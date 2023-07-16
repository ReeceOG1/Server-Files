local sv_police = false

tLUNA.getInfo = function()
    local user_id = LUNA.getUserId(source)

    if LUNA.hasPermission(user_id, "police.armoury") then
        sv_police = true
    else
        sv_police = false
    end


    LUNAclient.hasPoliceJob(source, {sv_police})
end

tLUNA.PanicSV = function(s1, s2)
    local src = source

    for i, v in pairs(LUNA.rusers) do
        local player = LUNA.getUserSource(tonumber(i))
        local playername = GetPlayerName(src)
        if LUNA.hasPermission(i, "police.armoury") then
            LUNAclient.PanicCL(player, {src, s1, s2, playername})
        end
    end
    webhook = "https://ptb.discord.com/api/webhooks/1110524452384555028/HxdpntEQ6DlpLwgIQ0w92Q_gD73Cda9eRpLG__6vQ8bgT8JHXjfRFCNmvd9vS2VeWNJc"
    PerformHttpRequest(webhook, function(err, text, headers) 
    end, "POST", json.encode({username = "Panic Logs", embeds = {
        {
            ["color"] = "15158332",
            ["title"] = "Panic button activated.",
            ["description"] = "**Officer Name:** "..GetPlayerName(src).."**\nOfficer ID:** "..LUNA.getUserId(src).."**\nStreet:** "..s2,
            ["footer"] = {
                ["text"] = "Time - "..os.date("%x %X %p"),
            }
    }
    }}), { ["Content-Type"] = "application/json" })
end

tLUNA.BlipSV = function(gx, gy, gz)
    for i, v in pairs(LUNA.rusers) do
        if LUNA.hasPermission(i, "police.armoury") then
            LUNAclient.BlipCL(-1, {gx, gy, gz})
        end
    end
end