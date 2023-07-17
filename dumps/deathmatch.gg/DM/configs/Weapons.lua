



globalWeaponList = {
    -- Casual
    ["WEAPON_AK200DM"] = {"AK-200", "assaultrifle", "Casual", 250},
    ["WEAPON_AK74GOLDDM"] = {"AK-74 Gold", "assaultrifle", "Casual", 250},
    ["WEAPON_AK74DM"] = {"AK-74", "assaultrifle", "Casual", 250},
    ["WEAPON_ANARCHYLR300DM"] = {"Anarchy LR300", "assaultrifle", "Casual", 250},
    ["WEAPON_SIG516DM"] = {"SIG-516", "assaultrifle", "Casual", 250},
    ["WEAPON_SPAR16DM"] = {"Spar-16", "assaultrifle", "Casual", 250},
    ["WEAPON_MOSINNAGANTDM"] = {"Mosin Nagant", "mosin", "Casual", 250},
    ["WEAPON_WINCHESTER12DM"] = {"Winchester-12", "shotgun", "Casual", 250},
    ["WEAPON_HK416DM"] = {"HK-416", "assaultrifle", "Casual", 250},
    ["WEAPON_M16A4DM"] = {"M16A4", "assaultrifle", "Casual", 250},
    ["WEAPON_UMP45DM"] = {"UMP-45", "smg", "Casual", 250},
    ["WEAPON_UZIDM"] = {"UZI", "smg", "Casual", 250},
    ["WEAPON_MP5DM"] = {"MP5", "smg", "Casual", 250},
    ["WEAPON_M1911DM"] = {"M1911", "pistol", "Casual", 250},
    ["WEAPON_GLOCK17DM"] = {"Glock-17", "pistol", "Casual", 250},
    ["WEAPON_SP1DM"] = {"M16-SP1", "assaultrifle", "Casual", 250},
    ["WEAPON_VALDM"] = {"As-Val", "assaultrifle", "Casual", 250},
    ["WEAPON_RE6DM"] = {"RE6", "assaultrifle", "Casual", 250},
    ["WEAPON_M13DM"] = {"M-13", "assaultrifle", "Casual", 250},
    ["WEAPON_SVDDM"] = {"Dragnov SVD", "sniper", "Casual", 250},
    ["WEAPON_MP5A2DM"] = {"MP5A2", "smg", "Casual", 250},
    ["WEAPON_MP7A2DM"] = {"MP7A2", "smg", "Casual", 250},
    ["WEAPON_SPAS12DM"] = {"Spas-12", "shotgun", "Casual", 250},
    ["WEAPON_WHITETINTDEAGLEDM"] = {"Whitetint Deagle", "pistol", "Casual", 250},

    -- Extinction
    ["WEAPON_ASSAULTRIFLE"] = {"Assault Rifle", "assaultrifle", "Glife", 250},
    ["WEAPON_COMBATMG"] = {"M60", "assaultrifle", "Glife", 250},
    ["WEAPON_SPECIALCARBINE"] = {"Special Carbine", "assaultrifle", "Glife", 250},
    ["WEAPON_BULLPUPRIFLE"] = {"Bullpup Rifle", "assaultrifle", "Glife", 250},
    ["WEAPON_HEAVYSNIPER"] = {"AWP", "sniper", "Glife", 250},
    ["WEAPON_ASSAULTRIFLE_MK2"] = {"Assault Rifle MK2", "assaultrifle", "Glife", 250},
    ["WEAPON_COMBATMG_MK2"] = {"M60 MK2", "assaultrifle", "Glife", 250},
    ["WEAPON_SPECIALCARBINE_MK2"] = {"Special Carbine MK2", "assaultrifle", "Glife", 250},
    ["WEAPON_HEAVYSNIPER_MK2"] = {"AWP MK2", "sniper", "Glife", 250},
    ["WEAPON_MARKSMANRIFLE_MK2"] = {"Marksman Rifle MK2", "sniper", "Glife", 250},
    ["WEAPON_MARKSMANRIFLE"] = {"Marksman Rifle", "sniper", "Glife", 250},
    ["WEAPON_SNIPERRIFLE"] = {"Sniper Rifle", "sniper", "Glife", 250},
    ["WEAPON_HEAVYREVOLVER"] = {"Heavy Revolver", "pistol", "Glife", 250},
    ["WEAPON_MUSKET"] = {"Musket", "mosin", "Glife", 250},
    ["WEAPON_KNIFE"] = {"Knife", "melee", "Glife", 1},

    -- American / Redzone
    ["WEAPON_APPISTOL"] = {"AP-Pistol", "pistol", "American", 9999},
    ["WEAPON_COMBATPISTOL"] = {"Combat Pistol", "pistol", "American", 9999},
    ["WEAPON_PISTOL"] = {"Pistol", "pistol", "American", 9999},
}

for k,v in pairs(globalWeaponList) do
    AddTextEntry(k, v[1])
end


