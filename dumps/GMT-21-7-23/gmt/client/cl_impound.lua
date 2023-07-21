local a = module("cfg/cfg_impound")
local b = {owner_id = 0, owner_name = "", vehicle = "", vehicle_name = ""}
local c = {}
Citizen.CreateThread(function()
    tGMT.createDynamicPed(a.CityPed.modelHash,a.CityPed.position,215.0,true,a.CityPed.animDict,a.CityPed.animName,30,false,false)
    tGMT.addBlip(a.CityPed.position.x, a.CityPed.position.y, a.CityPed.position.z, 357, 81, "Vehicle Impound", 0.8, false)
    tGMT.createDynamicPed(a.paletoPed.modelHash,a.paletoPed.position,215.0,true,a.paletoPed.animDict,a.paletoPed.animName,30,false,false)
    tGMT.addBlip(a.paletoPed.position.x, a.paletoPed.position.y, a.paletoPed.position.z, 357, 81, "Vehicle Impound", 0.8, false)
    Wait(2000)
    local d = function()
        TriggerServerEvent('GMT:getImpoundedVehicles')
        RageUI.Visible(RMenu:Get("gmtimpound", "main"), true)
    end
    local e = function()
        RageUI.ActuallyCloseAll()
    end
    local f = function()
    end
    tGMT.createArea("vehicle_impound", a.CityPed.position, 3.0, 6, d, e, f, {})
    tGMT.createArea("vehicle_impound", a.paletoPed.position, 3.0, 6, d, e, f, {})
end)
RMenu.Add("gmtimpound","reasons",RageUI.CreateMenu("","Impounding Vehicle...",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight(),"gmt_settingsui", "gmt_settingsui"))
RMenu.Add("gmtimpound","main",RageUI.CreateMenu("","Your Impounded Vehicles",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight(),"gmt_settingsui", "gmt_settingsui"))
RMenu.Add("gmtimpound", "vehicle_information", RageUI.CreateSubMenu(RMenu:Get("gmtimpound", "main")))
RMenu.Add("gmtimpound", "pay_fine_confirmation", RageUI.CreateSubMenu(RMenu:Get("gmtimpound", "vehicle_information")))
local g = 0

RageUI.CreateWhile(1.0, true, function()
    RageUI.BackspaceMenuCallback(function()
        resetChecked()
    end)
    if RageUI.Visible(RMenu:Get('gmtimpound', 'reasons')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("Vehicle: ~b~" .. b.vehicle_name .. "~s~ | Owner: ~b~" .. b.owner_name)
            for h = 1, #a.reasonsForImpound do
                RageUI.Checkbox(a.reasonsForImpound[h].option,"",a.reasonsForImpound[h].checked,{RightBadge = RageUI.CheckboxStyle.Car},function(i, j, k, l)
                    if j then
                        a.reasonsForImpound[h].checked = l
                    end
                end)
            end
            RageUI.ButtonWithStyle("~g~Confirm Selection","",{RightLabel = "→→→"},true,function(i, k, j)
                if j then
                    local m = {}
                    for h, n in ipairs(a.reasonsForImpound) do
                        if n.checked then
                            table.insert(m, h)
                            n.checked = false
                        end
                    end
                    TriggerServerEvent("GMT:impoundVehicle",b.owner_id,b.owner_name,b.vehicle,b.vehicle_name,m,b.vehicle_net_id)
                    RageUI.ActuallyCloseAll()
                end
            end,function()end)
            RageUI.ButtonWithStyle("Cancel","",{RightLabel = "→→→"},true,function(i, k, j)
                if j then
                    RageUI.ActuallyCloseAll()
                end
            end,function()end)
        end) 
    end
    if RageUI.Visible(RMenu:Get('gmtimpound', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("View your impounded vehicles here.")
                RageUI.Separator("You can pay the ~g~£10,000~s~ fine to release your vehicle.")
                RageUI.Separator("---")
                if c ~= nil and c ~= {} then
                    for o, p in pairs(c) do
                        RageUI.ButtonWithStyle(p.vehicle_name,"",{RightLabel = "→→→"},true,function(i, k, j)
                            if j then
                                g = p
                            end
                        end,
                        RMenu:Get("gmtimpound", "vehicle_information"))
                    end
                else
                    RageUI.Separator("None of your vehicles are currently impounded.")
                end
        end) 
    end
    if RageUI.Visible(RMenu:Get('gmtimpound', 'vehicle_information')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if g ~= 0 then
                RageUI.Separator(g.vehicle_name)
                RageUI.Separator("This vehicle was impounded by ~b~" ..g.impounded_by_name .. " (ID: " .. g.impounder .. ") ~s~for:")
                local q = g.reasons
                for h, n in ipairs(q) do
                    RageUI.Separator("» " .. q[h])
                end
                RageUI.ButtonWithStyle("~g~Pay Fine","Paying the fine will release your vehicle.",{RightLabel = "→→→"},true,function(i, k, j)
                end,RMenu:Get("gmtimpound", "pay_fine_confirmation"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('gmtimpound', 'pay_fine_confirmation')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if g ~= 0 then
                RageUI.Separator("Would you like to release your vehicle?")
                RageUI.Separator("This action will cost you ~g~£10,000~s~.")
                RageUI.Separator("---")
                RageUI.ButtonWithStyle("~g~Pay","Pay the fine",{RightLabel = "→→→"},true,function(i, k, j)
                    if j then
                        TriggerServerEvent("GMT:releaseImpoundedVehicle", g.vehicle)
                    end
                end,RMenu:Get("gmtimpound", "main"))
                RageUI.ButtonWithStyle("Cancel","Go back",{RightLabel = "→→→"},true,function(i, k, j)
                end,RMenu:Get("gmtimpound", "main"))
            end
        end)
    end
end)

RegisterNetEvent("GMT:receiveInfoForVehicleToImpound",function(r, s, t, u, v)
    b = {owner_id = tonumber(r), owner_name = s, vehicle = t, vehicle_name = u, vehicle_net_id = v}
end)

RegisterNetEvent("GMT:receiveImpoundedVehicles",function(w)
    c = w
end)

RegisterNetEvent("GMT:impoundSuccess",function(x, t, y, z, A, B, C, D)
    local u = NetworkGetEntityFromNetworkId(x)
    local E = GetEntityCoords(u, false)
    local F = CreateObject("prop_cs_protest_sign_03", E.x, E.y, E.z, true, true, true)
    tGMT.loadModel("prop_clamp")
    FreezeEntityPosition(u, true)
    local G = CreateObject("prop_clamp", E.x, E.y, E.z, true, true, true)
    SetModelAsNoLongerNeeded("prop_clamp")
    local H = GetEntityBoneIndexByName(u, "wheel_lf")
    SetEntityHeading(G, 0.0)
    AttachEntityToEntity(G, u, H, -0.1, 0.15, -0.3, 180.0, 200.0, 90.0, true, true, false, false, 2, true)
    FreezeEntityPosition(G, true)
    if IsVehicleWindowIntact(u, 0) then
        local I = GetEntityBoneIndexByName(u, "windscreen")
        FreezeEntityPosition(F, true)
        AttachEntityToEntity(F, u, I, 0.1, -2.7, -1.65, -32.0, 5.0, 180.0, true, true, false, true, 0, true)
    end
    tGMT.notifyPicture("polnotification","notification","You have siezed a ~b~" ..t .."~s~ owned by ~b~" ..y .. "~s~. \n \nA tow truck will pick up the vehicle shortly and take it to the impound.","Metropolitan Police","Impound",nil,nil)
    local J = PlayerPedId()
    local K = GetEntityCoords(J)
    local L, L, M = GetClosestVehicleNodeWithHeading(K.x, K.y, K.z, nil, 8, 8, 8, 8)
    local L, N, L = GetPointOnRoadSide(K.x, K.y, K.z, 0.0)
    local L, O = GetNthClosestVehicleNode(K.x, K.y, K.z, 15)
    local P
    local Q
    if O ~= vector3(0, 0, 0) and N ~= vector3(0, 0, 0) then
        tGMT.loadModel("flatbed")
        tGMT.loadModel("a_m_m_prolhost_01")
        P = tGMT.spawnVehicle("flatbed", O.x, O.y, O.z, M, false, true, true)
        local R = NetworkGetNetworkIdFromEntity(P)
        SetVehicleDoorsLocked(P, 2)
        SetNetworkIdCanMigrate(R, false)
        SetModelAsNoLongerNeeded("flatbed")
        local S = AddBlipForEntity(P)
        SetBlipSprite(S, 68)
        SetBlipDisplay(S, 4)
        SetBlipScale(S, 1.0)
        SetBlipColour(S, 5)
        SetBlipAsShortRange(S, true)
        Q = CreatePedInsideVehicle(P, 1, "a_m_m_prolhost_01", -1, true)
        local T = NetworkGetNetworkIdFromEntity(Q)
        TaskVehicleDriveToCoord(Q, P, N.x, N.y, N.z, 15.0, 1.0, "flatbed", 262144, 5.0)
        SetModelAsNoLongerNeeded("a_m_m_prolhost_01")
        local U = GetGameTimer()
        local V = #(GetEntityCoords(u) - GetEntityCoords(P))
        while V > 15.0 and GetGameTimer() - U < 20000 do
            Wait(1000)
            V = #(GetEntityCoords(u) - GetEntityCoords(P))
        end
        TriggerServerEvent("GMT:deleteImpoundEntities",x,NetworkGetNetworkIdFromEntity(G),NetworkGetNetworkIdFromEntity(F))
        u = tGMT.spawnVehicle(z, C.x, C.y, C.z, D, false, true, false)
        x = NetworkGetEntityFromNetworkId(u)
        SetVehicleDoorsLocked(u, 2)
        SetNetworkIdCanMigrate(x, false)
        SetVehicleColours(u, A, B)
        AttachEntityToEntity(u, P, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        TriggerServerEvent("GMT:awaitTowTruckArrival", x, R, T)
        TaskVehicleDriveToCoord(Q,P,a.driveToPosition.x,a.driveToPosition.y,a.driveToPosition.z,15.0,1.0,"flatbed",262144,5.0)
        SetEntityInvincible(u, true)
        SetEntityInvincible(P, true)
    end
end)

RegisterNetEvent("GMT:attachVehToTowCl",function(x, W)
    local u = NetworkGetEntityFromNetworkId(x)
    local P = NetworkGetEntityFromNetworkId(W)
    AttachEntityToEntity(u, P, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
end)

local function X(u)
    for Y = -1, GetVehicleMaxNumberOfPassengers(u) - 1 do
        if not IsVehicleSeatFree(u, Y) then
            return true
        end
    end
    return false
end
function tGMT.impoundVehicleOptions(Z, _, x, a0)
    local a1 = g_vehicleHashToVehicleName[_]
    if X(a0) then
        tGMT.notifyPicture("polnotification","notification","The vehicle cannot be impounded with a person inside.","Metropolitan Police","Impound",nil,nil)
        return
    end
    local a2 = GetVehicleClass(a0)
    if a2 == 18 then
        tGMT.notifyPicture("polnotification","notification","Emergency vehicles cannot be impounded.","Metropolitan Police","Impound",nil,nil)
    elseif a.disallowedVehicleClasses[a2] then
        tGMT.notifyPicture("polnotification","notification","That vehicle is too large to be impounded.","Metropolitan Police","Impound",nil,nil)
    else
        TriggerServerEvent("GMT:fetchInfoForVehicleToImpound", Z, a1, x)
        RageUI.Visible(RMenu:Get("gmtimpound", "reasons"), true)
    end
end

function tGMT.isVehicleImpounded(u)
    return c[u] ~= nil
end

function resetChecked()
    for L, n in ipairs(a.reasonsForImpound) do
        n.checked = false
    end
end

exports("impound", tGMT.impoundVehicleOptions)
exports("isImpounded", tGMT.isVehicleImpounded)
