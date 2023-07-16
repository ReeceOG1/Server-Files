local jewelrycfg = module("cfg/cfg_jewelryHeist") 
local facilityEmpty = true 
local userInFacility = nil 

AddEventHandler('GMT:playerSpawn', function(user_id, source, first_spawn) 
    if first_spawn then
        TriggerClientEvent('GMT:jewelrySyncSetupReady', source, facilityEmpty) 
    end 
end) 

RegisterNetEvent('GMT:jewelrySetupHeistStart') 
AddEventHandler('GMT:jewelrySetupHeistStart', function() 
    local source = source 
    local user_id = GMT.getUserId(source) 
    if userInfacility == nil then 
        userInFacility = user_id 
        facilityEmpty = false 
        TriggerClientEvent('GMT:jewelrySyncSetupReady', -1, facilityEmpty) 
        for k,v in pairs(jewelrycfg.aiSpawnLocs) do 
            local pos = v.coords 
            local ped = CreatePed(4, GetHashkey("s_m_y_blackops_03"), pos.x, pos.y, pos.z, v.heading, false, true) 
            GiveWeaponToPed(ped, v.weaponHash, 999, false, true) 
            TriggerClientEvent('GMT:jewelryMakePedsAttack', source, NetworkGetNetworkIdFromEntity(ped)) 
        end 
    end 
end) 

RegisterNetEvent('GMT:jewelrySetupHeistleave')
AddEventHandler('GMT:jewelrySetupHeistLeave', function() 
    local source = source 
    local user_id GMT.getUserId(source) 
    if userInFacility == user_id then 
        userInFacility = nil 
        facilityEmpty = true 
        TriggerClientEvent('GMT:jewelrySyncSetupReady', -1, facilityEmpty)
        TriggerClientEvent('GMT:jewelryRemoveDeviceArea', source) 
    end
end) 