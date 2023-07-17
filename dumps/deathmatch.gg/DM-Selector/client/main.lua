local display = false

local Stats = {
	'MP0_STAMINA',
	'MP0_STRENGTH',
	'MP0_LUNG_CAPACITY',
	'MP0_WHEELIE_ABILITY',
	'MP0_FLYING_ABILITY',
	'MP0_SHOOTING_ABILITY',
	'MP0_STEALTH_ABILITY'
}

RegisterNUICallback("Extinction", function(data)
    -- print("Spawning Extinction")
    -- TriggerEvent("SetSelectedZone", "Glife")
    -- FreezeEntityPosition(PlayerPedId(), false)
    -- SetEntityCoords(PlayerPedId(), 1534.709, 1702.526, 109.7114)
    -- TriggerEvent("ResetElements")
    -- setStats(50)
    -- SetDisplay(false)
end)

RegisterNUICallback("Casual", function(data)
    TriggerEvent("SetSelectedZone", "Casual")
    TriggerEvent("ResetElements")
    TriggerServerEvent("DM-GunGame:Module:ForceLeave")
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityCoords(PlayerPedId(), 3521.367, 3650.503, 41.34028)
    setStats(50)
    SetDisplay(false)
end)

RegisterNUICallback("American", function(data)
    TriggerEvent("SetSelectedZone", "American")
    TriggerEvent("ResetElements")
    TriggerServerEvent("DM-GunGame:Module:ForceLeave")
    FreezeEntityPosition(PlayerPedId(), false)
    setStats(100)
    SetDisplay(false)
end)

RegisterNUICallback("gunGame", function(data)
    TriggerEvent("SetSelectedZone", "gunGame")
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent("DM-GunGame:Module:ForceLeave")
    TriggerServerEvent("DM-GunGame:Module:Join")
    DoScreenFadeOut(500)
    TriggerEvent("ResetElements")
    setStats(50)
    SetDisplay(false)
end)

RegisterNUICallback("exit", function(data)
    print("exit")
    toggleDisplay()
end)

function setStats(Cooldown)
    for _, s in ipairs(Stats) do
        StatSetInt(s, Cooldown, true)
    end
end

function toggleDisplay()
    SetDisplay(not display)
end

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

RegisterNetEvent("FirstSpawn")
AddEventHandler("FirstSpawn", function()
    SetEntityCoords(PlayerPedId(), -1610.915, 5260.47, 3.973602)
    FreezeEntityPosition(PlayerPedId(), true)
    SetDisplay(true)
end)


RegisterCommand("lobby", function()
    SetDisplay(true)
    SetEntityCoords(PlayerPedId(), -1610.915, 5260.47, 3.973602)
    FreezeEntityPosition(PlayerPedId(), true)
    RemoveAllPedWeapons(PlayerPedId(), true)
end)