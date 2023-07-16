local countdown = 0
RegisterNetEvent("NOVA:c", function() SendNUIMessage({ app = "", type = "APP_TOGGLE", }) SetNuiFocus(false, false) countdown = 0 end)
RegisterNetEvent("NOVA:Respawn", function() SendNUIMessage({ page = "deathscreen", type = "RESPAWN_KEY_PRESSED", }) end)
RegisterNetEvent("NOVA:s", function(timer, killer, killerPermId, killedByWeapon, suicide) SendNUIMessage({ page = "deathscreen", type = "SHOW_DEATH_SCREEN", info = { timer = timer, killer = killer, killerPermId = killerPermId, killedByWeapon = killedByWeapon, suicide = suicide, }})  countdown = math.floor(timer) end)
RegisterNetEvent("NOVA:NHS", function() SendNUIMessage({ page = "deathscreen", type = "DEATH_SCREEN_NHS_CALLED", }) end)
CreateThread(function() while true do if countdown > 0 then countdown = countdown - 1 if countdown == 0 then TriggerEvent("NOVA:countdownEnded") end end Wait(1000) end end)