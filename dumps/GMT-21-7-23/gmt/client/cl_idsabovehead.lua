local a = 7.0
local b = {}
local c = {}
local d = true
local e = {}
local f = {}
local g = false
local h = 30000.0

local function i(j, k, l)
    if d then
        if k < a then
            if a > 7.0 then
                return true
            end
            if HasEntityClearLosToEntity(tGMT.getPlayerPed(), l, 17) then
                return true
            end
        elseif g and tGMT.isPlayerInSelectedGang(j) then
            if k < h then
                return true
            end
        end
    end
    return false
end

Citizen.CreateThread(function()
    Wait(500)
    while true do
        if not globalHideUi then
            if d then
                local m = tGMT.getPlayerPed()
                for n, o in ipairs(GetActivePlayers()) do
                    local l = GetPlayerPed(o)
                    if l ~= m then
                        if b[o] then
                            local j = GetPlayerServerId(o)
                            if i(j, b[o], l) then
                                local p = e[o]
                                if NetworkIsPlayerTalking(o) then
                                    SetMpGamerTagAlpha(p, 4, 255)
                                    SetMpGamerTagColour(p, 0, 9)
                                    SetMpGamerTagColour(p, 4, 0)
                                    SetMpGamerTagVisibility(p, 4, true)
                                else
                                    local q, r = tGMT.isPlayerInSelectedGang(j)
                                    if g and q then
                                        SetMpGamerTagColour(p, 0, r.hud)
                                        SetMpGamerTagsVisibleDistance(h)
                                    else
                                        SetMpGamerTagColour(p, 0, 0)
                                    end
                                    SetMpGamerTagColour(p, 4, 0)
                                    SetMpGamerTagVisibility(p, 4, false)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        b = {}
        c = {}
        local m = tGMT.getPlayerPed()
        local s = tGMT.getPlayerCoords()
        if tGMT.isInSpectate() then
            s = GetFinalRenderedCamCoord()
        end
        for n, o in ipairs(GetActivePlayers()) do
            local t = GetPlayerPed(o)
            local u = GetPlayerServerId(o)
            if t ~= m and (IsEntityVisible(t) or not tGMT.clientGetPlayerIsStaff(tGMT.clientGetUserIdFromSource(u)) and not tGMT.inEvent()) then
                local v = GetEntityCoords(t)
                b[o] = #(s - v)
                if DecorGetBool(t, "cinematicMode") then
                    c[o] = true
                end
            end
        end
        if not tGMT.isStaffedOn() then
            a = 7.0
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        g = tGMT.hasGangNamesEnabled() and not tGMT.isEmergencyService()
        for n, o in ipairs(GetActivePlayers()) do
            local k = b[o]
            local j = GetPlayerServerId(o)
            if k and i(j, k, GetPlayerPed(o)) and d then
                local w = nil
                if g and tGMT.isPlayerInSelectedGang(j) then
                    w = tGMT.getPlayerName(o)
                else
                    w = tostring(GetPlayerServerId(o))
                    if c[o] then
                        w = w .. " [cinematic mode]"
                    end
                end
                if f[o] ~= w and e[o] then
                    RemoveMpGamerTag(e[o])
                end
                e[o] = CreateFakeMpGamerTag(GetPlayerPed(o), w, false, false, "", 0)
                SetMpGamerTagVisibility(e[o], 3, true)
                f[o] = w
            elseif e[o] then
                RemoveMpGamerTag(e[o])
                e[o] = nil
                f[o] = nil
            end
            Wait(0)
        end
        Wait(0)
    end
end)

SetMpGamerTagsUseVehicleBehavior(false)

function tGMT.setPlayerNameDistance(k)
    if k == -1 then
        SetMpGamerTagsVisibleDistance(100.0)
        a = 7.0
    else
        SetMpGamerTagsVisibleDistance(k)
        a = k
    end
end

function tGMT.getPlayerNameDistance()
    return a
end

RegisterCommand("farids", function(x, y, z)
    if tGMT.getStaffLevel() > 2 and tGMT.isStaffedOn() then
        local A = y[1]
        if A ~= nil and tonumber(A) then
            a = tonumber(A) + 000.1
            tGMT.setPlayerNameDistance(a)
            tGMT.notify("~g~Far ids distance set to " .. A .. "m")
        else
            tGMT.notify("~r~Please enter a valid range! (/farids [range])")
        end
    end
end, false)

RegisterCommand("faridsreset", function(x, y, z)
    if tGMT.getStaffLevel() > 2 then
        tGMT.setPlayerNameDistance(-1)
    end
end, false)

RegisterCommand("hideids", function()
    d = false
end, false)

RegisterCommand("showids", function()
    d = true
end, false)

AddEventHandler("GMT:setGangNameDistance", function(k)
    h = k
end)
