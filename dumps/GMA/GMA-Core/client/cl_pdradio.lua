-- CLIENT SIDE

-- Triggered when the player has permission and should connect to the radio
RegisterNetEvent('GMA:connectToRadio')
AddEventHandler('GMA:connectToRadio', function()
    exports["mumble-voip"]:SetRadioChannel(1)
end)

-- Triggered when the player no longer has permission and should disconnect from the radio
RegisterNetEvent('GMA:disconnectFromRadio')
AddEventHandler('GMA:disconnectFromRadio', function()
    exports["mumble-voip"]:SetRadioChannel(0)
end)

-- Check permission and request connection periodically
Citizen.CreateThread(function()
    while true do
        TriggerServerEvent('GMA:requestRadioConnection')
        Citizen.Wait(2000) -- check every 2 seconds
    end
end)
