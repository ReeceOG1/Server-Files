Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if isInArea(vector3(-2170.7854003906,5139.7934570312,2.8199980258942), 100.0) then 
            DrawMarker(25, -2170.7854003906,5139.7934570312,2.8199980258942 - 0.999999, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, false)
        end
        if isInArea(vector3(-2170.7854003906,5139.7934570312,2.8199980258942), 0.9) then
            alert('Press ~INPUT_VEH_HORN~ To Exit VIP Island')
            if IsControlJustPressed(0, 51) then
                TriggerServerEvent("NOVA:VIPIslandTeleport", vector3(-746.967, 5807.38, 17.60291))
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if isInArea(vector3(-746.967, 5807.38, 17.60291), 100.0) then 
            DrawMarker(25, -746.967, 5807.38, 17.60291 - 0.999999, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 255, 255, 150, 0, 0, 2, 0, 0, 0, false)
        end
        if isInArea(vector3(-746.967, 5807.38, 17.60291), 0.9) then
            alert('Press ~INPUT_VEH_HORN~ To Enter VIP Island')
            if IsControlJustPressed(0, 51) then
                TriggerServerEvent("NOVA:VIPIslandTeleport", vector3(-2170.7854003906,5139.7934570312,2.8199980258942))
            end
        end
    end
end)