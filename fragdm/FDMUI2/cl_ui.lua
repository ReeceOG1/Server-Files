local isDisplaying = false;
local currentWeaponType = nil;
local function getWeaponType(Weapon)
    local weaponType = GetWeapontypeGroup(Weapon)
    if weaponType == 2685387236 then --Melee
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117867387115544576/knfie.png",
        })
        return;
    elseif weaponType == 416676503 then --Handgun
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117867638815727696/pistol.png",
        })
        return;
    elseif weaponType == -957766203 then -- Submachine Gun
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117869132541607966/smg.png",
        })
        return;
    elseif weaponType == 860033945 then --Shotgun
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117869132294148146/shotgun.png",
        })
        return;
    elseif weaponType == 3082541095 then --Sniper
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117867387648217288/LMG.png",
        })
        return;
    elseif weaponType == -1212426201 then
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117867387648217288/mosin.png",
        })
        return;
    elseif weaponType == 2725924767 then --Heavy Weapon
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117867387115544576/knfie.png",
        })
        return;
    elseif weaponType == 1159398588 then --Light Machine Gun
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117869131811799050/LMG.png",
        })
        return;
    elseif weaponType == 970310034 then --Assault Rifle
        SendNUIMessage({
            action = "updateWeaponIMG",
            image = "https://media.discordapp.net/attachments/1109217049177243708/1117658106483187804/ak.png",
        })
        return;
    end
end


local weaponTable = {
    [GetHashKey("weapon_musket")] = {name = "Musket"};
    [GetHashKey("WEAPON_SHOVEL")] = {name = "Shovel"};
    [GetHashKey("WEAPON_DILDO")] = {name = "Dildo"};
    [GetHashKey("WEAPON_AXE")] = {name = "Axe"};
    [GetHashKey("WEAPON_AK200")] = {name = "AK200"};
    [GetHashKey("WEAPON_MOSIN")] = {name = "Mosin"};
    [GetHashKey("WEAPON_UZI")] = {name = "Uzi"};
    [GetHashKey("WEAPON_WINCHESTER12")] = {name = "Winchester 12"};
    [GetHashKey("WEAPON_AK74KASHNAR")] = {name = "AK74 Kashnar"};
    [GetHashKey("WEAPON_M4A1")] = {name = "M4A1"};
    [GetHashKey("WEAPON_SPAR16")] = {name = "Spar 16"};
    [GetHashKey("WEAPON_SVD")] = {name = "SVD"};
    [GetHashKey("WEAPON_M1911")] = {name = "M1911"};
    [GetHashKey("WEAPON_REVOLVER357")] = {name = "Revolver 357"};
    [GetHashKey("WEAPON_TEC9")] = {name = "Tec-9"};
    [GetHashKey("WEAPON_ROOK")] = {name = "Rook 40"};
    [GetHashKey("WEAPON_UMP45")] = {name = "UMP45"};
    [GetHashKey("WEAPON_CHERRYMOSIN")] = {name = "Cherry Blossom Mosin"};
    [GetHashKey("WEAPON_BLASTXPHANTOM")] = {name = "Blast-X Phantom"};
    [GetHashKey("WEAPON_M4A1WHITENOISE")] = {name = "M4A1 Whitenoise"};
    [GetHashKey("WEAPON_M4A4FIRE")] = {name = "M4A4 Fire"};
    [GetHashKey("WEAPON_VTSGLOW")] = {name = "VTS Glow"};
    [GetHashKey("WEAPON_SPAR17")] = {name = "Spar 17"};
    [GetHashKey("WEAPON_REMINGTON700")] = {name = "Remington 700"};
    [GetHashKey("WEAPON_GLOCK")] = {name = "Glock"};
    [GetHashKey("WEAPON_REMINGTON870")] = {name = "Remington 870"};
    [GetHashKey("WEAPON_CQ300")] = {name = "CQ300"};
    [GetHashKey("WEAPON_PDHK416")] = {name = "HK416"};
    [GetHashKey("WEAPON_NERFMOSIN")] = {name = "NERFMOSIN"};
}

local function getWeaponName(Weapon)
    if weaponTable[Weapon] then
        return weaponTable[Weapon].name;
    else
        return "Undefined";
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local _, pedWeapon = GetCurrentPedWeapon(ped, 1)
        if IsPedArmed(ped, 4) and not isDisplaying then
            SendNUIMessage({
                action = "showWeaponUI",
            })
            isDisplaying = true;
        elseif isDisplaying and not IsPedArmed(ped, 4) then
            SendNUIMessage({
                action = "hideWeaponUI",
            })
            isDisplaying = false;
        end
        if isDisplaying and pedWeapon ~= -1569615261 then
            local WType = getWeaponType(pedWeapon)
            local _,cAmmo = GetAmmoInClip(ped, pedWeapon)
            local ammoCount = GetAmmoInPedWeapon(ped, pedWeapon)
            SendNUIMessage({
                action = "updateWeaponUI",
                clipAmmo = cAmmo,
                weaponAmmo = ammoCount - cAmmo,
                weaponName = getWeaponName(pedWeapon),
                weaponType = WType;
            })
        end
        Wait(0)
    end
end)


local function showKillleader(bool, first, second, third, firstKills, secondKills, thirdKills)
    if bool then
        SendNUIMessage({
            action = "showKillLeaders",
            first = first,
            second = second,
            third = third,
            firstKills = firstKills,
            secondKills = secondKills,
            thirdKills = thirdKills,
        })
    else
        SendNUIMessage({
            action = "HideKillLeaders",
        })
    end
end

RegisterNetEvent("FDM:ShowInteractionUI", function(bool)
    if bool then
        SendNUIMessage({
            action = "showUI",
        })
    else
        SendNUIMessage({
            action = "hideUI",
        })
    end
end)

RegisterNetEvent("FDM:ShowKillleaderUI", function(bool, first, second, third, firstKills, secondKills, thirdKills)
    showKillleader(bool, first, second, third, firstKills, secondKills, thirdKills)
end)