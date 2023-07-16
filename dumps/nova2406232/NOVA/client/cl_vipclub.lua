RMenu.Add('vipclubmenu','mainmenu',RageUI.CreateMenu("","",1300, 100,"banners", "vipclub"))
RMenu:Get('vipclubmenu','mainmenu'):SetSubtitle("NOVA Club")
RMenu.Add('vipclubmenu','managesubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","",1300, 100,"banners", "vipclub"))
RMenu:Get('vipclubmenu','managesubscription'):SetSubtitle("NOVA Club")
RMenu.Add('vipclubmenu','manageusersubscription',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","",1300, 100,"banners", "vipclub"))
RMenu:Get('vipclubmenu','manageusersubscription'):SetSubtitle("NOVA Club")
RMenu.Add('vipclubmenu','manageperks',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','mainmenu'),"","",1300, 100,"banners", "vipclub"))
RMenu:Get('vipclubmenu','manageperks'):SetSubtitle("NOVA Club Perks")
RMenu.Add('vipclubmenu','deathsounds',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","",1300, 100,"banners", "vipclub"))
RMenu:Get('vipclubmenu','deathsounds'):SetSubtitle("NOVA Club Perks")
RMenu.Add('vipclubmenu','vehicleextras',RageUI.CreateSubMenu(RMenu:Get('vipclubmenu','manageperks'),"","",1300, 100,"banners", "vipclub"))
RMenu:Get('vipclubmenu','vehicleextras'):SetSubtitle("NOVA Club Perks")
local a={hoursOfPlus=0,hoursOfPlatinum=0}
local z={}

function tNOVA.isPlusClub()
    if a.hoursOfPlus>0 then 
        return true 
    else 
        return false 
    end 
end

function tNOVA.isPlatClub()
    if a.hoursOfPlatinum>0 then 
        return true 
    else 
        return false 
    end 
end

RegisterCommand("novaclub",function()
    TriggerServerEvent('NOVA:getPlayerSubscription')
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu'),not RageUI.Visible(RMenu:Get('vipclubmenu','mainmenu')))
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
    local f=GetResourceKvpString("NOVA_pluschutes") or "true"
    if f=="true"then
        E=true
    else 
        E=true
    end 
end)
function tNOVA.setparachutestting(f)
    SetResourceKvp("NOVA_pluschutes",tostring(f))
end

AddEventHandler("playerSpawned", function()
    TriggerServerEvent('NOVA:getPlayerSubscription')
    Wait(5000)
    local i=tNOVA.getDeathSound()
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

function tNOVA.setDeathSound(i)
    if tNOVA.isPlusClub() or tNOVA.isPlatClub() then 
        SetResourceKvp("nova_deathsound",i)
    else 
        tNOVA.notify("~r~Cannot change deathsound, not a valid NOVA Plat subscriber.")
    end 
end
function tNOVA.getDeathSound()
    if tNOVA.isPlusClub() or tNOVA.isPlatClub() then 
        local k=GetResourceKvpString("nova_deathsound")
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
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Manage Subscription","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","managesubscription"))
            if tNOVA.isPlusClub() or tNOVA.isPlatClub()then 
                RageUI.Button("Manage Perks","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageperks"))
            end
            if tNOVA.isDeveloper(tNOVA.getUserId()) then
                RageUI.Button("Manage User's Subscription","",{RightLabel="→→→"},true,function(o,p,q)
                end,RMenu:Get("vipclubmenu","manageusersubscription"))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'managesubscription')) then
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
                    TriggerServerEvent("NOVA:beginSellSubscriptionToPlayer","Plus")
                end 
            end)
            RageUI.Button("Sell Platinum Subscription days.","~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("NOVA:beginSellSubscriptionToPlayer","Platinum")
                end 
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageusersubscription')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tNOVA.isDeveloper(tNOVA.getUserId()) then
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
                            TriggerServerEvent("NOVA:setPlayerSubscription", z.userid, "Plus")
                        end
                    end)
                    RageUI.Button("Set Platinum Days (in hours)","This has to be set in hours.",{RightLabel="→→→"},true,function(o,p,q)
                        if q then
                            TriggerServerEvent("NOVA:setPlayerSubscription", z.userid, "Platinum")
                        end
                    end)    
                else
                    RageUI.Separator('Please select a Perm ID')
                end
                RageUI.Button("Select Perm ID", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        permID = KeyboardInput("Enter Perm ID", "", 10)
                        if permID == nil then 
                            tNOVA.notify('~r~Invalid Perm ID')
                        end
                        TriggerServerEvent('NOVA:getPlayerSubscription', permID)
                    end
                end, RMenu:Get("vipclubmenu", 'manageusersubscription'))
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'manageperks')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Custom Death Sounds","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","deathsounds"))
            RageUI.Button("Vehicle Extras","",{RightLabel="→→→"},true,function(o,p,q)
            end,RMenu:Get("vipclubmenu","vehicleextras"))
            RageUI.Button("Claim Weekly Kit","",{RightLabel="→→→"},true,function(o,p,q)
                if q then 
                    TriggerServerEvent("NOVA:claimWeeklyKit")
                end 
            end)
            local function R()
                E=true
                tNOVA.setparachutestting(E)
                tNOVA.notify("~a~Parachute enabled.")
            end
            local function S()
                E=false
                tNOVA.setparachutestting(E)
                tNOVA.notify("~r~Parachute disabled.")
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
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'deathsounds')) then
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
                            tNOVA.setDeathSound(l.soundId)
                        end
                    end
                    l.checked = Checked
                end)
            end 
        end)
    end
    if RageUI.Visible(RMenu:Get('vipclubmenu', 'vehicleextras')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            local w=getPlayerVehicle()
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

RegisterNetEvent("NOVA:setVIPClubData",function(y,z)
    a.hoursOfPlus=y
    a.hoursOfPlatinum=z 
end)

RegisterNetEvent("NOVA:reducePlusMembershipHour",function()
    a.hoursOfPlus=a.hoursOfPlus-1
    if a.hoursOfPlus<0 then 
        a.hoursOfPlus=0 
    end 
end)

RegisterNetEvent("NOVA:reducePlatMembershipHour",function()
    a.hoursOfPlatinum=a.hoursOfPlatinum-1
    if a.hoursOfPlatinum<0 then 
        a.hoursOfPlatinum=0 
    end 
end)

RegisterNetEvent("NOVA:getUsersSubscription",function(userid, plussub, platsub)
    z.userid = userid
    z.hoursOfPlus=plussub
    z.hoursOfPlatinum=platsub
    RMenu:Get("vipclubmenu", 'manageusersubscription')
end)

RegisterNetEvent("NOVA:userSubscriptionUpdated",function()
    TriggerServerEvent('NOVA:getPlayerSubscription', permID)
end)


Citizen.CreateThread(function()
    while true do 
        if tNOVA.isPlusClub() or tNOVA.isPlatClub()then 
            SetVehicleDirtLevel(getPlayerVehicle(),0.0)
        end
        Wait(500)
    end 
end)