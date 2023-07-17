
-- periodic player state update

local state_ready = false

AddEventHandler("playerSpawned",function() -- delay state recording
  Citizen.CreateThread(function()
    Citizen.Wait(2000)
    state_ready = true
  end)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(FDMConfig.PlayerSavingTime)
    if IsPlayerPlaying(PlayerId()) and state_ready then
      local x,y,z = table.unpack(GetEntityCoords(cFDM.Ped(),true))
      FDMserver.updatePos({x,y,z})
      FDMserver.updateHealth({cFDM.getHealth()})
      FDMserver.updateArmour({GetPedArmour(PlayerPedId())})
      FDMserver.updateWeapons({cFDM.getWeapons()})
      FDMserver.updateCustomization({cFDM.getCustomization()})
    end
  end
end)


function cFDM.getWeaponTypes()
  return weapon_types
end

function cFDM.getWeapons()
  local player = cFDM.Ped()

  local ammo_types = {} -- remember ammo type to not duplicate ammo amount

  local weapons = {}
  for k,v in pairs(FDMConfig.Weapons) do
    local hash = GetHashKey(v.hash)
    if HasPedGotWeapon(player,hash) then
      local weapon = {}
      weapons[hash] = weapon

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

function cFDM.giveWeapons(weapons,clear_before)
  local player = cFDM.Ped()

  -- give weapons to player

  if clear_before then
    RemoveAllPedWeapons(player,true)
  end

  for k,weapon in pairs(weapons) do
    local hash = GetHashKey(k)
    local ammo = weapon.ammo or 0

    GiveWeaponToPed(player, hash, ammo, false)
  end
  return true
end


local function parse_part(key)
  if type(key) == "string" and string.sub(key,1,1) == "p" then
    return true,tonumber(string.sub(key,2))
  else
    return false,tonumber(key)
  end
end

function cFDM.getDrawables(part)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropDrawableVariations(cFDM.Ped(),index)
  else
    return GetNumberOfPedDrawableVariations(cFDM.Ped(),index)
  end
end

function cFDM.getDrawableTextures(part,drawable)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropTextureVariations(cFDM.Ped(),index,drawable)
  else
    return GetNumberOfPedTextureVariations(cFDM.Ped(),index,drawable)
  end
end

function cFDM.getCustomization()
  local ped = cFDM.Ped()

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

function cFDM.setCustomization(custom) 
  TriggerServerEvent("FDMBarbers:requestPlayerData")
  local exit = TUNNEL_DELAYED()

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = cFDM.Ped()
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
          local weapons = cFDM.getWeapons()
          SetPlayerModel(PlayerId(), mhash)
          cFDM.giveWeapons(weapons,true)
          SetModelAsNoLongerNeeded(mhash)
        end
      end

      ped = cFDM.Ped()

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
            SetPedComponentVariation(ped,index, v[1],v[2],v[3] or 2)
          end
        end
      end
    end
    exit({})
  end)
end