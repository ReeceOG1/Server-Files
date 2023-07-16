local function a()
    local b = tGMT.getPlayerPed()
    if GetEntityHealth(b) > 102 then
        local c, d = tGMT.getNearestOwnedVehicle(8)
        if d ~= nil then
            if c then
                tGMT.vc_toggleLock(d)
                tGMT.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
                Citizen.Wait(1000)
            else
                Citizen.Wait(1000)
            end
        else
            tGMT.notify("No owned vehicle found nearby to lock/unlock")
        end
    else
        tGMT.notify("You may not lock/unlock your vehicle whilst dead.")
    end
end
Citizen.CreateThread(function()
    while true do
        if IsDisabledControlPressed(0, 82) then
            a()
        end
        Wait(0)
    end
end)
AddEventHandler("GMT:lockNearestVehicle",function()
    a()
end)