globalOnTacoDuty = false
local a = false
local b
local c
local d = {}
local e = {}
local f = {}
RegisterNetEvent("GMT:removeTacoSeller",function(g)
    d[g] = nil
    refreshMarkersAndBlips()
end)
RegisterNetEvent("GMT:sendClientTacoData",function(h)
    d = h
    refreshMarkersAndBlips()
end)
RegisterNetEvent("GMT:toggleTacoJob",function(i)
    globalOnTacoDuty = i
end)
RegisterCommand("taco",function(j, k, l)
    local m = GetEntityCoords(tGMT:getPlayerPed())
    local n = GetVehiclePedIsIn(tGMT:getPlayerPed())
    local o = GetEntityModel(n)
    if not a then
        if globalOnTacoDuty then
            if o == GetHashKey("taco") then
                tGMT.notify("~g~Now selling tacos!")
                SetVehicleDoorOpen(n, 5, true, true)
                tacoVehicle = n
                a = true
                FreezeEntityPosition(n, true)
                TriggerServerEvent("GMT:addTacoSeller", m, 15000)
                while GetVehiclePedIsIn(tGMT:getPlayerPed(), false) == tacoVehicle do
                    Wait(100)
                end
                tGMT.notify("~r~Stopped selling tacos!")
                SetVehicleDoorShut(n, 5, true)
                FreezeEntityPosition(n, false)
                tacoVehicle = nil
                a = false
                TriggerServerEvent("GMT:RemoveMeFromTacoPositions")
            else
                tGMT.notify("~r~Stopped selling tacos!")
                SetVehicleDoorShut(n, 5, true)
                tacoVehicle = nil
                a = false
                TriggerServerEvent("GMT:RemoveMeFromTacoPositions")
            end
        else
            tGMT.notify("~r~You do not have the taco seller job!")
        end
    end
end,false)
Citizen.CreateThread(function()
    while true do
        if tacoVehicle then
            SetVehicleEngineOn(tacoVehicle, false, true, false)
        end
        Wait(0)
    end
end)
function refreshMarkersAndBlips()
    for p, q in pairs(e) do
        tGMT.removeMarker(q)
    end
    for p, r in pairs(f) do
        tGMT.removeBlip(r)
    end
    e = {}
    f = {}
    for g, s in pairs(d) do
        table.insert(f, tGMT.addBlip(s.position.x, s.position.y, s.position.z, 52, 17, "Taco Seller"))
        s.position = s.position - GetEntityForwardVector(PlayerPedId()) * 1.2
        table.insert(e,tGMT.addMarker(s.position.x, s.position.y, s.position.z - 1, 5.0, 5.0, 2.0, 255, 100, 0, 70, 50))
    end
end
Citizen.CreateThread(function()
    while true do
        local m = GetEntityCoords(tGMT:getPlayerPed())
        for g, s in pairs(d) do
            local t = #(m - s.position)
            if t < 7 then
                b = g
                c = s.amount
            end
            while #(GetEntityCoords(tGMT:getPlayerPed()) - s.position) <= 8 do
                Wait(100)
            end
            b = nil
            c = nil
        end
        Wait(5000)
    end
end)
Citizen.CreateThread(function()
    while true do
        if not a and b then
            drawNativeNotification("Press ~INPUT_CONTEXT~ to buy a taco for ~g~£" .. c)
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("GMT:payTacoSeller", b)
                Wait(50)
            end
        end
        Wait(0)
    end
end)