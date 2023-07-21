local a = {
    onJob = false,
    spawnVehicleVector = vector3(455.00802612304, -582.24096679688, 28.49980354309),
    startVector = vector3(429.52169799804, -587.45068359375, 29.499813079834),
    tempMarker = 0,
    tempBlip = 0,
    tempVehicle = 0,
    tempObject = 0,
    cashEarned = 0,
    stopNumber = 0
}
local b = 10
RegisterNetEvent(
    "GMT:beginBusJob",
    function()
        a.tempVehicle =
            tGMT.spawnVehicle(
            "bus",
            a.spawnVehicleVector.x,
            a.spawnVehicleVector.y,
            a.spawnVehicleVector.z,
            343,
            true,
            true,
            true
        )
        a.onJob = true
        tGMT.notify("~g~Bus Job started, exit the bus station and head to the first bus stop.")
        while a.onJob do
            DrawGTATimerBar("PASSENGERS:", a.stopNumber .. "/" .. b, 2)
            DrawGTATimerBar("~g~EARNED:", "£" .. getMoneyStringFormatted(a.cashEarned), 1)
            Wait(0)
        end
    end
)
RegisterNetEvent(
    "GMT:busJobEnd",
    function()
        tGMT.notify("~g~Shift complete.")
        DeleteVehicle(GetVehiclePedIsIn(tGMT.getPlayerPed(), false))
        DeleteVehicle(a.tempVehicle)
        a.onJob = false
        a.tempMarker = 0
        a.tempBlip = 0
        a.tempVehicle = 0
        a.tempObject = 0
        a.cashEarned = 0
        a.stopNumber = 0
    end
)
RegisterNetEvent(
    "GMT:busJobReachedNextStop",
    function(c, d)
        local e = a.tempVehicle
        a.stopNumber = a.stopNumber + 1
        if d then
            a.cashEarned = a.cashEarned + d
        end
        Citizen.CreateThread(
            function()
                while e do
                    SetVehicleEngineOn(e, false, true, false)
                    Wait(0)
                end
            end
        )
        if a.tempMarker then
            tGMT.removeMarker(a.tempMarker)
        end
        SetVehicleDoorOpen(e, 0, false, false)
        SetVehicleDoorOpen(e, 1, false, false)
        SetVehicleDoorOpen(e, 2, false, false)
        SetVehicleDoorOpen(e, 3, false, false)
        SetVehicleDoorOpen(e, 4, false, false)
        SetVehicleDoorOpen(e, 5, false, false)
        RemoveBlip(a.tempBlip)
        SetTimeout(
            2500,
            function()
                SetVehicleDoorShut(e, 0, false)
                SetVehicleDoorShut(e, 1, false)
                SetVehicleDoorShut(e, 2, false)
                SetVehicleDoorShut(e, 3, false)
                SetVehicleDoorShut(e, 4, false)
                SetVehicleDoorShut(e, 5, false)
                e = nil
            end
        )
    end
)
RegisterNetEvent(
    "GMT:busJobSetNextBlip",
    function(f)
        a.tempBlip = AddBlipForCoord(f.x, f.y, f.z)
        SetBlipSprite(a.tempBlip, 1)
        SetBlipRoute(a.tempBlip, true)
        a.tempMarker = tGMT.addMarker(f.x, f.y, f.z - 1, 2.0, 2.0, 1.0, 200, 20, 0, 50, 50)
    end
)
RegisterNetEvent("GMT:onClientSpawn")
AddEventHandler(
    "GMT:onClientSpawn",
    function(g, h)
        if h then
            local i = function(j)
                drawNativeNotification("Press ~INPUT_PICKUP~ to start your bus shift")
            end
            local k = function(j)
            end
            local l = function(j)
                if IsControlJustReleased(1, 38) and not a.onJob then
                    TriggerServerEvent("GMT:attemptBeginBusJob")
                end
            end
            tGMT.addBlip(a.startVector.x, a.startVector.y, a.startVector.z, 106, 1, "Bus Driver Job")
            tGMT.addMarker(
                a.startVector.x,
                a.startVector.y,
                a.startVector.z - 1,
                1.0,
                1.0,
                1.0,
                255,
                0,
                0,
                70,
                50,
                39,
                false,
                false,
                true
            )
            tGMT.createArea("bus", a.startVector, 1.5, 6, i, k, l, {})
        end
    end
)
