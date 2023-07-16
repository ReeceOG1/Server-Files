RegisterNetEvent("FR:mutePlayers",function(a)
    for b, c in pairs(a) do
        exports["pma-voice"]:mutePlayer(b, true)
    end
end)
RegisterNetEvent("FR:mutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, true)
end)
RegisterNetEvent("FR:unmutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, false)
end)
