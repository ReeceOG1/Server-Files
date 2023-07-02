local a=1000
local b=1000
local c=1000
local d="0"
local e=vector3(924.9962,47.0060,81.1045)
local f=vector3(1089.608,206.600,-48.999)
local g=vector3(967.6533,63.68201,112.5531)
local inCasino = false
RMenu.Add('LUNAChips','cashier',RageUI.CreateMenu("","",1300,100,"shopui_title_casino","shopui_title_casino"))
RMenu:Get('LUNAChips','cashier'):SetSubtitle("~b~Chips")
RMenu.Add('casino_enter','casino',RageUI.CreateMenu("","",1300,100,"shopui_title_casino","shopui_title_casino"))
RMenu:Get('casino_enter','casino'):SetSubtitle("~b~Enter")
RMenu.Add('casino_exit','casino',RageUI.CreateMenu("","",1300,100,"shopui_title_casino","shopui_title_casino"))
RMenu:Get('casino_exit','casino'):SetSubtitle("~b~Exit")
RMenu.Add('casino_rooftop_exit','casino',RageUI.CreateMenu("","",1300,100,"shopui_title_casino","shopui_title_casino"))
RMenu:Get('casino_rooftop_exit','casino'):SetSubtitle("~b~Exit")
local h={{model=`u_f_m_casinocash_01`,pedPosition=vector3(1117.671,218.7382,-49.4),pedHeading=100.0,entryPosition=vector3(1116.0776,218.0423,-50.4350)},{model=`u_f_m_casinocash_01`,pedPosition=vector3(20.1525,6705.5737,-105.8544),pedHeading=75.0,entryPosition=vector3(18.4456,6705.7485,-106.8544)}}
Citizen.CreateThread(function()
    local i="mini@strip_club@idles@bouncer@base"
    RequestAnimDict(i)
    while not HasAnimDictLoaded(i)do 
        RequestAnimDict(i)
        Wait(0)
    end
    for j,k in pairs(h)do 
        local l=tLUNA.loadModel(k.model)
        local m=CreatePed(26,l,k.pedPosition.x,k.pedPosition.y,k.pedPosition.z,100.0,false,true)
        SetModelAsNoLongerNeeded(l)
        SetEntityCanBeDamaged(m,0)
        SetPedAsEnemy(m,0)
        SetBlockingOfNonTemporaryEvents(m,1)
        SetPedResetFlag(m,249,1)
        SetPedConfigFlag(m,185,true)
        SetPedConfigFlag(m,108,true)
        SetPedCanEvasiveDive(m,0)
        SetPedCanRagdollFromPlayerImpact(m,0)
        SetPedConfigFlag(m,208,true)
        SetEntityCollision(m,false)
        SetEntityCoordsNoOffset(m,k.pedPosition.x,k.pedPosition.y,k.pedPosition.z,100.0,0,0,1)
        SetEntityHeading(m,k.pedHeading)
        FreezeEntityPosition(m,true)
        TaskPlayAnim(m,i,"base",8.0,0.0,-1,1,0,0,0,0)
    end
    RemoveAnimDict(i)
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('LUNAChips', 'cashier')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Buy chips","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    TriggerServerEvent("LUNA:buyChips")
                end 
            end)
            RageUI.Button("Sell chips","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    TriggerServerEvent("LUNA:sellChips")
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('casino_exit', 'casino')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Exit Diamond Casino","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    TriggerServerEvent("LUNA:exitDiamondCasino")
                    tLUNA.teleport(e.x,e.y,e.z)
                    if cardObjects then 
                        for r,s in pairs(cardObjects)do 
                            for j,t in pairs(s)do 
                                DeleteObject(t)
                            end 
                        end 
                    end 
                    inCasino = false
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('casino_enter', 'casino')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Enter Diamond Casino","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    TriggerServerEvent("LUNA:enterDiamondCasino")
                    tLUNA.teleport(f.x,f.y,f.z)
                    inCasino = true
                end 
            end)
            RageUI.Button("Diamond Casino Rooftop","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    tLUNA.teleport(g.x,g.y,g.z)
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('casino_rooftop_exit', 'casino')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Exit Rooftop","",{RightLabel="→→→"},true,function(n,o,p)
                if p then 
                    tLUNA.teleport(e.x,e.y,e.z)
                end 
            end)
        end)
    end
end)

function showCasinoChipsCashier(u)
    RageUI.Visible(RMenu:Get('LUNAChips','cashier'),u)
end
function showCasinoEnter(u)
    RageUI.Visible(RMenu:Get('casino_enter','casino'),u)
end
function showCasinoRooftopExit(u)
    RageUI.Visible(RMenu:Get('casino_rooftop_exit','casino'),u)
end
function showCasinoExit(u)
    RageUI.Visible(RMenu:Get('casino_exit','casino'),u)
end
Citizen.CreateThread(function()
    while true do 
        if a<1.5 then 
            showCasinoEnter(true)
        elseif a<2.5 then 
            showCasinoEnter(false)
        end
        if b<1.5 then 
            showCasinoExit(true)
        elseif b<2.5 then 
            showCasinoExit(false)
        end
        if c<1.5 then 
            showCasinoRooftopExit(true)
        elseif c<2.5 then 
            showCasinoRooftopExit(false)
        end
        Wait(0)
    end 
end)
Citizen.CreateThread(function()
    while true do 
        DrawMarker(27,e.x,e.y,e.z-1.0,0,0,0,0,0,0,1.001,1.0001,0.5001,255,255,255,200,0,0,0,0)
        DrawMarker(27,f.x,f.y,f.z-1.0,0,0,0,0,0,0,1.001,1.0001,0.5001,255,255,255,200,0,0,0,0)
        DrawMarker(27,g.x,g.y,g.z-1.0,0,0,0,0,0,0,1.001,1.0001,0.5001,255,255,255,200,0,0,0,0)
        Wait(0)
    end 
end)
Citizen.CreateThread(function()
    while true do 
        local v=GetEntityCoords(tLUNA.getPlayerPed())
        a=#(v-e)
        b=#(v-f)
        c=#(v-g)
        Wait(100)
    end 
end)
RegisterNetEvent("LUNA:setDisplayChips")
AddEventHandler("LUNA:setDisplayChips",function(x)
    local y = tostring(x)
    d = getMoneyStringFormatted(y)
end)

RegisterNetEvent("LUNA:chipsUpdated",function()
    TriggerServerEvent('LUNA:getChips')
end)

local z={{position=vector3(1149.3828,269.19174,-52.0208),radius=100},{position=vector3(54.0539,6742.1513,-107.3543),radius=100},{position=vector3(-1896.8582,2069.3537,144.8627),radius=10},{position=vector3(774.7513,-552.9113,22.4988),radius=100},{position=vector3(-1137.8917,-184.7176,40.0803),radius=50},{position=vector3(422.0620,18.2774,91.935),radius=25}}


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if inCasino then       
            DrawMarker(27,1115.9804,217.9931,-49.43511 -1.0,0,0,0,0,0,0,1.001,1.0001,0.5001,255,255,255,200,0,0,0,0)
            if isInArea(vector3(1115.9804,217.9931,-49.43511), 0.8) then 
                RageUI.Visible(RMenu:Get("LUNAChips", "cashier"), true)
                chipsMenu = true
            end
            if isInArea(vector3(1115.9804,217.9931,-49.43511), 0.8) == false and chipsMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("LUNAChips", "cashier"), false)
                chipsMenu = false
            end
            for H,k in pairs(h)do 
                tLUNA.addBlip(k.entryPosition.x,k.entryPosition.y,k.entryPosition.z,683,0,"Chips Cashier",0.7,true)
            end
            SetScriptGfxDrawOrder(7)
            DrawSprite("CommonMenu","shop_chips_b",0.89,0.078,0.025,0.030,0.0,255,255,255,255)
            SetScriptGfxDrawOrder(1)
            DrawRect(0.934,0.077,0.104,0.036,0,0,0,150)
            DrawAdvancedTextNoOutline(1.037,0.08,0.005,0.0028,0.52,d,255,255,255,255,7,0)
        end
    end 
end)

function DrawAdvancedTextNoOutline(v,w,x,y,z,A,B,C,D,E,F,G)
    SetTextFont(F)
    SetTextProportional(0)
    SetTextScale(z,z)
    N_0x4e096588b13ffeca(G)
    SetTextColour(B,C,D,E)
    SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(A)
    DrawText(v-0.1+x,w-0.02+y)
end

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function tLUNA.loadModel(modelName)
    local modelHash
    if type(modelName) ~= "string" then
        modelHash = modelName
    else
        modelHash = GetHashKey(modelName)
    end
    if IsModelInCdimage(modelHash) then
        if not HasModelLoaded(modelHash) then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(0)
            end
        end
        return modelHash
    else
        return nil
    end
  end