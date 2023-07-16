local comaAnim = {}
in_coma = false
local coma_left = 30
local secondsTilBleedout = 60   
local playerCanRespawn = false 
local calledNHS = false
local deathString = ""
local deathPosition
local notified = false
local killfeed = false
fullyComa = false
local comaAnim = {}
local DeathAnim = 50
local e = 0
local f = 300
local g = false
local i = 100
local n = 102
WeaponNames={}
WeaponSpawnCodes={}
local cfg = module("cfg/cfg_respawn")
local o=module("cfg/weapons")
local p={}
local q={}
Citizen.CreateThread(function()
    q=o.nativeWeaponModelsToNames
    for r,s in pairs(o.weapons)do 
        q[r]=s.name
    end
    for r,t in pairs(q)do 
        WeaponNames[GetHashKey(r)]=t
        p[GetHashKey(r)]=r
    end
end)
Citizen.CreateThread(function()
    while true do 
        if in_coma then
			if not calledNHS then
				if IsControlJustPressed(1, 51) then
                    TriggerEvent("LUNA:DEATH_SCREEN_NHS_CALLED")
                    ExecuteCommand("6578833634667874")
                    calledNHS = true
				end
			end
            DisableControlAction(0,323,true)
            DisableControlAction(0,182,true)
            DisableControlAction(0,37,true)
        end
        Wait(0) 
    end 
end)

AddEventHandler("LUNA:countdownEnded",function()
    g = true
end)

Citizen.CreateThread(function()
    while true do 
        if IsDisabledControlJustPressed(0,38) then
            if g and in_coma then
                tLUNA.respawnPlayer()
                DoScreenFadeIn(800)
                TriggerEvent("LUNA:respawnKeyPressed")
                TriggerServerEvent("LUNA:SendSpawnMenu")
                calledNHS = false
            end
        end
        Wait(0)
    end
end)


Citizen.CreateThread(function() -- coma thread
    Wait(500)
    exports.spawnmanager:setAutoSpawn(false)
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        local health = GetEntityHealth(ped)
        if IsEntityDead(GetPlayerPed(-1)) and not in_coma then --Wait for death check
            pbCounter = 100
            local plyCoords = GetEntityCoords(GetPlayerPed(-1),true)
            LUNAserver.StoreWeaponsDead()
            LUNAserver.Coma()
            TriggerEvent('LUNA:IsInMoneyComa', true)
            TriggerServerEvent('LUNA:InComa')
            LUNAserver.MoneyDrop()
            TriggerEvent('LUNA:5Seconds')
            tLUNA.ejectVehicle()
            in_coma = true
            TriggerServerEvent("LUNA:getNumOfNHSOnline")
            TriggerEvent("luna:PlaySound", tLUNA.getDeathSound())
            SendNUIMessage({action = in_coma})
            deathPosition = plyCoords
            local x,y,z = table.unpack(deathPosition)
            LUNAserver.updatePos({x,y,z})
            LUNAserver.updateHealth({0})
            Wait(250) --Need wait, otherwise will autorevive in next check
        end

        if DeathAnim <= 0  then --Been 10 seconds, proceed to play anim check 
            DeathAnim = 50 
            local entityDead = GetEntityHealth(GetPlayerPed(-1))
            while entityDead <= 100 do
                Wait(0)
                local x,y,z = tLUNA.getPosition()
                NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)), true, true, false)
                entityDead = GetEntityHealth(GetPlayerPed(-1))
                fullyComa = true
            end
            SetEntityHealth(GetPlayerPed(-1), 102)
            SetEntityInvincible(GetPlayerPed(-1),true)
            comaAnim = getRandomComaAnimation()
            if not HasAnimDictLoaded(comaAnim.dict) then
                RequestAnimDict(comaAnim.dict)
                while not HasAnimDictLoaded(comaAnim.dict) do
                    Wait(0)
                end
            end
            TaskPlayAnim(GetPlayerPed(-1), comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0 )
        end

        if health > 102 and in_coma then --Revive check
            if IsEntityDead(GetPlayerPed(-1)) then
                local x,y,z = tLUNA.getPosition()
                NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)), true, true, false)
                Wait(0)
            end
        
            playerCanRespawn = false 
            tLUNA.disableComa()
            DeathAnim = 50 

            SetEntityInvincible(GetPlayerPed(-1),false)
            ClearPedSecondaryTask(GetPlayerPed(-1))
            Citizen.CreateThread(function()
                Wait(500)
                ClearPedSecondaryTask(GetPlayerPed(-1))
                ClearPedTasks(GetPlayerPed(-1))
            end)    
        end 

        local health = GetEntityHealth(GetPlayerPed(-1))
        if health <= 102 and not in_coma then 
            SetEntityHealth(GetPlayerPed(-1),0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if in_coma then
            local playerPed = PlayerPedId()
            if not IsEntityDead(playerPed) then
                if comaAnim.dict == nil then
                    comaAnim = getRandomComaAnimation()
                end
                if not IsEntityPlayingAnim(playerPed,comaAnim.dict,comaAnim.anim,3)  then
                    if comaAnim.dict ~= nil then
                        if not HasAnimDictLoaded(comaAnim.dict) then
                            RequestAnimDict(comaAnim.dict)
                            while not HasAnimDictLoaded(comaAnim.dict) do
                                Wait(0)
                            end
                        end
                        TaskPlayAnim(playerPed, comaAnim.dict, comaAnim.anim, 3.0, 1.0, -1, 1, 0, 0, 0, 0 )
                    end
                end
            end
            if GetEntityHealth(playerPed) > 102 then 
                tLUNA.disableComa()
                if IsEntityDead(playerPed) then
                    local x,y,z = tLUNA.getPosition()
                    NetworkResurrectLocalPlayer(x, y, z, GetEntityHeading(GetPlayerPed(-1)),true, true, false)
                    Wait(0)
                end
                tLUNA.disableComa()
                DeathAnim = 50 
                deathString = ""
                SetEntityInvincible(playerPed,false)
                ClearPedSecondaryTask(playerPed) 
            end
        end
        Wait(0)
    end
end)


Citizen.CreateThread(function()
    while true do 
        if in_coma then
            secondsTilBleedout = secondsTilBleedout - 1
        end
        Wait(1000)
    end
end) 

Citizen.CreateThread(function()
    while DeathAnim <= 5 and DeathAnim >= 0 do
        Wait(1000)
        DeathAnim = DeathAnim - 1
    end
end) 

RegisterNetEvent("LUNA:5Seconds")
AddEventHandler("LUNA:5Seconds", function()
    DeathAnim = 5
    while DeathAnim <= 5 and DeathAnim >= 0 do
        Wait(1000)
        DeathAnim = DeathAnim - 1
    end
end)

function tLUNA.respawnPlayer()
    DoScreenFadeOut(1000)
    Wait(1000)
    DoScreenFadeIn(500)
    exports.spawnmanager:spawnPlayer()
    playerCanRespawn = false 
    deathString = ""
    local ped = GetPlayerPed(-1)
    tLUNA.reviveComa()
end


function tLUNA.disableComa()
    in_coma = false
    killfeed = false
end

function tLUNA.isInComa()
    return in_coma
end

RegisterNetEvent("LUNA:FixClient")
AddEventHandler("LUNA:FixClient", function()
    local resurrectspamm = true
    Citizen.CreateThread(function()
        while true do 
            Wait(0)
            if resurrectspamm == true then
                Citizen.Wait(500)
                NetworkSetVoiceActive(true)
                SetPlayerTalkingOverride(PlayerId(), true)
                fullyComa = false
                notified = false
                local ped = PlayerPedId()
                local x,y,z = GetEntityCoords(ped)
                respawnedrecent = false 
                NetworkResurrectLocalPlayer(x, y, z, true, true, false)
                Citizen.Wait(0)
                calledNHS = false
                ClearPedTasksImmediately(PlayerPedId())
                resurrectspamm = false
                in_coma = false
                killfeed = false
                EnableControlAction(0, 73, true)
                tLUNA.stopScreenEffect(cfg.coma_effect)
                TriggerEvent("LUNA:CLOSE_DEATH_SCREEN")
                Citizen.Wait(500)
            end 
        end
    end)
end)

local L = {}
function tLUNA.getKillerInfo()
    return L
end

RegisterNetEvent("LUNA:getNumberOfDocsOnline",function(I)
    c = I
    e = 60000
    f = e / 1000
    i = 10
    l = GetGameTimer()
    CreateThread(function()
        local K = GetGameTimer()
        while tLUNA.getKillerInfo().ready == nil do
            Wait(0)
        end
        local L = tLUNA.getKillerInfo()
        local M = false
        if L.name == nil then
            M = true
        end
        g = false
        TriggerEvent("LUNA:SHOW_DEATH_SCREEN", f, L.name or "N/A", L.user_id or "N/A", L.weapon or "N/A", M)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsEntityDead(PlayerPedId()) then
            local s
            local PedKiller = GetPedSourceOfDeath(PlayerPedId())
            Q=GetPedCauseOfDeath(PlayerPedId())
            R=WeaponNames[Q]
            if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
                Killer = NetworkGetPlayerIndexFromPed(PedKiller)
            elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
                Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
            end
            local distance = 0
            local a6 = false
            local az = tLUNA.getPedServerId(PedKiller)
            if (Killer == PlayerId()) or (Killer == nil) then
                a6 = true
            else
                L.name = GetPlayerName(Killer)
                distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(PedKiller))
            end
            L.source = az
            L.user_id = tLUNA.getPedServerId(PedKiller)
            L.weapon = tostring(R)
            L.ready = true

            if s == nil then
                s = "N/A"
            end
            if distance == nil then
                distance = "N/A"
            end
            if R == nil then
                R = ""
            end
            if not g and in_coma and killfeed then
                TriggerServerEvent("LUNA:onPlayerKilled", "finished off", tLUNA.getPedServerId(PedKiller), s)
            else
                TriggerServerEvent("LUNA:onPlayerKilled", "killed", tLUNA.getPedServerId(PedKiller), R, a6, distance)
                killfeed = true
            end
            Killer = nil
            PedKiller = nil
            R = nil
        end
        while IsEntityDead(PlayerPedId()) do
            Citizen.Wait(0)
        end
        L = {}
    end
end)

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

local Cameras = 0
RegisterNetEvent("LUNA:OpenSpawnMenu",function(Table)
    DoScreenFadeIn(1000)
    TriggerScreenblurFadeIn(100.0)
    ExecuteCommand("hideui")
    SetPlayerControl(PlayerId(), false, 0)
    local K = GetPlayerPed(-1)
    local U = tLUNA.getPlayerCoords()
    FreezeEntityPosition(K, true)
    SetEntityCoordsNoOffset(K, U.x, U.y, -100.0, false, false, false)
    Cameras = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA",675.57568359375,1107.1724853516,375.29666137695,0.0,0.0,0.0,65.0,0,2)
    SetCamActive(Cameras, true)
    RenderScriptCams(true, true, 0, true, false)
    SetCamParams(Cameras, -1024.6506347656, -2712.0234375, 79.889106750488, 0.0, 0.0, 0.0, 65.0, 250000, 0, 0, 2)
    local JustATable = {}
    for k, v in pairs(Table) do
        if cfg.spawnLocations[v] then
            table.insert(JustATable, cfg.spawnLocations[v])
        end
    end
    TriggerEvent("LUNAUI4:openSpawnMenu", JustATable)
end)
AddEventHandler("LUNA:respawnButtonClicked",function(w, c)
    if c ~= nil then
        TriggerServerEvent("LUNA:takeAmount", c)
    end
    local x = cfg.spawnLocations[w].coords
    TriggerEvent("LUNA:playGTAIntro")
    SetEntityCoords(GetPlayerPed(-1), x)
    SetEntityVisible(GetPlayerPed(-1), true, 0)
    SetPlayerControl(PlayerId(), true, 0)
    SetFocusPosAndVel(x.x, x.y, x.z + 1000)
    local Z = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", x.x, x.y, x.z + 1000.0, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActive(Z, true)
    RenderScriptCams(true, true, 0, true, false)
    SetCamParams(Z, x.x, x.y, x.z, 0.0, 0.0, 0.0, 65.0, 5000, 0, 0, 2)
    Wait(2500)
    ClearFocus()
    Wait(2000)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    RenderScriptCams(false, true, 2000, true, false)
    DestroyCam(Z, false)
    DestroyCam(Cameras, false)
    RenderScriptCams(false, true, 2000, false, false)
    TriggerScreenblurFadeOut(2000.0)
    ExecuteCommand("showui")
    ClearFocus()
end)

function tLUNA.reviveComa()
    local ped = GetPlayerPed(-1)
    SetEntityInvincible(ped,false)
    tLUNA.setRagdoll(false)
    tLUNA.stopScreenEffect(cfg.coma_effect)
    SetEntityHealth(GetPlayerPed(-1), 200)
end

-- kill the player if in coma
function tLUNA.killComa()
    if in_coma then
        coma_left = 0
    end
end

Citizen.CreateThread(function() -- disable health regen, conflicts with coma system
    while true do
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        Wait(0)
    end
end)

function tLUNA.varyHealth(variation)
    local ped = GetPlayerPed(-1)

    local n = math.floor(GetEntityHealth(ped)+variation)
    SetEntityHealth(ped,n)
end

function tLUNA.reviveHealth()
    local ped = GetPlayerPed(-1)
    if GetEntityHealth(ped) == 102 then
        SetEntityHealth(ped,200)
    end
end

function tLUNA.getHealth()
    return GetEntityHealth(GetPlayerPed(-1))
end

function tLUNA.getArmour()
    return GetPedArmour(GetPlayerPed(-1))
end

function tLUNA.setHealth(health)
    local n = math.floor(health)
    SetEntityHealth(GetPlayerPed(-1),n)
end

function tLUNA.setArmour(armour)
    SetPedArmour(PlayerPedId(), armour)
end

function tLUNA.setFriendlyFire(flag)
    local flag = true
    NetworkSetFriendlyFireOption(flag)
    SetCanAttackFriendly(GetPlayerPed(-1), flag, flag)
end

function tLUNA.setPolice(flag)
    local flag = false
    local player = PlayerId()
    SetPoliceIgnorePlayer(player, not flag)
    SetDispatchCopsForPlayer(player, flag)
end

function getRandomComaAnimation()
-- --death emotes
    randomComaAnimations = {
        {"combat@damage@writheidle_a", "writhe_idle_a"},
        {"combat@damage@writheidle_a", "writhe_idle_b"},
        {"combat@damage@writheidle_a", "writhe_idle_c"},
        {"combat@damage@writheidle_b", "writhe_idle_d"},
        {"combat@damage@writheidle_b", "writhe_idle_e"},
        {"combat@damage@writheidle_b", "writhe_idle_f"},
        {"combat@damage@writheidle_c", "writhe_idle_g"},
        {"combat@damage@rb_writhe", "rb_writhe_loop"},
        {"combat@damage@writhe", "writhe_loop"}
    }


    comaAnimation = {}
    
    math.randomseed(GetGameTimer())
    num = math.random(1,#randomComaAnimations)
    num = math.random(1,#randomComaAnimations)
    num = math.random(1,#randomComaAnimations)
    
    dict,anim = table.unpack(randomComaAnimations[num])
    comaAnimation["dict"] = dict
    comaAnimation["anim"] = anim
    --comaAnimation["dict"] = "combat@damage@writheidle_a"
    --comaAnimation["anim"] = "writhe_idle_a"
    --randomize this :)
    return comaAnimation
end

function DrawAdvancedTextOutline(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)

    SetTextEdge(1, 0, 0, 0, 255)

    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function tLUNA.getHealth()
    return GetEntityHealth(GetPlayerPed(-1))
end

AddEventHandler("LUNA:playGTAIntro",function()
    TriggerEvent("luna:PlaySound", "gtaloadin")
end)