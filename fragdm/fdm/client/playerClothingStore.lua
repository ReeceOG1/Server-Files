local ClothingStore = RageUI.CreateMenu("", "Clothing Store", 1415,10, "banners", "Clothing")
local MainClothing = RageUI.CreateSubMenu(ClothingStore, "", "Clothing Store", 1415,10)
local AccessoriesClothing = RageUI.CreateSubMenu(ClothingStore, "", "Accessories", 1415,10)
local Gender = RageUI.CreateSubMenu(MainClothing, "", "Gender Menu", 1415,10)
local Clear = RageUI.CreateSubMenu(ClothingStore, "", "Miscellaneous", 1415,10)
local Options = RageUI.CreateSubMenu(ClothingStore, "", "Clothing Information", 1415,10)
local Clothing = {}
Clothing.Hoodies = {}
Clothing.Masks = {}
Clothing.UnderShirt = {}
Clothing.Trousers = {}
Clothing.Shoes = {}
Clothing.Vests = {}
Clothing.Accessories = {}
Clothing.Gloves = {}
Clothing.Hats = {}
local ClothingIndex = nil;


local function CloseMenus()
    RageUI.Visible(MainClothing, false)
    RageUI.Visible(Options, false)
    RageUI.Visible(AccessoriesClothing, false)
    RageUI.Visible(Clear, false)
    RageUI.Visible(Options, false)
    RageUI.Visible(ClothingStore, false)
end


local function GetMaxFromForAll()
    for m=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 0), 1 do
        table.insert(Clothing.Hats, m)
    end
    for m=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 1), 1 do
        table.insert(Clothing.Masks, m)
    end
    for m=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 0), 1 do
        table.insert(Clothing.Hats, m)
    end
    for b=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 11), 1 do
        table.insert(Clothing.Hoodies, b)
    end
    for s=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 4), 1 do
        table.insert(Clothing.Trousers, s)
    end
    for n=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 6), 1 do
        table.insert(Clothing.Shoes, n)
    end
    for na=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 8), 1 do
        table.insert(Clothing.UnderShirt, na)
    end
    for ba=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 9), 1 do
        table.insert(Clothing.Vests, ba)
    end
    for as=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 7), 1 do
        table.insert(Clothing.Accessories, as)
    end
    for gl=1, GetNumberOfPedDrawableVariations(cFDM.Ped(), 3), 1 do
        table.insert(Clothing.Gloves, gl)
    end
    for ha=1, GetNumberOfPedPropDrawableVariations(ped, 0), 1 do
        table.insert(Clothing.Gloves, ha)
    end
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        RageUI.IsVisible(ClothingStore, function()
            RageUI.Button('~h~~r~Selected Outfit', '~h~~r~Check Selected Outfit Numbers', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(Options, true)
                end,
            });
            RageUI.Button('Main Clothing', '~h~~r~This Includes T-Shirts/Hoodies and More', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(MainClothing, true)
                end,
            });
            RageUI.Button('Change Gender', '~h~~r~Change Ped Gender', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(Gender, true)
                end,
            });
            RageUI.Button('Accessories', '~h~~r~This Includes Watches/Accessories and More', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(AccessoriesClothing, true)
                end,
            });
            RageUI.Button('Miscellaneous Options', '~h~~r~Clear Props And More', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(Clear, true)
                end,
            });
        end)
        RageUI.IsVisible(Gender, function()
            RageUI.Button('Female', '~h~~r~Set Current Ped To Female', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    local health = GetEntityHealth(cFDM.Ped())
                    local model = GetHashKey('mp_f_freemode_01')
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        RequestModel(model)
                        Citizen.Wait(0)
                    end
                    SetPlayerModel(PlayerId(), model)
                    SetEntityHealth(health)
                    SetPedComponentVariation(cFDM.Ped(), 0, 0, 0, 2) 
                end,
            });
            RageUI.Button('Male', '~h~~r~Set Current Ped To Female', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    local model = GetHashKey('mp_m_freemode_01')
                    local health = GetEntityHealth(cFDM.Ped())
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        RequestModel(model)
                        Citizen.Wait(0)
                    end
                    SetPlayerModel(PlayerId(), model)
                    SetEntityHealth(health)
                    SetPedComponentVariation(cFDM.Ped(), 0, 0, 0, 2) 
                end,
            });
        end)
        RageUI.IsVisible(MainClothing, function()
            if IsControlJustPressed(0, 203) then 
                AddTextEntry('FMMC_MPM_NA', "Enter Clothing ID")
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0);
                    Wait(0);
                end
                if (GetOnscreenKeyboardResult()) then
                    local result = GetOnscreenKeyboardResult()
                    if tonumber(ClothingIndex) == 0 then 
                        SetPedPropIndex(cFDM.Ped(), 0, tonumber(ClothingIndex), 0, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), ClothingIndex, tonumber(result), 0, 0)
                    end
                end
            end
            RageUI.List('Hoodies', Clothing.Hoodies, GetPedDrawableVariation(cFDM.Ped(), 11)+1, "~h~~r~Texture: " .. GetPedTextureVariation(cFDM.Ped(), 11) .. " / Max Total Textures: " ..GetNumberOfPedTextureVariations(cFDM.Ped(), 11), {}, true, {
                onActive = function()
                    ClothingIndex = 11;
                end,
                onListChange = function(Index, Item)
                    Index = Index
                    SetPedComponentVariation(cFDM.Ped(), 11, Index-1, 1, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedTextureVariation(cFDM.Ped(), 11) == GetNumberOfPedTextureVariations(cFDM.Ped(), 11) then
                        SetPedComponentVariation(cFDM.Ped(), 11, GetPedDrawableVariation(cFDM.Ped(), 11), 1, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), 11, GetPedDrawableVariation(cFDM.Ped(), 11), GetPedTextureVariation(cFDM.Ped(), 11)+1, 0)
                    end
                end,
            })
            RageUI.List('Under Shirt',Clothing.UnderShirt, GetPedDrawableVariation(cFDM.Ped(), 8)+1, "~h~~r~Texture: " .. GetPedTextureVariation(cFDM.Ped(), 8) .. " / Total Textures: " ..GetNumberOfPedTextureVariations(cFDM.Ped(), 8), {}, true, {
                onActive = function()
                    ClothingIndex = 8;
                end,
                onListChange = function(Index, Item)
                    Index = Index
                    SetPedComponentVariation(cFDM.Ped(), 8, Index-1, 1, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedTextureVariation(cFDM.Ped(), 8) == GetNumberOfPedTextureVariations(cFDM.Ped(), 8) then
                        SetPedComponentVariation(cFDM.Ped(), 8, GetPedDrawableVariation(cFDM.Ped(), 8), 1, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), 8, GetPedDrawableVariation(cFDM.Ped(), 8), GetPedTextureVariation(cFDM.Ped(), 8)+1, 0)
                    end
                end,
            })
            RageUI.List('Gloves',Clothing.Gloves, GetPedDrawableVariation(cFDM.Ped(), 3)+1, "~h~~r~Texture: " .. GetPedTextureVariation(cFDM.Ped(), 3) .. " / Total Textures: " ..GetNumberOfPedTextureVariations(cFDM.Ped(), 3), {}, true, {
                onActive = function()
                    ClothingIndex = 3;
                end,
                onListChange = function(Index, Item)
                    Index = Index
                    SetPedComponentVariation(cFDM.Ped(), 3, Index-1, 1, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedTextureVariation(cFDM.Ped(), 3) == GetNumberOfPedTextureVariations(cFDM.Ped(), 3) then
                        SetPedComponentVariation(cFDM.Ped(), 3, GetPedDrawableVariation(cFDM.Ped(), 3), 1, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), 3, GetPedDrawableVariation(cFDM.Ped(), 3), GetPedTextureVariation(cFDM.Ped(), 3)+1, 0)
                    end
                end,
            })
            RageUI.List('Vests',Clothing.Vests, GetPedDrawableVariation(cFDM.Ped(), 9)+1, "~h~~r~Texture: " .. GetPedTextureVariation(cFDM.Ped(), 9) .. " / Total Textures: " ..GetNumberOfPedTextureVariations(cFDM.Ped(), 9), {}, true, {
                onActive = function()
                    ClothingIndex = 9;
                end,
                onListChange = function(Index, Item)
                    Index = Index
                    SetPedComponentVariation(cFDM.Ped(), 9, Index-1, 1, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedTextureVariation(cFDM.Ped(), 9) == GetNumberOfPedTextureVariations(cFDM.Ped(), 9) then
                        SetPedComponentVariation(cFDM.Ped(), 9, GetPedDrawableVariation(cFDM.Ped(), 9), 1, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), 9, GetPedDrawableVariation(cFDM.Ped(), 9), GetPedTextureVariation(cFDM.Ped(), 9)+1, 0)
                    end
                end,
            })
            RageUI.List('Trousers',Clothing.Trousers, GetPedDrawableVariation(cFDM.Ped(), 4)+1, "~h~~r~Texture: " .. GetPedTextureVariation(cFDM.Ped(), 4) .. " / Total Textures: " ..GetNumberOfPedTextureVariations(cFDM.Ped(), 4), {}, true, {
                onActive = function()
                    ClothingIndex = 4;
                end,
                onListChange = function(Index, Item)
                    Index = Index
                    SetPedComponentVariation(cFDM.Ped(), 4, Index-1, 1, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedTextureVariation(cFDM.Ped(), 4) == GetNumberOfPedTextureVariations(cFDM.Ped(), 4) then
                        SetPedComponentVariation(cFDM.Ped(), 4, GetPedDrawableVariation(cFDM.Ped(), 4), 1, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), 4, GetPedDrawableVariation(cFDM.Ped(), 4), GetPedTextureVariation(cFDM.Ped(), 4)+1, 0)
                    end
                end,
            })
            RageUI.List('Shoes',Clothing.Shoes, GetPedDrawableVariation(cFDM.Ped(), 6)+1, "~h~~r~Texture: " .. GetPedTextureVariation(cFDM.Ped(), 6) .. " / Total Textures: " ..GetNumberOfPedTextureVariations(cFDM.Ped(), 6), {}, true, {
                onActive = function()
                    ClothingIndex = 6;
                end,
                onListChange = function(Index, Item)
                    Index = Index
                    SetPedComponentVariation(cFDM.Ped(), 6, Index-1, 1, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedTextureVariation(cFDM.Ped(), 6) == GetNumberOfPedTextureVariations(cFDM.Ped(), 6) then
                        SetPedComponentVariation(cFDM.Ped(), 6, GetPedDrawableVariation(cFDM.Ped(), 6), 1, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), 6, GetPedDrawableVariation(cFDM.Ped(), 6), GetPedTextureVariation(cFDM.Ped(), 6)+1, 0)
                    end
                end,
            })
        end)
        RageUI.IsVisible(AccessoriesClothing, function()
            RageUI.List('Hats', Clothing.Hats, GetPedPropIndex(cFDM.Ped(), 0) +1, "~h~~r~Texture: " .. GetPedPropTextureIndex(cFDM.Ped(), 0) .. " / Total Textures: " ..GetNumberOfPedPropTextureVariations(cFDM.Ped(), 0, GetPedPropIndex(cFDM.Ped(), 0))-1, {}, true, {
                onActive = function()
                    ClothingIndex = 0;
                end,
                onListChange = function(Index, Item)
                    Index = Index
                    SetPedPropIndex(cFDM.Ped(), 0, Index-1, 0, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedPropTextureIndex(cFDM.Ped(), 0) == GetNumberOfPedPropTextureVariations(cFDM.Ped(), 0, Index)-1 then
                        SetPedPropIndex(cFDM.Ped(), 0, Index, 1, 0)
                    else
                        SetPedPropIndex(cFDM.Ped(), 0, Index, GetPedPropTextureIndex(cFDM.Ped(), 0) +1, 0)
                    end
                end,
            })
            RageUI.List('Masks',Clothing.Masks, GetPedDrawableVariation(cFDM.Ped(), 1)+1, "~h~~r~Texture: " .. GetPedTextureVariation(cFDM.Ped(), 1) .. " / Total Textures: " ..GetNumberOfPedTextureVariations(cFDM.Ped(), 1), {}, true, {
                onActive = function()
                    ClothingIndex = 1;
                end,
                onListChange = function(Index, Item)
                    Index = Index
                    SetPedComponentVariation(cFDM.Ped(), 1, Index-1, 1, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedTextureVariation(cFDM.Ped(), 1) == GetNumberOfPedTextureVariations(cFDM.Ped(), 1) then
                        SetPedComponentVariation(cFDM.Ped(), 1, GetPedDrawableVariation(cFDM.Ped(), 1), 1, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), 1, GetPedDrawableVariation(cFDM.Ped(), 1), GetPedTextureVariation(cFDM.Ped(), 1)+1, 0)
                    end
                end,
            })
            RageUI.List('Neck Accessories', Clothing.Accessories, GetPedDrawableVariation(cFDM.Ped(), 7)+1, "~h~~r~Texture: " .. GetPedTextureVariation(cFDM.Ped(), 7) .. " / Total Textures: " ..GetNumberOfPedTextureVariations(cFDM.Ped(), 7), {}, true, {
                onActive = function()
                    ClothingIndex = 7;
                end,
                onListChange = function(Index, Item)
                    ClothingIndex = 7;
                    Index = Index
                    SetPedComponentVariation(cFDM.Ped(), 7, Index-1, 1, 0)
                end,
                onSelected = function(Index, Item)
                    if GetPedTextureVariation(cFDM.Ped(), 7) == GetNumberOfPedTextureVariations(cFDM.Ped(), 7) then
                        SetPedComponentVariation(cFDM.Ped(), 7, GetPedDrawableVariation(cFDM.Ped(), 7), 1, 0)
                    else
                        SetPedComponentVariation(cFDM.Ped(), 7, GetPedDrawableVariation(cFDM.Ped(), 7), GetPedTextureVariation(cFDM.Ped(), 7) +1, 0)
                    end
                end,
            })
        end)
        RageUI.IsVisible(Clear, function()
            RageUI.Button('Clear Props', '~h~~r~Clear All Props Applied To Ped', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    ClearAllPedProps(cFDM.Ped())
                end,
            });
        end)
        RageUI.IsVisible(Options, function()
            RageUI.Separator("~h~Current Outfit Numbers")
            RageUI.Separator("~h~Hat: " ..GetPedDrawableVariation(cFDM.Ped(), 0).. " (~r~Texture~w~: " .. GetPedTextureVariation(cFDM.Ped(), 0).. ")")
            RageUI.Separator("~h~Mask: " ..GetPedDrawableVariation(cFDM.Ped(), 1).. " (~r~Texture~w~: " .. GetPedTextureVariation(cFDM.Ped(), 1).. ")")
            RageUI.Separator("~h~Hoodie: " ..GetPedDrawableVariation(cFDM.Ped(), 11).. " (~r~Texture~w~: " .. GetPedTextureVariation(cFDM.Ped(), 11).. ")")
            RageUI.Separator("~h~Under Shirt: " ..GetPedDrawableVariation(cFDM.Ped(), 8).." (~r~Texture~w~: " .. GetPedTextureVariation(cFDM.Ped(), 8).. ")")
            RageUI.Separator("~h~Vest: " ..GetPedDrawableVariation(cFDM.Ped(),9).. " (~r~Texture~w~: " .. GetPedTextureVariation(cFDM.Ped(), 9).. ")")
            RageUI.Separator("~h~Trousers: " ..GetPedDrawableVariation(cFDM.Ped(), 4).." (~r~Texture~w~: " .. GetPedTextureVariation(cFDM.Ped(), 4).. ")")
            RageUI.Separator("~h~Shoes: " ..GetPedDrawableVariation(cFDM.Ped(), 6).. " (~r~Texture~w~: " .. GetPedTextureVariation(cFDM.Ped(), 6).. ")")
            RageUI.Button('Share Clothing With Nearest Player(Coming Soon)', '~h~~r~Offer Clothing To Nearest Player.', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    --
                end,
            });
            RageUI.Button('Request Nearest Player Clothing(Coming Soon)', '~h~~r~Offer Clothing To Nearest Player.', {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    --
                end,
            });
        end)
    end
end)

local cfg = module("cfg/skinshops")
local skinshops = cfg.skinshops 
Citizen.CreateThread(function()
    for i,v in pairs(skinshops) do 
        local x,y,z = v[2], v[3], v[4]
        local Blip = AddBlipForCoord(x, y, z)
        SetBlipSprite(Blip, 73)
        SetBlipDisplay(Blip, 4)
        SetBlipScale(Blip, 0.7)
        SetBlipColour(Blip, 1)
        SetBlipAsShortRange(Blip, true)
        AddTextEntry("MAPBLIP", 'Clothing Store')
        BeginTextCommandSetBlipName("MAPBLIP")
        EndTextCommandSetBlipName(Blip)
        SetBlipCategory(Blip, 1)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        for i,v in pairs(skinshops) do 
            local x,y,z = v[2], v[3], v[4]
            if not HasStreamedTextureDictLoaded("clothing") then
				RequestStreamedTextureDict("clothing", true)
				while not HasStreamedTextureDictLoaded("clothing") do
					Wait(1)
				end
			else
			    DrawMarker(9, x, y, z, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.7, 0.7, 0.7, 250, 0, 0, 1.0,false, false, 2, true, "clothing", "nade", false)
            end 
        end 
    end
end)

local inMarker = false;
local MenuOpen = false;
Citizen.CreateThread(function()
    while true do 
        Wait(250)
        inMarker = false;
        local coords = GetEntityCoords(cFDM.Ped())
        for i,v in pairs(skinshops) do 
            local x,y,z = v[2], v[3], v[4]
            if #(coords - vec3(x,y,z)) <= 1.0 then
                inMarker = true 
                break
            end    
        end
        if not MenuOpen and inMarker then 
            MenuOpen = true
            GetMaxFromForAll()
            RageUI.Visible(ClothingStore, true)
        end
        if not inMarker and MenuOpen then
            CloseMenus()
            MenuOpen = false
        end
    end
end)