
fx_version "bodacious"
game "gta5"

ui_page "ui/index.html"
client_script "client.lua"

server_scripts {
    "@vrp/lib/utils.lua",
    "@mysql-async/lib/MySQL.lua",
	"server.lua"
}

files {
	"ui/RadialMenu/RadialMenu.css",
	"ui/RadialMenu/RadialMenu.js",
	"ui/script.js",
	"ui/style.css",
	"ui/assets/cursor.png",
	"ui/index.html"
}