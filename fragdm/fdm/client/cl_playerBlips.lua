Citizen.CreateThread(function()
	local blips = {}
	while true do
        for _,v in pairs(GetActivePlayers()) do
			local playerPed = GetPlayerPed(v)
            local playerName = GetPlayerName(NetworkGetPlayerIndexFromPed(playerPed))
            if playerPed ~= cFDM.Ped() then
                RemoveBlip(blips[v])
                local blip = AddBlipForEntity(playerPed)
                SetBlipNameToPlayerName(blip, playerName)
                SetBlipSprite(blip, 303)
                SetBlipColour(blip, 1)
                SetBlipScale(blip, 0.7)
                SetBlipAsShortRange(blip, true)
                blips[v] = blip;
            end
		end
        Wait(500)
	end
end)