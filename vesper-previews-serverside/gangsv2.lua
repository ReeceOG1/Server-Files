// So sausage fingers and the muzzy want to use my shit, enjoy it for free :)
// Gonna continue to happen with each dev-preview they put out

// Gang logs with webhook

function addGangLog(name, id, date, action, actionValue)
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(id) == I then
                    local ganglogs = {}
                    if V.logs == 'NOTHING' then
                        ganglogs = {}
                    else
                        ganglogs = json.decode(V.logs)
                    end
                    local gangname = V.gangname
                    table.insert(ganglogs, 1, {name, id, date, action, actionValue})
                    ganglogs = json.encode(ganglogs)
                    exports['ghmattimysql']:execute("UPDATE arma_gangs SET logs = @logs WHERE gangname=@gangname", {logs = ganglogs, gangname = gangname}, function()
                        TriggerClientEvent('ARMA:ForceRefreshData', -1)
                    end)
                    PerformHttpRequest(V.webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = V.gangname..' Gang Logs', avatar_url = 'https://cdn.discordapp.com/avatars/988120850546962502/50ca540f28908bf89c1f8af3bea62025.webp?size=2048', embeds = {
                        {
                            ["color"] = 16448403,
                            ["title"] = action,
                            ["description"] = "Player ID: "..id.."\nPlayer Name: "..name.."\n"..action.." "..actionValue,
                            ["footer"] = {
                                ["text"] = os.date("%X"),
                                ["icon_url"] = "",
                            }
                    }
                    }}), { ["Content-Type"] = "application/json" })
                    break
                end
            end
        end
    end)
end

// Apply gang fit

RegisterServerEvent("ARMA:applyGangFit")
AddEventHandler("ARMA:applyGangFit", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    exports['arma']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if V.gangfit ~= nil then
                        ARMAclient.setCustomization(source, {json.decode(V.gangfit)})
                    else
                        ARMAclient.notify(source,{"~r~Gang does not have an outfit set."})
                    end
                    break
                end
            end
        end
    end)
end)

// Set gang fit

RegisterServerEvent("ARMA:setGangFit")
AddEventHandler("ARMA:setGangFit", function(gangid)
    local source=source
    local user_id=ARMA.getUserId(source)
    exports['arma']:execute('SELECT * FROM arma_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank == 4 then
                        ARMAclient.getCustomization(source,{},function(gangfit)
                            gangfit = json.encode(gangfit)
                            exports['arma']:execute("UPDATE arma_gangs SET gangfit = @gangfit WHERE gangname = @gangname", {gangname = gangid, gangfit = gangfit}, function() end)
                            ARMAclient.notify(source,{"~g~Gang outfit set."})
                        end)
                    else
                        ARMAclient.notify(source,{"~r~You do not have permission."})
                    end
                end
            end
        end
    end)
end)