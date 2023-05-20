GMAAnnouncementConfig = {}
 
-- AUDIO --
GMAAnnouncementConfig.UseSound = true
GMAAnnouncementConfig.AudioName = "ROUND_ENDING_STINGER_CUSTOM"
GMAAnnouncementConfig.AudioRefrence = "CELEBRATION_SOUNDSET"
 
-- MESSAGE --
GMAAnnouncementConfig.TitleName = "GMA Announcement!"
GMAAnnouncementConfig.ShowTime = 20
GMAAnnouncementConfig.ErrorTitle = 'Error'
GMAAnnouncementConfig.ErrorTextPermissions = "You don't have enough permissions to execute this command."
GMAAnnouncementConfig.ErrorTextCharacterLimit = "Maximum characters reached for this style"
 
-- COMMAND --
GMAAnnouncementConfig.Command = "announce"
GMAAnnouncementConfig.CommandHelpText = "Make a server announcement"
GMAAnnouncementConfig.CommandStyleText = "style"
GMAAnnouncementConfig.CommandStyleHelp = "Select the style of announcement"
GMAAnnouncementConfig.CommandMessageText = "message"
GMAAnnouncementConfig.CommandMessageHelp = "Enter the message you'd like to to include within the announcement"
 
-- PERMISSIONS --
GMAAnnouncementConfig.UsingQBCore = false
GMAAnnouncementConfig.QBCorePermission = 'admin'
GMAAnnouncementConfig.AloudLicences = {
    'license:', -- Enter the licences of users that should have access to this command. This will be ignored if you're using QBCore.
    'xbl:',
    'live:',
    'discord:259797127012679691',
    'discord:746375095559127153',
    'fivem:Cye1',
    'license2:'
}
GMAAnnouncementConfig.DebugMode = false -- If this is set to true, the licence of the user that is trying to execute the command will show within the server console.