local Tunnel = module("lib/Tunnel")
local Proxy = module("lib/Proxy")

Tunnel.bindInterface("LUNA", {})

local function GetPlayerData(playerID)
    -- Retrieve the necessary player data based on the playerID
    -- You can use a database query or any other method to retrieve the player's data
    -- Example implementation using a basic table for demonstration purposes:
    local playerData = {
        [1] = { name = "Player1", blipColor = 1 },
        [2] = { name = "Player2", blipColor = 2 },
        [3] = { name = "Player3", blipColor = 3 }
    }

    return playerData[playerID]
end

RegisterServerEvent("LUNA:EnableGangBlips")
AddEventHandler("LUNA:EnableGangBlips", function()
    local source = source
    local user_id = LUNA.getUserId(source)

    local playerGang, gangPermission = GetPlayerGangAndPermission(user_id)

    if playerGang then
        local gangMembers = GetGangMembers(playerGang, gangPermission)

        local filteredMembers = {}
        for _, memberID in ipairs(gangMembers) do
            if memberID ~= user_id and LUNA.isPlayerOnline(memberID) then
                table.insert(filteredMembers, memberID)
            end
        end

        local blipsData = GetBlipsData(filteredMembers)
        TriggerClientEvent("LUNA:ReceiveGangBlipsData", source, blipsData)
    end
end)

-- Function to retrieve the player's gang and permission
function GetPlayerGangAndPermission(user_id)
    local gangMembers = {}
    local gangPermission = 0

    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
        for _, gangData in pairs(gotGangs) do
            local gangMembersData = json.decode(gangData.gangmembers)
            local userGangData = gangMembersData[tostring(user_id)]

            if userGangData then
                gangMembers = gangMembersData
                gangPermission = userGangData.gangPermission
                break
            end
        end

        print("Got player gang and permission:", gangMembers, gangPermission) -- Add this line
    end)

    return gangMembers, gangPermission
end

-- Function to retrieve the members of a gang based on the player's gang and permission
function GetGangMembers(playerGang, gangPermission)
    local gangMembers = {}

    for memberID, memberData in pairs(playerGang) do
        if memberData.gangPermission <= gangPermission then
            table.insert(gangMembers, tonumber(memberID))
        end
    end

    return gangMembers
end

-- Function to retrieve the blips data for the given gang members
function GetBlipsData(memberIDs)
    local blipsData = {}

    for _, memberID in ipairs(memberIDs) do
        -- Retrieve the necessary data for each member and create a blip data entry
        -- Customize this part based on your player data structure
        local playerData = GetPlayerData(memberID)
        if playerData then
            local blipData = {
                playerID = memberID,
                playerName = playerData.name,
                blipColor = playerData.blipColor
            }
            table.insert(blipsData, blipData)
        end
    end

    return blipsData
end
