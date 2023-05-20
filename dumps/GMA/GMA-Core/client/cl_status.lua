local UserID = 0
local PlayerCount = 0

RegisterNetEvent('discord:getpermid2')
AddEventHandler('discord:getpermid2', function(UserID)
    SetDiscordAppId(1105884853704073236)
    SetDiscordRichPresenceAsset('big')
    SetDiscordRichPresenceAssetText('GMA')
    SetDiscordRichPresenceAssetSmallText('GMA')
    SetDiscordRichPresenceAction(0, "Join GMA", "https://discord.gg/GMA")
  --  SetDiscordRichPresenceAction(1, "Join GMA", "https://cfx.re/join/6qjbrd")
   -- SetRichPresence("[ID: " .. tostring(UserID) .. "] |" .. #GetActivePlayers() " /64")
end)






RegisterNetEvent('GMA:StartGetPlayersLoopCL')
AddEventHandler('GMA:StartGetPlayersLoopCL', function()
    StartLoop()
end)

RegisterNetEvent('GMA:ReturnGetPlayersLoopCL')
AddEventHandler('GMA:ReturnGetPlayersLoopCL', function(UserID, PlayerCount)
    UserID = UserID
    PlayerCount = PlayerCount
    SetRichPresence("[ID: "..UserID.."] | "..PlayerCount.." / 64")
end)

function StartLoop()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            TriggerServerEvent("GMA:StartGetPlayersLoopSV")
        end
    end)
end