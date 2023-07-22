-- got bored someone have fun and finish it :)

local c = {"bulker", "a_c_chimp"}
local boat = nil
RegisterCommand('testcargo', function()
    if tARMA.getUserId()==1 then 
        for h, i in pairs(c) do
            tARMA.loadModel(i)
        end
        tARMA.notify('spawning cargoship')
        TriggerEvent('chatMessage', "^0Cargo Ship | ", {66, 72, 245}, "A cargo ship has appeared at the docks carrying various containers of guns and precious stones.", "alert")
        local n = vector3(1168.746, -3548.871, 23.447867)
        local fC = vector3(1149.964, -3836.471, 23.136482)
        boat = CreateVehicle("bulker", n.x, n.y, n.z, 100.0, false, true)
        DecorSetInt(boat, tARMA.getZy(), 955)
        SetEntityHeading(boat, q)
        SetVehicleDoorsLocked(boat, 2)
        SetVehicleEngineOn(boat, true, true, false)
        SetEntityProofs(boat, true, false, true, false, false, false, false, false)
        Wait(10000)
        tARMA.notify('driving to coords')
        local r = CreatePedInsideVehicle(boat, 1, "a_c_chimp", -1, false, true)
        SetBlockingOfNonTemporaryEvents(r, true)
        SetPedRandomComponentVariation(r, false)
        SetPedKeepTask(r, true)
        TaskVehicleDriveToCoord(r,boat,fC.x, fC.y, fC.z,60.0,0,"bulker",262144,15.0,-1.0)
        local s = AddBlipForEntity(boat)
        SetBlipSprite(s, 410)
        SetBlipColour(s, 1)
        local t = vector2(fC.x, fC.y)
        local u = vector2(GetEntityCoords(boat).x, GetEntityCoords(boat).y)
        while #(u - t) > 5.0 do
            Wait(100)
            u = vector2(GetEntityCoords(boat).x, GetEntityCoords(boat).y)
        end
        TaskVehicleDriveToCoord(r, boat, 0.0, 0.0, 500.0, 60.0, 0, "bulker", 262144, -1.0, -1.0)
        RemoveBlip(s)
        DeleteVehicle(boat)
        DeleteEntity(r)
        SetEntityAsNoLongerNeeded(r)
        SetEntityAsNoLongerNeeded(boat)
        boat = nil
        TriggerEvent('chatMessage', "^0Cargo Ship | ", {66, 72, 245}, "The cargo ship has been raided and lost all GPS services.", "alert")
    end
end)

Citizen.CreateThread(function()
    local prevBoatCoords = vector3(0.0, 0.0, 0.0)
    local s = nil
    while true do
        Citizen.Wait(0)
        if boat ~= nil then
            if #(GetEntityCoords(boat) - prevBoatCoords) > 5.0 then
                RemoveBlip(s)
                s = AddBlipForRadius(GetEntityCoords(boat).x, GetEntityCoords(boat).y, GetEntityCoords(boat).z, 80.0)
                SetBlipColour(s, 1)
                SetBlipAlpha(s, 180)
                prevBoatCoords = GetEntityCoords(boat)
            end
        elseif s ~= nil then
            RemoveBlip(s)
            s = nil
        end
    end
end)
