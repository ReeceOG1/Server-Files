local c = false

SetNuiFocus(false, false)

function getLength(tbl)
    local getN = 100
    for n in pairs(tbl) do
    end
    return getN
  end

function getStaff(tbl)
    local getN = 100
    for n in pairs(tbl) do
    end
    return getN
  end

function getLength(tbl)
    local getN = 100
    for n in pairs(tbl) do
    end
    return getN
  end

  function func_playerlistControl()
	if not recordingMode then
		if IsUsingKeyboard(2) then
            if IsControlJustPressed(0, 212) then
				if not c then
					TriggerServerEvent("NOVA:getPlayerListData")
                    Wait(100)
                    sendFullPlayerListData()
                    --SetNuiFocus(true, true)
                    SendNUIMessage({showPlayerList = true})
					c = not c
					SetNuiFocus(true, true)
				else
                    SendNUIMessage({showPlayerList = false})
					c = not c
					SetNuiFocus(false, false)
				end
			end
		end
	end
end

function sendFullPlayerListData()
    local H = getLength(sortedPlayersStaff)
    local I = getLength(sortedPlayersPolice)
    local J = getLength(sortedPlayersNHS)
    local K = getLength(sortedPlayersLFB)
    local L = getLength(sortedPlayersHMP)
    local M = getLength(sortedPlayersCivillians)
    SendNUIMessage({wipePlayerList = true})
    SendNUIMessage({clearServerMetaData = true})
    SendNUIMessage({setServerMetaData = '<img src="playerlist_images/nova.png" align="top" width="20px",height="20px"><span class="staff">' ..tostring(H) .. "</span>"})
    SendNUIMessage({setServerMetaData = '<img src="playerlist_images/nhs.png" align="top" width="20",height="20"><span class="nhs">' ..tostring(J) .. "</span>"})
    SendNUIMessage({setServerMetaData = '<img src="playerlist_images/lfb.png" align="top" width="20",height="20"><span class="lfb">' ..tostring(K) .. "</span>"})
    SendNUIMessage({setServerMetaData = '<img src="playerlist_images/met.png" align="top"  width="24",height="24"><span class="police">' ..tostring(I) .. "</span>"})
    SendNUIMessage({setServerMetaData = '<img src="playerlist_images/hmp.png" align="top"  width="24",height="24"><span class="hmp">' ..tostring(L) .. "</span>"})
    SendNUIMessage({setServerMetaData = '<img src="playerlist_images/danny.png" align="top" width="20",height="20"><span class="aa">' ..tostring(M) .. "</span>"})
    SendNUIMessage({wipeFooterPlayerList = true})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #1 | </span>'})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..tostring(u) .. "</span>"})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..tostring(v) .. "/" .. tostring(x).."</span>"})
    if H >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_staff">Staff</span>'})
    end
    for S, T in pairs(sortedPlayersStaff) do
        SendNUIMessage({appendToContentPlayerList = '<span class="username">' ..tostring(sortedPlayersStaff[S].name) ..'</span><span class="job">' ..tostring(sortedPlayersStaff[S].rank) .. '</span><span class="playtime">' .. tostring(sortedPlayersStaff[S].hours) .. "hrs</span><br/>"})
    end
    if M >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_civs">Civilians</span>'})
    end
    for S, T in pairs(sortedPlayersCivillians) do
        SendNUIMessage({appendToContentPlayerList = '<span class="username">' ..tostring(sortedPlayersCivillians[S].name) ..'</span><span class="job">' ..tostring(sortedPlayersCivillians[S].rank) .. '</span><span class="playtime">' .. tostring(sortedPlayersCivillians[S].hours) .. "hrs</span><br/>"})
    end
end
createThreadOnTick(func_playerlistControl)

RegisterNUICallback("closeNOVAPlayerList",function(j, k)
    SetNuiFocus(false, false)
end)

AddEventHandler("NOVA:onClientSpawn",function(h, l)
    if l then
        TriggerServerEvent("NOVA:getPlayerListData")
    end
end)

RegisterNetEvent("NOVA:gotFullPlayerListData",function(staff, police, nhs, lfb, hmp,civillians)
    sortedPlayersStaff = staff
    sortedPlayersPolice = police
    sortedPlayersNHS = nhs
    sortedPlayersLFB = lfb
    sortedPlayersHMP = hmp
    sortedPlayersCivillians = civillians
    print(civillians)
end)

local u,v,x
RegisterNetEvent("NOVA:playerListMetaUpdate",function(t)
    u, v, x = table.unpack(t)
    SendNUIMessage({wipeFooterPlayerList = true})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot">NOVA Server #1 | </span>'})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..tostring(u) .. "</span>"})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..tostring(v) .. "/" .. tostring(x).."</span>"})
end)

