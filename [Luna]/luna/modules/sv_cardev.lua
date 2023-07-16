RegisterServerEvent('LUNA:openCarDev')
AddEventHandler('LUNA:openCarDev', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil and LUNA.hasPermission(user_id, "cardev.menu") then 
      LUNAclient.openCarDev(source,{})
    end
end)

RegisterServerEvent('LUNA:setCarDev')
AddEventHandler('LUNA:setCarDev', function(status)
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil and LUNA.hasPermission(user_id, "cardev.menu") then 
      if status then
        SetPlayerRoutingBucket(source, 10)
      else
        SetPlayerRoutingBucket(source, 0)
      end
    end
end)

RegisterServerEvent('LUNA:takeCarScreenshot')
AddEventHandler('LUNA:takeCarScreenshot', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    local name = GetPlayerName(source)
    if user_id ~= nil and LUNA.hasPermission(user_id, "cardev.menu") then 
        exports["discord-carscreenshot"]:requestClientScreenshotUploadToDiscord(source,{username = " Car Screenshots"},30000,function(error)
            if error then
                return print("^1ERROR: " .. error)
            end
        end)
    end   
end)

RegisterServerEvent("LUNA:getCarDevDebug")
AddEventHandler("LUNA:getCarDevDebug", function(text)
   local source = source
   local user_id = LUNA.getUserId(source)
   local command = {
      {
        ["color"] = "16777215",
        ["title"] = "Requested by "..GetPlayerName(source).." Perm ID: "..user_id.."",
        ["description"] = text[1],
        ["footer"] = {
          ["text"] = "LUNA - "..os.date("%X"),
          ["icon_url"] = "https://cdn.discordapp.com/attachments/1110327017049686029/1110387573815246989/lnu.png", -- LOGO
        }
      }
    }
    PerformHttpRequest("https://discordapp.com/api/webhooks/1096255069395111946/coKxPW3k9213BX-8u4S2-JD2haAX8aOYuhjQ0ntR8YRN_FLNVgDxQPKbvvQOZk-2nWt_", function(err, text, headers) end, 'POST', json.encode({username = "LUNA Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
end)