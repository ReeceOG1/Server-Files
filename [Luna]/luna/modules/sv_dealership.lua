RegisterNetEvent('whoIs')
AddEventHandler('whoIs', function(vehicle, price)
    local user_id = LUNA.getUserId(source)
    local correctcar = false 
    local wrongprice = false 
    local player = source
    local user_id = LUNA.getUserId(source)
    local playerName = GetPlayerName(source)   


 
        MySQL.query("LUNA/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
            if #pvehicle > 0 then
                LUNAclient.notify(player,{"~r~Vehicle already owned."})
                TriggerClientEvent("luna:PlaySound", player, 2)
            else

                if LUNA.tryFullPayment(user_id, price) then
                LUNA.getUserIdentity(user_id, function(identity)
                    MySQL.execute("LUNA/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = identity.registration})
                    webhook = "https://ptb.discord.com/api/webhooks/1110524880807542784/e5qbw_a6rz9n5rAUACJTUf5XlUuZ4MDwE1RRXW-O5gA9r0CgFHQPsHL_22aLyaxektiE"
                    PerformHttpRequest(webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = "LUNA", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Dealership Vehicle bought",
                        ["description"] = "**Player Name:** "..playerName.."\n**PermID:** "..user_id.."\n**Car Spawncode:** "..vehicle.."\n**Paid:** £"..tostring(price),
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                        }
                    }}), { ["Content-Type"] = "application/json" })
                end)

                    LUNAclient.notify(player,{"~g~Vehicle pruchased! Pick up your vehicle from the nearest garage!"})
                    TriggerClientEvent("luna:PlaySound", player, 1)
                    
                else
                    LUNAclient.notify(player,{"~r~Insufficient funds."})
                    TriggerClientEvent("luna:PlaySound", player, 2)
                end
            end
        end)
   
end)