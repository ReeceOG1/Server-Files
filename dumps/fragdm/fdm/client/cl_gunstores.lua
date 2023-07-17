local previewWeaponCoords = vec3(976.4517+0.2, 2905.2566+0.05, 32.1133-1.3);
local currentWeaponObject = nil;
local currentPreviewModel = nil;
local isFirstWeapon = false;
local gunShopConfig = {
    Weapons = {
        ["WEAPON_LVGUN"] = {price = 2000, name = "LV Assault Rifle", modelType = "ar"};
        ["WEAPON_DARKMATTERVANDAL"] = {price = 2000, name = "Dark Matter Vandal", modelType = "ar"};
        ["WEAPON_ODIN"] = {price = 20000, name = "Odin LMG", modelType = "lmg"};
        ["WEAPON_M249PLAYMAKER"] = {price = 20000, name = "M249-Playmaker LMG", modelType = "lmg"};
        ["WEAPON_DEVASTATORSSNIPER"] = {price = 4000, name = "Devastator Sniper", modelType = "sniper"};
        ["WEAPON_AN94"] = {price = 2000, name = "AN94 Assault Rifle", modelType = "ar"};
        ["WEAPON_galilkz"] = {price = 2000, name = "Galil Assault Rifle", modelType = "ar"};
        ["WEAPON_NERFMOSIN"] = {price = 4000, name = "Nerf Mosin Sniper", modelType = "sniper"};
    }
}

local function removePreviewWeapon()
    SetEntityAsMissionEntity(currentWeaponObject, false, true)
    DeleteObject(currentWeaponObject)
    currentWeaponObject = nil;
end

local function loadWeaponModel(Model)
    TriggerEvent("FDM:Loading", true)
    while not HasWeaponAssetLoaded(Model) do
        RequestWeaponAsset(Model, 31, 26)
        Wait(100)
    end
    TriggerEvent("FDM:Loading", false)
    return true;
end

local function previewWeapon(Model)
    if currentPreviewModel ~= Model then
        removePreviewWeapon()
        if loadWeaponModel(Model) then
            currentWeaponObject = CreateWeaponObject(GetHashKey(Model), 0, previewWeaponCoords.x, previewWeaponCoords.y,previewWeaponCoords.z, false, 1.0, false)
            SetEntityHeading(currentWeaponObject, 178.0697)
            currentPreviewModel = Model;
        end
    end
end

local GunDealer = RageUI.CreateMenu("", "~h~~r~FDM Custom Gun Dealer", 1415,10, "banners", "Gunstore")
Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(GunDealer, function()
            if json.encode(gunShopConfig.Weapons) == "[]" then
                RageUI.Separator("~h~~r~There are currently no weapons for sell.")
            else
                for k,v in pairs(gunShopConfig.Weapons) do
                    RageUI.Button(v.name, "~h~~r~Purchase for " ..cFDM.FormatPrice(v.price).. " Point/s", {RightLabel = "→ → →",}, true, {
                        onActive = function()
                            previewWeapon(k)
                        end,
                        onSelected = function()
                            TriggerServerEvent("FDM:PurchaseCustomWeapon", k)
                        end,
                    });
                end
            end
        end)
        Wait(0)
    end
end)


Citizen.CreateThread(function()
    while true do
        local c = #(GetEntityCoords(cFDM.Ped()) - vec3(977.7922, 2905.7107, 31.1208))
        if isOpen then
            if IsControlJustPressed(0, 177) then
                removePreviewWeapon()
                DestroyCamera()
                isOpen = false;
            end
        end
        if c > 2.0 and isOpen then
            RageUI.Visible(GunDealer, false)
            isOpen = false;
            removePreviewWeapon()
            DestroyCamera()
        end
        Wait(0)
    end
end)

local displayCam = false;
local gunStorePed = nil;
local function openGunMenu(entity)
    RageUI.Visible(GunDealer, true)
    isOpen = true;
    CreationCamHead(entity)
end

function CreationCamHead(entity)
    gunStorePed = entity;
	displayCam = CreateCam('DEFAULT_SCRIPTED_CAMERA')
	SetCamCoord(displayCam, vec3(977.0275, 2903.7031, 31.1208))
	PointCamAtCoord(displayCam, previewWeaponCoords)
	SetCamActive(displayCam, true)
	RenderScriptCams(true, true, 2000, true, true)
end

function DestroyCamera()
    RenderScriptCams(false, false, 0, 1, 0)
    SetCamActive(displayCam, false)
    DestroyCam(displayCam, true)
    currentWeaponObject = nil;
    currentPreviewModel = nil;
end

RegisterNetEvent("FWD:GunStore", function(entity)
    openGunMenu(entity)
end)