fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

escrow_ignore {
	'*',
	'*/*',
}

files {
	'html/index.html',
	'html/main.js',
	'html/style.css',
	'html/images/*',
	'html/AXIS.ttf',
}
dependency '/assetpacks'
dependency '/assetpacks'
dependency '/assetpacks'