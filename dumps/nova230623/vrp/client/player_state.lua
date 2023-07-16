
-- periodic player state update

local state_ready = false

AddEventHandler("playerSpawned",function() -- delay state recording
  state_ready = false
  
  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    state_ready = true
  end)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if IsPlayerPlaying(PlayerId()) and state_ready then
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
        vRPserver.updatePos({x,y,z})
        vRPserver.updateHealth({GetEntityHealth(GetPlayerPed(-1))})
        vRPserver.updateArmour({GetPedArmour(PlayerPedId())})
        vRPserver.updateWeapons({tvRP.getWeapons()})
        vRPserver.updateCustomization({tvRP.getCustomization()})
        TriggerServerEvent('NOVA:changeHairStyle')
        TriggerServerEvent('NOVA:ChangeTattoos')
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    vRPserver.UpdatePlayTime()
  end
end)

-- def
local weapon_types = {
  -- large
  "WEAPON_WINCHESTER",
  "WEAPON_VESPER",
  "WEAPON_MP7",
  "WEAPON_MP40",
  "WEAPON_AKM",
  "WEAPON_MOSIN",

  -- rebel
  "WEAPON_AK200",
  "WEAPON_MXM",
  "GADGET_PARACHUTE",
  "WEAPON_MXC",

  -- advanced rebel
  "WEAPON_SPAR16",
  "WEAPON_MK1EMR",
  "WEAPON_SVD",

  -- small arms
  "WEAPON_M1911",
  "WEAPON_BERETTA",
  "WEAPON_PYTHON",
  "WEAPON_UMP45",

  -- police large
  "WEAPON_MP5",
  "WEAPON_REMINGTON700",
  "WEAPON_PDMCX",
  "WEAPON_SPAR17",
  "WEAPON_PDHK416",
  "WEAPON_CQ300",

  -- police small arms
  "WEAPON_NIGHTSTICK",
  "WEAPON_FLASHLIGHT",
  "WEAPON_GLOCK",
  "WEAPON_STUNGUN",
  "WEAPON_REMINGTON870",
  "WEAPON_SPEEDGUN",
}

function tvRP.spawnAnim(a)
  if a ~= nil then
    DoScreenFadeOut(250)
    ExecuteCommand("hideui")
    local g = GetEntityCoords(PlayerPedId(),true)
    Wait(500)
    TriggerScreenblurFadeIn(100.0)
    RequestCollisionAtCoord(g.x, g.y, g.z)
    NewLoadSceneStartSphere(g.x, g.y, g.z, 100.0, 2)
    SetEntityCoordsNoOffset(PlayerPedId(), g.x, g.y, g.z, true, false, false)
    SetEntityVisible(PlayerPedId(), false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    local h = GetGameTimer()
    while (not HaveAllStreamingRequestsCompleted(PlayerPedId()) or GetNumberOfStreamingRequests() > 0) and
        GetGameTimer() - h < 10000 do
        Wait(0)
    end
    NewLoadSceneStop()
    TriggerServerEvent('NOVA:changeHairstyle')
    TriggerEvent("vrp:PlaySound", "gtaloadin")
    DoScreenFadeIn(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    if not tvRP.isDeveloper() then
      SetFocusPosAndVel(g.x, g.y, g.z+1000)
      local spawnCam3 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", g.x, g.y, g.z+1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
      SetCamActive(spawnCam3, true)
      RenderScriptCams(true, true, 0, 1, 0)
      local spawnCam4 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", g.x, g.y, g.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
      SetCamActiveWithInterp(spawnCam4, spawnCam3, 5000, 0, 0)
      Wait(2500)
      ClearFocus()
      TriggerScreenblurFadeOut(2000.0)
      Wait(2000)
      DestroyCam(spawnCam3)
      DestroyCam(spawnCam4)
      RenderScriptCams(false, true, 2000, 0, 0)
    else
      TriggerScreenblurFadeOut(500.0)
    end
    tvRP.setCustomization(a)
    SetEntityVisible(PlayerPedId(), true, false)
    FreezeEntityPosition(PlayerPedId(), false)
    if not tvRP.isDeveloper() then
      Citizen.Wait(2000)
    end
    ExecuteCommand("showui")
  end
  spawning = false
end

function tvRP.getWeaponTypes()
  return weapon_types
end

function tvRP.getWeapons()
  local player = GetPlayerPed(-1)

  local ammo_types = {} -- remember ammo type to not duplicate ammo amount

  local weapons = {}
  for k,v in pairs(weapon_types) do
    local hash = GetHashKey(v)
    if HasPedGotWeapon(player,hash) then
      local weapon = {}
      weapons[v] = weapon

      local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
      if ammo_types[atype] == nil then
        ammo_types[atype] = true
        weapon.ammo = GetAmmoInPedWeapon(player,hash)
      else
        weapon.ammo = 0
      end
    end
  end

  return weapons
end

function tvRP.giveWeapons(weapons,clear_before)
  local player = GetPlayerPed(-1)

  -- give weapons to player

  if clear_before then
    RemoveAllPedWeapons(player,true)
  end

  for k,weapon in pairs(weapons) do
    local hash = GetHashKey(k)
    local ammo = weapon.ammo or 0
    GiveWeaponToPed(player, hash, ammo, false)
  end
end

function tvRP.giveWeaponAmmo(hash, amount)
  SetPedAmmo(PlayerPedId(), hash, amount)
end

-- PLAYER CUSTOMIZATION

-- parse part key (a ped part or a prop part)
-- return is_proppart, index
local function parse_part(key)
  if type(key) == "string" and string.sub(key,1,1) == "p" then
    return true,tonumber(string.sub(key,2))
  else
    return false,tonumber(key)
  end
end

function tvRP.getDrawables(part)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropDrawableVariations(PlayerPedId(),index)
  else
    return GetNumberOfPedDrawableVariations(PlayerPedId(),index)
  end
end

function tvRP.getDrawableTextures(part,drawable)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropTextureVariations(PlayerPedId(),index,drawable)
  else
    return GetNumberOfPedTextureVariations(PlayerPedId(),index,drawable)
  end
end

function tvRP.getCustomization()
  local ped = PlayerPedId()

  local custom = {}

  custom.modelhash = GetEntityModel(ped)

  -- ped parts
  for i=0,20 do -- index limit to 20
    custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
  end

  -- props
  for i=0,10 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end

  return custom
end

function tvRP.getCustomization2()
  local ped = PlayerPedId()

  local custom = {}

  custom.modelhash = GetEntityModel(ped)

  -- ped parts


  for i=0,6 do -- index limit to 20
    custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
  end


    custom[8] = {GetPedDrawableVariation(ped,8), GetPedTextureVariation(ped,8), GetPedPaletteVariation(ped,8)}
    for i=10,20 do -- index limit to 20
      custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
    end

  -- props
  for i=0,5 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end
  for i=7,10 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end

  return custom
end


-- partial customization (only what is set is changed)
function tvRP.setCustomization(custom) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model
  local exit = TUNNEL_DELAYED() -- delay the return values

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = PlayerPedId()
      local mhash = nil

      -- model
      if custom.modelhash ~= nil then
        mhash = custom.modelhash
      elseif custom.model ~= nil then
        mhash = GetHashKey(custom.model)
      end

      if mhash ~= nil then
        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
          RequestModel(mhash)
          Citizen.Wait(10)
        end

        if HasModelLoaded(mhash) then
          -- changing player model remove weapons, so save it
          local weapons = tvRP.getWeapons()
          if GetEntityModel(PlayerPedId()) ~= GetHashKey("mp_m_freemode_01") then
            SetPlayerModel(PlayerId(), mhash)
          end
          tvRP.giveWeapons(weapons,true)
          SetModelAsNoLongerNeeded(mhash)
        end
      end

      ped = PlayerPedId()

      -- parts
      for k,v in pairs(custom) do
        if k ~= "model" and k ~= "modelhash" then
          local isprop, index = parse_part(k)
          if isprop then
            if v[1] < 0 then
              ClearPedProp(ped,index)
            else
              SetPedPropIndex(ped,index,v[1],v[2],v[3] or 2)
            end
          else
            SetPedComponentVariation(ped,index,v[1],v[2],v[3] or 2)
          end
        end
      end
    end

    exit({})
  end)
end

RegisterNetEvent('checkAmmo')
AddEventHandler('checkAmmo', function()
    if IsPedArmed(PlayerPedId(), 4) then 
        TriggerServerEvent('sendAmmo', true)
    else
        TriggerServerEvent('sendAmmo', false)
    end
end)