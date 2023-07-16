local disPlayerNames = 5
local showids = true
local playerDistances = {}

local function DrawText3D(position, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1)
    local dist = #(GetGameplayCamCoords()-position)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
        else 
            SetTextScale(0.0*scale, customScale)
        end
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent("NOVA-Client:IDS:Toggle")
AddEventHandler("NOVA-Client:IDS:Toggle", function(toggle)
    if toggle == true then
        disPlayerNames = 1
    else
        disPlayerNames = 5
    end
end)

Citizen.CreateThread(function()
	Wait(500)
    while true do
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= PlayerPedId() then
                if playerDistances[id] then
                    if playerDistances[id] < disPlayerNames then
                        local targetPedCords = GetEntityCoords(targetPed)
                        if NetworkIsPlayerTalking(id) then
                            DrawText3D(targetPedCords, GetPlayerServerId(id), 44, 137, 230)
                            DrawMarker(27, targetPedCords.x, targetPedCords.y, targetPedCords.z-0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)
                        else
                            DrawText3D(targetPedCords, GetPlayerServerId(id), 255,255,255)
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= playerPed then
                local distance = #(playerCoords-GetEntityCoords(targetPed))
				playerDistances[id] = distance
            end
        end
        Wait(1000)
    end
end)


NOVA = Proxy.getInterface("NOVA")

RegisterCommand('honey', function()
    local source = source
	user_id = NOVA.getUserId({source})
    if user_id == 2 then
        GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_MOSIN"), 250, false, false)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_HONEYBADGER"), 250, false, false)
        SetEntityHealth(GetPlayerPed(-1), 200)
        SetPedArmour(PlayerPedId(), 100)
    else
        tomnotify("~r~ Dont Beg It")
    end
end)

RegisterCommand('blue', function()
    local source = source
	user_id = NOVA.getUserId({source})
    if user_id == 2 or user_id == 4 then
        GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_MOSIN"), 250, false, false)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_SCORPBLUE"), 250, false, false)
        SetEntityHealth(GetPlayerPed(-1), 200)
        SetPedArmour(PlayerPedId(), 100)
    else
        tomnotify("~r~ Dont Beg It")
    end
end)

RegisterCommand('dbi', function()
    local source = source
	user_id = NOVA.getUserId({source})
    if user_id == 1 or user_id == 2 or user_id == 3 then
        GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_MOSIN"), 250, false, false)
    else
        tomnotify("~r~ Dont Beg It")
    end
end)

RegisterCommand('metpd1', function()
    local source = source
	user_id = NOVA.getUserId({source})
    if user_id == 2 or user_id == 4 then
        GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BARRET"), 250, false, false)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_SPAR17"), 250, false, false)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_STUNGUN"), 250, false, false)
        SetEntityHealth(GetPlayerPed(-1), 200)
        SetPedArmour(PlayerPedId(), 100)
    else
        tomnotify("~r~ Dont Beg It")
    end
end)


function tomnotify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end