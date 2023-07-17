resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

this_is_a_map 'yes'

files {
	"peds.meta",
	"weaponrevolver.meta",
	"data/carcols.meta",
	"stream/**/*.ytyp",
	"dlc_hitmarkers/*.awc",
	"data/audio/hitmarkers_sounds.dat54.rel",
    "data/audio/hitmarkers_sounds.dat54.nametable",
	"data/carcols_gen9.meta",
    "data/carmodcols_gen9.meta",
	"data/popgroups.ymt",
	'mp_m_freemode_01_mp_m_clothing.meta',
	'mp_f_freemode_01_mp_f_clothing.meta',
	'peds.meta',
	'tattoos/tpack_overlays.xml',
	'tattoos/new_overlays.xml',
	'tattoos/shop_tattoo.meta',
	"FRTexture_cache_y.dat"
}
client_scripts {
	"client.lua",
	"cl_paleto.lua"
}


data_file 'WEAPONINFO_FILE_PATCH' 'weaponrevolver.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weaponcompactlauncher.meta'
data_file 'CARCOLS_FILE' 'data/carcols.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'
data_file "AUDIO_WAVEPACK" "dlc_hitmarkers"
data_file "AUDIO_SOUNDDATA" "data/audio/hitmarkers_sounds.dat"
data_file "CARCOLS_GEN9_FILE" "data/carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "data/carmodcols_gen9.meta"
data_file "DLC_POP_GROUPS" "data/popgroups.ymt"
data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_m_freemode_01_mp_m_clothing.meta'
data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_f_freemode_01_mp_f_clothing.meta'
data_file 'PED_METADATA_FILE' 'peds.meta'
data_file 'PED_OVERLAY_FILE' 'tattoos/new_overlays.xml'
data_file 'PED_OVERLAY_FILE' 'tattoos/tpack_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'tattoos/shop_tattoo.meta'
