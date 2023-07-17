local Spawns = 0

AddEventHandler("playerSpawned", function(spawn)
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)
	local mhash = "mp_m_freemode_01"
	RequestModel(mhash)
	Wait(100)
	SetPlayerModel(PlayerId(), mhash)
	SetModelAsNoLongerNeeded(mhash)
	ClearPedBloodDamage(PlayerPedId())
	SetPedComponentVariation(PlayerPedId(), 8, 15, 1, 0)
	SetPedComponentVariation(PlayerPedId(), 11, 105, 0, 0)
	SetPedComponentVariation(PlayerPedId(), 4, 15, 3, 0)
	SetPedComponentVariation(PlayerPedId(), 6, 34, 0, 0)
	SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 0)
    SetPedPropIndex(PlayerPedId(), 0, 3, 2)
	SetEntityHealth(PlayerPedId(), 200)
	SetPedArmour(PlayerPedId(), 100)
	DoScreenFadeIn(75000)
	Spawns = Spawns + 1
	if Spawns == 1 then
		TriggerEvent("FirstSpawn")
	elseif SelectedZone == "Glife" then
		SetEntityCoords(PlayerPedId(), 1534.709, 1702.526, 109.7114)
	elseif SelectedZone == "American" then
		SetEntityCoords(PlayerPedId(), -958.4753, 927.0952, 572.317)
	elseif SelectedZone == "gunGame" then
		gunGameRespawn()
	end

	if Spawns ~= 1 and SelectedZone ~= "gunGame" then
		RespawnPlayer()
		SetLocation() -- Needs Configuring
	end
end)

