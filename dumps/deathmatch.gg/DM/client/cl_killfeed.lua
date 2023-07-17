-- Configuration Options
local config = {
	prox_enabled = false,					-- Proximity Enabled
	prox_range = 100,						-- Distance	-- Toggle Kill Feed Command
}

local toggledkf = true
local toggledkfdistance = true

-- Weapons Table
local weapons = {
	[-1569615261] = 'melee',

	-- Casual
	[GetHashKey("WEAPON_AK200DM")] = 'aks',
	[GetHashKey("WEAPON_AK74GOLDDM")] = 'aks',
	[GetHashKey("WEAPON_AK74DM")] = 'aks',
	[GetHashKey("WEAPON_ANARCHYLR300DM")] = 'aks',
	[GetHashKey("WEAPON_SIG516DM")] = 'aks',
	[GetHashKey("WEAPON_SPAR16DM")] = 'aks',
	[GetHashKey("WEAPON_MOSINNAGANTDM")] = 'mosin',

	-- Redzone
	[GetHashKey("WEAPON_APPISTOL")] = 'pistol',
	[GetHashKey("WEAPON_COMBATPISTOL")] = 'pistol',
}

local weaponNames = {
	[-1569615261] = 'melee',

	-- Casual
	[GetHashKey("WEAPON_AK200DM")] = 'AK-200',
	[GetHashKey("WEAPON_AK74GOLDDM")] = 'AK-74 Gold',
	[GetHashKey("WEAPON_AK74DM")] = 'AK-74',
	[GetHashKey("WEAPON_ANARCHYLR300DM")] = 'Anarchy LR300',
	[GetHashKey("WEAPON_SIG516DM")] = 'SIG-516',
	[GetHashKey("WEAPON_SPAR16DM")] = 'Spar-16',
	[GetHashKey("WEAPON_MOSINNAGANTDM")] = 'Mosin',

	-- Redzone
	[GetHashKey("WEAPON_APPISTOL")] = 'AP-Pistol',
	[GetHashKey("WEAPON_COMBATPISTOL")] = 'Combat Pistol',
}

local feedActive = true

local isDead = false
Citizen.CreateThread(function()
    while true do
		local killed = GetPlayerPed(PlayerId())
		local killedCoords = GetEntityCoords(killed)
		if IsEntityDead(killed) and not isDead then
            local killer = GetPedKiller(killed)
            if killer ~= 0 then
                if killer == killed then
					TriggerServerEvent('DM:Died', killedCoords)
				else
					local KillerNetwork = NetworkGetPlayerIndexFromPed(killer)
					if KillerNetwork == "**Invalid**" or KillerNetwork == -1 then
						TriggerServerEvent('DM:Died', killedCoords)
					else
						TriggerServerEvent('DM:Killed', GetPlayerServerId(KillerNetwork), getWeaponElementbyHash("Img", GetPedCauseOfDeath(killed)), killedCoords, getWeaponElementbyHash("Name", GetPedCauseOfDeath(killed)))
					end
                end
            else
				TriggerServerEvent('DM:Died', killedCoords)
            end
            isDead = true
        end
		if not IsEntityDead(killed) then
			isDead = false
		end
        Citizen.Wait(50)
    end
end)

RegisterNetEvent('DM:AnnounceKill')
AddEventHandler('DM:AnnounceKill', function(killed, killer, weapon, coords, killergroup, killedgroup, Distance)
	if feedActive then
		if coords ~= nil and config.prox_enabled then
			local myLocation = GetEntityCoords(GetPlayerPed(PlayerId()))
			if #(myLocation - coords) < config.prox_range then
				if not toggledfk then
					SendNUIMessage({
						type = 'newKill',
						killer = killer,
						killed = killed,
						weapon = weapon,
						killergroup = killergroup,
						killedgroup = killedgroup,
						container = "killContainer",
						distance = "", 
					})
				end
			end
		else
			if killed == GetPlayerName(PlayerId()) or killer == GetPlayerName(PlayerId()) then
				container = "selfkillcontainer"
			else
				container = "killContainer"
			end
			local Distance1 = ""
			if toggledkfdistance then
				Distance1 = " ["..round(Distance).. "m]"
			else
				Distance1 = ""
			end

			if not toggledfk then
				SendNUIMessage({
					type = 'newKill',
					killer = killer,
					killed = killed,
					weapon = weapon,
					killergroup = killergroup,
					killedgroup = killedgroup,
					container = container,
					distance = Distance1, 
				})
			end
		end
	end
end)

function round(number)
    local _, decimals = math.modf(number)
    if decimals < 0.5 then return math.floor(number) end
    return math.ceil(number)
end

RegisterNetEvent('DM:AnnounceDeath')
AddEventHandler('DM:AnnounceDeath', function(killed, coords, group)
	if feedActive then
		local container = "killContainer"
		if coords ~= nil and config.prox_enabled then
			local myLocation = GetEntityCoords(GetPlayerPed(PlayerId()))
			if #(myLocation - coords) < config.prox_range then
				if not toggledfk then
					SendNUIMessage({
						type = 'newDeath',
						killed = killed,
						group = group,
						container = "killContainer",
					})
				end
			end
		else
			if killed == GetPlayerName(PlayerId()) then
				container = "selfkillcontainer"
			else
				container = "killContainer"
			end
			if not toggledfk then
				SendNUIMessage({
					type = 'newDeath',
					killed = killed,
					group = group,
					container = container,
				})
			end
		end
	end
end)


function getWeaponElementbyHash(Element, hash)
    if Element == "Img" then
        for k,v in pairs(globalWeaponList) do
            if GetHashKey(k) == hash then
                return v[2]
            end
        end
    elseif Element == "Name" then
        for k,v in pairs(globalWeaponList) do
            if GetHashKey(k) == hash then
                return v[1]
            end
        end
    end
end

function DrawNotificationsOne(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end