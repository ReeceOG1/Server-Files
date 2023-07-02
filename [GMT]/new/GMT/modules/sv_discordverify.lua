local a = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        for k,v in pairs(a) do
            if a[k] ~= nil then
                a[k] = nil
            end
        end
    end
end)

RegisterServerEvent('GMT:changeLinkedDiscord', function()
    local source = source
    local user_id = GMT.getUserId(source)
    GMT.prompt(source,"Enter Discord Id:","",function(source,discordid) 
        if discordid ~= nil then
            TriggerClientEvent('GMT:gotDiscord', source)
            GMTclient.generateUUID(source, {"linkcode", 5, "alphanumeric"}, function(code)
                a[user_id] = {code = code, discordid = discordid}
                exports['GMTStaffBot']:dmUser(source, {discordid, code, user_id}, function()end)
            end)
        end
	end)
end)


RegisterServerEvent('GMT:enterDiscordCode', function()
    local source = source
    local user_id = GMT.getUserId(source)
    GMT.prompt(source,"Enter Code:","",function(source,code) 
        if code ~= nil then
            if a[user_id].code == code then
                exports['ghmattimysql']:execute("UPDATE `gmt_verification` SET discord_id = @discord_id WHERE user_id = @user_id", {user_id = user_id, discord_id = a[user_id].discordid}, function() end)
                GMTclient.notify(source, {'~g~Your discord has been successfully updated.'})
            end
        end
	end)
end)
