local plrsInServer = {}
local SelectedPerm = nil;
local SelectedGroup = nil;
local Buttons = {}
local EntitysDeleted = {}
local NearbyPlayers = {}
local Groups = {}
local cfg = module('cfg/admin_menu')
local main = RageUI.CreateMenu("", "~h~~r~Admin Menu", 1415, 30, "banners", "Admin")
local nearby = RageUI.CreateSubMenu(main, "", "~h~~r~Nearby Players")
local player_selected_nearby = RageUI.CreateSubMenu(nearby, "", "~h~~r~Selected Player")
local players = RageUI.CreateSubMenu(main, "", "~h~~r~Admin Menu")
local player_selected = RageUI.CreateSubMenu(players, "", "~h~~r~Groups")
local groups = RageUI.CreateSubMenu(player_selected, "", "~h~~r~Groups")
local groups_manage = RageUI.CreateSubMenu(groups, "", "~h~~r~Manage Groups")
local misc = RageUI.CreateSubMenu(main, "", "~h~~r~Misc Options")
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        RageUI.IsVisible(main, function()
            RageUI.Button("Players", " ", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(players, true)
                end,
            });
            RageUI.Button("Nearby Players", " ", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(nearby, true)
                end,
            });
            RageUI.Button("Misc Options", " ", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(misc, true)
                end,
            });
        end)
        RageUI.IsVisible(nearby, function()
            for k,v in pairs(NearbyPlayers) do
                RageUI.Button(v[2], "Perm ID: " ..  k .. ' / Temp ID: ' .. v[1], {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        SelectedPerm = k
                        RageUI.Visible(player_selected_nearby, true)
                    end,
                });
            end
        end)
        RageUI.IsVisible(misc, function()
            for i,v in pairs(MiscBtn) do 
                RageUI.Button(i, v, {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        cfg.MiscButtons[i][1]()
                    end,
                });
            end
        end)
        RageUI.IsVisible(players, function()
            for i,v in pairs(plrsInServer) do 
                RageUI.Button(v[2], "Perm ID: " .. i .. ' / Temp ID: ' .. v[1], {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        SelectedPerm = i
                        RageUI.Visible(player_selected, true)
                    end,
                });
            end
        end)
        RageUI.IsVisible(player_selected_nearby, function()
            RageUI.Separator("~h~~r~Selected Player Perm Id: " ..SelectedPerm)
            for i,v in pairs(Buttons) do 
                RageUI.Button(i, "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        cfg.Buttons[i][1](SelectedPerm)
                    end,
                });
            end
            RageUI.Button('Players Groups', "", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    TriggerServerEvent('FDMAdmin:Groups', SelectedPerm)
                    RageUI.Visible(groups, true)
                end,
            });
        end)
        RageUI.IsVisible(player_selected, function()
            RageUI.Separator("~h~~r~Selected Player Perm Id: " ..SelectedPerm)
            for i,v in pairs(Buttons) do 
                RageUI.Button(i, "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        cfg.Buttons[i][1](SelectedPerm)
                    end,
                });
            end
            RageUI.Button('Players Groups', "", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    TriggerServerEvent('FDMAdmin:Groups', SelectedPerm)
                    RageUI.Visible(groups, true)
                end,
            });
        end)
        RageUI.IsVisible(groups, function()
            for i,v in pairs(Groups) do 
                RageUI.Button(i, "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        SelectedGroup = i;
                        RageUI.Visible(groups_manage, true)
                    end,
                });
            end
        end)
        RageUI.IsVisible(groups_manage, function()
            RageUI.Button("Remove Group", "", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    TriggerServerEvent('FDMAdmin:RemoveGroup', SelectedPerm, SelectedGroup)
                end,
            });
        end)
    end
end)

RegisterCommand('openadminmenu', function()
    TriggerServerEvent('FDMAdmin:ReturnPlayers')
end, false)


RegisterKeyMapping('openadminmenu', 'Opens admin menu', 'keyboard', 'F2')

RegisterNetEvent('FDMAdmin:RecievePlayers')
AddEventHandler('FDMAdmin:RecievePlayers', function(table, perms, misc, nearby)
    plrsInServer = table
    Buttons = perms
    MiscBtn = misc
    NearbyPlayers = nearby
    RageUI.Visible(main, true)
end)

RegisterNetEvent('FDMAdmin:ReturnGroups')
AddEventHandler('FDMAdmin:ReturnGroups', function(groups)
    Groups = groups
end)


local Spectating = false;
local LastCoords = nil;
RegisterNetEvent('FDMAdmin:Spectate')
AddEventHandler('FDMAdmin:Spectate', function(plr,tpcoords)
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
    if not Spectating then
        LastCoords = GetEntityCoords(playerPed) 
        if tpcoords then 
            SetEntityCoords(playerPed, tpcoords - 10.0)
        end
        Wait(300)
        targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
        if targetPed == playerPed then cFDM.notify('~r~I mean you cannot spectate yourself...') return end
		NetworkSetInSpectatorMode(true, targetPed)
        SetEntityCollision(playerPed, false, false)
        SetEntityVisible(playerPed, false, 0)
		SetEveryoneIgnorePlayer(playerPed, true)	
        Spectating = true
        cFDM.notify('~g~Spectating Player.')
    else 
        NetworkSetInSpectatorMode(false, targetPed)
        SetEntityVisible(playerPed, true, 0)
		SetEveryoneIgnorePlayer(playerPed, false)
		SetEntityCollision(playerPed, true, true)
        Spectating = false;
        SetEntityCoords(playerPed, LastCoords)
        cFDM.notify('~r~Stopped Spectating Player.')
    end 
end)

RegisterNetEvent('FDMAdmin:TPTo')
AddEventHandler('FDMAdmin:TPTo', function(coords, plr)
    if coords then 
        SetEntityCoords(PlayerPedId(), coords)
    else 
        local targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
        local plrcoords = GetEntityCoords(targetPed)
        SetEntityCoords(PlayerPedId(), plrcoords)
    end
end)

RegisterNetEvent('FDMAdmin:Bring')
AddEventHandler('FDMAdmin:Bring', function(coords, plr)
    if coords then 
        SetEntityCoords(PlayerPedId(), coords)
    else 
        local targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
        local plrcoords = GetEntityCoords(targetPed)
        SetEntityCoords(PlayerPedId(), plrcoords)
    end
end)

function NetworkDelete(entity)
    Citizen.CreateThread(function()
        if DoesEntityExist(entity) and not (IsEntityAPed(entity) and IsPedAPlayer(entity)) then
            NetworkRequestControlOfEntity(entity)
            local timeout = 5
            while timeout > 0 and not NetworkHasControlOfEntity(entity) do
                Citizen.Wait(1)
                timeout = timeout - 1
            end
            DetachEntity(entity, 0, false)
            SetEntityCollision(entity, false, false)
            SetEntityAlpha(entity, 0.0, true)
            SetEntityAsMissionEntity(entity, true, true)
            SetEntityAsNoLongerNeeded(entity)
            DeleteEntity(entity)
        end
    end)
end

RegisterNetEvent("FDMAdmin:EntityWipe")
AddEventHandler("FDMAdmin:EntityWipe", function(id)
    Citizen.CreateThread(function() 
        for k,v in pairs(GetAllEnumerators()) do 
            local enum = v
            for entity in enum() do 
                local owner = NetworkGetEntityOwner(entity)
                local playerID = GetPlayerServerId(owner)
                NetworkDelete(entity)
            end
        end
    end)
end)

local EntityCleanupGun = false;
RegisterNetEvent("FDMAdmin:EntityCleanupGun")
AddEventHandler("FDMAdmin:EntityCleanupGun", function()
    EntityCleanupGun = not EntityCleanupGun
    if EntityCleanupGun then 
        FDM.GiveWeapon(source, GetHashKey('WEAPON_PISTOL'))
        cFDM.notify("~g~Entity cleanup gun enabled.")
    else 
        cFDM.notify("~r~Entity cleanup gun disabled.")
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey('WEAPON_PISTOL'))
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if EntityCleanupGun then 
            local plr = PlayerId()
            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_PISTOL') then
                if IsPlayerFreeAiming(plr) then 
                    local yes, entity = GetEntityPlayerIsFreeAimingAt(plr)
                    if yes then 
                        EntitysDeleted[GetEntityModel(entity)] = true;
                        cFDM.notify('~g~Deleted Entity: ' .. GetEntityModel(entity))
                        NetworkDelete(entity)
                    end
                end 
            else 
                RemoveWeaponFromPed(PlayerPedId(), GetHashKey('WEAPON_PISTOL'))
                EntityCleanupGun = false;
                cFDM.notify("~r~Entity cleanup gun disabled.")
            end 
        end
    end
end)