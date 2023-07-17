RegisterCommand("getcoords",function()
	local coords = GetEntityCoords(GetPlayerPed(-1))
	TriggerServerEvent("DM:Coords", coords)
end)