local coinflipTables = {
    [1] = false,
    [2] = false,
    [5] = false,
    [6] = false,
}

local linkedTables = {
    [1] = 2,
    [2] = 1,
    [5] = 6,
    [6] = 5,
}

local coinflipGameInProgress = {}
local coinflipGameData = {}

local betId = 0

function giveChips(source,amount)
    local user_id = GMT.getUserId(source)
    MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
    TriggerClientEvent('GMT:chipsUpdated', source)
end

AddEventHandler('playerDropped', function (reason)
    local source = source
    for k,v in pairs(coinflipTables) do
        if v == source then
            coinflipTables[k] = false
            coinflipGameData[k] = nil
        end
    end
end)

RegisterNetEvent("GMT:requestCoinflipTableData")
AddEventHandler("GMT:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("GMT:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("GMT:requestSitAtCoinflipTable")
AddEventHandler("GMT:requestSitAtCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then
        for k,v in pairs(coinflipTables) do
            if v == source then
                coinflipTables[k] = false
                return
            end
        end
        coinflipTables[chairId] = source
        local currentBetForThatTable = coinflipGameData[chairId]
        TriggerClientEvent("GMT:sendCoinflipTableData",-1,coinflipTables)
        TriggerClientEvent("GMT:sitAtCoinflipTable",source,chairId,currentBetForThatTable)
    end
end)

RegisterNetEvent("GMT:leaveCoinflipTable")
AddEventHandler("GMT:leaveCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then 
        for k,v in pairs(coinflipTables) do 
            if v == source then 
                coinflipTables[k] = false
                coinflipGameData[k] = nil
            end
        end
        TriggerClientEvent("GMT:sendCoinflipTableData",-1,coinflipTables)
    end
end)

RegisterNetEvent("GMT:proposeCoinflip")
AddEventHandler("GMT:proposeCoinflip",function(betAmount)
    local source = source
    local user_id = GMT.getUserId(source)
    betId = betId+1
    if betAmount ~= nil then 
        if coinflipGameData[betId] == nil then
            coinflipGameData[betId] = {}
        end
        if not coinflipGameInProgress[betId] then
            if tonumber(betAmount) then
                betAmount = tonumber(betAmount)
                if betAmount >= 100000 then
                    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                        chips = rows[1].chips
                        if chips >= betAmount then
                            TriggerClientEvent('GMT:chipsUpdated', source)
                            if coinflipGameData[betId][source] == nil then
                                coinflipGameData[betId][source] = {}
                            end
                            coinflipGameData[betId] = {betId = betId, betAmount = betAmount, user_id = user_id}
                            for k,v in pairs(coinflipTables) do
                                if v == source then
                                    TriggerClientEvent('GMT:addCoinflipProposal', source, betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    if coinflipTables[linkedTables[k]] then
                                        TriggerClientEvent('GMT:addCoinflipProposal', coinflipTables[linkedTables[k]], betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    end
                                end
                            end
                            GMTclient.notify(source,{"~g~Bet placed: " .. getMoneyStringFormatted(betAmount) .. " chips."})
                        else 
                            GMTclient.notify(source,{"Not enough chips!"})
                        end
                    end)
                else
                    GMTclient.notify(source,{'Minimum bet at this table is £100,000.'})
                    return
                end
            end
        end
    else
       GMTclient.notify(source,{"Error betting!"})
    end
end)

RegisterNetEvent("GMT:requestCoinflipTableData")
AddEventHandler("GMT:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("GMT:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("GMT:cancelCoinflip")
AddEventHandler("GMT:cancelCoinflip", function()   
    local source = source
    local user_id = GMT.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.user_id == user_id then
            coinflipGameData[k] = nil
            TriggerClientEvent("GMT:cancelCoinflipBet",-1,k)
        end
    end
end)

RegisterNetEvent("GMT:acceptCoinflip")
AddEventHandler("GMT:acceptCoinflip", function(gameid)   
    local source = source
    local user_id = GMT.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.betId == gameid then
            MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                chips = rows[1].chips
                if chips >= v.betAmount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = v.betAmount})
                    TriggerClientEvent('GMT:chipsUpdated', source)
                    MySQL.execute("casinochips/remove_chips", {user_id = v.user_id, amount = v.betAmount})
                    TriggerClientEvent('GMT:chipsUpdated', GMT.getUserSource(v.user_id))
                    local coinFlipOutcome = math.random(0,1)
                    if coinFlipOutcome == 0 then
                        local game = {amount = v.betAmount, winner = GetPlayerName(source), loser = GetPlayerName(GMT.getUserSource(v.user_id))}
                        TriggerClientEvent('GMT:coinflipOutcome', source, true, game)
                        TriggerClientEvent('GMT:coinflipOutcome', GMT.getUserSource(v.user_id), false, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = v.betAmount*2})
                        TriggerClientEvent('GMT:chipsUpdated', source)
                        tGMT.sendWebhook('coinflip-bet',"GMT Coinflip Logs", "> Winner Name: **"..GetPlayerName(source).."**\n> Winner TempID: **"..source.."**\n> Winner PermID: **"..user_id.."**\n> Loser Name: **"..GetPlayerName(GMT.getUserSource(v.user_id)).."**\n> Loser TempID: **"..GMT.getUserSource(v.user_id).."**\n> Loser PermID: **"..v.user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    else
                        local game = {amount = v.betAmount, winner = GetPlayerName(GMT.getUserSource(v.user_id)), loser = GetPlayerName(source)}
                        TriggerClientEvent('GMT:coinflipOutcome', source, false, game)
                        TriggerClientEvent('GMT:coinflipOutcome', GMT.getUserSource(v.user_id), true, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = v.user_id, amount = v.betAmount*2})
                        TriggerClientEvent('GMT:chipsUpdated', GMT.getUserSource(v.user_id))
                        tGMT.sendWebhook('coinflip-bet',"GMT Coinflip Logs", "> Winner Name: **"..GetPlayerName(GMT.getUserSource(v.user_id)).."**\n> Winner TempID: **"..GMT.getUserSource(v.user_id).."**\n> Winner PermID: **"..v.user_id.."**\n> Loser Name: **"..GetPlayerName(source).."**\n> Loser TempID: **"..source.."**\n> Loser PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    end
                else 
                    GMTclient.notify(source,{"Not enough chips!"})
                end
            end)
        end
    end
end)

RegisterCommand('tables', function(source)
    print(json.encode(coinflipTables))
end)