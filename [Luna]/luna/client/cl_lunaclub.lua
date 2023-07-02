RMenu.Add('lunaclubmenu','mainmenu',RageUI.CreateMenu("","",1300, 100,"banners", "lunaclub"))
RMenu:Get('lunaclubmenu','mainmenu'):SetSubtitle("~y~LUNA Plat/Plus Membership")
RMenu.Add('lunaclubmenu','managesubscription',RageUI.CreateSubMenu(RMenu:Get('lunaclubmenu','mainmenu'),"","",1300, 100,"banners", "lunaclub"))
RMenu:Get('lunaclubmenu','managesubscription'):SetSubtitle("~y~LUNA Plat/Plus Membership")
RMenu.Add('lunaclubmenu','manageusersubscription',RageUI.CreateSubMenu(RMenu:Get('lunaclubmenu','mainmenu'),"","",1300, 100,"banners", "lunaclub"))
RMenu:Get('lunaclubmenu','manageusersubscription'):SetSubtitle("~y~LUNA Plat/Plus Membership")
RMenu.Add('lunaclubmenu','manageperks',RageUI.CreateSubMenu(RMenu:Get('lunaclubmenu','mainmenu'),"","",1300, 100,"banners", "lunaclub"))
RMenu:Get('lunaclubmenu','manageperks'):SetSubtitle("~y~LUNA Plat/Plus Membership")
RMenu.Add('lunaclubmenu','deathsounds',RageUI.CreateSubMenu(RMenu:Get('lunaclubmenu','manageperks'),"","",1300, 100,"banners", "lunaclub"))
RMenu:Get('lunaclubmenu','deathsounds'):SetSubtitle("~y~LUNA Plat/Plus Membership")
RMenu.Add('lunaclubmenu','vehicleextras',RageUI.CreateSubMenu(RMenu:Get('lunaclubmenu','manageperks'),"","",1300, 100,"banners", "lunaclub"))
RMenu:Get('lunaclubmenu','vehicleextras'):SetSubtitle("~y~LUNA Plat/Plus Membership")
local a={hoursOfPlus=0,hoursOfPlatinum=0}
local z={}
local killNotification = false

function tLUNA.isPlusClub()
    if a.hoursOfPlus>0 then 
        return true 
    else 
        return false 
    end 
end

function tLUNA.isPlatClub()
    if a.hoursOfPlatinum>0 then 
        return true 
    else 
        return false 
    end 
end

RegisterCommand("lunaclub",function()
    TriggerServerEvent('LUNA:getPlayerSubscription')
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('lunaclubmenu','mainmenu'),not RageUI.Visible(RMenu:Get('lunaclubmenu','mainmenu')))
end)

local d={
    ["Default"]={checked=true,soundId="dead"},
    ["Fortnite"]={checked=false,soundId="fortnite_death"},
    ["Roblox"]={checked=false,soundId="roblox_death"},
    ["Minecraft"]={checked=false,soundId="minecraft_death"},
    ["Pac-Man"]={checked=false,soundId="pacman_death"},
    ["Mario"]={checked=false,soundId="mario_death"},
    ["CS:GO"]={checked=false,soundId="csgo_death"}
}

local E=true
Citizen.CreateThread(function()
    local f=GetResourceKvpString("LUNA_pluschutes") or "true"
    if f=="true"then
        E=true
    else 
        E=true
    end 
end)
function tLUNA.setparachutestting(f)
    SetResourceKvp("LUNA_pluschutes",tostring(f))
end

AddEventHandler("playerSpawned", function()
    TriggerServerEvent('LUNA:getPlayerSubscription')
    Wait(5000)
    local i=tLUNA.getDeathSound()
    local j="dead"
    for k,l in pairs(d)do 
        if l.soundId==i then 
            j=k 
        end 
    end
    for k,m in pairs(d)do 
        if j~=k then 
            m.checked=false 
        else 
            m.checked=true 
        end 
    end 
end)

function tLUNA.setDeathSound(i)
    if tLUNA.isPlusClub() or tLUNA.isPlatClub() then 
        SetResourceKvp("LUNA_deathsound",i)
    else 
        tLUNA.notify("~r~Cannot change deathsound, not a valid LUNA Plat subscriber.")
    end 
end
function tLUNA.getDeathSound()
    if tLUNA.isPlusClub() or tLUNA.isPlatClub() then 
        local k=GetResourceKvpString("LUNA_deathsound")
        if type(k)=="string"and k~=""then 
            return k 
        else 
            return"dead"
        end 
    else 
        return"dead"
    end 
end
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('lunaclubmenu', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Manage Subscription","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("lunaclubmenu","managesubscription"))
            if tLUNA.isPlusClub() or tLUNA.isPlatClub()then 
                RageUI.Button("Manage Perks","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("lunaclubmenu","manageperks"))
            end
            if tLUNA.isDeveloper(tLUNA.getUserId()) then
                RageUI.Button("Manage User's Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("lunaclubmenu","manageusersubscription"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('lunaclubmenu', 'managesubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if a.hoursOfPlus>=10 then 
                colourCode="~g~"
            elseif a.hoursOfPlus<10 and a.hoursOfPlus>3 then 
                colourCode="~y~"
            else 
                colourCode="~r~"
            end
            RageUI.Separator("Days remaining of Plus Subscription: "..colourCode..math.floor(a.hoursOfPlus/24*100)/100 .." days.")
            if a.hoursOfPlatinum>=10 then 
                colourCode="~g~"
            elseif a.hoursOfPlatinum<10 and a.hoursOfPlatinum>3 then 
                colourCode="~y~"
            else 
                colourCode="~r~"
            end
            RageUI.Separator("Days remaining of Platinum Subscription: "..colourCode..math.floor(a.hoursOfPlatinum/24*100)/100 .." days.")
            RageUI.Separator()
            RageUI.Button("Sell Plus Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("LUNA:beginSellSubscriptionToPlayer","Plus")
                end 
            end)
            RageUI.Button("Sell Platinum Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("LUNA:beginSellSubscriptionToPlayer","Platinum")
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('lunaclubmenu', 'manageusersubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tLUNA.isDeveloper(tLUNA.getUserId()) then
                if next(z) then
                    RageUI.Separator('Perm ID: '..z.userid)
                    if z.hoursOfPlus>=10 then 
                        colourCode="~g~"
                    elseif z.hoursOfPlus<10 and z.hoursOfPlus>3 then 
                        colourCode="~y~"
                    else 
                        colourCode="~r~"
                    end
                    RageUI.Separator('Days of Plus Remaining: '..colourCode..math.floor(z.hoursOfPlus/24*100)/100)
                    if z.hoursOfPlatinum>=10 then 
                        colourCode="~g~"
                    elseif z.hoursOfPlatinum<10 and z.hoursOfPlatinum>3 then 
                        colourCode="~y~"
                    else 
                        colourCode="~r~"
                    end
                    RageUI.Separator('Days of Platinum Remaining: '..colourCode..math.floor(z.hoursOfPlatinum/24*100)/100)
                    RageUI.Button("Set Plus Days (in hours)","This has to be set in hours.",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("LUNA:setPlayerSubscription", z.userid, "Plus")
                        end
                    end)
                    RageUI.Button("Set Platinum Days (in hours)","This has to be set in hours.",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("LUNA:setPlayerSubscription", z.userid, "Platinum")
                        end
                    end)    
                else
                    RageUI.Separator('Please select a Perm ID')
                end
                RageUI.Button("Select Perm ID", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        permID = KeyboardInput("Enter Perm ID", "", 10)
                        if permID == nil then 
                            tLUNA.notify('~r~Invalid Perm ID')
                        end
                        TriggerServerEvent('LUNA:getPlayerSubscription', permID)
                    end
                end, RMenu:Get("lunaclubmenu", 'manageusersubscription'))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('lunaclubmenu', 'manageperks')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Custom Death Sounds","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("lunaclubmenu","deathsounds"))
            RageUI.Button("Vehicle Extras","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("lunaclubmenu","vehicleextras"))
            RageUI.Button("Claim Weekly Kit","",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("LUNA:claimWeeklyKit")
                end 
            end)
            -- RageUI.Checkbox("Old killfeed", "~g~This brings back the old Killfeed above the map.", oldkillfeed, {}, function(Hovered, Active, Selected, Checked)
            --     if (Selected) then
            --         for k,v in pairs(d)do 
            --             if k~=u then 
            --                 v.checked=true
            --             end 
            --         end
            --         ExecuteCommand("togglekillfeed")
            --         ExecuteCommand("oldkillfeed")
            --         oldkillfeed = not oldkillfeed
            --     end
            -- end)  
            -- RageUI.Checkbox("Kill Notification", nil, killNotification, {}, function(Hovered, Active, Selected, Checked)
            --     if (Selected) then
            --         notify("~g~Kill Notification Toggled!")
            --         killNotification = not killNotification
            --     end
            -- end)                
            local function R()
                E=true
                tLUNA.setparachutestting(E)
                tLUNA.notify("~a~Parachute enabled.")
            end
            local function S()
                E=false
                tLUNA.setparachutestting(E)
                tLUNA.notify("~r~Parachute disabled.")
            end
            RageUI.Checkbox("Enable Parachute","~g~This gives you a primary and reserve parachute.",E,{Style=RageUI.CheckboxStyle.Car},function(o,q,p,t)
                if p then
                    if E then
                        S()
                    else
                        R()
                    end
                end
            end,R,S)
        end)
    end
    if RageUI.Visible(RMenu:Get('lunaclubmenu', 'deathsounds')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for u,l in pairs(d)do 
                RageUI.Checkbox(u, "", l.checked, {Style = RageUI.CheckboxStyle.Tick}, function(Hovered, Selected, Active, Checked)
                    if Selected then
                        if l.checked then
                            for k,v in pairs(d)do 
                                if k~=u then 
                                    v.checked=false
                                end 
                            end
                            tLUNA.setDeathSound(l.soundId)
                        end
                    end
                    l.checked = Checked
                end)
            end 
        end)
    end
    if RageUI.Visible(RMenu:Get('lunaclubmenu', 'vehicleextras')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local w=tLUNA.getPlayerVehicle()
            SetVehicleAutoRepairDisabled(w,true)
            for x=1,99,1 do 
                if DoesExtraExist(w,x)then 
                    RageUI.Checkbox("Extra "..x,"",IsVehicleExtraTurnedOn(w,x),{},function()
                    end,function()
                        SetVehicleExtra(w,x,0)
                    end,function()
                        SetVehicleExtra(w,x,1)
                    end)
                end 
            end 
        end)
    end
end)

RegisterNetEvent("LUNA:setlunaclubData",function(y,z)
    a.hoursOfPlus=y
    a.hoursOfPlatinum=z 
end)

RegisterNetEvent("LUNA:reducePlusMembershipHour",function()
    a.hoursOfPlus=a.hoursOfPlus-1
    if a.hoursOfPlus<0 then 
        a.hoursOfPlus=0 
    end 
end)

RegisterNetEvent("LUNA:reducePlatMembershipHour",function()
    a.hoursOfPlatinum=a.hoursOfPlatinum-1
    if a.hoursOfPlatinum<0 then 
        a.hoursOfPlatinum=0 
    end 
end)

RegisterNetEvent("LUNA:getUsersSubscription",function(userid, plussub, platsub)
    z.userid = userid
    z.hoursOfPlus=plussub
    z.hoursOfPlatinum=platsub
    RMenu:Get("lunaclubmenu", 'manageusersubscription')
end)

RegisterNetEvent("LUNA:userSubscriptionUpdated",function()
    TriggerServerEvent('LUNA:getPlayerSubscription', permID)
end)


Citizen.CreateThread(function()
    while true do 
        if tLUNA.isPlatClub()then 
            if not HasPedGotWeapon(PlayerPedId(),`GADGET_PARACHUTE`,false) and E then 
                GiveWeaponToPed(PlayerPedId(),`GADGET_PARACHUTE`)
                SetPlayerHasReserveParachute(PlayerId())
            end 
        end
        if tLUNA.isPlusClub() or tLUNA.isPlatClub()then 
            SetVehicleDirtLevel(tLUNA.getPlayerVehicle(),0.0)
        end
        Wait(500)
    end 
end)

RegisterNetEvent('onPlayerKilled')
AddEventHandler('onPlayerKilled', function(killerName)
    if killNotification then
        local text = "Killed : " .. killerName

        Citizen.CreateThread(function()
            local endTime = GetGameTimer() + 5000 -- Display the notification for 5 seconds

            while GetGameTimer() < endTime do
                Citizen.Wait(0)

                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.3, 0.3)
                SetTextColour(255, 255, 255, 255)
                SetTextDropShadow(0, 0, 0, 0, 0)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(text)

                DrawText(0.5, 0.6) -- Position the text below the crosshair
            end
        end)
    end
end)