fx_version "bodacious"
game "gta5"

ui_page "HUD/ui.html"

client_script "client/client.lua"
client_scripts {
    "server/mapmanager_shared.lua",
    "client/mapmanager_client.lua",
    "client/empty.lua",
    "client/spawnmanager.lua",
    "client/basic_client.lua"
}

server_scripts {
    "server/mapmanager_shared.lua",
    "server/mapmanager_server.lua"
}



resource_type 'gametype' { name = 'Freeroam' }

server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"
server_export "roundEnded"
files {
    "config.js",
    "HUD/ui.html",
    "assets/css/style.css",
    "assets/img/cursor.png",
    "assets/img/discord.png",
    "assets/img/home.png",
    "assets/img/garage.png",
    "assets/js/app.js",
    "assets/js/music.js"
}