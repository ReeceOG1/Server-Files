-- RMenu.Add('GMANHSMenu', 'main', RageUI.CreateMenu("GMA NHS", "~g~NHS Menu",1250,100))

-- RageUI.CreateWhile(1.0, true, function()
--     if RageUI.Visible(RMenu:Get('GMANHSMenu', 'main')) then
--         RageUI.DrawContent({ header = true, glare = true, instructionalButton = true}, function()
--             if IsPedInAnyVehicle(PlayerPedId(), false) == false then

--                 RageUI.Button("Perform Cardiopulmonary Resuscitation (CPR)" , "~b~Perform CPR on the nearest player in a coma", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
--                     if Selected then 
--                         TriggerServerEvent('GMA:PerformCPR')
--                     end
--                 end)

--                 RageUI.Button("Heal Nearest Player", "~b~Heal the nearest player", { RightLabel = '→'}, true, function(Hovered, Active, Selected) 
--                   if Selected then 
--                       TriggerServerEvent('GMA:HealPlayer')
--                   end
--               end)
                

--             end
--         end)
--     end
-- end)

-- RegisterCommand('nhs', function()
--   if IsPedInAnyVehicle(PlayerPedId(), false) == false then
--     TriggerServerEvent('GMA:OpenNHSMenu')
--   end
-- end)

-- RegisterNetEvent("GMA:NHSMenuOpened")
-- AddEventHandler("GMA:NHSMenuOpened",function()
--   RageUI.Visible(RMenu:Get('GMANHSMenu', 'main'), not RageUI.Visible(RMenu:Get('GMANHSMenu', 'main')))
-- end)

-- RegisterKeyMapping('nhs', 'Opens the NHS menu', 'keyboard', 'U')