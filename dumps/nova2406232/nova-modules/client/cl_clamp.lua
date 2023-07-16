--[[Proxy/Tunnel]]--

NOVAClampClientT = {}
Tunnel.bindInterface("NOVA_Clamp",NOVAClampClientT)
Proxy.addInterface("NOVA_Clamp",NOVAClampClientT)
NOVAClampServer = Tunnel.getInterface("NOVA_Clamp","NOVA_Clamp")
NOVA = Proxy.getInterface("NOVA")

Clamps = {}
DisabledVehs = {}

function NOVAClampClientT.ClampVehicle()
  local x,y,z = NOVA.getPosition()
  local ped =PlayerPedId()
  local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, 5.0, 0, 4+2+1)
  if DoesEntityExist(veh) then
    local clampHash = 'prop_clamp'
    RequestModel(clampHash)
    while not HasModelLoaded(clampHash) do
      Citizen.Wait(0)
    end
    local clamp = CreateObject(clampHash, x, y, z, true, true, true)
    DecorSetInt(clamp,"NOVACARS",955)
    local boneIndex = GetEntityBoneIndexByName(veh, "wheel_lf")
    SetEntityHeading(clamp, 0.0)
    SetEntityRotation(clamp, 60.0, 20.0, 10.0, 1, true)
    AttachEntityToEntity(clamp, veh, boneIndex, -0.10, 0.15, -0.30, 180.0, 200.0, 90.0, true, true, false, false, 2, true)
    SetEntityRotation(clamp, 60.0, 20.0, 10.0, 1, true)
    SetEntityAsMissionEntity(clamp, true, true)
    FreezeEntityPosition(clamp, true)
    NOVAClampServer.ChangeVehState({VehToNet(veh), true})
    local clampID = #Clamps + 1
    Clamps[clampID] = {clamp, veh}
    NOVA.notify({"~g~You have clamped the vehicle, clamp ID " .. clampID .. "."})
  else
    NOVA.notify({"~r~There is no vehicle nearby."})
  end
end

function NOVAClampClientT.ChangeVehState(veh, disable)
  if disable then
    local veh = NetToVeh(veh)
    DisabledVehs[veh] = true
    Citizen.CreateThread(function()
      while DisabledVehs[veh] do
        Citizen.Wait(500)
        SetVehicleEngineOn(veh, false, false, true)
      end
    end)
  else
    DisabledVehs[NetToVeh(veh)] = false
    Citizen.Wait(500)
    SetVehicleEngineOn(NetToVeh(veh), true, false, false)
  end
end

TriggerEvent('chat:addSuggestion', '/clamp', 'Clamps closest vehicle.')
TriggerEvent('chat:addSuggestion', '/removeclamps', 'Removes all your clamped cars.')
RegisterCommand("removeclamps", function(source, args, rawCommand)
  for k, v in pairs(Clamps) do
    if v ~= nil then
      DeleteEntity(v[1])
      NOVAClampServer.ChangeVehState({VehToNet(v[2]), false})
    end
  end
  Clamps = {}
  NOVA.notify({"~g~All clamps removed."})
end, false)

RegisterNetEvent("NOVA:UnClampVehicles")
AddEventHandler("NOVA:UnClampVehicles", function()
  for k, v in pairs(Clamps) do
    if v ~= nil then
      DeleteEntity(v[1])
      NOVAClampServer.ChangeVehState({VehToNet(v[2]), false})
    end
  end
  Clamps = {}
  NOVA.notify({"~g~All clamps removed."})
end, false)









TriggerEvent('chat:addSuggestion', '/removeclamp', 'Removes clamp.', {{ name="ClampID", help="Clamp ID you want to remove."}})
RegisterCommand("removeclamp", function(source, args, rawCommand)
  local ID = tonumber(args[1])
  if Clamps[ID] == nil then
    NOVA.notify({"~r~Please enter a valid clamp ID."})
  else
    DeleteEntity(Clamps[ID][1])
    NOVAClampServer.ChangeVehState({VehToNet(Clamps[ID][2]), false})
    Clamps[ID] = nil
    NOVA.notify({"~g~Clamp removed."})
  end
end, false)
