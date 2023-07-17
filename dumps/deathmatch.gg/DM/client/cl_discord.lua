local UId = 0
local Plyrs = 0

RegisterNetEvent("DM:ReturnServerInfo")
AddEventHandler("DM:ReturnServerInfo", function(UsrId, Players)
    UId = UsrId
    Plyrs = Players
    SetRichPresence("[ID:"..UsrId.."] | " ..Plyrs.."/64")
end)

Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(964609695669157969)
		SetDiscordRichPresenceAsset('logo_bg')
        SetDiscordRichPresenceAssetText('Deathmatch')
        SetDiscordRichPresenceAssetSmall('logo_bg')
        SetDiscordRichPresenceAssetSmallText('Deathmatch')
        SetDiscordRichPresenceAction(0, "Join Deathmatch", "fivem://connect/s1.deathmatch-gg.com")
        TriggerServerEvent("DM:RequestServerInfo")
		Citizen.Wait(15000)
	end
end)