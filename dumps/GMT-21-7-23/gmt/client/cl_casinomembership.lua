local a={{pedPosition=vector3(1088.0207519531,221.13066101074,-49.200397491455),pedHeading=175.0,entryPosition=vector3(1088.3181152344,218.88592529297,-50.200374603271)}}
RMenu.Add('gmthighrollers','casino',RageUI.CreateMenu("","",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight(),"shopui_title_casino","shopui_title_casino"))
RMenu:Get('gmthighrollers','casino'):SetSubtitle("MEMBERSHIP")
RMenu.Add('gmthighrollers','confirmadd',RageUI.CreateSubMenu(RMenu:Get('gmthighrollers','casino'),"","~b~Are you sure?",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight()))
RMenu.Add('gmthighrollers','confirmremove',RageUI.CreateSubMenu(RMenu:Get('gmthighrollers','casino'),"","~b~Are you sure?",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight()))
RMenu.Add("gmthighrollers","confirmban",RageUI.CreateSubMenu(RMenu:Get("gmthighrollers", "casino"),"","~b~Are you sure?",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight()))
RMenu.Add("gmthighrollers","casinostats",RageUI.CreateSubMenu(RMenu:Get("gmthighrollers", "casino"),"","~b~Casino Stats",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('gmthighrollers', 'casino')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Purchase High Rollers Membership (£10,000,000)","~g~Allows you to sit at High-Rollers only seats.",{RightLabel="→→→"},true,function(b,c,d)
            end,RMenu:Get('gmthighrollers','confirmadd'))
            RageUI.ButtonWithStyle("Remove High Rollers Membership (£0)","~r~This is an irrevocable action, you will not receive any money in return.",{RightLabel="→→→"},true,function(b,c,d)
            end,RMenu:Get('gmthighrollers','confirmremove'))
            RageUI.ButtonWithStyle("Casino Self Ban","~r~This is an irrevocable action.",{RightLabel = "→→→"},true,function(c, d, e)
            end,RMenu:Get("gmthighrollers", "confirmban"))
            RageUI.ButtonWithStyle("View Casino Stats","~b~Your bet history throughout GMT.",{RightLabel = "→→→"},true,function(c, d, e)
                if e then
                    TriggerServerEvent("GMT:getCasinoStats")
                end
            end,RMenu:Get("gmthighrollers", "casinostats"))
        end,
        function()
    end)
    if RageUI.Visible(RMenu:Get('gmthighrollers', 'confirmadd')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("No","",{RightLabel="→→→"},true,function(b,c,d)
                if d then 
                    tGMT.notify("~y~Cancelled!")
                end 
            end,RMenu:Get('gmthighrollers','casino'))
            RageUI.ButtonWithStyle("Yes","",{RightLabel="→→→"},true,function(b,c,d)
                if d then 
                    TriggerServerEvent("GMT:purchaseHighRollersMembership")
                end 
            end,RMenu:Get('gmthighrollers','casino'))
        end)
    end
    if RageUI.Visible(RMenu:Get('gmthighrollers', 'confirmremove')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("No","",{RightLabel="→→→"},true,function(b,c,d)
                if d then 
                    tGMT.notify("~y~Cancelled!")
                end 
            end,RMenu:Get('gmthighrollers','casino'))
            RageUI.ButtonWithStyle("Yes","",{RightLabel="→→→"},true,function(b,c,d)
                if d then 
                    TriggerServerEvent("GMT:removeHighRollersMembership")
                end 
            end,RMenu:Get('gmthighrollers','casino'))
        end,function()
        end)
        RageUI.IsVisible(RMenu:Get("gmthighrollers", "confirmremove"),true,true,true,function()
            RageUI.ButtonWithStyle("No","",{RightLabel = "→→→"},true,function(c, d, e)
                    if e then
                        tGMT.notify("~y~Cancelled!")
                    end
                end,RMenu:Get("gmthighrollers", "casino"))
                RageUI.ButtonWithStyle("Yes","",{RightLabel = "→→→"},true,function(c, d, e)
                    if e then
                        TriggerServerEvent("GMT:removeHighRollersMembership")
                    end
                end,RMenu:Get("gmthighrollers", "casino"))
            end,function()
            end)
            RageUI.IsVisible(RMenu:Get("gmthighrollers", "confirmban"),true,true,true,function()
                RageUI.ButtonWithStyle("No","",{RightLabel = "→→→"},true,function(c, d, e)
                    if e then
                        tGMT.notify("~y~Cancelled!")
                    end
                end,RMenu:Get("gmthighrollers", "casino"))
                RageUI.ButtonWithStyle("Yes","",{RightLabel = "→→→"},true,function(c, d, e)
                        if e then
                        tGMT.casinoBan(true)
                        tGMT.notify("~g~You have been successfully self-banned from the casino.")
                    end
                end,RMenu:Get("gmthighrollers", "casino"))
            end,function()
            end)
            RageUI.IsVisible(RMenu:Get("gmthighrollers", "casinostats"),true,true,true,function()
                if next(b) then
                    for f, g in pairs(b) do
                        RageUI.Separator(g)
                    end
                else
                    RageUI.Separator("~r~You have no casino stats to display.")
                end
                RageUI.ButtonWithStyle("Back","",{RightLabel = "→→→"},true,function(c, d, e)
                end,RMenu:Get("gmthighrollers", "casino"))
            end,function()
            end)
        end
    end
end)
RegisterNetEvent("GMT:setCasinoStats")
AddEventHandler("GMT:setCasinoStats",function(h)
    b = h
end)
function showCasinoMembership(e)
    RageUI.Visible(RMenu:Get('gmthighrollers','casino'),e)
end
Citizen.CreateThread(function()
    local f="mini@strip_club@idles@bouncer@base"
    RequestAnimDict(f)
    while not HasAnimDictLoaded(f)do 
        RequestAnimDict(f)
        Wait(0)
    end
    for g,h in pairs(a)do 
        local i=tGMT.loadModel('u_f_m_casinocash_01')
        local j=CreatePed(26,i,h.pedPosition.x,h.pedPosition.y,h.pedPosition.z,175.0,false,true)
        SetModelAsNoLongerNeeded(i)
        SetEntityCanBeDamaged(j,0)
        SetPedAsEnemy(j,0)
        SetBlockingOfNonTemporaryEvents(j,1)
        SetPedResetFlag(j,249,1)
        SetPedConfigFlag(j,185,true)
        SetPedConfigFlag(j,108,true)
        SetPedCanEvasiveDive(j,0)
        SetPedCanRagdollFromPlayerImpact(j,0)
        SetPedConfigFlag(j,208,true)
        SetEntityCoordsNoOffset(j,h.pedPosition.x,h.pedPosition.y,h.pedPosition.z,175.0,0,0,1)
        SetEntityHeading(j,h.pedHeading)
        FreezeEntityPosition(j,true)
        TaskPlayAnim(j,f,"base",8.0,0.0,-1,1,0,0,0,0)
        RemoveAnimDict(f)
    end 
end)
AddEventHandler("GMT:onClientSpawn",function(D, E)
    if E then
		local m=function(n)
            showCasinoMembership(true)
        end
        local o=function(n)
            showCasinoMembership(false)
        end
        local p=function(n)
        end
        for q,h in pairs(a)do 
            tGMT.addBlip(h.entryPosition.x,h.entryPosition.y,h.entryPosition.z,682,0,"Casino Memberships",0.7,true)
            tGMT.addMarker(h.entryPosition.x,h.entryPosition.y,h.entryPosition.z,1.0,1.0,1.0,138,43,226,70,50,27)
            tGMT.createArea("casinomembership_"..q,h.entryPosition,1.5,6,m,o,p,{})
        end 
	end
end)
function tGMT.casinoBan(v)
    if v then
        SetResourceKvp("gmt_casino_banned", "true")
    else
        SetResourceKvp("gmt_casino_banned", "false")
    end
end