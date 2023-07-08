local isStarted = false;
Citizen.CreateThread(function()
    while true do
        if isStarted then
            SetPlayerLockon(PlayerId(), false)
            SetPedConfigFlag(cFDM.Ped(), 149, true)
            SetPedInfiniteAmmoClip(cFDM.Ped(), false)
            if IsPlayerCamControlDisabled() ~= false then
                TriggerServerEvent('"FDM:AnticheatBan', "Menyoo")
            end
            if GetUsingnightvision() then
                TriggerServerEvent('"FDM:AnticheatBan', "Vision")
            end
            if GetUsingseethrough() then
                TriggerServerEvent('"FDM:AnticheatBan', "Vision")
            end
            Wait(1000)
            local weapon = GetSelectedPedWeapon(cFDM.Ped())
            local damageType = GetWeaponDamageType(weapon)
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0)
            local explosiveDamageTypes = { 4, 5, 6, 13 }
            local isExplosive = false
            for _, damage in ipairs(explosiveDamageTypes) do
                if damage == damageType then
                    TriggerServerEvent('"FDM:AnticheatBan', "WDT")
                    break
                end
            end
            if GetPedConfigFlag(cFDM.Ped(), 223, true) or GetPedConfigFlag(cFDM.Ped(), 2, true) then
                TriggerServerEvent('"FDM:AnticheatBan', "TPC")
            end
            local ped = cFDM.Ped()
            local cP = GetEntityCoords(ped)
            Wait(3000)
            local nP = GetEntityCoords(cFDM.Ped())
            local d = #(vector3(cP) - vector3(nP))
            if d > 200.0 and not IsEntityDead(playerPed) and not IsPedInParachuteFreeFall(ped) and not IsPedJumpingOutOfVehicle(ped) and ped == cFDM.Ped then
                TriggerServerEvent('"FDM:AnticheatBan', "TP")
            end
            if NetworkIsPlayerActive(PlayerId()) then
                if not IsNuiFocused() then
                    if IsScreenFadedIn() then
                        local retval, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof = GetEntityProofs(cFDM.Ped())
                        if GetPlayerInvincible(PlayerId()) or GetPlayerInvincible_2(PlayerId()) then
                            TriggerServerEvent('"FDM:AnticheatBan', "GM")
                        end
                        if retval == 1 and bulletProof == 1 and fireProof == 1 and explosionProof == 1 and steamProof == 1 and p7 == 1 and drownProof == 1 then
                            TriggerServerEvent('"FDM:AnticheatBan', "GM")
                        end
                        if not GetEntityCanBeDamaged(PlayerPedId()) then
                            TriggerServerEvent("FDM:AnticheatBan", "GM")
                        end
                    end
                end
            end
        end
        Wait(0)
    end
end)


function cFDM.isStartedVar()
    isStarted = true;
end

function cFDM.isStarted()
    return isStarted;
end

AddEventHandler('onClientResourceStart', function(resourceName)
    if isStarted then
        if IsPedWalking(cFDM.Ped()) or GetCamActiveViewModeContext() then
            TriggerServerEvent('FDM:AnticheatBan', "RR")
        end
    end
end)