









fx_version 'bodacious'
game 'gta5'

ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/assets/bank.png",
	"ui/assets/cash.png",
	"ui/script.js",
	"ui/style.css",
	"ui/debounce.min.js"
}

client_scripts {
    "cl_moneyui.lua",
}

server_scripts {
    "@vrp/lib/utils.lua",
    "sv_moneyui.lua",
}

shared_scripts {
    'cfg_moneyui.lua'
}
