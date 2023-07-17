local spawnProtection = false;
local spawnProtectionVeh = false;
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehiclePool = GetGamePool('CVehicle')
        for i = 1, #vehiclePool do 
            if GetPedInVehicleSeat(vehiclePool[i], -1) ~= 0 then
                if #(GetEntityCoords(vehiclePool[i]) - GetEntityCoords(ped)) < 10.0 then
                    SetEntityNoCollisionEntity(vehiclePool[i], ped, true)
                end
            end
        end
        if spawnProtection then 
            spawnProtectionVeh = GetVehiclePedIsIn(ped, false)
            if spawnProtectionVeh ~= 0 then
                SetEntityAlpha(spawnProtectionVeh, 102, false)
                SetEntityAlpha(cFDM.Ped(), 102, false)
                SetEntityInvincible(veh, true)
                local vehiclePool = GetGamePool('CVehicle')
                for i = 1, #vehiclePool do
                    if GetPedInVehicleSeat(vehiclePool[i], -1) ~= 0 then
                        if #(GetEntityCoords(vehiclePool[i]) - GetEntityCoords(ped)) < 10.0 then
                            SetEntityNoCollisionEntity(vehiclePool[i], spawnProtectionVeh, true)
                        end
                    end
                end
            end
        end
        Wait(0)
    end
end)


function cFDM.setSpawnProtection(bool)
    spawnProtection = bool;
    if spawnProtection then
        Wait(2500)
        spawnProtection = false;
        SetEntityInvincible(veh, false)
        ResetEntityAlpha(spawnProtectionVeh)
        ResetEntityAlpha(cFDM.Ped())
        spawnProtection = false;
    end
end