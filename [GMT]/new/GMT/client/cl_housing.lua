local Housing = module("cfg/cfg_housing")
local isInMenu = false
local isInLeaveMenu = false
local isInWardrobeMenu = false
local currentHome = nil
local currentOutfit = nil
local currentHousePrice = 0
local owned = false
wardrobe = {}
ownedHouses = {}

RMenu.Add("GMTHousing", "main", RageUI.CreateMenu("", "", tGMT.getRageUIMenuWidth(), tGMT.getRageUIMenuHeight(),"gmt_homesui","gmt_homesui"))
RMenu.Add("GMTHousing", "leave", RageUI.CreateMenu("", "", tGMT.getRageUIMenuWidth(), tGMT.getRageUIMenuHeight(),"gmt_homesui","gmt_homesui"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('GMTHousing', 'main')) then
        maxKG = Housing.chestsize[currentHome] or 500
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator('Price: ~g~£'..getMoneyStringFormatted(currentHousePrice))
            RageUI.Separator('Storage: ~g~'..maxKG..'kg')
            RageUI.Button("Enter House", "Enter this home", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("GMTHousing:Enter", currentHome)
                end
            end)
            if owned ~= true then
                RageUI.Button("Buy Home", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("GMTHousing:Buy", currentHome)
                    end
                end)
            end
            RageUI.Button("Sell House to Player", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("GMTHousing:Sell", currentHome)
                end
            end)
            RageUI.Button("Rent House to Player", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("GMTHousing:Rent", currentHome)
                end
            end)
            RageUI.Button("House Robbery","~r~Break into this house", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected and not tGMT.inEvent() then
                    tGMT.notify("~r~This feature is currently disabled.")
                end
            end)
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('GMTHousing', 'leave')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Leave Home", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("GMTHousing:Leave", currentHome)
                end
            end)
        end, function()
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not HasStreamedTextureDictLoaded("clothing") then
            RequestStreamedTextureDict("clothing", true)
            while not HasStreamedTextureDictLoaded("clothing") do
                Wait(1)
            end
        end
        for k, v in pairs(cfghomes.homes) do
            if isInArea(v.entry_point, 100) then
                DrawMarker(20, v.entry_point, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 25, 100, false, true, 2, false)
            end
            if isInArea(v.entry_point, 0.8) and isInMenu == false then 
                currentHome = k
                currentHousePrice = v.buy_price
                RMenu:Get("GMTHousing", "main"):SetSubtitle("" .. currentHome)
                RageUI.Visible(RMenu:Get("GMTHousing", "main"), true)
                isInMenu = true
            end
            if isInArea(v.entry_point, 0.8) == false and isInMenu and currentHome == k then
                RageUI.Visible(RMenu:Get("GMTHousing", "main"), false)
                isInMenu = false
            end
            if currentHome == k then
                -- Storage
                if tGMT.isInHouse() then
                    DrawMarker(9, v.chest_point, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.8, 0.8, 0.8, 224, 224, 244, 1.0, false, false, 2, true, "dp_clothing", "bag", false)
                end
                if isInArea(v.chest_point, 0.8) and tGMT.isInHouse() then
                    alert("Press ~INPUT_VEH_HORN~ To Open House Chest!")
                    if IsControlJustPressed(0, 51) then
                        TriggerServerEvent('GMT:FetchPersonalInventory')
                        inventoryType = 'Housing'
                        TriggerServerEvent('GMT:FetchHouseInventory', currentHome)
                    end
                end
                -- Wardrobe
                if tGMT.isInHouse() then
                    --tGMT.addMarker(v.wardrobe_point.x,v.wardrobe_point.y,v.wardrobe_point.z,0.6,0.6,0.6,10,255,81,170,50,9,false,false,true,"dp_clothing","top",90.0,90.0,0.0)
                    DrawMarker(9, v.wardrobe_point, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 0, 255, 60, false, true, 2, false, "clothing", "clothing", false)
                end
                if isInArea(v.wardrobe_point, 0.8) and isInWardrobeMenu == false and tGMT.isInHouse() then
                    currentHome = k
                    TriggerEvent('GMT:openOutfitMenu')
                    isInWardrobeMenu = true
                end
                if isInArea(v.wardrobe_point, 0.8) == false and isInWardrobeMenu and currentHome == k and tGMT.isInHouse() then
                    TriggerEvent('GMT:closeOutfitMenu')
                    isInWardrobeMenu = false
                end
                -- Leave House
                if tGMT.isInHouse() then
                    DrawMarker(20, v.leave_point, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 25, 100, false, true, 2, false)
                end
                if isInArea(v.leave_point, 0.8) and isInLeaveMenu == false and tGMT.isInHouse() then
                    currentHome = k
                    RMenu:Get("GMTHousing", "leave"):SetSubtitle("" .. currentHome)
                    RageUI.Visible(RMenu:Get("GMTHousing", "leave"), true)
                    isInLeaveMenu = true
                end
                if isInArea(v.leave_point, 0.8) == false and isInLeaveMenu and currentHome == k and tGMT.isInHouse() then
                    RageUI.Visible(RMenu:Get("GMTHousing", "leave"), false)
                    isInLeaveMenu = false
                   
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if tGMT.isInHouse() then
        NetworkConcealPlayer(GetPlayerPed(-1), true, false)
    else 
        NetworkConcealPlayer(GetPlayerPed(-1), false, false)
    end
   end
end)


function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function isInArea(v, dis) 
    if #(GetEntityCoords(PlayerPedId()) - v) <= dis then  
        return true
    else 
        return false
    end
end