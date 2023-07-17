Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO','~w~FR British RP - discord.gg/fr5m')
    AddTextEntry("PM_PANE_CFX","FR")
end)
RegisterCommand("discord",function()
    TriggerEvent("chatMessage","^1[FR]^1  ",{ 128, 128, 128 },"^0Discord: discord.gg/fr5m","ooc")
    tFR.notify("~g~discord Copied to Clipboard.")
    tFR.CopyToClipBoard("https://discord.gg/fr5m")
end)
-- RegisterCommand("ts",function()
--     TriggerEvent("chatMessage","^1[FR]^1  ",{ 128, 128, 128 },"^0TS: ts.frforums.net","ooc")
--     tFR.notify("~g~ts Copied to Clipboard.")
--     tFR.CopyToClipBoard("ts.frforums.net")
-- end)
RegisterCommand("website",function()
    TriggerEvent("chatMessage","^1[FR]^1  ",{ 128, 128, 128 },"^0Forums: www.frforums.net","ooc")
    tFR.notify("~g~Website Copied to Clipboard.")
    tFR.CopyToClipBoard("www.frforums.net")
end)
RegisterCommand("register",function()
    TriggerEvent("chatMessage","^1There is no need to /register on this server, to change your appearance go to a clothes store!")
end,false)

--[[RegisterCommand('getid', function(source, args)
    if args and args[1] then 
        if tFR.clientGetUserIdFromSource(tonumber(args[1])) ~= nil then
            if tFR.clientGetUserIdFromSource(tonumber(args[1])) ~= tFR.getUserId() then
                TriggerEvent("chatMessage","^1[FR]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tFR.clientGetUserIdFromSource(tonumber(args[1])), "alert")
            else
                TriggerEvent("chatMessage","^1[FR]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tFR.getUserId(), "alert")
            end
        else
            TriggerEvent("chatMessage","^1[FR]^1  ",{ 128, 128, 128 }, "Invalid Temp ID", "alert")
        end
    else 
        TriggerEvent("chatMessage","^1[FR]^1  ",{ 128, 128, 128 }, "Please specify a user eg: /getid [tempid]", "alert")
    end
end)]]