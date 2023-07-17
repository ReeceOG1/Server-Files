local GunSelector = RageUI.CreateMenu("", "~r~Lobby Gun Store", 1415,10,"banners", "Gunstore")
local CustomWeapons = RageUI.CreateSubMenu(GunSelector, "", "~r~Custom Weapon Selector")
local playerGunData = {};
Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(GunSelector, function()
            RageUI.Button("~h~~y~Custom Weapons", "~h~~r~Select one of your custom weapons", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(CustomWeapons, true)
                end,
            });
            for k,v in pairs(FDMConfig.Weapons) do
                RageUI.Button(v.name, "~h~~r~Press ENTER To Equip Weapon", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        TriggerServerEvent("FDM:GunSelectorWeapon", v.hash)
                    end,
                });
            end
        end)
        RageUI.IsVisible(CustomWeapons, function()
            for k,v in pairs(playerGunData) do
                RageUI.Button(v.Weapon_Name, "~h~~r~Press ENTER To Equip Weapon", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        TriggerServerEvent("FDM:GunSelectorWeapon", v.Weapon_SpawnCode, true)
                    end,
                });
            end
        end)
        Wait(0)
    end
end)

RegisterCommand("Gunselector", function()
    if cFDM.GetGameMode() ~= "Car-Scraps" and cFDM.GetGameMode() ~= "Mosin-Only" then
        TriggerServerEvent("FDM:FetchCustomWeapons")
    end
end)


RegisterNetEvent("FDM:ReceiveCustomWeapons", function(data)
    playerGunData = data;
    RageUI.Visible(GunSelector, true)
end)


RegisterKeyMapping("Gunselector", "Opens Gun Selector Menu", "KEYBOARD", "F3")