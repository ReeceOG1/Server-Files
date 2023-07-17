ConfigMain = {}

ConfigMain.Weapons = {
    Pistols = {
        {Name = "Glock 17", SpawnCode = "WEAPON_GLOCK17DM"}, -- Done
        {Name = "M1911", SpawnCode = "WEAPON_M1911DM"}, -- Done
    },
    Shotguns = {
        {Name = "Winchester 12", SpawnCode = "WEAPON_WINCHESTER12DM"}, -- Done
    },
    SMGs = {
        {Name = "UMP-45", SpawnCode = "WEAPON_UMP45DM"}, -- Done
        {Name = "UZI", SpawnCode = "WEAPON_UZIDM"}, -- Done
        {Name = "MP5", SpawnCode = "WEAPON_MP5DM"}, -- Done
    },
    AssaultRifles = {
        {Name = "AK-200", SpawnCode = "WEAPON_AK200DM"}, -- Done
        {Name = "AK-74 Gold", SpawnCode = "WEAPON_AK74GOLDDM"}, -- Done
        {Name = "AK-74", SpawnCode = "WEAPON_AK74DM"}, -- Done
        {Name = "Anarchy LR-300", SpawnCode = "WEAPON_ANARCHYLR300DM"}, -- Done 
        {Name = "HK-416", SpawnCode = "WEAPON_HK416DM"}, -- Done 
        {Name = "M16A4", SpawnCode = "WEAPON_M16A4DM"}, -- Done 
        {Name = "M16-SP1", SpawnCode = "WEAPON_SP1DM"}, -- Done 
        {Name = "SIG-516", SpawnCode = "WEAPON_SIG516DM"}, -- Done 
        {Name = "Spar-16", SpawnCode = "WEAPON_SPAR16DM"}, -- Done
    },
    SniperRifles = {
        {Name = "Mosin Nagant", SpawnCode = "WEAPON_MOSINNAGANTDM"}, -- Done
    },
    American = {
        {Name = "AP-Pistol", SpawnCode = "WEAPON_APPISTOL"},
        {Name = "Combat Pistol", SpawnCode = "WEAPON_COMBATPISTOL"},
    },
    GLife = {
        Normal = {
            {Name = "Assault Rifle", SpawnCode = "WEAPON_ASSAULTRIFLE"},
            {Name = "M60", SpawnCode = "WEAPON_COMBATMG"},
            {Name = "Special Carbine", SpawnCode = "WEAPON_SPECIALCARBINE"},
            {Name = "AWP", SpawnCode = "WEAPON_HEAVYSNIPER"},
        },
        MK2 = {
            {Name = "Assault Rifle MK2", SpawnCode = "WEAPON_ASSAULTRIFLE_MK2"},
            {Name = "M60 MK2", SpawnCode = "WEAPON_COMBATMG_MK2"},
            {Name = "Special Carbine MK2", SpawnCode = "WEAPON_SPECIALCARBINE_MK2"},
            {Name = "AWP MK2", SpawnCode = "WEAPON_HEAVYSNIPER_MK2"},
        }
    }
}


ConfigMain.PremiumMenu = {
    Pistols = {
        {Name = "Whitetint Deagle", SpawnCode = "WEAPON_WHITETINTDEAGLEDM"}, 
    },
    Shotguns = {
        {Name = "Spas-12", SpawnCode = "WEAPON_SPAS12DM"},
    },
    SMGs = {
        {Name = "MP5A2", SpawnCode = "WEAPON_MP5A2DM"},
        {Name = "MP7A2", SpawnCode = "WEAPON_MP7A2DM"},
    },
    AssaultRifles = {
        {Name = "AS-Val", SpawnCode = "WEAPON_VALDM"},
        {Name = "RE6", SpawnCode = "WEAPON_RE6DM"},
        {Name = "M-13", SpawnCode = "WEAPON_M13DM"},
    },
    SniperRifles = {
        {Name = "SVD Dragunov", SpawnCode = "WEAPON_SVDDM"},
    }
}


ConfigMain.Teleport = {
    GLife = {
        {  
            Name = "Simeons", 
            SpawnLocations = {
                {1381.047, 4286.697, 36.4719},
            },
            Center = {1347.54, 4355.914, 43.68353}
        },
        {  
            Name = "Ranch", 
            SpawnLocations = {
                {1466.991, 1134.106, 114.3226},
                {1463.725, 1096.699, 114.394},
                {1411.389, 1125.19, 114.3437},
                {1389.265, 1141.479, 114.3345},
                {1335.312, 1188.016, 109.009},
                {1374.368, 1174.749, 113.9855},
                {1417.231, 1174.165, 114.3448},
                {1407.8, 1188.31, 113.8221},
                {1495.512, 1185.928, 114.2313},
                {1490.859, 1128.654, 114.3637},
            },
            Center = {1448.555, 1120.101, 114.3339}
        },
    },
    TeamLocs = {
        {
            Name = "Backgarages Attack", 
            SpawnLocations = {
                {3616.772, 3738.17, 28.69009},
            },
            Location = "Backgarages",
            Team = "TeamA",
        },
        {
            Name = "Backgarages Defend", 
            SpawnLocations = {
                {3555.767, 3674.042, 28.12189},
            },
            Location = "Backgarages",
            Team = "TeamB",
        },
    },
    Casual = {
        {
            Name = "North LSD", 
            SpawnLocations = {
                {1381.047, 4286.697, 36.4719},
                {1367.061, 4384.743, 44.33835},
                {1389.246, 4359.652, 42.8476},
                {1274.423, 4377.098, 47.44622},
                {1297.435, 4303.796, 37.00053},
                {1353.218, 4355.316, 43.75933},
                {1341.454, 4387.35, 44.3438},
                {1306.116, 4375.59, 47.67176},
                {1265.752, 4312.614, 32.34309}, 
            }, -- Done
            Center = vector3(1347.54, 4355.914, 43.68353)
        },
                {
            Name = "North LSD ATM", 
            SpawnLocations = {
                {1641.119, 4835.311, 42.024},
                {1688.994, 4814.661, 42.01952},
                {1670.128, 4851.897, 42.05991},
                {1650.879, 4825.103, 42.00468},
                {1685.229, 4817.667, 42.00583},
                {1640.549, 4859.94, 42.02279},
                {1664.227, 4810.474, 41.88618},
                {1655.125, 4867.526, 42.0113},
                {1667.132, 4862.736, 42.06443},
                {1675.238, 4794.877, 42.01458},
                {1682.314, 4849.88, 42.11223},
                {1693.229, 4815.055, 41.98039},
            }, -- Done
            Center = vector3(2580.527, 372.1322, 108.4568),
        },
        {
            Name = "South LSD ATM", 
            SpawnLocations = {
                {2548.977, 410.1335, 108.4594},
                {2587.626, 489.0423, 108.55},
                {2571.076, 278.7909, 108.5261},
                {2542.039, 353.114, 108.6027},
                {2539.373, 368.4556, 111.4283},
                {2614.201, 433.7776, 107.7906},
            }, -- Done
            Center = vector3(2580.527, 372.1322, 108.4568),
        },
        {
            Name = "South LSD", 
            SpawnLocations = {
                {2507.621, -336.5306, 115.6136},
                {2506.568, -430.5609, 116.0817},
                {2461.982, -321.7641, 93.09082},
                {2461.988, -399.6668, 109.5219},
                {2503.022, -431.9731, 92.99286},
                {2468.118, -342.8608, 109.5218},
                {2523.257, -414.7634, 94.27289},
                {2480.302, -413.2571, 93.74272},
                {2542.973, -306.7309, 92.98597},
                {2564.28, -395.6529, 92.9927},
                {2528.437, -310.2337, 92.99382},
                {2468.991, -312.6126, 93.24207},
                {2480.87, -350.7002, 93.73435},
                {2472.921, -370.855, 109.5218},
            }, -- Done
            Center = vector3(2500.997, -385.3876, 99.48222),
        },
        {
            Name = "Rebel",
            SpawnLocations = {
                {1492.416, 6347.187, 23.97357},
                {1501.471, 6357.418, 16.71407},
                {1477.095, 6377.194, 23.29396},
                {1396.463, 6412.585, 32.91936},
                {1518.435, 6315.917, 24.08256},
                {1551.813, 6329.507, 24.08255},
                {1536.56, 6384.084, 37.37035},
                {1409.821, 6332.329, 24.68792},
                {1525.043, 6240.146, 123.5666},
                {1458.155, 6369.979, 23.71573},
            }, -- Done
            Center = vector3(1492.416, 6347.187, 23.97357)
        },
        {
            Name = "Large Arms",
            SpawnLocations = {
                {-1043.731, 4913.833, 208.2956},
                {-1173.073, 4902.62, 216.9878},
                {-1129.663, 4905.459, 218.9221},
                {-1004.387, 4854.285, 274.6057},
                {-1061.87, 4846.341, 237.3336},
                {-1048.769, 4821.709, 245.6945},
                {-1071.607, 4946.53, 212.8349 },
                {-1115.95, 4952.967, 218.8628},
                {-1078.745, 4940.452, 229.2218},
            }, -- Done
            Center = vector3(-1112.229, 4922.334, 217.728),
        },
        {
            Name = "Oil Rig",
            SpawnLocations = {
                {-1724.853, 8889.377, 13.76496},
                {-1704.827, 8870.96, 27.36192},
                {-1685.034, 8877.664, 27.34559},
                {-1706.022, 8862.598, 19.74932},
                {-1688.025, 8890.083, 19.87496},
                {-1727.846, 8893.126, 19.90699},
                {-1730.095, 8873.619, 21.71975},
                {-1684.004, 8886.047, 13.751061},
                {-1698.292, 8875.55, 19.86008},
            },
            Center = vector3(-1705.948, 8886.882, 28.72353),
        },
    },
    American = {
        {
            Name = "Hub / Spawn", 
            SpawnLocations = {
                {-958.6526, 905.6978, 572.3246},
                {-958.4753, 927.0952, 572.317},
            }, 
            Center = vector3(-958.4753, 927.0952, 572.317),
        },
        {
            Name = "Deathmatch Arena", 
            SpawnLocations = {
                {1407.463, 3079.604, 129.6792},
            }, 
            Center = vector3(1407.463, 3079.604, 129.6792),
        },
        {
            Name = "Skatepark", 
            SpawnLocations = {
                {-958.7108, -780.2469, 17.8361},
            }, 
            Center = vector3(-941.2835, -791.6302, 15.95098),
        },
        {
            Name = "Weed", 
            SpawnLocations = {
                {-242.4271, -1574.455, 33.97188},
            }, 
            Center = vector3(-265.7364, -1571.21, 32.06606),
        },
        {
            Name = "Sky Ramp #1", 
            SpawnLocations = {
                {-902.9819, 925.0632, 585.4277},
                {-903.1693, 907.9558, 585.4277},
            }, 
            Center = vector3(-903.1101, 916.2585, 580.8579),
        },
        {
            Name = "Sky Ramp #2", 
            SpawnLocations = {
                {-918.3009, 858.509, 577.0502},
                {-900.7025, 858.3721, 577.0503},
            }, 
            Center = vector3(-909.7354, 858.3803, 572.4808),
        },
        {
            Name = "Sky Ramp #3", 
            SpawnLocations = {
                {-950.3016, 858.1405, 577.0503},
                {-967.5001, 858.3977, 577.0503},
            }, 
            Center = vector3(-958.7009, 858.2661, 572.731),
        },
        {
            Name = "Sky Ramp #4", 
            SpawnLocations = {
                {-1015.811, 858.4677, 576.7303},
                {-998.6097, 858.4073, 576.7303},
            }, 
            Center = vector3(-1007.81, 858.4396, 572.731),
        },
        {
            Name = "Sky Ramp #5", 
            SpawnLocations = {
                {-1014.076, 924.877, 585.5152},
                {-1014.444, 907.7645, 585.5152},
            }, 
            Center = vector3(-1014.295, 916.1128, 580.876),
        },
        {
            Name = "Sky Ramp #6", 
            SpawnLocations = {
                {-1016.055, 974.4022, 577.0516},
                {-998.8092, 974.6409, 577.0516},
            }, 
            Center = vector3(-1007.057, 974.5267, 572.3118),
        },
        {
            Name = "Sky Ramp #7", 
            SpawnLocations = {
                {-950.2017, 974.4247, 577.0504},
                {-967.7974, 973.9789, 577.0504},
            }, 
            Center = vector3(-958.7076, 974.7781, 572.4806),
        },
        {
            Name = "Sky Ramp #8", 
            SpawnLocations = {
                {-918.0756, 974.5417, 577.0504},
                {-900.8828, 974.5773, 577.0504},
            }, 
            Center = vector3(-909.3804, 974.4338, 572.4112),
        },
    },
}


ConfigMain.Settings = {
    DistanceFind = {
        {"20%", 0.2},
        {"30%", 0.3},
        {"40%", 0.4},
        {"50%", 0.5},
        {"60%", 0.6},
        {"70%", 0.7},
        {"80%", 0.8},
        {"90%", 0.9},
        {"100%", 1.0},
        {"150%", 1.5},
        {"200%", 2.0},
        {"500%", 5.0},
        {"1000%", 10.0},
    },
    Distances = {
        "20%", 
        "30%", 
        "40%", 
        "50%", 
        "60%", 
        "70%", 
        "80%", 
        "90%", 
        "100%",
        "150%",
        "200%",
        "500%",
        "1000%",
    },
    DistanceIndex = 9,

    WeatherFind = {
        {"Clear", "CLEAR"},
        {"Sunny", "EXTRASUNNY"},
        {"Cloudy", "CLOUDS"},
        {"Rain", "RAIN"},
        {"Smog", "SMOG"},
        {"Snow", "SNOWLIGHT"},
        {"Blizzard", "BLIZZARD"},
        {"Christmas", "XMAS"},
        {"Foggy", "FOGGY"},
    },

    Weather = {
        "Clear",
        "Sunny",
        "Cloudy",
        "Rain",
        "Smog",
        "Snow",
        "Blizzard",
        "Christmas",
        "Foggy",
    }, 
    WeatherIndex = 1,
}


return ConfigMain