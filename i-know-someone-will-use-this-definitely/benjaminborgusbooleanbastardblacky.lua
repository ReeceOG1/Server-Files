ARMA.createConsoleCommand('convertlsc', function(source, args)
    exports['ghmattimysql']:execute("SELECT * FROM arma_user_vehicles", {}, function(result)
        if #result > 0 then
            print("^5Converting LSC Vehicles")
            local startTime = os.time()
            print("^1Current Time - "..os.date("%H:%M:%S"))
            local coloursTable = {
                ["chrome"] = {
                    {name = "Chrome", index = 120}
                },
                ["classic"] = {
                    {name = "Black", index = 0},
                    {name = "Carbon Black", index = 147},
                    {name = "Graphite", index = 1},
                    {name = "Anthracite Black", index = 11},
                    {name = "Black Steel", index = 2},
                    {name = "Dark Steel", index = 3},
                    {name = "Silver", index = 4},
                    {name = "Bluish Silver", index = 5},
                    {name = "Rolled Steel", index = 6},
                    {name = "Shadow Silver", index = 7},
                    {name = "Stone Silver", index = 8},
                    {name = "Midnight Silver", index = 9},
                    {name = "Cast Iron Silver", index = 10},
                    {name = "Red", index = 27},
                    {name = "Torino Red", index = 28},
                    {name = "Formula Red", index = 29},
                    {name = "Lava Red", index = 150},
                    {name = "Blaze Red", index = 30},
                    {name = "Grace Red", index = 31},
                    {name = "Garnet Red", index = 32},
                    {name = "Sunset Red", index = 33},
                    {name = "Cabernet Red", index = 34},
                    {name = "Wine Red", index = 143},
                    {name = "Candy Red", index = 35},
                    {name = "Hot Pink", index = 135},
                    {name = "Pfsiter Pink", index = 137},
                    {name = "Salmon Pink", index = 136},
                    {name = "Sunrise Orange", index = 36},
                    {name = "Orange", index = 38},
                    {name = "Bright Orange", index = 138},
                    {name = "Gold", index = 99},
                    {name = "Bronze", index = 90},
                    {name = "Yellow", index = 88},
                    {name = "Race Yellow", index = 89},
                    {name = "Dew Yellow", index = 91},
                    {name = "Dark Green", index = 49},
                    {name = "Racing Green", index = 50},
                    {name = "Sea Green", index = 51},
                    {name = "Olive Green", index = 52},
                    {name = "Bright Green", index = 53},
                    {name = "Gasoline Green", index = 54},
                    {name = "Lime Green", index = 92},
                    {name = "Midnight Blue", index = 141},
                    {name = "Galaxy Blue", index = 61},
                    {name = "Dark Blue", index = 62},
                    {name = "Saxon Blue", index = 63},
                    {name = "Blue", index = 64},
                    {name = "Mariner Blue", index = 65},
                    {name = "Harbor Blue", index = 66},
                    {name = "Diamond Blue", index = 67},
                    {name = "Surf Blue", index = 68},
                    {name = "Nautical Blue", index = 69},
                    {name = "Racing Blue", index = 73},
                    {name = "Ultra Blue", index = 70},
                    {name = "Light Blue", index = 74},
                    {name = "Chocolate Brown", index = 96},
                    {name = "Bison Brown", index = 101},
                    {name = "Creeen Brown", index = 95},
                    {name = "Feltzer Brown", index = 94},
                    {name = "Maple Brown", index = 97},
                    {name = "Beechwood Brown", index = 103},
                    {name = "Sienna Brown", index = 104},
                    {name = "Saddle Brown", index = 98},
                    {name = "Moss Brown", index = 100},
                    {name = "Woodbeech Brown", index = 102},
                    {name = "Straw Brown", index = 99},
                    {name = "Sandy Brown", index = 105},
                    {name = "Bleached Brown", index = 106},
                    {name = "Schafter Purple", index = 71},
                    {name = "Spinnaker Purple", index = 72},
                    {name = "Midnight Purple", index = 142},
                    {name = "Bright Purple", index = 145},
                    {name = "Cream", index = 107},
                    {name = "Ice White", index = 111},
                    {name = "Frost White", index = 112}
                },
                ["matte"] = {
                    {name = "Black", index = 12},
                    {name = "Gray", index = 13},
                    {name = "Light Gray", index = 14},
                    {name = "Ice White", index = 131},
                    {name = "Blue", index = 83},
                    {name = "Dark Blue", index = 82},
                    {name = "Midnight Blue", index = 84},
                    {name = "Midnight Purple", index = 149},
                    {name = "Schafter Purple", index = 148},
                    {name = "Red", index = 39},
                    {name = "Dark Red", index = 40},
                    {name = "Orange", index = 41},
                    {name = "Yellow", index = 42},
                    {name = "Lime Green", index = 55},
                    {name = "Green", index = 128},
                    {name = "Frost Green", index = 151},
                    {name = "Foliage Green", index = 155},
                    {name = "Olive Darb", index = 152},
                    {name = "Dark Earth", index = 153},
                    {name = "Desert Tan", index = 154}
                },
                ["metals"] = {
                    {name = "Black", index = 12},
                    {name = "Gray", index = 13},
                    {name = "Light Gray", index = 14},
                    {name = "Ice White", index = 131},
                    {name = "Blue", index = 83},
                    {name = "Dark Blue", index = 82},
                    {name = "Midnight Blue", index = 84},
                    {name = "Midnight Purple", index = 149},
                    {name = "Schafter Purple", index = 148},
                    {name = "Red", index = 39},
                    {name = "Dark Red", index = 40},
                    {name = "Orange", index = 41},
                    {name = "Yellow", index = 42},
                    {name = "Lime Green", index = 55},
                    {name = "Green", index = 128},
                    {name = "Frost Green", index = 151},
                    {name = "Foliage Green", index = 155},
                    {name = "Olive Darb", index = 152},
                    {name = "Dark Earth", index = 153},
                    {name = "Desert Tan", index = 154}
                },
                ["util"] = {
                    {name = "Black", index = 15},
                    {name = "Black Poly", index = 16},
                    {name = "Dark Steel", index = 17},
                    {name = "Silver", index = 18},
                    {name = "Black Steel", index = 19},
                    {name = "Shadow Silver", index = 20},
                    {name = "Dark Red", index = 43},
                    {name = "Red", index = 44},
                    {name = "Garnet Red", index = 45},
                    {name = "Dark Green", index = 56},
                    {name = "Green", index = 57},
                    {name = "Dark Blue", index = 75},
                    {name = "Midnight Blue", index = 76},
                    {name = "Saxon Blue", index = 77},
                    {name = "Nautical Blue", index = 78},
                    {name = "Blue", index = 79},
                    {name = "Blue Poly", index = 80},
                    {name = "Bright Purple", index = 81},
                    {name = "Straw Brown", index = 93},
                    {name = "Feltzer Brown", index = 108},
                    {name = "Moss Brown", index = 109},
                    {name = "Sandy Brown", index = 110},
                    {name = "Off White", index = 122},
                    {name = "Bright Green", index = 125},
                    {name = "Harbor Blue", index = 127},
                    {name = "Frost White", index = 134},
                    {name = "Lime Green", index = 139},
                    {name = "Ultra Blue", index = 140},
                    {name = "Gray", index = 144},
                    {name = "Light Blue", index = 157},
                    {name = "Yellow", index = 160},
                },
                ["chameleon"] = {
                    {name = "Monochrome", index = 161},
                    {name = "Night & Day", index = 162},
                    {name = "The Verlierer", index = 163},
                    {name = "Sprunk Extreme", index = 164},
                    {name = "Vice City", index = 165},
                    {name = "Synthwave Nights", index = 166},
                    {name = "Four Seasons", index = 167},
                    {name = "Maisonette 9 Throwback", index = 168},
                    {name = "Bubblegum", index = 169},
                    {name = "Full Rainbow", index = 170},
                    {name = "Sunset", index = 171},
                    {name = "The Seven", index = 172},
                    {name = "Kamen Rider", index = 173},
                    {name = "Chromatic Aberration", index = 174},
                    {name = "It's Christmas!", index = 175},
                    {name = "Temperature", index = 176},
                },
            }
            for a,b in pairs(result) do
                local modsTable = json.decode(b.modifications)
                if modsTable ~= nil then
                    local modsColour = modsTable.color
                    local modsExtraColour = modsTable.extraColor
                    local modsWindowTint = modsTable.windowTint
                    local modsPlateIndex = modsTable.plateIndex
                    -- Converts all LS Customs mods to new format
                    for k,v in pairs(modsTable.mods) do
                        if v.mod ~= -1 then
                            MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = "mod_"..k, mod = v.mod})
                        end
                    end
                    print("^5Converted mods of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    -- Converts the security mods to new format
                    if modsTable.biometric == 1 then
                        MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = "security", mod = "21"})
                        print("^5Converted biometric of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    end
                    if modsTable.remoteblips == 1 then
                        MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = "security_blips", mod = "11"})
                        print("^5Converted remote blips of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    end
                    if modsTable.dashcam == 1 then
                        MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = "security_dashcam", mod = "1"})
                        print("^5Converted dashcam of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    end
                    -- Converts bulletproof tyres to new format
                    if modsTable.bulletProofTyres == 1 then
                        MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = "bulletproof_tires", mod = "1"})
                        print("^5Converted bulletproof tyres of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    end
                    -- Converts primary colours to new format
                    if modsColour ~= nil then
                        for k,v in pairs(coloursTable) do
                            for k2, v2 in pairs(v) do
                                if v2.index == modsColour[1] then
                                    MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = k, mod = modsColour[1]})
                                end
                                if v2.index == modsColour[2] then
                                    MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = k.."2", mod = modsColour[2]})
                                end
                            end
                        end
                        print("^5Converted primary and secondary colours of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    end
                    -- Converts secondary colours to new format
                    if modsExtraColour ~= nil then
                        for k,v in pairs(coloursTable.classic) do
                            if v.index == modsExtraColour[2] then
                                MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = "wheelcolor", mod = modsExtraColour[2]})
                            end
                        end
                        print("^5Converted wheel colour of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    end
                    -- Converts window tint to new format
                    if modsWindowTint ~= nil then
                        MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = "windowtint", mod = modsWindowTint})
                        print("^5Converted window tint of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    end
                    -- Converts plate index to new format
                    if modsPlateIndex ~= nil then
                        MySQL.asyncQuery("ARMA/InsertNewVehicleMod",{user_id = b.user_id, spawncode = b.vehicle, savekey = "plate_colour", mod = modsPlateIndex})
                        print("^5Converted plate index of vehicle: "..b.vehicle.." for ID: "..b.user_id.."^0")
                    end
                    print("^5Current Conversion Status: Position: "..a.." (^2"..math.floor(a/#result*100).." %^5)^0")
                end
            end
            print("^3-------------------------------------^0")
            print("^3Finished Converting LSC Vehicles^0")
            print("^1Finished Time - "..os.date("%H:%M:%S").."^0")
            print("^1Conversion took - "..os.time()-startTime.." seconds^0")
            print("^3-------------------------------------^0")
        end
    end)
end)
