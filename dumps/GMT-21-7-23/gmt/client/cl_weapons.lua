local a = module("cfg/weapons")
Citizen.CreateThread(
    function()
        for b, c in pairs(a.weapons) do
            AddTextEntry(b, c.name)
        end
    end
)
allowedWeapons = {}
weapons = module("cfg/weapons")
function tGMT.allowWeapon(d, e)
    if e == nil then
        e = 0
    end
    if allowedWeapons[d] then
        allowedWeapons[d] = {ammo = allowedWeapons[d].ammo + e, setFrame = GetFrameCount()}
    else
        allowedWeapons[d] = {ammo = e, setFrame = GetFrameCount()}
    end
end
function tGMT.removeWeapon(d)
    if allowedWeapons[d] then
        allowedWeapons[d] = nil
    end
end
function tGMT.checkWeapon(d)
    if allowedWeapons[d] == nil and not weapon_additions then
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(d))
        TriggerServerEvent("GMT:acType2", d)
        return
    end
end
function tGMT.getAllowedWeapons()
    return allowedWeapons
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            for f, g in pairs(weapons.weapons) do
                if GetHashKey(f) and HasPedGotWeapon(PlayerPedId(), GetHashKey(f), false) then
                    tGMT.checkWeapon(f)
                end
            end
        end
    end
)
weapon_additions = false
function tGMT.giveWeapons(h, i)
    local j = PlayerPedId()
    if i then
        RemoveAllPedWeapons(j, true)
        allowedWeapons = {}
    end
    weapon_additions = true
    for k, l in pairs(h) do
        local m = GetHashKey(k)
        local n = l.ammo or 0
        tGMT.allowWeapon(k, n)
        GiveWeaponToPed(j, m, n, false)
        local f = l.attachments or {}
        for o, p in pairs(f) do
            GiveWeaponComponentToPed(j, k, p)
        end
    end
    weapon_additions = false
end
function tGMT.isPlayerArmed()
    local j = PlayerPedId()
    for b, c in pairs(a.weapons) do
        if HasPedGotWeapon(j, c.hash) then
            return true
        end
    end
    return false
end
function tGMT.hasWeapon(q)
    if HasPedGotWeapon(PlayerPedId(), string.upper(q)) then
        return true
    end
    return false
end
function tGMT.getWeapons()
    local j = PlayerPedId()
    local r = {}
    local h = {}
    for b, c in pairs(a.weapons) do
        if HasPedGotWeapon(j, c.hash) then
            local l = {}
            local s = GetPedAmmoTypeFromWeapon(j, c.hash)
            if r[s] == nil then
                r[s] = true
                l.ammo = GetAmmoInPedWeapon(j, c.hash)
            else
                l.ammo = 0
            end
            h[b] = l
        end
    end
    return h
end
function tGMT.removeAllWeapons()
    RemoveAllPedWeapons(tGMT.getPlayerPed())
end
function tGMT.setWeaponAmmo(t, e)
    SetPedAmmoByType(PlayerPedId(), GetPedAmmoTypeFromWeapon(PlayerPedId(), GetHashKey(t)), e)
end
local u = GetGameTimer()
RegisterCommand(
    "storecurrentweapon",
    function()
        if u + 3000 < GetGameTimer() then
            u = GetGameTimer()
            if
                HasPedGotWeapon(PlayerPedId(), "WEAPON_PISTOL50") or
                    HasPedGotWeapon(PlayerPedId(), "WEAPON_MACHINEPISTOL")
             then
            else
                local o, m = GetCurrentPedWeapon(PlayerPedId())
                local k = a.weaponHashToModels[m]
                TriggerServerEvent("GMT:forceStoreSingleWeapon", k)
            end
        else
            tGMT.notify("~r~Store weapons cooldown, please wait.")
        end
    end
)
local v = {GetHashKey("WEAPON_UNARMED"), GetHashKey("WEAPON_PETROLCAN"), GetHashKey("WEAPON_SNOWBALL")}
Citizen.CreateThread(
    function()
        while true do
            local w = allowedWeapons
            local x = GetFrameCount()
            local y = tGMT.isPedScriptGuidChanging()
            local r = {}
            if weapon_additions then
                return
            end
            for b, c in pairs(w) do
                local s = GetPedAmmoTypeFromWeapon(PlayerPedId(), b)
                if s ~= 0 then
                    if r[s] == nil then
                        r[s] = true
                        if x > w[b].setFrame and not y then
                            local B = GetAmmoInPedWeapon(PlayerPedId(), b)
                            if B > w[b].ammo then
                                TriggerServerEvent("GMT:AnticheatBan", 17, b)
                            end
                            w[b].ammo = B
                        end
                    else
                        w[b].ammo = B
                    end
                end
            end
            Wait(2000)
        end
    end
)
AddEventHandler(
    "onResourceStop",
    function(z)
        if z == GetCurrentResourceName() then
            RemoveAllPedWeapons(PlayerPedId(), true)
        end
    end
)
