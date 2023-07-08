local devMode = false;
local pedConfig = {
    ["Private Lobbies"] = {sprite = 565, action = "PrivateLobbies", coords = vec3(992.5826, 2909.6323, 31.1209), heading = 178.7225, model = GetHashKey("g_m_importexport_01"), weapon = "WEAPON_MINTYAXE",loaded = false, ped = nil, showingUI = false;};
    ["Public Lobbies"] = {sprite = 516,action = "PublicLobbies", coords = vec3(992.5842, 2901.6086, 31.1209), heading = 1.5479, model = GetHashKey("g_m_importexport_01"), weapon = "WEAPON_DARKMATTERVANDAL", loaded = false, ped = nil, showingUI = false;};
    ["Custom Guns"] = {sprite = 110, action = "CustomWeapons", coords = vec3(977.7922, 2905.7107, 31.1208), heading = 271.0951, model = GetHashKey("g_m_importexport_01"), weapon = "WEAPON_ODIN" , loaded = false, ped = nil, showingUI = false;};
}

local interactionPeds = {};
local function pedInteraction(action)
    if (action == "PrivateLobbies") then
        TriggerServerEvent("FDM:FetchCustomLobbies")
    elseif (action == "PublicLobbies") then
        TriggerServerEvent("FDM:FetchPublicLobbies")
    elseif (action == "CustomWeapons") then
        TriggerEvent("FWD:GunStore", pedConfig["Custom Guns"].ped)
    elseif (action == "CustomVehicles") then

    elseif (action == "CustomPeds") then

    end
end

local threadWait = 1000;
Citizen.CreateThread(function()
    while true do
        for k,v in pairs(pedConfig) do 
            RequestModel(pedConfig[k].model)
            while not HasModelLoaded(pedConfig[k].model) do
                Wait(100)
            end
            if #(GetEntityCoords(cFDM.Ped()) - v.coords) < 100.0 and not pedConfig[k].loaded then
                pedConfig[k].ped = CreatePed("CIVMODEL", pedConfig[k].model, pedConfig[k].coords[1], pedConfig[k].coords[2], pedConfig[k].coords[3] - 0.99999, pedConfig[k].heading, false, false)
                pedConfig[k].loaded = true;
                SetBlockingOfNonTemporaryEvents(pedConfig[k].ped, true)
                SetEntityInvincible(pedConfig[k].ped, true)
                FreezeEntityPosition(pedConfig[k].ped, true)
                GiveWeaponToPed(pedConfig[k].ped, pedConfig[k].weapon, 0, false, true)
                SetCurrentPedWeapon(pedConfig[k].ped, pedConfig[k].weapon, true)
            end
            if #(GetEntityCoords(cFDM.Ped()) - v.coords) < 10.0 then
                DrawMarker(20,
                v.coords.x, v.coords.y, v.coords.z + 1.0,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                0.2, 0.2, 0.2,
                250, 0, 0, 128,
                false,   
                false,
                2,
                true,
                nil,
                nil,
                false
            )
            end
            if #(GetEntityCoords(cFDM.Ped()) - v.coords) < 2.0 and not pedConfig[k].showingUI then
                TriggerEvent("FDM:ShowInteractionUI", true)
                pedConfig[k].showingUI = true;
            end
            if #(GetEntityCoords(cFDM.Ped()) - v.coords) > 2.0 and pedConfig[k].showingUI then
                TriggerEvent("FDM:ShowInteractionUI", false)
                pedConfig[k].showingUI = false;
            end
            if #(GetEntityCoords(cFDM.Ped()) - v.coords) < 2.0 then
                if IsControlJustPressed(0, 51) then
                    pedInteraction(v.action)
                end
            end
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(pedConfig) do
        local blip = AddBlipForCoord(pedConfig[k].coords)
        SetBlipSprite(blip, pedConfig[k].sprite)
        SetBlipScale(blip, 0.6)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(k)
        EndTextCommandSetBlipName(blip)
    end
end)