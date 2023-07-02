LUNAclient = Tunnel.getInterface("LUNA","LUNA")

local user_id = 0
local cooldown = 0
local foundMatch = false
local inSpectatorAdminMode = false
local players = {}
local playersNearby = {}
local searchPlayerGroups = {}
local selectedGroup
local Groups = {}
local povlist = ''
local SelectedPerm = nil
local hoveredPlayer = nil

local f = nil
local g
local h = {}
local i = 1
local k = {}

bantarget = nil
bantargetname = nil
banduration = 0
banevidence = nil
banstable = {}
banreasons = ''

admincfg = {}

admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false

local tpLocationColour = '~b~'



--[[ {enabled -- true or false}, permission required ]]
admincfg.buttonsEnabled = {


    --[[ admin Menu ]]
    ["adminMenu"] = {true, "admin.tickets"},
    ["warn"] = {true, "admin.warn"},      
    ["showwarn"] = {true, "admin.showwarn"},
    ["ban"] = {true, "admin.ban"},
    ["unban"] = {true, "admin.unban"},
    ["kick"] = {true, "admin.kick"},
    ["revive"] = {true, "admin.revive"},
    ["TP2"] = {true, "admin.tp2player"},
    ["TP2ME"] = {true, "admin.summon"},
    ["FREEZE"] = {true, "admin.freeze"},
    ["spectate"] = {true, "admin.spectate"}, 
    ["SS"] = {true, "admin.screenshot"},
    ["VV"] = {true, "admin.screenshot"},
    ["slap"] = {true, "admin.slap"},
    ["armour"] = {true, "admin.special"},
    ["giveMoney"] = {true, "admin.givemoney"},
    ["addcar"] = {true, "admin.addcar"},

    --[[ Functions ]]
    ["tp2waypoint"] = {true, "admin.tp2waypoint"},
    ["tp2location"] = {true, "admin.tp2location"},
    ["tp2coords"] = {true, "admin.tp2coords"},
    ["removewarn"] = {true, "admin.removewarn"},
    ["spawnBmx"] = {true, "admin.spawnBmx"},
    ["spawnTaxi"] = {true, "admin.spawnTaxi"},
    ["spawnGun"] = {true, "admin.spawnGun"},

    --[[ Add Groups ]]
    ["getgroups"] = {true, "group.add"},
    ["staffGroups"] = {true, "admin.staffAddGroups"},
    ["mpdGroups"] = {true, "admin.mpdAddGroups"},
    ["povGroups"] = {true, "admin.povAddGroups"},
    ["licenseGroups"] = {true, "admin.licenseAddGroups"},
    ["donoGroups"] = {true, "admin.donoAddGroups"},
    ["nhsGroups"] = {true, "admin.nhsAddGroups"},

    --[[ Vehicle Functions ]]
    ["vehFunctions"] = {true, "admin.vehmenu"},
    ["noClip"] = {true, "admin.noclip"},

    -- [[ Developer Functions ]]
    ["devMenu"] = {true, "dev.menu"},
}

menuColour = '~b~'

RMenu.Add('adminmenu', 'main', RageUI.CreateMenu("", "~b~Admin Menu", 1300,100, "banners","adminmenu"))

RMenu.Add("adminmenu", "players", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "closeplayers", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "searchoptions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Search Menu',1300,100,"banners","adminmenu"))

--[[ Functions ]]
RMenu.Add("adminmenu", "functions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Functions Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "teleportfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"), "", menuColour..'Teleport Functions Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "entityfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"), "", menuColour..'Entity Functions Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "devfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "functions"), "", menuColour..'Dev Functions Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "anticheattypes", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'AntiCheat Types',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "actypes", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'AC Types',1300,100,"banners","adminmenu"))
--[[ End of Functions ]]

RMenu.Add("adminmenu", "submenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Admin Player Interaction Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "trollfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Dev Functions Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "searchname", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "searchtempid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "searchpermid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "warnsub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Select Warn Reason',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "bansub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Select Ban Reasons',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "notesub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Player Notes',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "confirmban", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Confirm Ban',1300,100,"banners","adminmenu"))

--[[groups]]
RMenu.Add("adminmenu", "groups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))
--RMenu.Add("adminmenu", "staffGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "LicenseGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "UserGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "POVGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "PoliceGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "NHSGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "addgroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "removegroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","adminmenu"))

RMenu:Get('adminmenu', 'main')

-- local getStaffGroupsGroupIds = {
-- 	["founder"] = "Founder",
--     ["dev"] = "Developer",
--     ["operationsmanager"] = "Operations Manager",
--     ["staffmanager"] = "Staff Manager",
--     ["commanager"] = "Community Manager",
--     ["headadmin"] = "Head Admin",
--     ["senioradmin"] = "Senior Admin",
-- 	["administrator"] = "Admin",
--     ["srmoderator"] = "Senior Moderator",
-- 	["moderator"] = "Moderator",
--     ["supportteam"] = "Support Team",
--     ["trialstaff"] = "Trial Staff",
--     ["cardev"] = "Car Developer",
-- }
local getUserGroupsGroupIds = {
    ["VIP"] = "VIP",
    ["recruit"] = "Recruit",
    ["soldier"] = "Soldier",
    ["warrior"] = "Warrior",
    ["diamond"] = "Diamond",
    ["GANGWHITELIST"] = "Whitelisted Gang",

}
local getUserLicenseGroups = {
    ["Scrap Job"] = "Scrap Job License",
    ["Weed"] = "Weed License",
    ["Cocaine"] = "Cocaine License",
    ["Heroin"] = "Heroin License",
    ["LSD"] = "LSD License",
    ["Rebel"] = "Rebel License",
    ["AdvancedRebel"] = "Advanced Rebel",
    ["Diamond"] = "Diamond License",
    ["Gang"] = "Gang License",
    ["HighRoller"] = "High Roller License",
    ["DJ"] = "DJ License",
}
local getUserPOVGroups = {
    ["pov"] = "POV List",
    ["TutorialCompleted"] = "Tutorial Finished",
    ["AA"] = "AA Mechanic",
}

--local getUserPoliceGroups = {
    -- ["Special Constable"] = "Special Constable",
    -- ["Commissioner"] = "Commissioner",
    -- ["Deputy Commissioner"] = "Deputy Commissioner",
    -- ["Assistant Commissioner"] = "Assistant Commissioner",
    -- ["Deputy Assistant Commissioner"] = "Deputy Assistant Commissioner",
    -- ["Commander"] = "Commander",
    -- ["Chief Superintendent"] = "Chief Superintendent",
    -- ["Superintendent"] = "Superintendent",
    -- ["ChiefInspector"] = "Chief Inspector",
    -- ["Inspector"] = "Inspector",
    -- ["Sergeant"] = "Sergeant",
    -- ["Senior Constable"] = "Senior Constable",
    -- ["Police Constable"] = "Police Constable",
    -- ["PCSO"] = "PCSO",
    --["Police"] = "Whitelist",
    --["pdlargearms"] = "Police Large Arms",
--}

-- local getUserNHSGroups = {
--     ["Head Chief Medical Officer"] = "Head Chief Medical Officer",
--     ["Assistant Chief Medical Officer"] = "Assistant Chief Medical Officer",
--     ["Deputy Chief Medical Officer"] = "Deputy Chief Medical Officer",
--     ["Captain"] = "Captain",
--     ["Consultant"] = "Consultant",
--     ["Specialist"] = "Specialist",
--     ["Senior Doctor"] = "Senior Doctor",
--     ["Junior Doctor"] = "Junior Doctor",
--     ["Critical Care Paramedic"] = "Critical Care Paramedic",
--     ["Paramedic"] = "Paramedic",
--     ["Trainee Paramedic"] = "Trainee Paramedic",
-- }

AddEventHandler("playerSpawned",function()
    local h = true
    if h then 
        TriggerServerEvent("LUNA:requestAdminPerks")
    end 
end)

RegisterNetEvent('LUNA:SendAdminPerks', function(a)
    Stafflevel = a 
    if getStaffLevel() > 0 then 
        print('[LUNA] Your staff level is: ' ..Stafflevel)
    end
end)

function getStaffLevel()
    return Stafflevel
end

function tLUNA.isAdmin()
    return isPlayerAdmin
end

function tLUNA.setAdmin(bool_value)
    isPlayerAdmin = bool_value
end

RegisterCommand('staffperks', function(source, args, RawCommand)
    if getStaffLevel() > 4 then
        print('You requested all staff perms to be checked')
        TriggerServerEvent("LUNA:requestAdminPerks")
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
        hoveredPlayer = nil
        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.ButtonWithStyle("All Players", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'players'))
        end
        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.ButtonWithStyle("Nearby Players", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("LUNA:GetNearbyPlayers", 250)
                end
            end, RMenu:Get('adminmenu', 'closeplayers'))
        end
        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.ButtonWithStyle("Search Players", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'searchoptions'))
        end
        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.ButtonWithStyle("Functions", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'functions'))
        end
        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.ButtonWithStyle("Settings", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('SettingsMenu', 'MainMenu'))
        end
    end)
end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'players')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k, v in pairs(players) do
                RageUI.ButtonWithStyle(v[1] .." ["..v[3].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SelectedPlayer = players[k]
                        SelectedPerm = v[3]
                        TriggerServerEvent("LUNA:CheckPov",v[3])
                        TriggerServerEvent("LUNA:GetPlayerGroups", v[3])
                    end
                end, RMenu:Get('adminmenu', 'submenu'))
            end
        end)
    end

    if RageUI.Visible(RMenu:Get('adminmenu', 'closeplayers')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if next(playersNearby) then
                for i, v in pairs(playersNearby) do
                    RageUI.ButtonWithStyle(v[1] .." ["..v[2].."]", v[1] .. " ("..v[4].." hours) PermID: " .. v[3] .. " TempID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then 
                            SelectedPlayer = playersNearby[i]
                            SelectedPerm = v[3]
                            TriggerServerEvent("LUNA:GetPlayerGroups", v[3])
                        end
                        if Active then 
                            hoveredPlayer = v[2]
                        end
                    end, RMenu:Get("adminmenu", "submenu"))
                end
            else
                RageUI.Separator("~r~No players nearby!")
            end
        end)
    end
end)

RegisterNetEvent("LUNA:ReturnNearbyPlayers")
AddEventHandler("LUNA:ReturnNearbyPlayers", function(table)
    playersNearby = table
end)

RegisterNetEvent('LUNA:playerDamageDisplay')
AddEventHandler('LUNA:playerDamageDisplay', function(target, damage)
    if damageDisplay then
        DisplayDamage(target, damage)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if IsPedShooting(playerPed) then
            local _, target, damage = GetPedLastWeaponImpactCoord(playerPed)
            if IsPedAPlayer(target) then
                local targetPlayer = NetworkGetPlayerIndexFromPed(target)
                local targetPlayerId = GetPlayerServerId(targetPlayer)
                TriggerServerEvent('LUNA:playerDamage', targetPlayerId, damage)
            end
        end
    end
end)

RegisterCommand('ToggleNames', function()
    showPlayerNames = not showPlayerNames
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if showPlayerNames then
            for i=0, GetNumberOfPlayers() - 1 do
                local playerPed = GetPlayerPed(i)
                if playerPed ~= PlayerPedId() then
                    local coords = GetEntityCoords(playerPed)
                    local playerName = GetPlayerName(i)
                    DrawText3D(coords.x, coords.y, coords.z + 1.0, playerName)
                end
            end
        end
    end
end)



-- RMenu.Add('SettingsMenu', 'MainMenu', RageUI.CreateMenu("", menuColour.."Settings Menu", 1300,100, "banners","setting")) 
-- RMenu.Add("SettingsMenu", "crosshairsettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu")))


-- local statusr = "~r~[Off]"
-- local hitsounds = false
-- local oldkillfeed = false

-- local healthPercentageDisplay = true

-- local statusc = "~r~[Off]"
-- local compass = false

-- local statusT = "~r~[Off]"
-- local toggle = false

-- local killNotification = true
-- local damageDisplay = false
-- local nameschecked = false
-- local showPlayerNames = false
-- local oldKillfeedEnabled = false
-- local a = module("cfg/cfg_settings")





-- local df = {
--     {"10%", 0.1},
--     {"20%", 0.2},
--     {"30%", 0.3},
--     {"40%", 0.4},
--     {"50%", 0.5},
--     {"60%", 0.6},
--     {"70%", 0.7},
--     {"80%", 0.8},
--     {"90%", 0.9},
--     {"100%", 1.0},
--     {"150%", 1.5},
--     {"200%", 2.0},
--     {"250%", 2.5},
--     {"300%", 3.0},
--     {"350%", 3.5},
--     {"400%", 4.0},
--     {"450%", 4.5},
--     {"500%", 5.0},
--     {"600%", 6.0},
--     {"700%", 7.0},
--     {"800%", 8.0},
--     {"900%", 9.0},
--     {"1000%", 10.0},
-- }

-- local d = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "250%", "300%", "350%", "400%", "450%", "500%", "600%", "700%", "800%", "900%", "1000%"}
-- local dts = 10


--             RMenu.Add(
--                 "SettingsMenu",
--                 "graphicpresets",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "MainMenu"),
--                     "",
--                     "~b~Graphics Presets",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "changediscord",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "MainMenu"),
--                     "",
--                     "~b~Link Discord",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "killeffects",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "MainMenu"),
--                     "",
--                     "~b~Kill Effects",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "bloodeffects",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "MainMenu"),
--                     "",
--                     "~b~Blood Effects",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "weaponswhitelist",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "weaponsettings"),
--                     "",
--                     "~b~Custom Weapons Owned",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "generateaccesscode",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "weaponswhitelist"),
--                     "",
--                     "~b~Generate Access Code",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "viewwhitelisted",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "generateaccesscode"),
--                     "",
--                     "~b~View Whilelisted Users",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "uisettings",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "MainMenu"),
--                     "",
--                     "~b~UI Related Settings",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "weaponsettings",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "MainMenu"),
--                     "",
--                     "~b~Weapon Related Settings",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "gangsettings",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "MainMenu"),
--                     "",
--                     "~b~Gang Related Settings",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             RMenu.Add(
--                 "SettingsMenu",
--                 "miscsettings",
--                 RageUI.CreateSubMenu(
--                     RMenu:Get("SettingsMenu", "MainMenu"),
--                     "",
--                     "~b~Miscellaneous Settings",
--                     tLUNA.getRageUIMenuWidth(),
--                     tLUNA.getRageUIMenuHeight(),
--                     "banners",
--                     "setting"
--                 )
--             )
--             local a = module("cfg/cfg_settings")
--             local b = 0
--             local c = 0
--             local d = 0
--             local e = false
--             local g = false
--             local h = false
--             local i = false
--             local j = 1
--             local k = {30.0, 45.0, 60.0, 75.0, 90.0, 500.0}
--             local l = {"30m", "45m", "60m", "75m", "90m", "500m"}
--             local m = false
--             local n = 3
--             Citizen.CreateThread(
--                 function()
--                     local o = GetResourceKvpString("luna_diagonalweapons") or "false"
--                     if o == "false" then
--                         b = false
--                         TriggerEvent("LUNA:setVerticalWeapons")
--                     else
--                         b = true
--                         TriggerEvent("LUNA:setDiagonalWeapons")
--                     end
--                     local p = GetResourceKvpString("luna_frontars") or "false"
--                     if p == "false" then
--                         c = false
--                         TriggerEvent("LUNA:setBackAR")
--                     else
--                         c = true
--                         TriggerEvent("LUNA:setFrontAR")
--                     end
--                     local q = GetResourceKvpString("luna_hitmarkersounds") or "false"
--                     if q == "false" then
--                         d = false
--                         TriggerEvent("LUNA:hsSoundsOff")
--                     else
--                         d = true
--                         TriggerEvent("LUNA:hsSoundsOn")
--                     end
--                     local r = GetResourceKvpString("luna_reducedchatopacity") or "false"
--                     if r == "false" then
--                         f = false
--                         TriggerEvent("LUNA:chatReduceOpacity", false)
--                     else
--                         f = true
--                         TriggerEvent("LUNA:chatReduceOpacity", true)
--                     end
--                     local s = GetResourceKvpString("luna_hideeventannouncement") or "false"
--                     if s == "false" then
--                         g = false
--                     else
--                         g = true
--                     end
--                     local t = GetResourceKvpString("luna_healthpercentage") or "false"
--                     if t == "false" then
--                         h = false
--                     else
--                         h = true
--                     end
--                     local u = GetResourceKvpString("luna_flashlightnotaiming") or "false"
--                     if u == "false" then
--                         i = false
--                     else
--                         i = true
--                         SetFlashLightKeepOnWhileMoving(true)
--                     end
--                     local v = GetResourceKvpInt("luna_gang_name_distance")
--                     if v > 0 then
--                         j = v
--                         if k[j] then
--                             TriggerEvent("LUNA:setGangNameDistance", k[j])
--                         end
--                     end
--                     local w = GetResourceKvpString("luna_gang_ping_sound") or "false"
--                     if w == "false" then
--                         m = false
--                     else
--                         m = true
--                     end
--                     local x = GetResourceKvpInt("luna_gang_ping_marker")
--                     if x > 0 then
--                         n = x
--                     end
--                 end
--             )
--             function tLUNA.setDiagonalWeaponSetting(i)
--                 SetResourceKvp("luna_diagonalweapons", tostring(i))
--             end
--             function tLUNA.setFrontARSetting(i)
--                 SetResourceKvp("luna_frontars", tostring(i))
--             end
--             function tLUNA.setHitMarkerSetting(i)
--                 SetResourceKvp("luna_hitmarkersounds", tostring(i))
--             end
--             function tLUNA.setCODHitMarkerSetting(i)
--                 SetResourceKvp("luna_codhitmarkersounds", tostring(i))
--             end
--             function tLUNA.setKillListSetting(w)
--                 SetResourceKvp("luna_killlistsetting", tostring(w))
--             end
--             function tLUNA.setOldKillfeed(w)
--                 SetResourceKvp("luna_oldkillfeed", tostring(w))
--             end
--             function tLUNA.setDamageIndicator(w)
--                 SetResourceKvp("luna_damageindicator", tostring(w))
--             end
--             function tLUNA.setDamageIndicatorColour(w)
--                 SetResourceKvp("luna_damageindicatorcolour", tostring(w))
--             end
--             function tLUNA.setReducedChatOpacity(q)
--                 SetResourceKvp("luna_reducedchatopacity", tostring(q))
--             end
--             function tLUNA.setHideEventAnnouncementFlag(q)
--                 SetResourceKvp("luna_hideeventannouncement", tostring(q))
--             end
--             function tLUNA.getHideEventAnnouncementFlag()
--                 return g
--             end
--             function tLUNA.setShowHealthPercentageFlag(q)
--                 SetResourceKvp("luna_healthpercentage", tostring(q))
--             end
--             function tLUNA.setFlashlightNotAimingFlag(x)
--                 SetFlashLightKeepOnWhileMoving(x)
--                 i = x
--                 SetResourceKvp("luna_flashlightnotaiming", tostring(x))
--             end
--             function tLUNA.getShowHealthPercentageFlag()
--                 return h
--             end
--             function tLUNA.setGangPingSoundEnabled(q)
--                 SetResourceKvp("luna_gang_ping_sound", tostring(q))
--             end
--             function tLUNA.getGangPingSoundEnabled()
--                 return m
--             end
--             function tLUNA.getGangPingMarkerIndex()
--                 return n
--             end
--             local function y(j)
--                 RageUI.ActuallyCloseAll()
--                 RageUI.Visible(RMenu:Get("SettingsMenu", "setting"), j)
--             end
--             local z = {
--                 {"50%", 0.5},
--                 {"60%", 0.6},
--                 {"70%", 0.7},
--                 {"80%", 0.8},
--                 {"90%", 0.9},
--                 {"100%", 1.0},
--                 {"150%", 1.5},
--                 {"200%", 2.0},
--                 {"1000%", 10.0}
--             }
--             local A = {"50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "1000%"}
--             local o = 6
--             local p = {}
--             local q
--             local r
--             local s
--             local t
--             RegisterNetEvent(
--                 "LUNA:gotCustomWeaponsOwned",
--                 function(u)
--                     print("gotCustomWeaponsOwned", dump(u))
--                     p = u
--                 end
--             )
--             RegisterNetEvent(
--                 "LUNA:generatedAccessCode",
--                 function(B)
--                     print("got accessCode", B)
--                     s = B
--                 end
--             )
--             RegisterNetEvent(
--                 "LUNA:getWhitelistedUsers",
--                 function(v)
--                     t = v
--                 end
--             )
--             local w = {}
--             local function x(C, D)
--                 return w[C.name .. D.name]
--             end
--             local function E(C)
--                 local F = false
--                 for G, D in pairs(C.presets) do
--                     if w[C.name .. D.name] then
--                         F = true
--                         w[C.name .. D.name] = nil
--                     end
--                 end
--                 if F then
--                     for H, I in pairs(C.default) do
--                         SetVisualSettingFloat(H, I)
--                     end
--                 end
--             end
--             local function J(D)
--                 for H, I in pairs(D.values) do
--                     SetVisualSettingFloat(H, I)
--                 end
--             end
--             local function K(C, D, L)
--                 E(C)
--                 if L then
--                     w[C.name .. D.name] = true
--                     J(D)
--                 end
--                 local M = json.encode(w)
--                 SetResourceKvp("luna_graphic_presets", M)
--             end
--             local N = {
--                 "0%",
--                 "5%",
--                 "10%",
--                 "15%",
--                 "20%",
--                 "25%",
--                 "30%",
--                 "35%",
--                 "40%",
--                 "45%",
--                 "50%",
--                 "55%",
--                 "60%",
--                 "65%",
--                 "70%",
--                 "75%",
--                 "80%",
--                 "85%",
--                 "90%",
--                 "95%",
--                 "100%"
--             }
--             local O = {
--                 0.0,
--                 0.05,
--                 0.1,
--                 0.15,
--                 0.2,
--                 0.25,
--                 0.3,
--                 0.35,
--                 0.4,
--                 0.45,
--                 0.5,
--                 0.55,
--                 0.6,
--                 0.65,
--                 0.7,
--                 0.75,
--                 0.8,
--                 0.85,
--                 0.9,
--                 0.95,
--                 1.0
--             }
--             local P = {
--                 "25%",
--                 "50%",
--                 "75%",
--                 "100%",
--                 "125%",
--                 "150%",
--                 "175%",
--                 "200%",
--                 "250%",
--                 "300%",
--                 "350%",
--                 "400%",
--                 "450%",
--                 "500%",
--                 "750%",
--                 "1000%"
--             }
--             local Q = {0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 7.5, 10.0}
--             local R = {
--                 "0.1s",
--                 "0.2s",
--                 "0.3s",
--                 "0.4s",
--                 "0.5s",
--                 "0.6s",
--                 "0.7s",
--                 "0.8s",
--                 "0.9s",
--                 "1s",
--                 "1.25s",
--                 "1.5s",
--                 "1.75s",
--                 "2.0s"
--             }
--             local S = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1250, 1500, 1750, 2000}
--             local T = {
--                 "Disabled",
--                 "Fireworks",
--                 "Celebration",
--                 "Firework Burst",
--                 "Water Explosion",
--                 "Ramp Explosion",
--                 "Gas Explosion",
--                 "Electrical Spark",
--                 "Electrical Explosion",
--                 "Concrete Impact",
--                 "EMP 1",
--                 "EMP 2",
--                 "EMP 3",
--                 "Spike Mine",
--                 "Kinetic Mine",
--                 "Tar Mine",
--                 "Short Burst",
--                 "Fog Sphere",
--                 "Glass Smash",
--                 "Glass Drop",
--                 "Falling Leaves",
--                 "Wood Smash",
--                 "Train Smoke",
--                 "Money",
--                 "Confetti",
--                 "Marbles",
--                 "Sparkles"
--             }
--             local U = {
--                 {"DISABLED", "DISABLED", 1.0},
--                 {"scr_indep_fireworks", "scr_indep_firework_shotburst", 0.2},
--                 {"scr_xs_celebration", "scr_xs_confetti_burst", 1.2},
--                 {"scr_rcpaparazzo1", "scr_mich4_firework_burst_spawn", 1.0},
--                 {"particle cut_finale1", "cs_finale1_car_explosion_surge_spawn", 1.0},
--                 {"des_fib_floor", "ent_ray_fbi5a_ramp_explosion", 1.0},
--                 {"des_gas_station", "ent_ray_paleto_gas_explosion", 0.5},
--                 {"core", "ent_dst_electrical", 1.0},
--                 {"core", "ent_sht_electrical_box", 1.0},
--                 {"des_vaultdoor", "ent_ray_pro1_concrete_impacts", 1.0},
--                 {"scr_xs_dr", "scr_xs_dr_emp", 1.0},
--                 {"scr_xs_props", "scr_xs_exp_mine_sf", 1.0},
--                 {"veh_xs_vehicle_mods", "exp_xs_mine_emp", 1.0},
--                 {"veh_xs_vehicle_mods", "exp_xs_mine_spike", 1.0},
--                 {"veh_xs_vehicle_mods", "exp_xs_mine_kinetic", 1.0},
--                 {"veh_xs_vehicle_mods", "exp_xs_mine_tar", 1.0},
--                 {"scr_stunts", "scr_stunts_shotburst", 1.0},
--                 {"scr_tplaces", "scr_tplaces_team_swap", 1.0},
--                 {"des_fib_glass", "ent_ray_fbi2_window_break", 1.0},
--                 {"des_fib_glass", "ent_ray_fbi2_glass_drop", 2.5},
--                 {"des_stilthouse", "ent_ray_fam3_falling_leaves", 1.0},
--                 {"des_stilthouse", "ent_ray_fam3_wood_frags", 1.0},
--                 {"des_train_crash", "ent_ray_train_smoke", 1.0},
--                 {"core", "ent_brk_banknotes", 2.0},
--                 {"core", "ent_dst_inflate_ball_clr", 1.0},
--                 {"core", "ent_dst_gen_gobstop", 1.0},
--                 {"core", "ent_sht_telegraph_pole", 1.0}
--             }
--             local V = {
--                 "Disabled",
--                 "BikerFilter",
--                 "CAMERA_BW",
--                 "drug_drive_blend01",
--                 "glasses_blue",
--                 "glasses_brown",
--                 "glasses_Darkblue",
--                 "glasses_green",
--                 "glasses_purple",
--                 "glasses_red",
--                 "helicamfirst",
--                 "hud_def_Trevor",
--                 "Kifflom",
--                 "LectroDark",
--                 "MP_corona_tournament_DOF",
--                 "MP_heli_cam",
--                 "mugShot",
--                 "NG_filmic02",
--                 "REDMIST_blend",
--                 "trevorspliff",
--                 "ufo",
--                 "underwater",
--                 "WATER_LAB",
--                 "WATER_militaryPOOP",
--                 "WATER_river",
--                 "WATER_salton"
--             }
--             local W = {
--                 lightning = false,
--                 pedFlash = false,
--                 pedFlashRGB = {11, 11, 11},
--                 pedFlashIntensity = 4,
--                 pedFlashTime = 1,
--                 screenFlash = false,
--                 screenFlashRGB = {11, 11, 11},
--                 screenFlashIntensity = 4,
--                 screenFlashTime = 1,
--                 particle = 1,
--                 timecycle = 1,
--                 timecycleTime = 1
--             }
--             local X = 0
--             local function Y()
--                 local Z = json.encode(W)
--                 SetResourceKvp("luna_kill_effects", Z)
--             end
--             local _ = {head = 1, body = 1, arms = 1, legs = 1}
--             local function a0()
--                 local a1 = json.encode(_)
--                 SetResourceKvp("luna_blood_effects", a1)
--             end
--             Citizen.CreateThread(
--                 function()
--                     Citizen.Wait(1000)
--                     local M = GetResourceKvpString("luna_graphic_presets")
--                     if M and M ~= "" then
--                         w = json.decode(M) or {}
--                     end
--                     for G, C in pairs(a.presets) do
--                         for G, D in pairs(C.presets) do
--                             if x(C, D) then
--                                 J(D)
--                             end
--                         end
--                     end
--                     local Z = GetResourceKvpString("luna_kill_effects")
--                     if Z and Z ~= "" then
--                         local a2 = json.decode(Z)
--                         for a3, L in pairs(a2) do
--                             if W[a3] then
--                                 W[a3] = L
--                             end
--                         end
--                     end
--                     local a1 = GetResourceKvpString("luna_blood_effects")
--                     if a1 and a1 ~= "" then
--                         local a2 = json.decode(a1)
--                         for a3, L in pairs(a2) do
--                             if _[a3] then
--                                 _[a3] = L
--                             end
--                         end
--                     end
--                 end
--             )
--             RageUI.CreateWhile(
--                 1.0,
--                 true,
--                 function()
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.List(
--                                     "Render Distance Modifier",
--                                     A,
--                                     o,
--                                     "~g~Lowering this will increase your FPS!",
--                                     {},
--                                     true,
--                                     function(a4, a5, a6, a7)
--                                         o = a7
--                                     end,
--                                     function()
--                                     end,
--                                     nil
--                                 )
--                                 RageUI.ButtonWithStyle(
--                                     "UI Settings",
--                                     "UI related settings.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                     end,
--                                     RMenu:Get("SettingsMenu", "uisettings")
--                                 )
--                                 RageUI.ButtonWithStyle(
--                                     "Weapon Settings",
--                                     "Weapon related settings.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                     end,
--                                     RMenu:Get("SettingsMenu", "weaponsettings")
--                                 )
--                                 RageUI.ButtonWithStyle(
--                                     "Misc Settings",
--                                     "Miscellaneous settings.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                     end,
--                                     RMenu:Get("SettingsMenu", "miscsettings")
--                                 )
--                                 RageUI.ButtonWithStyle(
--                                     "Graphic Presets",
--                                     "View a list of preconfigured graphic settings.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function()
--                                     end,
--                                     RMenu:Get("SettingsMenu", "graphicpresets")
--                                 )
--                                 RageUI.ButtonWithStyle(
--                                     "Kill Effects",
--                                     "Toggle effects that occur on killing a player.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function()
--                                     end,
--                                     RMenu:Get("SettingsMenu", "killeffects")
--                                 )
--                                 RageUI.ButtonWithStyle(
--                                     "Blood Effects",
--                                     "Toggle effects that occur when damaging a player.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function()
--                                     end,
--                                     RMenu:Get("SettingsMenu", "bloodeffects")
--                                 )
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "uisettings")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.Checkbox("Streetnames", nil, streetnamechecked, {}, function(Hovered, Active, Selected, Checked)
--                                     if (Selected) then
--                                         streetnamechecked = not streetnamechecked
--                                         if Checked then
--                                             ExecuteCommand('streetnames')
                                          
--                                         else
--                                             ExecuteCommand('streetnames')
                                           
--                                         end
--                                     end
--                                 end)  
--                                 RageUI.Checkbox("Compass", nil, compasschecked, {}, function(Hovered, Active, Selected, Checked)
--                                     if (Selected) then
--                                         compasschecked = not compasschecked
--                                         ExecuteCommand("compass")
--                                     end
--                                 end)
--                                 local function a9()
--                                     tLUNA.hideUI()
--                                     hideUI = true
--                                 end
--                                 local function aa()
--                                     tLUNA.showUI()
--                                     hideUI = false
--                                 end
--                                 RageUI.Checkbox("Hide UI", nil, hudchecked, {}, function(Hovered, Active, Selected, Checked)
--                                     if (Selected) then
--                                         hudchecked = not hudchecked
--                                         if Checked then
--                                             ExecuteCommand('hideui')
                                          
--                                         else
--                                             ExecuteCommand('showui')
--                                         end
--                                     end
--                                 end)
--                                 local function a9()
--                                     tLUNA.toggleBlackBars()
--                                     e = true
--                                 end
--                                 local function aa()
--                                     tLUNA.toggleBlackBars()
--                                     e = false
--                                 end
--                                 RageUI.Checkbox("Show Health Percentage", "Displays the health and armour percentage on the bars.", healthPercentageDisplay, {}, function(Hovered, Active, Selected, Checked)
--                                     if (Selected) then
--                                         healthPercentageDisplay = not healthPercentageDisplay
--                                         if Checked then
--                                             notify("~g~Health Percentage On!")
--                                             TriggerEvent('LUNA:ToggleHealthPercentage', true)
--                                         else
--                                             notify("~r~Health Percentage Off!")
--                                             TriggerEvent('LUNA:ToggleHealthPercentage', false)
--                                         end
--                                     end
--                                 end)     
--                                 RageUI.ButtonWithStyle(
--                                     "Crosshair",
--                                     "Create a custom built-in crosshair here.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                     end,
--                                     RMenu:Get("crosshair", "main")
--                                 )
--                                 RageUI.ButtonWithStyle(
--                                     "Scope Settings",
--                                     "Add a toggleable range finder when using sniper scopes.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                     end,
--                                     RMenu:Get("scope", "main")
--                                 )
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "weaponsettings")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 local function a9()
--                                     TriggerEvent("weaponsonback:trigger")
--                                     b = true
--                                     tLUNA.setDiagonalWeaponSetting(b)
--                                 end
--                                 local function aa()
--                                     TriggerEvent("weaponsonback:trigger")
--                                     b = false
--                                     tLUNA.setDiagonalWeaponSetting(b)
--                                 end
--                                 RageUI.Checkbox("Enable Diagonal Weapons", "~g~This changes the way weapons look on your back from vertical to diagonal.", wbchecked, {}, function(Hovered, Active, Selected, Checked)
--                                     if (Selected) then
--                                         wbchecked = not wbchecked
--                                         TriggerEvent("weaponsonback:trigger")
--                                     end
--                                 end)
--                                 RageUI.ButtonWithStyle(
--                                     "Weapon Whitelists",
--                                     "Sell your custom weapon whitelists here.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                         if a6 then
--                                             s = nil
--                                             q = nil
--                                             r = nil
--                                             t = nil
--                                             TriggerServerEvent("LUNA:getCustomWeaponsOwned")
--                                         end
--                                     end,
--                                     RMenu:Get("SettingsMenu", "weaponswhitelist")
--                                 )
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "gangsettings")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.List(
--                                     "Gang Ping Marker ",
--                                     {"Only Text", "Marker", "Icon"},
--                                     n,
--                                     "Max distance to display gang member names.",
--                                     {},
--                                     true,
--                                     function(ab, ac, ad, ae)
--                                         if ae ~= n then
--                                             n = ae
--                                             SetResourceKvpInt("luna_gang_ping_marker", ae)
--                                         end
--                                     end
--                                 )
--                                 RageUI.Checkbox(
--                                     "Gang Ping Sound",
--                                     "Play a sound when a gang member pings.",
--                                     m,
--                                     {},
--                                     function()
--                                     end,
--                                     function()
--                                         m = true
--                                         tLUNA.setGangPingSoundEnabled(true)
--                                     end,
--                                     function()
--                                         m = false
--                                         tLUNA.setGangPingSoundEnabled(false)
--                                     end
--                                 )
--                                 RageUI.List(
--                                     "Gang Name Distance",
--                                     l,
--                                     j,
--                                     "Max distance to display gang member names.",
--                                     {},
--                                     true,
--                                     function(ab, ac, ad, ae)
--                                         if ae ~= j then
--                                             j = ae
--                                             SetResourceKvpInt("luna_gang_name_distance", ae)
--                                             TriggerEvent("LUNA:setGangNameDistance", k[ae])
--                                         end
--                                     end
--                                 )
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "miscsettings")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.ButtonWithStyle(
--                                     "Change Linked Discord",
--                                     "Begins the process of changing your linked Discord. Your linked discord is used to sync roles with the server.",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                         if a6 then
--                                             TriggerServerEvent('Reverify:Prompt')
--                                         end
--                                     end
--                                 )
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "changediscord")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.Separator("~g~A code has been messaged to the Discord account")
--                                 RageUI.Separator("-----")
--                                 RageUI.Separator("~y~If you have not received a message verify:")
--                                 RageUI.Separator("~y~1. Your direct messages are open.")
--                                 RageUI.Separator("~y~2. The account you provided was correct.")
--                                 RageUI.Separator("-----")
--                                 RageUI.ButtonWithStyle(
--                                     "Enter Code",
--                                     "",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                         if a6 then
--                                             TriggerServerEvent("LUNA:enterDiscordCode")
--                                         end
--                                     end
--                                 )
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "weaponswhitelist")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 for af, ag in pairs(p) do
--                                     RageUI.ButtonWithStyle(
--                                         ag,
--                                         "",
--                                         {RightLabel = "→→→"},
--                                         true,
--                                         function(a4, a5, a6)
--                                             if a6 then
--                                                 q = ag
--                                                 r = af
--                                                 t = nil
--                                             end
--                                         end,
--                                         RMenu:Get("SettingsMenu", "generateaccesscode")
--                                     )
--                                 end
--                                 RageUI.Separator("~y~If you do not see your custom weapon here.")
--                                 RageUI.Separator("~y~Please open a ticket on our support discord.")
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "generateaccesscode")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.Separator("~g~Weapon Whitelist for " .. q)
--                                 RageUI.Separator("How it works:")
--                                 RageUI.Separator("You generate an access code for the player who wishes")
--                                 RageUI.Separator("to purchase your custom weapon whitelist, which they ")
--                                 RageUI.Separator("then enter on the store to receive their automated")
--                                 RageUI.Separator("weapon whitelist.")
--                                 RageUI.ButtonWithStyle(
--                                     "Create access code",
--                                     "",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                         if a6 then
--                                             local ah = getGenericTextInput("User ID of player purchasing your weapon whitelist.")
--                                             if tonumber(ah) then
--                                                 ah = tonumber(ah)
--                                                 if ah > 0 then
--                                                     print("selling", r, "to", ah)
--                                                     TriggerServerEvent("LUNA:generateWeaponAccessCode", r, ah)
--                                                 end
--                                             end
--                                         end
--                                     end
--                                 )
--                                 RageUI.ButtonWithStyle(
--                                     "View whitelisted users",
--                                     "",
--                                     {RightLabel = "→→→"},
--                                     true,
--                                     function(a4, a5, a6)
--                                         if a6 then
--                                             TriggerServerEvent("LUNA:requestWhitelistedUsers", r)
--                                         end
--                                     end,
--                                     RMenu:Get("SettingsMenu", "viewwhitelisted")
--                                 )
--                                 if s then
--                                     RageUI.Separator("~g~Access code generated: " .. s)
--                                 end
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "viewwhitelisted")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.Separator("~g~Whitelisted users for " .. q)
--                                 if t == nil then
--                                     RageUI.Separator("~r~Requesting whitelisted users...")
--                                 else
--                                     for ai, aj in pairs(t) do
--                                         RageUI.ButtonWithStyle(
--                                             "ID: " .. tostring(ai),
--                                             "",
--                                             {RightLabel = aj},
--                                             true,
--                                             function()
--                                             end
--                                         )
--                                     end
--                                 end
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "graphicpresets")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 for G, C in pairs(a.presets) do
--                                     RageUI.Separator(C.name)
--                                     for G, D in pairs(C.presets) do
--                                         local ak = x(C, D)
--                                         RageUI.Checkbox(
--                                             D.name,
--                                             nil,
--                                             ak,
--                                             {},
--                                             function(a4, a6, a5, a8)
--                                                 if a8 ~= ak then
--                                                     K(C, D, a8)
--                                                 end
--                                             end,
--                                             function()
--                                             end,
--                                             function()
--                                             end
--                                         )
--                                     end
--                                 end
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "killeffects")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.Checkbox(
--                                     "Create Lightning",
--                                     "",
--                                     W.lightning,
--                                     {},
--                                     function(a4, a6, a5, a8)
--                                         if a6 then
--                                             W.lightning = a8
--                                             Y()
--                                         end
--                                     end
--                                 )
--                                 RageUI.Checkbox(
--                                     "Ped Flash",
--                                     "",
--                                     W.pedFlash,
--                                     {},
--                                     function(a4, a6, a5, a8)
--                                         if a6 then
--                                             W.pedFlash = a8
--                                             Y()
--                                         end
--                                     end
--                                 )
--                                 if W.pedFlash then
--                                     RageUI.List(
--                                         "Ped Flash Red",
--                                         N,
--                                         W.pedFlashRGB[1],
--                                         "",
--                                         {},
--                                         W.pedFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.pedFlashRGB[1] ~= a7 then
--                                                 W.pedFlashRGB[1] = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                     RageUI.List(
--                                         "Ped Flash Green",
--                                         N,
--                                         W.pedFlashRGB[2],
--                                         "",
--                                         {},
--                                         W.pedFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.pedFlashRGB[2] ~= a7 then
--                                                 W.pedFlashRGB[2] = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                     RageUI.List(
--                                         "Ped Flash Blue",
--                                         N,
--                                         W.pedFlashRGB[3],
--                                         "",
--                                         {},
--                                         W.pedFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.pedFlashRGB[3] ~= a7 then
--                                                 W.pedFlashRGB[3] = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                     RageUI.List(
--                                         "Ped Flash Intensity",
--                                         P,
--                                         W.pedFlashIntensity,
--                                         "",
--                                         {},
--                                         W.pedFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.pedFlashIntensity ~= a7 then
--                                                 W.pedFlashIntensity = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                     RageUI.List(
--                                         "Ped Flash Time",
--                                         R,
--                                         W.pedFlashTime,
--                                         "",
--                                         {},
--                                         W.pedFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.pedFlashTime ~= a7 then
--                                                 W.pedFlashTime = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                 end
--                                 RageUI.Checkbox(
--                                     "Screen Flash",
--                                     "",
--                                     W.screenFlash,
--                                     {},
--                                     function(a4, a6, a5, a8)
--                                         if a6 then
--                                             W.screenFlash = a8
--                                             Y()
--                                         end
--                                     end
--                                 )
--                                 if W.screenFlash then
--                                     RageUI.List(
--                                         "Screen Flash Red",
--                                         N,
--                                         W.screenFlashRGB[1],
--                                         "",
--                                         {},
--                                         W.screenFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.screenFlashRGB[1] ~= a7 then
--                                                 W.screenFlashRGB[1] = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                     RageUI.List(
--                                         "Screen Flash Green",
--                                         N,
--                                         W.screenFlashRGB[2],
--                                         "",
--                                         {},
--                                         W.screenFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.screenFlashRGB[2] ~= a7 then
--                                                 W.screenFlashRGB[2] = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                     RageUI.List(
--                                         "Screen Flash Blue",
--                                         N,
--                                         W.screenFlashRGB[3],
--                                         "",
--                                         {},
--                                         W.screenFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.screenFlashRGB[3] ~= a7 then
--                                                 W.screenFlashRGB[3] = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                     RageUI.List(
--                                         "Screen Flash Intensity",
--                                         P,
--                                         W.screenFlashIntensity,
--                                         "",
--                                         {},
--                                         W.screenFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.screenFlashIntensity ~= a7 then
--                                                 W.screenFlashIntensity = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                     RageUI.List(
--                                         "Screen Flash Time",
--                                         R,
--                                         W.screenFlashTime,
--                                         "",
--                                         {},
--                                         W.screenFlash,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.screenFlashTime ~= a7 then
--                                                 W.screenFlashTime = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                 end
--                                 RageUI.List(
--                                     "Timecycle Flash",
--                                     V,
--                                     W.timecycle,
--                                     "",
--                                     {},
--                                     true,
--                                     function(a4, a5, a6, a7)
--                                         if a5 and W.timecycle ~= a7 then
--                                             W.timecycle = a7
--                                             Y()
--                                         end
--                                     end,
--                                     function()
--                                     end
--                                 )
--                                 if W.timecycle ~= 1 then
--                                     RageUI.List(
--                                         "Timecycle Flash Time",
--                                         R,
--                                         W.timecycleTime,
--                                         "",
--                                         {},
--                                         true,
--                                         function(a4, a5, a6, a7)
--                                             if a5 and W.timecycleTime ~= a7 then
--                                                 W.timecycleTime = a7
--                                                 Y()
--                                             end
--                                         end,
--                                         function()
--                                         end
--                                     )
--                                 end
--                                 RageUI.List(
--                                     "~y~Particles~w~",
--                                     T,
--                                     W.particle,
--                                     "",
--                                     {},
--                                     true,
--                                     function(a4, a5, a6, a7)
--                                         if a5 and W.particle ~= a7 then
--                                             if not tLUNA.isPlusClub() and not tLUNA.isPlatClub() then
--                                                 notify(
--                                                     "~y~You need to be a subscriber of LUNA Plus or LUNA Platinum to use this feature."
--                                                 )
--                                                 notify("~y~Available @ store.lunastudios.uk")
--                                             end
--                                             W.particle = a7
--                                             Y()
--                                         end
--                                     end,
--                                     function()
--                                     end
--                                 )
--                                 local al = 0
--                                 if W.lightning then
--                                     al = math.max(al, 1000)
--                                 end
--                                 if W.pedFlash then
--                                     al = math.max(al, S[W.pedFlashTime])
--                                 end
--                                 if W.screenFlash then
--                                     al = math.max(al, S[W.screenFlashTime])
--                                 end
--                                 if W.timecycleTime ~= 1 then
--                                     al = math.max(al, O[W.timecycleTime])
--                                 end
--                                 if W.particle ~= 1 then
--                                     al = math.max(al, 1000)
--                                 end
--                                 if GetGameTimer() - X > al + 1000 then
--                                     tLUNA.addKillEffect(PlayerPedId(), true)
--                                     X = GetGameTimer()
--                                 end
--                                 DrawAdvancedTextNoOutline(0.59, 0.9, 0.005, 0.0028, 1.5, "PREVIEW", 255, 0, 0, 255, 2, 0)
--                             end
--                         )
--                     end
--                     if RageUI.Visible(RMenu:Get("SettingsMenu", "bloodeffects")) then
--                         RageUI.DrawContent(
--                             {header = true, glare = false, instructionalButton = false},
--                             function()
--                                 RageUI.List(
--                                     "~y~Head",
--                                     T,
--                                     _.head,
--                                     "Effect that displays when you hit the head.",
--                                     {},
--                                     true,
--                                     function(a4, a5, a6, a7)
--                                         if _.head ~= a7 then
--                                             if not tLUNA.isPlusClub() and not tLUNA.isPlatClub() then
--                                                 notify(
--                                                     "~y~You need to be a subscriber of LUNA Plus or LUNA Platinum to use this feature."
--                                                 )
--                                                 notify("~y~Available @ store.lunastudios.uk")
--                                             end
--                                             _.head = a7
--                                             a0()
--                                         end
--                                         if a6 then
--                                             tLUNA.addBloodEffect("head", 0x796E, PlayerPedId())
--                                         end
--                                     end
--                                 )
--                                 RageUI.List(
--                                     "~y~Body",
--                                     T,
--                                     _.body,
--                                     "Effect that displays when you hit the body.",
--                                     {},
--                                     true,
--                                     function(a4, a5, a6, a7)
--                                         if _.body ~= a7 then
--                                             if not tLUNA.isPlusClub() and not tLUNA.isPlatClub() then
--                                                 notify(
--                                                     "~y~You need to be a subscriber of LUNA Plus or LUNA Platinum to use this feature."
--                                                 )
--                                                 notify("~y~Available @ store.lunastudios.uk")
--                                             end
--                                             _.body = a7
--                                             a0()
--                                         end
--                                         if a6 then
--                                             tLUNA.addBloodEffect("body", 0x0, PlayerPedId())
--                                         end
--                                     end
--                                 )
--                                 RageUI.List(
--                                     "~y~Arms",
--                                     T,
--                                     _.arms,
--                                     "Effect that displays when you hit the arms.",
--                                     {},
--                                     true,
--                                     function(a4, a5, a6, a7)
--                                         if _.arms ~= a7 then
--                                             if not tLUNA.isPlusClub() and not tLUNA.isPlatClub() then
--                                                 notify(
--                                                     "~y~You need to be a subscriber of LUNA Plus or LUNA Platinum to use this feature."
--                                                 )
--                                                 notify("~y~Available @ store.lunastudios.uk")
--                                             end
--                                             _.arms = a7
--                                             a0()
--                                         end
--                                         if a6 then
--                                             tLUNA.addBloodEffect("arms", 0xBB0, PlayerPedId())
--                                             tLUNA.addBloodEffect("arms", 0x58B7, PlayerPedId())
--                                         end
--                                     end
--                                 )
--                                 RageUI.List(
--                                     "~y~Legs",
--                                     T,
--                                     _.legs,
--                                     "Effect that displays when you hit the legs.",
--                                     {},
--                                     true,
--                                     function(a4, a5, a6, a7)
--                                         if _.legs ~= a7 then
--                                             if not tLUNA.isPlusClub() and not tLUNA.isPlatClub() then
--                                                 notify(
--                                                     "~y~You need to be a subscriber of LUNA Plus or LUNA Platinum to use this feature."
--                                                 )
--                                                 notify("~y~Available @ store.lunastudios.uk")
--                                             end
--                                             _.legs = a7
--                                             a0()
--                                         end
--                                         if a6 then
--                                             tLUNA.addBloodEffect("legs", 0x3FCF, PlayerPedId())
--                                             tLUNA.addBloodEffect("legs", 0xB3FE, PlayerPedId())
--                                         end
--                                     end
--                                 )
--                             end
--                         )
--                     end
--                 end
--             )
--             RegisterNetEvent("LUNA:OpenSettingsMenu")
--             AddEventHandler(
--                 "LUNA:OpenSettingsMenu",
--                 function(am)
--                     if not am then
--                         RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"), true)
--                     end
--                 end
--             )
--             RegisterCommand(
--                 "opensettingsmenu",
--                 function()
--                     TriggerServerEvent("LUNA:OpenSettings")
--                 end
--             )
--             AddEventHandler(
--                 "LUNA:enteredCity",
--                 function()
--                 end
--             )
--             AddEventHandler(
--                 "LUNA:leftCity",
--                 function()
--                 end
--             )
--             local function ac(ad)
--                 local ae = GetEntityCoords(ad, true)
--                 local an = GetGameTimer()
--                 local ao = math.floor(O[W.pedFlashRGB[1]] * 255)
--                 local ap = math.floor(O[W.pedFlashRGB[2]] * 255)
--                 local aq = math.floor(O[W.pedFlashRGB[3]] * 255)
--                 local ar = Q[W.pedFlashIntensity]
--                 local as = S[W.pedFlashTime]
--                 while GetGameTimer() - an < as do
--                     local at = (as - (GetGameTimer() - an)) / as
--                     local au = ar * 25.0 * at
--                     DrawLightWithRange(ae.x, ae.y, ae.z + 1.0, ao, ap, aq, 50.0, au)
--                     Citizen.Wait(0)
--                 end
--             end
--             local function av()
--                 local an = GetGameTimer()
--                 local ao = math.floor(O[W.screenFlashRGB[1]] * 255)
--                 local ap = math.floor(O[W.screenFlashRGB[2]] * 255)
--                 local aq = math.floor(O[W.screenFlashRGB[3]] * 255)
--                 local ar = Q[W.screenFlashIntensity]
--                 local as = S[W.screenFlashTime]
--                 while GetGameTimer() - an < as do
--                     local at = (as - (GetGameTimer() - an)) / as
--                     local au = math.floor(25.5 * ar * at)
--                     DrawRect(0.0, 0.0, 2.0, 2.0, ao, ap, aq, au)
--                     Citizen.Wait(0)
--                 end
--             end
--             local function aw(ad)
--                 local ae = GetEntityCoords(ad, true)
--                 local ax = U[W.particle]
--                 tLUNA.loadPtfx(ax[1])
--                 UseParticleFxAsset(ax[1])
--                 StartParticleFxNonLoopedAtCoord(ax[2], ae.x, ae.y, ae.z, 0.0, 0.0, 0.0, ax[3], false, false, false)
--                 RemoveNamedPtfxAsset(ax[1])
--             end
--             local function ay()
--                 local an = GetGameTimer()
--                 local as = S[W.timecycleTime]
--                 SetTimecycleModifier(V[W.timecycle])
--                 while GetGameTimer() - an < as do
--                     local at = (as - (GetGameTimer() - an)) / as
--                     SetTimecycleModifierStrength(1.0 * at)
--                     Citizen.Wait(0)
--                 end
--                 ClearTimecycleModifier()
--             end
--             function tLUNA.addKillEffect(az, aA)
--                 if W.lightning then
--                     ForceLightningFlash()
--                 end
--                 if W.pedFlash then
--                     Citizen.CreateThreadNow(
--                         function()
--                             ac(az)
--                         end
--                     )
--                 end
--                 if W.screenFlash then
--                     Citizen.CreateThreadNow(
--                         function()
--                             av()
--                         end
--                     )
--                 end
--                 if W.particle ~= 1 and (tLUNA.isPlatClub() or aA) then
--                     Citizen.CreateThreadNow(
--                         function()
--                             aw(az)
--                         end
--                     )
--                 end
--                 if W.timecycle ~= 1 then
--                     Citizen.CreateThreadNow(
--                         function()
--                             ay()
--                         end
--                     )
--                 end
--             end
--             function tLUNA.addBloodEffect(aB, aC, ad)
--                 local aD = _[aB]
--                 if aD > 1 then
--                     local ax = U[aD]
--                     tLUNA.loadPtfx(ax[1])
--                     UseParticleFxAsset(ax[1])
--                     StartParticleFxNonLoopedOnPedBone(ax[2], ad, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, aC, ax[3], false, false, false)
--                     RemoveNamedPtfxAsset(ax[1])
--                 end
--             end
--             AddEventHandler(
--                 "LUNA:onPlayerKilledPed",
--                 function(aE)
--                     tLUNA.addKillEffect(aE, false)
--                 end
--             )
--             local aF = {
--                 [0x0] = "body",
--                 [0x2E28] = "body",
--                 [0xE39F] = "legs",
--                 [0xF9BB] = "legs",
--                 [0x3779] = "legs",
--                 [0x83C] = "legs",
--                 [0xCA72] = "legs",
--                 [0x9000] = "legs",
--                 [0xCC4D] = "legs",
--                 [0x512D] = "legs",
--                 [0xE0FD] = "body",
--                 [0x5C01] = "body",
--                 [0x60F0] = "body",
--                 [0x60F1] = "body",
--                 [0x60F2] = "body",
--                 [0xFCD9] = "body",
--                 [0xB1C5] = "arms",
--                 [0xEEEB] = "arms",
--                 [0x49D9] = "arms",
--                 [0x67F2] = "arms",
--                 [0xFF9] = "arms",
--                 [0xFFA] = "arms",
--                 [0x67F3] = "arms",
--                 [0x1049] = "arms",
--                 [0x104A] = "arms",
--                 [0x67F4] = "arms",
--                 [0x1059] = "arms",
--                 [0x105A] = "arms",
--                 [0x67F5] = "arms",
--                 [0x1029] = "arms",
--                 [0x102A] = "arms",
--                 [0x67F6] = "arms",
--                 [0x1039] = "arms",
--                 [0x103A] = "arms",
--                 [0x29D2] = "arms",
--                 [0x9D4D] = "arms",
--                 [0x6E5C] = "arms",
--                 [0xDEAD] = "arms",
--                 [0xE5F2] = "arms",
--                 [0xFA10] = "arms",
--                 [0xFA11] = "arms",
--                 [0xE5F3] = "arms",
--                 [0xFA60] = "arms",
--                 [0xFA61] = "arms",
--                 [0xE5F4] = "arms",
--                 [0xFA70] = "arms",
--                 [0xFA71] = "arms",
--                 [0xE5F5] = "arms",
--                 [0xFA40] = "arms",
--                 [0xFA41] = "arms",
--                 [0xE5F6] = "arms",
--                 [0xFA50] = "arms",
--                 [0xFA51] = "arms",
--                 [0x9995] = "head",
--                 [0x796E] = "head",
--                 [0x5FD4] = "head",
--                 [0xD003] = "body",
--                 [0x45FC] = "body",
--                 [0x1D6B] = "legs",
--                 [0xB23F] = "legs"
--             }
--             AddEventHandler(
--                 "LUNA:onPlayerDamagePed",
--                 function(aE)
--                     if not tLUNA.isPlusClub() and not tLUNA.isPlatClub() then
--                         return
--                     end
--                     local aG, aC = GetPedLastDamageBone(aE, 0)
--                     if aG then
--                         local aH = GetPedBoneIndex(aE, aC)
--                         local aI = GetWorldPositionOfEntityBone(aE, aH)
--                         local aJ = aF[aC]
--                         if not aJ then
--                             local aK = GetWorldPositionOfEntityBone(aE, GetPedBoneIndex(aE, 0x9995))
--                             local aL = GetWorldPositionOfEntityBone(aE, GetPedBoneIndex(aE, 0x2E28))
--                             if aI.z >= aK.z - 0.01 then
--                                 aJ = "head"
--                             elseif aI.z < aL.z then
--                                 aJ = "legs"
--                             else
--                                 local aM = GetEntityCoords(aE, true)
--                                 local aN = #(aM.xy - aI.xy)
--                                 if aN > 0.075 then
--                                     aJ = "arms"
--                                 else
--                                     aJ = "body"
--                                 end
--                             end
--                         end
--                         tLUNA.addBloodEffect(aJ, aC, aE)
--                     end
--                 end
--             )
--             RegisterNetEvent("LUNA:gotDiscord")
--             AddEventHandler(
--                 "LUNA:gotDiscord",
--                 function()
--                     RageUI.Visible(RMenu:Get("SettingsMenu", "changediscord"), true)
--                 end
--             )

-- RageUI.CreateWhile(1.0, true, function()
--     if RageUI.Visible(RMenu:Get('SettingsMenu', 'crosshairsettings')) then
--         RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()


--         RageUI.Checkbox("Crosshair", nil, crosshairchecked, {}, function(Hovered, Active, Selected, Checked)
--             if (Selected) then
--                 crosshairchecked = not crosshairchecked
--                 if Checked then
--                     ExecuteCommand("cross")
--                     notify("~g~Crosshair Enabled!")
--                 else
--                     ExecuteCommand("cross")
--                     notify("~r~Crosshair Disabled!")
--                 end
--             end
--         end)

--         RageUI.ButtonWithStyle("Edit Crosshair", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--             if (Selected) then
--                 ExecuteCommand("crosse")
--             end
--         end)

--         RageUI.ButtonWithStyle("Reset Crosshair", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--             if (Selected) then
--                 ExecuteCommand("crossr")
--             end
--         end)

--     end)
-- end
-- end)


-- RegisterNetEvent('LUNA:OpenSettingsMenu')
-- AddEventHandler('LUNA:OpenSettingsMenu', function()

--     RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"), true)

-- end)

-- RegisterCommand('settings',function()
--     TriggerServerEvent('LUNA:OpenSettings')
-- end)

-- RegisterKeyMapping('settings', 'Opens the Settings menu', 'keyboard', 'F4')
-- RegisterKeyMapping('opensettingsmenu', 'Opens the Settings menu', 'keyboard', 'F4')

-- Citizen.CreateThread(function() 
--     while true do
--         Citizen.InvokeNative(0xA76359FC80B2438E, df[dts][2])      
--         Citizen.Wait(0)
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if hoveredPlayer ~= nil then
            local hoveredPedCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(hoveredPlayer)))
            DrawMarker(2, hoveredPedCoords.x, hoveredPedCoords.y, hoveredPedCoords.z + 1.1,0.0,0.0,0.0,0.0,-180.0,0.0,0.4,0.4,0.4,255,255,0,125,false,true,2, false)
        end
    end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchoptions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
        foundMatch = false
        RageUI.ButtonWithStyle("Search by Name",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('adminmenu', 'searchname'))
        
        RageUI.ButtonWithStyle("Search by Perm ID",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('adminmenu', 'searchpermid'))

        RageUI.ButtonWithStyle("Search by Temp ID",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('adminmenu', 'searchtempid'))
    end)
end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'functions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

       if admincfg.buttonsEnabled["kick"][1] and buttons["kick"] then                        
           RageUI.ButtonWithStyle("Kick (No F10)", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
               if Selected then
                   TriggerServerEvent('LUNA:noF10Kick')
               end
           end, RMenu:Get('adminmenu', 'functions'))
       end

        if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
            RageUI.ButtonWithStyle("Offline Ban",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local uid = GetPlayerServerId(PlayerId())
                    TriggerServerEvent('LUNA:offlineban', uid)
                end
            end)
        end

        if admincfg.buttonsEnabled["unban"][1] and buttons["unban"] then
            RageUI.ButtonWithStyle("Unban Player",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("LUNA:Unban")
                end
            end)
        end

        if admincfg.buttonsEnabled["spawnBmx"][1] and buttons["spawnBmx"] then
            RageUI.ButtonWithStyle("Spawn BMX", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnVehicle('bmx')
                end
            end, RMenu:Get('adminmenu', 'functions'))
        end

        if admincfg.buttonsEnabled["spawnTaxi"][1] and buttons["spawnTaxi"] then
            RageUI.ButtonWithStyle("Spawn Taxi", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    SpawnVehicle('taxi')
                end
            end, RMenu:Get('adminmenu', 'functions'))
        end

        if admincfg.buttonsEnabled["removewarn"][1] and buttons["removewarn"] then
            RageUI.ButtonWithStyle("Remove Warning", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local uid = GetPlayerServerId(PlayerId())
                    TriggerServerEvent('LUNA:RemoveWarning', uid, result)
                end
            end, RMenu:Get('adminmenu', 'functions'))
        end
        if admincfg.buttonsEnabled["getgroups"][1] and buttons["getgroups"] then
            RageUI.Button("Toggle Blips", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('LUNA:checkBlips')
                end
            end, RMenu:Get('adminmenu', 'functions'))
        end
        if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
            RageUI.ButtonWithStyle("~b~Developer Functions", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'devfunctions'))
        end
        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.ButtonWithStyle("~b~Teleport Functions", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'teleportfunctions'))
        end
    end)
end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'entityfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()


            if admincfg.buttonsEnabled["unban"][1] and buttons["unban"] then
                RageUI.ButtonWithStyle("Vehicle Cleanup", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('LUNA:VehCleanup')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

     

            if admincfg.buttonsEnabled["unban"][1] and buttons["unban"] then
                RageUI.ButtonWithStyle("Entity Cleanup",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('LUNA:CleanAll')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

        end)
    end
end)

local q = {tpLocationColour.."Mission Row", tpLocationColour.."Sandy PD", tpLocationColour.."License Centre", tpLocationColour.."Airport", tpLocationColour.."Rebel Diner", tpLocationColour.."VIP Island", tpLocationColour.."St Thomas", tpLocationColour.."Casino", tpLocationColour.."Dealership"}
local r = {
    --vector3(151.61740112305,-1035.05078125,29.339416503906),
    vector3(444.96252441406,-983.07598876953,30.689311981201),
    vector3(1839.3137207031, 3671.0014648438, 34.310436248779),
    vector3(-551.08221435547, -194.19259643555, 38.219661712646),
    vector3(-1142.0673828125, -2851.802734375, 13.94624710083),
    vector3(1572.0604248047,6444.8408203125,24.445825576782),
    vector3(-2167.3876953125,5180.6889648438,15.467968940735),
    vector3(364.86236572266,-590.99975585938,28.690246582031),
    vector3(923.24499511719,48.181098937988,81.106323242188),
    vector3(-58.337699890137,-1106.9178466797,26.438161849976),
}
local s = 1

RageUI.CreateWhile(1.0, true, function()  --marker 
    if RageUI.Visible(RMenu:Get('adminmenu', 'teleportfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

            if admincfg.buttonsEnabled["tp2waypoint"][1] and buttons["tp2waypoint"] then                        
                RageUI.List("Teleport to",q,s,nil,{},true,function(x, y, z, N)
                    s = N
                    if z then
                        local uid = GetPlayerServerId(PlayerId())
                        TriggerServerEvent("LUNA:Teleport", uid, vector3(r[s]))
                    end
                end,
                function()end)
            end

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.ButtonWithStyle("Get Coords", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('LUNA:GetCoords')
                    end
                end, RMenu:Get('adminmenu', 'teleportfunctions'))
            end

            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.ButtonWithStyle("TP To Coords",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("LUNA:Tp2Coords")
                    end
                end, RMenu:Get('adminmenu', 'teleportfunctions'))
            end

            if admincfg.buttonsEnabled["tp2waypoint"][1] and buttons["tp2waypoint"] then
                RageUI.ButtonWithStyle("TP To Waypoint", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local WaypointHandle = GetFirstBlipInfoId(8)
                        if DoesBlipExist(WaypointHandle) then
                            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
                            for height = 1, 1000 do
                                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                if foundGround then
                                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
                                    break
                                end
                                Citizen.Wait(5)
                            end
                        else
                            notify("~r~You do not have a waypoint set")
                        end
                    end
                end, RMenu:Get('adminmenu', 'teleportfunctions'))
            end

        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'devfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
           -- RageUI.CenterButton("~g~Money Functions", nil, {}, true,function(Hovered, Active, Selected)end)
                if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                    RageUI.ButtonWithStyle("Give Cash",nil,{}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("LUNA:GiveMoneyMenu")
                        end
                    end, RMenu:Get('adminmenu', 'devfunctions'))
                end
                if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                    RageUI.ButtonWithStyle("Give Bank",nil,{}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("LUNA:GiveBankMenu")
                        end
                    end, RMenu:Get('adminmenu', 'devfunctions'))
                end
           -- RageUI.CenterButton("~b~Vehicle Functions", nil, {}, true,function(Hovered, Active, Selected)end)
            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.ButtonWithStyle("Add Car",nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('LUNA:AddCar')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end

            -- if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
            --     RageUI.ButtonWithStyle("Restart Server",nil, {}, true, function(Hovered, Active, Selected)
            --         if Selected then
            --             ExecuteCommand("announcerestart2")
            --         end
            --     end, RMenu:Get('adminmenu', 'devfunctions'))
            -- end    
    
            if admincfg.buttonsEnabled["tp2waypoint"][1] and buttons["tp2waypoint"] then
                RageUI.ButtonWithStyle("Cancel Rent",nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('admin:cancelRent')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
            
          --  RageUI.CenterButton("~b~Spawn Functions", nil, {}, true,function(Hovered, Active, Selected)end)
            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.ButtonWithStyle("Spawn Vehicle",nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        spawnvehicle()
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.ButtonWithStyle("Spawn Weapon",nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('LUNA:Giveweapon')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end  
            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
             --   RageUI.CenterButton("~b~Other Functions", nil, {}, true,function(Hovered, Active, Selected)end)
                RageUI.ButtonWithStyle("Reset Rewards",nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('LUNA:resetRedeem')
                    end
                end)
            if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.ButtonWithStyle("Entity Functions", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end
                RageUI.ButtonWithStyle("AntiCheat Types", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                end, RMenu:Get('adminmenu', 'anticheattypes'))
            end    
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'anticheattypes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("~b~AC Types", nil, {}, true,function(Hovered, Active, Selected)end)
            RageUI.Button("Type #1 - Noclip", nil, {}, true,function(Hovered, Active, Selected)end)
            RageUI.Button("Type #2 - Spawning Weapons", nil, {}, true,function(Hovered, Active, Selected)end)
            RageUI.Button("Type #3 - Explosion Event", nil, {}, true,function(Hovered, Active, Selected)end)
            RageUI.Button("Type #4 - Blacklisted Event", nil, {}, true,function(Hovered, Active, Selected)end)
            RageUI.Button("Type #5 - Infinite Ammo", nil, {}, true,function(Hovered, Active, Selected)end)
            RageUI.Button("Type #6 - Ammo > 250", nil, {}, true,function(Hovered, Active, Selected)end)
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'searchpermid')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

            if foundMatch == false then
                searchforPermID = KeyboardInput("Enter Perm ID", "", 10)
                if searchforPermID == nil then 
                    searchforPermID = ""
                end
            end

            for k, v in pairs(players) do
                foundMatch = true
                if string.find(v[3],searchforPermID) then
                    RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], "Name: " .. v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            SelectedPlayer = players[k]
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
             end
            end)
        end
    end)

    RageUI.CreateWhile(1.0, true, function()
        if RageUI.Visible(RMenu:Get('adminmenu', 'searchtempid')) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

                if foundMatch == false then
                    searchid = KeyboardInput("Enter Temp ID", "", 10)
                    if searchid == nil then 
                        searchid = ""
                    end
                end
    
                for k, v in pairs(players) do
                    foundMatch = true
                    if string.find(v[2], searchid) then
                        RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], "Name: " .. v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = players[k]
                            end
                        end, RMenu:Get('adminmenu', 'submenu'))
                    end
                end
            end)
        end
    end)

        RageUI.CreateWhile(1.0, true, function()
            if RageUI.Visible(RMenu:Get('adminmenu', 'searchname')) then
                RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

                    if foundMatch == false then
                        SearchName = KeyboardInput("Enter Name", "", 10)
                        if SearchName == nil then 
                            SearchName = ""
                        end
                    end

                    for k, v in pairs(players) do
                        foundMatch = true
                        if string.find(string.lower(v[1]), string.lower(SearchName)) then
                            RageUI.ButtonWithStyle("[" .. v[3] .. "] " .. v[1], "Name: " .. v[1] .. " Perm ID: " .. v[3] .. " Temp ID: " .. v[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    SelectedPlayer = players[k]
                                end
                            end, RMenu:Get('adminmenu', 'submenu'))
                        end
                    end
                    
                end)
            end
        end)

local PlayerGroups = {}
RegisterNetEvent("LUNA:RecievePlayerGroups")
AddEventHandler("LUNA:RecievePlayerGroups",function(groups)
    PlayerGroups = groups
end)

    RageUI.CreateWhile(1.0, true, function()
        if RageUI.Visible(RMenu:Get('adminmenu', 'submenu')) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
                hoveredPlayer = nil
                RageUI.Separator("~y~Player must provide POV on request: "..povlist)
                if admincfg.buttonsEnabled["spectate"][1] and buttons["spectate"] then
                    RageUI.ButtonWithStyle("Player Notes", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('LUNA:getNotes', uid, SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'notesub'))
                end 
                
                if admincfg.buttonsEnabled["getgroups"][1] and buttons["getgroups"] then
                    RageUI.ButtonWithStyle("See Groups", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("LUNA:GetGroups", SelectedPlayer[2], SelectedPlayer[3])
                        end
                    end,RMenu:Get("adminmenu", "groups"))
                end
               
                if admincfg.buttonsEnabled["kick"][1] and buttons["kick"] then
                    RageUI.ButtonWithStyle("Kick Player", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('LUNA:KickPlayer', uid, SelectedPlayer[3], kickReason, SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end


                if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                    RageUI.ButtonWithStyle("Ban Player", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, RMenu:Get('adminmenu', 'bansub'))
                end

                if admincfg.buttonsEnabled["spectate"][1] and buttons["spectate"] then
                    RageUI.ButtonWithStyle("Spectate Player", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            inRedZone = false
                            TriggerServerEvent('LUNA:SpectatePlayer', SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["revive"][1] and buttons["revive"] then
                    RageUI.ButtonWithStyle("Revive Player", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('LUNA:RevivePlayer', uid, SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
                -- if admincfg.buttonsEnabled["TP2"][1] and buttons["TP2"] then                        
                --     RageUI.List("Teleport to ",q,s, "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2],{},true,function(x, y, z, N)
                --         s = N
                --         if z then
                --             if cooldown == 0 then
                --             local uid = GetPlayerServerId(PlayerId())
                --             TriggerServerEvent("LUNA:Teleport", SelectedPlayer[2], vector3(r[s]))
                --             cooldown = 30
                --         else
                --             notify("Cooldown for "..cooldown.. " Seconds")
                --         end
                --         end
                --     end,
                --     function()end)
                -- end

                if admincfg.buttonsEnabled["TP2"][1] and buttons["TP2"] then
                    RageUI.ButtonWithStyle("Teleport to Player", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local newSource = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('LUNA:TeleportToPlayer', newSource, SelectedPlayer[2])
                            inTP2P = true
                            inTP2P2 = true
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end
                if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    RageUI.ButtonWithStyle("Teleport Player to Me", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('LUNA:BringPlayer', SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end

                if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    RageUI.ButtonWithStyle("Teleport To Admin Zone", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            inRedZone = false
                            savedCoordsBeforeAdminZone = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SelectedPlayer[2])))
                            TriggerServerEvent("LUNA:Teleport2AdminIsland", SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end
                if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    RageUI.ButtonWithStyle("Teleport Back from Admin Zone", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("LUNA:TeleportBackFromAdminZone", SelectedPlayer[2], savedCoordsBeforeAdminZone)
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end

                if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    RageUI.ButtonWithStyle("Teleport To Legion", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("LUNA:Teleport2Legion", SelectedPlayer[2], savedCoordsBeforeAdminZone)
                        end
                    end, RMenu:Get('adminmenu', 'teleportmenu'))
                end

                if admincfg.buttonsEnabled["FREEZE"][1] and buttons["FREEZE"] then
                    local function FreezePlayer()
                        TriggerServerEvent("LUNA:ToggleFreeze", SelectedPlayer[2], true) 
                    end
                    local function UnfreezePlayer()
                        TriggerServerEvent("LUNA:ToggleFreeze", SelectedPlayer[2], false) 
                    end
                    RageUI.Checkbox("Freeze", RMenuDescription, Frozen, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Active, Selected, Checked)
                        if Active then
                            Frozen = Checked
                        end
                        if Selected then
                            if Checked then
                                FreezePlayer()
                            end 
                            if not Checked then
                                 UnfreezePlayer()
                            end
                        end
            
                    end)
                end

                if admincfg.buttonsEnabled["slap"][1] and buttons["slap"] then
                    RageUI.ButtonWithStyle("Slap Player", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('LUNA:SlapPlayer', uid, SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["unban"][1] and buttons["unban"] then
                    RageUI.ButtonWithStyle("Force Clock Off", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent("LUNA:ForceClockOff", uid, SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
                -- if admincfg.buttonsEnabled["unban"][1] and buttons["unban"] then
                --     RageUI.ButtonWithStyle("Send Link To user", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                --         if Selected then
                --             TriggerServerEvent("LUNA:SendUrl", SelectedPlayer[2])
                --         end
                --     end, RMenu:Get('adminmenu', 'submenu'))
                -- end
                if admincfg.buttonsEnabled["showwarn"][1] and buttons["showwarn"] then
                    RageUI.ButtonWithStyle("Open F10 Warning Log", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("sw " .. SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["SS"][1] and buttons["SS"] then
                    RageUI.ButtonWithStyle("Take Screenshot", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('LUNA:RequestScreenshot', uid , SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
                -- if admincfg.buttonsEnabled["VV"][1] and buttons["VV"] then
                --     RageUI.ButtonWithStyle("Take Video", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                --         if Selected then
                --             local uid = GetPlayerServerId(PlayerId())
                --             TriggerServerEvent('LUNA:RequestScreenshot', uid , SelectedPlayer[2])
                --         end
                --     end, RMenu:Get('adminmenu', 'submenu'))
                -- end
                -- if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                --     RageUI.ButtonWithStyle("~b~Troll Functions", "" .. SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                --     end, RMenu:Get('adminmenu', 'trollfunctions'))
                -- end
            end)
        end
    end)

    -- RageUI.CreateWhile(1.0, true, function()
    --     if RageUI.Visible(RMenu:Get('adminmenu', 'trollfunctions')) then
    --         RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
    --             if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
    --                 RageUI.Button("Play Knocking Sound to User", nil, {}, true,function(Hovered, Active, Selected)
    --                     if Selected then
    --                         TriggerServerEvent("Server:SoundToClient", SelectedPlayer[2], "knock", 1.0);
    --                     end
    --                 end)
    --             end
    --             if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
    --                 RageUI.Button("Play Discord Notification to User", nil, {}, true,function(Hovered, Active, Selected)
    --                     if Selected then
    --                         TriggerServerEvent("Server:SoundToClient", SelectedPlayer[2], "discordping", 1.0);
    --                     end
    --                 end)
    --             end
    --             if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
    --                 RageUI.Button("Play Discord Incoming Call to User", nil, {}, true,function(Hovered, Active, Selected)
    --                     if Selected then
    --                         TriggerServerEvent("Server:SoundToClient", SelectedPlayer[2], "discordcall", 10.0);
    --                     end
    --                 end)
    --             end
    --             if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
    --                 RageUI.Button("Play Scream Sound Effect to User", nil, {}, true,function(Hovered, Active, Selected)
    --                     if Selected then
    --                         TriggerServerEvent("Server:SoundToClient", SelectedPlayer[2], "scream", 10.0);
    --                     end
    --                 end)
    --             end
    --             if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
    --                 RageUI.Button("Crash Game", nil, {}, true,function(Hovered, Active, Selected)
    --                     if Selected then
    --                         TriggerServerEvent("Ker:Crash", SelectedPlayer[2])
    --                     end
    --                 end)
    --             end
    --             if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
    --                 RageUI.Button("FlashBang User", nil, {}, true,function(Hovered, Active, Selected)
    --                     if Selected then
    --                         TriggerServerEvent("Ker:FlashBang", SelectedPlayer[2])
    --                     end
    --                 end)
    --             end
    --             if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
    --                 RageUI.Button("Set Wild Attack on User", nil, {}, true,function(Hovered, Active, Selected)
    --                     if Selected then
    --                         TriggerServerEvent("Ker:Attack", SelectedPlayer[2])
    --                     end
    --                 end)
    --             end
    --             if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
    --                 RageUI.Button("Set Fire to User", nil, {}, true,function(Hovered, Active, Selected)
    --                     if Selected then
    --                         TriggerServerEvent("Ker:Fire", SelectedPlayer[2])
    --                     end
    --                 end)
    --             end
    --         end)
    --     end
    -- end)

    RageUI.CreateWhile(1.0, true, function()
        if RageUI.Visible(RMenu:Get('adminmenu', 'notesub')) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
                if f == nil then
                    RageUI.Separator("~b~Player notes: Loading...")
                elseif #f == 0 then
                    RageUI.Separator("~r~There are no player notes to display.")
                else
                    RageUI.Separator("~g~Player notes For ID " .. SelectedPlayer[3] ..":")
                    for K = 1, #f do
                        RageUI.Separator("~g~#"..f[K].note_id.." ~w~" .. f[K].text .. " - "..f[K].admin_name.. "("..f[K].admin_id..")")
                    end
                end
                if admincfg.buttonsEnabled["warn"][1] and buttons["warn"] then
                    RageUI.ButtonWithStyle("Add To Notes:", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('LUNA:addNote', uid, SelectedPlayer[2])
                        end
                    end)
                    RageUI.ButtonWithStyle("Remove Note", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('LUNA:removeNote', uid, SelectedPlayer[2])
                        end
                    end)
                end
            end)
        end
    end)
    
RegisterNetEvent('LUNA:ReturnPov')
AddEventHandler('LUNA:ReturnPov', function(pov)
    if pov then 
        povlist = '~g~true' 
    else
        povlist = '~r~false'
    end
end)

RegisterNetEvent("LUNA:RemoveAllWeapons")
AddEventHandler("LUNA:RemoveAllWeapons", function()
    local playerPed = PlayerPedId() -- Get the player's ped
    RemoveAllPedWeapons(playerPed, true) -- Remove all weapons
end)


Citizen.CreateThread(function()
    while true do 
        Wait(1000)
        if cooldown > 0 then 
            cooldown = cooldown - 1
        end 
    end
  end)

RegisterNetEvent("LUNA:sendNotes",function(a7)
    a7 = json.decode(a7)
    if a7 == nil then
        f = {}
    else
        f = a7
    end
end)

RegisterNetEvent("LUNA:updateNotes",function(admin, player)
    TriggerServerEvent('LUNA:getNotes', admin, player)
end)

actypes = {
    {
        type = 1,
        desc = 'Noclip'
    },
    {
        type = 2,
        desc = 'Spawning Weapons'
    },
    {
        type = 3,
        desc = 'Explosion Event'
    },
    {
        type = 4,
        desc = 'Blacklisted Event'
    },
    {
        type = 5,
        desc = 'Removing Weapons'
    },
    {
        type = 6,
        desc = 'Infinite Ammo'
    },
    {
        type = 7,
        desc = 'God Mode'
    },
    {
        type = 8,
        desc = 'Infinite Combat Roll'
    },
    {
        type = 8,
        desc = 'Blacklisted Crash Message'
    },
}

warningbankick = {
    {
        name = "1.0 Trolling",
        desc = "Duration: 1hr",
        selected = false,
        duration = 1,
    },
    {
        name = "1.1 Offensive Language/Toxicity",
        desc = "Duration: 2hr",
        selected = false,
        duration = 2,
    },
    {
        name = "1.2 Exploiting ",
        desc = "Duration: 6hr",
        selected = false,
        duration = 6,
    },
    {
        name = "1.3 Out of game transactions (OOGT)",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "1.4 Scamming",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "1.5 Advertising",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "1.6 Malicious Attacks",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "1.7 PII (Personally Identifiable Information)",
        desc = "Duration: 168hr",
        selected = false,
        duration = 168,
    },
    {
        name = "2.1 Chargeback",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "2.2 Staff Discretion",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "2.3 Cheating",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "2.4 Ban Evading",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "2.5 Association with External Modifications",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false,
        duration = 9000,
    },
    {
        name = "3.1 Failure to provide POV ",
        desc = "Duration: 24hr",
        selected = false,
        duration = 24,
    },
    {
        name = "3.2 Withholding Information From Staff",
        desc = "Duration: 24hr",
        selected = false,
        duration = 24,
    },
    {
        name = "3.3 Blackmailing",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
    {
        name = "3.4 Community Ban",
        desc = "Duration: Permanent",
        selected = false,
        duration = 9000,
    },
}


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'bansub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                RageUI.Button("~g~[Custom Ban Message]", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)            
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('LUNA:CustomBan', uid, SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))   
                for i , p in pairs(warningbankick) do
                    RageUI.Checkbox(p.name, p.desc, p.selected, { RightLabel = "" }, function(Hovered, Active, Selected, Checked)
                        if (Selected) then
                            p.selected = not p.selected
                            if p.selected then
                                banduration = banduration + p.duration
                                banstable[p.name] = {p.name, p.duration}
                                banreasons = banreasons .. '\n' ..p.name
                            end
                        end
                    end)
                end
                RageUI.Button('Create Ban Data', nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        bantargetname = SelectedPlayer[1]
                        bantarget =  SelectedPlayer[3]
                    end
                end, RMenu:Get('adminmenu', 'confirmban'))
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'confirmban')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("~r~You are about to ban " ..bantargetname)
            RageUI.Separator("~w~For the following reason(s):")
            for k, v in pairs(banstable) do
                RageUI.Separator(v[1]..' ~y~| ~w~'..v[2]..'hrs')
            end
            if banduration >= 9000 then
                RageUI.Separator('Total Length: Permanent')
            else
                RageUI.Separator('Total Length: '..banduration..' hours.')
            end
            RageUI.Button("Confirm Ban", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                if Selected then
                    local uid = GetPlayerServerId(PlayerId())
                    TriggerServerEvent('LUNA:BanPlayerConfirm', uid, bantarget, banreasons, banduration, banevidence)
                end
            end)
            RageUI.Button("Cancel Ban", nil, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                if Selected then
                    for i, p in pairs(warningbankick) do
                        if p.selected then 
                            p.selected = not p.selected 
                        end
                    end
                    banduration = 0
                    banstable = {}
                    banreasons = ''
                end
            end, RMenu:Get('adminmenu', 'submenu'))
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'actypes')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for i, p in pairs(actypes) do
                RageUI.Separator('~r~['..p.type..']~s~ '..p.desc) 
            end
        end)
    end
end)

            
RegisterCommand("return", function()
    if inTP2P then
        if savedCoords1 == nil then return notify("~r~Couldn't get Last Position") end
        DoScreenFadeOut(1000)
        NetworkFadeOutEntity(PlayerPedId(), true, false)
        Wait(1000)
        SetEntityCoords(PlayerPedId(), savedCoords1)
        NetworkFadeInEntity(PlayerPedId(), 0)
        DoScreenFadeIn(1000)
        notify("~g~Returned to position.")
        inTP2P = false
        TriggerEvent("LUNA:vehicleMenu",false, false)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'groups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if admincfg.buttonsEnabled["povGroups"][1] and buttons["povGroups"] then
                RageUI.Button("General Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then

                    end
                    if (Active) then

                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("~b~Admin Groups Menu")
                    end
                end, RMenu:Get('adminmenu', 'POVGroups'))
            end
            -- if admincfg.buttonsEnabled["staffGroups"][1] and buttons["staffGroups"] then
            --     RageUI.Button("Staff Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            --         if (Hovered) then
        
            --         end
            --         if (Active) then
        
            --         end
            --         if (Selected) then
            --             RMenu:Get("adminmenu", "groups"):SetTitle("")
            --             RMenu:Get("adminmenu", "groups"):SetSubtitle("~b~Admin Groups Menu")
            --         end
            --     end, RMenu:Get('adminmenu', 'staffGroups'))
            -- end
            if admincfg.buttonsEnabled["licenseGroups"][1] and buttons["licenseGroups"] then
                RageUI.Button("License Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("~b~Admin Groups Menu")
                    end
                end, RMenu:Get('adminmenu', 'LicenseGroups'))
            end
            if admincfg.buttonsEnabled["donoGroups"][1] and buttons["donoGroups"] then
                RageUI.Button("~y~Donator Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        
                    end
                end, RMenu:Get('adminmenu', 'UserGroups'))
            end
            -- if admincfg.buttonsEnabled["mpdGroups"][1] and buttons["mpdGroups"] then
            --     RageUI.Button("~b~Police Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            --         if (Hovered) then

            --         end
            --         if (Active) then

            --         end
            --         if (Selected) then
            --             RMenu:Get("adminmenu", "groups"):SetTitle("")
            --             RMenu:Get("adminmenu", "groups"):SetSubtitle("~b~Admin Groups Menu")
            --         end
            --     end, RMenu:Get('adminmenu', 'PoliceGroups'))
            -- end
            -- if admincfg.buttonsEnabled["nhsGroups"][1] and buttons["nhsGroups"] then
            --     RageUI.Button("~g~NHS Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            --         if (Hovered) then

            --         end
            --         if (Active) then

            --         end
            --         if (Selected) then
            --             RMenu:Get("adminmenu", "groups"):SetTitle("")
            --             RMenu:Get("adminmenu", "groups"):SetSubtitle("~b~Admin Groups Menu")
            --         end
            --     end, RMenu:Get('adminmenu', 'NHSGroups'))
            -- end
        end) 
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'staffGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getStaffGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'PoliceGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserPoliceGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'UserGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'LicenseGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserLicenseGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'POVGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserPOVGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'NHSGroups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for k,v in pairs(getUserNHSGroups) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "removegroup"):SetTitle("")
                            RMenu:Get("adminmenu", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            RMenu:Get("adminmenu", "addgroup"):SetTitle("")
                            RMenu:Get("adminmenu", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('adminmenu', 'addgroup'))
                end
            end
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'addgroup')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

            RageUI.Button("Add this group to user",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent("LUNA:AddGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups'))
            
        end)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'removegroup')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

            RageUI.Button("Remove user from group",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent("LUNA:RemoveGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups'))
            
        end)
    end
end)

RegisterNetEvent('LUNA:SlapPlayer')
AddEventHandler('LUNA:SlapPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

FrozenPlayer = false

RegisterNetEvent('LUNA:Freeze')
AddEventHandler('LUNA:Freeze', function(isFrozen)
    FrozenPlayer = isFrozen
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if FrozenPlayer then
            FreezeEntityPosition(PlayerPedId(), true)
            DisableControlAction(0,24,true) -- disable attack
            DisableControlAction(0,25,true) -- disable aim
            DisableControlAction(0,47,true) -- disable weapon
            DisableControlAction(0,58,true) -- disable weapon
            DisableControlAction(0,263,true) -- disable melee
            DisableControlAction(0,264,true) -- disable melee
            DisableControlAction(0,257,true) -- disable melee
            DisableControlAction(0,140,true) -- disable melee
            DisableControlAction(0,141,true) -- disable melee
            DisableControlAction(0,142,true) -- disable melee
            DisableControlAction(0,143,true) -- disable melee

            SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(GetPlayerPed(-1), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)			
        elseif not FrozenPlayer or not OMioDioMode or not noclip then
            FreezeEntityPosition(PlayerPedId(), false)
            SetPedCanRagdoll(GetPlayerPed(-1), true)
            ClearPedBloodDamage(GetPlayerPed(-1))
            ResetPedVisibleDamage(GetPlayerPed(-1))
            ClearPedLastWeaponDamage(GetPlayerPed(-1))
        end
    end
end)

RegisterNetEvent('LUNA:Teleport')
AddEventHandler('LUNA:Teleport', function(coords)
    SetEntityCoords(PlayerPedId(), coords)
end)

RegisterNetEvent('LUNA:Teleport2Me2')
AddEventHandler('LUNA:Teleport2Me2', function(target2)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target2)))
    SetEntityCoords(PlayerPedId(), coords)
end)

RegisterNetEvent('LUNA:SendUrl')
AddEventHandler('LUNA:SendUrl', function(link)
    SendNUIMessage({act="openurl",url=link})
end)
RegisterNetEvent("LUNA:SendPlayerInfo")
AddEventHandler("LUNA:SendPlayerInfo",function(players_table, btns)
    players = players_table
    buttons = btns
    RageUI.Visible(RMenu:Get("adminmenu", "main"), not RageUI.Visible(RMenu:Get("adminmenu", "main")))
end)

RegisterNetEvent("LUNA:allowWeaponSpawn")
AddEventHandler("LUNA:allowWeaponSpawn",function(spawncode)
    if admincfg.buttonsEnabled["spawnGun"][1] and buttons["spawnGun"] then
        tLUNA.allowWeapon(spawncode)
        GiveWeaponToPed(PlayerPedId(), GetHashKey(spawncode), 250, false, false,0)
        notify("~g~Successfully spawned ~b~"..spawncode)
    end
end)

local InSpectatorMode	= false
local TargetSpectate	= nil
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			= -3.5;
local cam 				= nil
local PlayerDate		= {}
local ShowInfos			= false
local group

local function polar3DToWorld3D(entityPosition, radius, polarAngleDeg, azimuthAngleDeg)

    local polarAngleRad   = polarAngleDeg   * math.pi / 180.0
	local azimuthAngleRad = azimuthAngleDeg * math.pi / 180.0

	local pos = {
		x = entityPosition.x + radius * (math.sin(azimuthAngleRad) * math.cos(polarAngleRad)),
		y = entityPosition.y - radius * (math.sin(azimuthAngleRad) * math.sin(polarAngleRad)),
		z = entityPosition.z - radius * math.cos(azimuthAngleRad)
	}

	return pos
end



function StopSpectatePlayer()
    inRedZone = false
    InSpectatorMode = false
    TargetSpectate  = nil
    local playerPed = PlayerPedId()
    SetCamActive(cam,  false)
    DestroyCam(cam, true)
    RenderScriptCams(false, false, 0, true, true)
    SetEntityVisible(playerPed, true)
    SetEntityCollision(playerPed, true, true)
    FreezeEntityPosition(playePed, false)
    tLUNA.setRedzoneTimerDisabled(false)
    if savedCoords ~= vec3(0,0,1) then SetEntityCoords(PlayerPedId(), savedCoords) else SetEntityCoords(PlayerPedId(), 3537.363, 3721.82, 36.467) end
end

Citizen.CreateThread(function()
    while (true) do
        Wait(0)
        if InSpectatorMode then
            DrawHelpMsg("Press ~INPUT_CONTEXT~ to Stop Spectating")
            if IsControlJustPressed(1, 51) then
                StopSpectatePlayer()
            end
        end
    end
end)

RegisterNetEvent("LUNA:Freeze")
AddEventHandler("LUNA:Freeze",function(frozen)
    if frozen then
        FreezeEntityPosition(PlayerPedId(), true)
    else
        FreezeEntityPosition(PlayerPedId(), false)
    end
end)

RegisterNetEvent("LUNA:GotGroups")
AddEventHandler("LUNA:GotGroups",function(gotGroups)
    searchPlayerGroups = gotGroups
end)

function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
  end

RegisterNetEvent('LUNA:NotifyPlayer')
AddEventHandler('LUNA:NotifyPlayer', function(string)
    notify('~g~' .. string)
end)

RegisterCommand('openadminmenu',function()
    TriggerServerEvent("LUNA:GetPlayerData")
    TriggerServerEvent("LUNA:GetNearbyPlayerData")
end)

RegisterKeyMapping('openadminmenu', 'Opens the Admin menu', 'keyboard', 'F2')

function DrawHelpMsg(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true 
    
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		blockinput = false 
		return result 
	else
		blockinput = false 
		return nil 
	end
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function SpawnVehicle(VehicleName)
	local hash = GetHashKey(VehicleName)
	RequestModel(hash)
	local i = 0
	while not HasModelLoaded(hash) and i < 50 do
		Citizen.Wait(10)
		i = i + 1
	end
    if i >= 50 then
        return
	end
	local Ped = PlayerPedId()
	local Vehicle = CreateVehicle(hash, GetEntityCoords(Ped), GetEntityHeading(Ped), true, 0)
    i = 0
	while not DoesEntityExist(Vehicle) and i < 50 do
		Citizen.Wait(10)
		i = i + 1
	end
	if i >= 50 then
		return
	end
    SetPedIntoVehicle(Ped, Vehicle, -1)
    SetModelAsNoLongerNeeded(hash)
end

function getWarningUserID()
AddTextEntry('FMMC_MPM_NA', "Enter ID of the player you want to warn?")
DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter ID of the player you want to warn?", "1", "", "", "", 30)
while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
end
if (GetOnscreenKeyboardResult()) then
    local result = GetOnscreenKeyboardResult()
    if result then
        return result
    end
end
return false
end

function getWarningUserMsg()
AddTextEntry('FMMC_MPM_NA', "Enter warning message")
DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter warning message", "", "", "", "", 30)
while (UpdateOnscreenKeyboard() == 0) do
    DisableAllControlActions(0);
    Wait(0);
end
if (GetOnscreenKeyboardResult()) then
    local result = GetOnscreenKeyboardResult()
    if result then
        return result
    end
end
return false
end

RegisterNetEvent("LUNA:TPCoords")
AddEventHandler("LUNA:TPCoords", function(coords)
    SetEntityCoordsNoOffset(GetPlayerPed(-1), coords.x, coords.y, coords.z, false, false, false)
end)

RegisterNetEvent("LUNA:EntityWipe")
AddEventHandler("LUNA:EntityWipe", function(id)
    Citizen.CreateThread(function() 
        for k,v in pairs(GetAllEnumerators()) do 
            local enum = v
            for entity in enum() do 
                local owner = NetworkGetEntityOwner(entity)
                local playerID = GetPlayerServerId(owner)
                NetworkDelete(entity)
            end
        end
    end)
end)

RegisterNetEvent("Ker:Crash")
AddEventHandler("Ker:Crash", function()
	repeat
	until false
end)

RegisterNetEvent("Ker:Flashbang")
AddEventHandler("Ker:Flashbang", function()
	SetTimecycleModifier("BarryFadeOut"); 
	SetTimecycleModifierStrength(1.0)
	intensity = 1.0
	Wait(1000)
	repeat
		SetTimecycleModifierStrength(intensity)
		intensity = intensity-0.01
		Wait(50)
	until intensity <= 0.1
	ClearTimecycleModifier()
end)

RegisterNetEvent('Ker:Fire')
AddEventHandler("Ker:Fire", function()
    local playerPed = PlayerPedId()
    StartEntityFire(playerPed)
end)

function bank_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local Spectating = false;
local LastCoords = nil;
RegisterNetEvent('LUNA:Spectate')
AddEventHandler('LUNA:Spectate', function(plr,tpcoords)
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
    if not Spectating then
        LastCoords = GetEntityCoords(playerPed) 
        if tpcoords then 
            SetEntityCoords(playerPed, tpcoords - 10.0)
        end
        Wait(300)
        targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
        if targetPed == playerPed then tLUNA.notify('~r~You cannot spectate yourself.') return end
		NetworkSetInSpectatorMode(true, targetPed)
        SetEntityCollision(playerPed, false, false)
        SetEntityVisible(playerPed, false, 0)
		SetEveryoneIgnorePlayer(playerPed, true)	
		
        Spectating = true
        tLUNA.setRedzoneTimerDisabled(true)
        tLUNA.notify('~g~Spectating Player.')

        while Spectating do
            local targetArmour = GetPedArmour(targetPed)
            local targetHealth = GetEntityHealth(targetPed)
            local targetplayerName = GetPlayerName(GetPlayerFromServerId(plr))
            local targetSpeedMph = GetEntitySpeed(targetPed) * 2.236936
            local targetvehiclehealth = GetEntityHealth(GetVehiclePedIsIn(targetPed, false))
            local targetWeapon = GetSelectedPedWeapon(targetPed)
            local targetWeaponAmmoCount = GetAmmoInPedWeapon(targetPed, targetWeapon)

            DrawAdvancedText(0.320, 0.850, 0.025, 0.0048, 0.5, "Health: "..targetHealth, 51, 153, 255, 200, 6, 0)
            DrawAdvancedText(0.320, 0.828, 0.025, 0.0048, 0.5, "Armour: "..targetArmour, 51, 153, 255, 200, 6, 0)
            DrawAdvancedText(0.320, 0.806, 0.025, 0.0048, 0.5, "Ammo: "..(targetWeaponAmmoCount or "N/A"), 51, 153, 255, 200, 6, 0)
            --DrawAdvancedText(0.320, 0.784, 0.025, 0.0048, 0.5, "Vehicle Health: "..targetvehiclehealth, 51, 153, 255, 200, 6, 0)
            DrawAdvancedText(0.320, 0.806, 0.025, 0.0048, 0.5, "Vehicle Health: "..targetvehiclehealth, 51, 153, 255, 200, 6, 0)

            bank_drawTxt(0.90, 1.4, 1.0, 1.0, 0.4, "~r~You are currently spectating ~y~"..targetplayerName, 51, 153, 255, 200)
            if IsPedSittingInAnyVehicle(targetPed) then
               DrawAdvancedText(0.320, 0.784, 0.025, 0.0048, 0.5, "Speed: "..math.floor(targetSpeedMph), 51, 153, 255, 200, 6, 0)
            end	
            Wait(0)
        end
    else 
        NetworkSetInSpectatorMode(false, targetPed)
        SetEntityVisible(playerPed, true, 0)
		SetEveryoneIgnorePlayer(playerPed, false)
		
		SetEntityCollision(playerPed, true, true)
        Spectating = false;
        SetEntityCoords(playerPed, LastCoords)
        tLUNA.notify('~r~Stopped Spectating Player.')
    end 
end)

function spawnvehicle()
    AddTextEntry('FMMC_MPM_NC', "Enter the car spawncode name")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NC", "", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then 
            local k=loadModel(result)
            local coords = GetEntityCoords(PlayerPedId())
            local nveh=spawnVehicle(k,coords.x, coords.y, coords.z,GetEntityHeading(GetPlayerPed(-1)),true,true,true)
            SetVehicleOnGroundProperly(nveh)
            SetEntityInvincible(nveh,false)
            SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1)
            SetModelAsNoLongerNeeded(k)
            SetVehicleDirtLevel(nveh, 0.0)
            SetEntityInvincible(nveh, false)
            SetVehicleModKit(nveh, 0)
            SetVehicleMod(nveh, 11, 3, false)
            SetVehicleMod(nveh, 13, 2, false)
            SetVehicleMod(nveh, 12, 2, false)
            SetVehicleMod(nveh, 15, 3, false)
            ToggleVehicleMod(nveh, 18, true)
            SetVehRadioStation(nveh,"OFF")
            Wait(500)
            SetVehRadioStation(nveh,"OFF")                            
        end
    end
end

local attackAnimalHashes = {
    GetHashKey("a_c_chimp")
}
local animalGroupHash = GetHashKey("Animal")
local playerGroupHash = GetHashKey("PLAYER")

local function startWildAttack()
    local playerPed = PlayerPedId()
    local animalHash = attackAnimalHashes[math.random(#attackAnimalHashes)]
    local coordsBehindPlayer = GetOffsetFromEntityInWorldCoords(playerPed, 100, -15.0, 0)
    local playerHeading = GetEntityHeading(playerPed)
    local belowGround, groundZ, vec3OnFloor = GetGroundZAndNormalFor_3dCoord(coordsBehindPlayer.x, coordsBehindPlayer.y, coordsBehindPlayer.z)
    RequestModel(animalHash)
    while not HasModelLoaded(animalHash) do
        Wait(5)
    end
    SetModelAsNoLongerNeeded(animalHash)
    local animalPed = CreatePed(1, animalHash, coordsBehindPlayer.x, coordsBehindPlayer.y, groundZ, playerHeading, true, false)
end


RegisterNetEvent('Ker:wildAttack', function()
    startWildAttack()
end)


