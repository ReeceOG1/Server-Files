local currentAmmunition = nil
local currentGunHash = nil
local currentGunPrice = nil
local currentGunName = nil
local currentGunHash1 = nil
local currentGunPrice1 = nil
local currentGunName1 = nil
returnedPDGuns3 = {}

RMenu.Add('policeadvlarge', 'main', RageUI.CreateMenu("", "~b~NOVA Police Armoury", 1300, 50, "banners", "police"))
RMenu.Add("policeadvlarge", "sub", RageUI.CreateSubMenu(RMenu:Get("policeadvlarge", "main"), "", "~b~NOVA Police Armoury", 1300, 50, "banners", "police"))
RMenu.Add("policeadvlarge", "whitelistedguns", RageUI.CreateSubMenu(RMenu:Get("policelarge", "main"), "", "~b~NOVA Police Armoury", 1300, 50, "banners", "police"))
RageUI.CreateWhile(1.0, RMenu:Get('policeadvlarge', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('policeadvlarge', 'main'), true, false, true, function()
        for i , p in pairs(policeadvlarge.guns) do 
            RageUI.Button(p.name , nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if Active then
                    currentGunHash = nil
                end
                if Selected then
                    currentGunHash = p.hash
                    currentGunPrice = p.price
                    currentGunName = p.name
                end
            end, RMenu:Get("policeadvlarge", "sub"))  
        end
        for i , w in pairs(returnedPDGuns3) do 
            RageUI.Button(w.name , nil, {RightLabel = '→→→'}, true, function(Hovered, Active, Selected)
                if Active then
                    currentGunHash1 = nil
                end
                if Selected then
                    currentGunHash1 = w.gunhash
                    currentGunPrice1 = w.price
                    currentGunName1 = w.name
                end
            end, RMenu:Get("policeadvlarge", "whitelistedguns"))
        end
    end, function()
    end)
    RageUI.IsVisible(RMenu:Get("policeadvlarge", "sub"), true, false, true, function()
        RageUI.Button("Purchase Weapon Body" , "Purchase "..currentGunName.." and Max Ammo", { RightLabel = "~g~£"..tostring(getMoneyStringFormatted(currentGunPrice)) }, true, function(Hovered, Active, Selected)
            if Selected then
                local Ped = PlayerPedId()
                if HasPedGotWeapon(Ped, currentGunHash, false) then
                    notify("~r~You already have this weapon equipped.")
                else
                TriggerServerEvent("policeadvlarge:BuyWeapon", currentGunHash)
                end
            end
        end)
    
        RageUI.Button("Buy Max Ammo", "Purchase Max Ammo for "..currentGunName, {  RightLabel = "~g~£"..tostring(getMoneyStringFormatted(math.floor(currentGunPrice / 2))) }, true, function(Hovered, Active, Selected)
            --RageUI.Button("Buy Max Ammo", "Purchase Max Ammo for "..currentGunName, { RightLabel = "~g~£"..tostring(getMoneyStringFormatted(math.floor(currentGunPrice / 2))) }, true, function(Hovered, Active, Selected)v
            if Selected then
                TriggerServerEvent("policeadvlarge:BuyWeaponAmmo", currentGunHash)
            end
        end)
    end, function()
    end)
    
    RageUI.IsVisible(RMenu:Get("policeadvlarge", "whitelistedguns"), true, false, true, function()
        RageUI.Button("Purchase Weapon Body" , "Purchase "..currentGunName1.." and Max Ammo", {  RightLabel = "~g~£"..tostring(getMoneyStringFormatted(currentGunPrice1)) }, true, function(Hovered, Active, Selected)
            if Selected then
                local Ped = PlayerPedId()
                if HasPedGotWeapon(Ped, currentGunHash1, false) then
                    notify("~r~You already have this weapon equipped.")
                else
                TriggerServerEvent("policeadvlarge:BuyWLWeapon", currentGunHash1)
                end
            end
        end)
    
        RageUI.Button("Buy Max Ammo", "Purchase Max Ammo for "..currentGunName1, {  RightLabel = "~g~£"..tostring(getMoneyStringFormatted(currentGunPrice1 / 2)) }, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("policeadvlarge:BuyWLWeaponAmmo", currentGunHash1)
                 end
             end)
        end, function()
    end)
end)

RegisterNetEvent("PDADVLARGE:GUNSRETURNED")
AddEventHandler("PDADVLARGE:GUNSRETURNED", function(table)
    returnedPDGuns2 = table 
end)

RegisterNetEvent('policeadvlarge:Error')
AddEventHandler('policeadvlarge:Error', function()
    RageUI.Visible(RMenu:Get("policeadvlarge", "main"))
    alert('~r~Insufficent funds')
end)


function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end




isInpoliceadvlarge = false
currentAmmunition = nil
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)
        for k, v in pairs(policeadvlarge.gunshops) do 
            if currentGunHash ~= nil or currentGunHash1 ~= nil then
                for k,v in pairs(weaponmodels.models) do 
                    if currentGunHash == v[1] or currentGunHash1 == v[1] then
                        model = k
                    end
                end
                local N=loadModel(model)
                local O=CreateObject(N,v.x,v.y,v.z+0.1,false,false,false)
                while currentGunHash ~= nil or currentGunHash1 ~= nil and DoesEntityExist(O)do 
                    SetEntityHeading(O,GetEntityHeading(O)+1%360)
                    Wait(0)
                end
                DeleteEntity(O)
            end
            if isInArea(v, 500.0) then
                DrawMarker(27, v.x,v.y,v.z- 0.999999, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 0, 170, 255, 250, 0, 0, 2, 0, 0, 0, false)
            end
            if isInpoliceadvlarge == false then
            if isInArea(v, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to access Police Advanced Large Arms Armoury')
                if IsControlJustPressed(0, 51) then 
                    TriggerServerEvent("PDADVLARGE:PULLWHITELISTEDWEAPONS")
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("policeadvlarge", "main"), true)
                    isInpoliceadvlarge = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v, 1.4) == false and isInpolicelarge and k == currentAmmunition then
                RageUI.Visible(RMenu:Get("policeadvlarge", "main"), false)
                RageUI.Visible(RMenu:Get("policeadvlarge", "sub"), false)
                RageUI.Visible(RMenu:Get("policeadvlarge", "whitelistedguns"), false)
                isInpoliceadvlarge = false
                currentAmmunition = nil
            end
        end
    end
end)

RegisterNetEvent("policelarge:GiveWeapon")
AddEventHandler("policelarge:GiveWeapon", function(hash)
    GiveWeaponToPed(PlayerPedId(), hash, 250, false, false, 0)
end)

RegisterNetEvent("policelarge:GiveArmour")
AddEventHandler("policelarge:GiveArmour", function(level) 
    SetPedArmour(PlayerPedId(), level)
end)

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId(-1)) - v) <= dis then  
        return true
    else 
        return false
    end
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end
