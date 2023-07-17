function cFDM.SetPresence(userId, Name, Players)
	SetDiscordAppId(1121630433583575130)
	SetDiscordRichPresenceAsset('0112')  
	SetDiscordRichPresenceAssetText("Frag Deathmatch") 
	SetDiscordRichPresenceAssetSmall('0112') 
	SetDiscordRichPresenceAssetSmallText('discord.gg/FragDM')
    SetRichPresence("ID: ".. userId .." | "..Players.. "/64")
	SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/fragdm")
end