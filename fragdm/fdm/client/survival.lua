
function cFDM.Ped()
    return PlayerPedId()
end

function cFDM.varyHealth(variation)
    local ped = cFDM.Ped()
    local n = math.floor(GetEntityHealth(ped) + variation)
    TriggerEvent('FDM:IsInComa', false)
    SetEntityHealth(ped, n)
end

function cFDM.getHealth()
    return GetEntityHealth(cFDM.Ped())
end

function cFDM.setHealth(health)
    local n = math.floor(health)
    SetEntityHealth(cFDM.Ped(), n)
end

function cFDM.setArmour(armour)
    SetPedArmour(PlayerPedId(), armour)
end

function cFDM.setFriendlyFire(flag)
    NetworkSetFriendlyFireOption(flag)
    SetCanAttackFriendly(cFDM.Ped(), flag, flag)
end

local in_coma = false
Citizen.CreateThread(function() 
    if FDMConfig.EnableComa then 
        while true do
            Citizen.Wait(0)
            local ped = cFDM.Ped()
            local health = GetEntityHealth(ped)
            if IsPedDeadOrDying(cFDM.Ped(), 1) then
                if not in_coma then
                    in_coma = true;
                    DoScreenFadeOut(250)
                    Wait(2500)
                    local killer = nil;
                    if IsPedDeadOrDying(cFDM.Ped(), 1) then
                        killer = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedKiller(cFDM.Ped())))
                    else
                        killer = false;
                    end
                    TriggerServerEvent("FDM:Respawn", killer)
                    DoScreenFadeIn(600)
                end
            end
        end
    end
end)



local SelectedWeapon = nil;
function cFDM.SetSelectedWeapon(Weapon)
    SelectedWeapon = Weapon
end

function cFDM.GetSelectedWeapon()
    return SelectedWeapon
end

function cFDM.revivePlayer()
    local x, y, z = cFDM.getPosition()
    NetworkResurrectLocalPlayer(x, y, z, true, true, false)
    SetEntityHealth(PlayerPedId(), 200)
    in_coma = false;
end

function cFDM.ResetComa()
    in_coma = false; 
end

function cFDM.isInComa()
    return in_coma
end

Citizen.CreateThread(function() 
    while true do
        HideHudComponentThisFrame(13)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(2)
        HideHudComponentThisFrame(22)
        HideHudComponentThisFrame(21)
        RestorePlayerStamina(PlayerId(), 1.0)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
        Wait(0)
    end
end)



function cFDM.FormatPrice(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
end