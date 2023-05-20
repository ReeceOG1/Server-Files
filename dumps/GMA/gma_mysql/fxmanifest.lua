
fx_version 'cerulean'
games {  'gta5' }

description "GMA MySQL async - Modified Version"
dependency "ghmattimysql"
-- server scripts
server_scripts{ 
  "@gma/lib/utils.lua",
  "MySQL.lua"
}

