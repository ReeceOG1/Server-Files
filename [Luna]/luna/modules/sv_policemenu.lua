local lang = LUNA.lang
local cfg = module("cfg/police")

RegisterServerEvent('LUNA:OpenPoliceMenu')
AddEventHandler('LUNA:OpenPoliceMenu', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
        TriggerClientEvent("LUNA:PoliceMenuOpened", source)
    elseif user_id ~= nil and LUNA.hasPermission(user_id, "clockon.menu") then
      LUNAclient.notify(source,{"You are not on duty"})
    end
end)

RegisterServerEvent('LUNA:ActivateZone')
AddEventHandler('LUNA:ActivateZone', function(message, speed, radius, x, y, z)
    TriggerClientEvent('chatMessage', -1, "" , { 128, 128, 128 }, message, "alert")
    TriggerClientEvent('LUNA:ZoneCreated', -1, speed, radius, x, y, z)
end)

RegisterServerEvent('LUNA:RemoveZone')
AddEventHandler('LUNA:RemoveZone', function(blip)
    TriggerClientEvent('LUNA:RemovedBlip', -1)
end)

RegisterServerEvent('LUNA:Drag')
AddEventHandler('LUNA:Drag', function()
    player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
        LUNAclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
            local nuser_id = LUNA.getUserId(nplayer)
            if nuser_id ~= nil then
            LUNAclient.isHandcuffed(nplayer,{},function(handcuffed)
                if handcuffed then
                    TriggerClientEvent("LUNA:DragPlayer", nplayer, player)
                else
                    LUNAclient.notify(player,{"~r~Player is not handcuffed."})
                end
            end)
            else
                LUNAclient.notify(player,{"~r~There is no player nearby"})
            end
            else
                LUNAclient.notify(player,{"~r~There is no player nearby"})
            end
        end)
    end
end)

local cuff = false

RegisterServerEvent('LUNA:Handcuff')
AddEventHandler('LUNA:Handcuff', function()
    player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
      LUNAclient.getNearestPlayer(player,{20},function(nplayer)
          local nuser_id = LUNA.getUserId(nplayer)
          if nuser_id ~= nil then
         
            LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
              if not handcuffed then
                  LUNAclient.setHandcuffed(nplayer, {true})
              else
                  LUNAclient.setHandcuffed(nplayer, {false})
              end
            end)

           
           
            LUNA.closeMenu(nplayer)
          else
            LUNAclient.notify(player,{"~r~There is no player nearby"})
          end
      end)
    end
end)

local unjailed = {}
function jail_clock(target_id,timer)
  local target = LUNA.getUserSource(tonumber(target_id))
  local users = LUNA.getUsers()
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  LUNAclient.notify(target, {"~r~Remaining time: " .. timer .. " minute(s)."})
      LUNA.setUData(tonumber(target_id),"LUNA:jail:time",json.encode(timer))
	  SetTimeout(60*1000, function()
		for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
		  if v == tonumber(target_id) then
	        unjailed[v] = nil
		    timer = 0
		  end
		end
	    jail_clock(tonumber(target_id),timer-1)
	  end) 
    else 
    TriggerClientEvent("returnFalse", target)
	  LUNAclient.teleport(target,{1854.2919921875,2586.1066894531,45.672054290771}) -- teleport to outside jail
	  LUNAclient.setHandcuffed(target,{false})
      LUNAclient.notify(target,{"~b~You have been set free."})
      
	  LUNA.setUData({tonumber(target_id),"LUNA:jail:time",json.encode(-1)})
    end
  end
end

RegisterServerEvent('LUNA:SeizeWeapons2')
AddEventHandler('LUNA:SeizeWeapons2', function()
  local source = source
    player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
            LUNAclient.getNearestPlayer(player,{10},function(nplayer)
              LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then 
            if nplayer ~= nil then
                local nuser_id = LUNA.getUserId(nplayer)
                if nuser_id ~= nil then
                  RemoveAllPedWeapons(nplayer, true)
                  LUNA.clearInventory(nuser_id) 
                  LUNAclient.notify(player, {'~g~Seized players weapons'})
                  LUNAclient.notify(nplayer, {'~r~Your weapons were seized'})
                else
                    LUNAclient.notify(player,{"~r~There is no player nearby"})
                end
                else
                    LUNAclient.notify(player,{"~r~There is no player nearby"})
                end
              else
                LUNAclient.notify(player, {'~r~Player has to be cuffed.'})
              end
            end)
            end)
    end
end)

RegisterServerEvent('LUNA:SeizeItems')
AddEventHandler('LUNA:SeizeItems', function()
  local source = source
    player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
            LUNAclient.getNearestPlayer(player,{10},function(nplayer)
              LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then 
            if nplayer ~= nil then
                local nuser_id = LUNA.getUserId(nplayer)
                if nuser_id ~= nil then
                  RemoveAllPedWeapons(nplayer, true)
                  LUNA.clearInventory(nuser_id) 
                  LUNAclient.notify(player, {'~g~Seized players items'})
                  LUNAclient.notify(nplayer, {'~r~Your items were seized'})
                else
                    LUNAclient.notify(player,{"~r~There is no player nearby"})
                end
                else
                    LUNAclient.notify(player,{"~r~There is no player nearby"})
                end
              else
                LUNAclient.notify(player, {'~r~Player has to be cuffed.'})
              end
            end)
            end)
    end
end)

RegisterServerEvent('LUNA:JailPlayer')
AddEventHandler('LUNA:JailPlayer', function()
    local player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
        LUNAclient.getNearestPlayers(player, {15}, function(nplayers)
            local user_list = ""
            for k, v in pairs(nplayers) do
                user_list = user_list .. "[" .. LUNA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
            end
            LUNA.prompt(player, "Players Nearby:" .. user_list, "", function(player, target_id)
                if target_id ~= nil and target_id ~= "" then
                    if not target_id and nplayers then return end
                    local target = LUNA.getUserSource(tonumber(target_id))
                    if target ~= nil then
                        LUNAclient.isHandcuffed(target, {}, function(handcuffed)
                            if handcuffed then
                                LUNA.prompt(player, "Jail Time in minutes:", "1", function(player, jail_time)
                                    if jail_time ~= nil and jail_time ~= "" then
                                        if tonumber(jail_time) > 60 then
                                            jail_time = 60
                                        end
                                        if tonumber(jail_time) < 1 then
                                            jail_time = 1
                                        end

                                        LUNAclient.loadFreeze(target, {false, true, true})
                                        SetTimeout(15000, function()
                                            LUNAclient.loadFreeze(target, {false, false, false})
                                        end)
                                        LUNAclient.teleport(target, {1779.8850097656, 2584.3186035156, 45.797779083252}) -- teleport to inside jail
                                        LUNAclient.notify(target, {"~r~You have been sent to jail."})
                                        LUNAclient.notify(player, {"~b~You sent a player to jail."})
                                        LUNAclient.setHandcuffed(target, {false})
                                        jail_clock(tonumber(target_id), tonumber(jail_time))
                                        TriggerClientEvent("returnTrue", target)
                                        TriggerClientEvent("stopjail", target)
                                        local user_id = LUNA.getUserId(player)
                                        local jaillogs = {
                                            {
                                                ["color"] = "16777215",
                                                ["description"] = "**ID:** " .. user_id .. " **jailed **" .. target_id .. "** for **" .. jail_time .. " **minutes**",
                                                ["footer"] = {
                                                    ["text"] = "LUNA - " .. os.date("%X"),
                                                    ["icon_url"] = "https://cdn.discordapp.com/attachments/848856393012346930/877183938420953118/LUNALogo.png",
                                                }
                                            }
                                        }
                                        PerformHttpRequest("https://ptb.discord.com/api/webhooks/1110525163646234715/yicihCwNmtS1UGYdZm_HQtPWEGXnEYbrNjEvUMyGoVonyFYDhKynJ64foM3Fusir11K8", function(err, text, headers)
                                        end, "POST", json.encode({ username = "Jail Logs", embeds = jaillogs }), { ["Content-Type"] = "application/json" })

                                        -- Set player's clothes here
                                        TriggerClientEvent('LUNA:SetPlayerClothing', target)

                                    else
                                        LUNAclient.notify(player, {"~r~The jail time can't be empty."})
                                    end
                                end)
                            else
                                LUNAclient.notify(player, {"~r~The player is not handcuffed."})
                            end
                        end)
                    else
                        LUNAclient.notify(player, {"~r~That ID seems invalid."})
                    end
                else
                    LUNAclient.notify(player, {"~r~No player ID selected."})
                end
            end)
        end)
    else
        print(user_id .. " could be modding")
    end
end)







RegisterServerEvent('LUNA:UnJailPlayer')
AddEventHandler('LUNA:UnJailPlayer', function()
    player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "admin.noclip") then
	  LUNA.prompt(player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
      LUNA.getUData(tonumber(target_id),"LUNA:jail:time",function(value)
        if value ~= nil then
        custom = json.decode(value)
        if custom ~= nil then
          local user_id = LUNA.getUserId(player)
          if tonumber(custom) > 0 or LUNA.hasPermission(user_id,"admin.noclip") then
                local target = LUNA.getUserSource(tonumber(target_id))
          if target ~= nil then
            unjailed[target] = tonumber(target_id)
            LUNA.setUData(tonumber(target_id),"LUNA:jail:time",json.encode(-1))
            LUNAclient.notify(player,{"~g~Target will be released soon."})
            LUNAclient.notify(target,{"~g~Someone lowered your sentence."})
            local unjaillogs = {
              {
                  ["color"] = "16777215",
                  ["description"] = "**ID:** " .. user_id .. " **unjailed** " .. target_id,
                  ["footer"] = {
                    ["text"] = "LUNA - "..os.date("%X"),
                    ["icon_url"] = "https://cdn.discordapp.com/attachments/848856393012346930/877183938420953118/LUNALogo.png",
                  }
              }
          }
          PerformHttpRequest("https://ptb.discord.com/api/webhooks/1110525163646234715/yicihCwNmtS1UGYdZm_HQtPWEGXnEYbrNjEvUMyGoVonyFYDhKynJ64foM3Fusir11K8", function(err, text, headers) 
          end, "POST", json.encode({username = "Unjail Logs", embeds = unjaillogs}), { ["Content-Type"] = "application/json" })
          else
            LUNAclient.notify(player,{"~r~That ID seems invalid."})
          end
          else
          LUNAclient.notify(player,{"~r~Target is not jailed."})
          end
        end
		  end
		end)
      else
        LUNAclient.notify(player,{"~r~No player ID selected."})
      end 
  end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterServerEvent('LUNA:sendFine')
AddEventHandler('LUNA:sendFine', function()
    player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.group") then
      LUNAclient.getNearestPlayers(player,{15},function(nplayers) 
      local user_list = ""
      for k,v in pairs(nplayers) do
        user_list = user_list .. "[" .. LUNA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
      end 
      if user_list ~= "" then
        LUNA.prompt(player,"Players Nearby:" .. user_list,"",function(player,target_id) 
          if target_id ~= nil and target_id ~= "" then 
            LUNA.prompt(player,"Fine amount:","100",function(player,fine)
              if fine ~= nil and fine ~= "" then 
                LUNA.prompt(player,"Fine reason:","",function(player,reason)
                  if reason ~= nil and reason ~= "" then 
                    local target = LUNA.getUserSource(tonumber(target_id))
                    if target ~= nil then
                      if tonumber(fine) > 100000 then
                          fine = 100000
                      end
                      if tonumber(fine) < 100 then
                        fine = 100
                      end
                
                      if LUNA.tryFullPayment(tonumber(target_id), tonumber(fine)) then
                        LUNA.insertPoliceRecord(tonumber(target_id), lang.police.menu.fine.record({reason,fine}))
                        LUNAclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                        LUNAclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
                        local user_id = LUNA.getUserId(player)
                        LUNA.closeMenu(player)
                      else
                        LUNAclient.notify(player,{lang.money.not_enough()})
                      end
                    else
                      LUNAclient.notify(player,{"~r~That ID seems invalid."})
                    end
                  else
                    LUNAclient.notify(player,{"~r~You can't fine for no reason."})
                  end
                end)
              else
                LUNAclient.notify(player,{"~r~Your fine has to have a value."})
              end
            end)
          else
            LUNAclient.notify(player,{"~r~No player ID selected."})
          end 
        end)
      else
        LUNAclient.notify(player,{"~r~No player nearby."})
      end 
    end)
  else
    print(user_id.." Could be modder")
  end
end)
RegisterNetEvent("LUNA:PutPlrInVeh")
AddEventHandler("LUNA:PutPlrInVeh", function()
    player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
    LUNAclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = LUNA.getUserId(nplayer)
      if nuser_id ~= nil then
        LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            LUNAclient.putInNearestVehicleAsPassenger(nplayer, {5})
          else
            LUNAclient.notify(player,{"~r~Player is not not cuffed."})
          end
        end)
      else
        LUNAclient.notify(player,{"~r~No player nearby."})
      end
    end)
  else
    print(user_id.." Could be modder")
  end
end)

RegisterNetEvent("LUNA:TakeOutOfVehicle")
AddEventHandler("LUNA:TakeOutOfVehicle", function()
    player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
    LUNAclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = LUNA.getUserId(nplayer)
        if nuser_id ~= nil then
        LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
            LUNAclient.ejectVehicle(nplayer, {})
            else
              LUNAclient.notify(player,{"~r~Player is not not cuffed."})
            end
        end)
        else
          LUNAclient.notify(player,{"~r~No player nearby."})
        end
    end)
    else
        print(user_id.." Could be modder")
    end
end)

RegisterNetEvent("LUNA:SearchPlayer")
AddEventHandler("LUNA:SearchPlayer", function()
    player = source
    if user_id ~= nil and LUNA.hasPermission(user_id, "police.armoury") then
      LUNAclient.getNearestPlayer(player,{5},function(nplayer)
          local nuser_id = LUNA.getUserId(nplayer)
          if nuser_id ~= nil then
            LUNAclient.notify(nplayer,{lang.police.menu.check.checked()})
            LUNAclient.getWeapons(nplayer,{},function(weapons)
              -- prepare display data (money, items, weapons)
              local money = LUNA.getMoney(nuser_id)
              local items = ""
              local data = LUNA.getUserDataTable(nuser_id)
              if data and data.inventory then
                for k,v in pairs(data.inventory) do
                  local item = LUNA.items[k]
                  if item then
                    items = items.."<br />"..item.name.." ("..v.amount..")"
                  end
                end
              end
      
              local weapons_info = ""
              for k,v in pairs(weapons) do
                weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
              end
      
              LUNAclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
              -- request to hide div
              LUNA.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                LUNAclient.removeDiv(player,{"police_check"})
              end)
            end)
          else
            LUNAclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end
end)