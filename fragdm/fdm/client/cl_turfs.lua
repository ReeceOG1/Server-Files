local isCapturing = false;
local currentZone = false;
local gangTurfData = {
    ["Chicken"] = {
        coords = vec3(-71.0187, 6243.7402, 31.0676), 
        radius = 150.0, 
    };
    ["LSD"] = {
        coords = vec3(2485.2253, -428.2021, 92.9927), 
        radius = 150.0, 
    };
    ["H"] = {
        coords = vec3(3577.4697, 3649.3164, 33.8886), 
        radius = 150.0, 
    };
    ["Rebel"] = {
        coords = vec3(1429.5491, 6348.2539, 23.9838), 
        radius = 150.0, 
    };
    ["Military Base"] = {
        coords = vec3(-2132.3845, 3262.5400, 32.8103), 
        radius = 150.0, 
    };
};

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(playerPed)
        for k,v in pairs(gangTurfData) do
            if #(pedCoords - gangTurfData[k].coords) < 20.0 then
                DrawMarker(30, gangTurfData[k].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 250, 0, 0, 100, false, true, 2, true, nil, nil, false)
            end
            if #(pedCoords - gangTurfData[k].coords) < 1.0 then
                displayAlert("Press ~INPUT_PICKUP~ To Capture " ..k)
                if IsControlJustPressed(0, 51) then
                    TriggerServerEvent("FDM:TryCapture", k)
                end
            end
        end
        Wait(0)
    end
end)

RegisterNetEvent("FDM:DrawZone", function(bool, zone)
    if bool then
        isCapturing = true;
        currentZone = zone;
    else
        isCapturing = false;
        currentZone = false;
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(gangTurfData) do
		local blip = AddBlipForCoord(v.coords.x,v.coords.y,v.coords.z)
		SetBlipSprite(blip, 438)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip,true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(k.. " Turf")
		EndTextCommandSetBlipName(blip)
	end
    while true do
        interval = 1000;
        if isCapturing then 
            interval = 0;
            DrawMarker(1, currentZone-0.99999, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 50.0, 50.0, 50.0, 250, 0, 0, 100, false, false, 2, false, nil, nil, false)
        end
        Wait(interval)
    end
end)

function displayAlert(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, 1000)
end