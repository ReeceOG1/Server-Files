local a = GetGameTimer()
RegisterNetEvent("GMT:spawnNitroBMX",function()
    if not tGMT.isInComa() and not tGMT.isHandcuffed() and not insideDiamondCasino then --and not isPlayerNearPrison() then
        if GetTimeDifference(GetGameTimer(), a) > 10000 then
            a = GetGameTimer()
            tGMT.notify("~g~Crafting a BMX")
            local b = tGMT.getPlayerPed()
            TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
            Wait(5000)
            ClearPedTasksImmediately(b)
            local c = GetEntityCoords(b)
            tGMT.spawnVehicle("bmx", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
        else
            tGMT.notify("~r~Nitro BMX cooldown, please wait.")
        end
    else
        tGMT.notify("~r~Cannot craft a BMX right now.")
    end
end)
RegisterNetEvent("GMT:spawnMoped",function()
    if not tGMT.isInComa() and not tGMT.isHandcuffed() and not insideDiamondCasino then --and not isPlayerNearPrison() then
        if GetTimeDifference(GetGameTimer(), a) > 10000 then
            a = GetGameTimer()
            tGMT.notify("~g~Crafting a Moped")
            local b = tGMT.getPlayerPed()
            TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
            Wait(5000)
            ClearPedTasksImmediately(b)
            local c = GetEntityCoords(b)
            tGMT.spawnVehicle("faggio", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
        else
            tGMT.notify("~r~Nitro BMX cooldown, please wait.")
        end
    else
        tGMT.notify("~r~Cannot craft a Moped right now.")
    end
end)
