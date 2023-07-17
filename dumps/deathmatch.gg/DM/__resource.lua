resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "DM Framework"

ui_page "html/index.html"

files {
  'html/sounds/*.ogg',
  'html/index.html',
  'html/style.css',
  'html/main.js',
  'html/img/*.webp',
  'html/img/*.png',
  'html/*.ttf',
  'html/*.woff',
  'meta/weapons.meta',
}

server_scripts{ 
  "lib/utils.lua",
  "base.lua",
  "modules/*.lua",
}

client_scripts{
  "RageUI/src/RMenu.lua",
  "RageUI/src/menu/RageUI.lua",
  "RageUI/src/menu/Menu.lua",
  "RageUI/src/menu/MenuController.lua",
  "RageUI/src/components/Audio.lua",
  "RageUI/src/components/Rectangle.lua",
  "RageUI/src/components/Screen.lua",
  "RageUI/src/components/Sprite.lua",
  "RageUI/src/components/Text.lua",
  "RageUI/src/components/Visual.lua",
  "RageUI/src/menu/elements/ItemsBadge.lua",
  "RageUI/src/menu/elements/ItemsColour.lua",
  "RageUI/src/menu/elements/PanelColour.lua",
  "RageUI/src/menu/items/UIButton.lua",
  "RageUI/src/menu/items/UICheckBox.lua",
  "RageUI/src/menu/items/UIList.lua",
  "RageUI/src/menu/items/UIProgress.lua",
  "RageUI/src/menu/items/UISlider.lua",
  "RageUI/src/menu/items/UISliderHeritage.lua",
  "RageUI/src/menu/items/UISeparator.lua",
  "RageUI/src/menu/items/UISliderProgress.lua",
  "RageUI/src/menu/panels/UIColourPanel.lua",
  "RageUI/src/menu/panels/UIGridPanel.lua",
  "RageUI/src/menu/panels/UIGridPanelHorizontal.lua",
  "RageUI/src/menu/panels/UIPercentagePanel.lua",
  "RageUI/src/menu/panels/UIStatisticsPanel.lua",
  "RageUI/src/menu/windows/UIHeritage.lua",
  "configs/*.lua",
  "lib/utils.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/scaleform_Helpers.lua",
  "client/scaleform_Funcs.lua",
  "client/scaleform_Functions.lua",
  "client/buttons.lua",
  "client/base.lua",
  "client/functions.lua",
  "client/cl_*.lua",
}


data_file 'WEAPONINFO_FILE_PATCH' 'meta/weapons.meta'