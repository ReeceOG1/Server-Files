fx_version 'bodacious'
games { 'gta5' }

description "NOVA Death UI"

ui_page "ui/index.html"

-- client scripts
client_scripts{
    "@NOVA/lib/utils.lua",
    "client/*.lua",
}

-- html files for death ui
files{
    "ui/*.ttf",
    "ui/*.otf",
    "ui/*.woff",
    "ui/*.woff2",
    "ui/*.css",
    "ui/*.png",
    "ui/main.js",
    "ui/index.html",
}

