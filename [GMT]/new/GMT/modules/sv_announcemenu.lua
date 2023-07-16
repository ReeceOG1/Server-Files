local announceTables = {
    {permission = 'admin.managecommunitypot', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/FZMys0F.png'},
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/I7c5LsN.png'},
    {permission = 'nhs.announce', info = {name = "NHS Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/SypLbMo.png'},
    {permission = 'lfb.announce', info = {name = "LFB Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/AFqPgYk.png'},
    {permission = 'hmp.announce', info = {name = "HMP Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/rPF5FgQ.png'},
}

RegisterServerEvent("GMT:getAnnounceMenu")
AddEventHandler("GMT:getAnnounceMenu", function()
    local source = source
    local user_id = GMT.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if GMT.hasPermission(user_id, v.permission) or GMT.hasGroup(user_id, 'Founder') then
            table.insert(hasPermsFor, v.info)
        end
    end
    if #hasPermsFor > 0 then
        TriggerClientEvent("GMT:buildAnnounceMenu", source, hasPermsFor)
    end
end)

RegisterServerEvent("GMT:serviceAnnounce")
AddEventHandler("GMT:serviceAnnounce", function(announceType)
    local source = source
    local user_id = GMT.getUserId(source)
    for k,v in pairs(announceTables) do
        if v.info.name == announceType then
            if GMT.hasPermission(user_id, v.permission) or GMT.hasGroup(user_id, 'Founder') then
                if GMT.tryFullPayment(user_id, v.info.price) then
                    GMT.prompt(source,"Input text to announce","",function(source,data) 
                        TriggerClientEvent('GMT:serviceAnnounceCl', -1, v.image, data)
                        if v.info.price > 0 then
                            GMTclient.notify(source, {"~g~Purchased a "..v.info.name.." for £"..v.info.price.." with content ~b~"..data})
                        else
                            GMTclient.notify(source, {"~g~Sending a "..v.info.name.." with content ~b~"..data})
                            tGMT.sendWebhook('announce', "GMT Announcement Logs", "```"..data.."```".."\n> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                        end
                    end)
                else
                    GMTclient.notify(source, {"~r~You do not have enough money to do this."})
                end
            else
                TriggerEvent("GMT:acBan", user_id, 11, GetPlayerName(source), source, 'Attempted to Trigger an announcement')
            end
        end
    end
end)