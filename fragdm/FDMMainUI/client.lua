local isPlaying = false;
local pauseMenuActive = false;

local function UI(bool)
    if bool then
        SendNUIMessage({
			action = "open",
            data = GetPlayerName(PlayerId()) .. ": " ..GetPlayerServerId(PlayerId())
		})
		SetNuiFocus(true, true)
    else
        SendNUIMessage({
            action = "hide",
        })
        SetNuiFocus(false, false)
    end
end

RegisterNetEvent("FDM:MainMenu", function(bool)
    if bool and not isPlaying then
        UI(bool)
    else
        UI(bool)
    end
end)

RegisterNUICallback('FDM:MainMenu', function(data, cb)
    if data.action == "deathmatch" then
        if not isPlaying then
            DoScreenFadeOut(500)
            Wait(510)
            UI(false)
            SetEntityCoords(PlayerPedId(), 1008.5514, 2905.9902, 34.6209, false, false, false, false)
            Wait(2500)
            DoScreenFadeIn(1900)
            isPlaying = true;
            cb(true)
        end
    elseif data.action == "quit" then
        TriggerServerEvent("FDM:Leave")
        cb(true)
    elseif data.action == "settings" then
        pauseMenuActive = true;
        RestartFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'), "FE_MENU_VERSION_LANDING_MENU")
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'),0,-1) 
        UI(false)
        cb(true)
    end
end)

Citizen.CreateThread(function()
    while true do
        if pauseMenuActive then
            DisableControlAction(0, 202, 0)
            if IsDisabledControlJustPressed(0, 202) then
                UI(true)
                pauseMenuActive = false;
            end
        end
        Wait(0)
    end
end)

