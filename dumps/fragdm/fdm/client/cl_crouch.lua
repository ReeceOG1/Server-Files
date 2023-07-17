local crouched = false
local proned = false
Citizen.CreateThread( function()
	while true do 
        Wait(0)
		local ped = PlayerPedId()
		if (DoesEntityExist(ped) and not IsEntityDead(ped)) and not IsPedInAnyVehicle(ped, false) then 
			DisableControlAction(0, 36, true) 
			if (not IsPauseMenuActive() ) then 
				if (IsDisabledControlJustPressed(0, 36) ) then 
					RequestAnimSet( "move_ped_crouched" )
					RequestAnimSet("MOVE_M@TOUGH_GUY@")
					
					while ( not HasAnimSetLoaded( "move_ped_crouched")) do 
						Citizen.Wait( 100 )
					end 
					while (not HasAnimSetLoaded("MOVE_M@TOUGH_GUY@")) do 
						Citizen.Wait( 100 )
					end 		
					if crouched then 
						ResetPedMovementClipset(ped)
						ResetPedStrafeClipset(ped)
						SetPedMovementClipset(ped,"MOVE_M@TOUGH_GUY@", 0.5)
						crouched = false 
					elseif not crouched then
						SetPedMovementClipset( ped, "move_ped_crouched", 0.55 )
						SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
						crouched = true 
					end 
				end
			end
		else
			crouched = false
		end
	end
end)