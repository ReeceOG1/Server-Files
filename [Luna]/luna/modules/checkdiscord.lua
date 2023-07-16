-- -- You need to require the MySQL library based on what you're using
-- -- local MySQL = require('...')

-- function isDiscordIDInDatabase(discordID)
--     local discordIDToCheck = 'discord:'..discordID -- Assemble the ID like those stored in your DB
--     local result = MySQL.Sync.fetchScalar('SELECT identifier FROM luna_user_ids WHERE identifier = @identifier', {
--         ['@identifier'] = discordIDToCheck
--     })

--     return result ~= nil -- If result is not nil, the ID is in the DB
-- end

-- AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
--     local src = source
--     local identifiers = GetPlayerIdentifiers(src)

--     for i = 1, #identifiers do
--         if string.match(identifiers[i], 'discord:') then
--             local discordID = string.gsub(identifiers[i], 'discord:', '')
--             -- Code to check if discordID is in your database here
--             -- If it's not, kick the player
--             if not isDiscordIDInDatabase(discordID) then
--                 setKickReason('You must join our Discord guild to play on this server. Please join at discord.gg/LUNA5M')
--                 CancelEvent()
--             end
--         end
--     end
-- end)
