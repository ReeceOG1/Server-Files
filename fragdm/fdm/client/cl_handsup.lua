local handsup = false
CreateThread(function()		
	RequestAnimDict('mp_arresting')
	RequestAnimDict('random@arrests')
	RequestAnimDict('missminuteman_1ig_2')
	while true do
		local ped = PlayerPedId()
		if GetEntityHealth(ped) ~= 101 then
			if IsControlPressed(1, 323) then
				DisablePlayerFiring(ped, true)
				DisableControlAction(0, 22, true)
				DisableControlAction(0, 25, true)
				if not IsEntityDead(ped) then
					if not handsup then
						handsup = true
						TaskPlayAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 7.0, 1.0, -1, 50, 0, false, false, false)
					end
				end
			end
			if IsControlReleased(1, 323) and handsup then
				handsup = false
				CreateThread(function()
					local enableFiring = false
					CreateThread(function()
						Wait(1000)
						enableFiring = true
					end)
					while not enableFiring do
						DisablePlayerFiring(ped, true)
						Wait(0)
					end
				end)
				DisableControlAction(0, 21, true)
				DisableControlAction(0, 137, true)
				ClearPedTasks(ped)
			end
		end
		Wait(0)
	end
end)