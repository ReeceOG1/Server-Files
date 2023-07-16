-- Set damageLevel to 100.0 to activate airbags when the vehicle is no longer drivable
-- This is recommended to stay between 700 - 999.0
-- Vehicles start at 1000.0 damage level - then gradually reduce
local damageLevel = 630.0

-- This is the amount of seconds before the airbags automatically disappear - the /airbag command one does not disappear
-- If you set this to -1, all airbags will stay forever, even when the vehicle is deleted (so I recommend making these expire)
local secondsToExpire = 10
local modelName = `prop_car_airbag`

local vehicleAirbags = {}
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped and GetVehicleEngineHealth(vehicle) <= damageLevel and vehicleAirbags[vehicle] == nil then
            local class = GetVehicleClass(vehicle)
            if class ~= 8 and class ~= 16 and class ~= 15 and class ~= 13 then
				TriggerServerEvent("NOVA:PlaySound","airbag")
                createAirbags(vehicle, true)
            end
        end
        Wait(1000)
    end
end)

function createAirbags(vehicle, temp)
    vehicleAirbags[vehicle] = vehicle
    local driverSeat = GetEntityBoneIndexByName(vehicle, "seat_dside_f")
    local passengerSeat = GetEntityBoneIndexByName(vehicle, "seat_pside_f")
    loadModel(modelName)
    local coords = GetEntityCoords(ped)
    local airbag1 = CreateObject(modelName, coords.x, coords.y, coords.z, true, true, true)
    local airbag2 = CreateObject(modelName, coords.x, coords.y, coords.z, true, true, true)
    while not DoesEntityExist(airbag1) or not DoesEntityExist(airbag2) do Wait(0) end
    SetModelAsNoLongerNeeded(modelName)
    AttachEntityToEntity(airbag1, vehicle, driverSeat, 0.0, 0.30, 0.40, 90.0, 0.0, 0.0, true, true, false, false, 2, true)
    AttachEntityToEntity(airbag2, vehicle, passengerSeat, 0.0, 0.50, 0.40, 90.0, 0.0, 0.0, true, true, false, false, 2, true)
    if temp then
        local deleted = false
        
        Citizen.SetTimeout(secondsToExpire * 1000, function()
            if not deleted then
                NetworkRequestControlOfEntity(airbag1)
                NetworkRequestControlOfEntity(airbag2)
                if DoesEntityExist(airbag1) then DeleteEntity(airbag1) end
                if DoesEntityExist(airbag2) then DeleteEntity(airbag2) end
                deleted = true
            end
        end)
        Citizen.CreateThread(function()
            while not deleted do
                if not DoesEntityExist(vehicle) then
                    NetworkRequestControlOfEntity(airbag1)
                    NetworkRequestControlOfEntity(airbag2)
                    if DoesEntityExist(airbag1) then DeleteEntity(airbag1) end
                    if DoesEntityExist(airbag2) then DeleteEntity(airbag2) end
                    deleted = true
                end
                Wait(1000)
            end
        end)
    end      
end

function loadModel(modelName)
    RequestModel(modelName)
    while not HasModelLoaded(modelName) do
        Wait(0)
    end
end

local vehicleAirbags = {}
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped and GetVehicleEngineHealth(vehicle) <= main.damageLevel and vehicleAirbags[vehicle] == nil then
            local class = GetVehicleClass(vehicle)
            local model = GetEntityModel(vehicle)
            local allowed = true
            for k, v in pairs(main.exemptVehicleClasses) do
                if class == main.exemptVehicleClasses[k] then
                    allowed = false
                end
            end
            for k, v in pairs(main.exemptVehicleModels) do
                if model == main.exemptVehicleModels[k] then
                    allowed = false
                end
            end
            if allowed then
                vehicleAirbags[vehicle] = vehicle
                TriggerEvent("createAirbags", vehicle, true)
            end
        end
        Wait(1000)
    end
end)