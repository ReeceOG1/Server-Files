local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

RegisterServerEvent('GMT:OpenSettings')
AddEventHandler('GMT:OpenSettings', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id ~= nil then
        if GMT.hasPermission(user_id, "admin.tickets") then
            TriggerClientEvent("GMT:OpenAdminMenu", source, true)
        else
            TriggerClientEvent("GMT:OpenSettingsMenu", source, false)
        end
    end
end)

RegisterCommand("gethours", function(source, args)
    local v = source
    local UID = GMT.getUserId(v)
    local D = math.ceil(GMT.getUserDataTable(UID).PlayerTime/60) or 0
    if UID then
        if D > 5000 then
            GMTclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
        elseif D > 4000 then
            GMTclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
        elseif D > 3000 then
            GMTclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
        elseif D > 2000 then
            GMTclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
        elseif D > 1000 then
            GMTclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
        else
            GMTclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
        end
    end
end)

RegisterCommand("sethours", function(source, args) 
    if source == 0 then 
        local data = GMT.getUserDataTable(tonumber(args[1]))
        data.PlayerTime = tonumber(args[2])*60
        print(GetPlayerName(GMT.getUserSource(tonumber(args[1]))).."'s hours have been set to: "..tonumber(args[2]))
    end  
end)


RegisterNetEvent("GMT:GetNearbyPlayers")
AddEventHandler("GMT:GetNearbyPlayers", function(coords, dist)
    local source = source
    local user_id = GMT.getUserId(source)
    local plrTable = {}
    if GMT.hasPermission(user_id, 'admin.tickets') then
        GMTclient.getNearestPlayersFromPosition(source, {coords, dist}, function(nearbyPlayers)
            for k, v in pairs(nearbyPlayers) do
                data = GMT.getUserDataTable(GMT.getUserId(k))
                playtime = data.PlayerTime or 0
                PlayerTimeInHours = playtime/60
                if PlayerTimeInHours < 1 then
                    PlayerTimeInHours = 0
                end
                plrTable[GMT.getUserId(k)] = {GetPlayerName(k), k, GMT.getUserId(k), math.ceil(PlayerTimeInHours)}
            end
            plrTable[user_id] = {GetPlayerName(source), source, GMT.getUserId(source), math.ceil((GMT.getUserDataTable(user_id).PlayerTime/60)) or 0}
            TriggerClientEvent("GMT:ReturnNearbyPlayers", source, plrTable)
        end)
    end
end)

RegisterServerEvent("GMT:requestAccountInfosv")
AddEventHandler("GMT:requestAccountInfosv",function(permid)
    adminrequest = source
    adminrequest_id = GMT.getUserId(adminrequest)
    requesteduser = permid
    requestedusersource = GMT.getUserSource(requesteduser)
    if GMT.hasPermission(adminrequest_id, 'group.remove') then
        TriggerClientEvent('GMT:requestAccountInfo', GMT.getUserSource(permid))
    end
end)

RegisterServerEvent("GMT:receivedAccountInfo")
AddEventHandler("GMT:receivedAccountInfo", function(gpu,cpu,userAgent)
    if GMT.hasPermission(adminrequest_id, 'group.remove') then
        GMT.prompt(adminrequest,"Account Info","GPU: " .. gpu.." \n\nCPU: "..cpu.." \n\nUser Agent: "..userAgent,function(player,K)
        end)
    end
end)

RegisterServerEvent("GMT:GetGroups")
AddEventHandler("GMT:GetGroups",function(perm)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("GMT:GotGroups", source, GMT.getUserGroups(perm))
    end
end)

RegisterServerEvent("GMT:CheckPov")
AddEventHandler("GMT:CheckPov",function(userperm)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, "admin.tickets") then
        if GMT.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('GMT:ReturnPov', source, true)
        else
            TriggerClientEvent('GMT:ReturnPov', source, false)
        end
    end
end)


RegisterServerEvent("wk:fixVehicle")
AddEventHandler("wk:fixVehicle",function()
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('wk:fixVehicle', source)
    end
end)

local spectatingPositions = {}
RegisterServerEvent("GMT:spectatePlayer")
AddEventHandler("GMT:spectatePlayer", function(id)
    local playerssource = GMT.getUserSource(id)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, "admin.spectate") then
        if playerssource ~= nil then
            spectatingPositions[user_id] = {coords = GetEntityCoords(GetPlayerPed(source)), bucket = GetPlayerRoutingBucket(source)}
            tGMT.setBucket(source, GetPlayerRoutingBucket(playerssource))
            TriggerClientEvent("GMT:spectatePlayer",source, playerssource, GetEntityCoords(GetPlayerPed(playerssource)))
            tGMT.sendWebhook('spectate',"GMT Spectate Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(playerssource).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
        else
            GMTclient.notify(source, {"~r~You can't spectate an offline player."})
        end
    end
end)

RegisterServerEvent("GMT:stopSpectatePlayer")
AddEventHandler("GMT:stopSpectatePlayer", function()
    local source = source
    if GMT.hasPermission(GMT.getUserId(source), "admin.spectate") then
        TriggerClientEvent("GMT:stopSpectatePlayer",source)
        for k,v in pairs(spectatingPositions) do
            if k == GMT.getUserId(source) then
                TriggerClientEvent("GMT:stopSpectatePlayer",source,v.coords,v.bucket)
                SetEntityCoords(GetPlayerPed(source),v.coords)
                tGMT.setBucket(source, v.bucket)
                spectatingPositions[k] = nil
            end
        end
    end
end)

RegisterServerEvent("GMT:Giveweapon")
AddEventHandler("GMT:Giveweapon",function()
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, "dev.menu") then
        GMT.prompt(source,"Weapon Name:","",function(source,hash) 
            GMTclient.giveWeapons(source, {{['WEAPON_'..string.upper(hash)] = {ammo = 250}}, false})
            GMTclient.notify(source,{"~g~Successfully spawned ~b~"..hash})
        end)
    end
end)

RegisterServerEvent("GMT:GiveWeaponToPlayer")
AddEventHandler("GMT:GiveWeaponToPlayer",function()
    local source = source
    local admin = source
    local admin_id = GMT.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local source = source
    local userid = GMT.getUserId(source)
    if GMT.hasPermission(userid, "dev.menu") then
        GMT.prompt(source,"Perm ID:","",function(source,permid) 
            local permid = tonumber(permid)
            local permsource = GMT.getUserSource(permid)
            if permsource ~= nil then
                GMT.prompt(source,"Weapon Name:","",function(source,hash) 
                    GMTclient.giveWeapons(permsource, {{['WEAPON_'..string.upper(hash)] = {ammo = 250}}, false})
                    GMTclient.notify(source,{"~g~Successfully gave ~b~"..hash..' ~g~to '..GetPlayerName(permsource)})
                end)
            end
        end)
    end
end)

RegisterServerEvent("GMT:ForceClockOff")
AddEventHandler("GMT:ForceClockOff", function(player_temp)
    local source = source
    local user_id = GMT.getUserId(source)
    local name = GetPlayerName(source)
    local player_perm = GMT.getUserId(player_temp)
    if GMT.hasPermission(user_id,"admin.tp2waypoint") then
        GMT.removeAllJobs(player_perm)
        GMTclient.notify(source,{'~g~User clocked off'})
        GMTclient.notify(player_temp,{'~b~You have been force clocked off.'})
        tGMT.sendWebhook('force-clock-off',"GMT Faction Logs", "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..GetPlayerName(player_temp).."**\n> Players TempID: **"..player_temp.."**\n> Players PermID: **"..player_perm.."**")
    else
        local player = GMT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", user_id, 11, name, player, 'Attempted to Force Clock Off')
    end
end)

RegisterServerEvent("GMT:AddGroup")
AddEventHandler("GMT:AddGroup",function(perm, selgroup)
    local source = source
    local admin_temp = source
    local user_id = GMT.getUserId(source)
    local permsource = GMT.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if GMT.hasPermission(user_id, "group.add") then
        if selgroup == "Founder" and not GMT.hasPermission(user_id, "group.add.founder") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Lead Developer" and not GMT.hasPermission(user_id, "group.add.leaddeveloper") then
                GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Lead Developer" and not GMT.hasPermission(user_id, "group.add.developer") then
                GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not GMT.hasPermission(user_id, "group.add.staffmanager") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not GMT.hasPermission(user_id, "group.add.commanager") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not GMT.hasPermission(user_id, "group.add.headadmin") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Senior Admin" and not GMT.hasPermission(user_id, "group.add.senioradmin") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Admin" and not GMT.hasPermission(user_id, "group.add.administrator") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not GMT.hasPermission(user_id, "group.add.srmoderator") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Moderator" and not GMT.hasPermission(user_id, "group.add.moderator") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Support Team" and not GMT.hasPermission(user_id, "group.add.supportteam") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not GMT.hasPermission(user_id, "group.add.trial") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "pov" and not GMT.hasPermission(user_id, "group.add.pov") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        else
            GMT.addUserGroup(perm, selgroup)
            local user_groups = GMT.getUserGroups(perm)
            TriggerClientEvent("GMT:GotGroups", source, user_groups)
            tGMT.sendWebhook('group',"GMT Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..GetPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Added**")
        end
    end
end)

RegisterServerEvent("GMT:RemoveGroup")
AddEventHandler("GMT:RemoveGroup",function(perm, selgroup)
    local source = source
    local user_id = GMT.getUserId(source)
    local admin_temp = source
    local permsource = GMT.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if GMT.hasPermission(user_id, "group.remove") then
        if selgroup == "Founder" and not GMT.hasPermission(user_id, "group.remove.founder") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Developer" and not GMT.hasPermission(user_id, "group.remove.developer") then
                GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not GMT.hasPermission(user_id, "group.remove.staffmanager") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not GMT.hasPermission(user_id, "group.remove.commanager") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not GMT.hasPermission(user_id, "group.remove.headadmin") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Senior Admin" and not GMT.hasPermission(user_id, "group.remove.senioradmin") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Admin" and not GMT.hasPermission(user_id, "group.remove.administrator") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not GMT.hasPermission(user_id, "group.remove.srmoderator") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Moderator" and not GMT.hasPermission(user_id, "group.remove.moderator") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Support Team" and not GMT.hasPermission(user_id, "group.remove.supportteam") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not GMT.hasPermission(user_id, "group.remove.trial") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "pov" and not GMT.hasPermission(user_id, "group.remove.pov") then
            GMTclient.notify(admin_temp, {"You don't have permission to do that"})
        else
            GMT.removeUserGroup(perm, selgroup)
            local user_groups = GMT.getUserGroups(perm)
            TriggerClientEvent("GMT:GotGroups", source, user_groups)
            tGMT.sendWebhook('group',"GMT Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..GetPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Removed**")
        end
    end
end)

local bans = {
    {id = "trolling",name = "1.0 Trolling",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "trollingminor",name = "1.0 Trolling (Minor)",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "metagaming",name = "1.1 Metagaming",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "powergaming",name = "1.2 Power Gaming ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "failrp",name = "1.3 Fail RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rdm", name = "1.4 RDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "massrdm",name = "1.4.1 Mass RDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "nrti",name = "1.5 No Reason to Initiate (NRTI) ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "vdm", name = "1.6 VDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "massvdm",name = "1.6.1 Mass VDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "offlanguageminor",name = "1.7 Offensive Language/Toxicity (Minor)",durations = {2,24,72},bandescription = "1st Offense: 2hr\n2nd Offense: 24hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "offlanguagestandard",name = "1.7 Offensive Language/Toxicity (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "offlanguagesevere",name = "1.7 Offensive Language/Toxicity (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "breakrp",name = "1.8 Breaking Character",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "combatlog",name = "1.9 Combat logging",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "combatstore",name = "1.10 Combat storing",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "exploitingstandard",name = "1.11 Exploiting (Standard)",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "exploitingsevere",name = "1.11 Exploiting (Severe)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "oogt",name = "1.12 Out of game transactions (OOGT)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "spitereport",name = "1.13 Spite Reporting",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "scamming",name = "1.14 Scamming",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "loans",name = "1.15 Loans",durations = {48,168,-1},bandescription = "1st Offense: 48hr\n2nd Offense: 168hr\n3rd Offense: Permanent",itemchecked = false},
    {id = "wastingadmintime",name = "1.16 Wasting Admin Time",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "ftvl",name = "2.1 Value of Life",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "sexualrp",name = "2.2 Sexual RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "terrorrp",name = "2.3 Terrorist RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "impwhitelisted",name = "2.4 Impersonation of Whitelisted Factions",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gtadriving",name = "2.5 GTA Online Driving",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "nlr", name = "2.6 NLR",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "badrp",name = "2.7 Bad RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "kidnapping",name = "2.8 Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "stealingems",name = "3.0 Theft of Emergency Vehicles",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "whitelistabusestandard",name = "3.1 Whitelist Abuse",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "whitelistabusesevere",name = "3.1 Whitelist Abuse",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "copbaiting",name = "3.2 Cop Baiting",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "pdkidnapping",name = "3.3 PD Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "unrealisticrevival",name = "3.4 Unrealistic Revival",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "interjectingrp",name = "3.5 Interjection of RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "combatrev",name = "3.6 Combat Reviving",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gangcap",name = "3.7 Gang Cap",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "maxgang",name = "3.8 Max Gang Numbers",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "gangalliance",name = "3.9 Gang Alliance",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "impgang",name = "3.10 Impersonation of Gangs",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gzstealing",name = "4.1 Stealing Vehicles in Greenzone",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gzillegal",name = "4.2 Selling Illegal Items in Greenzone",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gzretretreating",name = "4.3 Greenzone Retreating ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rzhostage",name = "4.5 Taking Hostage into Redzone",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rzretreating",name = "4.6 Redzone Retreating",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "advert",name = "1.1 Advertising",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "bullying",name = "1.2 Bullying",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "impersonationrule",name = "1.3 Impersonation",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "language",name = "1.4 Language",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discrim",name = "1.5 Discrimination ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "attacks",name = "1.6 Malicious Attacks ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "PIIstandard",name = "1.7 PII (Personally Identifiable Information)(Standard)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "PIIsevere",name = "1.7 PII (Personally Identifiable Information)(Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "chargeback",name = "1.8 Chargeback",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discretion",name = "1.9 Staff Discretion",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "cheating",name = "1.10 Cheating",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "banevading",name = "1.11 Ban Evading",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "fivemcheats",name = "1.12 Withholding/Storing FiveM Cheats",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "altaccount",name = "1.13 Multi-Accounting",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "association",name = "1.14 Association with External Modifications",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "pov",name = "1.15 Failure to provide POV ",durations = {2,-1,-1},bandescription = "1st Offense: 2hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false    },
    {id = "withholdinginfostandard",name = "1.16 Withholding Information From Staff (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "withholdinginfosevere",name = "1.16 Withholding Information From Staff (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "blackmail",name = "1.17 Blackmailing",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false}
}
    
   

local PlayerOffenses = {}
local PlayerBanCachedDuration = {}
local defaultBans = {}

RegisterServerEvent("GMT:GenerateBan")
AddEventHandler("GMT:GenerateBan", function(PlayerID, RulesBroken)
    local source = source
    local PlayerCacheBanMessage = {}
    local PermOffense = false
    local separatormsg = {}
    local points = 0
    PlayerBanCachedDuration[PlayerID] = 0
    PlayerOffenses[PlayerID] = {}
    if GMT.hasPermission(GMT.getUserId(source), "admin.tickets") then
        exports['ghmattimysql']:execute("SELECT * FROM gmt_bans_offenses WHERE UserID = @UserID", {UserID = PlayerID}, function(result)
            if #result > 0 then
                points = result[1].points
                PlayerOffenses[PlayerID] = json.decode(result[1].Rules)
                for k,v in pairs(RulesBroken) do
                    for a,b in pairs(bans) do
                        if b.id == k then
                            PlayerOffenses[PlayerID][k] = PlayerOffenses[PlayerID][k] + 1
                            if PlayerOffenses[PlayerID][k] > 3 then
                                PlayerOffenses[PlayerID][k] = 3
                            end
                            PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + bans[a].durations[PlayerOffenses[PlayerID][k]]
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] ~= -1 then
                                points = points + bans[a].durations[PlayerOffenses[PlayerID][k]]/24
                            end
                            table.insert(PlayerCacheBanMessage, bans[a].name)
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] == -1 then
                                PlayerBanCachedDuration[PlayerID] = -1
                                PermOffense = true
                            end
                            if PlayerOffenses[PlayerID][k] == 1 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~1st Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] == 2 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~2nd Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] >= 3 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~3rd Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            end
                        end
                    end
                end
                if PermOffense then 
                    PlayerBanCachedDuration[PlayerID] = -1
                end
                Wait(100)
                TriggerClientEvent("GMT:RecieveBanPlayerData", source, PlayerBanCachedDuration[PlayerID], table.concat(PlayerCacheBanMessage, ", "), separatormsg, math.floor(points))
            end
        end)
    end
end)

AddEventHandler("playerJoining", function()
    local source = source
    local user_id = GMT.getUserId(source)
    for k,v in pairs(bans) do
        defaultBans[v.id] = 0
    end
    exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO gmt_bans_offenses(UserID,Rules) VALUES(@UserID, @Rules)", {UserID = user_id, Rules = json.encode(defaultBans)})
    exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO gmt_user_notes(user_id) VALUES(@user_id)", {user_id = user_id})
end)

RegisterCommand('removepoints', function(source, args) -- for removing points each month
    local source = source
    if GMT.getUserId(source) == 1 then
        removePoints = tonumber(args[1])
        exports['ghmattimysql']:execute("UPDATE gmt_bans_offenses SET points = CASE WHEN ((points-@removepoints)>0) THEN (points-@removepoints) ELSE 0 END WHERE points > 0", {removepoints = removePoints}, function() end)
        GMTclient.notify(source, {'~g~Removed '..removePoints..' points from all users.'})
    end
end)

RegisterServerEvent("GMT:BanPlayer")
AddEventHandler("GMT:BanPlayer", function(PlayerID, Duration, BanMessage, BanPoints)
    local source = source
    local AdminPermID = GMT.getUserId(source)
    local AdminName = GetPlayerName(source)
    local CurrentTime = os.time()
    local PlayerDiscordID = 0
    GMT.prompt(source, "Extra Ban Information (Hidden)","",function(player, Evidence)
        if GMT.hasPermission(AdminPermID, "admin.tickets") then
            if Evidence == "" then
                GMTclient.notify(source, {"Evidence field was left empty, please fill this in via Discord."})
            end
            if Duration == -1 then
                banDuration = "perm"
                BanPoints = 0
            else
                banDuration = CurrentTime + (60 * 60 * tonumber(Duration))
            end
            tGMT.sendWebhook('ban-player', AdminName.. " banned "..PlayerID, "> Admin Name: **"..AdminName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..AdminPermID.."**\n> Players PermID: **"..PlayerID.."**\n> Ban Duration: **"..Duration.."**\n> Reason(s): **"..BanMessage.."**")
            GMT.ban(source,PlayerID,banDuration,BanMessage,Evidence)
            f10Ban(PlayerID, AdminName, BanMessage, Duration)
            exports['ghmattimysql']:execute("UPDATE gmt_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = BanPoints}, function() end)
            local a = exports['ghmattimysql']:executeSync("SELECT * FROM gmt_bans_offenses WHERE UserID = @uid", {uid = PlayerID})
            for k,v in pairs(a) do
                if v.UserID == PlayerID then
                    if v.points > 10 then
                        exports['ghmattimysql']:execute("UPDATE gmt_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = 10}, function() end)
                        GMT.banConsole(PlayerID,2160,"You have reached 10 points and have received a 3 month ban.")
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent('GMT:RequestScreenshot')
AddEventHandler('GMT:RequestScreenshot', function(admin,target)
    local source = source
    local target_id = GMT.getUserId(target)
    local target_name = GetPlayerName(target)
    local admin_id = GMT.getUserId(admin)
    local admin_name = GetPlayerName(source)
    if GMT.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("GMT:takeClientScreenshotAndUpload", target, tGMT.getWebhook('screenshot'))
        tGMT.sendWebhook('screenshot', 'GMT Screenshot Logs', "> Players Name: **"..GetPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        local player = GMT.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Request Screenshot')
    end   
end)

RegisterServerEvent('GMT:RequestVideo')
AddEventHandler('GMT:RequestVideo', function(admin,target)
    local source = source
    local target_id = GMT.getUserId(target)
    local target_name = GetPlayerName(target)
    local admin_id = GMT.getUserId(admin)
    local admin_name = GetPlayerName(source)
    if GMT.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("GMT:takeClientVideoAndUpload", target, tGMT.getWebhook('video'))
        tGMT.sendWebhook('video', 'GMT Video Logs', "> Players Name: **"..GetPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        local player = GMT.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Request Video')
    end   
end)

RegisterServerEvent('GMT:KickPlayer')
AddEventHandler('GMT:KickPlayer', function(admin, target, tempid)
    local source = source
    local target_id = GMT.getUserSource(target)
    local target_permid = target
    local playerName = GetPlayerName(source)
    local playerOtherName = GetPlayerName(tempid)
    local admin_id = GMT.getUserId(admin)
    local adminName = GetPlayerName(admin)
    if GMT.hasPermission(admin_id, 'admin.kick') then
        GMT.prompt(source,"Reason:","",function(source,Reason) 
            if Reason == "" then return end
            tGMT.sendWebhook('kick-player', 'GMT Kick Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..playerOtherName.."**\n> Player TempID: **"..target_id.."**\n> Player PermID: **"..target.."**\n> Kick Reason: **"..Reason.."**")
            GMT.kick(target_id, "GMT You have been kicked | Your ID is: "..target.." | Reason: " ..Reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
            GMTclient.notify(admin, {'~g~Kicked Player.'})
        end)
    else
        local player = GMT.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Kick Someone')
    end
end)


RegisterServerEvent('GMT:RemoveWarning')
AddEventHandler('GMT:RemoveWarning', function(warningid)
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id ~= nil then
        if GMT.hasPermission(user_id, "admin.removewarn") then 
            exports['ghmattimysql']:execute("SELECT * FROM gmt_warnings WHERE warning_id = @warning_id", {warning_id = tonumber(warningid)}, function(result) 
                if result ~= nil then
                    for k,v in pairs(result) do
                        if v.warning_id == tonumber(warningid) then
                            exports['ghmattimysql']:execute("DELETE FROM gmt_warnings WHERE warning_id = @warning_id", {warning_id = v.warning_id})
                            exports['ghmattimysql']:execute("UPDATE gmt_bans_offenses SET points = CASE WHEN ((points-@removepoints)>0) THEN (points-@removepoints) ELSE 0 END WHERE UserID = @UserID", {UserID = v.user_id, removepoints = (v.duration/24)}, function() end)
                            GMTclient.notify(source, {'~g~Removed F10 Warning #'..warningid..' ('..(v.duration/24)..' points) from ID: '..v.user_id})
                            tGMT.sendWebhook('remove-warning', 'GMT Remove Warning Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Warning ID: **"..warningid.."**")
                        end
                    end
                end
            end)
        else
            local player = GMT.getUserSource(admin_id)
            local name = GetPlayerName(source)
            Wait(500)
            TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Remove Warning')
        end
    end
end)

RegisterServerEvent("GMT:Unban")
AddEventHandler("GMT:Unban",function()
    local source = source
    local admin_id = GMT.getUserId(source)
    playerName = GetPlayerName(source)
    if GMT.hasPermission(admin_id, 'admin.unban') then
        GMT.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            GMTclient.notify(source,{'~g~Unbanned ID: ' .. permid})
            tGMT.sendWebhook('unban-player', 'GMT Unban Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**")
            GMT.setBanned(permid,false)
        end)
    else
        local player = GMT.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Unban Someone')
    end
end)


RegisterServerEvent("GMT:getNotes")
AddEventHandler("GMT:getNotes",function(player)
    local source = source
    local admin_id = GMT.getUserId(source)
    if GMT.hasPermission(admin_id, 'admin.tickets') then
        exports['ghmattimysql']:execute("SELECT * FROM gmt_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                TriggerClientEvent('GMT:sendNotes', source, result[1].info)
            end
        end)
    end
end)

RegisterServerEvent("GMT:updatePlayerNotes")
AddEventHandler("GMT:updatePlayerNotes",function(player, notes)
    local source = source
    local admin_id = GMT.getUserId(source)
    if GMT.hasPermission(admin_id, 'admin.tickets') then
        exports['ghmattimysql']:execute("SELECT * FROM gmt_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                exports['ghmattimysql']:execute("UPDATE gmt_user_notes SET info = @info WHERE user_id = @user_id", {user_id = player, info = json.encode(notes)})
                GMTclient.notify(source, {'~g~Notes updated.'})
            end
        end)
    end
end)

RegisterServerEvent('GMT:SlapPlayer')
AddEventHandler('GMT:SlapPlayer', function(admin, target)
    local source = source
    local admin_id = GMT.getUserId(admin)
    local player_id = GMT.getUserId(target)
    if GMT.hasPermission(admin_id, "admin.slap") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        tGMT.sendWebhook('slap', 'GMT Slap Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..admin.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
        TriggerClientEvent('GMT:SlapPlayer', target)
        GMTclient.notify(admin, {'~g~Slapped Player.'})
    else
        local player = GMT.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Slap Someone')
    end
end)

RegisterServerEvent('GMT:RevivePlayer')
AddEventHandler('GMT:RevivePlayer', function(admin, targetid, reviveall)
    local source = source
    local admin_id = GMT.getUserId(admin)
    local player_id = targetid
    local target = GMT.getUserSource(player_id)
    if target ~= nil then
        if GMT.hasPermission(admin_id, "admin.revive") then
            GMTclient.RevivePlayer(target, {})
            GMTclient.setPlayerCombatTimer(target, {0})
            if not reviveall then
                local playerName = GetPlayerName(source)
                local playerOtherName = GetPlayerName(target)
                tGMT.sendWebhook('revive', 'GMT Revive Logs', "> Admin Name: **"..GetPlayerName(admin).."**\n> Admin TempID: **"..admin.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
                GMTclient.notify(admin, {'~g~Revived Player.'})
                return
            end
            GMTclient.notify(admin, {'~g~Revived all Nearby.'})
        else
            local player = GMT.getUserSource(admin_id)
            local name = GetPlayerName(source)
            Wait(500)
            TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Revive Someone')
        end
    end
end)

frozenplayers = {}

RegisterServerEvent('GMT:FreezeSV')
AddEventHandler('GMT:FreezeSV', function(admin, newtarget, isFrozen)
    local source = source
    local admin_id = GMT.getUserId(admin)
    local player_id = GMT.getUserId(newtarget)
    if GMT.hasPermission(admin_id, 'admin.freeze') then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        if isFrozen then
            tGMT.sendWebhook('freeze', 'GMT Freeze Logs', "> Admin Name: **"..GetPlayerName(admin).."**\n> Admin TempID: **"..admin.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..player_id.."**\n> Type: **Frozen**")
            GMTclient.notify(admin, {'~g~Froze Player.'})
            frozenplayers[user_id] = true
            GMTclient.notify(newtarget, {'~g~You have been frozen.'})
        else
            tGMT.sendWebhook('freeze', 'GMT Freeze Logs', "> Admin Name: **"..GetPlayerName(admin).."**\n> Admin TempID: **"..admin.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..player_id.."**\n> Type: **Unfrozen**")
            GMTclient.notify(admin, {'~g~Unfrozen Player.'})
            GMTclient.notify(newtarget, {'~g~You have been unfrozen.'})
            frozenplayers[user_id] = nil
        end
        TriggerClientEvent('GMT:Freeze', newtarget, isFrozen)
    else
        local player = GMT.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Freeze Someone')
    end
end)

RegisterServerEvent('GMT:TeleportToPlayer')
AddEventHandler('GMT:TeleportToPlayer', function(source, newtarget)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = GMT.getUserId(source)
    local player_id = GMT.getUserId(newtarget)
    if GMT.hasPermission(user_id, 'admin.tp2player') then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        local adminbucket = GetPlayerRoutingBucket(source)
        local playerbucket = GetPlayerRoutingBucket(newtarget)
        if adminbucket ~= playerbucket then
            tGMT.setBucket(source, playerbucket)
            GMTclient.notify(source, {'~g~Player was in another bucket, you have been set into their bucket.'})
        end
        GMTclient.teleport(source, coords)
        GMTclient.notify(newtarget, {'~g~An admin has teleported to you.'})
    else
        local player = GMT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", user_id, 11, name, player, 'Attempted to Teleport to Someone')
    end
end)

RegisterServerEvent('GMT:Teleport2Legion')
AddEventHandler('GMT:Teleport2Legion', function(newtarget)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.tp2player') then
        GMTclient.teleport(newtarget, vector3(152.66354370117,-1035.9771728516,29.337995529175))
        GMTclient.notify(newtarget, {'~g~You have been teleported to Legion by an admin.'})
        GMTclient.setPlayerCombatTimer(newtarget, {0})
        tGMT.sendWebhook('tp-to-legion', 'GMT Teleport Legion Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(newtarget).."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..GMT.getUserId(newtarget).."**")
    else
        local player = GMT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", user_id, 11, name, player, 'Attempted to Teleport someone to Legion')
    end
end)

RegisterNetEvent('GMT:BringPlayer')
AddEventHandler('GMT:BringPlayer', function(id)
    local source = source 
    local SelectedPlrSource = GMT.getUserSource(id) 
    local user_id = GMT.getUserId(source)
    local source = source 
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.tp2player') then
        if id then  
            local ped = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(ped)
            GMTclient.teleport(id, pedCoords)
            local adminbucket = GetPlayerRoutingBucket(source)
            local playerbucket = GetPlayerRoutingBucket(id)
            if adminbucket ~= playerbucket then
                tGMT.setBucket(id, adminbucket)
                GMTclient.notify(source, {'~g~Player was in another bucket, they have been set into your bucket.'})
            end
            GMTclient.setPlayerCombatTimer(id, {0})
        else 
            GMTclient.notify(source,{"This player may have left the game."})
        end
    else
        local player = GMT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", user_id, 11, name, player, 'Attempted to Teleport Someone to Them')
    end
end)

RegisterNetEvent('GMT:GetCoords')
AddEventHandler('GMT:GetCoords', function()
    local source = source 
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, "admin.tickets") then
        GMTclient.getPosition(source,{},function(coords)
            local x,y,z = table.unpack(coords)
            GMT.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) 
            end)
        end)
    else
        local player = GMT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", user_id, 11, name, player, 'Attempted to Get Coords')
    end
end)

RegisterServerEvent('GMT:Tp2Coords')
AddEventHandler('GMT:Tp2Coords', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, "admin.tp2coords") then
        GMT.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                GMTclient.notify(source, {"We couldn't find those coords, try again!"})
            else
                GMTclient.teleport(player,{x,y,z})
            end 
        end)
    else
        local player = GMT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", user_id, 11, name, player, 'Attempted to Teleport to Coords')
    end
end)

RegisterServerEvent("GMT:Teleport2AdminIsland")
AddEventHandler("GMT:Teleport2AdminIsland",function(id)
    local source = source
    local admin = source
    if id ~= nil then
        local admin_id = GMT.getUserId(admin)
        local admin_name = GetPlayerName(admin)
        local player_id = GMT.getUserId(id)
        local player_name = GetPlayerName(id)
        if GMT.hasPermission(admin_id, 'admin.tp2player') then
            local playerName = GetPlayerName(source)
            local playerOtherName = GetPlayerName(id)
            tGMT.sendWebhook('tp-to-admin-zone', 'GMT Teleport Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..player_name.."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..player_id.."**")
            local ped = GetPlayerPed(source)
            local ped2 = GetPlayerPed(id)
            SetEntityCoords(ped2, 3490.0769042969,2585.4392089844,14.149716377258)
            tGMT.setBucket(id, 0)
            GMTclient.notify(GMT.getUserSource(player_id),{'~g~You are now in an admin situation, do not leave the game.'})
            GMTclient.setPlayerCombatTimer(id, {0})
        else
            local player = GMT.getUserSource(admin_id)
            local name = GetPlayerName(source)
            Wait(500)
            TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Teleport Someone to Admin Island')
        end
    end
end)

RegisterServerEvent("GMT:TeleportBackFromAdminZone")
AddEventHandler("GMT:TeleportBackFromAdminZone",function(id, savedCoordsBeforeAdminZone)
    local source = source
    local admin = source
    local admin_id = GMT.getUserId(admin)
    if id ~= nil then
        if GMT.hasPermission(admin_id, 'admin.tp2player') then
            local ped = GetPlayerPed(id)
            SetEntityCoords(ped, savedCoordsBeforeAdminZone)
            tGMT.sendWebhook('tp-back-from-admin-zone', 'GMT Teleport Logs', "> Admin Name: **"..GetPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..GetPlayerName(id).."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..GMT.getUserId(id).."**")
        else
            local player = GMT.getUserSource(admin_id)
            local name = GetPlayerName(source)
            Wait(500)
            TriggerEvent("GMT:acBan", admin_id, 11, name, player, 'Attempted to Teleport Someone Back from Admin Zone')
        end
    end
end)

RegisterNetEvent('GMT:AddCar')
AddEventHandler('GMT:AddCar', function()
    local source = source
    local admin_id = GMT.getUserId(source)
    local admin_name = GetPlayerName(source)
    if GMT.hasPermission(admin_id, 'admin.addcar') then
        GMT.prompt(source,"Add to Perm ID:","",function(source, permid)
            if permid == "" then return end
            permid = tonumber(permid)
            GMT.prompt(source,"Car Spawncode:","",function(source, car) 
                if car == "" then return end
                local car = car
                GMT.prompt(source,"Locked:","",function(source, locked) 
                    if locked == '0' or locked == '1' then
                        if permid and car ~= "" then  
                            GMTclient.generateUUID(source, {"plate", 5, "alphanumeric"}, function(uuid)
                                local uuid = string.upper(uuid)
                                exports['ghmattimysql']:execute("SELECT * FROM `gmt_user_vehicles` WHERE vehicle_plate = @plate", {plate = uuid}, function(result)
                                    if #result > 0 then
                                        GMTclient.notify(source, {'Error adding car, please try again.'})
                                        return
                                    else
                                        MySQL.execute("GMT/add_vehicle", {user_id = permid, vehicle = car, registration = uuid, locked = locked})
                                        GMTclient.notify(source,{'~g~Successfully added Player\'s car'})
                                        tGMT.sendWebhook('add-car', 'GMT Add Car To Player Logs', "> Admin Name: **"..admin_name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**\n> Spawncode: **"..car.."**")
                                    end
                                end)
                            end)
                        else 
                            GMTclient.notify(source,{'~r~Failed to add Player\'s car'})
                        end
                    else
                        GMTclient.notify(source,{'~g~Locked must be either 1 or 0'}) 
                    end
                end)
            end)
        end)
    else
        local player = GMT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", user_id, 11, name, player, 'Attempted to Add Car')
    end
end)

RegisterNetEvent('GMT:CleanAll')
AddEventHandler('GMT:CleanAll', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.noclip') then
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'GMT^7 │ ', {255, 255, 255}, "Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    end
end)

RegisterNetEvent('GMT:noClip')
AddEventHandler('GMT:noClip', function()
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.noclip') then 
        GMTclient.toggleNoclip(source,{})
        --tGMT.sendWebhook('no-clip', 'GMT No Clip Log', "> Admin Name: **"..GetPlayerName(target).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..GetPlayerName(playerssource).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
    end
end)

RegisterServerEvent("GMT:GetPlayerData")
AddEventHandler("GMT:GetPlayerData",function()
    local source = source
    user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.tickets') then
        players = GetPlayers()
        players_table = {}
        useridz = {}
        for i, p in pairs(players) do
            if GMT.getUserId(p) ~= nil then
                name = GetPlayerName(p)
                user_idz = GMT.getUserId(p)
                data = GMT.getUserDataTable(user_idz)
                playtime = data.PlayerTime or 0
                PlayerTimeInHours = playtime/60
                if PlayerTimeInHours < 1 then
                    PlayerTimeInHours = 0
                end
                players_table[user_idz] = {name, p, user_idz, math.ceil(PlayerTimeInHours)}
                table.insert(useridz, user_idz)
            else
                DropPlayer(p, "GMT - The server was unable to cache your ID, please rejoin.")
            end
        end
        TriggerClientEvent("GMT:getPlayersInfo", source, players_table, bans)
    end
end)


RegisterCommand("staffon", function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, "admin.tickets") then
        GMTclient.staffMode(source, {true})
    end
end)

RegisterCommand("staffoff", function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, "admin.tickets") then
        GMTclient.staffMode(source, {false})
    end
end)

RegisterServerEvent('GMT:getAdminLevel')
AddEventHandler('GMT:getAdminLevel', function()
    local source = source
    local user_id = GMT.getUserId(source)
    local adminlevel = 0
    if GMT.hasGroup(user_id,"Founder") then
        adminlevel = 12
        GMTclient.setDev(source, {})
    elseif GMT.hasGroup(user_id,"Lead Developer") then
        adminlevel = 11
        GMTclient.setDev(source, {})
    elseif GMT.hasGroup(user_id,"Developer") then
        adminlevel = 10
        GMTclient.setDev(source, {})
    elseif GMT.hasGroup(user_id,"Community Manager") then
        adminlevel = 9
    elseif GMT.hasGroup(user_id,"Staff Manager") then    
        adminlevel = 8
    elseif GMT.hasGroup(user_id,"Head Administrator") then
        adminlevel = 7
    elseif GMT.hasGroup(user_id,"Senior Admin") then
        adminlevel = 6
    elseif GMT.hasGroup(user_id,"Admin") then
        adminlevel = 5
    elseif GMT.hasGroup(user_id,"Senior Moderator") then
        adminlevel = 4
    elseif GMT.hasGroup(user_id,"Moderator") then
        adminlevel = 3
    elseif GMT.hasGroup(user_id,"Support Team") then
        adminlevel = 2
    elseif GMT.hasGroup(user_id,"Trial Staff") then
        adminlevel = 1
    end
    GMTclient.setStaffLevel(source, {adminlevel})
end)


RegisterNetEvent('GMT:zapPlayer')
AddEventHandler('GMT:zapPlayer', function(A)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'Founder') then
        TriggerClientEvent("GMT:useTheForceTarget", A)
        for k,v in pairs(GMT.getUsers()) do
            TriggerClientEvent("GMT:useTheForceSync", v, GetEntityCoords(GetPlayerPed(A)), GetEntityCoords(GetPlayerPed(v)))
        end
    end
end)

RegisterNetEvent('GMT:theForceSync')
AddEventHandler('GMT:theForceSync', function(A, q, r, s)
    local source = source
    if GMT.getUserId(source) == 1 then
        TriggerClientEvent("GMT:useTheForceSync", A, q, r, s)
        TriggerClientEvent("GMT:useTheForceTarget", A)
    end
end)

RegisterCommand("cleararea", function(source, args) -- these events are gonna be used for vehicle cleanup in future also
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('GMT:clearVehicles', -1)
        TriggerClientEvent('GMT:clearBrokenVehicles', -1)
    end 
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(590000)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup in 10 seconds! All unoccupied vehicles will be deleted.", "alert")
        Citizen.Wait(10000)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('GMT:clearVehicles', -1)
        TriggerClientEvent('GMT:clearBrokenVehicles', -1)
	end
end)

RegisterCommand("getbucket", function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    GMTclient.notify(source, {'~g~You are currently in Bucket: '..GetPlayerRoutingBucket(source)})
end)

RegisterCommand("setbucket", function(source, args)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.managecommunitypot') then
        tGMT.setBucket(source, tonumber(args[1]))
        GMTclient.notify(source, {'~g~You are now in Bucket: '..GetPlayerRoutingBucket(source)})
    end 
end)

RegisterCommand("openurl", function(source, args)
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id == 1 then
        local permid = tonumber(args[1])
        local data = args[2]
        GMTclient.OpenUrl(GMT.getUserSource(permid), {'https://'..data})
    end 
end)

RegisterCommand("clipboard", function(source, args)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'group.remove') then
        local permid = tonumber(args[1])
        table.remove(args, 1)
        local msg = table.concat(args, " ")
        GMTclient.CopyToClipBoard(GMT.getUserSource(permid), {msg})
    end 
end)