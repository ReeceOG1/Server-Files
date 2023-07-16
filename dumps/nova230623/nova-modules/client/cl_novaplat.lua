RegisterNetEvent("NOVAPlat:spawnmoped")
AddEventHandler("NOVAPlat:spawnmoped",function()
    local mopedHash = GetHashKey("faggio")
    loadModel(mopedHash)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local pedHeading = GetEntityHeading(ped)
    local moped = CreateVehicle(mopedHash, pedCoords, pedHeading, true, true)
    SetPedIntoVehicle(ped, moped, -1)
    notify("~r~[NitroPerks] ~b~You have spawned a moped")
end)

RegisterNetEvent("NOVAPlat:notbooster")
AddEventHandler("NOVAPlat:notbooster",function()
    tvRP.notify("~y~You need to be a subscriber of NOVA Plus or NOVA Platinum to use this feature.")
    tvRP.notify("~y~Available @ store.NOVAstudios.uk")
end)


function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
end


RegisterCommand('craftmoped', function()
  ExecuteCommand("playanim")  
  TriggerServerEvent('NOVAPlat:craftmoped')

end)

RegisterCommand("playanim", function()
  TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_HAMMERING', false, true)
end)


function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
      Wait(5)
    end
  end


  function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end