fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

version '1.0.0'
author 'Cfx.re <root@cfx.re>'
description 'Provides baseline chat functionality using a NUI-based interface.'
repository 'https://github.com/citizenfx/cfx-server-data'

-- UI
ui_page "ui/index.html"
files {
	"ui/index.html",
	"ui/assets/arrow-left.png",
	"ui/assets/arrow-right.png",
	"ui/assets/radio-check.png",
	"ui/assets/radio-check-black.png",
	"ui/assets/head.png",
	"ui/assets/identity.png",
	"ui/assets/pilosite.png",
	"ui/assets/clothes.png",
	"ui/assets/cursor.png",
	"ui/assets/heritage/Face-0.jpg",
	"ui/assets/heritage/Face-1.jpg",
	"ui/assets/heritage/Face-2.jpg",
	"ui/assets/heritage/Face-3.jpg",
	"ui/assets/heritage/Face-4.jpg",
	"ui/assets/heritage/Face-5.jpg",
	"ui/assets/heritage/Face-6.jpg",
	"ui/assets/heritage/Face-7.jpg",
	"ui/assets/heritage/Face-8.jpg",
	"ui/assets/heritage/Face-9.jpg",
	"ui/assets/heritage/Face-10.jpg",
	"ui/assets/heritage/Face-11.jpg",
	"ui/assets/heritage/Face-12.jpg",
	"ui/assets/heritage/Face-13.jpg",
	"ui/assets/heritage/Face-14.jpg",
	"ui/assets/heritage/Face-15.jpg",
	"ui/assets/heritage/Face-16.jpg",
	"ui/assets/heritage/Face-17.jpg",
	"ui/assets/heritage/Face-18.jpg",
	"ui/assets/heritage/Face-19.jpg",
	"ui/assets/heritage/Face-20.jpg",
	"ui/assets/heritage/Face-21.jpg",
	"ui/assets/heritage/Face-22.jpg",
	"ui/assets/heritage/Face-23.jpg",
	"ui/assets/heritage/Face-24.jpg",
	"ui/assets/heritage/Face-25.jpg",
	"ui/assets/heritage/Face-26.jpg",
	"ui/assets/heritage/Face-27.jpg",
	"ui/assets/heritage/Face-28.jpg",
	"ui/assets/heritage/Face-29.jpg",
	"ui/assets/heritage/Face-30.jpg",
	"ui/assets/heritage/Face-31.jpg",
	"ui/assets/heritage/Face-32.jpg",
	"ui/assets/heritage/Face-33.jpg",
	"ui/assets/heritage/Face-34.jpg",
	"ui/assets/heritage/Face-35.jpg",
	"ui/assets/heritage/Face-36.jpg",
	"ui/assets/heritage/Face-37.jpg",
	"ui/assets/heritage/Face-38.jpg",
	"ui/assets/heritage/Face-39.jpg",
	"ui/assets/heritage/Face-40.jpg",
	"ui/assets/heritage/Face-41.jpg",
	"ui/assets/heritage/Face-42.jpg",
	"ui/assets/heritage/Face-43.jpg",
	"ui/assets/heritage/Face-44.jpg",
	"ui/assets/heritage/Face-45.jpg",
	"ui/fonts/Circular-Bold.ttf",
	"ui/fonts/Circular-Book.ttf",
	"ui/front.js",
	"ui/script.js",
	"ui/style.css",
	"ui/debounce.min.js",
	-- JS LOCALES
	"ui/locales/nl.js",
	"ui/locales/en.js",
	"ui/tabs.css"
}

-- Client Scripts
client_scripts {
    "client/cl_skin.lua"
}

-- Server Scripts
server_scripts {
    "@gmt/lib/utils.lua",
    "server/sv_skin.lua"
}