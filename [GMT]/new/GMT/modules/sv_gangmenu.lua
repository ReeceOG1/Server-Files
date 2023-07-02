function addGangLog(name, id, date, action, actionValue)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs', function(gotGangs)
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
                    exports['ghmattimysql']:execute("UPDATE gmt_gangs SET logs = @logs WHERE gangname=@gangname", {logs = ganglogs, gangname = gangname}, function()
                        TriggerClientEvent('GMT:ForceRefreshData', -1)
                    end)
                    break
                end
            end
        end
    end)
end

RegisterServerEvent("GMT:GetGangData")
AddEventHandler("GMT:GetGangData", function()
    local source = source
    local newarray = nil
    local peoplesids = {}
    local user_id = GMT.getUserId(source)
    local gangmembers ={}
    local gangpermission
    local ganglogs = {}
    local gotUser = exports['ghmattimysql']:executeSync('SELECT * FROM gmt_users WHERE id = @id', {id = user_id})
    local userData = exports['ghmattimysql']:executeSync('SELECT * FROM gmt_user_data WHERE user_id = @user_id', {user_id = user_id})
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    newarray={}
                    newarray["money"] = V.funds
                    isingang = true
                    newarray["id"] = V.gangname
                    gangpermission = L.gangPermission
                    ganglogs = json.decode(V.logs)
                    fundslocked = V.lockedfunds
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    for J,G in pairs(gotUser) do
                        for A,B in pairs(userData) do
                            if peoplesids[tostring(G.id)] ~= nil and G.id == B.user_id and B.dkey == 'GMT:datatable' then
                                local online = nil
                                if GMT.getUserSource(G.id) then
                                    online = 'Online'
                                else
                                    online = G.last_login
                                end
                                local playtime = json.decode(B.dvalue).PlayerTime or 0
                                playtime = playtime/60
                                if playtime < 1 then
                                    playtime = 0
                                end
                                table.insert(gangmembers,{G.username,tonumber(G.id),peoplesids[tostring(G.id)],online,math.ceil(playtime)})
                            end
                        end
                    end
                    TriggerClientEvent('GMT:GotGangData', source,newarray,gangmembers,gangpermission,ganglogs,fundslocked,0,false)
                    break
                end
            end
        end
    end)
end)
RegisterServerEvent("GMT:CreateGang")
AddEventHandler("GMT:CreateGang", function(gangname)
    local source=source
    local user_id=GMT.getUserId(source)
    local user_name = GetPlayerName(source)
    local funds = 0 
    local logs = "NOTHING"
    exports['ghmattimysql']:execute('SELECT gangname FROM gmt_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        if not GMT.hasGroup(user_id,"Gang") then
            GMTclient.notify(source,{"~r~You do not have gang licence."})
            return
        end
        if json.encode(gotGang) ~= "[]" and gotGang ~= nil and json.encode(gotGang) ~= nil then
            GMTclient.notify(source,{"~r~Gang name is already in use."})
            return
        end
        local gangmembers = {
            [tostring(user_id)] = {
                ["rank"] = 4,
                ["gangPermission"] = 4,
            },
        }
        gangmembers = json.encode(gangmembers)
        GMTclient.notify(source,{"~g~"..gangname.." created."})
        exports['ghmattimysql']:execute("INSERT INTO gmt_gangs (gangname,gangmembers,funds,logs) VALUES(@gangname,@gangmembers,@funds,@logs)", {gangname=gangname,gangmembers=gangmembers,funds=funds,logs=logs}, function() end)
        TriggerClientEvent('GMT:gangNameNotTaken', source)
        TriggerClientEvent('GMT:ForceRefreshData', -1)
    end)
end)
RegisterServerEvent("GMT:addUserToGang")
AddEventHandler("GMT:addUserToGang", function(ganginvite,playerid)
    local source=source
    local user_id=GMT.getUserId(source)
    local playersource = GMT.getUserSource(playerid)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname', {gangname = ganginvite}, function(G)
        if json.encode(G) == "[]" and G == nil and json.encode(G) == nil then
            GMTclient.notify(playersource,{"Gang no longer exists."})
            return
        end
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            array[tostring(playerid)] = {["rank"] = 1,["gangPermission"] = 1}
            exports['ghmattimysql']:execute("UPDATE gmt_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers = json.encode(array), gangname = ganginvite}, function()
                TriggerClientEvent('GMT:ForceRefreshData', -1)
            end)
        end
    end)
end)
RegisterServerEvent("GMT:depositGangBalance")
AddEventHandler("GMT:depositGangBalance", function(gangname, amount)
    local source = source
    local user_id = GMT.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        GMTclient.notify(source,{"Invalid Amount"})
                        return
                    end
                    if tonumber(GMT.getBankMoney(user_id)) < tonumber(amount) then
                        GMTclient.notify(source,{"Not enough money in bank."})
                    else
                        --
                        GMT.setBankMoney(user_id, (GMT.getBankMoney(user_id))-tonumber(amount))
                        GMTclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                        local newamount = tonumber(amount)+tonumber(funds)
                        local tax = tonumber(amount)*0.01
                        TriggerEvent('GMT:addToCommunityPot', math.floor(tax))
                        addGangLog(name, user_id, date, 'Deposited', '£'..getMoneyStringFormatted(amount))
                        exports['ghmattimysql']:execute("UPDATE gmt_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                            TriggerClientEvent('GMT:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
    TriggerClientEvent('GMT:ForceRefreshData', source)
end)
RegisterServerEvent("GMT:depositAllGangBalance")
AddEventHandler("GMT:depositAllGangBalance", function(gangname)
    local source = source 
    local user_id = GMT.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local amount = GMT.getBankMoney(user_id)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers) 
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then 
                        GMTclient.notify(source, {"Invalid Amount"})
                        return 
                    end
                    GMT.setBankMoney(user_id, (GMT.getBankMoney(user_id)-amount))
                    GMTclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                    local newamount = tonumber(amount)+tonumber(funds)
                    local tax = tonumber(amount)*0.01
                    TriggerEvent('GMT:addToCommunityPot', math.floor(tax))
                    addGangLog(name, user_id, date, 'Deposited', '£'..getMoneyStringFormatted(amount))
                    exports['ghmattimysql']:execute("UPDATE gmt_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                        TriggerClientEvent('GMT:ForceRefreshData', -1)
                    end)
                end
            end
        end
    end)
    TriggerClientEvent('GMT:ForceRefreshData', source)
end)

local gangWithdraw = {}
RegisterServerEvent("GMT:withdrawGangBalance")
AddEventHandler("GMT:withdrawGangBalance", function(gangname, amount)
    local source = source
    local user_id = GMT.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    if not gangWithdraw[source] then
        gangWithdraw[source] = true
        exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        if L.rank >= 3 then
                            local funds = V.funds
                            local gangname = V.gangname
                            if tonumber(amount) < 0 then
                                GMTclient.notify(source,{"Gang funds are locked currently."})
                            else
                                if tonumber(amount) < 0 then
                                    GMTclient.notify(source,{"Invalid Amount."})
                                    return
                                end
                                if tonumber(funds) < tonumber(amount) then
                                    GMTclient.notify(source,{"Invalid Amount."})
                                else
                                    GMT.setBankMoney(user_id, (GMT.getBankMoney(user_id))+tonumber(amount))
                                    GMTclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                                    local newamount = tonumber(funds)-tonumber(amount)
                                    addGangLog(name, user_id, date, 'Withdrew', '£'..getMoneyStringFormatted(amount))
                                    exports['ghmattimysql']:execute("UPDATE gmt_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                                        TriggerClientEvent('GMT:ForceRefreshData', -1)
                                    end)
                                end
                            end
                        else
                            GMTclient.notify(source, {"You do not have permission"})
                        end
                    end
                end
            end
            gangWithdraw[source] = nil
        end)
    end
    TriggerClientEvent('GMT:ForceRefreshData', source)
end)
RegisterServerEvent("GMT:withdrawAllGangBalance")
AddEventHandler("GMT:withdrawAllGangBalance", function()
    local source = source
    local user_id = GMT.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    if not gangWithdraw[source] then
        gangWithdraw[source] = true
        exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs', function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        local funds = V.funds
                        local gangname = V.gangname
                        local amount = V.funds
                        if tonumber(funds) < 1 then
                            GMTclient.notify(source,{"~r~Invalid Amount."})
                        else
                            GMT.setBankMoney(user_id, (GMT.getBankMoney(user_id)+amount))
                            GMTclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                            addGangLog(name, user_id, date, 'Withdrew', '£'..getMoneyStringFormatted(amount))
                            -- put webhook here for withdraw all
                            exports['ghmattimysql']:execute("UPDATE GMT_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                                TriggerClientEvent('GMT:ForceRefreshData', -1)
                            end)
                        end
                    end
                end
            end
            gangWithdraw[source] = nil
        end)
    end
    TriggerClientEvent('GMT:ForceRefreshData', source)
end)
RegisterServerEvent("GMT:PromoteUser")
AddEventHandler("GMT:PromoteUser", function(gangname,user_id)
    local source = source
    local user_id=GMT.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(user_id)].rank
                        local gangpermission = array[tostring(user_id)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= I then
                            GMTclient.notify(source,{"Only can Leader can promote."})
                            return
                        end
                        if array[tostring(user_id)].rank == 3 and gangpermission == 3 and tostring(user_id) == I then
                            GMTclient.notify(source,{"There can only be 1 leader in each gang."})
                            return
                        end
                        if tonumber(user_id) == tonumber(user_id) and rank == 4 and gangpermission == 4 then
                            GMTclient.notify(source,{"You are the highest rank."})
                            return
                        end 
                        array[tostring(user_id)].gangPermission = tonumber(gangpermission)+1
                        array[tostring(user_id)].rank = tonumber(rank)+1
                        array = json.encode(array)
                        addGangLog(name, user_id, date, 'Promoted', 'ID: '..user_id)
                        exports['ghmattimysql']:execute("UPDATE gmt_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('GMT:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("GMT:DemoteUser")
AddEventHandler("GMT:DemoteUser", function(gangname,user_id)
    local source = source
    local user_id=GMT.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(user_id)].rank
                        local gangpermission = array[tostring(user_id)].gangPermission
                        if rank == 4 or gangpermission == 4 then
                            GMTclient.notify(source,{"Cannot demote the leader"})
                            return
                        end
                        if rank == 1 and gangpermission == 1 then
                            GMTclient.notify(source,{"Member is already the lowest rank."})
                            return
                        end
                        array[tostring(user_id)].rank = tonumber(rank)-1
                        array[tostring(user_id)].gangPermission = tonumber(gangpermission)-1
                        array = json.encode(array)
                        addGangLog(name, user_id, date, 'Demoted', 'ID: '..user_id)
                        exports['ghmattimysql']:execute("UPDATE gmt_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('GMT:ForceRefreshData', -1)
                        end)
                    else
                        GMTclient.notify(source,{"You do not have permission."})
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("GMT:kickMemberFromGang")
AddEventHandler("GMT:kickMemberFromGang", function(gangname,member)
    local source = source
    local user_id = GMT.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local membersource = GMT.getUserSource(member)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(member)].rank
                    local rank = array[tostring(user_id)].rank
                    if L.rank >= 3 then
                        if tonumber(member) == tonumber(user_id) then
                            GMTclient.notify(source,{"You cannot kick yourself!"})
                            return
                        end
                        if tonumber(memberrank) >= rank then
                            GMTclient.notify(source,{"You do not have permission to kick this member from the gang."})
                            return
                        end
                        array[tostring(member)] = nil
                        array = json.encode(array)
                        GMTclient.notify(source,{"Successfully kicked member from gang"})
                        addGangLog(name, user_id, date, 'Kicked', 'ID: '..user_id)
                        exports['ghmattimysql']:execute("UPDATE gmt_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('GMT:ForceRefreshData', source)
                            if tonumber(membersource) > 0 then
                                GMTclient.notify(source,{"You have been kicked from the gang."})
                                TriggerClientEvent('GMT:disbandedGang', membersource)
                                TriggerClientEvent('GMT:ForceRefreshData', -1)
                            end
                        end)
                    else
                        GMTclient.notify(source,{"~rYou do not have permission."})
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("GMT:memberLeaveGang")
AddEventHandler("GMT:memberLeaveGang", function(gangname)
    local source = source
    local user_id = GMT.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local membersource = GMT.getUserSource(user_id)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(user_id)].rank
                    local rank = array[tostring(user_id)].rank
                    if rank == 4 then
                        GMTclient.notify(source,{"~rYou cannot leave the gang because you are the leader!"})
                        return
                    else
                        array[tostring(user_id)] = nil
                        array = json.encode(array)
                        addGangLog(name, user_id, date, 'Left', 'ID: '..user_id)
                        exports['ghmattimysql']:execute("UPDATE gmt_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('GMT:ForceRefreshData', source)
                            if tonumber(membersource) > 0 then
                                GMTclient.notify(source,{"~g~Successfully left gang."})
                                TriggerClientEvent('GMT:disbandedGang', membersource)
                                TriggerClientEvent('GMT:ForceRefreshData', -1)
                            end
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("GMT:InviteUserToGang")
AddEventHandler("GMT:InviteUserToGang", function(gangid,playerid)
    local source = source
    playerid = tonumber(playerid)
    local user_id=GMT.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local message = "~g~Gang invite recieved from "..name
    local playersource = GMT.getUserSource(playerid)
    if playersource == nil then
        GMTclient.notify(source,{"Player is not online."})
        return
    else
        local playername = GetPlayerName(playersource)
        addGangLog(name, user_id, date, 'Invited', 'ID: '..playerid)
        TriggerClientEvent('GMT:InviteRecieved', playersource,message,gangid)
        GMTclient.notify(source,{"~g~Successfully invited " ..playername.." to the gang"})
    end
end)
RegisterServerEvent("GMT:DeleteGang")
AddEventHandler("GMT:DeleteGang", function(gangid)
    local source=source
    local user_id=GMT.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank == 4 then
                    exports['ghmattimysql']:execute("DELETE FROM gmt_gangs WHERE gangname = @gangname", {gangname = gangid}, function() end)
                    GMTclient.notify(source,{"~g~Disbanded "..gangid})
                    TriggerClientEvent('GMT:disbandedGang', source)
                    TriggerClientEvent('GMT:ForceRefreshData', -1)
                    else
                        GMTclient.notify(source,{"You do not have permission."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("GMT:RenameGang")
AddEventHandler("GMT:RenameGang", function(gangid, newname)
    local source = source 
    local user_id = GMT.getUserId(source) 
    exports['ghmattimysql']:execute('SELECT gangname FROM gmt_gangs WHERE gangname = @gangname', {gangname = newname}, function(gotGangs)
        if json.encode(gotGang) ~= "[]" and gotGang ~= nil and json.encode(gotGang) ~= nil then
            GMTclient.notify(source,{"Gang name is already in use."})
            return
        end
        exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
            for K,V in pairs(G) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        if L.rank == 4 then
                            exports['ghmattimysql']:execute("UPDATE gmt_gangs SET gangname = @newname WHERE gangname = @gangname", {gangname = gangid, newname = newname}, function(gotGangs) end)
                            GMTclient.notify(source, {"~g~Renamed gang to "..newname})
                            TriggerClientEvent('GMT:ForceRefreshData', -1)
                        else
                            GMTclient.notify(source,{"You do not have permission."})
                        end
                    end
                end
            end
        end)
    end)
end)

RegisterServerEvent("GMT:SetGangWebhook")
AddEventHandler("GMT:SetGangWebhook", function(gangid)
    local source = source 
    local user_id = GMT.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 3 then
                        GMT.prompt(source,"Webhook (discord.com/api/webhooks/???): ","",function(source,webhook)
                            if webhook ~= nil and string.find(webhook, "https://discord.com/api/webhooks/") then 
                                exports['ghmattimysql']:execute("UPDATE gmt_gangs SET webhook = @webhook WHERE gangname = @gangname", {gangname = gangid, webhook = webhook}, function(gotGangs) end)
                                GMTclient.notify(source,{"~g~Webhook set."})
                                TriggerClientEvent('GMT:ForceRefreshData', -1)
                            else
                                GMTclient.notify(source,{"Invalid value."})
                            end
                        end)
                    else
                        GMTclient.notify(source,{"You do not have permission."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("GMT:LockGangFunds")
AddEventHandler("GMT:LockGangFunds", function(gangid)
    local source = source 
    local user_id=GMT.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank == 4 then
                        local fundsLocked = not V.lockedfunds
                        exports['ghmattimysql']:execute("UPDATE gmt_gangs SET lockedfunds = @lockedfunds WHERE gangname = @gangname", {gangname = gangid, lockedfunds = fundsLocked}, function(gotGangs) end)
                        GMTclient.notify(source, {"~g~Funds status changed."})
                        TriggerClientEvent('GMT:ForceRefreshData', -1)
                    else
                        GMTclient.notify(source,{"You do not have permission."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("GMT:sendGangMarker")
AddEventHandler("GMT:sendGangMarker", function(gangname)
    local source = source 
    local user_id = GMT.getUserId(source)
    local markerCreator = GetPlayerName(source)
    local peoplesids = {}
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname',{gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermissions)
                    end
                    exports['ghmattimysql']:execute('SELECT * FROM gmt_users', function(gotUser)
                        for J,G in pairs(gotUser) do 
                            if peoplesids[tostring(G.id)] ~= nil then
                                local player = GMT.getUserSource(tonumber(G.id))
                                if player ~= nil then 
                                    TriggerClientEvent('GMT:drawGangMarker', player, markerCreator, coords)
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end)
                            
RegisterServerEvent("GMT:applyGangFit")
AddEventHandler("GMT:applyGangFit", function(gangname)   
    local source = source 
    local user_id=GMT.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname',{gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if V.gangfit ~= nil then 
                        GMTclient.setCustomization(source, {json.decode(V.gangfit)})
                    else
                        GMTclient.notify(source,{"Gang does not have an outfit set."})
                    end
                    break
                end
            end
        end
    end)
end)

RegisterServerEvent("GMT:setGangFit")
AddEventHandler("GMT:setGangFit", function(gangid)  
    local source = source
    local user_id=GMT.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank == 4 then
                        GMTclient.setCustomization(source, {}, function(gangfit)
                            gangfit = json.encode(gangfit)
                            exports['ghmattimysql']:execute("UPDATE gmt_gangs SET gangfit = @gangfit WHERE gangname = @gangname", {gangname = gangid, gangfit = gangfit}, function(gotGangs) end)
                            GMTclient.notify(source,{"~g~Gang outfit set."})
                        end)
                    else
                        GMTclient.notify(source,{"You do not have permission."})
                    end
                end
            end
        end
    end)
end)


AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
  if first_spawn then
       TriggerClientEvent('GMT:ForceRefreshData', -1)
    end
end)

Citizen.CreateThread(function()
    while true do
        local healthTable = {}
        exports['ghmattimysql']:execute('SELECT * FROM gmt_gangs', function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    local permid = tonumber(I)
                    local tempId = GMT.getUserSource(permid)
                    if tempId ~= nil then
                        local playerPed = GetPlayerPed(tempId)
                        healthTable[permid] = {health = GetEntityHealth(playerPed), armour = GetPedArmour(playerPed)}
                    end
                end
            end
            TriggerClientEvent('GMT:sendGangHPStats', -1, healthTable)
        end)
        Citizen.Wait(5000)
    end
end)

function getMoneyStringFormatted(cashString)
    local i, j, minus, int = tostring(cashString):find('([-]?)(%d+)%.?%d*')

    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")

    -- reverse the int-string back, remove an optional comma, and put the optional minus back
    return minus .. int:reverse():gsub("^,", "")
end