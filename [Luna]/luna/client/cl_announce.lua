RMenu.Add('announcemenu', 'main', RageUI.CreateMenu("Announce", "Make an announcement"))

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        RageUI.IsVisible(RMenu:Get('announcemenu', 'main'), true, true, true, function()
            RageUI.Button('Admin Announce', nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('adminAnnouncePrompt')
                end
            end)
        end, function()
        end)
    end
end)

RegisterNetEvent('showAnnouncement')
AddEventHandler('showAnnouncement', function(message)
    Citizen.CreateThread(function()
        ShowBigMessage("~r~LUNA Announcement", message, 10000) -- This will make the text appear for 10 seconds, adjust as needed.
    end)
end)

RegisterCommand('announcemenu', function(source, args, rawCommand)
    TriggerServerEvent('checkPermissionAnnounceMenu')
end, false)

RegisterNetEvent('openAnnounceMenu')
AddEventHandler('openAnnounceMenu', function()
    local message = GetUserInput("Enter your announcement:", "", 100)
    if message ~= nil then
        TriggerServerEvent('adminAnnounce', message)
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function ShowBigMessage(title, message, duration)
    local scaleform = RequestScaleformMovie('MIDSIZED_MESSAGE')

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_MIDSIZED_MESSAGE')
    PushScaleformMovieFunctionParameterString(title)
    PushScaleformMovieFunctionParameterString(message)
    EndScaleformMovieMethod()

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
    end)

    Citizen.Wait(duration)
    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function GetUserInput(title, defaultText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', title)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", defaultText, "", "", "", maxLength)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    end
    Citizen.Wait(500)
    return nil
end
