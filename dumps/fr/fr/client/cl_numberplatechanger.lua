local currentPlate = nil
local carstable = {}
local location = vector3(-585.17864990234,-209.28169250488,38.219661712646)
local m = module("fr-vehicles", "cfg/cfg_garages")
m=m.garages

RMenu.Add('plateshop', 'main', RageUI.CreateMenu("", "DVLA", 1350, 50, "fr_licenseplateui", "fr_licenseplateui"))
RMenu.Add("plateshop", "ownedvehicles", RageUI.CreateSubMenu(RMenu:Get("plateshop", "main"), "", "Owned Vehicles", 1350, 50))
RMenu.Add("plateshop", "changeplate", RageUI.CreateSubMenu(RMenu:Get("plateshop", "ownedvehicles"), "", "Plate management", 1350, 50))
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('plateshop', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.ButtonWithStyle("Owned Vehicles", "View your owned vehicles", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get("plateshop", "ownedvehicles"))
            RageUI.ButtonWithStyle("Check Plate Availability", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local u = GetLicensePlateString()
                    if u ~= "" then
                        TriggerServerEvent("FR:checkPlateAvailability", u)
                    end
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('plateshop', 'ownedvehicles')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if next(carstable) == nil then
                RageUI.Separator('You do not own any vehicles.')
            else
                for i,j in pairs(carstable) do
                    for k,v in pairs(m) do
                        for a,l in pairs(v) do
                            if a ~= "_config" then
                                if a == j[1] then
                                    RageUI.Button(""..l[1], '~g~Spawncode: ~w~'..j[1]..' - ~g~Current Plate ~w~'..j[2], "", true,function(Hovered, Active, Selected)
                                        if Selected then
                                            selectedCar = j[1]
                                            selectedCarName = l[1]
                                        end
                                    end, RMenu:Get("plateshop", "changeplate"))
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('plateshop', 'changeplate')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Button("Change Number Plate", "~g~Changing plate of "..selectedCarName, {RightLabel = "~g~£500,000"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("FR:ChangeNumberPlate", selectedCar)
                end
            end)
        end)
    end
end)
AddEventHandler("FR:onClientSpawn",function(h, i)
    if i then
        local j = function(k)
        end
        local l = function(k)
            RageUI.ActuallyCloseAll()
            RageUI.Visible(RMenu:Get("plateshop", "main"), false)
        end
        local m = function(k)
            if IsControlJustPressed(1, 38) then
                TriggerServerEvent('FR:getCars')
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("plateshop", "main"), not RageUI.Visible(RMenu:Get("plateshop", "main")))
            end
            tFR.DrawText3D(location, "Press [E] to open License Plate Management", 0.4)
        end
        tFR.createArea("licenseplate", location, 1.5, 6, j, l, m, {})
        tFR.addMarker(location.x, location.y, location.z - 1, 1.0, 1.0, 1.0, 255, 0, 0, 170, 50, 27)
        tFR.addBlip(location.x, location.y, location.z, 606, 2, "Licence Plate Manager")
    end
end)


RegisterNetEvent("FR:RecieveNumberPlate")
AddEventHandler("FR:RecieveNumberPlate", function(numplate)
    currentPlate = numplate
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("plateshop", "main"), true)
    TriggerServerEvent('FR:getCars')
end)

RegisterNetEvent("FR:carsTable")
AddEventHandler("FR:carsTable",function(cars)
    carstable = cars
end)

function GetLicensePlateString()
    AddTextEntry("FMMC_MPM_NA", "Enter text:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local A = GetOnscreenKeyboardResult()
        return A
    end
    return ""
end