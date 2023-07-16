local cfg_inventory = module("luna-vehicles", "cfg/cfg_inventory")
local lang = LUNA.lang

-- RegisterServerEvent("LUNA:AskID")
-- AddEventHandler("LUNA:AskID", function()
--     local player = source
--     LUNAclient.getNearestPlayer(player, {10}, function(nplayer)
--         local nuser_id = LUNA.getUserId(nplayer)
--         if nuser_id ~= nil then
--             LUNAclient.notify(player, {lang.police.menu.askid.asked()})
--             LUNA.request(nplayer, lang.police.menu.askid.request(), 15, function(nplayer, ok)
--                 if ok then
--                     LUNA.getUserIdentity(nuser_id, function(identity)
--                         if identity then
--                             -- Display identity and business
--                             local name = identity.name
--                             local firstname = identity.firstname
--                             local age = identity.age
--                             local phone = identity.phone
--                             local registration = identity.registration
--                             local home = ""
--                             local number = ""

--                             LUNA.getUserAddress(nuser_id, function(address)
--                                 if address then
--                                     home = address.home
--                                     number = address.number
--                                 end

--                                 -- Added img tag and modified div styles to align the content on the left
--                                 local content = '<img src="https://cdn.discordapp.com/attachments/1096186285292540025/1105451395026530314/luna_connecting.pngL" alt="Portrait" />' .. lang.police.identity.info({name, firstname, age, registration, phone, home, number})
--                                 LUNAclient.setDiv(player, {"police_identity", ".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; display: flex; flex-direction: row; align-items: center; } .div_police_identity img { margin-right: 20px; }", content})
--                                 -- Request to hide div
--                                 LUNA.request(player, lang.police.menu.askid.request_hide(), 1000, function(player, ok)
--                                     LUNAclient.removeDiv(player, {"police_identity"})
--                                 end)
--                             end)
--                         end
--                     end)
--                 else
--                     LUNAclient.notify(player, {lang.common.request_refused()})
--                 end
--             end)
--         else
--             LUNAclient.notify(player, {lang.common.no_player_near()})
--         end
--     end)
-- end)



RegisterServerEvent("LUNA:GiveMoney2")
AddEventHandler("LUNA:GiveMoney2",function()
    local player = source
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil then
      LUNAclient.getNearestPlayer(player,{10},function(nplayer)
        if nplayer ~= nil then
        local nuser_id = LUNA.getUserId(nplayer)
        if nuser_id ~= nil then
            LUNA.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and LUNA.tryPayment(user_id,amount) then
                LUNA.giveMoney(nuser_id,amount)
                LUNAclient.notify(player,{"~r~You hand over ~w~£" .. amount .. "" })
                LUNAclient.notify(nplayer,{"~g~You got handed ~w~£" .. amount .. ""})
            else
                LUNAclient.notify(player,{lang.money.not_enough()})
                end
            end)
            else
                LUNAclient.notify(player,{lang.common.no_player_near()})
            end
            else
                LUNAclient.notify(player,{lang.common.no_player_near()})
            end
        end)
    end
end)

local function ch_vehicle(player,choice)
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    -- check vehicle
    LUNAclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
      if ok then
        -- build vehicle menu
        LUNA.buildMenu("vehicle", {user_id = user_id, player = player, vtype = vtype, vname = name}, function(menu)
          menu.name=lang.vehicle.title()
          menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}

          for k,v in pairs(veh_actions) do
            menu[k] = {function(player,choice) v[1](user_id,player,vtype,name) end, v[2]}
          end

          LUNA.openMenu(player,menu)
        end)
      else
        LUNAclient.notify(player,{lang.vehicle.no_owned_near()})
      end
    end)
  end
end

RegisterNetEvent('LUNA:TrunkOpened')
AddEventHandler('LUNA:TrunkOpened', function()
  local user_id = LUNA.getUserId(source)
  LUNAclient.getNearestOwnedVehicle(source,{7},function(ok,vtype,name)
    if ok then 
      local chestname = "u"..user_id.."veh_"..string.lower(name)
      local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

      LUNAclient.vc_openDoor(source, {vtype,5})
      LUNA.openChest(source, chestname, max_weight, function()
        LUNAclient.vc_closeDoor(source, {vtype,5})
      end)
    end
  end)
end)

RegisterNetEvent('LUNA:SearchPlr')
AddEventHandler("LUNA:SearchPlr", function()
  player = source
  LUNAclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      TriggerClientEvent('LUNA:handsUpNearest', nplayer)
      LUNAclient.notify(nplayer,{lang.police.menu.check.checked()})
      LUNAclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = LUNA.getMoney(nuser_id)
        local items = ""
        local data = LUNA.getUserDataTable(nuser_id)
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = LUNA.getItemName(k)
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        -- Set bolder font and use Roboto as the font
        local content = '<div class="content-wrapper">'..lang.police.menu.check.info({money,items,weapons_info})..'</div>'
        LUNAclient.setDiv(player,{"police_check","@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@700&display=swap'); .div_police_check{ background-image: url('https://cdn.discordapp.com/attachments/1096186285292540025/1105451395026530314/luna_connecting.png'); background-size: cover; background-position: center; color: white; font-family: 'Roboto', sans-serif; font-weight: bold; width: 500px; padding: 20px; position: fixed; left: 2%; top: 50%; transform: translateY(-50%); display: flex; flex-direction: column; align-items: flex-start; border-radius: 10px; } .content-wrapper { background-color: rgba(0, 0, 0, 0.6); padding: 20px; border-radius: 10px; }",content})

        -- request to hide div
        LUNA.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          LUNAclient.removeDiv(player,{"police_check"})
        end)
      end)
    else
      LUNAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end)





RegisterServerEvent('LUNA:searchNearestPlayer')
AddEventHandler('LUNA:searchNearestPlayer', function(nplayer)
  LUNAclient.notify(nplayer,{lang.police.menu.check.checked()})
  LUNAclient.getWeapons(nplayer,{},function(weapons)
    -- prepare display data (money, items, weapons)
    local money = LUNA.getMoney(nuser_id)
    local items = ""
    local data = LUNA.getUserDataTable(nuser_id)
    if data and data.inventory then
      for k,v in pairs(data.inventory) do
        local item_name = LUNA.getItemName(k)
        if item_name then
          items = items.."<br />"..item_name.." ("..v.amount..")"
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
end)

RegisterServerEvent("LUNA:SendPayment")
AddEventHandler('LUNA:SendPayment', function(playerid, price)
    local source = source
    userid = LUNA.getUserId(source)
    reciever = LUNA.getUserSource(tonumber(playerid))
    recieverid = LUNA.getUserId(reciever)
    
    if recieverid == nil then
        LUNAclient.notify(source, {"~r~This ID does not exist/ is offline!"})
        TriggerClientEvent("luna:PlaySound", source, 2)
    else

        if userid == recieverid then 
            LUNAclient.notify(source, {"~r~Unable to send money to yourself!"})
            TriggerClientEvent("luna:PlaySound", source, 2)
        else
    
            if LUNA.tryBankPayment(userid, tonumber(price)) then 

                LUNAclient.notify(source, {"~g~Successfully transfered: ~w~" .. price .. " Token(s) ~g~to ~w~" .. LUNA.getPlayerName(reciever) .. " ~r~ ~n~ ~n~[ID: ~w~" .. playerid .. " ~r~]"})
                TriggerClientEvent("luna:PlaySound", source, 1)
                LUNA.giveBankMoney(tonumber(playerid), tonumber(price))

                LUNAclient.notify(reciever, {"~g~You have recieved: ~w~" .. price .. " Token(s)~g~ from ~w~".. LUNA.getPlayerName(source) .. " ~r~ ~n~ ~n~[ID: ~w~" .. userid .. " ~r~]"})
                TriggerClientEvent("luna:PlaySound", reciever, 1)

                else 
                LUNAclient.notify(source, {"~r~You do not have enough money complete transaction 🤦‍♂️"})
                TriggerClientEvent("luna:PlaySound", source, 2)
            end
        end
    end
end)