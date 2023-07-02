-- currentHours = 0

-- RMenu.Add('DailyRewards', 'main', RageUI.CreateMenu("","Main Menu",10,50, "rewards", "rewards"))

-- RageUI.CreateWhile(1.0, true, function()
--     if RageUI.Visible(RMenu:Get('DailyRewards', 'main')) then
--         RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
--             RageUI.Separator('You have no login streak.')
--             RageUI.ButtonWithStyle("Day 1", nil,{ RightLabel = "£10,000" }, true, function(Hovered, Active, Selected)
--                 if Active then
--                     DrawAdvancedText(0.243, 0.235, 0.00, 0.0028, 0.4, '24 Hours required',  255, 255, 255, 255, 6, 0)
--                 end
--                 if Selected then
--                     TriggerServerEvent('LUNA:hoursReward', 1)
--                 end
--             end) 
--             RageUI.ButtonWithStyle("Day 2", nil,{ RightLabel = "£20,000" }, true, function(Hovered, Active, Selected)
--                 if Active then
--                     DrawAdvancedText(0.243, 0.273, 0.00, 0.0028, 0.4, '48 Hours required',  255, 255, 255, 255, 6, 0)
--                 end
--                 if Selected then
--                     TriggerServerEvent('LUNA:hoursReward', 48)
--                 end
--             end) 
--             RageUI.ButtonWithStyle("Day 3", nil,{ RightLabel = "£30,000" }, true, function(Hovered, Active, Selected)
--                 if Active then
--                     DrawAdvancedText(0.243, 0.305, 0.00, 0.0028, 0.4, '72 Hours required',  255, 255, 255, 255, 6, 0)
--                 end
--                     if Selected then
--                     TriggerServerEvent('LUNA:hoursReward', 72)
--                 end
--             end) 
--         end)
--     end
-- end)

-- RegisterNetEvent('LUNA:sendHoursReward')
-- AddEventHandler('LUNA:sendHoursReward', function(hours)
--     currentHours = hours
-- end)




-- RegisterCommand('dailyrewards', function()
--     TriggerServerEvent('LUNA:getHoursReward')
--     RageUI.Visible(RMenu:Get('DailyRewards', 'main'), not RageUI.Visible(RMenu:Get('DailyRewards', 'main')))
-- end)
