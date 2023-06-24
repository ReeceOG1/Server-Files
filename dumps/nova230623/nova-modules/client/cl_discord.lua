

local UserID = 0
local PlayerCount = 0

RegisterNetEvent('discord:getpermid2')
AddEventHandler('discord:getpermid2', function(UserID)
    SetDiscordAppId(1117871736097095720)
    SetDiscordRichPresenceAsset('logo_bg')
    SetDiscordRichPresenceAssetText('Nova Roleplay')
    SetDiscordRichPresenceAssetSmallText('[EU|UK] NOVA Server #1')
    SetDiscordRichPresenceAction(0, "Join Discord", "https://discord.gg/4YSJvhrCyh")
    SetDiscordRichPresenceAction(1, "Connect To NOVA", "https://pnrtscr.com/ck08e6")
    SetRichPresence("[ "..UserID.." ] - Connecting")
end)

RegisterNetEvent('NOVA:StartGetPlayersLoopCL')
AddEventHandler('NOVA:StartGetPlayersLoopCL', function()
    StartLoop()
end)

RegisterNetEvent('NOVA:ReturnGetPlayersLoopCL')
AddEventHandler('NOVA:ReturnGetPlayersLoopCL', function(UserID, PlayerCount)
    UserID = UserID
    PlayerCount = PlayerCount
    SetRichPresence("[ID:"..UserID.."] "..PlayerCount.." / 64")
end)

function StartLoop()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            TriggerServerEvent("NOVA:StartGetPlayersLoopSV")
        end
    end)
end
