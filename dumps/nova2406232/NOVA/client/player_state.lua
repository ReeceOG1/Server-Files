
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
        NOVAserver.updatePos({x,y,z})
        NOVAserver.updateHealth({GetEntityHealth(GetPlayerPed(-1))})
        NOVAserver.updateArmour({GetPedArmour(PlayerPedId())})
        NOVAserver.updateWeapons({tNOVA.getWeapons()})
        NOVAserver.updateCustomization({tNOVA.getCustomization()})
        TriggerServerEvent('NOVA:changeHairStyle')
        TriggerServerEvent('NOVA:ChangeTattoos')
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    NOVAserver.UpdatePlayTime()
  end
end)

-- def
local weapon_types = { -- Add your guns here.

"WEAPON_BARRET",
"WEAPON_SPAR17",
"WEAPON_G36K", 
"WEAPON_SIGMCX",
"WEAPON_MP5", 
"WEAPON_GLOCK17",
"WEAPON_BATON", 
"WEAPON_MOSIN", 
"WEAPON_KASHNAR",
"WEAPON_AK74",
"WEAPON_UMP", 
"WEAPON_MK1EMR",
"WEAPON_MXM", 
"WEAPON_SPAR16",
"WEAPON_SVD", 
"WEAPON_PQ15", 
"WEAPON_AK200", 
"WEAPON_LR300", 
"WEAPON_M1911", 
"WEAPON_UZI",
"WEAPON_MAKAROV",
"WEAPON_GUITAR",
"WEAPON_SHANK",
"WEAPON_TOILETBRUSH",
"WEAPON_KITCHEN",
"WEAPON_CRUTCH",
"WEAPON_BUTTERFLY",
"WEAPON_SPEEDGUN",
"WEAPON_REMINGTON870",
"WEAPON_WINCHESTER12",

"WEAPON_BARRET50",
"WEAPON_MSR", 
"WEAPON_SV98",
"WEAPON_M4A1SDECIMATOR",
"WEAPON_M4A1SSAGIRIR",
"WEAPON_CNDYRIFLE",
"WEAPON_AUG",
"WEAPON_GRAU",
"WEAPON_VANDAL", 
"WEAPON_NV4", 
"WEAPON_HONEYBADGER",
"WEAPON_HK418",
"WEAPON_SCORPBLUE",
"WEAPON_PERFORATOR", 
"WEAPON_GUNGIRLDEAGLE",
"WEAPON_SAKURADEAGLE",
"WEAPON_PRINTSTREAMDEAGLE",
"WEAPON_KILLCONFIRMEDDEAGLE",
"WEAPON_TINT",
"WEAPON_ASIIMOVPISTOL",
"WEAPON_VOMFEUER",
"WEAPON_CARB2",
"WEAPON_KARAMBIT",
"WEAPON_FNX45",
"WEAPON_FINN",  
"WEAPON_MIST",
"WEAPON_PPSH",
"WEAPON_M4A1SSAGIRI",

"WEAPON_HAHA",
"WEAPON_HOWL",
"WEAPON_GDEAGLE",
"WEAPON_PICK",
"WEAPON_HOBBY",
"WEAPON_LIGHTSABER",
"WEAPON_KATANA",
"WEAPON_SPHANTOM",
"WEAPON_ADAGGER",
"WEAPON_CAPSHIELD",
"WEAPON_TIGER",
"WEAPON_LEVIATHAN",
"WEAPON_L96",
"WEAPON_MP7A2",
"WEAPON_M107",
"WEAPON_M4A1SNIGHTMARE",
"WEAPON_PILUM",
"WEAPON_HAYMAKER",
"WEAPON_USPSTORQUE",
"WEAPON_REAVERVANDAL",
"WEAPON_M4A1",
"WEAPON_SCAR",
"WEAPON_MP5A2",
"WEAPON_IRONWOLF",
"WEAPON_LIQUIDCARBINE",
"WEAPON_M82A2",
"WEAPON_M82A3",
"WEAPON_GUNGNIR",
"WEAPON_BORA",
"WEAPON_HADDESNIPER",
"WEAPON_M98B",
"WEAPON_M200",
"WEAPON_ORSIST5000",
"WEAPON_MSR2",
"WEAPON_STAC",
"WEAPON_MX",
"WEAPON_NERFBLASTER",
"WEAPON_M4A4FIRE",
"WEAPON_M4A4HYBRID",
"WEAPON_VAL",
"WEAPON_RIFLEV2",
"WEAPON_M60",
"WEAPON_USAS12",
"WEAPON_HKV2",
"WEAPON_HK416",
"WEAPON_FNFAL",
"WEAPON_DRAGONAK",
"WEAPON_MK18",
"WEAPON_M16A4",
"WEAPON_M13",
"WEAPON_RAINBOWLR300",
"WEAPON_ICEDRAKE",
"WEAPON_M203",
"WEAPON_M4FBX",
"WEAPON_M4",
"WEAPON_M4A4NOIR",
"WEAPON_M4A1SNEONOIR",
"WEAPON_M4A1SPURPLE",
"WEAPON_MK18V2",
"WEAPON_PRIMEVANDAL",
"WEAPON_ORIGINVANDAL",
"WEAPON_REDTIGER",
"WEAPON_SP1",
"WEAPON_M4A4RIOT",
"WEAPON_M4A4RETRO",
"WEAPON_XM4TIGER",
"WEAPON_AUGV2",
"WEAPON_DIAMONDMP5",
"WEAPON_MTARGLOWC",
"WEAPON_MP5GLOW",
"WEAPON_MP5A3",
"WEAPON_MPXC",
"WEAPON_P90",
"WEAPON_P90V2",
"WEAPON_PRIMESPECTRE",
"WEAPON_SCORPEVOE",
"WEAPON_SINGULARITYSPECTRE",
"WEAPON_T5GLOW",
"WEAPON_VSS",
"WEAPON_VESPER",
"WEAPON_VESPERHYBRID",
"WEAPON_ARESSHRIKE",
"WEAPON_FNMAG",
"WEAPON_M60V2",
"WEAPON_MK249",
"WEAPON_DEADPOOLSHOTGUN",
"WEAPON_HAYMAKERV2",
"WEAPON_PUMPSHOTGUNMK2",
"WEAPON_SPAS12",
"WEAPON_RPK16",
"WEAPON_AK47KITTYREVENGE",
"WEAPON_L118A1",
"WEAPON_MINIMIM249",
"WEAPON_SR25",
"WEAPON_ANIMESWORD",
"WEAPON_wuxiafan",
"WEAPON_ANIMEMAC10",
"WEAPON_DIAMONDSWORD",
"WEAPON_GLITCHPOPOPERATOR",
"WEAPON_RE6",
"WEAPON_RE6RN",
"WEAPON_RE6SNIPER",
"WEAPON_M4A4NEVA",
"WEAPON_AK74UV3",
"WEAPON_SR25",
"WEAPON_ANIMESWORD",
"WEAPON_wuxiafan",
"WEAPON_ANIMEMAC10",
"WEAPON_DIAMONDSWORD",
"WEAPON_ODIN",
"WEAPON_BLASTXPHANTOM",
"WEAPON_M4A4DRAGONKING",
"WEAPON_BAL27",
"WEAPON_PURPLENIKEGRAU",
"WEAPON_AKCQB",
"WEAPON_HEADSTONEAUG",
"WEAPON_FFAR",
"WEAPON_PARAFALSOULREAPER",
"WEAPON_ORIGINVANDALYELLOW",
"WEAPON_ACRCQB",
"WEAPON_AK74UGOKU",
"WEAPON_M249",
"WEAPON_LVOA",
"WEAPON_NERFMOSIN",
"WEAPON_GLITCHPOPPHANTOM",
"WEAPON_VITYAZ",
"WEAPON_VTSGLOW",
"WEAPON_TACGLOCK19",
"WEAPON_AWPMIKU",
"WEAPON_HKMP5K",
"WEAPON_MODEL680",
"WEAPON_SVDK",
"WEAPON_G28",
"WEAPON_FIVESEVEN",
"WEAPON_SIGSAUERP226R",
"WEAPON_COLTM16A2",
"WEAPON_MWUZI",
"WEAPON_FX05",
"WEAPON_TX15",
"WEAPON_M14",
"WEAPON_RPD",
"WEAPON_FFARAUTOTOON",
"WEAPON_SIG",
"WEAPON_GSCYTHE",
"WEAPON_PK470",
"WEAPON_IBAK",
"WEAPON_ODINX",
"WEAPON_HBRA3",
"WEAPON_AN94",
"WEAPON_HKMG4",
"WEAPON_S75",
"WEAPON_M77",
"WEAPON_AR160",
"WEAPON_M40A3",
"WEAPON_ELDERVANDAL",
"WEAPON_RGXVANDAL",
"WEAPON_REAVEROPERATOR",
"WEAPON_WARHEAD",
"WEAPON_WARHEADAR",
"WEAPON_STAC",
"WEAPON_PHAN",
"WEAPON_SOLBLUE",
"WEAPON_HAWKM4",
"WEAPON_REAVERVANDALWHITE",
"WEAPON_M249PLAYMAKER",
"WEAPON_XM177",
"WEAPON_MK18CQBR",
"WEAPON_M16A2",
"WEAPON_MK18V2",
"WEAPON_DEAGLE",
"WEAPON_IMPULSEAK47",
"WEAPON_SAIGRY",
"WEAPON_GLOWAUG",
}

function tNOVA.spawnAnim(a)
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
    TriggerEvent("NOVA:PlaySound", "gtaloadin")
    DoScreenFadeIn(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    if not tNOVA.isDevMode() then
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
    tNOVA.setCustomization(a)
    SetEntityVisible(PlayerPedId(), true, false)
    FreezeEntityPosition(PlayerPedId(), false)
    if not tNOVA.isDevMode() then
      Citizen.Wait(2000)
    end
    ExecuteCommand("showui")
  end
  spawning = false
end

function tNOVA.getWeaponTypes()
  return weapon_types
end

function tNOVA.getWeapons()
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

function tNOVA.giveWeapons(weapons,clear_before)
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

function tNOVA.giveWeaponAmmo(hash, amount)
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

function tNOVA.getDrawables(part)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropDrawableVariations(PlayerPedId(),index)
  else
    return GetNumberOfPedDrawableVariations(PlayerPedId(),index)
  end
end

function tNOVA.getDrawableTextures(part,drawable)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropTextureVariations(PlayerPedId(),index,drawable)
  else
    return GetNumberOfPedTextureVariations(PlayerPedId(),index,drawable)
  end
end

function tNOVA.getCustomization()
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

function tNOVA.getCustomization2()
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
function tNOVA.setCustomization(custom) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model
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
          local weapons = tNOVA.getWeapons()
          if GetEntityModel(PlayerPedId()) ~= GetHashKey("mp_m_freemode_01") then
            SetPlayerModel(PlayerId(), mhash)
          end
          tNOVA.giveWeapons(weapons,true)
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