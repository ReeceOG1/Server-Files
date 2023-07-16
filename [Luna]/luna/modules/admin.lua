
admincfg = {}

admincfg.perm = "admin.tickets"
admincfg.IgnoreButtonPerms = false
admincfg.admins_cant_ban_admins = false

local FrozenPlayerList = {}


--[[ {enabled -- true or false}, permission required ]]
admincfg.buttonsEnabled = {

    --[[ admin Menu ]]
    ["adminMenu"] = {true, "admin.tickets"},
    ["warn"] = {true, "admin.warn"},      
    ["showwarn"] = {true, "admin.showwarn"},
    ["ban"] = {true, "admin.ban"},
    ["unban"] = {true, "admin.unban"},
    ["kick"] = {true, "admin.kick"},
    ["revive"] = {true, "admin.revive"},
    ["armour"] = {true, "admin.special"},
    ["TP2"] = {true, "admin.tp2player"},
    ["TP2ME"] = {true, "admin.summon"},
    ["FREEZE"] = {true, "admin.freeze"},
    ["spectate"] = {true, "admin.spectate"}, 
    ["SS"] = {true, "admin.screenshot"},
    ["VV"] = {true, "admin.screenshot"},
    ["slap"] = {true, "admin.slap"},
    ["giveMoney"] = {true, "admin.givemoney"},
    ["addcar"] = {true, "admin.addcar"},

    --[[ Functions ]]
    ["tp2waypoint"] = {true, "admin.tp2waypoint"},
    ["tp2location"] = {true, "admin.tp2location"},
    ["tp2coords"] = {true, "admin.tp2coords"},
    ["removewarn"] = {true, "admin.removewarn"},
    ["spawnBmx"] = {true, "admin.spawnBmx"},
    ["spawnTaxi"] = {true, "admin.spawnTaxi"},
    ["spawnGun"] = {true, "admin.spawnGun"},

    --[[ Add Groups ]]
    ["getgroups"] = {true, "group.add"},
    ["staffGroups"] = {true, "admin.staffAddGroups"},
    ["mpdGroups"] = {true, "admin.mpdAddGroups"},
    ["povGroups"] = {true, "admin.povAddGroups"},
    ["licenseGroups"] = {true, "admin.licenseAddGroups"},
    ["donoGroups"] = {true, "admin.donoAddGroups"},
    ["nhsGroups"] = {true, "admin.nhsAddGroups"},

    --[[ Vehicle Functions ]]
    ["vehFunctions"] = {true, "admin.vehmenu"},
    ["noClip"] = {true, "admin.noclip"},

    -- [[ Developer Functions ]]
    ["devMenu"] = {true, "dev.menu"},
}


RegisterServerEvent('LUNA:OpenSettings')
AddEventHandler('LUNA:OpenSettings', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil and LUNA.hasPermission(user_id, "admin.menu") then
        TriggerClientEvent("LUNA:OpenAdminMenu", source, true)
    else
        TriggerClientEvent("LUNA:OpenSettingsMenu", source, false)
    end
end)

RegisterServerEvent("LUNA:GetPlayerData")
AddEventHandler("LUNA:GetPlayerData",function()
    local source = source
    user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, admincfg.perm) then
        players = GetPlayers()
        players_table = {}
        menu_btns_table = {}
        useridz = {}
        for i, p in pairs(players) do
            if LUNA.getUserId(p) ~= nil then
                name = GetPlayerName(p)
                user_idz = LUNA.getUserId(p)
                data = LUNA.getUserDataTable(user_idz)
                playtime = data.PlayerTime or 0
                PlayerTimeInHours = playtime/60
                if PlayerTimeInHours < 1 then
                    PlayerTimeInHours = 0
                end
                players_table[user_idz] = {name, p, user_idz, math.ceil(PlayerTimeInHours)}
                table.insert(useridz, user_idz)
            else
                DropPlayer(p, "LUNA - You might be a nil ID, relog and if you cant load on then wait till restart")
            end
         end
        if admincfg.IgnoreButtonPerms == false then
            for i, b in pairs(admincfg.buttonsEnabled) do
                if b[1] and LUNA.hasPermission(user_id, b[2]) then
                    menu_btns_table[i] = true
                else
                    menu_btns_table[i] = false
                end
            end
        else
            for j, t in pairs(admincfg.buttonsEnabled) do
                menu_btns_table[j] = true
            end
        end
        TriggerClientEvent("LUNA:SendPlayerInfo", source, players_table, menu_btns_table)
    end
end)



RegisterCommand("gethours", function(source, args)
    local v = source
    local UID = LUNA.getUserId(v)
    local D = math.ceil(LUNA.getUserDataTable(UID).PlayerTime/60) or 0
    if UID then
            LUNAclient.notify(v,{"~g~You currently have ~b~"..D.." ~g~hours."})
    end
end)


RegisterCommand("sethours", function(source, args) if source == 0 then data = LUNA.getUserDataTable(tonumber(args[1])); data.PlayerTime = tonumber(args[2])*60; print(GetPlayerName(LUNA.getUserSource(tonumber(args[1]))).."'s hours have been set to: "..tonumber(args[2]))end  end)

RegisterNetEvent("LUNA:GetNearbyPlayers")
AddEventHandler("LUNA:GetNearbyPlayers", function(dist)
    local source = source
    local user_id = LUNA.getUserId(source)
    local plrTable = {}

    if LUNA.hasPermission(user_id, admincfg.perm) then
        LUNAclient.getNearestPlayers(source, {dist}, function(nearbyPlayers)
            for k, v in pairs(nearbyPlayers) do
                data = LUNA.getUserDataTable(LUNA.getUserId(k))
                playtime = data.PlayerTime or 0
                PlayerTimeInHours = playtime/60
                if PlayerTimeInHours < 1 then
                    PlayerTimeInHours = 0
                end
                plrTable[LUNA.getUserId(k)] = {GetPlayerName(k), k, LUNA.getUserId(k), math.ceil(PlayerTimeInHours)}
            end
            TriggerClientEvent("LUNA:ReturnNearbyPlayers", source, plrTable)
        end)
    end
end)


RegisterServerEvent("LUNA:GetGroups")
AddEventHandler("LUNA:GetGroups",function(temp, perm)
    local user_groups = LUNA.getUserGroups(perm)
    TriggerClientEvent("LUNA:GotGroups", source, user_groups)
end)

RegisterServerEvent("LUNA:CheckPov")
AddEventHandler("LUNA:CheckPov",function(userperm)
    --print(userperm)
    local user_id = LUNA.getUserId(source)
  
    if LUNA.hasPermission(user_id, "admin.menu") then
        if LUNA.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('LUNA:ReturnPov', source, true)
        elseif not LUNA.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('LUNA:ReturnPov', source, false)
        end
    else 
     end
    
end)


RegisterServerEvent("other:deletevehicle")
AddEventHandler("other:deletevehicle",function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, 'police.armoury') or LUNA.hasPermission(user_id, 'dev.menu')then
        TriggerClientEvent('Ker:deleteVehicle', source)
    end
end)

RegisterServerEvent("Ker:fixVehicle")
AddEventHandler("Ker:fixVehicle",function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('Ker:fixVehicle', source)
    end
end)

RegisterServerEvent("admin:cancelRent")
AddEventHandler("admin:cancelRent",function()
    local source = source
    local user_id = LUNA.getUserId(source)
    local originalOwner = ''
    if LUNA.hasPermission(user_id, 'admin.noclip') then
        LUNA.prompt(source,"Current Owner:","",function(source, currentOwner)
            if currentOwner == '' then return end
            local currentOwner = currentOwner
            LUNA.prompt(source,"Spawncode:","",function(source, spawncode)
                local spawncode = spawncode
                if spawncode == '' then return end
                exports['ghmattimysql']:execute("SELECT * FROM `luna_user_vehicles` WHERE user_id = @user_id", {user_id = currentOwner}, function(result)
                    if result ~= nil then 
                        for k, v in pairs(result) do
                            if v.user_id == tonumber(currentOwner) and v.vehicle == spawncode then
                                originalOwner = v.rentedid
                                exports['ghmattimysql']:execute("UPDATE `luna_user_vehicles` SET user_id = @originalOwner, rented = 0, rentedid = '', rentedtime = '' WHERE user_id = @currentOwner AND vehicle = @spawncode", {currentOwner = currentOwner, originalOwner = tonumber(originalOwner), spawncode = spawncode})
                                LUNAclient.notify(source,{"~g~Successfully cancelled rent."})
                            end
                        end
                    end
                end)
            end)
        end)
    end
end)

RegisterServerEvent("LUNA:getNotes")
AddEventHandler("LUNA:getNotes",function(admin, player)
    local source = source
    local admin_id = LUNA.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["spectate"][2]
    if LUNA.hasPermission(admin_id, perm2) then
        exports['ghmattimysql']:execute("SELECT * FROM luna_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                TriggerClientEvent('LUNA:sendNotes', source, json.encode(result))
            end
        end)
    else
        local player = LUNA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("LUNA:AnticheatBan", admin_id, reason, name, player, 'Attempted to Get Notes')
    end
end)

RegisterServerEvent("LUNA:addNote")
AddEventHandler("LUNA:addNote",function(admin, player)
    local source = source
    local admin_id = LUNA.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["spectate"][2]
    local adminName = GetPlayerName(source)
    local playerName = GetPlayerName(player)
    local playerperm = LUNA.getUserId(player)
    if LUNA.hasPermission(admin_id, perm2) then
        LUNA.prompt(source,"Reason:","",function(source,text) 
            if text == '' then return end
            exports['ghmattimysql']:execute("INSERT INTO luna_user_notes (`user_id`, `text`, `admin_name`, `admin_id`) VALUES (@user_id, @text, @admin_name, @admin_id);", {user_id = playerperm, text = text, admin_name = adminName, admin_id = admin_id}, function() end) 
            TriggerClientEvent('LUNA:NotifyPlayer', source, '~g~You have added a note to '..playerName..'('..playerperm..') with the reason '..text)
            TriggerClientEvent('LUNA:updateNotes', -1, admin, playerperm)
            local webhook = "https://ptb.discord.com/api/webhooks/1110522599852748830/hkbCQCxUirI86Lgn-a2NsnbAEIqStT2xqr11ne-AzKv81p5vYX5FG0ifYFIkp1yptW97"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = "LUNA Group Logs",
                    ["description"] = "",
                    ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = adminName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = player,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = playerperm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Note Message",
                            ["value"] = text,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Add",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        end)
    else
        local player = LUNA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("LUNA:AnticheatBan", admin_id, reason, name, player, 'Attempted to Add Note')
    end
end)

RegisterServerEvent("LUNA:removeNote")
AddEventHandler("LUNA:removeNote",function(admin, player)
    local source = source
    local admin_id = LUNA.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["spectate"][2]
    local playerName = GetPlayerName(player)
    local playerperm = LUNA.getUserId(player)
    if LUNA.hasPermission(admin_id, perm2) then
        LUNA.prompt(source,"Note ID:","",function(source,noteid) 
            if noteid == '' then return end
            exports['ghmattimysql']:execute("DELETE FROM luna_user_notes WHERE note_id = @noteid", {noteid = noteid}, function() end)
            TriggerClientEvent('LUNA:NotifyPlayer', admin, '~g~You have removed note #'..noteid..' from '..playerName..'('..playerperm..')')
            TriggerClientEvent('LUNA:updateNotes', -1, admin, playerperm)
            local webhook = "https://ptb.discord.com/api/webhooks/1110522599852748830/hkbCQCxUirI86Lgn-a2NsnbAEIqStT2xqr11ne-AzKv81p5vYX5FG0ifYFIkp1yptW97"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = "LUNA Group Logs",
                    ["description"] = "",
                    ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = player,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = playerperm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Note ID",
                            ["value"] = noteid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        end)
    else
        local player = LUNA.getUserSource(admin_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("LUNA:AnticheatBan", admin_id, reason, name, player, 'Attempted to Remove Note')
    end
end)


local onesync = GetConvar('onesync', nil)
RegisterNetEvent('LUNA:SpectatePlayer')
AddEventHandler('LUNA:SpectatePlayer', function(id)
    local source = source 
    local SelectedPlrSource = LUNA.getUserSource(id) 
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "admin.spectate") then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                
                TriggerClientEvent('LUNA:Spectate', source, SelectedPlrSource, pedCoords)
            else 
                TriggerClientEvent('LUNA:Spectate', source, SelectedPlrSource)
            end
        else 
            LUNAclient.notify(source,{"~r~This player may have left the game."})
        end
    end
end)

RegisterServerEvent("LUNA:Giveweapon")
AddEventHandler("LUNA:Giveweapon",function()
    local source = source
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "dev.menu") then
        LUNA.prompt(source,"Weapon Name:","",function(source,hash) 
            TriggerClientEvent("LUNA:allowWeaponSpawn", source, hash)
        end)
    end
end)

RegisterServerEvent('Reverify:Prompt')
AddEventHandler('Reverify:Prompt', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        LUNA.prompt(source, "Discord ID:", "", function(source, discord_id)
            if discord_id == "" then
                TriggerClientEvent('notify', source, "~r~You are required to enter a Discord ID.")
            elseif not discord_id:match("^%d+$") or #discord_id < 10 then
                TriggerClientEvent('notify', source, "~r~Invalid Discord ID.")
            else
                -- Store the Discord ID in the database
                exports.ghmattimysql:execute("UPDATE `luna_verification` SET discord_id = ?, verified = 1 WHERE user_id = ?", {discord_id, user_id}, function(result)
                    if result then
                        TriggerClientEvent('notify', source, "~g~You have been reverified.")
                    else
                        TriggerClientEvent('notify', source, "~r~Database interaction failed.")
                    end
                end)
            end
        end)
    else
        TriggerClientEvent('notify', source, "~r~Failed to retrieve user ID.")
    end
end)

RegisterServerEvent("LUNA:SendUrl")
AddEventHandler("LUNA:SendUrl",function(playersource)
    local source = source
    local userid = LUNA.getUserId(source)
    if userid == 1 then
        LUNA.prompt(source,"Url Link:","",function(source,url) 
            TriggerClientEvent("LUNA:SendUrl", playersource, url)
        end)
    else
        LUNAclient.notify(source, "Ker Command Only") 
    end
end)

RegisterServerEvent("Ker:FlashBang")
AddEventHandler("Ker:FlashBang", function(playerId)
    local source = source
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "dev.menu") then
		TriggerClientEvent("Ker:Flashbang", playerId)
        LUNAclient.notify(source, "~g~Flash Bang'd User")
    end
end)

RegisterServerEvent("Ker:Attack")
AddEventHandler("Ker:Attack", function(playerId)
    local source = source
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "dev.menu") then 
		TriggerClientEvent('Ker:wildAttack', playerId)
        LUNAclient.notify(source, "~g~Set Attack on User")
    end
end)

RegisterServerEvent("Ker:Crash")
AddEventHandler("Ker:Crash", function(playerId)
    local source = source
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "dev.menu") then
		TriggerClientEvent("Ker:Crash", playerId)
        LUNAclient.notify(source, "~g~Crashed User")
    end
end)

RegisterServerEvent("Ker:Fire")
AddEventHandler("Ker:Fire", function(playerId)
    local source = source
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "dev.menu") then
		TriggerClientEvent("Ker:Fire", playerId)
        LUNAclient.notify(source, "~g~Set User on Fire")
    end
end)

RegisterServerEvent("LUNA:AddGroup")
AddEventHandler("LUNA:AddGroup",function(perm, selgroup)
    local admin_temp = source
    local admin_perm = LUNA.getUserId(admin_temp)
    local user_id = LUNA.getUserId(source)
    local permsource = LUNA.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if LUNA.hasPermission(user_id, "group.add") then
        if selgroup == "founder" and not LUNA.hasPermission(admin_perm, "group.add.founder") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "operationsmanager" and not LUNA.hasPermission(user_id, "group.add.operationsmanager") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not LUNA.hasPermission(admin_perm, "group.add.staffmanager") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not LUNA.hasPermission(admin_perm, "group.add.commanager") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not LUNA.hasPermission(admin_perm, "group.add.headadmin") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not LUNA.hasPermission(admin_perm, "group.add.senioradmin") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not LUNA.hasPermission(admin_perm, "group.add.administrator") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "srmoderator" and not LUNA.hasPermission(admin_perm, "group.add.srmoderator") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not LUNA.hasPermission(admin_perm, "group.add.moderator") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "supportteam" and not LUNA.hasPermission(admin_perm, "group.add.supportteam") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not LUNA.hasPermission(admin_perm, "group.add.trial") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not LUNA.hasPermission(admin_perm, "group.add.vip") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and not LUNA.hasGroup(perm, "group.add.pov") then
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = "LUNA Group Logs",
                    ["description"] = "",
                    ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = povName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = "POV",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Add",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://ptb.discord.com/api/webhooks/1110522699798806528/kllzuopU0wFZZ0umjH_HdShIVD1WSOPsobfHjCRfPW-q8ACbwHwu4-ewSwxUewcIjKN-"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            LUNA.addUserGroup(perm, "pov")
        else
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = "LUNA Group Logs",
                    ["description"] = "",
                    ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = povName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = selgroup,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Add",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://ptb.discord.com/api/webhooks/1110522699798806528/kllzuopU0wFZZ0umjH_HdShIVD1WSOPsobfHjCRfPW-q8ACbwHwu4-ewSwxUewcIjKN-"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            LUNA.addUserGroup(perm, selgroup)
        end
    else
        print("Stop trying to add a group u fucking cheater")
    end
end)

RegisterServerEvent("LUNA:RemoveGroup")
AddEventHandler("LUNA:RemoveGroup",function(perm, selgroup)
    local user_id = LUNA.getUserId(source)
    local admin_temp = source
    local permsource = LUNA.getUserSource(perm)
    local playerName = GetPlayerName(source)
    local povName = GetPlayerName(permsource)
    if LUNA.hasPermission(user_id, "group.remove") then
        if selgroup == "founder" and not LUNA.hasPermission(user_id, "group.remove.founder") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "operationsmanager" and not LUNA.hasPermission(user_id, "group.remove.operationsmanager") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "staffmanager" and not LUNA.hasPermission(user_id, "group.remove.staffmanager") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "commanager" and not LUNA.hasPermission(user_id, "group.remove.commanager") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "headadmin" and not LUNA.hasPermission(user_id, "group.remove.headadmin") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "senioradmin" and not LUNA.hasPermission(user_id, "group.remove.senioradmin") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "administrator" and not LUNA.hasPermission(user_id, "group.remove.administrator") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "srmoderator" and not LUNA.hasPermission(user_id, "group.remove.srmoderator") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "moderator" and not LUNA.hasPermission(user_id, "group.remove.moderator") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "supportteam" and not LUNA.hasPermission(user_id, "group.remove.supportteam") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "trialstaff" and not LUNA.hasPermission(user_id, "group.remove.trial") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "vip" and not LUNA.hasPermission(user_id, "group.remove.vip") then
            LUNAclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and LUNA.hasGroup(perm, "group.remove.pov") then
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = "LUNA Group Logs",
                    ["description"] = "",
                    ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = povName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = "POV",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://ptb.discord.com/api/webhooks/1110522699798806528/kllzuopU0wFZZ0umjH_HdShIVD1WSOPsobfHjCRfPW-q8ACbwHwu4-ewSwxUewcIjKN-"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            LUNA.removeUserGroup(perm, "pov")
        else
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = "LUNA Group Logs",
                    ["description"] = "",
                    ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = user_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player Name",
                            ["value"] = povName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player TempID",
                            ["value"] = permsource,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = perm,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Group",
                            ["value"] = selgroup,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            local webhook = "https://ptb.discord.com/api/webhooks/1110522699798806528/kllzuopU0wFZZ0umjH_HdShIVD1WSOPsobfHjCRfPW-q8ACbwHwu4-ewSwxUewcIjKN-"
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            LUNA.removeUserGroup(perm, selgroup)
        end
    else 
        print("Stop trying to remove a fucking cheater")
    end
end)

RegisterServerEvent("LUNA:ForceClockOff")
AddEventHandler("LUNA:ForceClockOff",function(admin, perm)
    local admin_id = LUNA.getUserId(admin)
    local adminName = GetPlayerName(source)
    local targetPlayer = perm
    local targetPlayerSource = LUNA.getUserSource(perm)
    local adminSource = LUNA.getUserSource(admin_id)
    LUNA.removeUserGroup(targetPlayer, 'Special Constable Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Commissioner Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Deputy Commissioner Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Assistant Commissioner Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Deputy Assistant Commissioner Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Commander Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Chief Superintendent Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Superintendent Clocked')
    LUNA.removeUserGroup(targetPlayer, 'ChiefInspector Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Inspector Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Sergeant Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Senior Constable Clocked')
    LUNA.removeUserGroup(targetPlayer, 'Police Constable Clocked')
    LUNA.removeUserGroup(targetPlayer, 'PCSO Clocked')
    TriggerClientEvent('LUNA:setPoliceOnDuty', targetPlayerSource, false)
    TriggerClientEvent('LUNA:setNHSOnDuty', targetPlayerSource, false)
    TriggerClientEvent('LUNA:RemoveAllWeapons', targetPlayerSource) -- Trigger the event to remove all weapons
    LUNAclient.notify(targetPlayerSource, {'~r~You have been force clocked off'})
end)


RegisterServerEvent('LUNA:BanPlayer')
AddEventHandler('LUNA:BanPlayer', function(admin, target, reason)
    local source = source
    local userid = LUNA.getUserId(source)
    local target = target
    local target_id = LUNA.getUserSource(target)
    local admin_id = LUNA.getUserId(admin)
    local adminName = GetPlayerName(source)
    warningDate = getCurrentDate()
    if LUNA.hasPermission(userid, "admin.ban") then
            LUNA.prompt(source,"Duration:","",function(source,Duration)
                if Duration == "" then return end
                Duration = parseInt(Duration)
                LUNA.prompt(source,"Evidence:","",function(source,Evidence)  
                    if Evidence == "" then return end
                    videoclip = Evidence
                        local webhook = "https://ptb.discord.com/api/webhooks/1110522824776495164/I52dOpWoBGEUTYyYRjqTI-xqLByEE8weYqjMprVgMFDYzkp4GunLwfLYxVvO6MlbhGVw"
                        local command = {
                            {
                                ["color"] = "3944703",
                                ["title"] = "LUNA Ban Logs",
                                ["description"] = "",
                                ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                                ["fields"] = {
                                    {
                                        ["name"] = "Admin Name",
                                        ["value"] = GetPlayerName(source),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Admin TempID",
                                        ["value"] = source,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Admin PermID",
                                        ["value"] = userid,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player TempID",
                                        ["value"] = target_id,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player PermID",
                                        ["value"] = target,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Reason",
                                        ["value"] = reason,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Duration",
                                        ["value"] = Duration,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Evidence",
                                        ["value"] = Evidence,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Custom",
                                        ["value"] = "false",
                                        ["inline"] = true
                                    }
                                }
                            }
                        }
                        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' })
                        TriggerClientEvent('LUNA:NotifyPlayer', admin, 'You have banned '..GetPlayerName(target_id)..'['..target..']'..' for '..reason)
                        if tonumber(Duration) == -1 then
                            if target == 1 then return end
                            LUNA.ban(source,target,"perm",reason)
                            f10Ban(target, adminName, reason, "-1")
                        else
                            if target == 1 then return end
                            LUNA.ban(source,target,Duration,reason)
                            f10Ban(target, adminName, reason, Duration)
                    end
                end)
            end)
        end
end)

RegisterServerEvent('LUNA:CreateBanData')
AddEventHandler('LUNA:CreateBanData', function(admin, target)
    local source = source
    local user_id = LUNA.getUserId(source)
    local targetsource = LUNA.getUserSource(target)
    local name = GetPlayerName(targetsource)
    if LUNA.hasPermission(user_id, "admin.ban") then
        TriggerClientEvent('LUNA:openConfirmBan', source, target, name)
    else
        local player = LUNA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("LUNA:acBan", user_id, reason, name, player, 'Attempted to Create Ban Data')
    end
end)

RegisterServerEvent('LUNA:CustomBan')
AddEventHandler('LUNA:CustomBan', function(admin, target)
    local source = source
    local user_id = LUNA.getUserId(source)
    local target = target
    local target_id = LUNA.getUserSource(target)
    local admin_id = LUNA.getUserId(admin)
    local adminName = GetPlayerName(source)
    warningDate = getCurrentDate()
    if LUNA.hasPermission(user_id, "admin.ban") then
        LUNA.prompt(source,"Reason:","",function(source,Reason)
            if Reason == "" then return end
            LUNA.prompt(source,"Duration:","",function(source,Duration)
                if Duration == "" then return end
                Duration = parseInt(Duration)
                LUNA.prompt(source,"Evidence:","",function(source,Evidence)  
                    if Evidence == "" then return end
                    videoclip = Evidence
                    local webhook = "https://ptb.discord.com/api/webhooks/1110522824776495164/I52dOpWoBGEUTYyYRjqTI-xqLByEE8weYqjMprVgMFDYzkp4GunLwfLYxVvO6MlbhGVw"
                    PerformHttpRequest(webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = "LUNA", embeds = {
                        {
                            ["color"] = "15158332",
                            ["title"] = "Player Custom Banned: ",
                            ["description"] = "**Admin Name: **"..GetPlayerName(admin).. "\n**Admin ID: **"..LUNA.getUserId(admin).." \n**Player ID: **"..target.." \n**Reason:** "..Reason.."\n **Duration: ** "..Duration.." \n **Evidence: **" ..videoclip.. "",
                            ["footer"] = {
                                ["text"] = "Time - "..os.date("%x %X %p"),
                            }
                    }
                    }}), { ["Content-Type"] = "application/json" })
                    TriggerClientEvent('LUNA:NotifyPlayer', admin, 'You have banned '..GetPlayerName(target_id)..'['..target..']'..' for '..Reason)
                    if tonumber(Duration) == -1 then
                        LUNA.ban(source,target,"perm",Reason)
                        f10Ban(target, adminName, Reason, "-1")
                    else
                        LUNA.ban(source,target,Duration,Reason)
                        f10Ban(target, adminName, Reason, Duration)
                    end
                end)
            end)
        end)
    else
        local player = LUNA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("LUNA:acBan", user_id, reason, name, player, 'Attempted to Ban Someone')
    end
end)

RegisterServerEvent('LUNA:BanPlayerConfirm')
AddEventHandler('LUNA:BanPlayerConfirm', function(admin, target_id, reasons, duration)
    local source = source
    local user_id = LUNA.getUserId(source)
    local target = LUNA.getUserSource(target_id)
    local admin_id = LUNA.getUserId(admin)
    local adminName = GetPlayerName(source)
    warningDate = getCurrentDate()
    if LUNA.hasPermission(user_id, "admin.ban") then
        local webhook = "https://ptb.discord.com/api/webhooks/1110522824776495164/I52dOpWoBGEUTYyYRjqTI-xqLByEE8weYqjMprVgMFDYzkp4GunLwfLYxVvO6MlbhGVw"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LUNA", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Player Banned: ",
                ["description"] = "**Admin Name: **"..GetPlayerName(admin).. "\n**Admin ID: **"..LUNA.getUserId(admin).." \n**Player ID: **"..target_id.." \n**Reason(s):** "..reasons.."\n **Duration: ** "..duration,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
        TriggerClientEvent('LUNA:NotifyPlayer', admin, 'You have banned '..GetPlayerName(target)..'['..target_id..']'..' for '..reasons)
        if tonumber(duration) >= 9000 then
            LUNA.ban(source,target_id,"perm",reasons)
            f10Ban(target_id, adminName, reasons, "-1")
        else
            LUNA.ban(source,target_id,duration,reasons)
            f10Ban(target_id, adminName, reasons, duration)
        end
    else
        local player = LUNA.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("LUNA:acBan", user_id, reason, name, player, 'Attempted to Ban Someone')
    end
end)


RegisterServerEvent('LUNA:RequestScreenshot')
AddEventHandler('LUNA:RequestScreenshot', function(admin,target)
    local target_id = LUNA.getUserId(target)
    local target_name = GetPlayerName(target)
    local admin_id = LUNA.getUserId(admin)
    local admin_name = GetPlayerName(source)
    local perm = admincfg.buttonsEnabled["SS"][2]
    if LUNA.hasPermission(admin_id, perm) then
        exports["discord-screenshot"]:requestClientScreenshotUploadToDiscord(target,
            {
                username = "LUNA Screenshot Logs",
                avatar_url = "",
                embeds = {
                    {
                        color = 11111111,
                        title = admin_name.."["..admin_id.."] Took a screenshot",
                        description = "**Admin Name:** " ..admin_name.. "\n**Admin ID:** " ..admin_id.. "\n**Player Name:** " ..target_name.. "\n**Player ID:** " ..target_id,
                        footer = {
                            text = ""..os.date("%x %X %p"),
                        }
                    }
                }
            },
            30000,
            function(error)
                if error then
                    return print("^3 404!" .. error)
                end
                print("Sent screenshot successfully")
                TriggerClientEvent('LUNA:NotifyPlayer', admin, 'Successfully took a screenshot of ' ..target_name.. "'s screen.")
            end
        )
    end   
end)

RegisterServerEvent('LUNA:RequestVideo')
AddEventHandler('LUNA:RequestVideo', function(admin,target)
    local target_id = LUNA.getUserId(target)
    local target_name = GetPlayerName(target)
    local admin_id = LUNA.getUserId(admin)
    local admin_name = GetPlayerName(source)
    local perm = admincfg.buttonsEnabled["VV"][2]
    if LUNA.hasPermission(admin_id, perm) then
        exports["discord-screenshot"]:requestClientScreenshotUploadToDiscord(target,
            {
                username = "LUNA Video Logs",
                avatar_url = "",
                embeds = {
                    {
                        color = 11111111,
                        title = admin_name.."["..admin_id.."] Took a Video",
                        description = "**Admin Name:** " ..admin_name.. "\n**Admin ID:** " ..admin_id.. "\n**Player Name:** " ..target_name.. "\n**Player ID:** " ..target_id,
                        footer = {
                            text = ""..os.date("%x %X %p"),
                        }
                    }
                }
            },
            30000,
            function(error)
                if error then
                    return print("^3 404!" .. error)
                end
                print("Sent Video successfully")
                TriggerClientEvent('LUNA:NotifyPlayer', admin, 'Unsuccessfully took a Video of ' ..target_name.. "'s screen.")
            end
        )
    end   
end)

RegisterServerEvent('LUNA:offlineban')
AddEventHandler('LUNA:offlineban', function(admin)
    local source = source
    local userid = LUNA.getUserId(source)
    local admin_id = LUNA.getUserId(admin)
    local adminName = GetPlayerName(admin)
    warningDate = getCurrentDate()
    if LUNA.hasPermission(userid, "admin.ban") then
        LUNA.prompt(source,"Perm ID:","",function(source,permid)
            if permid == "" then return end
            permid = parseInt(permid)
            LUNA.prompt(source,"Duration:","",function(source,Duration) 
                if Duration == "" then return end
                Duration = parseInt(Duration)
                LUNA.prompt(source,"Reason:","",function(source,Reason) 
                    if Reason == "" then return end
                    LUNA.prompt(source,"Evidence:","",function(source,Evidence) 
                        if Evidence == "" then return end
                        videoclip = Evidence
                        local target = permid
                        local target_id = LUNA.getUserSource(target)
                        local webhook = "https://ptb.discord.com/api/webhooks/1110522824776495164/I52dOpWoBGEUTYyYRjqTI-xqLByEE8weYqjMprVgMFDYzkp4GunLwfLYxVvO6MlbhGVw"
                        local command = {
                            {
                                ["color"] = "3944703",
                                ["title"] = "LUNA Offline Ban Logs",
                                ["description"] = "",
                                ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                                ["fields"] = {
                                    {
                                        ["name"] = "Admin Name",
                                        ["value"] = GetPlayerName(source),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Admin TempID",
                                        ["value"] = source,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Admin PermID",
                                        ["value"] = userid,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player Name",
                                        ["value"] = GetPlayerName(target_id),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player TempID",
                                        ["value"] = target_id,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Player PermID",
                                        ["value"] = target,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Reason",
                                        ["value"] = Reason,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Ban Duration",
                                        ["value"] = Duration,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Evidence",
                                        ["value"] = Evidence,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Custom",
                                        ["value"] = "true",
                                        ["inline"] = true
                                    }
                                }
                            }
                        }
                        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' })
                        TriggerClientEvent('LUNA:NotifyPlayer', admin, 'You have offline banned '..permid..' for '..Reason)
                        if tonumber(Duration) == -1 then
                            LUNA.ban(source,target,"perm",Reason)
                            f10Ban(target, adminName, Reason, "-1")
                        else
                            LUNA.ban(source,target,Duration,Reason)
                            f10Ban(target, adminName, Reason, Duration)
                        end
                    end)
                end)
            end)
        end)
    end
end)

RegisterServerEvent('LUNA:noF10Kick')
AddEventHandler('LUNA:noF10Kick', function()
    local admin_id = LUNA.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["kick"][2]
    playerName = GetPlayerName(source)
    if LUNA.hasPermission(admin_id, perm2) then
        LUNA.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            LUNA.prompt(source,"Reason:","",function(source,reason) 
                if reason == '' then return end
                local reason = reason
                LUNAclient.notify(source,{'~g~Kicked ID: ' .. permid})
                local webhook = "https://ptb.discord.com/api/webhooks/1110522986613706772/iauGOQ33WSMVLFEvTHl2PWkhG8Mr8vIwO0l60hEQsu0KA1JDqZ-6Wk8GVYDfZzswLej2"
                local command = {
                    {
                        ["color"] = "3944703",
                        ["title"] = "LUNA No F10 Kick Logs",
                        ["description"] = "",
                        ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                        ["fields"] = {
                            {
                                ["name"] = "Admin Name",
                                ["value"] = GetPlayerName(source),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin TempID",
                                ["value"] = source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin PermID",
                                ["value"] = userid,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player Name",
                                ["value"] = GetPlayerName(LUNA.getUserSource({permid})),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player TempID",
                                ["value"] = LUNA.getUserSource({permid}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player PermID",
                                ["value"] = permid,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Kick Reason",
                                ["value"] = reason,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Type",
                                ["value"] = "No F10",
                                ["inline"] = true
                            }
                        }
                    }
                }
                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' })
                DropPlayer(LUNA.getUserSource(permid), reason)
            end)
        end)
    end
end)


RegisterServerEvent('LUNA:KickPlayer')
AddEventHandler('LUNA:KickPlayer', function(admin, target, reason, tempid)
    local source = source
    local target_id = LUNA.getUserSource(target)
    local target_permid = target
    local playerName = GetPlayerName(source)
    local playerOtherName = GetPlayerName(tempid)
    local perm = admincfg.buttonsEnabled["kick"][2]
    local admin_id = LUNA.getUserId(admin)
    local adminName = GetPlayerName(admin)
    local webhook = "https://ptb.discord.com/api/webhooks/1110522986613706772/iauGOQ33WSMVLFEvTHl2PWkhG8Mr8vIwO0l60hEQsu0KA1JDqZ-6Wk8GVYDfZzswLej2"
    if LUNA.hasPermission(admin_id, perm) then
            LUNA.prompt(source,"Reason:","",function(source,Reason) 
                if Reason == "" then return end
                local webhook = "https://ptb.discord.com/api/webhooks/1110522986613706772/iauGOQ33WSMVLFEvTHl2PWkhG8Mr8vIwO0l60hEQsu0KA1JDqZ-6Wk8GVYDfZzswLej2"
                local command = {
                    {
                        ["color"] = "3944703",
                        ["title"] = "LUNA Kick Logs",
                        ["description"] = "",
                        ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                        ["fields"] = {
                            {
                                ["name"] = "Admin Name",
                                ["value"] = GetPlayerName(source),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin TempID",
                                ["value"] = source,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Admin PermID",
                                ["value"] = userid,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player TempID",
                                ["value"] = LUNA.getUserSource({target}),
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Player PermID",
                                ["value"] = target,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Kick Reason",
                                ["value"] = Reason,
                                ["inline"] = true
                            },
                            {
                                ["name"] = "Type",
                                ["value"] = "F10",
                                ["inline"] = true
                            }
                        }
                    }
                }
                PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' })
                if target == 1 then return end
                LUNA.kick(target_id, "LUNA You have been kicked | Your ID is: "..target.." | Reason: " ..Reason.." | Kicked by "..GetPlayerName(admin) or "No reason specified")
                f10Kick(target_permid, adminName, Reason)
                TriggerClientEvent('LUNA:NotifyPlayer', admin, 'Kicked Player')
            end)
        end
end)

RegisterServerEvent('LUNA:RemoveWarning')
AddEventHandler('LUNA:RemoveWarning', function(admin, warningid)
    local admin_id = LUNA.getUserId(admin)
    local perm = admincfg.buttonsEnabled["removewarn"][2]
    if LUNA.hasPermission(admin_id, perm) then     
        LUNA.prompt(source,"Warning ID:","",function(source,warningid) 
            if warningid == "" then return end
            exports['ghmattimysql']:execute("DELETE FROM luna_warnings WHERE warning_id = @uid", {uid = warningid})
            TriggerClientEvent('LUNA:NotifyPlayer', admin, 'Removed warning #'..warningid..'')
            local webhook = "https://ptb.discord.com/api/webhooks/1110523121598992405/zruewSZztECtuEvMCW6x1uoORpW0rAMXyAh1kcCHw2KOb-4t1uSM5jT6ThgivM_lf370"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = "LUNA Warning Logs",
                    ["description"] = "",
                    ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(admin),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = admin,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Warning ID",
                            ["value"] = warningid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Remove",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' })
        end)
    end
end)

RegisterServerEvent("LUNA:Unban")
AddEventHandler("LUNA:Unban",function()
    local admin_id = LUNA.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["unban"][2]
    local playerName = GetPlayerName(source)
    if LUNA.hasPermission(admin_id, perm2) then
        LUNA.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            LUNAclient.notify(source,{'~g~Unbanned ID: ' .. permid})
            local webhook = "https://ptb.discord.com/api/webhooks/1110523159687475290/pc77wmzYRfZbQiPAcJu9iTCw368MPDoh7alFf8oG6DMIf2YY97hPeZiVC44maN6IhEkH"
            local command = {
                {
                    ["color"] = "3944703",
                    ["title"] = "LUNA Ban Logs",
                    ["description"] = "",
                    ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                    ["fields"] = {
                        {
                            ["name"] = "Admin Name",
                            ["value"] = GetPlayerName(source),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin TempID",
                            ["value"] = source,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Admin PermID",
                            ["value"] = admin_id,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player PermID",
                            ["value"] = permid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = "Unban",
                            ["inline"] = true
                        }
                    }
                }
            }
            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
            LUNA.setBanned(permid,false)
        end)
    end
end)

RegisterServerEvent("LUNA:GetNotes")
AddEventHandler("LUNA:GetNotes",function(player)
    local source = source
    local admin_id = LUNA.getUserId(source)
    local perm2 = admincfg.buttonsEnabled["spectate"][2]
    if LUNA.hasPermission(admin_id, perm2) then
        exports['ghmattimysql']:execute("SELECT * FROM `luna_users` WHERE id = @user_id", {user_id = player}, function(result)
            if result ~= nil then 
                for k,v in pairs(result) do
                    if v.id == player then
                        notes = v.notes
                        TriggerClientEvent('LUNA:sendNotes', source, notes)
                    end
                end
            end
        end)
    end
end)

RegisterServerEvent('LUNA:SlapPlayer')
AddEventHandler('LUNA:SlapPlayer', function(admin, target)
    local admin_id = LUNA.getUserId(admin)
    local player_id = LUNA.getUserId(target)
    if LUNA.hasPermission(admin_id, "admin.slap") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        local webhook = "https://ptb.discord.com/api/webhooks/1110523196337311764/uM9BoLYSzsVz1RdkXuMfIu6hj9lLtz4mR2p_CZsLe21byE8HV2EYmY3_zrktV3x7FLpC"
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = "LUNA Slap Logs",
                ["description"] = "",
                ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = admin_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = GetPlayerName(target),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = target,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    }
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        TriggerClientEvent('LUNA:SlapPlayer', target)
        TriggerClientEvent('LUNA:NotifyPlayer', admin, 'Slapped Player')
       -- LUNAclient.notify(target,{"~g~You have been slapped by ".. playerName .." ID: ".. admin_id})
    end
end)

RegisterServerEvent('LUNA:RevivePlayer')
AddEventHandler('LUNA:RevivePlayer', function(admin, target)
    local admin_id = LUNA.getUserId(admin)
    local player_id = LUNA.getUserId(target)
    if LUNA.hasPermission(admin_id, "admin.revive") then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(target)
        local webhook = "https://ptb.discord.com/api/webhooks/1110523241753219132/NhKYhCssqyPHCoz_AOoJbmtXoH3GxXgQgRrTCjeaFcuLTYeFzViGL_DFf3xMKzXHM8sa"
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = "LUNA Revive Logs",
                ["description"] = "",
                ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = admin_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = GetPlayerName(target),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = target,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    }
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        TriggerClientEvent('LUNA:FixClient',target)
        TriggerClientEvent('LUNA:NotifyPlayer', admin, 'Revived Player')
        LUNAclient.notify(target,{"~g~You have been revived by a staff member"})
    end
end)

RegisterServerEvent('LUNA:ToggleFreeze')
AddEventHandler('LUNA:ToggleFreeze', function(PlayerSource, Freeze)
    local AdminTemp = source
    local AdminPermID = LUNA.getUserId(source)
    local AdminName = GetPlayerName(AdminTemp)
    local PlayerID = LUNA.getUserId(PlayerSource)
    local LogChannel = "https://ptb.discord.com/api/webhooks/1110743966527279185/evgUaj6bjjdRUvIL7kOe3IRmilcS-ekPffLXyxwMmtDciI_0FYa2nzqKfbwp9boyFylh"
    if FrozenPlayerList[PlayerID] == nil then
        FrozenPlayerList[PlayerID] = "Unfrozen";
        LUNAclient.notify(AdminTemp, {"~r~Unable to freeze User ID "..PlayerID.."("..GetPlayerName(PlayerSource)..") Try again"})
        TriggerClientEvent("LUNA:FailedFroze", AdminTemp)
        return
    end
    if LUNA.hasPermission(AdminPermID, "admin.menu") then
        local communityname = "LUNA Staff Logs"
        local communtiylogo = ""
        local command = {
            {
                ["color"] = "15536128",
                ["title"] = GetPlayerName(PlayerSource).. " Was " ..FrozenPlayerList[PlayerID],
                ["fields"] = {
                    {
                        ["name"] = "**Admin Name**",
                        ["value"] = "" ..AdminName,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin TempID**",
                        ["value"] = "" ..AdminTemp,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Admin PermID**",
                        ["value"] = "" ..AdminPermID,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player Name**",
                        ["value"] = "" .. GetPlayerName(PlayerSource),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player TempID**",
                        ["value"] = "" ..PlayerSource,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "**Player PermID**",
                        ["value"] = ""..PlayerID,
                        ["inline"] = true
                    },
                },
                ["description"] = "",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(LogChannel, function(err, text, headers) end, 'POST', json.encode({username = "LUNA Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })

        if Freeze and FrozenPlayerList[PlayerID] == "Unfrozen" then
            FrozenPlayerList[PlayerID] = "Frozen";
            LUNAclient.notify(AdminTemp, {"~g~You froze UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
            TriggerClientEvent("LUNA:Freeze", PlayerSource, true)

        elseif not Freeze and FrozenPlayerList[PlayerID] == "Frozen" then
            FrozenPlayerList[PlayerID] = "Unfrozen";
            LUNAclient.notify(AdminTemp, {"~g~You unfroze UserID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
            TriggerClientEvent("LUNA:Freeze", PlayerSource, false)
        else
            LUNAclient.notify(AdminTemp, {"~r~Unable to freeze User ID "..PlayerID.."("..GetPlayerName(PlayerSource)..")"})
            TriggerClientEvent("LUNA:FailedFroze", AdminTemp)
        end
        
    end
end)

RegisterServerEvent('LUNA:TeleportToPlayer')
AddEventHandler('LUNA:TeleportToPlayer', function(source, newtarget)
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = LUNA.getUserId(source)
    local player_id = LUNA.getUserId(newtarget)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LUNA.hasPermission(user_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(newtarget)
        local webhook = "https://ptb.discord.com/api/webhooks/1110523417070931999/T3YPY-vsu2W2EmX4ZqxlWNFY5xj9VtfGg_7Sk1R-tOnWev5fElowsnqPRLwebUfNsAyG"
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = "LUNA TP Logs",
                ["description"] = "",
                ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                ["fields"] = {
                    {
                        ["name"] = "Admin Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin TempID",
                        ["value"] = source,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Admin PermID",
                        ["value"] = user_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player Name",
                        ["value"] = GetPlayerName(newtarget),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = newtarget,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = player_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Type",
                        ["value"] = "Teleport to me",
                        ["inline"] = true
                    }
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        TriggerClientEvent('LUNA:Teleport', source, coords)
    end
end)


RegisterNetEvent('LUNA:BringPlayer')
AddEventHandler('LUNA:BringPlayer', function(id)
    local source = source 
    local SelectedPlrSource = LUNA.getUserSource(id) 
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, "admin.tickets") then
        if SelectedPlrSource then  
            if onesync ~= "off" then 
                local ped = GetPlayerPed(source)
                local otherPlr = GetPlayerPed(SelectedPlrSource)
                local pedCoords = GetEntityCoords(ped)
                local playerOtherName = GetPlayerName(SelectedPlrSource)

                local player_id = LUNA.getUserId(SelectedPlrSource)
                local playerName = GetPlayerName(source)

                SetEntityCoords(otherPlr, pedCoords)

                webhook = "https://ptb.discord.com/api/webhooks/1110524240337305670/yb95Kx5xjNGWMcIBkXHhyL6zIL9_Hf1w8Osj4U118vjCTwmEZcUIh3hscSR4Ok9MdHWn"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "LUNA", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Brang "..playerOtherName,
                        ["description"] = "**Admin Name: **"..playerName.."\n**PermID: **"..user_id.."\n**Player Name:** "..playerOtherName.."\n**Player ID:** "..player_id,
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })
            else 
                TriggerClientEvent('LUNA:BringPlayer', SelectedPlrSource, false, id)  
            end
        else 
            LUNAclient.notify(source,{"~r~This player may have left the game."})
        end
    else
        LUNAclient.notify(source,{"~r~Player Cheating"})
    end
end)

playersSpectating = {}
playersToSpectate = {}

RegisterNetEvent('LUNA:GetCoords')
AddEventHandler('LUNA:GetCoords', function()
    local source = source 
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "dev.getcoords") then
    --if LUNA.hasGroup(userid, "dev") then
        LUNAclient.getPosition(source,{},function(x,y,z)
            LUNA.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
        end)
    end
end)

RegisterServerEvent('LUNA:Tp2Coords')
AddEventHandler('LUNA:Tp2Coords', function()
    local source = source
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "dev.tp2coords") then
        LUNA.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                LUNAclient.notify(source, {"~r~We couldn't find those coords, try again!"})
            else
                LUNAclient.teleport(player,{x,y,z})
            end 
        end)
    end
end)

RegisterServerEvent('LUNA:GiveMoneyMenu')
AddEventHandler('LUNA:GiveMoneyMenu', function()
    local source = source
    local userid = LUNA.getUserId(source)

        if LUNA.hasGroup(userid, "founder") then
        if user_id ~= nil then
            LUNA.prompt(source,"Amount:","",function(source,amount) 
                amount = parseInt(amount)
                LUNA.giveMoney(user_id, amount)
                LUNAclient.notify(source,{"You have gave yourself £" .. amount})
                webhook = "https://ptb.discord.com/api/webhooks/1110523471861129256/cbzX8rEIGcdcaO5VS39J8_4JjHfu4EugdkzR5hzamT2AR6DQF86oB3vbThPtEwFcetIj"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "LUNA", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Money Logs",
                        ["description"] = "**Admin Name: **"..userid.."\n**Amount: **"..amount,
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })
            end)
        end
    end
end)

RegisterServerEvent('LUNA:GiveBankMenu')
AddEventHandler('LUNA:GiveBankMenu', function()
    local source = source
    local userid = LUNA.getUserId(source)

        if LUNA.hasGroup(userid, "founder") then
        if user_id ~= nil then
            LUNA.prompt(source,"Amount:","",function(source,amount) 
                amount = parseInt(amount)
                LUNA.giveBankMoney(user_id, amount)
                LUNAclient.notify(source,{"You have gave yourself £" .. amount})
                webhook = "https://ptb.discord.com/api/webhooks/1110523471861129256/cbzX8rEIGcdcaO5VS39J8_4JjHfu4EugdkzR5hzamT2AR6DQF86oB3vbThPtEwFcetIj"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "LUNA", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Bank Logs",
                        ["description"] = "**Admin Name: **"..userid.."\n**Amount: **"..amount,
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }
            }}), { ["Content-Type"] = "application/json" })
            end)
        end
    end
end)

RegisterServerEvent("LUNA:Teleport2AdminIsland")
AddEventHandler("LUNA:Teleport2AdminIsland",function(id)
    local admin = source
    local admin_id = LUNA.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = LUNA.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LUNA.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://ptb.discord.com/api/webhooks/1110523575095533628/ivZUx6FDEgRl9dMBtrP_2dbxrEASJoW4fOGNkm3LFHVEUND1P0T0tXpaAQIfPKhlYHRt"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LUNA", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported "..playerOtherName.." to admin island",
                ["description"] = "**Admin Name: **"..playerName.."\n**PermID: **"..user_id.."\n**Player Name:** "..playerOtherName.."\n**Player ID:** "..player_id,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, 4890.955078125,-4924.9912109375,3.3665964603424)
        LUNAclient.notify(LUNA.getUserSource(player_id),{'~g~You are now in an admin situation, do not leave the game.'})
    end
end)

RegisterServerEvent("LUNA:Teleport2Legion")
AddEventHandler("LUNA:Teleport2Legion",function(id)
    local admin = source
    local admin_id = LUNA.getUserId(admin)
    local admin_name = GetPlayerName(admin)
    local player_id = LUNA.getUserId(id)
    local player_name = GetPlayerName(id)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LUNA.hasPermission(admin_id, perm) then
        local playerName = GetPlayerName(source)
        local playerOtherName = GetPlayerName(id)
        webhook = "https://ptb.discord.com/api/webhooks/1110523616757547108/mD3Yqlo_l_4VZ0mlpE87M9kNGL86lUIPZIB4dNqA5qX6AshhOXAvXANAZLwN6ZzsDPp7"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LUNA", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Teleported "..playerOtherName.." to Legion",
                ["description"] = "**Admin Name: **"..playerName.."\n**PermID: **"..user_id.."\n**Player Name:** "..playerOtherName.."\n**Player ID:** "..player_id,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
    }}), { ["Content-Type"] = "application/json" })
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, 151.6117401123,-1035.0394287109,29.339387893677)
    end
end)

RegisterServerEvent("LUNA:TeleportBackFromAdminZone")
AddEventHandler("LUNA:TeleportBackFromAdminZone",function(id, savedCoordsBeforeAdminZone)
    local admin = source
    local admin_id = LUNA.getUserId(admin)
    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LUNA.hasPermission(admin_id, perm) then
        local ped = GetPlayerPed(id)
        SetEntityCoords(ped, savedCoordsBeforeAdminZone)
    end
end)

local cooldown = 0
RegisterServerEvent("LUNA:Teleport")
AddEventHandler("LUNA:Teleport",function(id, coords)
    local admin = source
    local admin_id = LUNA.getUserId(admin)

    local perm = admincfg.buttonsEnabled["TP2"][2]
    if LUNA.hasPermission(admin_id, perm) then
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped2, coords)
    end
end)

RegisterNetEvent('LUNA:AddCar')
AddEventHandler('LUNA:AddCar', function()
    local source = source
    local userid = LUNA.getUserId(source)
    local perm = admincfg.buttonsEnabled["addcar"][2]
    if LUNA.hasPermission(userid, perm) then
        LUNA.prompt(source,"Add to Perm ID:","",function(source, permid)
            if permid == "" then return end
            local playerName = GetPlayerName(permid)
            LUNA.prompt(source,"Car Spawncode:","",function(source, car) 
                if car == "" then return end
                local car = car
                local adminName = GetPlayerName(source)
                LUNA.prompt(source,"Locked:","",function(source, locked) 
                if locked == '0' or locked == '1' then
                    if permid and car ~= "" then  
                        LUNA.getUserIdentity(userid, function(identity)					
                            exports['ghmattimysql']:execute("INSERT IGNORE INTO luna_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)", {user_id = permid, vehicle = car, registration = identity.registration, locked = locked})
                        end)
                        LUNAclient.notify(source,{'~g~Successfully added Player\'s car'})
                        webhook = "https://ptb.discord.com/api/webhooks/1110523660340572211/JYB9Bj_H6N7aBez-5lMtmU1gpz9AQfn-Zeq2Sx2dUiB7QO6DwvFqOn5uaB9oyN3e6d5c"
                        PerformHttpRequest(webhook, function(err, text, headers) 
                        end, "POST", json.encode({username = "LUNA", embeds = {
                            {
                                ["color"] = "15158332",
                                ["title"] = "Added Car",
                                ["description"] = "**Admin Name:** "..adminName.."\n**Admin ID:** "..userid.."\n**Player ID:** "..permid.."\n**Car Spawncode:** "..car,
                                ["footer"] = {
                                    ["text"] = "Time - "..os.date("%x %X %p"),
                                }
                        }}}), { ["Content-Type"] = "application/json" })
                    else 
                        LUNAclient.notify(source,{'~r~Failed to add Player\'s car'})
                    end
                else
                    LUNAclient.notify(source,{'~g~Locked must be either 1 or 0'}) 
                end
                end)
            end)
        end)
    end
end)

RegisterNetEvent('LUNA:resetRedeem')
AddEventHandler('LUNA:resetRedeem', function()
    local source = source
    local userid = LUNA.getUserId(source)
    local perm = admincfg.buttonsEnabled["addcar"][2]
    if LUNA.hasPermission(userid, perm) then
        LUNA.prompt(source,"Perm ID:","",function(source, permid)
            if permid == "" then return end
                local playerName = GetPlayerName(source)
                LUNA.removeUserGroup(userid,'Redeemed')
                LUNAclient.notify(source,{'~g~Successfully reset Player\'s Redeemed Rewards.'})
                webhook = "https://ptb.discord.com/api/webhooks/1110522336026824707/lumMjsfR4NEsh2wxfa5vyjIq1xMoTpEbMAQBKtmiBanSTTydYJXPkdEQUqN9zvQ8hB7T"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "LUNA", embeds = {
                    {
                        ["color"] = "15158332",
                        ["title"] = "Reset Rewards",
                        ["description"] = "**Admin Name:** "..playerName.."\n**Admin ID:** "..userid.."\n**Player ID:** "..permid,
                        ["footer"] = {
                            ["text"] = "Time - "..os.date("%x %X %p"),
                        }
                }}}), { ["Content-Type"] = "application/json" })
        end)
    end
end)

RegisterNetEvent('LUNA:PropCleanup')
AddEventHandler('LUNA:PropCleanup', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, 'admin.menu') then
        for i,v in pairs(GetAllObjects()) do 
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'LUNA │ ', {255, 255, 255}, "Entity Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    else 
        
        LUNAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('LUNA:DeAttachEntity')
AddEventHandler('LUNA:DeAttachEntity', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent("LUNAAdmin:EntityWipe", -1)
        TriggerClientEvent('chatMessage', -1, 'LUNA │ ', {255, 255, 255}, "Deattach Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    else
        
        LUNAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('LUNA:PedCleanup')
AddEventHandler('LUNA:PedCleanup', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, 'admin.menu') then
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'LUNA │ ', {255, 255, 255}, "Ped Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    else 
        
        LUNAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)


RegisterNetEvent('LUNA:VehCleanup')
AddEventHandler('LUNA:VehCleanup', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, 'admin.menu') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "A Vehicle Cleanup has been Triggered, please wait 60 seconds! ^2", "alert")
        Wait(60000)
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "Vehicle Cleanup Completed ^0!", "alert")
    else 
        
        LUNAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)


RegisterNetEvent('LUNA:VehCleanup1')
AddEventHandler('LUNA:VehCleanup1', function()
    for i,v in pairs(GetAllVehicles()) do 
        DeleteEntity(v)
    end
end)

RegisterNetEvent('LUNA:CleanAll')
AddEventHandler('LUNA:CleanAll', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, 'admin.menu') then
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'LUNA^7 │ ', {255, 255, 255}, "Vehicle, Ped, Entity Cleanup Completed by ^3" .. GetPlayerName(source) .. "^0!", "alert")
    else 
        LUNAclient.notify(source,{"~r~You can not perform this action!"})
    end
end)

RegisterNetEvent('LUNA:noClip')
AddEventHandler('LUNA:noClip', function()
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, 'admin.noclip') then 
        TriggerClientEvent('ToggleAdminNoclip',source)
    end
end)

RegisterServerEvent('LUNA:playerDamage')
AddEventHandler('LUNA:playerDamage', function(target, damage)
    TriggerClientEvent('LUNA:playerDamageDisplay', -1, target, damage)
end)



RegisterNetEvent("LUNA:checkBlips")
AddEventHandler("LUNA:checkBlips",function(status)
    local source = source
    if LUNA.hasPermission(user_id, 'group.add') then 
        TriggerClientEvent('LUNA:showBlips', source)
    end
end)

RegisterNetEvent("LUNA:requestAdminPerks")
AddEventHandler("LUNA:requestAdminPerks", function()
        local source = source
        local user_id = LUNA.getUserId(source)
        if LUNA.hasGroup(user_id, "founder") then
            a = 12
        elseif LUNA.hasGroup(user_id, "dev") then
            a = 11
        elseif LUNA.hasGroup(user_id, "operationsmanager") then
            a = 10
        elseif LUNA.hasGroup(user_id, "commanager") then
            a = 9
        elseif LUNA.hasGroup(user_id, "staffmanager") then
            a = 8
        elseif LUNA.hasGroup(user_id, "headadmin") then
            a = 7
        elseif LUNA.hasGroup(user_id, "senioradmin") then
            a = 6
        elseif LUNA.hasGroup(user_id, "administrator") then
            a = 5
        elseif LUNA.hasGroup(user_id, "srmoderator") then
            a = 4
        elseif LUNA.hasGroup(user_id, "moderator") then
            a = 3
        elseif LUNA.hasGroup(user_id, "supportteam") then
            a = 2
        elseif LUNA.hasGroup(user_id, "trialstaff") then
            a = 1
        elseif not LUNA.hasGroup(user_id, "dev") then
            a = 0
        end
        TriggerClientEvent("LUNA:SendAdminPerks", source, a)
    end
)

RegisterServerEvent('LUNA:GetPlayerGroups')
AddEventHandler('LUNA:GetPlayerGroups', function(PlayerPermID)
    local source = source
    local user_id = LUNA.getUserId(source)
    if LUNA.hasPermission(user_id, "admin.menu") then  
        local PlayerGroups = LUNA.getUserGroups(PlayerPermID)
        TriggerClientEvent("LUNA:RecievePlayerGroups", source, PlayerGroups)
    end
end)