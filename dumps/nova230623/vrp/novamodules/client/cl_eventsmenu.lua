RMenu.Add('EventsMenu', 'main', RageUI.CreateMenu("","~b~NOVA Events~w~",1300,100, "banners", "settings"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('EventsMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("General Events")
            RageUI.Button("Chat Event", nil, { RightLabel = '→→→'}, true, function(Hovered, Active, Selected)
                if Selected then
                    notify("Coming Soon!")
                end
            end)
            RageUI.Separator("~g~Special Events")
            RageUI.Button("Gun Game", nil, { RightLabel = '→→→'}, true, function(Hovered, Active, Selected)
                if Selected then
                    notify("Coming Soon!")
                end
            end)
            RageUI.Button("~r~Purge Event", nil, { RightLabel = '→→→'}, true, function(Hovered, Active, Selected)
                if Selected then
                    purge()
                end
            end)

            RageUI.Separator("~y~VIP Events")

            RageUI.Separator("~r~Founder Events")
            RageUI.Button("Birthday Event", nil, { RightLabel = '→→→'}, true, function(Hovered, Active, Selected)
                if Selected then
                    birthday()
                end
            end)

        end)
    end
end)

RegisterCommand('eventsmenu', function()
    TriggerServerEvent('NOVA:openEventsMenu')
end)

function tvRP.openEventsMenu()
    RageUI.Visible(RMenu:Get('EventsMenu', 'main'), not RageUI.Visible(RMenu:Get('EventsMenu', 'main')))
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function purge()
    TriggerServerEvent("NOVA:ServerPurge")
end

function birthday()
    TriggerServerEvent("NOVA:GiveBirthdayMoney", Amount)
end