local cfg = {}

cfg.Buttons = {
    ["Ban"] = {function(self)
    local reason = nil
    local hours = nil
    AddTextEntry('FMMC_MPM_NC', "Enter Reason for Ban Player")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then 
            reason = result
        end
    end
    AddTextEntry('FMMC_MPM_NC', "Enter Hours for Ban (-1 is perm ban)")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then 
            hours = tonumber(result)
        end
    end
    TriggerServerEvent('FDMAdmin:Ban', self, hours, reason)
    end, "player.ban"},
    ["No Warning Kick"] = {function(self)
        AddTextEntry('FMMC_MPM_NC', "Enter Reason to Kick Player")
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            if result then 
                result = result
                TriggerServerEvent('FDMAdmin:Kick', self, result, true)
            end
        end
    end, "player.kick"},
    ["Revive"] = {function(self)
        TriggerServerEvent('FDMAdmin:Revive', self)
    end, "player.revive"},
    ["Slap"] = {function(self)
        TriggerServerEvent('FDMAdmin:SlapPlayer', self)
    end, "player.slap"},
    ["Spectate"] = {function(self)
        TriggerServerEvent('FDMAdmin:SpectatePlr', self)
    end, "player.spectate"},
    ["Add Car"] = {function(self)
        AddTextEntry('FMMC_MPM_NC', "Enter the car spawncode")
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            if result then 
                TriggerServerEvent('FDMAdmin:AddCar', self, result)
            end
        end
    end, "player.addcar"},
    ["TP To Player"] = {function(self)
        TriggerServerEvent('FDMAdmin:TPTo', self)
    end, "player.tpto"},
    ["Bring Player"] = {function(self)
        TriggerServerEvent('FDMAdmin:Bring', self)
    end, "player.tpbring"},
    ["Add Group"] = {function(self)
        AddTextEntry('FMMC_MPM_NC', "Enter the group name")
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            if result then 
                TriggerServerEvent('FDMAdmin:AddGroup', self, result)
            end
        end
    end, "player.addGroups"},
}

cfg.MiscButtons = {
    ["Offline Unban"] = {function(self)
        TriggerServerEvent("FDM:OfflineUnban")
    end, "player.unban", "Offline Unban"},
    ["Offline Ban"] = {function(self)
        TriggerServerEvent("FDM:OfflineBan")
    end, "player.ban", "Offline Unban"},
    ["Entity Cleanup"] = {function(self)
        TriggerServerEvent('FDMAdmin:PropCleanup')
    end, "player.propcleanup", "Gets rid of those pesky modders ramps! (Onesync)"},
    ["Entity Cleanup Gun"] = {function(self)
        TriggerServerEvent('FDMAdmin:EntityCleanupGun')
    end, "player.propcleanup", "Makes your current Gun a Cleanup Gun! Deletes anything you aim at"},
    ["Deattach Entity Cleanup"] = {function(self)
        TriggerServerEvent('FDMAdmin:DeAttachEntity')
    end, "player.propcleanup", "Gets rid of those pesky attached hamburgers! (Onesync)"},
    ["Vehicle Cleanup"] = {function(self)
        TriggerServerEvent('FDMAdmin:VehCleanup')
    end, "player.vehcleanup", "Gets rid of those vehicles! (Onesync)"},
    ["Ped Cleanup"] = {function(self)
        TriggerServerEvent('FDMAdmin:PedCleanup')
    end, "player.pedcleanup", "Gets rid of those peds! (Onesync)"},
    ["All Cleanup"] = {function(self)
        TriggerServerEvent('FDMAdmin:CleanAll')
    end, "player.cleanallcleanup", "When your server is so fucked you need to cleanup everything. (Onesync)"},
    ["Shutdown Server"] = {function(self)
        TriggerServerEvent('FDMAdmin:ServerShutdown')
    end, "player.shutdownserver", "Shuts down the server!"},
    ["TP to Waypoint"] = {function(self)
        TriggerEvent("TpToWaypoint")
    end, "player.tptowaypoint", "Teleports you to a waypoint"},
    ["Noclip"] = {function(self)
        cFDM.toggleNoclip({})
    end, "player.noclip", "Teleports you to a waypoint"},
    ["Spawn Vehicle"] = {function(self)
        AddTextEntry('FMMC_MPM_NC', "Enter the car spawncode name")
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local result = GetOnscreenKeyboardResult()
            if result then 
                local mhash = GetHashKey(result)
                local i = 0
                while not HasModelLoaded(mhash) and i < 10000 do
                    RequestModel(mhash)
                    Citizen.Wait(10)
                    i = i+1
                    if i > 10000 then 
                        cFDM.notify('~r~Model could not be loaded!')
                        break 
                    end
                end
                -- spawn car
                if HasModelLoaded(mhash) then
                    local x,y,z = cFDM.getPosition()
                    if pos then
                        x,y,z = table.unpack(pos)
                    end
                    local nveh = CreateVehicle(mhash, x,y,z+0.5, 0.0, true, false)
                    SetVehicleOnGroundProperly(nveh)
                    SetEntityInvincible(nveh,false)
                    SetPedIntoVehicle(cFDM.Ped(),nveh,-1) -- put player inside
                    SetVehicleNumberPlateText(nveh, "P "..cFDM.getRegistrationNumber())
                    --Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
                    SetVehicleHasBeenOwnedByPlayer(nveh,true)
                    local nid = NetworkGetNetworkIdFromEntity(nveh)
                    SetNetworkIdCanMigrate(nid,cfg.vehicle_migration)
                end
            end
        end
    end, "admin.spawnveh", "Spawns you a car"},
}
return cfg
