RMenu.Add('MainMenu', 'main', RageUI.CreateMenu("", "~b~DM Main Menu", 1300,100, "", ""))
RMenu.Add('MainMenu', 'Weapons',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "main")))
RMenu.Add('MainMenu', 'Teleport',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "main")))
RMenu.Add('MainMenu', 'Settings',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "main")))
RMenu.Add('MainMenu', 'League',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "main")))

-- Weapons Submenu's
RMenu.Add('MainMenu', 'Pistols',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "Weapons")))
RMenu.Add('MainMenu', 'Shotguns',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "Weapons")))
RMenu.Add('MainMenu', 'SMGs',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "Weapons")))
RMenu.Add('MainMenu', 'AssaultRifles',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "Weapons")))
RMenu.Add('MainMenu', 'SniperRifles',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "Weapons")))

RMenu.Add('MainMenu', 'Normal',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "Weapons")))
RMenu.Add('MainMenu', 'MK2',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "Weapons")))

-- Team Locations
RMenu.Add('MainMenu', 'TeamLocations',  RageUI.CreateSubMenu(RMenu:Get("MainMenu", "Teleport")))

ActiveWeapon = {}
ActiveLocation = {}
SelectedZone = "N/A"



League_Queue = {}
League_Mosin = false
League_AK_200 = false
LeagueAP_Pistol = false
LeagueCombat_Pistol = false
League_M60 = false
League_Special_Carbine = false 
Queued_For_Selected_League = 0
SelectedLeagueWeapon = ""
Player_Elo = 0
HudActive = false
Hitsounds = false



hitsounds_Index = {
    ["Fortnite"] = {"fortnite", "fortniteheadshot"},
    ["Rust"] = {"rust", "rustheadshot"},
    ["Call Of Duty"] = {"cod", "codheadshot"},
}

hitsounds = {"Rust", "Fortnite", "Call Of Duty"}
Index = 1

local locationPlayers = 0
local HoveredLocation = vector3(0,0,0)
Citizen.CreateThread(function()
    while true do
        local x = GetActivePlayers()
        for i,o in pairs(x) do
            local ped = GetPlayerPed(o)
            local coords = GetEntityCoords(ped)
            if #(HoveredLocation - coords) < 150 then
                locationPlayers = locationPlayers + 1
            end
        end
        Citizen.Wait(1)
        locationPlayers = 0
    end
end)

function ResetLeagueChoice()
    League_Mosin = false
    League_AK_200 = false
    LeagueAP_Pistol = false
    LeagueCombat_Pistol = false
    League_M60 = false
    League_Special_Carbine = false
end

local WeaponList = {
    {Name = "Glock 17", SpawnCode = "WEAPON_GLOCK17DM"}, -- Done
    {Name = "M1911", SpawnCode = "WEAPON_M1911DM"}, -- Done
    {Name = "Winchester 12", SpawnCode = "WEAPON_WINCHESTER12DM"}, -- Done
    {Name = "UMP-45", SpawnCode = "WEAPON_UMP45DM"}, -- Done
    {Name = "UZI", SpawnCode = "WEAPON_UZIDM"}, -- Done
    {Name = "MP5", SpawnCode = "WEAPON_MP5DM"}, -- Done
    {Name = "AK-200", SpawnCode = "WEAPON_AK200DM"}, -- Done
    {Name = "AK-74 Gold", SpawnCode = "WEAPON_AK74GOLDDM"}, -- Done
    {Name = "AK-74", SpawnCode = "WEAPON_AK74DM"}, -- Done
    {Name = "Anarchy LR-300", SpawnCode = "WEAPON_ANARCHYLR300DM"}, -- Done 
    {Name = "HK-416", SpawnCode = "WEAPON_HK416DM"}, -- Done 
    {Name = "M16A4", SpawnCode = "WEAPON_M16A4DM"}, -- Done 
    {Name = "M16-SP1", SpawnCode = "WEAPON_SP1DM"}, -- Done 
    {Name = "SIG-516", SpawnCode = "WEAPON_SIG516DM"}, -- Done 
    {Name = "Spar-16", SpawnCode = "WEAPON_SPAR16DM"}, -- Done
    {Name = "Mosin Nagant", SpawnCode = "WEAPON_MOSINNAGANTDM"}, -- Done
}

RageUI.CreateWhile(1.0,RMenu:Get("MainMenu", "main"),nil,function()
    RageUI.IsVisible(RMenu:Get("MainMenu", "main"),true, false,true,function()
        RageUI.ButtonWithStyle("Weapons", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('MainMenu', 'Weapons'))
        RageUI.ButtonWithStyle("Teleport", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('MainMenu', 'Teleport'))
        RageUI.ButtonWithStyle("League [~y~Coming Soon~w~]", "~r~Compete against players with a similar skill group as you! Coming Soon!", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then 
            end
        end)
        RageUI.ButtonWithStyle("Settings", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('MainMenu', 'Settings'))
        

        RageUI.ButtonWithStyle("~r~Suicide", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                SetEntityHealth(PlayerPedId(), 0)
            end
        end)
    end)

    RageUI.IsVisible(RMenu:Get("MainMenu", "League"),true, false,true,function()
        if SelectedZone == "Casual" then
            local function MosinTrue()
                ResetLeagueChoice()
                League_Mosin = true
                SelectedLeagueWeapon = "Mosin"
            end
            local function MosinFalse()
                ResetLeagueChoice()
                League_Mosin = false
                SelectedLeagueWeapon = ""
            end
            RageUI.Checkbox("Mosin", "~y~Select Mosin ONLY League Lobbies", League_Mosin, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
            end, MosinTrue, MosinFalse)

            local function AK_200True()
                ResetLeagueChoice()
                League_AK_200 = true
                SelectedLeagueWeapon = "AK_200"
            end
            local function AK_200False()
                ResetLeagueChoice()
                League_AK_200 = false
                SelectedLeagueWeapon = ""
            end
            RageUI.Checkbox("AK-200", "~y~Select AK-200 ONLY League Lobbies", League_AK_200, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
            end, AK_200True, AK_200False)
        end


        RageUI.Separator("Your Elo: " .. Player_Elo, function() end)
        RageUI.Separator("Current Players Queued: " .. Queued_For_Selected_League, function() end)

        RageUI.ButtonWithStyle("Queue", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                if SelectedZone == "Casual" then
                    if not League_AK_200 and not League_Mosin then
                        Draw_Native_Notify("~r~You haven't selected a specified weapon for league!")
                    else
                        TriggerServerEvent("QueuePlayerForSelectedLeague", SelectedZone, SelectedLeagueWeapon)
                    end
                elseif SelectedZone == "American" then
                    if not League_AP_Pistol and not League_Combat_Pistol then
                        Draw_Native_Notify("~r~You haven't selected a specified weapon for league!")
                    else
                        TriggerServerEvent("QueuePlayerForSelectedLeague", SelectedZone, SelectedLeagueWeapon)
                    end
                end
            end
        end, RMenu:Get('MainMenu', 'League'))
    end)

    RageUI.IsVisible(RMenu:Get("MainMenu", "Weapons"),true, false,true,function()
        if SelectedZone == "Casual" then
            RageUI.ButtonWithStyle("Pistols", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('MainMenu', 'Pistols'))
            RageUI.ButtonWithStyle("Shotguns", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('MainMenu', 'Shotguns'))
            RageUI.ButtonWithStyle("SMGs", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('MainMenu', 'SMGs'))
            RageUI.ButtonWithStyle("Assault Rifles", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('MainMenu', 'AssaultRifles'))
            RageUI.ButtonWithStyle("Sniper Rifles", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('MainMenu', 'SniperRifles'))

            RageUI.ButtonWithStyle("~r~Random Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    ActiveWeapon = {
                        Name = "Random Weapon",
                        SpawnCode = "RandomWep",
                    }
                    RandomNum = math.random(1, #WeaponList)
                    GiveWeaponToPed(PlayerPedId(), WeaponList[RandomNum]["SpawnCode"], globalWeaponList[WeaponList[RandomNum]["SpawnCode"]][4], false, true)
                    Draw_Native_Notify("Recieved ~g~"..WeaponList[RandomNum]["Name"])
                end
            end)
        elseif SelectedZone == "American" then
            for k,v in pairs(ConfigMain.Weapons.American) do
                RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RemoveAllPedWeapons(PlayerPedId(), true)
                        ActiveWeapon = {}
                        GiveWeaponToPed(PlayerPedId(), v.SpawnCode, globalWeaponList[v.SpawnCode][4], false, true)
                        ActiveWeapon = {
                            Name = v.Name,
                            SpawnCode = v.SpawnCode,
                        }
                    end
                end)
            end
        elseif SelectedZone == "Glife" then
            RageUI.ButtonWithStyle("Normal Weapons", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('MainMenu', 'Normal'))
            RageUI.ButtonWithStyle("MK2 Weapons", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('MainMenu', 'MK2'))
        end
    end)


    RageUI.IsVisible(RMenu:Get("MainMenu", "Normal"),true, false,true,function()
        for k,v in pairs(ConfigMain.Weapons.GLife.Normal) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, globalWeaponList[v.SpawnCode][4], false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("MainMenu", "MK2"),true, false,true,function()
        for k,v in pairs(ConfigMain.Weapons.GLife.MK2) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, globalWeaponList[v.SpawnCode][4], false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)


    RageUI.IsVisible(RMenu:Get("MainMenu", "Pistols"),true, false,true,function()
        for k,v in pairs(ConfigMain.Weapons.Pistols) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, globalWeaponList[v.SpawnCode][4], false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("MainMenu", "Shotguns"),true, false,true,function()
        for k,v in pairs(ConfigMain.Weapons.Shotguns) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, globalWeaponList[v.SpawnCode][4], false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("MainMenu", "SMGs"),true, false,true,function()
        for k,v in pairs(ConfigMain.Weapons.SMGs) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, globalWeaponList[v.SpawnCode][4], false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("MainMenu", "AssaultRifles"),true, false,true,function()
        for k,v in pairs(ConfigMain.Weapons.AssaultRifles) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, globalWeaponList[v.SpawnCode][4], false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("MainMenu", "SniperRifles"),true, false,true,function()
        for k,v in pairs(ConfigMain.Weapons.SniperRifles) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, globalWeaponList[v.SpawnCode][4], false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    if SelectedZone ~= "GunGame" then
        RageUI.IsVisible(RMenu:Get("MainMenu", "Teleport"),true, false,true,function()
            if SelectedZone == "Glife" then
                for k,v in pairs(ConfigMain.Teleport.GLife) do
                    RageUI.ButtonWithStyle(v.Name, "There are " ..locationPlayers.. " Players @ " ..v.Name, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Active then
                            HoveredLocation = v.Center
                        end
                        if Selected then
                            ActiveLocation = {}
                            ActiveLocation = {
                                Name = v.Name,
                                SpawnLoc = v.SpawnLocations,
                            }
                            RandomLoc = math.random(1, #ActiveLocation.SpawnLoc)
                            x,y,z = table.unpack(ActiveLocation.SpawnLoc[RandomLoc])
                            SetEntityCoords(PlayerPedId(), x,y,z)

                            TriggerServerEvent("AddPlayerToTeamGame", "Reset")
                        end
                    end)
                end
            elseif SelectedZone == "Casual" then
                RageUI.ButtonWithStyle("~b~Team Locations", "~o~Friendly Fire is Disabled To Prevent Team Killing.b", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end, RMenu:Get('MainMenu', 'TeamLocations'))
                for k,v in pairs(ConfigMain.Teleport.Casual) do
                    RageUI.ButtonWithStyle(v.Name, "There are " ..locationPlayers.. " Players @ " ..v.Name, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Active then
                            HoveredLocation = v.Center
                        end
                        if Selected then
                            ActiveLocation = {}
                            ActiveLocation = {
                                Name = v.Name,
                                SpawnLoc = v.SpawnLocations,
                            }
                            RandomLoc = math.random(1, #ActiveLocation.SpawnLoc)
                            x,y,z = table.unpack(ActiveLocation.SpawnLoc[RandomLoc])
                            SetEntityCoords(PlayerPedId(), x,y,z)

                            TriggerServerEvent("AddPlayerToTeamGame", "Reset")
                        end
                    end)
                end
            elseif SelectedZone == "American" then
                for k,v in pairs(ConfigMain.Teleport.American) do
                    RageUI.ButtonWithStyle(v.Name, "There are " ..locationPlayers.. " Players @ " ..v.Name, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Active then
                            HoveredLocation = v.Center
                        end
                        if Selected then
                            ActiveLocation = {}
                            ActiveLocation = {
                                Name = v.Name,
                                SpawnLoc = v.SpawnLocations,
                            }
                            RandomLoc = math.random(1, #ActiveLocation.SpawnLoc)
                            x,y,z = table.unpack(ActiveLocation.SpawnLoc[RandomLoc])
                            SetEntityCoords(PlayerPedId(), x,y,z)

                            TriggerServerEvent("AddPlayerToTeamGame", "Reset")
                        end
                    end)
                end
            end

            RageUI.ButtonWithStyle("~r~Reset Spawn Location", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    ActiveLocation = {}
                end
            end)
        end)
    end


    RageUI.IsVisible(RMenu:Get("MainMenu", "TeamLocations"),true, false,true,function()
        for k,v in pairs(ConfigMain.Teleport.TeamLocs) do
            RageUI.ButtonWithStyle(v.Name, "Friendly Fire is ~g~Enabled~w~ @ " ..v.Name, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    ActiveLocation = {}
                    ActiveLocation = {
                        Name = v.Name,
                        SpawnLoc = v.SpawnLocations,
                    }
                    RandomLoc = math.random(1, #ActiveLocation.SpawnLoc)
                    x,y,z = table.unpack(ActiveLocation.SpawnLoc[RandomLoc])
                    SetEntityCoords(PlayerPedId(), x,y,z)

                    TriggerServerEvent("AddPlayerToTeamGame", v.Location, v.Team)
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("MainMenu", "Settings"),true, false,true,function()
        RageUI.List("Render Distance", ConfigMain.Settings.Distances, ConfigMain.Settings.DistanceIndex, "~y~Change render distance, lowering this will increase FPS.", {}, true, function(Hovered, Active, Selected, Index)
            ConfigMain.Settings.DistanceIndex = Index
        end)

        local function ToggleUI()
            if HudActive then
                HudActive = false
            else
                HudActive = true
            end
        end
        RageUI.Checkbox("HUD", "~g~Toggle HUD On/Off", HudActive, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Select, Checked)
        end, ToggleUI, ToggleUI)

        RageUI.List("Weather", ConfigMain.Settings.Weather, ConfigMain.Settings.WeatherIndex, "~g~Change your clients weather.", {}, true, function(Hovered, Active, Selected, Index)
            ConfigMain.Settings.WeatherIndex = Index
        end)

        -- local function HsToggle()
        --     if Hitsounds then
        --         Hitsounds = false
        --         TriggerEvent("SetHitSounds", false)
        --         Draw_Native_Notify("~y~Rust hitsounds disabled.")
        --     else
        --         Hitsounds = true
        --         TriggerEvent("SetHitSounds", true)
        --         Draw_Native_Notify("~y~Rust hitsounds enabled.")
        --     end
        -- end
        -- RageUI.Checkbox("Hitsounds", "~y~Enable/Disable rust hitsounds.", Hitsounds, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
        -- end, HsToggle, HsToggle)

        local function ToggleHSTrue()
            Hitsounds = true
            Draw_Native_Notify("Hitsounds ~g~Enabled~w~, remember to select hitsound ~y~below~w~.")
        end
        local function ToggleHSFalse()
            Hitsounds = false
            Draw_Native_Notify("Hitsounds ~r~Disabled")
        end
        RageUI.Checkbox("Hitsounds","~w~Toggle your hitsounds!", Hitsounds, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
        end, ToggleHSTrue, ToggleHSFalse)

        if Hitsounds then
            RageUI.List("Sound", hitsounds, Index, "~g~Press enter to select hitsound", {}, true, function(a,b,Selected, Idex)
                if Selected then
                    TriggerEvent("SetHitSounds", hitsounds[Index])
                    Draw_Native_Notify("Hitsounds set to ~g~" ..hitsounds[Index])
                end
    
                Index = Idex
            end)
        end

        local function ToggleKDR()
            if KDR then
                KDR = false
            else
                KDR = true
            end
        end
        RageUI.Checkbox("KDR", "~g~Toggle KDR On/Off", KDR, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Select, Checked)
        end, ToggleKDR, ToggleKDR)

    end)
end)


RegisterCommand("main-menu", function()
    if SelectedZone ~= "gunGame" then
        RageUI.Visible(RMenu:Get('MainMenu', 'main'), not RageUI.Visible(RMenu:Get('MainMenu', 'main')))
    elseif SelectedZone == "gunGame" then
        RageUI.Visible(RMenu:Get('settingz', 'main'), not RageUI.Visible(RMenu:Get('settingz', 'main')))
    end
end)

RegisterKeyMapping("main-menu","Opens Main Weapons / Teleport Menu", "keyboard", "F1")



function GetLocalHitsounds()
    return Hitsounds
end

function RespawnPlayer()
    if ActiveWeapon.Name ~= nil then
        if ActiveWeapon.Name ~= "Random Weapon" then
            GiveWeaponToPed(PlayerPedId(), ActiveWeapon.SpawnCode, globalWeaponList[ActiveWeapon.SpawnCode][4], false, true)
        else
            RandomNum = math.random(1, #WeaponList)
            GiveWeaponToPed(PlayerPedId(), WeaponList[RandomNum]["SpawnCode"], globalWeaponList[WeaponList[RandomNum]["SpawnCode"]][4], false, true)
            Draw_Native_Notify("Recieved ~g~"..WeaponList[RandomNum]["Name"])
        end
    end
end

function SetLocation()
    if ActiveLocation.Name ~= nil then
        RandomLoc = math.random(1, #ActiveLocation.SpawnLoc)
        x,y,z = table.unpack(ActiveLocation.SpawnLoc[RandomLoc])
        SetEntityCoords(PlayerPedId(), x,y,z)
    else
        if SelectedZone == "American" then
            SetEntityCoords(PlayerPedId(), -958.4753, 927.0952, 572.317)
        elseif SelectedZone == "GLife" then
            SetEntityCoords(PlayerPedId(), 1534.709, 1702.526, 109.7114)
        end
    end
end


RegisterNetEvent("SetSelectedZone")
AddEventHandler("SetSelectedZone", function(Str)
    SelectedZone = tostring(Str)
    currentGameStarting = false
end)


RegisterNetEvent("SendQueuedPlayers")
AddEventHandler("SendQueuedPlayers", function(Queue)
    League_Queue = Queue
end)

RegisterNetEvent("ResetElements")
AddEventHandler("ResetElements", function()
    ActiveWeapon = {}
    ActiveLocation = {}
end)




function DMclient.GetGameModeType(Type)
    if Type == SelectedZone then
        return true
    else
        return false
    end
end













function getCamDirection()
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


