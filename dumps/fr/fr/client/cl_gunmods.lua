--[[local a = module("cfg/cfg_gunmods")
local b = {}
local c = {}
local d = {}
givenAttachmentsToRemove = {}
local e = {}
local f
local g = 0
local h = 0
globalIsInModShop = false
RMenu.Add(
    "frgunmods",
    "main",
    RageUI.CreateMenu(
        "",
        "Gun Mods",
        tFR.getRageUIMenuWidth(),
        tFR.getRageUIMenuHeight(),
        "fr_gunstoreui",
        "fr_gunstoreui"
    )
)
RMenu.Add(
    "frgunmods",
    "attachments",
    RageUI.CreateSubMenu(
        RMenu:Get("frgunmods", "main"),
        "",
        "Gun Mods",
        tFR.getRageUIMenuWidth(),
        tFR.getRageUIMenuHeight(),
        "fr_gunstoreui",
        "fr_gunstoreui"
    )
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        RageUI.IsVisible(
            RMenu:Get("frgunmods", "main"),
            true,
            true,
            true,
            function()
                for i = 1, #b do
                    local j = b[i]
                    RageUI.ButtonWithStyle(
                        WeaponNames[tostring(GetHashKey(j))],
                        WeaponNames[tostring(GetHashKey(j))],
                        {RightLabel = "→→→"},
                        true,
                        function(k, l, m)
                            if m then
                                c = getWeaponSupportedAttachments(j)
                                h = j
                                if e[j] == nil then
                                    e[j] = {}
                                end
                                if givenAttachmentsToRemove[j] == nil then
                                    givenAttachmentsToRemove[h] = {}
                                end
                                f = FR.spawnWeaponObject(j, d[4].x, d[4].y, d[4].z)
                            end
                        end,
                        RMenu:Get("frgunmods", "attachments")
                    )
                end
            end
        )
        RageUI.IsVisible(
            RMenu:Get("frgunmods", "attachments"),
            true,
            true,
            true,
            function()
                for i = 1, #c do
                    local n = c[i]
                    local o = {RightLabel = "£" .. getMoneyStringFormatted(a.components[n][2])}
                    if table.has(e[h], n) then
                        o = {RightBadge = RageUI.BadgeStyle.Gun}
                    end
                    RageUI.ButtonWithStyle(
                        a.components[n][1],
                        a.components[n][1],
                        o,
                        true,
                        function(k, l, m)
                            if m then
                                if not table.has(e[h], n) then
                                    TriggerServerEvent("FR:tryBuyAttachment", h, n, a.components[n][2])
                                else
                                    tFR.notify("~r~You already have this attachment")
                                end
                            end
                            if l then
                                if g ~= i then
                                    if not HasPedGotWeaponComponent(PlayerPedId(), h, n) then
                                        tFR.giveWeaponComponent(h, n)
                                        givenAttachmentsToRemove[h][#givenAttachmentsToRemove[h] + 1] = n
                                    end
                                    if g ~= nil then
                                        if table.has(givenAttachmentsToRemove[h], c[g]) and not table.has(e[h], c[g]) then
                                            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(h), GetHashKey(c[g]))
                                        end
                                        RemoveWeaponComponentFromWeaponObject(f, GetHashKey(c[g]))
                                    end
                                    GiveWeaponComponentToWeaponObject(f, n)
                                    g = i
                                end
                            end
                        end
                    )
                end
            end
        )
    end
)
AddEventHandler(
    "FR:onClientSpawn",
    function(p, q)
        if q then
            local r = function(s)
                d = s.shop
                b = tFR.getWeapons()
                for t, u in pairs(b) do
                    e[t] = getAllWeaponAttachments(u)
                end
                showModsShop(true)
                globalIsInModShop = true
            end
            local v = function()
                globalIsInModShop = false
                if f ~= nil then
                    DeleteObject(f)
                end
                for t, u in pairs(givenAttachmentsToRemove) do
                    for i = 1, #givenAttachmentsToRemove[t] do
                        local n = givenAttachmentsToRemove[t][i]
                        if not table.has(e[t], n) then
                            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(t), GetHashKey(n))
                        end
                    end
                end
                showModsShop(false)
            end
            local w = function()
            end
            for i = 1, #a.shops do
                local x = a.shops[i]
                tFR.createArea("gunmods_" .. i, x[2], 1.5, 6, r, v, w, {shop = x})
            end
        end
    end
)
RegisterNetEvent(
    "FR:updateBoughtAttachments",
    function(n, j)
        e[j][#e[j] + 1] = n
    end
)
function showModsShop(y)
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("frgunmods", "main"), y)
end
function getWeaponSupportedAttachments(j)
    local z = {}
    for t, u in pairs(a.components) do
        if DoesWeaponTakeWeaponComponent(GetHashKey(j), GetHashKey(t)) then
            z[#z + 1] = t
        end
    end
    return z
end
RMenu:Get("frgunmods", "attachments").Closed = function()
    DeleteObject(f)
    f = nil
    for t, u in pairs(givenAttachmentsToRemove) do
        for i = 1, #givenAttachmentsToRemove[t] do
            local n = givenAttachmentsToRemove[t][i]
            if not table.has(e[t], n) then
                RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(t), GetHashKey(n))
            end
        end
    end
end
RMenu:Get("frgunmods", "main").Closed = function()
    DeleteObject(f)
    f = nil
end
function tFR.giveWeaponComponent(j, n)
    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(j), n)
end
Citizen.CreateThread(
    function()
        for i = 1, #a.shops do
            local x = a.shops[i]
            local A = x[2]
            tFR.addMarker(A.x, A.y, A.z, 0.5, 0.5, 0.5, 10, 255, 81, 170, 50, 2, false, false, true)
        end
    end
)
function tFR.giveAttachment(n)
    local B = tFR.getWeapons()
    for t, u in pairs(B) do
        local C = GetHashKey(t)
        local D = GetHashKey(n)
        if DoesWeaponTakeWeaponComponent(C, n) then
            GiveWeaponComponentToPed(PlayerPedId(), C, n)
            return
        end
    end
end]]
