-- Made by Evn 
-- Simple script, Still alot to add.


-- Define the mechanic locations
local mechanic_shops = {
    {x = -33.079650878906, y = -1089.935546875, z = 26.422283172607, h = 180.0},
    {x = 535.81665039062, y = -179.53031921387, z = 54.375087738037, h = 200.0},
    -- add more locations as needed
}

-- Define a radius for triggering the repair
local repair_radius = 10.0

-- Define mechanic names
local mechanic_names = {
    "Evn",
    "Dribble",
    "Cash",
    "Dotz",
    "Cye",
    -- add more names as needed
}

-- Function to display notifications
function showNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Iterate over the mechanic locations
for _, shop in ipairs(mechanic_shops) do
    local blip = AddBlipForCoord(shop.x, shop.y, shop.z)
    SetBlipSprite(blip, 402)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mechanic Shop")
    EndTextCommandSetBlipName(blip)
end

-- Draw a marker at each mechanic shop
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local player = GetPlayerPed(-1)
        local player_coords = GetEntityCoords(player, true)
        for _, shop in ipairs(mechanic_shops) do
            if Vdist(player_coords.x, player_coords.y, player_coords.z, shop.x, shop.y, shop.z) < repair_radius then
                DrawMarker(1, shop.x, shop.y, shop.z-1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 0.2, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            end
        end
    end
end)

-- Check if the player is in a vehicle and within the repair radius of a mechanic shop
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local player = GetPlayerPed(-1)
        if IsPedInAnyVehicle(player, false) then
            local player_vehicle = GetVehiclePedIsIn(player, false)
            local player_coords = GetEntityCoords(player, true)
            for _, shop in ipairs(mechanic_shops) do
                if Vdist(player_coords.x, player_coords.y, player_coords.z, shop.x, shop.y, shop.z) < repair_radius then
                    if GetIsVehicleEngineRunning(player_vehicle) == false then
                        showNotification("~b~Press ~y~E ~b~to start the repair.")
                    end
                end
            end
        end
    end
end)

-- Check for the E key press
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local player = GetPlayerPed(-1)
        if IsPedInAnyVehicle(player, false) then
            local player_vehicle = GetVehiclePedIsIn(player, false)
            local player_coords = GetEntityCoords(player, true)
            for _, shop in ipairs(mechanic_shops) do
                if Vdist(player_coords.x, player_coords.y, player_coords.z, shop.x, shop.y, shop.z) < repair_radius then
                    if IsControlJustReleased(0, 51) then -- 51 is the key code for E
                        -- Choose a random mechanic name
                        local mechanic_name = mechanic_names[math.random(#mechanic_names)]
                        showNotification(mechanic_name .. " ~g~the mechanic is looking at your car.")
                        SetVehicleHandbrake(player_vehicle, true) -- Lock the vehicle
                        Citizen.Wait(8000) -- Wait for 8 seconds
                        showNotification(mechanic_name .. " ~g~is working on your car.")
                        Citizen.Wait(8000) -- Wait for 8 seconds
                        showNotification(mechanic_name .. " ~g~looks confused.")
                        Citizen.Wait(9000) -- Wait for 9 seconds
                        showNotification(mechanic_name .. " ~g~starts hitting things with a hammer.")
                        Citizen.Wait(5000) -- Wait for 5 seconds
                        showNotification(mechanic_name .. " ~g~goes to look for help.")
                        Citizen.Wait(4000) -- Wait for 4 seconds
                        showNotification(mechanic_name .. "s ~g~Manager comes back and starts working on your car.")
                        Citizen.Wait(3000) -- Wait for 3 seconds
                        showNotification("~g~The Manager is also hitting things with a hammer.")
                        Citizen.Wait(6000) -- Wait for 6 seconds
                        showNotification("~g~The manager yells for his father to come look at it.")
                        Citizen.Wait(4000) -- Wait for 4 seconds
                        showNotification("~g~His father is working on your car.")
                        Citizen.Wait(14000) -- Wait for 14 seconds
                        SetVehicleFixed(player_vehicle)
                        SetVehicleHandbrake(player_vehicle, false) -- Unlock the vehicle
                        Citizen.Wait(2000) -- Wait for 2 seconds
                        showNotification("~g~Do crash again!")
                    end
                end
            end
        end
    end
end)



