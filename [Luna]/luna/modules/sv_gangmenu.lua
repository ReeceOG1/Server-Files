RegisterServerEvent("LUNA:GetGangData")
AddEventHandler("LUNA:GetGangData", function()
    local source=source
    local newarray = nil
    local peoplesids = {}
    local user_id=LUNA.getUserId(source)
    local gangmembers ={}
    local gangpermission
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    newarray={}
                    newarray["money"] = V.funds
                    isingang = true
                    newarray["id"] = V.gangname
                    gangpermission = L.gangPermission
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['ghmattimysql']:execute('SELECT * FROM LUNA_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] ~= nil then
                                table.insert(gangmembers,{G.username,tonumber(G.id),peoplesids[tostring(G.id)]})
                            end
                        end
                        TriggerClientEvent('LUNA:GotGangData', source,newarray,gangmembers,gangpermission)
                    end)
                    break
                end
            end
        end
    end)
end)
RegisterServerEvent("LUNA:CreateGang")
AddEventHandler("LUNA:CreateGang", function(gangname)
    local source=source
    local user_id=LUNA.getUserId(source)
    local user_name = GetPlayerName(source)
    local funds = 0 
    local logs = "NOTHING"
    exports['ghmattimysql']:execute('SELECT gangname FROM LUNA_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGang)
        if not LUNA.hasGroup(user_id,"Gang") then
            LUNAclient.notify(source,{"~r~You do not have gang licence."})
            return
        end
        if json.encode(gotGang) ~= "[]" and gotGang ~= nil and json.encode(gotGang) ~= nil then
            LUNAclient.notify(source,{"~r~Gang name is already in use."})
            return
        end
        local gangmembers = {
            [tostring(user_id)] = {
                ["rank"] = 4,
                ["gangPermission"] = 4,
            },
        }
        gangmembers = json.encode(gangmembers)
        LUNAclient.notify(source,{"~g~"..gangname.." created."})
        exports['ghmattimysql']:execute("INSERT INTO LUNA_gangs (gangname,gangmembers,funds,logs) VALUES(@gangname,@gangmembers,@funds,@logs)", {gangname=gangname,gangmembers=gangmembers,funds=funds,logs=logs}, function() end)
        TriggerClientEvent('LUNA:gangNameNotTaken', source)
        TriggerClientEvent('LUNA:ForceRefreshData', -1)
    end)
end)
RegisterServerEvent("LUNA:addUserToGang")
AddEventHandler("LUNA:addUserToGang", function(ganginvite,playerid)
    local source=source
    local user_id=LUNA.getUserId(source)
    local playersource = LUNA.getUserSource(playerid)
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs WHERE gangname = @gangname', {gangname = ganginvite}, function(G)
        if json.encode(G) == "[]" and G == nil and json.encode(G) == nil then
            LUNAclient.notify(playersource,{"~r~Gang no longer exists."})
            return
        end
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            array[tostring(playerid)] = {["rank"] = 1,["gangPermission"] = 1}
            exports['ghmattimysql']:execute("UPDATE LUNA_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers = json.encode(array), gangname = ganginvite}, function()
                TriggerClientEvent('LUNA:ForceRefreshData', -1)
            end)
        end
    end)
end)
RegisterServerEvent("LUNA:depositGangBalance")
AddEventHandler("LUNA:depositGangBalance", function(amount)
    local source = source
    local user_id = LUNA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        LUNAclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    if tonumber(LUNA.getMoney(user_id)) < tonumber(amount) then
                        LUNAclient.notify(source,{"~r~Not enough cash."})
                    else
                        LUNA.setMoney(user_id,tonumber(LUNA.getMoney(user_id))-tonumber(amount))
                        LUNAclient.notify(source,{"~g~Deposited £"..amount})
                        local newamount = tonumber(amount)+tonumber(funds)
                        local tax = tonumber(amount)*0.01
                        local webhook = 'https://ptb.discord.com/api/webhooks/1110524972788633773/7sQGk7Po0Cj6L4hEOcwPK-Vbs4h7AtAISAKHqaL1FSBELBRFt7Blc3NgZKRxX4K-Dqe6'
                        local embed = {
                            {
                                ["color"] = "16777215",
                                ["title"] = "Gang Funds",
                                ["description"] = "**Player Name:** "..GetPlayerName(source).."\n**User ID:** "..LUNA.getUserId(source).."\n**Deposit:** £"..getMoneyStringFormatted(amount).."\n**Gang Name:** "..gangname,
                                ["footer"] = {
                                    ["text"] = "LUNA - "..os.date("%X"),
                                },
                            }
                        }
                        PerformHttpRequest(webhook, function (err, text, headers) end, 'POST', json.encode({username = 'LUNA', embeds = embed}), { ['Content-Type'] = 'application/json' })
                        exports['ghmattimysql']:execute("UPDATE LUNA_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                            TriggerClientEvent('LUNA:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
    TriggerClientEvent('LUNA:ForceRefreshData', source)
end)
function addGangLog(name, id, date, action, actionValue)
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
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
                    exports['ghmattimysql']:execute("UPDATE LUNA_gangs SET logs = @logs WHERE gangname=@gangname", {logs = ganglogs, gangname = gangname}, function()
                        TriggerClientEvent('LUNA:ForceRefreshData', -1)
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
RegisterServerEvent("LUNA:withdrawGangBalance")
AddEventHandler("LUNA:withdrawGangBalance", function(amount)
    local source = source
    local user_id = LUNA.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        LUNAclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    if tonumber(funds) < tonumber(amount) then
                        LUNAclient.notify(source,{"~r~Invalid Amount."})
                    else
                        LUNA.setMoney(user_id,tonumber(LUNA.getMoney(user_id))+tonumber(amount))
                        LUNAclient.notify(source,{"~g~Withdrew £"..amount})
                        local newamount = tonumber(funds)-tonumber(amount)
                        local webhook = 'https://ptb.discord.com/api/webhooks/1110524972788633773/7sQGk7Po0Cj6L4hEOcwPK-Vbs4h7AtAISAKHqaL1FSBELBRFt7Blc3NgZKRxX4K-Dqe6'
                        local embed = {
                            {
                                ["color"] = "16777215",
                                ["title"] = "Gang Funds",
                                ["description"] = "**User Name:** "..GetPlayerName(source).."\n**User ID:** "..LUNA.getUserId(source).."\n**Withdrew:** £"..getMoneyStringFormatted(amount).."\n**Gang Name:** "..gangname,
                                ["footer"] = {
                                    ["text"] = "LUNA - "..os.date("%X"),
                                },
                            }
                        }
                        PerformHttpRequest(webhook, function (err, text, headers) end, 'POST', json.encode({username = 'LUNA', embeds = embed}), { ['Content-Type'] = 'application/json' })
                        exports['ghmattimysql']:execute("UPDATE LUNA_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                            TriggerClientEvent('LUNA:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
    TriggerClientEvent('LUNA:ForceRefreshData', source)
end)
RegisterServerEvent("LUNA:PromoteUser")
AddEventHandler("LUNA:PromoteUser", function(gangid,memberid)
    local source = source
    local user_id=LUNA.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(memberid)].rank
                        local gangpermission = array[tostring(memberid)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= I then
                            LUNAclient.notify(source,{"~r~Only can Leader can promote."})
                            return
                        end
                        if array[tostring(memberid)].rank == 3 and gangpermission == 3 and tostring(user_id) == I then
                            LUNAclient.notify(source,{"~r~There can only be 1 leader in each gang."})
                            return
                        end
                        if tonumber(memberid) == tonumber(user_id) and rank == 4 and gangpermission == 4 then
                            LUNAclient.notify(source,{"~r~You are the highest rank."})
                            return
                        end 
                        array[tostring(memberid)].gangPermission = tonumber(gangpermission)+1
                        array[tostring(memberid)].rank = tonumber(rank)+1
                        array = json.encode(array)
                        exports['ghmattimysql']:execute("UPDATE LUNA_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('LUNA:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("LUNA:DemoteUser")
AddEventHandler("LUNA:DemoteUser", function(gangid,memberid)
    local source = source
    local user_id=LUNA.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(memberid)].rank
                        local gangpermission = array[tostring(memberid)].gangPermission
                        if rank == 4 or gangpermission == 4 then
                            LUNAclient.notify(source,{"~r~Cannot demote the leader"})
                            return
                        end
                        if rank == 1 and gangpermission == 1 then
                            LUNAclient.notify(source,{"~r~Member is already the lowest rank."})
                            return
                        end
                        array[tostring(memberid)].rank = tonumber(rank)-1
                        array[tostring(memberid)].gangPermission = tonumber(gangpermission)-1
                        array = json.encode(array)
                        exports['ghmattimysql']:execute("UPDATE LUNA_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('LUNA:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("LUNA:kickMemberFromGang")
AddEventHandler("LUNA:kickMemberFromGang", function(gangid,member)
    local source = source
    local user_id = LUNA.getUserId(source)
    local membersource = LUNA.getUserSource(member)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(member)].rank
                    local rank = array[tostring(user_id)].rank
                    if tonumber(member) == tonumber(user_id) then
                        LUNAclient.notify(source,{"~r~You cannot kick yourself!"})
                        return
                    end
                    if tonumber(memberrank) >= 3 then
                        LUNAclient.notify(source,{"~r~You do not have permission to kick another Lieutenant!"})
                        return
                    end
                    array[tostring(member)] = nil
                    array = json.encode(array)
                    LUNAclient.notify(source,{"~r~Successfully kicked member from gang"})
                    exports['ghmattimysql']:execute("UPDATE LUNA_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                        TriggerClientEvent('LUNA:ForceRefreshData', source)
                        if tonumber(membersource) > 0 then
                            LUNAclient.notify(source,{"~r~You have been kicked from the gang."})
                            TriggerClientEvent('LUNA:disbandedGang', membersource)
                        end
                    end)
                end
            end
        end
    end)
end)
RegisterServerEvent("LUNA:memberLeaveGang")
AddEventHandler("LUNA:memberLeaveGang", function(gangid)
    local source = source
    local user_id = LUNA.getUserId(source)
    local membersource = LUNA.getUserSource(user_id)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(user_id)].rank
                    local rank = array[tostring(user_id)].rank
                    array[tostring(user_id)] = nil
                    array = json.encode(array)
                    exports['ghmattimysql']:execute("UPDATE LUNA_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                        TriggerClientEvent('LUNA:ForceRefreshData', source)
                        if tonumber(membersource) > 0 then
                            LUNAclient.notify(source,{"~g~Successfully left gang."})
                            TriggerClientEvent('LUNA:disbandedGang', membersource)
                        end
                    end)
                end
            end
        end
    end)
end)
RegisterServerEvent("LUNA:InviteUserToGang")
AddEventHandler("LUNA:InviteUserToGang", function(gangid,playerid)
    local source = source
    playerid = tonumber(playerid)
    local user_id=LUNA.getUserId(source)
    local name = GetPlayerName(source)
    local message = "~g~Gang invite recieved from "..name
    local playersource = LUNA.getUserSource(playerid)
    if playersource == nil then
        LUNAclient.notify(source,{"~r~Player is not online."})
        return
    end
    local playername = GetPlayerName(playersource)
    TriggerClientEvent('LUNA:InviteRecieved', playersource,message,gangid)
end)
RegisterServerEvent("LUNA:DeleteGang")
AddEventHandler("LUNA:DeleteGang", function(gangid)
    local source=source
    local user_id=LUNA.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM LUNA_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    exports['ghmattimysql']:execute("DELETE FROM LUNA_gangs WHERE gangname = @gangname", {gangname = gangid}, function() end)
                    LUNAclient.notify(source,{"~g~Disbanded "..gangid})
                    TriggerClientEvent('LUNA:disbandedGang', source)
                    TriggerClientEvent('LUNA:ForceRefreshData', -1)
                end
            end
        end
    end)
end)