cfg = module("cfg/client")
cfgweapons = module("luna-weapons", "cfg/cfg_weaponNames")
local user_id = 0
tLUNA = {}
allowedWeapons = {}
local players = {} -- keep track of connected players (server id)

-- bind client tunnel interface
Tunnel.bindInterface("LUNA",tLUNA)

-- get server interface
LUNAserver = Tunnel.getInterface("LUNA","LUNA")

-- add client proxy interface (same as tunnel interface)
Proxy.addInterface("LUNA",tLUNA)

function tLUNA.allowWeapon(name)
  if allowedWeapons[name] then
  else
    allowedWeapons[name] = true
  end
end

local a
local b = false
local function c(d, e, f, g)
    if g == nil then
        g = function()
        end
    end
    if a then
        SendNUIMessage({act = "close_prompt"})
        while a do
            Wait(0)
        end
    end
    SendNUIMessage({act = "open_prompt", type = f, title = d, text = tostring(e)})
    SetNuiFocus(true)
    a = g
    b = true
end
RegisterNUICallback(
    "prompt",
    function(h, g)
        if h.act == "close" then
            if a then
                a(h.result)
                a = nil
            end
        end
    end
)
function tLUNA.clientPrompt(d, e, g)
    c(d, e, "client", g)
end
function tLUNA.prompt(d, e)
    c(d, e, "server", nil)
end
RegisterNUICallback(
    "prompt",
    function(h, g)
        if h.act == "close" and b then
            SetNuiFocus(false)
            b = false
            if h.type ~= "client" then
                LUNAserver.promptResult({h.result})
            end
        end
    end
)
function tLUNA.CopyToClipboard(i)
    SendNUIMessage({copytoboard = i})
end
function tLUNA.OpenUrl(j)
    SendNUIMessage({act = "openurl", url = j})
end
RegisterNUICallback(
    "ClosePrompt",
    function()
        if b then
            SendNUIMessage({act = "close_prompt"})
            SetNuiFocus(false)
            a = nil
            b = false
        end
    end
)
exports("prompt", tLUNA.clientPrompt)
exports("copytoboard", tLUNA.CopyToClipboard)
exports(
    "playSound",
    function(k)
        SendNUIMessage({transactionType = k})
    end
)



function tLUNA.inEvent()
  return false
end

function tLUNA.ClearWeapons()
  allowedWeapons = {}
end

createThreadOnTick(savePlayerInfo)
function tLUNA.getClosestVehicle(aB)
    local aC = tLUNA.getPlayerCoords()
    local aD = 100
    local aE = 100
    for x, aF in pairs(GetGamePool("CVehicle")) do
        local aG = GetEntityCoords(aF)
        local aH = #(aC - aG)
        if aH < aE then
            aE = aH
            aD = aF
        end
    end
    if aE <= aB then
        return aD
    else
        return nil
    end
end

local function b(c,d,e)
  return c<d and d or c>e and e or c 
end

local function f(g)
  local h=math.floor(#g%99==0 and#g/99 or#g/99+1)
  local i={}
  for j=0,h-1 do 
      i[j+1]=string.sub(g,j*99+1,b(#string.sub(g,j*99),0,99)+j*99)
  end
  return i 
  end
  
  local function k(l,m)
  local n=f(l)
  SetNotificationTextEntry("CELL_EMAIL_BCON")
  for o,p in ipairs(n)do 
    AddTextComponentSubstringPlayerName(p)
  end
  if m then 
    local q=GetSoundId()
    PlaySoundFrontend(q,"police_notification","DLC_AS_VNT_Sounds",true)
    ReleaseSoundId(q)
  end 
  end
  
  function tLUNA.NotifyDVLAPicture(ay,az,l,ac,aA,aB,aC)
    if ay ~= nil and az ~= nil then 
      RequestStreamedTextureDict(ay,true)
      while not HasStreamedTextureDictLoaded(ay)do 
        Wait(0)
      end 
    end
    k(l,aB == "police")
    if aC == nil then 
      aC = 0 
    end
    local aD = false
    EndTextCommandThefeedPostMessagetext(ay,az,aD,aC,ac,aA)
    local aE = true
    local aF = false
    EndTextCommandThefeedPostTicker(aF,aE)
    DrawNotification(false,true)
    if aB == nil then 
      PlaySoundFrontend(-1,"CHECKPOINT_NORMAL","HUD_MINI_GAME_SOUNDSET",1)
    end 
  end

-- function tLUNA.checkWeapon(name)
--   if allowedWeapons[name] == nil then
--     RemoveWeaponFromPed(PlayerPedId(), GetHashKey(name))
--     print("Tried to spawn "..name)
--     return
--   end
-- end

function DrawText3DD(ai, R, S, T, U, V, e)
  local f, i, g = GetScreenCoordFromWorldCoord(ai, R, S)
  if f then
      SetTextScale(0.4, 0.4)
      SetTextFont(0)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 255)
      SetTextDropshadow(0, 0, 0, 0, 55)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      BeginTextCommandDisplayText("STRING")
      SetTextCentre(1)
      AddTextComponentSubstringPlayerName(T)
      EndTextCommandDisplayText(i, g)
  end
end

function tLUNA.getPedServerId(a5)
  local a6=GetActivePlayers()
  for T,U in pairs(a6)do 
      if a5==GetPlayerPed(U)then 
          local a7=GetPlayerServerId(U)
          return a7 
      end 
  end
  return nil 
end

function tLUNA.setWeaponAmmo(q, r)
  SetPedAmmoByType(PlayerPedId(), GetPedAmmoTypeFromWeapon(PlayerPedId(), GetHashKey(q)), r)
end
function tLUNA.setDev()
  by = true
end
function tLUNA.isDev()
  return by
end
function tLUNA.setWeapon(m, r, s)
  SetCurrentPedWeapon(m, r, s)
end

globalBlips={}
function tLUNA.addBlip(a,b,c,d,e,f,g,h)
    local i=AddBlipForCoord(a+0.001,b+0.001,c+0.001)
    SetBlipSprite(i,d)
    SetBlipAsShortRange(i,true)
    SetBlipColour(i,e)
    if d==403 or d==431 or d==365 or d==85 or d==140 or d==60 or d==44 or d==110 or d==315 then 
        SetBlipScale(i,1.1)
    elseif d==50 then 
        SetBlipScale(i,0.7)
    else 
        SetBlipScale(i,0.8)
    end
    SetBlipScale(i,g or 0.8)
    if h then 
        SetBlipDisplay(i,5)
    end
    if f~=nil then 
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(f)
        EndTextCommandSetBlipName(i)
    end
    table.insert(globalBlips,i)
    return i 
end
function tLUNA.removeBlip(j)
    RemoveBlip(j)
end
local k={}
function tLUNA.setNamedBlip(l,a,b,c,d,e,f,g)
    tLUNA.removeNamedBlip(l)
    k[l]=tLUNA.addBlip(a,b,c,d,e,f,g)
    return k[l]
end
function tLUNA.removeNamedBlip(l)
    if k[l]~=nil then 
        tLUNA.removeBlip(k[l])
        k[l]=nil 
    end 
end
local m={}
local n=Tools.newIDGenerator()
local o={}
local p={}
local q={}
function tLUNA.addMarker(a,b,c,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H)
    local I={position=vector3(a,b,c),sx=r,sy=s,sz=t,r=u,g=v,b=w,a=x,visible_distance=y,mtype=z,faceCamera=A,bopUpAndDown=B,rotate=C,textureDict=D,textureName=E,xRot=F,yRot=G,zRot=H}
    if I.sx==nil then 
        I.sx=2.0 
    end
    if I.sy==nil then 
        I.sy=2.0 
    end
    if I.sz==nil then 
        I.sz=0.7 
    end
    if I.r==nil then 
        I.r=0 
    end
    if I.g==nil then 
        I.g=155 
    end
    if I.b==nil then 
        I.b=255 
    end
    if I.a==nil then 
        I.a=200 
    end
    I.sx=I.sx+0.001
    I.sy=I.sy+0.001
    I.sz=I.sz+0.001
    if I.visible_distance==nil then 
        I.visible_distance=150 
    end
    local j=n:gen()
    m[j]=I
    q[j]=I
    return j 
end
function tLUNA.removeMarker(j)
    if m[j]~=nil then 
        m[j]=nil
        n:free(j)
    end
    if q[j]then 
        q[j]=nil 
    end 
end
function tLUNA.setNamedMarker(l,a,b,c,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H)
    tLUNA.removeNamedMarker(l)
    o[l]=tLUNA.addMarker(a,b,c,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H)
    return o[l]
end

function tLUNA.removeNamedMarker(l)
    if o[l]~=nil then 
        tLUNA.removeMarker(o[l])
        o[l]=nil 
    end 
end
local J={}
Citizen.CreateThread(function()
    while true do 
        for K,L in pairs(p)do 
            if J[K]then 
                if J[K]<=L.visible_distance then 
                    if L.mtype==nil then 
                        L.mtype=1 
                    end
                    DrawMarker(L.mtype,L.position.x,L.position.y,L.position.z,0.0,0.0,0.0,L.xRot,L.yRot,L.zRot,L.sx,L.sy,L.sz,L.r,L.g,L.b,L.a,L.bopUpAndDown,L.faceCamera,2,L.rotate,L.textureDict,L.textureName)
                end 
            end 
        end
        Wait(0)
    end 
end)
Citizen.CreateThread(function()
    while true do 
        local M=tLUNA.getPlayerCoords()
        J={}
        for K,L in pairs(q)do 
            J[K]=#(L.position-M)
            if J[K]<=L.visible_distance then 
                p[K]=L 
            else 
                p[K]=nil 
            end 
        end
        Citizen.Wait(250)
    end 
end)
Citizen.CreateThread(function()
    while true do 
        q=tLUNA.getNearbyMarkers()
        Citizen.Wait(10000)
    end 
end)
function tLUNA.getNearbyMarkers()
    local N={}
    local O=tLUNA.getPlayerCoords()
    local P=0
    for K,L in pairs(m)do 
        if#(L.position-O)<=250.0 then 
            N[K]=L 
        end
        P=P+1
        if P%25==0 then 
            Wait(0)
        end 
    end
    return N 
end
local Q={}
local R={}

function tLUNA.getNearbyAreas()
    local S={}
    local M=tLUNA.getPlayerCoords()
    local P=0
    for K,L in pairs(Q)do 
        if#(L.position-M)<=250.0 or L.radius>250 then 
            S[K]=L 
        end
        P=P+1
        if P%25==0 then 
            Wait(0)
        end 
    end
    return S 
end
function tLUNA.setArea(l,a,b,c,T,U)
    local V={position=vector3(a+0.001,b+0.001,c+0.001),radius=T,height=U}
    if V.height==nil then 
        V.height=6 
    end
    Q[l]=V 
end
function tLUNA.createArea(l,W,T,U,X,Y,Z,_)
    local V={position=W,radius=T,height=U,enterArea=X,leaveArea=Y,onTickArea=Z,metaData=_}
    if V.height==nil then 
        V.height=6 
    end
    Q[l]=V
    R[l]=V 
end
function tLUNA.removeArea(l)
    if Q[l]then 
        Q[l]=nil 
    end 
end
function tLUNA.doesAreaExist(l)
    if Q[l]then 
        return true 
    end
    return false 
end
Citizen.CreateThread(function()
    while true do 
        local M=tLUNA.getPlayerCoords()
        for a0,a1 in pairs(R)do 
            local a2=#(a1.position-M)
            local a3=a2<=a1.radius and math.abs(M.z-a1.position.z)<=a1.height
            a1.distance=a2
            if a1.player_in and not a3 then 
                if a1.leaveArea then 
                    if a1.metaData==nil then 
                        a1.metaData={}
                    end
                    a1.leaveArea(a1.metaData)
                else 
                    tLUNAserver.leaveArea({a0})
                end 
            elseif not a1.player_in and a3 then 
                if a1.enterArea then 
                    if a1.metaData==nil then 
                        a1.metaData={}
                    end
                    a1.enterArea(a1.metaData)
                else 
                    tLUNAserver.enterArea({a0})
                end 
            end
            a1.player_in=a3 
        end
        Wait(0)
    end 
end)
Citizen.CreateThread(function()
    while true do 
        for a0,a1 in pairs(R)do 
            if a1.player_in and a1.onTickArea then 
                if a1.metaData==nil then 
                    a1.metaData={}
                end
                a1.metaData.distance=a1.distance
                a1.onTickArea(a1.metaData)
            end 
        end
        Wait(0)
    end 
end)
Citizen.CreateThread(function()
    while true do 
        R=tLUNA.getNearbyAreas()
        Citizen.Wait(5000)
    end 
end)



-- functions
function tLUNA.teleport(x,y,z)
  tLUNA.unjail() -- force unjail before a teleportation
  SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001, 1,0,0,1)
  LUNAserver.updatePos({x,y,z})
end

-- return x,y,z
function tLUNA.getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end

--returns the distance between 2 coordinates (x,y,z) and (x2,y2,z2)
function tLUNA.getDistanceBetweenCoords(x,y,z,x2,y2,z2)

-- local distance = GetDistanceBetweenCoords(x,y,z,x2,y2,z2, true)
local distance = #(vec(x, y, z) - vector3(x2, y2, z2)) 
  
  return distance
end

-- return false if in exterior, true if inside a building
function tLUNA.isInside()
  local x,y,z = tLUNA.getPosition()
  return not (GetInteriorAtCoords(x,y,z) == 0)
end

-- return vx,vy,vz
function tLUNA.getSpeed()
  local vx,vy,vz = table.unpack(GetEntityVelocity(GetPlayerPed(-1)))
  return math.sqrt(vx*vx+vy*vy+vz*vz)
end

function tLUNA.getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  -- normalize
  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function tLUNA.addPlayer(player)
  players[player] = true
end

function tLUNA.removePlayer(player)
  players[player] = nil
end

function tLUNA.getNearestPlayers(radius)
  local r = {}

  local ped = GetPlayerPed(i)
  local pid = PlayerId()
  local px,py,pz = tLUNA.getPosition()

  --[[
  for i=0,GetNumberOfPlayers()-1 do
    if i ~= pid then
      local oped = GetPlayerPed(i)

      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
      if distance <= radius then
        r[GetPlayerServerId(i)] = distance
      end
    end
  end
  --]]

  for k,v in pairs(players) do
    local player = GetPlayerFromServerId(k)

    if v and player ~= pid and NetworkIsPlayerConnected(player) then
      local oped = GetPlayerPed(player)
      local x,y,z = table.unpack(GetEntityCoords(oped,true))
      local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
      if distance <= radius then
        r[GetPlayerServerId(player)] = distance
      end
    end
  end

  return r
end

function tLUNA.getNearestPlayer(radius)
  local p = nil

  local players = tLUNA.getNearestPlayers(radius)
  local min = radius+10.0
  for k,v in pairs(players) do
    if v < min then
      min = v
      p = k
    end
  end

  return p
end

function tLUNA.notify(msg)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(msg)
  DrawNotification(true, false)
end

function tLUNA.notifyPicture(icon, type, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
end

-- SCREEN

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tLUNA.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    StartScreenEffect(name, 0, true)
  else
    StartScreenEffect(name, 0, true)

    Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Citizen.Wait(math.floor((duration+1)*1000))
      StopScreenEffect(name)
    end)
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tLUNA.stopScreenEffect(name)
  StopScreenEffect(name)
end

local user_id = nil
local baseplayers = {}

function tLUNA.setBasePlayers(players)
  baseplayers = players
end

function tLUNA.addBasePlayer(player, id)
  baseplayers[player] = id
end

function tLUNA.removeBasePlayer(player)
  --baseplayers[player] = nil
end

function tLUNA.setUserID(a)
  user_id = a
end
function tLUNA.getUserId(Z)
  if Z then
    return baseplayers[Z]
  else
    return user_id
  end
end

-- ANIM

-- animations dict and names: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local anims = {}
local anim_ids = Tools.newIDGenerator()

-- play animation (new version)
-- upper: true, only upper body, false, full animation
-- seq: list of animations as {dict,anim_name,loops} (loops is the number of loops, default 1) or a task def (properties: task, play_exit)
-- looping: if true, will LUNAly loop the first element of the sequence until stopAnim is called
function tLUNA.playAnim(upper, seq, looping)
  if seq.task ~= nil then -- is a task (cf https://github.com/ImagicTheCat/LUNA/pull/118)
    tLUNA.stopAnim(true)

    local ped = GetPlayerPed(-1)
    if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
      local x,y,z = tLUNA.getPosition()
      TaskStartScenarioAtPosition(ped, seq.task, x, y, z-1, GetEntityHeading(ped), 0, 0, false)
    else
      TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
    end
  else -- a regular animation sequence
    tLUNA.stopAnim(upper)

    local flags = 0
    if upper then flags = flags+48 end
    if looping then flags = flags+1 end

    Citizen.CreateThread(function()
      -- prepare unique id to stop sequence when needed
      local id = anim_ids:gen()
      anims[id] = true

      for k,v in pairs(seq) do
        local dict = v[1]
        local name = v[2]
        local loops = v[3] or 1

        for i=1,loops do
          if anims[id] then -- check animation working
            local first = (k == 1 and i == 1)
            local last = (k == #seq and i == loops)

            -- request anim dict
            RequestAnimDict(dict)
            local i = 0
            while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
              Citizen.Wait(10)
              RequestAnimDict(dict)
              i = i+1
            end

            -- play anim
            if HasAnimDictLoaded(dict) and anims[id] then
              local inspeed = 8.0001
              local outspeed = -8.0001
              if not first then inspeed = 2.0001 end
              if not last then outspeed = 2.0001 end

              TaskPlayAnim(GetPlayerPed(-1),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
            end

            Citizen.Wait(0)
            while GetEntityAnimCurrentTime(GetPlayerPed(-1),dict,name) <= 0.95 and IsEntityPlayingAnim(GetPlayerPed(-1),dict,name,3) and anims[id] do
              Citizen.Wait(0)
            end
          end
        end
      end

      -- free id
      anim_ids:free(id)
      anims[id] = nil
    end)
  end
end
local ax = {}
Citizen.CreateThread(function()
  while true do
    local ay = {}
    ay.playerPed = tLUNA.getPlayerPed()
    ay.playerCoords = tLUNA.getPlayerCoords()
    ay.playerId = tLUNA.getPlayerId()
    ay.vehicle = tLUNA.getPlayerVehicle()
    ay.weapon = GetSelectedPedWeapon(ay.playerPed)
    for az = 1, #ax do
        local aA = ax[az]
        aA(ay)
    end
    Wait(0)
  end
end)
function tLUNA.createThreadOnTick(aA)
  ax[#ax + 1] = aA
end
local ai = 0
local R = 0
local S = 0
local T = vector3(0, 0, 0)
local U = false
local V = PlayerPedId
function savePlayerInfo()
  ai = V()
  R = GetVehiclePedIsIn(ai, false)
  S = PlayerId()
  T = GetEntityCoords(ai)
  local e = GetPedInVehicleSeat(R, -1)
  U = e == ai
end
_G["PlayerPedId"] = function()
  return ai
end
function tLUNA.getPlayerPed()
  return ai
end
function tLUNA.getPlayerVehicle()
  return R, U
end
function tLUNA.getPlayerId()
  return S
end
function tLUNA.getPlayerCoords()
  return T
end
createThreadOnTick(savePlayerInfo)

local aj = {}
local ak = {
    ["alphabet"] = "abcdefghijklmnopqrstuvwxyz",
    ["numerical"] = "0123456789",
    ["alphanumeric"] = "abcdefghijklmnopqrstuvwxyz0123456789"
}
local function al(am, type)
    local an, ao, ap = 0, "", 0
    local aq = {ak[type]}
    repeat
        an = an + 1
        ap = math.random(aq[an]:len())
        if math.random(2) == 1 then
            ao = ao .. aq[an]:sub(ap, ap)
        else
            ao = aq[an]:sub(ap, ap) .. ao
        end
        an = an % #aq
    until ao:len() >= am
    return ao
end
function tLUNA.generateUUID(ar, am, type)
    if aj[ar] == nil then
        aj[ar] = {}
    end
    if type == nil then
        type = "alphanumeric"
    end
    local as = al(am, type)
    if aj[ar][as] then
        while aj[ar][as] ~= nil do
            as = al(am, type)
            Wait(0)
        end
    end
    aj[ar][as] = true
    return as
end

function drawNativeNotification(V)
  BeginTextCommandPrint("STRING")
  AddTextComponentSubstringPlayerName(V)
  EndTextCommandPrint(100, 1)
end

function drawNativeText(str)
	SetTextEntry_2("STRING")
	AddTextComponentString(str)
	EndTextCommandPrint(1000, 1)
end


-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tLUNA.stopAnim(upper)
  anims = {} -- stop all sequences
  if upper then
    ClearPedSecondaryTask(GetPlayerPed(-1))
  else
    ClearPedTasks(GetPlayerPed(-1))
  end
end

-- RAGDOLL
local ragdoll = false

-- set player ragdoll flag (true or false)
function tLUNA.setRagdoll(flag)
  ragdoll = flag
end

-- ragdoll thread
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if ragdoll then
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
    end
  end
end)
-- SOUND
-- some lists: 
-- pastebin.com/A8Ny8AHZ
-- https://wiki.gtanet.work/index.php?title=FrontEndSoundlist

-- play sound at a specific position
function tLUNA.playSpatializedSound(dict,name,x,y,z,range)
  PlaySoundFromCoord(-1,name,x+0.0001,y+0.0001,z+0.0001,dict,0,range+0.0001,0)
end

-- play sound
function tLUNA.playSound(dict,name)
  PlaySound(-1,name,dict,0,0,1)
end

--[[
-- not working
function tLUNA.setMovement(dict)
  if dict then
    SetPedMovementClipset(GetPlayerPed(-1),dict,true)
  else
    ResetPedMovementClipset(GetPlayerPed(-1),true)
  end
end
--]]

-- events

AddEventHandler("playerSpawned",function()
  TriggerServerEvent("LUNAcli:playerSpawned")
  TriggerServerEvent("LUNA:gettingUserID")
  TriggerServerEvent("LUNA:PoliceCheck")
  TriggerServerEvent("LUNA:RebelCheck")
  TriggerServerEvent("LUNA:VIPCheck")
  TriggerServerEvent("LUNA:getHouses")
end)

AddEventHandler("playerSpawned",function()
  TriggerEvent("LUNA:UnFreezeRespawn")
end)

AddEventHandler("onPlayerDied",function(player,reason)
  TriggerServerEvent("LUNAcli:playerDied")
end)

AddEventHandler("onPlayerKilled",function(player,killer,reason)
  TriggerServerEvent("LUNAcli:playerDied")
end)

TriggerServerEvent('LUNA:CheckID')

RegisterNetEvent('LUNA:CheckIdRegister')
AddEventHandler('LUNA:CheckIdRegister', function()
    TriggerEvent('playerSpawned', GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent("LUNA:setUserID")
AddEventHandler("LUNA:setUserID", function(serverid)
  user_id = serverid
end)

function tLUNA.spawnVehicle(W,v,w,H,X,Y,Z,_)
  local a0=loadModel(W)
  local a1=CreateVehicle(a0,v,w,H,X,Z,_)
  SetEntityAsMissionEntity(a1)
  SetModelAsNoLongerNeeded(a0)
  if Y then 
      TaskWarpPedIntoVehicle(PlayerPedId(),a1,-1)
  end
  return a1
end

local developers = {
  [1] = true,
}
local grind = {
  [1] = true,
}
function tLUNA.isGrinder(user_id) 
  return grind[user_id] or false
end

Citizen.CreateThread(
    function()
        while true do
            if globalHideUi then
                HideHudAndRadarThisFrame()
            end
            Wait(0)
        end
    end
)

function tLUNA.loadPtfx(u)
  if not HasNamedPtfxAssetLoaded(u) then
      RequestNamedPtfxAsset(u)
      while not HasNamedPtfxAssetLoaded(u) do
          Wait(0)
      end
  end
  UseParticleFxAsset(u)
end

local a_ = math.rad
local b0 = math.cos
local b1 = math.sin
local b2 = math.abs
function tLUNA.rotationToDirection(b3)
    local B = a_(b3.x)
    local D = a_(b3.z)
    return vector3(-b1(D) * b2(b0(B)), b0(D) * b2(b0(B)), b1(B))
end
  

function tLUNA.notify(R)
  if not globalHideUi then
      SetNotificationTextEntry("STRING")
      AddTextComponentString(R)
      DrawNotification(true, false)
  end
end

function drawNativeText(ai)
  if not globalHideUi then
      BeginTextCommandPrint("STRING")
      AddTextComponentSubstringPlayerName(ai)
      EndTextCommandPrint(100, 1)
  end
end

function tLUNA.isDeveloper(user_id) 
  return developers[user_id] or false
end

function tLUNA.getUserId(val)
  if val==nil then
    return user_id
  end
end

function tLUNA.isStreetnamesEnabled()
  return b
end
function tLUNA.setStreetnamesEnabled(h)
  b = h
  SetResourceKvp("LUNA_streetnames", tostring(h))
end

function tLUNA.isStaffedOn()
  return staffMode
end

function tLUNA.getRageUIMenuWidth()
  local au, g = GetActiveScreenResolution()
  if au == 1920 then
      return 1300
  elseif au == 1280 and g == 540 then
      return 1000
  elseif au == 2560 and g == 1080 then
      return 1050
  elseif au == 3440 and g == 1440 then
      return 1050
  end
  return 1300
end
function tLUNA.getRageUIMenuHeight()
  return 100
end

function tLUNA.isPurge()
  return GetConvarInt("luna_purge", 0) == 1
end

function tLUNA.announceClient(U)
  if U ~= nil then
      CreateThread(
          function()
              local V = GetGameTimer()
              local bs = RequestScaleformMovie("MIDSIZED_MESSAGE")
              while not HasScaleformMovieLoaded(bs) do
                  Wait(0)
              end
              PushScaleformMovieFunction(bs, "SHOW_SHARD_MIDSIZED_MESSAGE")
              PushScaleformMovieFunctionParameterString("~g~LUNA Announcement")
              PushScaleformMovieFunctionParameterString(U)
              PushScaleformMovieMethodParameterInt(5)
              PushScaleformMovieMethodParameterBool(true)
              PushScaleformMovieMethodParameterBool(false)
              EndScaleformMovieMethod()
              while V + 6 * 1000 > GetGameTimer() do
                  DrawScaleformMovieFullscreen(bs, 255, 255, 255, 255)
                  Wait(0)
              end
          end
      )
  end
end

function tLUNA.announceMpBigMsg(a_, b0, b1)
  local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

  while not HasScaleformMovieLoaded(scaleform) do
      Wait(0)
  end

  BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
  ScaleformMovieMethodAddParamPlayerNameString(a_)
  ScaleformMovieMethodAddParamPlayerNameString(b0)
  ScaleformMovieMethodAddParamInt(0)
  ScaleformMovieMethodAddParamBool(false)
  ScaleformMovieMethodAddParamBool(false)
  EndScaleformMovieMethod()

  local isEnded = false
  SetTimeout(b1, function()
      isEnded = true
  end)

  while not isEnded do
      DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
      Wait(0)
  end
end


local BucketValue = 0
function tLUNA.getPlayerBucket()
    return BucketValue
end
RegisterNetEvent("LUNA:SetPlayerBucket",function(BucketNumber)
  print("BucketNumber: "..BucketNumber)
        BucketValue = BucketNumber
    end)

    function isInArea(q, s)
      if #(GetEntityCoords(PlayerPedId()) - q) <= s then
          return true
      else
          return false
      end
  end


-- Citizen.CreateThread(
--     function()
--         while true do
--             if tLUNA.isDeveloper(tLUNA.getUserId()) then
--                 if not HasPedGotWeapon(PlayerPedId(), "GADGET_PARACHUTE", false) then
--                     GiveWeaponToPed(PlayerPedId(), "GADGET_PARACHUTE")
--                     SetPlayerHasReserveParachute(PlayerId())
--                 end
--             end
--             if tLUNA.isDeveloper(tLUNA.getUserId()) then
--                 SetVehicleDirtLevel(getPlayerVehicle(), 0.0)
--             end
--             Wait(500)
--         end
--     end
-- )