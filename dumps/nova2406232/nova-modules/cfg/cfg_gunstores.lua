GunCFG = {}
GunCFG.Info = {
    ["knife"] = {
        gangnum = 0,
        permission = "player.phone",
        Coords = vector3(-3172.02,1087.75,20.84),
        Name = "Shank Shop",
        weapons = {
            {name = "Shank", price = 200, hash = "WEAPON_SHANK", model = "w_me_shank"},
            {name = "Butter Fly Knife", price = 500, hash = "WEAPON_BUTTERFLY", model = "w_me_butterfly"},
            {name = "Crutch", price = 9000, hash = "WEAPON_CRUTCH", model = "w_me_crutch"},
            {name = "Kitchen Knife", price = 400, hash = "WEAPON_SHANK", model = "w_me_kitchenknife"},
            {name = "Toilet Brush", price = 300, hash = "WEAPON_TOILETBRUSH", model = "w_me_toiletbrush"},
            {name = "Guitar", price = 6000, hash = "WEAPON_GUITAR", model = "w_me_guitar"},
        },
        maxarmour = 0
    },

    ["smallarms"] = {
        gangnum = 0,
        permission = "player.phone",
        Coords = vector3(-1499.76,-216.65,47.89),
        Name = "Small Arms",
        weapons = {
            {name = "M1911", price = 50000, hash = "WEAPON_M1911", model = "w_ar_m1911"},
            {name = "Makarov", price = 60000, hash = "WEAPON_MAKAROV", model = "w_pi_makarov"},
            {name = "UZI", price = 190000, hash = "WEAPON_UZI", model = "w_sb_uzi"},
        },
        maxarmour = 25
    },

    ["smallarms2"] = {
        gangnum = 0,
        permission = "player.phone",
        Coords = vector3(2433.758, 4968.672, 42.3385),
        Name = "Sandy Small Arms",
        weapons = {
            {name = "M1911", price = 50000, hash = "WEAPON_M1911", model = "w_pi_m1911"},
            {name = "Makarov", price = 60000, hash = "WEAPON_MAKAROV", model = "w_pi_makarov"},
            {name = "UZI", price = 190000, hash = "WEAPON_UZI", model = "w_sb_uzi"},
        },
        maxarmour = 25
    },

    ["large"] = {
        gangnum = 7,
        permission = "gang.guns",
        Coords = vector3(-1106.67,4935.38,218.37),
        Name = "Large Arms",
        weapons = {
            {name = "AK-74", price = 650000, hash = "WEAPON_AK74"},
            {name = "AK-74 Kashnar", price = 650000, hash = "WEAPON_KASHNAR"},
            {name = "LVOA-C", price = 650000, hash = "WEAPON_LVOA"},
            {name = "UMP-45", price = 250000, hash = "WEAPON_UMP"},
            {name = "Mosin Nagant", price = 850000, hash = "WEAPON_MOSIN"},
            {name = "Winchester 12", price = 350000, hash = "WEAPON_WINCHESTER12"},
        },
        maxarmour = 50
    },  

    ["rebel"] = {
        gangnum = 0,
        permission = "rebel.guns",
        Coords = vector3(1544.7969970703,6331.2475585938,24.077945709229),
        Name = "Rebel",
        weapons = {
            {name = "AK-200", price = 750000, hash = "WEAPON_AK200"},
            {name = "Anarchy LR300", price = 850000, hash = "WEAPON_LR300"},
            {name = "MK1-EMR", price = 850000, hash = "WEAPON_MK1EMR"},
            {name = "MXM", price = 850000, hash = "WEAPON_MXM"},
            {name = "MX", price = 850000, hash = "WEAPON_MX"},
            {name = "Spar-16", price = 900000, hash = "WEAPON_SPAR16"},
            {name = "Mosin Nagant", price = 900000, hash = "WEAPON_MOSIN"},
            {name = "SVD", price = 2500000, hash = "WEAPON_SVD"},
        },
        maxarmour = 100
    },
    ["rebel2"] = {
        gangnum = 0,
        permission = "rebel.guns",
        Coords = vector3(866.5978, -966.6725, 27.84766),
        Name = "City Rebel",
        weapons = {
            {name = "AK-200", price = 750000, hash = "WEAPON_AK200", model = "w_ar_ak200"},
            {name = "Anarchy LR300", price = 850000, hash = "WEAPON_LR300", model = "w_ar_anarchy"},
            {name = "MK1-EMR", price = 850000, hash = "WEAPON_MK1EMR", model = "w_ar_mk1emr"},
            {name = "MXM", price = 850000, hash = "WEAPON_MXM", model = "w_ar_mxm"},
            {name = "MX", price = 850000, hash = "WEAPON_MX", model = "w_ar_mx"},
            {name = "Spar-16", price = 900000, hash = "WEAPON_SPAR16", model = "w_ar_spar16"},
            {name = "SVD", price = 2500000, hash = "WEAPON_SVD", model = "w_sr_svd"},
            {name = "Parachute", price = 10000, hash = "GADGET_PARACHUTE", model = "p_parachute_s"},
        },
        maxarmour = 100
    },
    
    ["vip"] = {
        gangnum = 0,
        permission = "vip.guns",
        Coords = vector3(-2151.63, 5191.14, 15.72),
        Name = "VIP Store",
        weapons = {
            {name = "AK-74 Kashnar", price = 750000, hash = "WEAPON_KASHNAR", model = "w_ar_ak74kashnar"},
            {name = "Parachute", price = 10000, hash = "GADGET_PARACHUTE", model = "p_parachute_s"},
        },
        maxarmour = 100
    },  
}