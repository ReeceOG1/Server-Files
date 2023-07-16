Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO','~w~GMT British RP - discord.gg/GMT')
    AddTextEntry("PM_PANE_CFX","GMT")
end)
RegisterCommand("discord",function()
    TriggerEvent("chatMessage","^1[GMT]^1  ",{ 128, 128, 128 },"^0Discord: discord.gg/gmt","ooc")
    tGMT.notify("~g~discord Copied to Clipboard.")
    tGMT.CopyToClipBoard("https://discord.gg/GMT")
end)
RegisterCommand("ts",function()
    TriggerEvent("chatMessage","^1[GMT]^1  ",{ 128, 128, 128 },"^0TS: ts.gmtforums.net","ooc")
    tGMT.notify("~g~ts Copied to Clipboard.")
    tGMT.CopyToClipBoard("ts.gmtforums.net")
end)
RegisterCommand("website",function()
    TriggerEvent("chatMessage","^1[GMT]^1  ",{ 128, 128, 128 },"^0Forums: www.gmtforums.net","ooc")
    tGMT.notify("~g~Website Copied to Clipboard.")
    tGMT.CopyToClipBoard("www.gmtforums.net")
end)
RegisterCommand("register",function()
    TriggerEvent("chatMessage","^1There is no need to /register on this server, to change your appearance go to a clothes store!")
end,false)

--[[RegisterCommand('getid', function(source, args)
    if args and args[1] then 
        if tGMT.clientGetUserIdFromSource(tonumber(args[1])) ~= nil then
            if tGMT.clientGetUserIdFromSource(tonumber(args[1])) ~= tGMT.getUserId() then
                TriggerEvent("chatMessage","^1[GMT]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tGMT.clientGetUserIdFromSource(tonumber(args[1])), "alert")
            else
                TriggerEvent("chatMessage","^1[GMT]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tGMT.getUserId(), "alert")
            end
        else
            TriggerEvent("chatMessage","^1[GMT]^1  ",{ 128, 128, 128 }, "Invalid Temp ID", "alert")
        end
    else 
        TriggerEvent("chatMessage","^1[GMT]^1  ",{ 128, 128, 128 }, "Please specify a user eg: /getid [tempid]", "alert")
    end
end)]]

RegisterCommand("linktwitter",function()
    SendNUIMessage({act="openurl",url="https://gmtstudios.net/twitter/"})
end,false)