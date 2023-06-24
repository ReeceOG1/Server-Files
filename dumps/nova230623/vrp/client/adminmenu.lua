vRPclient = Tunnel.getInterface("vRP","vRP")

local user_id = 0

local foundMatch = false
local inSpectatorAdminMode = false
local players = {}
local playersNearby = {}
local searchPlayerGroups = {}
local selectedGroup
local Groups = {}
local povlist = nil
local SelectedPerm = nil
local hoveredPlayer = nil
local a = module("cfg/cfg_settings")


admincfg = {}

admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false

local tpLocationColour = '~b~'
local q = {tpLocationColour.."Legion", tpLocationColour.."Mission Row", tpLocationColour.."Sandy PD", tpLocationColour.."License Centre", tpLocationColour.."Airport", tpLocationColour.."Rebel Diner", tpLocationColour.."VIP Island", tpLocationColour.."St Thomas", tpLocationColour.."Casino"}
local r = {
    vector3(151.61740112305,-1035.05078125,29.339416503906),
    vector3(444.96252441406,-983.07598876953,30.689311981201),
    vector3(1839.3137207031, 3671.0014648438, 34.310436248779),
    vector3(-551.08221435547, -194.19259643555, 38.219661712646),
    vector3(-1142.0673828125, -2851.802734375, 13.94624710083),
    vector3(1588.3441162109, 6439.3696289063, 25.123600006104),
    vector3(-2172.2595214844, 5140.984375, 2.819997549057),
    vector3(364.86236572266,-590.99975585938,28.690246582031),
    vector3(923.24499511719,48.181098937988,81.106323242188),
}
local s = 1

WeaponFindArray = {
[tostring(GetHashKey('WEAPON_UNARMED'))] = 'Fists',
[tostring(GetHashKey('WEAPON_KNIFE'))] = 'Knife',
[tostring(GetHashKey('WEAPON_NIGHTSTICK'))] = 'Nightstick',
[tostring(GetHashKey('WEAPON_HAMMER'))] = 'Hammer',
[tostring(GetHashKey('WEAPON_BAT'))] = 'Baseball Bat',
[tostring(GetHashKey('WEAPON_GOLFCLUB'))] = 'Golf Club',
[tostring(GetHashKey('WEAPON_CROWBAR'))] = 'Crowbar',
[tostring(GetHashKey('WEAPON_PISTOL'))] = 'Pistol',
[tostring(GetHashKey('WEAPON_COMBATPISTOL'))] = 'Combat Pistol',
[tostring(GetHashKey('WEAPON_APPISTOL'))] = 'AP Pistol',
[tostring(GetHashKey('WEAPON_PISTOL50'))] = 'Pistol .50',
[tostring(GetHashKey('WEAPON_MICROSMG'))] = 'Micro SMG',
[tostring(GetHashKey('WEAPON_SMG'))] = 'SMG',
[tostring(GetHashKey('WEAPON_ASSAULTSMG'))] = 'Assault SMG',
[tostring(GetHashKey('WEAPON_ASSAULTRIFLE'))] = 'Assault Rifle',
[tostring(GetHashKey('WEAPON_CARBINERIFLE'))] = 'Carbine Rifle',
[tostring(GetHashKey('WEAPON_ADVANCEDRIFLE'))] = 'Advanced Rifle',
[tostring(GetHashKey('WEAPON_MG'))] = 'MG',
[tostring(GetHashKey('WEAPON_COMBATMG'))] = 'Combat MG',
[tostring(GetHashKey('WEAPON_PUMPSHOTGUN'))] = 'Pump Shotgun',
[tostring(GetHashKey('WEAPON_SAWNOFFSHOTGUN'))] = 'Sawed-Off Shotgun',
[tostring(GetHashKey('WEAPON_ASSAULTSHOTGUN'))] = 'Assault Shotgun',
[tostring(GetHashKey('WEAPON_BULLPUPSHOTGUN'))] = 'Bullpup Shotgun',
[tostring(GetHashKey('WEAPON_SNIPERRIFLE'))] = 'Sniper Rifle',
[tostring(GetHashKey('WEAPON_HEAVYSNIPER'))] = 'Heavy Sniper',
[tostring(GetHashKey('WEAPON_REMOTESNIPER'))] = 'Remote Sniper',
[tostring(GetHashKey('WEAPON_GRENADELAUNCHER'))] = 'Grenade Launcher',
[tostring(GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE'))] = 'Smoke Grenade Launcher',
[tostring(GetHashKey('WEAPON_RPG'))] = 'RPG',
[tostring(GetHashKey('WEAPON_PASSENGER_ROCKET'))] = 'Passenger Rocket',
[tostring(GetHashKey('WEAPON_AIRSTRIKE_ROCKET'))] = 'Airstrike Rocket',
[tostring(GetHashKey('WEAPON_STINGER'))] = 'Stinger [Vehicle]',
[tostring(GetHashKey('WEAPON_MINIGUN'))] = 'Minigun',
[tostring(GetHashKey('WEAPON_GRENADE'))] = 'Grenade',
[tostring(GetHashKey('WEAPON_STICKYBOMB'))] = 'Sticky Bomb',
[tostring(GetHashKey('WEAPON_SMOKEGRENADE'))] = 'Tear Gas',
[tostring(GetHashKey('WEAPON_BZGAS'))] = 'BZ Gas',
[tostring(GetHashKey('WEAPON_MOLOTOV'))] = 'Molotov',
[tostring(GetHashKey('WEAPON_FIREEXTINGUISHER'))] = 'Fire Extinguisher',
[tostring(GetHashKey('WEAPON_PETROLCAN'))] = 'Jerry Can',
[tostring(GetHashKey('OBJECT'))] = 'Object',
[tostring(GetHashKey('WEAPON_BALL'))] = 'Ball',
[tostring(GetHashKey('WEAPON_FLARE'))] = 'Flare',
[tostring(GetHashKey('VEHICLE_WEAPON_TANK'))] = 'Tank Cannon',
[tostring(GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET'))] = 'Rockets',
[tostring(GetHashKey('VEHICLE_WEAPON_PLAYER_LASER'))] = 'Laser',
[tostring(GetHashKey('AMMO_RPG'))] = 'Rocket',
[tostring(GetHashKey('AMMO_TANK'))] = 'Tank',
[tostring(GetHashKey('AMMO_SPACE_ROCKET'))] = 'Rocket',
[tostring(GetHashKey('AMMO_PLAYER_LASER'))] = 'Laser',
[tostring(GetHashKey('AMMO_ENEMY_LASER'))] = 'Laser',
[tostring(GetHashKey('WEAPON_RAMMED_BY_CAR'))] = 'Rammed by Car',
[tostring(GetHashKey('WEAPON_BOTTLE'))] = 'Bottle',
[tostring(GetHashKey('WEAPON_GUSENBERG'))] = 'Gusenberg Sweeper',
[tostring(GetHashKey('WEAPON_SNSPISTOL'))] = 'SNS Pistol',
[tostring(GetHashKey('WEAPON_VINTAGEPISTOL'))] = 'Vintage Pistol',
[tostring(GetHashKey('WEAPON_FLAREGUN'))] = 'Flare Gun',
[tostring(GetHashKey('WEAPON_HEAVYPISTOL'))] = 'Heavy Pistol',
[tostring(GetHashKey('WEAPON_SPECIALCARBINE'))] = 'Special Carbine',
[tostring(GetHashKey('WEAPON_MUSKET'))] = 'Musket',
[tostring(GetHashKey('WEAPON_FIREWORK'))] = 'Firework Launcher',
[tostring(GetHashKey('WEAPON_MARKSMANRIFLE'))] = 'Marksman Rifle',
[tostring(GetHashKey('WEAPON_HEAVYSHOTGUN'))] = 'Heavy Shotgun',
[tostring(GetHashKey('WEAPON_PROXMINE'))] = 'Proximity Mine',
[tostring(GetHashKey('WEAPON_HOMINGLAUNCHER'))] = 'Homing Launcher',
[tostring(GetHashKey('WEAPON_HATCHET'))] = 'Hatchet',
[tostring(GetHashKey('WEAPON_COMBATPDW'))] = 'Combat PDW',
[tostring(GetHashKey('WEAPON_KNUCKLE'))] = 'Knuckle Duster',
[tostring(GetHashKey('WEAPON_MARKSMANPISTOL'))] = 'Marksman Pistol',
[tostring(GetHashKey('WEAPON_MACHETE'))] = 'Machete',
[tostring(GetHashKey('WEAPON_MACHINEPISTOL'))] = 'Machine Pistol',
[tostring(GetHashKey('WEAPON_FLASHLIGHT'))] = 'Flashlight',
[tostring(GetHashKey('WEAPON_DBSHOTGUN'))] = 'Double Barrel Shotgun',
[tostring(GetHashKey('WEAPON_COMPACTRIFLE'))] = 'Compact Rifle',
[tostring(GetHashKey('WEAPON_SWITCHBLADE'))] = 'Switchblade',
[tostring(GetHashKey('WEAPON_REVOLVER'))] = 'Heavy Revolver',
[tostring(GetHashKey('WEAPON_FIRE'))] = 'Fire',
[tostring(GetHashKey('WEAPON_HELI_CRASH'))] = 'Heli Crash',
[tostring(GetHashKey('WEAPON_RUN_OVER_BY_CAR'))] = 'Run over by Car',
[tostring(GetHashKey('WEAPON_HIT_BY_WATER_CANNON'))] = 'Hit by Water Cannon',
[tostring(GetHashKey('WEAPON_EXHAUSTION'))] = 'Exhaustion',
[tostring(GetHashKey('WEAPON_EXPLOSION'))] = 'Explosion',
[tostring(GetHashKey('WEAPON_ELECTRIC_FENCE'))] = 'Electric Fence',
[tostring(GetHashKey('WEAPON_BLEEDING'))] = 'Bleeding',
[tostring(GetHashKey('WEAPON_DROWNING_IN_VEHICLE'))] = 'Drowning in Vehicle',
[tostring(GetHashKey('WEAPON_DROWNING'))] = 'Drowning',
[tostring(GetHashKey('WEAPON_BARBED_WIRE'))] = 'Barbed Wire',
[tostring(GetHashKey('WEAPON_VEHICLE_ROCKET'))] = 'Vehicle Rocket',
[tostring(GetHashKey('WEAPON_BULLPUPRIFLE'))] = 'Bullpup Rifle',
[tostring(GetHashKey('WEAPON_ASSAULTSNIPER'))] = 'Assault Sniper',
[tostring(GetHashKey('VEHICLE_WEAPON_ROTORS'))] = 'Rotors',
[tostring(GetHashKey('WEAPON_RAILGUN'))] = 'Railgun',
[tostring(GetHashKey('WEAPON_AIR_DEFENCE_GUN'))] = 'Air Defence Gun',
[tostring(GetHashKey('WEAPON_AUTOSHOTGUN'))] = 'Automatic Shotgun',
[tostring(GetHashKey('WEAPON_BATTLEAXE'))] = 'Battle Axe',
[tostring(GetHashKey('WEAPON_COMPACTLAUNCHER'))] = 'Compact Grenade Launcher',
[tostring(GetHashKey('WEAPON_MINISMG'))] = 'Mini SMG',
[tostring(GetHashKey('WEAPON_PIPEBOMB'))] = 'Pipebomb',
[tostring(GetHashKey('WEAPON_POOLCUE'))] = 'Poolcue',
[tostring(GetHashKey('WEAPON_WRENCH'))] = 'Wrench',
[tostring(GetHashKey('WEAPON_SNOWBALL'))] = 'Snowball',
[tostring(GetHashKey('WEAPON_ANIMAL'))] = 'Animal',
[tostring(GetHashKey('WEAPON_COUGAR'))] = 'Cougar',
[tostring(GetHashKey("WEAPON_STUNGUN"))] = 'Tazer',
[tostring(GetHashKey("WEAPON_FLASHLIGHT"))] = 'Flashligh',
[tostring(GetHashKey("WEAPON_NIGHTSTICK"))] = 'Baton',
[tostring(GetHashKey("WEAPON_MOLOTOV"))] = 'Molotov',
[tostring(GetHashKey("WEAPON_FIREEXTINGUISHER"))] = 'Fire Extinguisher',
[tostring(GetHashKey("WEAPON_PETROLCAN"))] = 'Petrol Can',
[tostring(GetHashKey("WEAPON_SPAR17"))] = 'Spar-17',
[tostring(GetHashKey("WEAPON_MXM"))] = 'MXM',
[tostring(GetHashKey("WEAPON_MK1EMR"))] = 'MK1-EMR',
[tostring(GetHashKey("WEAPON_UMP"))] = 'UMP-45',
[tostring(GetHashKey("WEAPON_MP5"))] = 'MP5',
[tostring(GetHashKey("WEAPON_UZI"))] = 'UZI',
[tostring(GetHashKey("WEAPON_SPAR16"))] = 'Spar-16',
[tostring(GetHashKey("WEAPON_BATON"))] = 'Baton',
[tostring(GetHashKey("WEAPON_BUTTERFLY"))] = 'Butterfly Knife',
[tostring(GetHashKey("WEAPON_SHANK"))] = 'Shnak',
[tostring(GetHashKey("WEAPON_TOILETBRUSH"))] = 'Toilet Brush',
[tostring(GetHashKey("WEAPON_CRUTCH"))] = 'Crutch',
[tostring(GetHashKey("WEAPON_GUITAR"))] = 'Guitar',
[tostring(GetHashKey("WEAPON_KITCHEN"))] = 'Kitchen Knife',
[tostring(GetHashKey("WEAPON_KASHNAR"))] = 'AK-74 Kashnar',
[tostring(GetHashKey("WEAPON_AK200"))] = 'AK-200',
[tostring(GetHashKey("WEAPON_AK74"))] = 'AK-74',
[tostring(GetHashKey("WEAPON_PQ15"))] = 'Anpq-15',
[tostring(GetHashKey("WEAPON_SIGMCX"))] = 'SIG-MCX',
[tostring(GetHashKey("WEAPON_GLOCK22"))] = 'Glock 22',
[tostring(GetHashKey("WEAPON_G36K"))] = 'G36K',
[tostring(GetHashKey("WEAPON_MOSIN"))] = 'Mosin Nagant',
[tostring(GetHashKey("WEAPON_REMINGTON870"))] = 'Remington-870',
[tostring(GetHashKey("WEAPON_WINCHESTER12"))] = 'Winchester-12',
[tostring(GetHashKey("WEAPON_GLOCK17"))] = 'Glock-17',
[tostring(GetHashKey("WEAPON_M1911"))] = 'M1911',
[tostring(GetHashKey("WEAPON_MAKAROV"))] = 'Makarov',
[tostring(GetHashKey("WEAPON_BARRET"))] = 'Barret M98',
[tostring(GetHashKey("WEAPON_SVD"))] = 'Dragnov SVD',
[tostring(GetHashKey("WEAPON_LR300"))] = 'Anarchy LR300',

[tostring(GetHashKey("WEAPON_BARRET50"))] = 'Barret .50Cal',
[tostring(GetHashKey("WEAPON_MSR"))] = 'Remington MSR',
[tostring(GetHashKey("WEAPON_SV98"))] = 'SV-98',

[tostring(GetHashKey("WEAPON_M4A1SDECIMATOR"))] = 'M4A1-S Decimator',
[tostring(GetHashKey("WEAPON_CNDYRIFLE"))] = 'Candy Rifle',
[tostring(GetHashKey("WEAPON_AUG"))] = 'AUG',
[tostring(GetHashKey("WEAPON_GRAU"))] = 'Grau',
[tostring(GetHashKey("WEAPON_VANDAL"))] = 'Reflective Vandal',
[tostring(GetHashKey("WEAPON_NV4"))] = 'NV4',
[tostring(GetHashKey("WEAPON_HONEYBADGER"))] = 'Honey Badger',
[tostring(GetHashKey("WEAPON_HK418"))] = 'HK-418',
[tostring(GetHashKey("WEAPON_SCORPBLUE"))] = 'Scorpion Blue',
[tostring(GetHashKey("WEAPON_PERFORATOR"))] = 'Perforator',
[tostring(GetHashKey("WEAPON_GUNGIRLDEAGLE"))] = 'Gun Girl Deagle',
[tostring(GetHashKey("WEAPON_KILLCONFIRMEDDEAGLE"))] = 'Kill Confirmed Deagle',
[tostring(GetHashKey("WEAPON_TINT"))] = 'White Tint Deagle',
[tostring(GetHashKey("WEAPON_ASIIMOVPISTOL"))] = 'Asiimov Pistol',

[tostring(GetHashKey("WEAPON_CARB2"))] = 'Carbon Rifle Mk2',
[tostring(GetHashKey("WEAPON_KARAMBIT"))] = 'Karambit Knife',
[tostring(GetHashKey("WEAPON_FNX45"))] = 'FNX 45',
[tostring(GetHashKey("WEAPON_FINN"))] = 'Adventure Time Pistol',
[tostring(GetHashKey("WEAPON_MIST"))] = 'Mist Splitter',
[tostring(GetHashKey("WEAPON_PPSH"))] = 'PPSH',
[tostring(GetHashKey("WEAPON_M4A1SSAGIRI"))] = 'M4A1 Sagiri',

[tostring(GetHashKey("WEAPON_HAHA"))] = 'Laughing 74-U',
[tostring(GetHashKey("WEAPON_HOWL"))] = 'M4A4 Howl',
[tostring(GetHashKey("WEAPON_GDEAGLE"))] = 'Golden Deagle',
[tostring(GetHashKey("WEAPON_PICK"))] = 'Diamond Pickaxe',
[tostring(GetHashKey("WEAPON_HOBBY"))] = 'Hobby Horse',
[tostring(GetHashKey("WEAPON_LIGHTSABER"))] = 'Lightsaber',
[tostring(GetHashKey("WEAPON_KATANA"))] = 'Thermal Katana',
[tostring(GetHashKey("WEAPON_SPHANTOM"))] = 'Singularity Phantom',
[tostring(GetHashKey("WEAPON_ADAGGER"))] = 'Ancient Dagger',
}


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
    ["slap"] = {true, "admin.slap"},
    ["armour"] = {true, "admin.special"},
    ["giveMoney"] = {true, "admin.givemoney"},
    ["addcar"] = {true, "admin.addcar"},

    --[[ Functions ]]
    ["tp2waypoint"] = {true, "admin.tp2waypoint"},
    ["tp2coords"] = {true, "admin.tp2coords"},
    ["removewarn"] = {true, "admin.removewarn"},
    ["spawnBmx"] = {true, "admin.spawnBmx"},
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

menuColour = '~w~'

RMenu.Add('adminmenu', 'main', RageUI.CreateMenu("", "~w~Admin Menu", 1300,100, "banners","admin"))

RMenu.Add("adminmenu", "players", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "closeplayers", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Interaction Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "searchoptions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Player Search Menu',1300,100,"banners","admin"))

--[[ Functions ]]
RMenu.Add("adminmenu", "functions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Admin Functions Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "entityfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Entity Functions Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "devfunctions", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "main"), "", menuColour..'Dev Functions Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "actypes", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "devfunctions"), "", menuColour..'AC Types',1300,100,"banners","admin"))
--[[ End of Functions ]]

RMenu.Add("adminmenu", "submenu", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Admin Player Interaction Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "searchname", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "searchtempid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "searchpermid", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "searchoptions"), "", menuColour..'Admin Player Search Menu',1300,100,"banners","adminmenu"))
RMenu.Add("adminmenu", "warnsub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Select Warn Reason',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "bansub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Select Ban Reason',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "notesub", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "players"), "", menuColour..'Player Notes',1300,100,"banners","admin"))

--[[group ]]
RMenu.Add("adminmenu", "groups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "submenu"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "staffGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "LicenseGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "UserGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "POVGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "PoliceGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "NHSGroups", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "addgroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))
RMenu.Add("adminmenu", "removegroup", RageUI.CreateSubMenu(RMenu:Get("adminmenu", "groups"), "", menuColour..'Admin Groups Menu',1300,100,"banners","admin"))

RMenu:Get('adminmenu', 'main')

local getStaffGroupsGroupIds = {
	["founder"] = "Founder",
    ["operationsmanager"] = "Operations Manager",
    ["staffmanager"] = "Staff Manager",
    ["commanager"] = "Community Manager",
    ["headadmin"] = "Head Admin",
    ["senioradmin"] = "Senior Admin",
    ["administrator"] = "Admin",
    ["srmoderator"] = "Senior Moderator",
	["moderator"] = "Moderator",
    ["supportteam"] = "Support Team",
    ["trialstaff"] = "Trial Staff",
    ["cardev"] = "Car Developer",
	["leaddev"] = "Lead Developer",
	["dev"] = "Developer",
	["TutorialDone"] = "Tutorial Done",
}
local getUserGroupsGroupIds = {
    ["VIP"] = "VIP",
    ["Supporter"] = "Supporter",
    ["Premium"] = "Premium",
    ["Supreme"] = "Supreme",
    ["Kingpin"] = "Kingpin",
    ["Rainmaker"] = "Rainmaker",
    ["Baller"] = "Baller",
    --["GANGWHITELIST"] = "Whitelisted Gang",

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
}

local getUserPoliceGroups = {
    ["Special Constable"] = "Special Constable",
    ["Commissioner"] = "Commissioner",
    ["Deputy Commissioner"] = "Deputy Commissioner",
    ["Assistant Commissioner"] = "Assistant Commissioner",
    ["Deputy Assistant Commissioner"] = "Deputy Assistant Commissioner",
    ["Commander"] = "Commander",
    ["Chief Superintendent"] = "Chief Superintendent",
    ["Superintendent"] = "Superintendent",
    ["ChiefInspector"] = "Chief Inspector",
    ["Inspector"] = "Inspector",
    ["Sergeant"] = "Sergeant",
    ["Senior Constable"] = "Senior Constable",
    ["Police Constable"] = "Police Constable",
    ["PCSO"] = "PCSO",
    --["Police"] = "Whitelist",
    --["pdlargearms"] = "Police Large Arms",
}

local getUserNHSGroups = {
    ["Head Chief Medical Officer"] = "Head Chief Medical Officer",
    ["Assistant Chief Medical Officer"] = "Assistant Chief Medical Officer",
    ["Deputy Chief Medical Officer"] = "Deputy Chief Medical Officer",
    ["Captain"] = "Captain",
    ["Consultant"] = "Consultant",
    ["Specialist"] = "Specialist",
    ["Senior Doctor"] = "Senior Doctor",
    ["Junior Doctor"] = "Junior Doctor",
    ["Critical Care Paramedic"] = "Critical Care Paramedic",
    ["Paramedic"] = "Paramedic",
    ["Trainee Paramedic"] = "Trainee Paramedic",
}

AddEventHandler("playerSpawned",function()
    local h = true
    if h then 
        TriggerServerEvent("NOVA:requestAdminPerks")
    end 
end)

RegisterNetEvent('NOVA:SendAdminPerks', function(a)
    Stafflevel = a 
    if getStaffLevel() > 0 then 
        print('[NOVA] Your staff level is: ' ..Stafflevel)
   
    end
end)

function getStaffLevel()
    return Stafflevel
end
RegisterCommand('requeststafflevel', function(source, args, RawCommand)
    if getStaffLevel() > 4 then
        print('You requested all all staff perms to be checked')
        TriggerServerEvent("NOVA:requestAdminPerks")
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
                    TriggerServerEvent("NOVA:GetNearbyPlayers", 250)
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
                        TriggerServerEvent("NOVA:CheckPov",v[3])
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
                        end
                        if Active then 
                            hoveredPlayer = v[2]
                        end
                    end, RMenu:Get("adminmenu", "submenu"))
                end
            else
                RageUI.Separator("No players nearby!")
            end
        end)
    end
end)

RegisterNetEvent("NOVA:ReturnNearbyPlayers")
AddEventHandler("NOVA:ReturnNearbyPlayers", function(table)
    playersNearby = table
end)


RMenu.Add('SettingsMenu', 'MainMenu', RageUI.CreateMenu("", menuColour.."Settings Menu", 1300,100, "banners","settings")) 
RMenu.Add("SettingsMenu", "graphicpresets", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"), "", '~b~Graphics Presets',1300, 100,"banners","settings"))
RMenu.Add("SettingsMenu", "uisettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu")))
RMenu.Add("SettingsMenu","killeffects",RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu"),"","~b~Kill Effects"))
RMenu.Add("SettingsMenu", "crosshairsettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu")))
RMenu.Add("SettingsMenu", "weaponsettings", RageUI.CreateSubMenu(RMenu:Get("SettingsMenu", "MainMenu")))

RegisterNetEvent('NOVA:ReturnPov')
AddEventHandler('NOVA:ReturnPov', function(pov)
    povlist = pov
end)


local statusr = "~r~[Off]"
local hitsounds = false

local statusc = "~r~[Off]"
local compass = false

local statusT = "~r~[Off]"
local toggle = false

local df = {
    {"10%", 0.1},
    {"20%", 0.2},
    {"30%", 0.3},
    {"40%", 0.4},
    {"50%", 0.5},
    {"60%", 0.6},
    {"70%", 0.7},
    {"80%", 0.8},
    {"90%", 0.9},
    {"100%", 1.0},
    {"150%", 1.5},
    {"200%", 2.0},
    {"250%", 2.5},
    {"300%", 3.0},
    {"350%", 3.5},
    {"400%", 4.0},
    {"450%", 4.5},
    {"500%", 5.0},
    {"600%", 6.0},
    {"700%", 7.0},
    {"800%", 8.0},
    {"900%", 9.0},
    {"1000%", 10.0},
}

local d = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "250%", "300%", "350%", "400%", "450%", "500%", "600%", "700%", "800%", "900%", "1000%"}
local dts = 10
local WeaponOnBack = false


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'MainMenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.List("Render Distance Modifier", d, dts, "~g~Lowering this will increase your FPS!", {}, true, function(a,b,c,d)
                if c then -- Locals...
                end
                dts = d -- Locals ...
            end)
            RageUI.ButtonWithStyle("UI Settings","View a list of preconfigured graphic settings.",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "uisettings"))
            RageUI.ButtonWithStyle("Weapon Settings","",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "weaponsettings"))
            RageUI.ButtonWithStyle("Misc Settings","",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "killeffects"))
            RageUI.ButtonWithStyle("Graphic Presets","",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "killeffects"))
            RageUI.ButtonWithStyle("Kill Effects","",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "killeffects"))
            RageUI.ButtonWithStyle("Blood Effects","",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "killeffects"))
       end)
    end
end)
local n = GetResourceKvpString("nova_healthpercentage") or "false"
if n == "false" then
    h = true
else
    h = true
end
local p
function tvRP.getShowHealthPercentageFlag()
    return h
end
function tvRP.setShowHealthPercentageFlag(p)
    SetResourceKvp("nova_healthpercentage", tostring(p))
end
function tvRP.setShowHealthPercentageFlag(p)
    SetResourceKvp("nova_healthpercentage", tostring(p))
end
local function ToggleWPHorizontal()
    TriggerEvent("NOVA:Settings:SetWB", true)
    WeaponOnBack = true
end
local function ToggleWPVertical()
    TriggerEvent("NOVA:Settings:SetWB", false)
    WeaponOnBack = false
end


RageUI.CreateWhile(1.0, true, function()
	if RageUI.Visible(RMenu:Get("SettingsMenu", "killeffects")) then

          RageUI.DrawContent({header = true, glare = false, instructionalButton = false},function()

            RageUI.Checkbox("Create Lightning","",U.lightning,{},function(a2, a4, a3, a8)

                if a4 then

                   U.lightning = a8

                   W()

                end

             end)

             RageUI.Checkbox("Ped Flash","",U.pedFlash,{},function(a2, a4, a3, a8)

                if a4 then

                   U.pedFlash = a8

                   W()

                end

             end)

             if U.pedFlash then

                   RageUI.List("Ped Flash Red",L,U.pedFlashRGB[1],"",{},U.pedFlash,function(a2, a3, a4, a5)

                      if a3 and U.pedFlashRGB[1] ~= a5 then

                      U.pedFlashRGB[1] = a

                      W()

                   end

                end,function()

                end)

                RageUI.List("Ped Flash Green",L,U.pedFlashRGB[2],"",{},U.pedFlash,function(a2, a3, a4, a5)

                   if  U.pedFlashRGB[2] ~= a5 then

                      U.pedFlashRGB[2] = a5

                      W()

                   end

                end,function()

                end)

                RageUI.List("Ped Flash Blue",L,U.pedFlashRGB[3],"",{},U.pedFlash,function(a2, a3, a4, a5)

                   if a3 and U.pedFlashRGB[3] ~= a5 then

                      U.pedFlashRGB[3] = a5

                      W()

                   end

                end,function()

                end)

                RageUI.List("Ped Flash Intensity",N,U.pedFlashIntensity,"",{},U.pedFlash,function(a2, a3, a4, a5)

                   if a3 and U.pedFlashIntensity ~= a5 then

                      U.pedFlashIntensity = a5

                      W()

                   end

                end,function()

                end)

                RageUI.List("Ped Flash Time",P,U.pedFlashTime,"",{},U.pedFlash,function(a2, a3, a4, a5)

                   if a3 and U.pedFlashTime ~= a5 then

                      U.pedFlashTime = a5

                      W()

                   end

                end,function()

                end)

             end

             RageUI.Checkbox("Screen Flash","",U.screenFlash,{},function(a2, a4, a3, a8)

                if a4 then

                   U.screenFlash = a8

                   W()

                end

             end)

             if U.screenFlash then

                RageUI.List("Screen Flash Red",L,U.screenFlashRGB[1],"",{},U.screenFlash,function(a2, a3, a4, a5)

                   if a3 and U.screenFlashRGB[1] ~= a5 then

                      U.screenFlashRGB[1] = a5

                      W()

                   end

                end,function()

                end)

                RageUI.List("Screen Flash Green",L,U.screenFlashRGB[2],"",{},U.screenFlash,function(a2, a3, a4, a5)

                   if a3 and U.screenFlashRGB[2] ~= a5 then

                      U.screenFlashRGB[2] = a5

                      W()

                   end

                end,function()

                end)

                RageUI.List("Screen Flash Blue",L,U.screenFlashRGB[3],"",{},U.screenFlash,function(a2, a3, a4, a5)

                   if a3 and U.screenFlashRGB[3] ~= a5 then

                      U.screenFlashRGB[3] = a5

                      W()

                   end

                end,function()

                end)

                RageUI.List("Screen Flash Intensity",N,U.screenFlashIntensity,"",{},U.screenFlash,function(a2, a3, a4, a5)

                   if a3 and U.screenFlashIntensity ~= a5 then

                      U.screenFlashIntensity = a5

                      W()

                   end

                end,function()

                end)

                RageUI.List("Screen Flash Time",P,U.screenFlashTime,"",{},U.screenFlash,function(a2, a3, a4, a5)

                   if a3 and U.screenFlashTime ~= a5 then

                      U.screenFlashTime = a5

                      W()

                   end

                end,function()

                end)

             end

             RageUI.List("Timecycle Flash",T,U.timecycle,"",{},true,function(a2, a3, a4, a5)

                if a3 and U.timecycle ~= a5 then

                   U.timecycle = a5

                   W()

                end

             end,function()

             end)

             if U.timecycle ~= 1 then

                RageUI.List("Timecycle Flash Time",P,U.timecycleTime,"",{},true,function(a2, a3, a4, a5)

                   if a3 and U.timecycleTime ~= a5 then

                      U.timecycleTime = a5

                      W()

                   end

                end,function()

                end)

             end

             RageUI.List("~y~Particles~w~",R,U.particle,"",{},true,function(a2, a3, a4, a5)

                if a3 and U.particle ~= a5 then

                   if not tvRP.isPlusClub() and not tvRP.isPlatClub() then

                      tvRP.notify("~y~You need to be a subscriber of NOVA Plus or NOVA Platinum to use this feature.")

                      tvRP.notify("~y~Available @ store.NOVAstudios.uk")

                   end

                   U.particle = a5

                   W()

                end

             end,function()

             end)

             local aj = 0

             if U.lightning then

                aj = math.max(aj, 1000)

             end

             if U.pedFlash then

                aj = math.max(aj, Q[U.pedFlashTime])

             end

             if U.screenFlash then

                aj = math.max(aj, Q[U.screenFlashTime])

             end

             if U.timecycleTime ~= 1 then

                aj = math.max(aj, M[U.timecycleTime])

             end

             if U.particle ~= 1 then

                aj = math.max(aj, 1000)

             end

             if GetGameTimer() - V > aj + 1000 then

                tvRP.addKillEffect(PlayerPedId(), true)

                V = GetGameTimer()

             end

             DrawAdvancedText(0.59, 0.9, 0.005, 0.0028, 1.5, "PREVIEW", 255, 0, 0, 255, 2, 0)

          end)

       end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'uisettings')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Checkbox("Compass", nil, compasschecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if (Selected) then
                    compasschecked = not compasschecked
                    ExecuteCommand("compass")
                end
            end)

            RageUI.Checkbox("Cinematic Bars", "~y~Roleplay Option!", blackbarschecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if (Selected) then
                    blackbarschecked = not blackbarschecked
                    ExecuteCommand("cinematic")
                end
            end)
            RageUI.Checkbox("Show Health Percentage","Displays the health and armour percentage on the bars", h, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
            if (Selected) then
                if Checked then
                    h = true
                	tvRP.setShowHealthPercentageFlag(true)
                else
                    h = false
                	tvRP.setShowHealthPercentageFlag(false)              
                end
            end
        end)

            RageUI.Checkbox("Hide UI", nil, hudchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if (Selected) then
                    hudchecked = not hudchecked
                    if Checked then
                        ExecuteCommand('hideui')
                      
                    else
                        ExecuteCommand('showui')
                      
                    end
                end
            end)

            RageUI.Checkbox("Streetnames", nil, streetnamechecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if (Selected) then
                    streetnamechecked = not streetnamechecked
                    if Checked then
                        ExecuteCommand('streetnames')
                      
                    else
                        ExecuteCommand('streetnames')
                       
                    end
                end
            end)
                        RageUI.ButtonWithStyle("Crosshair Settings","",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("SettingsMenu", "crosshairsettings"))

    end)
end
end)
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'weaponsettings')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

            RageUI.Checkbox("Disable Hitsounds", nil, hitsoundchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
                if (Selected) then
                    hitsoundchecked = not hitsoundchecked
                    TriggerEvent("hs:triggerSounds")
                end
            end)

            RageUI.Checkbox("Weapons On Back","~w~Set weapons on back vertical or horizontal", WeaponOnBack, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
            if (Selected) then
                WeaponOnBack = not WeaponOnBack
                if Checked then
                    WeaponOnBack = true
                    TriggerEvent("NOVA:Settings:SetWB", true)
                else
                    WeaponOnBack = false
                    TriggerEvent("NOVA:Settings:SetWB", false)               
                end
            end
        end)
            RageUI.Button("Scope Settings", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                   ExecuteCommand('scope')
               end
           end)

    end)
end
end)
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('SettingsMenu', 'crosshairsettings')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()


        RageUI.Checkbox("Enable Crosshair", nil, crosshairchecked, {RightLabel = ""}, function(Hovered, Active, Selected, Checked)
            if (Selected) then
                crosshairchecked = not crosshairchecked
                if Checked then
                    ExecuteCommand("cross")
                    notify("~g~Crosshair Enabled!")
                else
                    ExecuteCommand("cross")
                    notify("~r~Crosshair Disabled!")
                end
            end
        end)

        RageUI.ButtonWithStyle("Edit Crosshair", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                ExecuteCommand("crosse")
            end
        end)

        RageUI.ButtonWithStyle("Reset Crosshair", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                ExecuteCommand("crossr")
            end
        end)

    end)
end
end)

if RageUI.Visible(RMenu:Get('SettingsMenu', 'graphicpresets')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for C, y in pairs(a.presets) do
                RageUI.Separator(y.name)
                for C, z in pairs(y.presets) do
                    local ac = x(y, z)
                    RageUI.Checkbox(z.name,nil,ac,{},function(a0, a2, a1, a6)
                        if a6 ~= ac then
                            G(y, z, a6)
                        end
                    end,function()end,function()end)
                end
            end
        end)
end
RegisterNetEvent('NOVA:OpenSettingsMenu')
AddEventHandler('NOVA:OpenSettingsMenu', function(admin)
    if not admin then
        RageUI.Visible(RMenu:Get("adminmenu", "main"), false)
        RageUI.Visible(RMenu:Get("SettingsMenu", "MainMenu"), true)
    end
end)

RegisterCommand('opensettingsmenu',function()
    TriggerServerEvent('NOVA:OpenSettings')
end)

RegisterKeyMapping('opensettingsmenu', 'Opens the Settings menu', 'keyboard', 'F2')

Citizen.CreateThread(function() 
    while true do
        Citizen.InvokeNative(0xA76359FC80B2438E, df[dts][2])      
        Citizen.Wait(0)
    end
end)

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

        --if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
            if tvRP.isDeveloper(tvRP.getUserId()) then
            RageUI.ButtonWithStyle("Get Coords", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NOVA:GetCoords')
                end
            end, RMenu:Get('adminmenu', 'functions'))
        end

        if admincfg.buttonsEnabled["kick"][1] and buttons["kick"] then                        
            RageUI.ButtonWithStyle("Kick (No F10)", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('NOVA:noF10Kick')
                end
            end, RMenu:Get('adminmenu', 'functions'))
        end

        if admincfg.buttonsEnabled["tp2waypoint"][1] and buttons["tp2waypoint"] then                        
            RageUI.List("Teleport to ",q,s,nil,{},true,function(x, y, z, N)
                s = N
                if z then
                    local uid = GetPlayerServerId(PlayerId())
                    TriggerServerEvent("NOVA:Teleport", uid, vector3(r[s]))
                end
            end,
            function()end)
        end

       -- if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
            if tvRP.isDeveloper(tvRP.getUserId()) then
            RageUI.ButtonWithStyle("TP To Coords",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("NOVA:Tp2Coords")
                end
            end, RMenu:Get('adminmenu', 'functions'))
        end

        if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
            RageUI.ButtonWithStyle("Offline Ban",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local uid = GetPlayerServerId(PlayerId())
                    TriggerServerEvent('NOVA:offlineban', uid)
                end
            end)
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
            end, RMenu:Get('adminmenu', 'functions'))
        end

        if admincfg.buttonsEnabled["unban"][1] and buttons["unban"] then
            RageUI.ButtonWithStyle("Unban Player",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("NOVA:Unban")
                end
            end)
        end

        if admincfg.buttonsEnabled["spawnBmx"][1] and buttons["spawnBmx"] then
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
                    TriggerServerEvent('NOVA:RemoveWarning', uid, result)
                end
            end, RMenu:Get('adminmenu', 'functions'))
        end

        -- if admincfg.buttonsEnabled["getgroups"][1] and buttons["getgroups"] then
        --     RageUI.Button("Toggle Blips", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        --         if Selected then
        --             TriggerServerEvent('NOVA:checkBlips')
        --         end
        --     end, RMenu:Get('adminmenu', 'functions'))
        -- end

        if admincfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
            RageUI.ButtonWithStyle("~r~Entity Functions", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'entityfunctions'))
        end
        --if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
            if tvRP.isDeveloper(tvRP.getUserId()) then
            RageUI.ButtonWithStyle("~r~Developer Functions", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('adminmenu', 'devfunctions'))
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
                        TriggerServerEvent('NOVA:VehCleanup')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

     

            if admincfg.buttonsEnabled["unban"][1] and buttons["unban"] then
                RageUI.ButtonWithStyle("Entity Cleanup",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('NOVA:CleanAll')
                    end
                end, RMenu:Get('adminmenu', 'entityfunctions'))
            end

        end)
    end
end)


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'devfunctions')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

            if tvRP.isDeveloper(tvRP.getUserId()) then
                RageUI.ButtonWithStyle("Spawn Weapon",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('NOVA:Giveweapon')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end

            if tvRP.isDeveloper(tvRP.getUserId()) then
                RageUI.ButtonWithStyle("Reset Rewards",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('NOVA:resetRedeem')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
    
            if tvRP.isDeveloper(tvRP.getUserId()) then
                RageUI.ButtonWithStyle("Add Car",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('NOVA:AddCar')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
    
            if admincfg.buttonsEnabled["tp2waypoint"][1] and buttons["tp2waypoint"] then
                RageUI.ButtonWithStyle("Cancel Rent",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('admin:cancelRent')
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
                RageUI.ButtonWithStyle("Spawn Vehicle","", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("NOVA:SpawnVehicle")
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
			
            --if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                if tvRP.isDeveloper(tvRP.getUserId()) then
                RageUI.ButtonWithStyle("Give Cash",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("NOVA:GiveMoneyMenu")
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end

                if tvRP.isDeveloper(tvRP.getUserId()) then
                RageUI.ButtonWithStyle("Give Bank",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("NOVA:GiveBankMenu")
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end
                if tvRP.isDeveloper(tvRP.getUserId()) then
                RageUI.ButtonWithStyle("Server Restart",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("NOVA:RestartServer")
                    end
                end, RMenu:Get('adminmenu', 'devfunctions'))
            end


          --  if admincfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                if tvRP.isDeveloper(tvRP.getUserId()) then
                RageUI.ButtonWithStyle("AC Types",nil,{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                    end
                end, RMenu:Get('adminmenu', 'actypes'))
            end          
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

    RageUI.CreateWhile(1.0, true, function()
        if RageUI.Visible(RMenu:Get('adminmenu', 'submenu')) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
                hoveredPlayer = nil
				if povlist == nil then
                	RageUI.Separator("~y~Player must provide POV on request: Loading...")
                elseif povlist == true then
                	RageUI.Separator("~y~Player must provide POV on request: ~g~true")
                elseif povlist == false then
                	RageUI.Separator("~y~Player must provide POV on request: ~r~false")
                end
                if admincfg.buttonsEnabled["spectate"][1] and buttons["spectate"] then
                    RageUI.ButtonWithStyle("Player Notes",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('NOVA:getNotes', uid, SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'notesub'))
                end 
               
                if admincfg.buttonsEnabled["kick"][1] and buttons["kick"] then
                    RageUI.ButtonWithStyle("Kick Player",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('NOVA:KickPlayer', uid, SelectedPlayer[3], kickReason, SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                    RageUI.ButtonWithStyle("Ban Player",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end, RMenu:Get('adminmenu', 'bansub'))
                end

                if admincfg.buttonsEnabled["spectate"][1] and buttons["spectate"] then
                    RageUI.ButtonWithStyle("Spectate Player",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            inRedZone = false
                            TriggerServerEvent('NOVA:SpectatePlayer', SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["revive"][1] and buttons["revive"] then
                    RageUI.ButtonWithStyle("Revive",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('NOVA:RevivePlayer', uid, SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
                
                if admincfg.buttonsEnabled["TP2"][1] and buttons["TP2"] then
                    RageUI.ButtonWithStyle("Teleport to Player",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local newSource = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('NOVA:TeleportToPlayer', newSource, SelectedPlayer[2])
                            inTP2P = true
                            inTP2P2 = true
                            
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    RageUI.ButtonWithStyle("Teleport Player to Me",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('NOVA:BringPlayer', SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    RageUI.ButtonWithStyle("Teleport to Admin Zone",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            inRedZone = false
                            savedCoordsBeforeAdminZone = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(SelectedPlayer[2])))
                            TriggerServerEvent("NOVA:Teleport2AdminIsland", SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    RageUI.ButtonWithStyle("Return Player",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("NOVA:returnplayer", SelectedPlayer[2], savedCoordsBeforeAdminZone)
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    RageUI.ButtonWithStyle("Teleport to Legion",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("NOVA:Teleport", SelectedPlayer[2], vector3(151.61740112305,-1035.05078125,29.339416503906))
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["FREEZE"][1] and buttons["FREEZE"] then
                    RageUI.ButtonWithStyle("Freeze",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            isFrozen = not isFrozen
                            TriggerServerEvent('NOVA:FreezeSV', uid, SelectedPlayer[2], isFrozen)
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["slap"][1] and buttons["slap"] then
                    RageUI.ButtonWithStyle("Slap Player",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('NOVA:SlapPlayer', uid, SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["unban"][1] and buttons["unban"] then
                    RageUI.ButtonWithStyle("Force Clock Off",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent("NOVA:ForceClockOff", uid, SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end
                if admincfg.buttonsEnabled["tp2waypoint"][1] and buttons["tp2waypoint"] then                        
                    RageUI.List("Teleport to ",q,s,nil,{},true,function(x, y, z, N)
                        s = N
                        if z then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent("NOVA:Teleport", SelectedPlayer[2], vector3(r[s]))
                        end
                    end,
                    function()end)
                end

                if admincfg.buttonsEnabled["showwarn"][1] and buttons["showwarn"] then
                    RageUI.ButtonWithStyle("Open F10 Warning Log",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ExecuteCommand("sw " .. SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["SS"][1] and buttons["SS"] then
                    RageUI.ButtonWithStyle("Take Screenshot",nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('NOVA:RequestScreenshot', uid , SelectedPlayer[2])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                end

                if admincfg.buttonsEnabled["getgroups"][1] and buttons["getgroups"] then
                    RageUI.ButtonWithStyle("See Groups",SelectedPlayer[1] .. " Perm ID: " .. SelectedPlayer[3] .. " Temp ID: " .. SelectedPlayer[2], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent("NOVA:GetGroups", SelectedPlayer[2], SelectedPlayer[3])
                        end
                    end,RMenu:Get("adminmenu", "groups"))
                end
                
            end)
        end
    end)

    RageUI.CreateWhile(1.0, true, function()
        if RageUI.Visible(RMenu:Get('adminmenu', 'notesub')) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
                if f == nil then
                    RageUI.Separator("~r~Player notes: Loading...")
                elseif #f == 0 then
                    RageUI.Separator("~r~There are no player notes to display.")
                else
                    RageUI.Separator("~r~Player notes:")
                    for K = 1, #f do
                        RageUI.Separator("~g~#"..f[K].note_id.." ~w~" .. f[K].text .. " - "..f[K].admin_name.. "("..f[K].admin_id..")")
                    end
                end
                if admincfg.buttonsEnabled["warn"][1] and buttons["warn"] then
                    RageUI.ButtonWithStyle("Add To Notes:", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('NOVA:addNote', uid, SelectedPlayer[2])
                        end
                    end)
                    RageUI.ButtonWithStyle("Remove Note", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('NOVA:removeNote', uid, SelectedPlayer[2])
                        end
                    end)
                end
            end)
        end
    end)

RegisterNetEvent('NOVA:ReturnPov')
AddEventHandler('NOVA:ReturnPov',function(aq)
i=aq end)

RegisterNetEvent("NOVA:sendNotes",function(a7)
    a7 = json.decode(a7)
    if a7 == nil then
        f = {}
    else
        f = a7
    end
end)

RegisterNetEvent("NOVA:updateNotes",function(admin, player)
    TriggerServerEvent('NOVA:getNotes', admin, player)
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
        id = "trolling",
        name = "1.0 Trolling",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "trollingminor",
        name = "1.0 Trolling (Minor)",
        desc = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",
        selected = false
    },
    {
        id = "metagaming",
        name = "1.1 Metagaming",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "powergaming",
        name = "1.2 Power Gaming ",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "failrp",
        name = "1.3 Fail RP",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {id = "rdm", name = "1.4 RDM", desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", selected = false},
    {
        id = "massrdm",
        name = "1.4.1 Mass RDM",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "nrti",
        name = "1.5 No Reason to Initiate (NRTI) ",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {id = "vdm", name = "1.6 VDM", desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", selected = false},
    {
        id = "massvdm",
        name = "1.6.1 Mass VDM",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "offlanguageminor",
        name = "1.7 Offensive Language/Toxicity (Minor)",
        desc = "1st Offense: 2hr\n2nd Offense: 24hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "offlanguagestandard",
        name = "1.7 Offensive Language/Toxicity (Standard)",
        desc = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",
        selected = false
    },
    {
        id = "offlanguagesevere",
        name = "1.7 Offensive Language/Toxicity (Severe)",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "breakrp",
        name = "1.8 Breaking Character",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "combatlog",
        name = "1.9 Combat logging",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "combatstore",
        name = "1.10 Combat storing",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "exploitingstandard",
        name = "1.11 Exploiting (Standard)",
        desc = "1st Offense: 24hr\n2nd 48hr\n3rd 168hr",
        selected = false
    },
    {
        id = "exploitingsevere",
        name = "1.11 Exploiting (Severe)",
        desc = "1st Offense: 168hr\n2nd Permanent\n3rd N/A",
        selected = false
    },
    {
        id = "oogt",
        name = "1.12 Out of game transactions (OOGT)",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "spitereport",
        name = "1.13 Spite Reports ",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",
        selected = false
    },
    {
        id = "scamming",
        name = "1.14 Scamming",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "loans",
        name = "1.15 Loans",
        desc = "1st Offense: 48hr\n2nd Offense: 168hr\n3rd Offense: Permanent",
        selected = false
    },
    {
        id = "wastingadmintime",
        name = "1.16 Wasting Admin Time",
        desc = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",
        selected = false
    },
    {
        id = "ftvl",
        name = "2.1 Value of Life",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "sexualrp",
        name = "2.2 Sexual RP",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd N/A",
        selected = false
    },
    {
        id = "terrorrp",
        name = "2.3 Terrorist RP",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd N/A",
        selected = false
    },
    {
        id = "impwhitelisted",
        name = "2.4 Impersonation of Whitelisted Factions",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "gtadriving",
        name = "2.5 GTA Online Driving",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {id = "nlr", name = "2.6 NLR", desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", selected = false},
    {
        id = "badrp",
        name = "2.7 Bad RP",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "kidnapping",
        name = "2.8 Kidnapping",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "stealingems",
        name = "3.0 Theft of Emergency Vehicles",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "whitelistabusestandard",
        name = "3.1 Whitelist Abuse",
        desc = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd 168hr",
        selected = false
    },
    {
        id = "whitelistabusesevere",
        name = "3.1 Whitelist Abuse",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd N/A",
        selected = false
    },
    {
        id = "copbaiting",
        name = "3.2 Cop Baiting",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "pdkidnapping",
        name = "3.3 PD Kidnapping",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "unrealisticrevival",
        name = "3.4 Unrealistic Revival",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "interjectingrp",
        name = "3.5 Interjection of RP",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "combatrev",
        name = "3.6 Combat Reviving",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "gangcap",
        name = "3.7 Gang Cap",
        desc = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168h",
        selected = false
    },
    {
        id = "maxgang",
        name = "3.8 Max Gang Numbers",
        desc = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168h",
        selected = false
    },
    {
        id = "gangalliance",
        name = "3.9 Gang Alliance",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "impgang",
        name = "3.10 Impersonation of Gangs",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "gzstealing",
        name = "4.1 Stealing Vehicles in Greenzone",
        desc = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",
        selected = false
    },
    {
        id = "gzillegal",
        name = "4.2 Selling Illegal Items in Greenzone",
        desc = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",
        selected = false
    },
    {
        id = "gzretretreating",
        name = "4.3 Greenzone Retreating ",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "rzhostage",
        name = "4.5 Taking Hostage into Redzone",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "rzretreating",
        name = "4.6 Redzone Retreating",
        desc = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",
        selected = false
    },
    {
        id = "advert",
        name = "1.1 Advertising",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "bullying",
        name = "1.2 Bullying",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "impersonationrule",
        name = "1.3 Impersonation",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "language",
        name = "1.4 Language",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "discrim",
        name = "1.5 Discrimination ",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "attacks",
        name = "1.6 Malicious Attacks ",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "PIIstandard",
        name = "1.7 PII (Personally Identifiable Information)(Standard)",
        desc = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "PIIsevere",
        name = "1.7 PII (Personally Identifiable Information)(Severe)",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "chargeback",
        name = "1.8 Chargeback",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "discretion",
        name = "1.9 Staff Discretion",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "cheating",
        name = "1.10 Cheating",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "banevading",
        name = "1.11 Ban Evading",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "fivemcheats",
        name = "1.12 Withholding/Storing FiveM Cheats",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "altaccount",
        name = "1.13 Multi-Accounting",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "association",
        name = "1.14 Association with External Modifications",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "pov",
        name = "1.15 Failure to provide POV ",
        desc = "1st Offense: 2hr\n2nd Offense: Permanent\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "withholdinginfostandard",
        name = "1.16 Withholding Information From Staff (Standard)",
        desc = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",
        selected = false
    },
    {
        id = "withholdinginfosevere",
        name = "1.16 Withholding Information From Staff (Severe)",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
    {
        id = "blackmail",
        name = "1.17 Blackmailing",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },

    {
        id = "comban",
        name = "Community Ban",
        desc = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",
        selected = false
    },
}


RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'bansub')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()

            
            if admincfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                RageUI.Button("~g~[Custom Ban Message]", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)            
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('NOVA:CustomBan', uid, SelectedPlayer[3])
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                        

                for i , p in pairs(warningbankick) do 
                    RageUI.Button(p.name, p.desc, { RightLabel = ">>>" }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local uid = GetPlayerServerId(PlayerId())
                            TriggerServerEvent('NOVA:BanPlayer', uid, SelectedPlayer[3], p.name)
                        end
                    end, RMenu:Get('adminmenu', 'submenu'))
                 end

            end

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
        TriggerEvent("NOVA:vehicleMenu",false, false)
    end
end)

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('adminmenu', 'groups')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if admincfg.buttonsEnabled["staffGroups"][1] and buttons["staffGroups"] then
                RageUI.Button("Staff Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("Staff Groups")
                    end
                end, RMenu:Get('adminmenu', 'staffGroups'))
            end
            if admincfg.buttonsEnabled["licenseGroups"][1] and buttons["licenseGroups"] then
                RageUI.Button("License Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("License Groups")
                    end
                end, RMenu:Get('adminmenu', 'LicenseGroups'))
            end
            if admincfg.buttonsEnabled["povGroups"][1] and buttons["povGroups"] then
                RageUI.Button("POV Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then

                    end
                    if (Active) then

                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("POV Groups")
                    end
                end, RMenu:Get('adminmenu', 'POVGroups'))
            end
            if admincfg.buttonsEnabled["mpdGroups"][1] and buttons["mpdGroups"] then
                RageUI.Button("~r~Police Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then

                    end
                    if (Active) then

                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("POV Groups")
                    end
                end, RMenu:Get('adminmenu', 'PoliceGroups'))
            end
            if admincfg.buttonsEnabled["nhsGroups"][1] and buttons["nhsGroups"] then
                RageUI.Button("~g~NHS Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then

                    end
                    if (Active) then

                    end
                    if (Selected) then
                        RMenu:Get("adminmenu", "groups"):SetTitle("")
                        RMenu:Get("adminmenu", "groups"):SetSubtitle("POV Groups")
                    end
                end, RMenu:Get('adminmenu', 'NHSGroups'))
            end
            if admincfg.buttonsEnabled["donoGroups"][1] and buttons["donoGroups"] then
                RageUI.Button("Donator Groups",nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        
                    end
                end, RMenu:Get('adminmenu', 'UserGroups'))
            end
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
                    TriggerServerEvent("NOVA:AddGroup",SelectedPerm,selectedGroup)
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
                    TriggerServerEvent("NOVA:RemoveGroup",SelectedPerm,selectedGroup)
                end
            end, RMenu:Get('adminmenu', 'groups'))
            
        end)
    end
end)

RegisterNetEvent('NOVA:SlapPlayer')
AddEventHandler('NOVA:SlapPlayer', function()
    SetEntityHealth(PlayerPedId(), 0)
end)

FrozenPlayer = false

RegisterNetEvent('NOVA:Freeze')
AddEventHandler('NOVA:Freeze', function(isFrozen)
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
        elseif not FrozenPlayer and not staffMode and not noclip then
            FreezeEntityPosition(PlayerPedId(), false)
            SetPedCanRagdoll(GetPlayerPed(-1), true)
            ClearPedBloodDamage(GetPlayerPed(-1))
            ResetPedVisibleDamage(GetPlayerPed(-1))
            ClearPedLastWeaponDamage(GetPlayerPed(-1))
        end
    end
end)

RegisterNetEvent('NOVA:Teleport')
AddEventHandler('NOVA:Teleport', function(coords)
    SetEntityCoords(PlayerPedId(), coords)
end)

RegisterNetEvent('NOVA:Teleport2Me2')
AddEventHandler('NOVA:Teleport2Me2', function(target2)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target2)))
    SetEntityCoords(PlayerPedId(), coords)
end)


RegisterNetEvent("NOVA:SendPlayerInfo")
AddEventHandler("NOVA:SendPlayerInfo",function(players_table, btns)
    players = players_table
    buttons = btns
    RageUI.Visible(RMenu:Get("adminmenu", "main"), not RageUI.Visible(RMenu:Get("adminmenu", "main")))
end)

RegisterNetEvent("NOVA:SpawnWeaponC")
AddEventHandler("NOVA:SpawnWeaponC",function(spawncode)
    if Stafflevel >= 11 then
        vRPclient.allowWeapon({spawncode, "-1"})
        GiveWeaponToPed(PlayerPedId(), GetHashKey(spawncode), 250, false, false,0)
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
    setRedzoneTimerDisabled(false)
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

RegisterNetEvent("NOVA:GotGroups")
AddEventHandler("NOVA:GotGroups",function(gotGroups)
    searchPlayerGroups = gotGroups
end)

function Draw2DText(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 0)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
  end

RegisterNetEvent('NOVA:NotifyPlayer')
AddEventHandler('NOVA:NotifyPlayer', function(string)
    notify('~g~' .. string)
end)

RegisterCommand('openadminmenu',function()
    TriggerServerEvent("NOVA:GetPlayerData")
    TriggerServerEvent("NOVA:GetNearbyPlayerData")
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

RegisterNetEvent("NOVA:TPCoords")
AddEventHandler("NOVA:TPCoords", function(coords)
    SetEntityCoordsNoOffset(GetPlayerPed(-1), coords.x, coords.y, coords.z, false, false, false)
end)

RegisterNetEvent("NOVA:EntityWipe")
AddEventHandler("NOVA:EntityWipe", function(id)
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
RegisterNetEvent('NOVA:Spectate')
AddEventHandler('NOVA:Spectate', function(plr,tpcoords)
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
    if not Spectating then
        LastCoords = GetEntityCoords(playerPed) 
        if tpcoords then 
            SetEntityCoords(playerPed, tpcoords - 10.0)
        end
        Wait(300)
        targetPed = GetPlayerPed(GetPlayerFromServerId(plr))
        if targetPed == playerPed then tvRP.notify('~r~I mean you cannot spectate yourself...') return end
		NetworkSetInSpectatorMode(true, targetPed)
        SetEntityCollision(playerPed, false, false)
        SetEntityVisible(playerPed, false, 0)
		SetEveryoneIgnorePlayer(playerPed, true)	
		
        Spectating = true
        setRedzoneTimerDisabled(true)
        tvRP.notify('~g~Spectating Player.')

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
            --DrawAdvancedText(0.320, 0.806, 0.025, 0.0048, 0.5, "Ammo: "..(targetWeaponAmmoCount or "N/A"), 51, 153, 255, 200, 6, 0)
            --DrawAdvancedText(0.320, 0.784, 0.025, 0.0048, 0.5, "Vehicle Health: "..targetvehiclehealth, 51, 153, 255, 200, 6, 0)
            DrawAdvancedText(0.320, 0.806, 0.025, 0.0048, 0.5, "Vehicle Health: "..targetvehiclehealth, 51, 153, 255, 200, 6, 0)

            bank_drawTxt(0.90, 1.4, 1.0, 1.0, 0.4, "You are currently spectating "..targetplayerName, 51, 153, 255, 200)
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
        tvRP.notify('~r~Stopped Spectating Player.')
    end 
end)


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
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('settingdev', 'MainMenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            if tvRP.isNewPlayer() then
                drawNativeNotification("Press ~INPUT_REPLAY_START_STOP_RECORDING_SECONDARY~ to toggle the Settings Menu.")
            end
            RageUI.List("Render Distance Modifier",m,n,"~g~Lowering this will increase your FPS!",{},true,function(a0, a1, a2, a3)
                n = a3
            end,function()end,nil)
            local function a4()
                TriggerEvent("NOVA:setDiagonalWeapons")
                b = true
                tvRP.setDiagonalWeaponSetting(b)
            end
            local function a5()
                TriggerEvent("NOVA:setVerticalWeapons")
                b = false
                tvRP.setDiagonalWeaponSetting(b)
            end
            RageUI.Checkbox("Enable Diagonal Weapons","~g~This changes the way weapons look on your back from vertical to diagonal.",b,{RightBadge = RageUI.CheckboxStyle.Car},function(a0, a2, a1, a6)
            end,a4,a5)
            RageUI.Checkbox("Enable Front Assault Rifles","~g~This changes the positioning of Assault Rifles from back to front.",c,{RightBadge = RageUI.CheckboxStyle.Car},function()
            end,
            function()
                TriggerEvent("NOVA:setFrontAR")
                c = true
                tvRP.setFrontARSetting(c)
            end,
            function()
                TriggerEvent("NOVA:setBackAR")
                c = false
                tvRP.setFrontARSetting(c)
            end)
            local function a4()
                TriggerEvent("NOVA:hsSoundsOn")
                d = true
                tvRP.setHitMarkerSetting(d)
                tvRP.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
            end
            local function a5()
                TriggerEvent("NOVA:hsSoundsOff")
                d = false
                tvRP.setHitMarkerSetting(d)
                tvRP.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
            end
            RageUI.Checkbox("Enable Experimental Hit Marker Sounds","~g~This adds 'hit marker' sounds when shooting another player, however it can be unreliable.",d,{RightBadge = RageUI.CheckboxStyle.Car},function(a0, a2, a1, a6)
            end,a4,a5)
            RageUI.ButtonWithStyle("Weapon Whitelists","Sell your custom weapon whitelists here.",{RightLabel = "→→→"},true,function(a0, a1, a2)
                if a2 then
                    r = nil
                    p = nil
                    q = nil
                    s = nil
                    TriggerServerEvent("NOVA:getCustomWeaponsOwned")
                end
            end,RMenu:Get("settingdev", "weaponswhitelist"))
            -- RageUI.ButtonWithStyle("Store Inventory","View your store inventory here.",{RightLabel = "→→→"},true,function()
            -- end,RMenu:Get("store", "mainmenu"))
            RageUI.Checkbox("Streetnames","",tvRP.isStreetnamesEnabled(),{RightBadge = RageUI.CheckboxStyle.Car},function(a0, a2, a1, a6)
            end,
            function()
                tvRP.setStreetnamesEnabled(true)
            end,
            function()
                tvRP.setStreetnamesEnabled(false)
            end)
            RageUI.Checkbox("Compass","",tvRP.isCompassEnabled(),{RightBadge = RageUI.CheckboxStyle.Car},function(a0, a2, a1, a6)
            end,
            function()
                tvRP.setCompassEnabled(true)
            end,
            function()
                tvRP.setCompassEnabled(false)
            end)
            local function a4()
                tvRP.hideUI()
                hideUI = true
            end
            local function a5()
                tvRP.showUI()
                hideUI = false
            end
            RageUI.Checkbox("Hide UI","",hideUI,{RightBadge = RageUI.CheckboxStyle.Car},function(a0, a2, a1, a6)
            end,a4,a5)
            local function a4()
                tvRP.toggleBlackBars()
                e = true
            end
            local function a5()
                tvRP.toggleBlackBars()
                e = false
            end
            RageUI.Checkbox("Cinematic Black Bars","",e,{RightBadge = RageUI.CheckboxStyle.Car},function(a0, a2, a1, a6)
            end,a4,a5)
            RageUI.Checkbox("Show Health Percentage","Displays the health and armour percentage on the bars.",h,{},function()
            end,function()
                h = true
                tvRP.setShowHealthPercentageFlag(true)
            end,function()
                h = false
                tvRP.setShowHealthPercentageFlag(false)
            end)
            RageUI.Checkbox("Hide Event Announcements","Hides the big scaleform from displaying across your screen, will still announce in chat.",g,{},function()
            end,function()
                g = true
                tvRP.setHideEventAnnouncementFlag(true)
            end,function()
                g = false
                tvRP.setHideEventAnnouncementFlag(false)
            end)
            RageUI.ButtonWithStyle("Change Linked Discord","Begins the process of changing your linked Discord. Your linked discord is used to sync roles with the server.",{RightLabel = "→→→"},true,function(a0, a1, a2)
                if a2 then
                    TriggerServerEvent('NOVA:changeLinkedDiscord')
                end
            end)
            RageUI.ButtonWithStyle("Crosshair","Create a custom built-in crosshair here.",{RightLabel = "→→→"},true,function(a0, a1, a2)
            end,RMenu:Get("crosshair", "main"))
            RageUI.ButtonWithStyle("Scope Settings","Add a toggleable range finder when using sniper scopes.",{RightLabel = "→→→"},true,function(a0, a1, a2)
            end,RMenu:Get("scope", "main"))
            RageUI.ButtonWithStyle("Graphic Presets","View a list of preconfigured graphic settings.",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("settingdev", "graphicpresets"))
            RageUI.ButtonWithStyle("Kill Effects","Toggle effects that occur on killing a player.",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("settingdev", "killeffects"))
            RageUI.ButtonWithStyle("Blood Effects","Toggle effects that occur when damaging a player.",{RightLabel = "→→→"},true,function()
            end,RMenu:Get("settingdev", "bloodeffects"))
        end)
    end
    if RageUI.Visible(RMenu:Get('settingdev', 'changediscord')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator('~g~A code has been messaged to the Discord account')
            RageUI.Separator('-----')
            RageUI.Separator('~y~If you have not received a message verify:')
            RageUI.Separator('~y~1. Your direct messages are open.')
            RageUI.Separator('~y~2. The account you provided was correct.')
            RageUI.Separator('-----')
            RageUI.ButtonWithStyle("Enter Code","",{RightLabel = "→→→"},true,function(a0, a1, a2)
                if a2 then
                    TriggerServerEvent('NOVA:enterDiscordCode')
                end
            end)
        end)
    end
    if RageUI.Visible(RMenu:Get('settingdev', 'weaponswhitelist')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for a7, a8 in pairs(o) do
                RageUI.ButtonWithStyle(a8,"",{RightLabel = "→→→"},true,function(a0, a1, a2)
                    if a2 then
                        p = a8
                        q = a7
                        s = nil
                    end
                end,RMenu:Get("settingdev", "generateaccesscode"))
            end
            RageUI.Separator("~y~If you do not see your custom weapon here.")
            RageUI.Separator("~y~Please open a ticket on our support discord.")
        end)
    end
    if RageUI.Visible(RMenu:Get('settingdev', 'generateaccesscode')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("~g~Weapon Whitelist for " .. p)
            RageUI.Separator("How it works:")
            RageUI.Separator("You generate an access code for the player who wishes")
            RageUI.Separator("to purchase your custom weapon whitelist, which they ")
            RageUI.Separator("then enter on the store to receive their automated")
            RageUI.Separator("weapon whitelist.")
            RageUI.ButtonWithStyle("Create access code","",{RightLabel = "→→→"},true,function(a0, a1, a2)
                if a2 then
                    local a9 = getGenericTextInput("User ID of player purchasing your weapon whitelist.")
                    if tonumber(a9) then
                        a9 = tonumber(a9)
                        if a9 > 0 then
                            print("selling", q, "to", a9)
                            TriggerServerEvent("NOVA:generateWeaponAccessCode", q, a9)
                        end
                    end
                end
            end)
            RageUI.ButtonWithStyle("View whitelisted users","",{RightLabel = "→→→"},true,function(a0, a1, a2)
                if a2 then
                    TriggerServerEvent("NOVA:requestWhitelistedUsers", q)
                end
            end,RMenu:Get("settingdev", "viewwhitelisted"))
            if r then
                RageUI.Separator("~g~Access code generated: " .. r)
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('settingdev', 'viewwhitelisted')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("~g~Whitelisted users for " .. p)
            if s == nil then
                RageUI.Separator("~r~Requesting whitelisted users...")
            else
                for aa, ab in pairs(s) do
                    RageUI.ButtonWithStyle("ID: " .. tostring(aa),"",{RightLabel = ab},true,function()
                    end)
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('settingdev', 'graphicpresets')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for C, y in pairs(a.presets) do
                RageUI.Separator(y.name)
                for C, z in pairs(y.presets) do
                    local ac = x(y, z)
                    RageUI.Checkbox(z.name,nil,ac,{},function(a0, a2, a1, a6)
                        if a6 ~= ac then
                            G(y, z, a6)
                        end
                    end,function()end,function()end)
                end
            end
        end)
    end
    if RageUI.Visible(RMenu:Get('settingdev', 'killeffects')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Checkbox("Create Lightning","",S.lightning,{},function(a0, a2, a1, a6)
                if a2 then
                    S.lightning = a6
                    U()
                end
            end)
            RageUI.Checkbox("Ped Flash","",S.pedFlash,{},function(a0, a2, a1, a6)
                if a2 then
                    S.pedFlash = a6
                    U()
                end
            end)
            if S.pedFlash then
                RageUI.List("Ped Flash Red",J,S.pedFlashRGB[1],"",{},S.pedFlash,function(a0, a1, a2, a3)
                    if a1 and S.pedFlashRGB[1] ~= a3 then
                        S.pedFlashRGB[1] = a3
                        U()
                    end
                end,function()end)
                RageUI.List("Ped Flash Green",J,S.pedFlashRGB[2],"",{},S.pedFlash,function(a0, a1, a2, a3)
                    if a1 and S.pedFlashRGB[2] ~= a3 then
                        S.pedFlashRGB[2] = a3
                        U()
                    end
                end,function()end)
                RageUI.List("Ped Flash Blue",J,S.pedFlashRGB[3],"",{},S.pedFlash,function(a0, a1, a2, a3)
                    if a1 and S.pedFlashRGB[3] ~= a3 then
                        S.pedFlashRGB[3] = a3
                        U()
                    end
                end,function()end)
                RageUI.List("Ped Flash Intensity",L,S.pedFlashIntensity,"",{},S.pedFlash,function(a0, a1, a2, a3)
                    if a1 and S.pedFlashIntensity ~= a3 then
                        S.pedFlashIntensity = a3
                        U()
                    end
                end,function()end)
                RageUI.List("Ped Flash Time",N,S.pedFlashTime,"",{},S.pedFlash,function(a0, a1, a2, a3)
                    if a1 and S.pedFlashTime ~= a3 then
                        S.pedFlashTime = a3
                        U()
                    end
                end,function()end)
            end
            RageUI.Checkbox("Screen Flash","",S.screenFlash,{},function(a0, a2, a1, a6)
                if a2 then
                    S.screenFlash = a6
                    U()
                end
            end)
            if S.screenFlash then
                RageUI.List("Screen Flash Red",J,S.screenFlashRGB[1],"",{},S.screenFlash,function(a0, a1, a2, a3)
                    if a1 and S.screenFlashRGB[1] ~= a3 then
                        S.screenFlashRGB[1] = a3
                        U()
                    end
                end,function()end)
                RageUI.List("Screen Flash Green",J,S.screenFlashRGB[2],"",{},S.screenFlash,function(a0, a1, a2, a3)
                        if a1 and S.screenFlashRGB[2] ~= a3 then
                            S.screenFlashRGB[2] = a3
                            U()
                        end
                    end,function()end)
                RageUI.List("Screen Flash Blue",J,S.screenFlashRGB[3],"",{},S.screenFlash,function(a0, a1, a2, a3)
                    if a1 and S.screenFlashRGB[3] ~= a3 then
                        S.screenFlashRGB[3] = a3
                        U()
                    end
                end,function()end)
                RageUI.List("Screen Flash Intensity",L,S.screenFlashIntensity,"",{},S.screenFlash,function(a0, a1, a2, a3)
                    if a1 and S.screenFlashIntensity ~= a3 then
                        S.screenFlashIntensity = a3
                        U()
                    end
                end,function()end)
                RageUI.List("Screen Flash Time",N,S.screenFlashTime,"",{},S.screenFlash,function(a0, a1, a2, a3)
                    if a1 and S.screenFlashTime ~= a3 then
                        S.screenFlashTime = a3
                        U()
                    end
                end,function()end)
            end
            RageUI.List("Timecycle Flash",R,S.timecycle,"",{},true,function(a0, a1, a2, a3)
                if a1 and S.timecycle ~= a3 then
                    S.timecycle = a3
                    U()
                end
            end,function()end)
            if S.timecycle ~= 1 then
                RageUI.List("Timecycle Flash Time",N,S.timecycleTime,"",{},true,function(a0, a1, a2, a3)
                    if a1 and S.timecycleTime ~= a3 then
                        S.timecycleTime = a3
                        U()
                    end
                end,function()end)
            end
            RageUI.List("~y~Particles~w~",P,S.particle,"",{},true,function(a0, a1, a2, a3)
                if a1 and S.particle ~= a3 then
                    if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                        notify("~y~You need to be a subscriber of NOVA Plus or NOVA Platinum to use this feature.")
                        notify("~y~Available @ store.novarp.co.uk")
                    end
                    S.particle = a3
                    U()
                end
            end,function()end)
            local ad = 0
            if S.lightning then
                ad = math.max(ad, 1000)
            end
            if S.pedFlash then
                ad = math.max(ad, O[S.pedFlashTime])
            end
            if S.screenFlash then
                ad = math.max(ad, O[S.screenFlashTime])
            end
            if S.timecycleTime ~= 1 then
                ad = math.max(ad, K[S.timecycleTime])
            end
            if S.particle ~= 1 then
                ad = math.max(ad, 1000)
            end
            if GetGameTimer() - T > ad + 1000 then
                tvRP.addKillEffect(PlayerPedId(), true)
                T = GetGameTimer()
            end
            DrawAdvancedTextNoOutline(0.59, 0.9, 0.005, 0.0028, 1.5, "PREVIEW", 255, 0, 0, 255, 2, 0)
        end)
    end
    if RageUI.Visible(RMenu:Get('settingdev', 'bloodeffects')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.List("~y~Head",P,W.head,"Effect that displays when you hit the head.",{},true,function(a0, a1, a2, a3)
                if W.head ~= a3 then
                    if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                        notify("~y~You need to be a subscriber of NOVA Plus or NOVA Platinum to use this feature.")
                        notify("~y~Available @ store.novarp.co.uk")
                    end
                    W.head = a3
                    X()
                end
                if a2 then
                    tvRP.addBloodEffect("head", 0x796E, PlayerPedId())
                end
            end)
            RageUI.List("~y~Body",P,W.body,"Effect that displays when you hit the body.",{},true,function(a0, a1, a2, a3)
                if W.body ~= a3 then
                    if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                        notify("~y~You need to be a subscriber of NOVA Plus or NOVA Platinum to use this feature.")
                        notify("~y~Available @ store.novarp.co.uk")
                    end
                    W.body = a3
                    X()
                end
                if a2 then
                    tvRP.addBloodEffect("body", 0x0, PlayerPedId())
                end
            end)
            RageUI.List("~y~Arms",P,W.arms,"Effect that displays when you hit the arms.",{},true,function(a0, a1, a2, a3)
                if W.arms ~= a3 then
                    if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                        notify("~y~You need to be a subscriber of NOVA Plus or NOVA Platinum to use this feature.")
                        notify("~y~Available @ store.novarp.co.uk")
                    end
                    W.arms = a3
                    X()
                end
                if a2 then
                    tvRP.addBloodEffect("arms", 0xBB0, PlayerPedId())
                    tvRP.addBloodEffect("arms", 0x58B7, PlayerPedId())
                end
            end)
            RageUI.List("~y~Legs",P,W.legs,"Effect that displays when you hit the legs.",{},true,function(a0, a1, a2, a3)
                if W.legs ~= a3 then
                    if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                        notify("~y~You need to be a subscriber of NOVA Plus or NOVA Platinum to use this feature.")
                        notify("~y~Available @ store.novarp.co.uk")
                    end
                    W.legs = a3
                    X()
                end
                if a2 then
                    tvRP.addBloodEffect("legs", 0x3FCF, PlayerPedId())
                    tvRP.addBloodEffect("legs", 0xB3FE, PlayerPedId())
                end
            end)
        end)
    end
end)

local function at()

    local al = GetGameTimer()

    local am = math.floor(M[U.screenFlashRGB[1]] * 255)

    local an = math.floor(M[U.screenFlashRGB[2]] * 255)

    local ao = math.floor(M[U.screenFlashRGB[3]] * 255)

    local ap = O[U.screenFlashIntensity]

    local aq = Q[U.screenFlashTime]

    while GetGameTimer() - al < aq do

        local ar = (aq - (GetGameTimer() - al)) / aq

        local as = math.floor(25.5 * ap * ar)

        DrawRect(0.0, 0.0, 2.0, 2.0, am, an, ao, as)

        Citizen.Wait(0)

    end

end

local function au(ab)

    local ac = GetEntityCoords(ab, true)

    local av = S[U.particle]

    tvRP.loadPtfx(av[1])

    UseParticleFxAsset(av[1])

    StartParticleFxNonLoopedAtCoord(av[2], ac.x, ac.y, ac.z, 0.0, 0.0, 0.0, av[3], false, false, false)

    RemoveNamedPtfxAsset(av[1])

end

local function aw()

    local al = GetGameTimer()

    local aq = Q[U.timecycleTime]

    SetTimecycleModifier(T[U.timecycle])

    while GetGameTimer() - al < aq do

        local ar = (aq - (GetGameTimer() - al)) / aq

        SetTimecycleModifierStrength(1.0 * ar)

        Citizen.Wait(0)

    end

    ClearTimecycleModifier()

end

function tvRP.addKillEffect(ax, ay)

    if U.lightning then

        ForceLightningFlash()

    end

    if U.pedFlash then

        Citizen.CreateThreadNow(function()

            aa(ax)

        end)

    end

    if U.screenFlash then

        Citizen.CreateThreadNow(function()

            at()

        end)

    end

    if U.particle ~= 1 and (tvRP.isPlatClub() or ay) then

        Citizen.CreateThreadNow(function()

            au(ax)

        end)

    end

    if U.timecycle ~= 1 then

        Citizen.CreateThreadNow(function()

            aw()

        end)

    end

end

function tvRP.addBloodEffect(az, aA, ab)

    local aB = Y[az]

    if aB > 1 then

        local av = S[aB]

        tvRP.loadPtfx(av[1])

        UseParticleFxAsset(av[1])

        StartParticleFxNonLoopedOnPedBone(av[2], ab, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, aA, av[3], false, false, false)

        RemoveNamedPtfxAsset(av[1])

    end

end

AddEventHandler("NOVA:onPlayerKilledPed",function(aC)

    tvRP.addKillEffect(aC, false)

end)

local aD = {

    [0x0] = "body",

    [0x2E28] = "body",

    [0xE39F] = "legs",

    [0xF9BB] = "legs",

    [0x3779] = "legs",

    [0x83C] = "legs",

    [0xCA72] = "legs",

    [0x9000] = "legs",

    [0xCC4D] = "legs",

    [0x512D] = "legs",

    [0xE0FD] = "body",

    [0x5C01] = "body",

    [0x60F0] = "body",

    [0x60F1] = "body",

    [0x60F2] = "body",

    [0xFCD9] = "body",

    [0xB1C5] = "arms",

    [0xEEEB] = "arms",

    [0x49D9] = "arms",

    [0x67F2] = "arms",

    [0xFF9] = "arms",

    [0xFFA] = "arms",

    [0x67F3] = "arms",

    [0x1049] = "arms",

    [0x104A] = "arms",

    [0x67F4] = "arms",

    [0x1059] = "arms",

    [0x105A] = "arms",

    [0x67F5] = "arms",

    [0x1029] = "arms",

    [0x102A] = "arms",

    [0x67F6] = "arms",

    [0x1039] = "arms",

    [0x103A] = "arms",

    [0x29D2] = "arms",

    [0x9D4D] = "arms",

    [0x6E5C] = "arms",

    [0xDEAD] = "arms",

    [0xE5F2] = "arms",

    [0xFA10] = "arms",

    [0xFA11] = "arms",

    [0xE5F3] = "arms",

    [0xFA60] = "arms",

    [0xFA61] = "arms",

    [0xE5F4] = "arms",

    [0xFA70] = "arms",

    [0xFA71] = "arms",

    [0xE5F5] = "arms",

    [0xFA40] = "arms",

    [0xFA41] = "arms",

    [0xE5F6] = "arms",

    [0xFA50] = "arms",

    [0xFA51] = "arms",

    [0x9995] = "head",

    [0x796E] = "head",

    [0x5FD4] = "head",

    [0xD003] = "body",

    [0x45FC] = "body",

    [0x1D6B] = "legs",

    [0xB23F] = "legs"

}

AddEventHandler("NOVA:onPlayerDamagePed",function(aC)

    if not tvRP.isPlusClub() and not tvRP.isPlatClub() then

        return

    end

    local aE, aA = GetPedLastDamageBone(aC, 0)

    if aE then

        local aF = GetPedBoneIndex(aC, aA)

        local aG = GetWorldPositionOfEntityBone(aC, aF)

        local aH = aD[aA]

        if not aH then

            local aI = GetWorldPositionOfEntityBone(aC, GetPedBoneIndex(aC, 0x9995))

            local aJ = GetWorldPositionOfEntityBone(aC, GetPedBoneIndex(aC, 0x2E28))

            if aG.z >= aI.z - 0.01 then

                aH = "head"

            elseif aG.z < aJ.z then

                aH = "legs"

            else

                local aK = GetEntityCoords(aC, true)

                local aL = #(aK.xy - aG.xy)

                if aL > 0.075 then

                    aH = "arms"

                else

                    aH = "body"

                end

            end

        end

        tvRP.addBloodEffect(aH, aA, aC)

    end

end)

local L = {

    "0%",

    "5%",

    "10%",

    "15%",

    "20%",

    "25%",

    "30%",

    "35%",

    "40%",

    "45%",

    "50%",

    "55%",

    "60%",

    "65%",

    "70%",

    "75%",

    "80%",

    "85%",

    "90%",

    "95%",

    "100%"

}

local M = {

    0.0,

    0.05,

    0.1,

    0.15,

    0.2,

    0.25,

    0.3,

    0.35,

    0.4,

    0.45,

    0.5,

    0.55,

    0.6,

    0.65,

    0.7,

    0.75,

    0.8,

    0.85,

    0.9,

    0.95,

    1.0

}

local N = {

    "25%",

    "50%",

    "75%",

    "100%",

    "125%",

    "150%",

    "175%",

    "200%",

    "250%",

    "300%",

    "350%",

    "400%",

    "450%",

    "500%",

    "750%",

    "1000%"

}

local O = {0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 7.5, 10.0}

local P = {

    "0.1s",

    "0.2s",

    "0.3s",

    "0.4s",

    "0.5s",

    "0.6s",

    "0.7s",

    "0.8s",

    "0.9s",

    "1s",

    "1.25s",

    "1.5s",

    "1.75s",

    "2.0s"

}

local Q = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1250, 1500, 1750, 2000}

local R = {

    "Disabled",

    "Fireworks",

    "Celebration",

    "Firework Burst",

    "Water Explosion",

    "Ramp Explosion",

    "Gas Explosion",

    "Electrical Spark",

    "Electrical Explosion",

    "Concrete Impact",

    "EMP 1",

    "EMP 2",

    "EMP 3",

    "Spike Mine",

    "Kinetic Mine",

    "Tar Mine",

    "Short Burst",

    "Fog Sphere",

    "Glass Smash",

    "Glass Drop",

    "Falling Leaves",

    "Wood Smash",

    "Train Smoke",

    "Money",

    "Confetti",

    "Marbles",

    "Sparkles"

}

local S = {

    {"DISABLED", "DISABLED", 1.0},

    {"scr_indep_fireworks", "scr_indep_firework_shotburst", 0.2},

    {"scr_xs_celebration", "scr_xs_confetti_burst", 1.2},

    {"scr_rcpaparazzo1", "scr_mich4_firework_burst_spawn", 1.0},

    {"particle cut_finale1", "cs_finale1_car_explosion_surge_spawn", 1.0},

    {"des_fib_floor", "ent_ray_fbi5a_ramp_explosion", 1.0},

    {"des_gas_station", "ent_ray_paleto_gas_explosion", 0.5},

    {"core", "ent_dst_electrical", 1.0},

    {"core", "ent_sht_electrical_box", 1.0},

    {"des_vaultdoor", "ent_ray_pro1_concrete_impacts", 1.0},

    {"scr_xs_dr", "scr_xs_dr_emp", 1.0},

    {"scr_xs_props", "scr_xs_exp_mine_sf", 1.0},

    {"veh_xs_vehicle_mods", "exp_xs_mine_emp", 1.0},

    {"veh_xs_vehicle_mods", "exp_xs_mine_spike", 1.0},

    {"veh_xs_vehicle_mods", "exp_xs_mine_kinetic", 1.0},

    {"veh_xs_vehicle_mods", "exp_xs_mine_tar", 1.0},

    {"scr_stunts", "scr_stunts_shotburst", 1.0},

    {"scr_tplaces", "scr_tplaces_team_swap", 1.0},

    {"des_fib_glass", "ent_ray_fbi2_window_break", 1.0},

    {"des_fib_glass", "ent_ray_fbi2_glass_drop", 2.5},

    {"des_stilthouse", "ent_ray_fam3_falling_leaves", 1.0},

    {"des_stilthouse", "ent_ray_fam3_wood_frags", 1.0},

    {"des_train_crash", "ent_ray_train_smoke", 1.0},

    {"core", "ent_brk_banknotes", 2.0},

    {"core", "ent_dst_inflate_ball_clr", 1.0},

    {"core", "ent_dst_gen_gobstop", 1.0},

    {"core", "ent_sht_telegraph_pole", 1.0}

}

local T = {

    "Disabled",

    "BikerFilter",

    "CAMERA_BW",

    "drug_drive_blend01",

    "glasses_blue",

    "glasses_brown",

    "glasses_Darkblue",

    "glasses_green",

    "glasses_purple",

    "glasses_red",

    "helicamfirst",

    "hud_def_Trevor",

    "Kifflom",

    "LectroDark",

    "MP_corona_tournament_DOF",

    "MP_heli_cam",

    "mugShot",

    "NG_filmic02",

    "REDMIST_blend",

    "trevorspliff",

    "ufo",

    "underwater",

    "WATER_LAB",

    "WATER_militaryPOOP",

    "WATER_river",

    "WATER_salton"

}

local U = {

    lightning = false,

    pedFlash = false,

    pedFlashRGB = {11, 11, 11},

    pedFlashIntensity = 4,

    pedFlashTime = 1,

    screenFlash = false,

    screenFlashRGB = {11, 11, 11},

    screenFlashIntensity = 4,

    screenFlashTime = 1,

    particle = 1,

    timecycle = 1,

    timecycleTime = 1

}

local function aa(ab)

    local ac = GetEntityCoords(ab, true)

    local al = GetGameTimer()

    local am = math.floor(M[U.pedFlashRGB[1]] * 255)

    local an = math.floor(M[U.pedFlashRGB[2]] * 255)

    local ao = math.floor(M[U.pedFlashRGB[3]] * 255)

    local ap = O[U.pedFlashIntensity]

    local aq = Q[U.pedFlashTime]

    while GetGameTimer() - al < aq do

        local ar = (aq - (GetGameTimer() - al)) / aq

        local as = ap * 25.0 * ar

        DrawLightWithRange(ac.x, ac.y, ac.z + 1.0, am, an, ao, 50.0, as)

        Citizen.Wait(0)

    end

end

local V = 0

local function W()

    local X = json.encode(U)

    SetResourceKvp("nova_kill_effects", X)

end

local Y = {head = 1, body = 1, arms = 1, legs = 1}

local function Z()

    local _ = json.encode(Y)

    SetResourceKvp("nova_blood_effects", _)

end

Citizen.CreateThread(function()

    Citizen.Wait(0)

    local K = GetResourceKvpString("nova_graphic_presets")

    if K and K ~= "" then

        u = json.decode(K) or {}

    end

    for E, A in pairs(a.presets) do

        for E, B in pairs(A.presets) do

            if v(A, B) then

                H(B)

            end

        end

    end

    local X = GetResourceKvpString("nova_kill_effects") --// may need to remove

    if X and X ~= "" then

        local a0 = json.decode(X)

        for a1, J in pairs(a0) do

            if U[a1] then

                U[a1] = J

            end

        end

    end

    local _ = GetResourceKvpString("nova_blood_effects")

    if _ and _ ~= "" then

        local a0 = json.decode(_)

        for a1, J in pairs(a0) do

            if Y[a1] then

                Y[a1] = J

            end

        end

    end

end)