RegisterNetEvent("FDM:PlayClientSound", function(audio)
    SendNUIMessage({
        action = "playSound",
        audioFile = audio,
    })
end)