



fx_version 'cerulean'
games {  'gta5' }

description "RP module/framework"

dependency "ghmattimysql"
dependency "NOVA_mysql"

shared_script '@NOVAPmc/import.lua'

ui_page "gui/index.html"

shared_scripts {
  "sharedcfg/*"
}

-- RageUI
client_scripts {
	"rageui/RMenu.lua",
	"rageui/menu/RageUI.lua",
	"rageui/menu/Menu.lua",
	"rageui/menu/MenuController.lua",
	"rageui/components/*.lua",
	"rageui/menu/elements/*.lua",
	"rageui/menu/items/*.lua",
	"rageui/menu/panels/*.lua",
	"rageui/menu/panels/*.lua",
	"rageui/menu/windows/*.lua"
}

-- server scripts
server_scripts{ 
  "lib/utils.lua",
  "lib/Housingutils.lua",
  "base.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/inventory.lua",
  "modules/identity.lua",
  "modules/police.lua",
  "modules/aptitude.lua",
  "modules/sv_playerlist.lua",

  -- basic implementations
  "modules/basic_phone.lua",
  "modules/basic_atm.lua",
  "modules/sv_gangmenu.lua",
  "modules/sv_deathscreen.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/sv_policemenu.lua",
  "modules/paycheck.lua",
  "modules/LsCustoms.lua",
  "modules/sv_aamenu.lua",
  "modules/server_commands.lua",
  "modules/warningsystem.lua",
  "modules/sv_cmds.lua",
  "modules/sv_dealership.lua",
  "modules/sv_entitygun.lua",
  "modules/sv_panic.lua",
  "modules/sv_tebex.lua",
  "modules/sv_phone.lua",
  "modules/sv_carry.lua",
  "modules/sv_cardev.lua",
  "modules/sv_anticheat.lua",
  "modules/sv_speedgun.lua",
  "modules/sv_djmenu.lua",
  "modules/sv_tutorial.lua",
  "modules/sv_killfeed.lua",
  "modules/sv_vipclub.lua",
  "modules/sv_groupselector.lua",
  "modules/sv_discordroles.lua",
  "modules/sv_cinematic.lua",
  "novamodules/modules/sv_*.lua",
  "cfg/discordroles.lua",
  "cfg/items.lua",
  "modules/sv_restart.lua",	
}

-- client scripts
client_scripts{
  "lib/cl_thread.lua",
  "lib/cl_cache.lua",
  "lib/cl_util.lua",
  "cfg/atms.lua",

  "cfg/cfg_weapons.lua",
  "cfg/skinshops.lua",
  "cfg/admin_menu.lua",
  "cfg/cfg_groupselector.lua", 
  "cfg/cfg_*.lua",
  "lib/utils.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "client/cl_combattimer.lua",
  "utils/*",
  "client/iplloader.lua",
  "client/cl_policemenu.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/cl_map.lua",
  "client/survival.lua",
  "client/map.lua",
  "client/identity.lua",
  "client/cl_cinematic.lua",
  "client/basic_garage.lua",
  "client/cl_anticheat.lua",
  "client/cl_entitygun.lua",
  "client/cl_weaponsonback.lua",
  "client/police.lua",
  "client/cl_aamenu.lua",
  "client/cl_policehotkeys.lua",
  "client/lockcar-client.lua",
  "client/admin.lua",
  "client/enumerators.lua",
  "client/clothing.lua",
  "client/cl_moneydrop.lua",
  "client/atms.lua",
  "client/garages.lua",
  "client/cl_panic.lua",
  "novamodules/client/cl_*.lua",
  "client/cl_gangmenu.lua",
  "client/adminmenu.lua",
  "client/LsCustomsMenu.lua",
  "client/LsCustoms.lua",
  "client/warningsystem.lua",
  'client/cl_phone.lua',
  "client/cl_carry.lua",
  "client/cl_cmds.lua",
  "client/cl_cardev.lua",
  "client/cl_speedgun.lua",
  "client/cl_vehiclemenu.lua",
  "client/cl_vehiclewhitelist.lua",
  "client/cl_anpr.lua",
  "client/cl_djmenu.lua",
  "client/cl_tutorial.lua",
  "client/cl_killfeed.lua",
  "client/cl_vipclub.lua",
  "client/cl_groupselector.lua",
  "client/cl_policeloadout.lua",
  "client/cl_playerlist.lua",
  "client/cl_restart.lua",
  "novamodules/cfg/cfg_*.lua",
}

-- client files
files{
  "lib/HousingTunnel.lua",
  "cfg/client.lua",
  "cfg/cfg_*.lua",
  "gui/index.html",
  "gui/design.css",
  "gui/index.css",
  "gui/main.js",
  "gui/index.js",
  "gui/Menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/AnnounceManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js",
  "gui/fonts/Pdown.woff",
  "gui/fonts/GTA.woff",
  "gui/img/death.png",
   "gui/killfeed/img/*.png",
  "gui/killfeed/font/stratum2-bold-webfont.woff",
  "gui/killfeed/index.js",
  "gui/killfeed/style.css",
  "gui/money/img/*.png",
  "gui/money/index.css",
  "gui/money/index.js",
  "gui/playerlist_images/*.png",
}
