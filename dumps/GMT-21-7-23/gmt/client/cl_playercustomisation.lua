local a = module("cfg/cfg_clothing")
local function b(c)
    if type(c) == "string" and string.sub(c, 1, 1) == "p" then
        return true, tonumber(string.sub(c, 2))
    else
        return false, tonumber(c)
    end
end
function tGMT.getDrawables(d)
    local e, f = b(d)
    if e then
        return GetNumberOfPedPropDrawableVariations(PlayerPedId(), f)
    else
        return GetNumberOfPedDrawableVariations(PlayerPedId(), f)
    end
end
function tGMT.getDrawableTextures(d, g)
    local e, f = b(d)
    if e then
        return GetNumberOfPedPropTextureVariations(PlayerPedId(), f, g)
    else
        return GetNumberOfPedTextureVariations(PlayerPedId(), f, g)
    end
end
function tGMT.getCustomization()
    local h = PlayerPedId()
    local i = {}
    i.modelhash = GetEntityModel(h)
    for j = 0, 20 do
        i[j] = {GetPedDrawableVariation(h, j), GetPedTextureVariation(h, j), GetPedPaletteVariation(h, j)}
    end
    for j = 0, 10 do
        i["p" .. j] = {GetPedPropIndex(h, j), math.max(GetPedPropTextureIndex(h, j), 0)}
    end
    return i
end
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 

        local player = PlayerPedId()

        if IsPedInAnyVehicle(player, false) then
            local vehicle = GetVehiclePedIsIn(player, false)

            if IsThisModelABike(GetEntityModel(vehicle)) then
                if IsPedWearingHelmet(player) then
                    SetPedHelmet(player, false) 
                end
            end
        end
    end
end)

local k = false
local l = 0
function tGMT.setCustomization(i, m, n)
    if i then
        local o = tGMT.getArmour()
        local h = PlayerPedId()
        local p = nil
        if i.modelhash ~= nil then
            p = i.modelhash
        elseif i.model ~= nil then
            p = GetHashKey(i.model)
        end
        local q = tGMT.loadModel(p)
        local r = GetEntityModel(h)
        if q then
            if r ~= q or m then
                k = true
                local s = tGMT.getWeapons()
                local t = GetEntityHealth(h)
                SetPlayerModel(PlayerId(), p)
                Wait(0)
                tGMT.giveWeapons(s, true)
                if n == nil or n == false then
                    print("[GMT] Customisation, setting health to ", t)
                    tGMT.setHealth(t)
                end
                TriggerServerEvent("GMT:getPlayerHairstyle")
                TriggerServerEvent("GMT:getPlayerTattoos")
                h = PlayerPedId()
            else
             --   print("[GMT] Same model detected, not changing model.")  -- Spams console so removed for the time being
            end
            SetModelAsNoLongerNeeded(p)
            for u, v in pairs(i) do
                if u ~= "model" and u ~= "modelhash" then
                    if tonumber(u) then
                        u = tonumber(u)
                    end
                    local e, f = b(u)
                    if e then
                        if v[1] < 0 then
                            ClearPedProp(h, f)
                        else
                            SetPedPropIndex(h, f, v[1], v[2], v[3] or 2)
                        end
                    else
                        SetPedComponentVariation(h, f, v[1], v[2], v[3] or 2)
                    end
                end
            end
            k = false
            l = GetGameTimer()
        else
            print("[GMT] Failed to load model", p)
        end
        tGMT.setArmour(o)
    end
end
function tGMT.isPedScriptGuidChanging()
    return k or GetGameTimer() - l < 3000
end
function tGMT.loadCustomisationPreset(w)
    local x = a.presets[w]
    assert(x, string.format("Preset %s does not exist.", w))
    if x.model then
        tGMT.setCustomization({modelhash = x.model})
        Citizen.Wait(100)
    end
    local y = PlayerPedId()
    if x.components then
        for z, A in pairs(x.components) do
            SetPedComponentVariation(y, z, A[1], A[2], A[3])
        end
    end
    if x.props then
        for B, C in pairs(x.props) do
            SetPedPropIndex(y, B, C[1], C[2], C[3])
        end
    end
end
SetVisualSettingFloat("ped.lod.distance.high", 200.0)
SetVisualSettingFloat("ped.lod.distance.medium", 400.0)
SetVisualSettingFloat("ped.lod.distance.low", 700.0)
