
fx_version 'cerulean'
games {  'gta5' }

description "NOVA MySQL async - Modified Version"
dependency "ghmattimysql"
-- server scripts
server_scripts{ 
  "@NOVA/lib/utils.lua",
  "MySQL.lua"
}

