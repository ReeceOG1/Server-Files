local currenttests = {}
local dvsamodule = module("cfg/cfg_dvsa")


local dvsaAlerts = {
    --{title = 'DVSA', message = 'No current alerts.', date = 'Wednesday 7th September 2022'},
}

AddEventHandler("playerJoining", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    exports['ghmattimysql']:execute("SELECT * FROM luna_dvsadata WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if next(result) then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    local data1 = {}
                    local licence = {}
                    local date = os.date("%d/%m/%Y")
                    local updateddata = exports['ghmattimysql']:executeSync("SELECT * FROM luna_dvsadata WHERE user_id = @user_id", {user_id = user_id})[1]
                    if updateddata ~= nil then
                        licence = {
                            ["banned"] = updateddata.licence == "banned",
                            ["full"] = updateddata.licence == "full",
                            ["active"] = updateddata.licence == "active",
                            ["points"] = updateddata.points or 0,
                            ["id"] = updateddata.id or "No Licence",
                            ["date"] = date or os.date("%d/%m/%Y")
                        }
                    end
                    TriggerClientEvent('LUNA:dvsaData',source,licence,json.decode(updateddata.testsaves),dvsaAlerts)
                    return
                end
            end
        else
            exports['ghmattimysql']:execute("INSERT INTO luna_dvsadata (user_id,licence,datelicence) VALUES (@user_id, 'none',"..os.date("%d/%m/%Y")..")", {user_id = user_id})
            local data1 = {}
            local licence = {}
            local date = os.date("%d/%m/%Y")
            local updateddata = exports['ghmattimysql']:executeSync("SELECT * FROM luna_dvsadata WHERE user_id = @user_id", {user_id = user_id})[1]
            if updateddata ~= nil then
                licence = {
                    ["banned"] = updateddata.licence == "banned",
                    ["full"] = updateddata.licence == "full",
                    ["active"] = updateddata.licence == "active",
                    ["points"] = updateddata.points or 0,
                    ["id"] = updateddata.id or "No Licence",
                    ["date"] = date or os.date("%d/%m/%Y")
                }
            end
            TriggerClientEvent('LUNA:dvsaData',source,licence,{},dvsaAlerts)
            return
        end
    end)
end)

function dvsaUpdate(user_id)
    local source = LUNA.getUserSource(user_id)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM luna_dvsadata WHERE user_id = @user_id", {user_id = user_id})[1]
    local licence = {}
    local date = os.date("%d/%m/%Y")
    if data ~= nil then
        licence = {
            ["banned"] = data.licence == "banned",
            ["full"] = data.licence == "full",
            ["active"] = data.licence == "active",
            ["points"] = data.points or 0,
            ["id"] = data.id or "No Licence",
            ["date"] = date or os.date("%d/%m/%Y")
        }
    end
    TriggerClientEvent('LUNA:updateDvsaData',source,licence,json.decode(data.testsaves),dvsaAlerts)
end
RegisterServerEvent("LUNA:dvsaBucket")
AddEventHandler("LUNA:dvsaBucket", function(bool)
    local source = source
    local user_id = LUNA.getUserId(source)
    if bool then
        if currenttests[user_id] ~= nil then
            LUNAclient.notify(source,{'~r~You already have a test in progress.'})
            return
        end
        local bucket = math.random(21,300)
        local highestcount = 21
        if table.count(currenttests) > 0 then
            for k,v in pairs(currenttests) do
                if v.bucket == bucket then
                    repeat highestcount = math.random(21,300) until highestcount ~= bucket
                end
            end
        end
        currenttests[user_id] = {
            ["bucket"] = highestcount
        }
        SetPlayerRoutingBucket(source, 12)
    elseif not bool then
        if currenttests[user_id] ~= nil then
            currenttests[user_id] = nil
        end
        SetPlayerRoutingBucket(source,0)
    end
end)

RegisterServerEvent("LUNA:candidatePassed")
AddEventHandler("LUNA:candidatePassed", function(seriousissues,minorissues,minorreasons)
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local source = source
    local licence
    local user_id = LUNA.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM luna_dvsadata WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        local previoustests = {}
        local testsaves = json.decode(GotLicence[1].testsaves)
        if testsaves ~= nil then
            previoustests = testsaves
            table.insert(previoustests, {date = localday, serious = seriousissues, minor = minorissues, minorsReason = minorreasons, pass = true}) 
        else
            table.insert(previoustests, {date = localday, serious = seriousissues,  minor = minorissues, minorsReason = minorreasons, pass = true})
        end
        if licence == "active" then
            exports['ghmattimysql']:execute("UPDATE luna_dvsadata SET licence = 'full', testsaves = @testsaves WHERE user_id = @user_id", {user_id = user_id,testsaves=json.encode(previoustests)}, function() end)
            Wait(100)
            dvsaUpdate(user_id)
        end
    end)
end)

RegisterServerEvent("LUNA:candidateFailed")
AddEventHandler("LUNA:candidateFailed", function(seriousissues,minorissues,seriousreasons,minorreasons)    
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local source = source
    local licence
    local user_id = LUNA.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM luna_dvsadata WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        local previoustests = {}
        local testsaves = json.decode(GotLicence[1].testsaves)
        if testsaves ~= nil then
            previoustests = testsaves
            table.insert(previoustests, {date = localday, serious = seriousissues, seriousReason = seriousreasons, minor = minorissues, minorsReason = minorreasons})
        else
            table.insert(previoustests, {date = localday, serious = seriousissues, seriousReason = seriousreasons, minor = minorissues, minorsReason = minorreasons})
        end
        if licence == "active" then
            exports['ghmattimysql']:execute("UPDATE luna_dvsadata SET testsaves = @testsaves WHERE user_id = @user_id", {user_id = user_id,testsaves=json.encode(previoustests)}, function() end)
            Wait(100)
            dvsaUpdate(user_id)
        end
    end)
end)

RegisterServerEvent("LUNA:beginTest")
AddEventHandler("LUNA:beginTest", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM luna_dvsadata WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == ("full" or "banned") then
        TriggerClientEvent('LUNA:beginTestClient', source, false)
        return
    end
    if data.licence == "active" then
        TriggerClientEvent('LUNA:beginTestClient', source,true,math.random(1,3))
    else
        --ac ban
    end
end)

RegisterServerEvent("LUNA:surrenderLicence")
AddEventHandler("LUNA:surrenderLicence", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM luna_dvsadata WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == "banned" then
        LUNAclient.notify(source,{'~r~You are already banned from driving.'})
        --ac ban
        return
    end
    if data.licence == "active" or data.licence == "full" then
        exports['ghmattimysql']:execute("UPDATE luna_dvsadata SET licence = @licence WHERE user_id = @user_id", {licence = "none", user_id = user_id})
        exports['ghmattimysql']:execute("UPDATE luna_dvsadata SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(100)
        dvsaUpdate(user_id)
    end
end)

RegisterServerEvent("LUNA:activateLicence")
AddEventHandler("LUNA:activateLicence", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM luna_dvsadata WHERE user_id = @user_id", {user_id = user_id})[1]
    if data == nil then return end
    if data.licence == "none" then
        exports['ghmattimysql']:execute("UPDATE luna_dvsadata SET licence = @licence, datelicence = @datelicense WHERE user_id = @user_id", {licence = "active", datelicense = os.date("%d/%m/%Y"), user_id = user_id})
        exports['ghmattimysql']:execute("UPDATE luna_dvsadata SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(6500)
        dvsaUpdate(user_id)
    end
end)

RegisterNetEvent("Create:Plate", function()
    print("Triggered")
    local src = source
    local plyPed = GetPlayerPed(src)
    local model = GetHashKey('prop_lplate')
    local plate = CreateObject(model, GetEntityCoords(plyPed), true, false, false)
    local plate2 = CreateObject(model, GetEntityCoords(plyPed), true, false, false)
    while not DoesEntityExist(plate) and not DoesEntityExist(plate2) do
        --print("Waiting for plates to create.")
        Wait(100)
    end
    local net1 = NetworkGetNetworkIdFromEntity(plate)
    local net2 = NetworkGetNetworkIdFromEntity(plate2)
    TriggerClientEvent("Plate:Created", src, net1, net2)
end)


RegisterServerEvent("LUNA:speedCameraFlashServer",function(speed)
    local source = source
    local user_id = LUNA.getUserId(source)
    local name = GetPlayerName(source)
    local bank = LUNA.getBankMoney(user_id)
    local speed = tonumber(speed)
    local overspeed = speed-180
    local fine = 7563
    if LUNA.hasPermission(user_id,"police.armoury") then
        return
    end
    if tonumber(bank) > 7563 then
        LUNA.setBankMoney(user_id,bank-7563)
        TriggerClientEvent('LUNA:dvsaMessage', source,"DVSA","UK Government","You were fined £"..fine.." for going over the speedlimit")
        -- could add in the future that it gives points to a license
        return
    else
        LUNAclient.notify(source,{'~r~You could not afford the fine. Benefits paid.'})
        return
    end
end)