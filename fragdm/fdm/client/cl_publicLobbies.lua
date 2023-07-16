local isOpen = false;
local OpenLobbies = {};
local PublicLobbies = RageUI.CreateMenu("", "~h~~r~Public Lobbies", 1415, 30, "banners", "Public")
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        RageUI.IsVisible(PublicLobbies, function()
            for k,v in pairs(OpenLobbies) do
                RageUI.Button(k, "~h~Current Players: " ..v.Players, {RightLabel = "→ → →",}, true, {
                    onSelected = function()
                        TriggerServerEvent("FDM:JoinPublicLobby", k)
                        RageUI.Visible(PublicLobbies, false)
                    end,
                });
            end
        end)
    end
end)

RegisterNetEvent("FDM:ReceivePublicLobbies", function(publicLobbies)
    OpenLobbies = publicLobbies;
    RageUI.Visible(PublicLobbies, true)
    isOpen = not isOpen;
end)

local gameMode = false;
Citizen.CreateThread(function()
    while true do
        if isOpen then
            if #(GetEntityCoords(cFDM.Ped()) - vec3(992.5842, 2901.6086, 31.1209)) > 2.0 then
                RageUI.Visible(PublicLobbies, false)
                isOpen = false;
            end
        end
        if gameMode == "Mosin-Only" then
            DisableControlAction(0, 37, true)
            if GetCurrentPedWeapon(cFDM.Ped(), 1) ~= GetHashKey("WEAPON_NERFMOSIN") then
                SetCurrentPedWeapon(cFDM.Ped(), GetHashKey("WEAPON_NERFMOSIN", true))
            end
        end
        Wait(0)
    end
end)

function cFDM.SetGameMode(mode)
    gameMode = mode;
end

function cFDM.GetGameMode()
    return gameMode;
end