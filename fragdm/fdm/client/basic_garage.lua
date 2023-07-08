local vehicles = {}

function cFDM.setVehicle(spawnCode, vehicleNetID, vehicleHash)
    local veh = NetToVeh(vehicleNetID)
    while veh == 0 do
        Wait(100)
        veh = NetToVeh(vehicleNetID)
    end
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(vehicleNetID, false)
    SetEntityAsMissionEntity(veh) 
    SetModelAsNoLongerNeeded(vehicleHash)
    SetPedIntoVehicle(cFDM.Ped(), veh, -1)
end

function cFDM.getNearestVehicle(radius)
    local x, y, z = cFDM.getPosition()
    local ped = cFDM.Ped()
    if IsPedSittingInAnyVehicle(ped) then
        return GetVehiclePedIsIn(ped, true)
    else
        -- flags used:
        --- 8192: boat
        --- 4096: helicos
        --- 4,2,1: cars (with police)

        local veh = GetClosestVehicle(x + 0.0001, y + 0.0001, z + 0.0001, radius + 0.0001, 0, 8192 + 4096 + 4 + 2 + 1) -- boats, helicos
        if not IsEntityAVehicle(veh) then
            veh = GetClosestVehicle(x + 0.0001, y + 0.0001, z + 0.0001, radius + 0.0001, 0, 4 + 2 + 1)
        end -- cars
        return veh
    end
end

function cFDM.fixeNearestVehicle(radius)
    local veh = cFDM.getNearestVehicle(radius)
    if IsEntityAVehicle(veh) then
        SetVehicleFixed(veh)
    end
end

function cFDM.replaceNearestVehicle(radius)
    local veh = cFDM.getNearestVehicle(radius)
    if IsEntityAVehicle(veh) then
        SetVehicleOnGroundProperly(veh)
    end
end

-- try to get a vehicle at a specific position (using raycast)
function cFDM.getVehicleAtPosition(x, y, z)
    x = x + 0.0001
    y = y + 0.0001
    z = z + 0.0001

    local ray = CastRayPointToPoint(x, y, z, x, y, z + 4, 10, cFDM.Ped(), 0)
    local a, b, c, d, ent = GetRaycastResult(ray)
    return ent
end

-- return ok,vtype,name
function cFDM.getNearestOwnedVehicle(radius)
    local px, py, pz = cFDM.getPosition()
    for k, v in pairs(vehicles) do
        local x, y, z = table.unpack(GetEntityCoords(v[3], true))
        local dist = GetDistanceBetweenCoords(x, y, z, px, py, pz, true)
        -- {vtype,name,nveh} 
        if dist <= radius + 0.0001 then
            return true, v[1], v[2]
        end
    end

    return false, "", ""
end

-- return ok,x,y,z
function cFDM.getAnyOwnedVehiclePosition()
    for k, v in pairs(vehicles) do
        if IsEntityAVehicle(v[3]) then
            local x, y, z = table.unpack(GetEntityCoords(v[3], true))
            return true, x, y, z
        end
    end

    return false, 0, 0, 0
end

-- return x,y,z
function cFDM.getOwnedVehiclePosition(vtype)
    local vehicle = vehicles[vtype]
    local x, y, z = 0, 0, 0

    if vehicle then
        x, y, z = table.unpack(GetEntityCoords(vehicle[3], true))
    end

    return x, y, z
end

-- return ok, vehicule network id
function cFDM.getOwnedVehicleId(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        return true, NetworkGetNetworkIdFromEntity(vehicle[3])
    else
        return false, 0
    end
end

-- eject the ped from the vehicle
function cFDM.ejectVehicle()
    local ped = cFDM.Ped()
    if IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, veh, 4160)
    end
end

-- vehicle commands
function cFDM.vc_openDoor(vtype, door_index)
    local vehicle = vehicles[vtype]
    if vehicle then
        SetVehicleDoorOpen(vehicle[3], door_index, 0, false)
    end
end

function cFDM.vc_closeDoor(vtype, door_index)
    local vehicle = vehicles[vtype]
    if vehicle then
        SetVehicleDoorShut(vehicle[3], door_index)
    end
end

function cFDM.vc_detachTrailer(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        DetachVehicleFromTrailer(vehicle[3])
    end
end

function cFDM.vc_detachTowTruck(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        local ent = GetEntityAttachedToTowTruck(vehicle[3])
        if IsEntityAVehicle(ent) then
            DetachVehicleFromTowTruck(vehicle[3], ent)
        end
    end
end

function cFDM.vc_detachCargobob(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        local ent = GetVehicleAttachedToCargobob(vehicle[3])
        if IsEntityAVehicle(ent) then
            DetachVehicleFromCargobob(vehicle[3], ent)
        end
    end
end

function cFDM.vc_toggleEngine(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E, vehicle[3]) -- GetIsVehicleEngineRunning
        SetVehicleEngineOn(vehicle[3], not running, true, true)
        if running then
            SetVehicleUndriveable(vehicle[3], true)
        else
            SetVehicleUndriveable(vehicle[3], false)
        end
    end
end

function cFDM.vc_toggleLock(vtype)
    local vehicle = vehicles[vtype]
    if vehicle then
        local veh = vehicle[3]
        local locked = GetVehicleDoorLockStatus(veh) >= 2
        if locked then -- unlock
            SetVehicleDoorsLockedForAllPlayers(veh, false)
            SetVehicleDoorsLocked(veh, 1)
            SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
            cFDM.notify("~r~Vehicle unlocked.")
        else -- lock
            SetVehicleDoorsLocked(veh, 2)
            SetVehicleDoorsLockedForAllPlayers(veh, true)
            cFDM.notify("~g~Vehicle locked.")
        end
    end
end

