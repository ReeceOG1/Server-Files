local connectedPlayers = {}

function GetPlayerSteamIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            return v
        end
    end
    return nil
end

function IsPlayerConnected(identifier, callback)
    local query = "SELECT COUNT(*) AS count FROM player_connections WHERE identifier = @identifier"
    exports.ghmattimysql:execute(query, {["@identifier"] = identifier}, function(result)
        local count = tonumber(result[1].count)
        callback(count > 0)
    end)
end

function MarkPlayerConnected(identifier)
    local query = "INSERT INTO player_connections (identifier) VALUES (@identifier)"
    exports.ghmattimysql:execute(query, {["@identifier"] = identifier})
end

AddEventHandler('playerJoining', function()
    local source = source
    local identifier = GetPlayerSteamIdentifier(source)

    if identifier then
        IsPlayerConnected(identifier, function(isConnected)
            if not isConnected then
                MarkPlayerConnected(identifier) -- Mark the player as connected

                local users = LUNA.getUsers({})
                for _, _user_id in ipairs(users) do
                    LUNA.giveBankMoney({_user_id, 30000})
                end

                -- Notify all players
                TriggerClientEvent('luna_notify', -1, "~g~You have received £30,000 as someone new has joined the server.")
            end
        end)
    end
end)
