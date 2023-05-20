local status = false

RegisterNetEvent('GMA:pdRadioAnim')
AddEventHandler('GMA:pdRadioAnim', function(status, b)
    if status then
        loadAnimDict("random@arrests")
        TaskPlayAnim(b, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
        DisableActions(b)
    else
        ClearPedTasks(b)
    end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
        b = GetPlayerPed(-1)
        if IsControlJustReleased(0, 19) then
            TriggerServerEvent('GMA:pdRadioPerms', false, b)
        else
            if IsControlJustPressed(0, 19) then
                TriggerServerEvent('GMA:pdRadioPerms', true, b)
            end
        end
    end
end)

function DisableActions(b)
    DisableControlAction(1, 140, true)
    DisableControlAction(1, 141, true)
    DisableControlAction(1, 142, true)
    DisableControlAction(1, 37, true)
    DisablePlayerFiring(b, true)
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end
