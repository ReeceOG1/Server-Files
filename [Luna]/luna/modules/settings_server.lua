-- local settingsFilename = "settings.json"

-- -- Save settings to a file
-- function saveSettings(source, settings)
--     local playerIdentifier = GetPlayerIdentifier(source, 0)
--     local settingsData = LoadResourceFile(GetCurrentResourceName(), settingsFilename)

--     if settingsData then
--         settingsData = json.decode(settingsData)
--     else
--         settingsData = {}
--     end

--     settingsData[playerIdentifier] = settings
--     SaveResourceFile(GetCurrentResourceName(), settingsFilename, json.encode(settingsData), -1)
-- end

-- -- Load settings from a file
-- function loadSettings(source)
--     local playerIdentifier = GetPlayerIdentifier(source, 0)
--     local settingsData = LoadResourceFile(GetCurrentResourceName(), settingsFilename)

--     if settingsData then
--         settingsData = json.decode(settingsData)
--         return settingsData[playerIdentifier]
--     end

--     return nil
-- end

-- -- Event to save player settings
-- RegisterNetEvent("settings:save")
-- AddEventHandler("settings:save", function(settings)
--     local source = source
--     saveSettings(source, settings)
-- end)

-- -- Event to load player settings
-- RegisterNetEvent("settings:load")
-- AddEventHandler("settings:load", function()
--     local source = source
--     local settings = loadSettings(source)

--     if settings then
--         TriggerClientEvent("settings:apply", source, settings)
--     end
-- end)

-- -- When player connects, load their settings
-- AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
--     local source = source
--     TriggerEvent("settings:load", source)
-- end)
