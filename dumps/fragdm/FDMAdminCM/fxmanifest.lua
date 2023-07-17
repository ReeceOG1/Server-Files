fx_version 'cerulean'
games { 'gta5' }
author '15'

ui_page "index.html"

client_scripts {
    "pmcCallbacks.lua",
    "client.lua",
}

server_scripts {
    '@fdm/lib/utils.lua',
    "ServerpmcCallbacks.lua",
    "server.lua",
}

files{
    "index.html",
    "script.js", 
    "style.css",
    "assests/*",
}