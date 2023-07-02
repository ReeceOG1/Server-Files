RegisterNetEvent("GMT:mutePlayers",function(a)
    for b, c in pairs(a) do
        exports["pma-voice"]:mutePlayer(b, true)
    end
end)
RegisterNetEvent("GMT:mutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, true)
end)
RegisterNetEvent("GMT:unmutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, false)
end)
