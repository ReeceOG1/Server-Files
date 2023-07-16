local SettingsMenu = RageUI.CreateMenu("", "~h~~r~Settings Menu", 1415,10, "banners", "Settings2")
local HitsoundsEnabled = false;
local RenderDistance = 100;
local SelectedHeadshot= 1;
local SelectedChestshot= 1;
local hideCrosshair = false;
local currentWeather = 1;

local hitSoundHead = {
    [1] = {audioFile = "valHead.ogg"};
    [2] = {audioFile = "rustHead.ogg"};
    [3] = {audioFile = "codHead.ogg"};
}

local hitSoundChest = {
    [1] = {audioFile = "valBody.ogg"};
    [2] = {audioFile = "rustBody.ogg"};
    [3] = {audioFile = "codChest.ogg"};
}

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(SettingsMenu, function()
            RageUI.Checkbox('Hitmarker Sounds', "~h~~r~Enables/Disables Hitsounds", HitsoundsEnabled, {}, {
                onSelected = function(Index)
                    HitsoundsEnabled = Index;
                    SetResourceKvpInt("HitsoundsEnabled", HitsoundsEnabled)
                end
            })
            RageUI.List('HeadShot Audio', {
                { Name = "Valorant Headshot", Value = 1},
                { Name = "Rust Headshot", Value = 2},
                { Name = "Cod Headshot", Value = 3},
            }, SelectedHeadshot, description, {}, true, {
                onListChange = function(Index, Item)
                    SelectedHeadshot = Index;
                    SetResourceKvpInt("SelectedHeadshot", SelectedHeadshot)
                end,
            })
            RageUI.List('Chestshot Audio', {
                { Name = "Valorant Chestshot", Value = 1},
                { Name = "Rust Chestshot", Value = 2},
                { Name = "Cod Chestshot", Value = 3},
            }, SelectedChestshot, description, {}, true, {
                onListChange = function(Index, Item)
                    SelectedChestshot = Index;
                    SetResourceKvpInt("SelectedChestshot", SelectedChestshot)
                end,
            })
            RageUI.Checkbox('Crosshair', "~h~~r~Enables/Disables Vanilla Crosshair", hideCrosshair, {}, {
                onSelected = function(Index)
                    hideCrosshair = Index;
                    SetResourceKvpInt("hideCrosshair", hideCrosshair)
                end
            })
        end)
        Wait(0)
    end
end)



Citizen.CreateThread(function()
    if GetResourceKvpInt('HitsoundsEnabled') == 0 then
        HitsoundsEnabled = false;
    elseif GetResourceKvpInt('HitsoundsEnabled') == 1 then
        HitsoundsEnabled = true;
    elseif GetResourceKvpInt('hideCrosshair') == 1 then
        hideCrosshair = true;
    elseif GetResourceKvpInt('hideCrosshair') == 0 then
        hideCrosshair = false;
    end
    SelectedChestshot = GetResourceKvpInt("SelectedChestshot")
    SelectedHeadshot = GetResourceKvpInt("SelectedHeadshot")
end)


function cFDM.FetchHsData()
    return {HitsoundsEnabled,hitSoundHead[SelectedHeadshot].audioFile,hitSoundChest[SelectedChestshot].audioFile}
end

Citizen.CreateThread(function()
    while true do
        if hideCrosshair then
            HideHudComponentThisFrame(14)
        end
        Wait(0)
    end
end)


RegisterCommand("settings", function()
    RageUI.Visible(SettingsMenu, true)
end)


RegisterKeyMapping("settings", "Open Settings Menu", "KEYBOARD", "F1")