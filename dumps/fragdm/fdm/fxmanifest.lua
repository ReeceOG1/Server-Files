fx_version 'cerulean'
games {  'gta5' }

dependency "ghmattimysql"
dependency "fdm_mysql"

ui_page "gui/index.html"

shared_scripts {
  "sharedcfg/*"
}

data_file 'POPSCHED_FILE' 'stream/popcycle.dat'

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
  "base.lua",
  "modules/sv_anticheat.lua",
  "modules/sv_safeZones.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/sv_admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/sv_discordPresence.lua",
  "modules/inventory.lua",
  "modules/identity.lua",
  "modules/item_transformer.lua",
  "modules/sv_privateLobbies.lua",
  "modules/sv_gunstores.lua",
  "modules/sv_turfs.lua",
  "modules/sv_baseEvents.lua",
  "modules/aptitude.lua",
  "modules/sv_publicLobbies.lua",
  "modules/basic_garage.lua",
  "modules/basic_skinshop.lua",
  "modules/LsCustoms.lua",
  "modules/server_commands.lua",
  "modules/sv_gunSelector.lua",
  "modules/sv_vehCleanup.lua",
  "modules/sv_weather.lua",
  "servercfg/*.lua"
  -- "modules/hotkeys.lua"
}

-- client scripts
client_scripts{
  "cfg/skinshops.lua",
  "cfg/garages.lua",
  "cfg/admin_menu.lua",
  "lib/utils.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "utils/*",
  "client/iplloader.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/basic_garage.lua",
  "client/cl_admin.lua",
  "client/cl_weather.lua",
  "client/enumerators.lua",
  "client/gunSelector.lua",
  "client/cl_adminmenu.lua",
  "client/LsCustomsMenu.lua",
  "client/LsCustoms.lua",
  "client/playerClothingStore.lua",
  "client/cl_vehFail.lua",
  "client/cl_turfs.lua",
  "client/cl_discordPresence.lua",
  "client/cl_antivdm.lua",
  "client/cl_playerBlips.lua",
  "client/cl_gunstores.lua",
  "client/cl_baseEvents.lua",
  "client/cl_settings.lua",
  "client/cl_publicLobbies.lua",
  "client/cl_turfs.lua",
  "client/cl_privateLobbies.lua",
  "client/cl_crouch.lua",
  "client/cl_menu.lua",
  "client/cl_gameSettings.lua",
  "client/cl_weaponsOnBack.lua",
  "client/cl_switchgun.lua",
  "client/cl_anticheat.lua",
  "client/cl_idsaboveHead.lua",
  "client/cl_interactionPeds.lua",
  "client/cl_handsup.lua",
  -- "hotkeys/hotkeys.lua"
}

-- client files
files{
  'stream/popcycle.dat',
  "cfg/client.lua",
  "gui/index.html",
  "gui/design.css",
  "gui/main.js",
  "gui/Menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/AnnounceManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js",
  "gui/fonts/Pdown.woff",
  "gui/fonts/GTA.woff"
}
