local ClosedLobbies = {};
local PrivateLobbies = RageUI.CreateMenu("", "~h~~r~Private Lobbies", 1415, 30, "banners", "Private")
local CreateLobby = RageUI.CreateSubMenu(PrivateLobbies, "", "~h~~r~Create Lobby")
local Locations = RageUI.CreateSubMenu(PrivateLobbies, "", "~h~~r~Lobby Location")
local GameMode = RageUI.CreateSubMenu(PrivateLobbies, "", "~h~~r~Lobby GameMode")
local JoinLobby = RageUI.CreateSubMenu(PrivateLobbies, "", "~h~~r~Join Lobby")
local LobbyOwnerMenu = RageUI.CreateMenu("", "~h~~r~Lobby Owner Settings", 1415, 30, "banners", "LobbyManager")
local LobbyPassword = "Undefined";
local LobbyGameMode = "Undefined";
local LobbyLocation = "Undefined";
local isOwner = false; 
local changingLocation = false;
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        RageUI.IsVisible(LobbyOwnerMenu, function()
            if not changingLocation and not changingGameMode then
                RageUI.Button("Change Location", "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        changingLocation = true;
                    end,
                });
                RageUI.Button("Change GameMode", "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        changingGameMode = true;
                    end,
                });
                RageUI.Button("Disaband Lobby", "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        TriggerServerEvent("FDM:ClosePrivateLobby")
                    end,
                });
            end
            if changingGameMode then
                for k,v in pairs(FDMConfig.GameModes) do
                    RageUI.Button(k, " ", {RightLabel = "→ → →",}, true, {
                        onSelected = function()
                            TriggerServerEvent("FDM:ChangeGameMode", k)
                            changingGameMode = false;
                        end,
                    });
                end
            end
            if changingLocation then
                for k,v in pairs(FDMConfig.Locations) do
                    RageUI.Button(k, " ", {RightLabel = "→ → →",}, true, {
                        onSelected = function()
                            TriggerServerEvent("FDM:ChangeLobbyLocation", k)
                            changingLocation = false;
                        end,
                    });
                end
            end
        end)
        RageUI.IsVisible(PrivateLobbies, function()
            RageUI.Button("Create Lobby", "", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(CreateLobby, true)
                end,
            });
            RageUI.Button("Join Lobby", "", {RightLabel = "→ → →",}, true, {
                onSelected = function()
                    RageUI.Visible(JoinLobby, true)
                end,
            });
        end)
        RageUI.IsVisible(CreateLobby, function()
            RageUI.Separator("Lobby Password: " ..LobbyPassword)
            RageUI.Separator("Lobby GameMode: " ..LobbyGameMode)
            RageUI.Separator("Lobby Location: " ..LobbyLocation)
            if LobbyPassword == "Undefined" then
                RageUI.Button("Set Password", "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        local Password = cFDM.Keyboard("Password(10c)", "", 10)
                        if Password then
                            LobbyPassword = Password;
                        end
                    end,
                });
            end
            if LobbyGameMode == "Undefined" then
                RageUI.Button("Set GameMode", "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        RageUI.Visible(GameMode, true)
                    end,
                });
            end
            if LobbyLocation == "Undefined" then
                RageUI.Button("Set Location", "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        RageUI.Visible(Locations, true)
                    end,
                });
            end
            if LobbyLocation ~= "Undefined" and LobbyGameMode ~= "Undefined" and LobbyPassword ~= "Undefined" then
                RageUI.Button("Create Lobby", "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        TriggerServerEvent("FDM:CreateCustomLobbie", LobbyLocation, LobbyGameMode, LobbyPassword)
                        LobbyLocation = "Undefined";
                        LobbyGameMode = "Undefined";
                        LobbyPassword = "Undefined";
                        RageUI.Visible(CreateLobby, false)
                    end,
                });
                RageUI.Button("Clear Lobby Settings", "", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        LobbyLocation = "Undefined";
                        LobbyGameMode = "Undefined";
                        LobbyPassword = "Undefined";
                    end,
                });
            end
        end)
        RageUI.IsVisible(GameMode, function()
            for k,v in pairs(FDMConfig.GameModes) do
                RageUI.Button(k, " ", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        LobbyGameMode = k;
                        RageUI.Visible(CreateLobby, true)
                    end,
                });
            end
        end)
        RageUI.IsVisible(Locations, function()
            for k,v in pairs(FDMConfig.Locations) do
                RageUI.Button(k, " ", {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        LobbyLocation = k;
                        RageUI.Visible(CreateLobby, true)
                    end,
                });
            end
        end)
        RageUI.IsVisible(JoinLobby, function()
            for k,v in pairs(ClosedLobbies) do
                RageUI.Button(k, "Location: " ..v[1].. " | GameMode: " ..v[3], {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        local Password = cFDM.Keyboard("Password(10c)", "", 10)
                        if Password then
                            TriggerServerEvent("FDM:JoinPrivateLobby", v[2], Password)
                        end
                    end,
                });
            end
        end)
    end
end)


RegisterCommand("lobbymanagement", function()
    if isOwner then
        changingLocation = nil;
        changingGameMode = nil;
        RageUI.Visible(LobbyOwnerMenu, true)
    end
end)

RegisterKeyMapping("lobbymanagement", "Opens lobby management menu for custom lobbies", "KEYBOARD", "F7")

function cFDM.setOwnsLobby(value)
    isOwner = value;
end

function cFDM.Keyboard(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
    blockinput = true 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Wait(250) 
        blockinput = false
        return result
    else
        Wait(250) 
        blockinput = false 
        return nil 
    end
end

RegisterNetEvent("FDM:ReceivePrivateLobbies", function(publicLobbies)
    ClosedLobbies = publicLobbies;
    RageUI.Visible(PrivateLobbies, true)
end)


function cFDM.loadVehModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(100)
    end
end