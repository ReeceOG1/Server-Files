-- RegisterNetEvent('showNotification')
-- AddEventHandler('showNotification', function(text)
--     ShowNotification(text)
-- end)

-- function ShowNotification(text)
--     SetNotificationTextEntry("STRING")
--     AddTextComponentString(text)
--     DrawNotification(0,1)
-- end


-- -- Setting up a global flag to determine if the oldkillfeed command has been used
-- local oldKillfeedActivated = false

-- RegisterCommand("oldkillfeed", function()
--     if tLUNA.isPlatClub() or tLUNA.isPlusClub() then
--         oldKillfeedActivated = not oldKillfeedActivated -- This will toggle the activation
--         if oldKillfeedActivated then
--             TriggerEvent('showNotification', "~y~Old Killfeed now set to true")
--         else
--             TriggerEvent('showNotification', "~r~Old Killfeed now set to false")
--         end
--     else
--         TriggerEvent('showNotification', "~r~You are not a member of LUNA Plat/Plus Club, you cannot use this command")
--     end
-- end, false)

-- RegisterCommand("testPlusClub", function()
--     if tLUNA.isPlatClub() or tLUNA.isPlusClub() then
--         TriggerEvent('showNotification', "~g~You are a member of the Plus Club")
--     else
--         TriggerEvent('showNotification', "~r~You are not a member of the Plus Club")
--     end
-- end, false)


-- Citizen.CreateThread(function()
--     -- main loop thing
--     local alreadyDead = false
--     while true do
--         Citizen.Wait(50)
--         if oldKillfeedActivated then
--             local playerPed = GetPlayerPed(-1)
--             if IsEntityDead(playerPed) and not alreadyDead then
--                 local killer = GetPedKiller(playerPed)
--                 local killername = false
--                 for id = 0, 255 do -- Increase range to support more players
--                     if killer == GetPlayerPed(id) then
--                         killername = GetPlayerName(id)
--                     end				
--                 end
--                 if killer == playerPed then
--                     TriggerServerEvent('playerDied',0,0)
--                 elseif killername then
--                     TriggerServerEvent('playerDied',killername,1)
--                 else
--                     TriggerServerEvent('playerDied',0,2)
--                 end
--                 alreadyDead = true
--             end
--             if not IsEntityDead(playerPed) then
--                 alreadyDead = false
--             end
--         end
--     end
-- end)
