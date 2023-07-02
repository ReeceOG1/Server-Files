
-- this module define some police tools and functions
local lang = LUNA.lang
local cfg = module("cfg/police")

-- police records

-- insert a police record for a specific user
--- line: text for one line (can be html)
function LUNA.insertPoliceRecord(user_id, line)
  if user_id ~= nil then
    LUNA.getUData(user_id, "LUNA:police_records", function(data)
      local records = data..line.."<br />"
      LUNA.setUData(user_id, "LUNA:police_records", records)
    end)
  end
end

-- Hotkey Open Police PC 1/2
function LUNA.openPolicePC(source)
  LUNA.buildMenu("police_pc", {player = source}, function(menudata)
    menudata.name = "Police PC"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    LUNA.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police PC 2/2
function tLUNA.openPolicePC()
  LUNA.openPolicePC(source)
end

-- Hotkey Open Police Menu 1/2
function LUNA.openPoliceMenu(source)
  LUNA.buildMenu("police", {player = source}, function(menudata)
    menudata.name = "Police"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    LUNA.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police Menu 2/2
function tLUNA.openPoliceMenu()
  LUNA.openPoliceMenu(source)
end

-- police PC

local menu_pc = {name=lang.police.pc.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

-- search identity by registration
local function ch_searchreg(player,choice)
  LUNA.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    LUNA.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        LUNA.getUserIdentity(user_id, function(identity)
          if identity then
            -- display identity and business
            local name = identity.name
            local firstname = identity.firstname
            local age = identity.age
            local phone = identity.phone
            local registration = identity.registration
            local bname = ""
            local bcapital = 0
            local home = ""
            local number = ""

            LUNA.getUserBusiness(user_id, function(business)
              if business then
                bname = business.name
                bcapital = business.capital
              end

              LUNA.getUserAddress(user_id, function(address)
                if address then
                  home = address.home
                  number = address.number
                end

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
                LUNAclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
              end)
            end)
          else
            LUNAclient.notify(player,{lang.common.not_found()})
          end
        end)
      else
        LUNAclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- show police records by registration
local function ch_show_police_records(player,choice)
  LUNA.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    LUNA.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        LUNA.getUData(user_id, "LUNA:police_records", function(content)
          LUNAclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
        end)
      else
        LUNAclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- delete police records by registration
local function ch_delete_police_records(player,choice)
  LUNA.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    LUNA.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        LUNA.setUData(user_id, "LUNA:police_records", "")
        LUNAclient.notify(player,{lang.police.pc.records.delete.deleted()})
      else
        LUNAclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- close business of an arrested owner
local function ch_closebusiness(player,choice)
  LUNAclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      LUNA.getUserIdentity(nuser_id, function(identity)
        LUNA.getUserBusiness(nuser_id, function(business)
          if identity and business then
            LUNA.request(player,lang.police.pc.closebusiness.request({identity.name,identity.firstname,business.name}),15,function(player,ok)
              if ok then
                LUNA.closeBusiness(nuser_id)
                LUNAclient.notify(player,{lang.police.pc.closebusiness.closed()})
              end
            end)
          else
            LUNAclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end)
    else
      LUNAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

-- track vehicle
local function ch_trackveh(player,choice)
  LUNA.prompt(player,lang.police.pc.trackveh.prompt_reg(),"",function(player, reg) -- ask reg
    LUNA.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        LUNA.prompt(player,lang.police.pc.trackveh.prompt_note(),"",function(player, note) -- ask note
          -- begin veh tracking
          LUNAclient.notify(player,{lang.police.pc.trackveh.tracking()})
          local seconds = math.random(cfg.trackveh.min_time,cfg.trackveh.max_time)
          SetTimeout(seconds*1000,function()
            local tplayer = LUNA.getUserSource(user_id)
            if tplayer ~= nil then
              LUNAclient.getAnyOwnedVehiclePosition(tplayer,{},function(ok,x,y,z)
                if ok then -- track success
                  LUNA.sendServiceAlert(nil, cfg.trackveh.service,x,y,z,lang.police.pc.trackveh.tracked({reg,note}))
                else
                  LUNAclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
                end
              end)
            else
              LUNAclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
            end
          end)
        end)
      else
        LUNAclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

menu_pc[lang.police.pc.searchreg.title()] = {ch_searchreg,lang.police.pc.searchreg.description()}
menu_pc[lang.police.pc.trackveh.title()] = {ch_trackveh,lang.police.pc.trackveh.description()}
menu_pc[lang.police.pc.records.show.title()] = {ch_show_police_records,lang.police.pc.records.show.description()}
menu_pc[lang.police.pc.records.delete.title()] = {ch_delete_police_records, lang.police.pc.records.delete.description()}
menu_pc[lang.police.pc.closebusiness.title()] = {ch_closebusiness,lang.police.pc.closebusiness.description()}

menu_pc.onclose = function(player) -- close pc gui
  LUNAclient.removeDiv(player,{"police_pc"})
end

local function pc_enter(source,area)
  local user_id = LUNA.getUserId(source)
  if user_id ~= nil and LUNA.hasPermission(user_id,"police.pc") then
    LUNA.openMenu(source,menu_pc)
  end
end

local function pc_leave(source,area)
  LUNA.closeMenu(source)
end

-- main menu choices

---- handcuff
local choice_handcuff = {function(player,choice)
  LUNAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      LUNAclient.toggleHandcuff(nplayer,{})
    else
      LUNAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.handcuff.description()}

---- putinveh
--[[
-- veh at position version
local choice_putinveh = {function(player,choice)
  LUNAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          LUNAclient.getNearestOwnedVehicle(player, {10}, function(ok,vtype,name) -- get nearest owned vehicle
            if ok then
              LUNAclient.getOwnedVehiclePosition(player, {vtype}, function(x,y,z)
                LUNAclient.putInVehiclePositionAsPassenger(nplayer,{x,y,z}) -- put player in vehicle
              end)
            else
              LUNAclient.notify(player,{lang.vehicle.no_owned_near()})
            end
          end)
        else
          LUNAclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      LUNAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}
--]]

local choice_putinveh = {function(player,choice)
  LUNAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          LUNAclient.putInNearestVehicleAsPassenger(nplayer, {5})
        else
          LUNAclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      LUNAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}

local choice_getoutveh = {function(player,choice)
  LUNAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          LUNAclient.ejectVehicle(nplayer, {})
        else
          LUNAclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      LUNAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.getoutveh.description()}

RegisterServerEvent("LUNA:AskID")
AddEventHandler("LUNA:AskID", function()
  local player = source
  LUNAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      LUNAclient.notify(player,{lang.police.menu.askid.asked()})
      LUNA.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
        if ok then
          LUNA.getUserIdentity(nuser_id, function(identity)
            if identity then
              local name = identity.firstname.. " ".. identity.name
              local firstname = ""
              local age = identity.age
              local phone = identity.phone
              local registration = identity.registration
              local bname = ""
              local bcapital = 0
              local home = ""
              local number = ""

              local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
              LUNAclient.setDiv(player,{"police_identity",".div_police_identity { position: fixed; top: 50%; left: 0%; transform: translateY(-30%); background: url('') no-repeat center center fixed; -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; background-size: cover; color: white; font-family: 'Arial', sans-serif; font-weight: bold; width: 600px; padding: 20px; border-radius: 15px; display: flex; justify-content: center; align-items: center; } .div_police_identity .content { background-color: rgba(0, 0, 0, 0.5); padding: 30px; border-radius: 10px; }", "<div class='content'>" .. content .. "</div>"})
              LUNA.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                LUNAclient.removeDiv(player,{"police_identity"})
              end)
            end
          end)
        else
          LUNAclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      LUNAclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end)





---- askid
local choice_askid = {function(player,choice)
  LUNAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      LUNAclient.notify(player,{lang.police.menu.askid.asked()})
      LUNA.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
        if ok then
          LUNA.getUserIdentity(nuser_id, function(identity)
            if identity then
              local name = identity.name
              local firstname = identity.firstname
              local age = identity.age
              local phone = identity.phone
              local registration = identity.registration
              local bname = ""
              local bcapital = 0
              local home = ""
              local number = ""

              LUNA.getUserBusiness(nuser_id, function(business)
                if business then
                  bname = business.name
                  bcapital = business.capital
                end

                LUNA.getUserAddress(nuser_id, function(address)
                  if address then
                    home = address.home
                    number = address.number
                  end

                  local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
                  LUNAclient.setDiv(player,{"police_identity",".div_police_identity{ background: url('https://cdn.discordapp.com/attachments/1096186285292540025/1105451395026530314/luna_connecting.png') no-repeat center center fixed; -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; background-size: cover; color: white; font-weight: bold; width: 500px; padding:10px; margin-left: 0; margin-top: 150px; }",content})
                    LUNA.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                    LUNAclient.removeDiv(player,{"police_identity"})
                    end)
                    end)
                    end)
                    end
                    end)
                    else
                    LUNAclient.notify(player,{lang.common.request_refused()})
                    end
                    end)
                    else
                    LUNAclient.notify(player,{lang.common.no_player_near()})
                    end
                    end)
                    end, lang.police.menu.askid.description()}

---- police check
local choice_check = {function(player,choice)
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
end, lang.police.menu.check.description()}

local choice_seize_weapons = {function(player, choice)
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    LUNAclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = LUNA.getUserId(nplayer)
      if nuser_id ~= nil and LUNA.hasPermission(nuser_id, "police.seizable") then
        LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            LUNAclient.getWeapons(nplayer,{},function(weapons)
              for k,v in pairs(weapons) do -- display seized weapons
                -- LUNAclient.notify(player,{lang.police.menu.seize.seized({k,v.ammo})})
                -- convert weapons to parametric weapon items
                LUNA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                if v.ammo > 0 then
                  LUNA.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                end
              end

              -- clear all weapons
              LUNAclient.giveWeapons(nplayer,{{},true})
              LUNAclient.notify(nplayer,{lang.police.menu.seize.weapons.seized()})
            end)
          else
            LUNAclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        LUNAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.weapons.description()}

local choice_seize_items = {function(player, choice)
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    LUNAclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = LUNA.getUserId(nplayer)
      if nuser_id ~= nil and LUNA.hasPermission(nuser_id, "police.seizable") then
        LUNAclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            for k,v in pairs(cfg.seizable_items) do -- transfer seizable items
              local amount = LUNA.getInventoryItemAmount(nuser_id,v)
              if amount > 0 then
                local item = LUNA.items[v]
                if item then -- do transfer
                  if LUNA.tryGetInventoryItem(nuser_id,v,amount,true) then
                    LUNA.giveInventoryItem(user_id,v,amount,false)
                    LUNAclient.notify(player,{lang.police.menu.seize.seized({item.name,amount})})
                  end
                end
              end
            end

            LUNAclient.notify(nplayer,{lang.police.menu.seize.items.seized()})
          else
            LUNAclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        LUNAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.items.description()}

-- toggle jail nearest player
local choice_jail = {function(player, choice)
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    LUNAclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = LUNA.getUserId(nplayer)
      if nuser_id ~= nil then
        LUNAclient.isJailed(nplayer, {}, function(jailed)
          if jailed then -- unjail
            LUNAclient.unjail(nplayer, {})
            LUNAclient.notify(nplayer,{lang.police.menu.jail.notify_unjailed()})
            LUNAclient.notify(player,{lang.police.menu.jail.unjailed()})
          else -- find the nearest jail
            LUNAclient.getPosition(nplayer,{},function(x,y,z)
              local d_min = 1000
              local v_min = nil
              for k,v in pairs(cfg.jails) do
                local dx,dy,dz = x-v[1],y-v[2],z-v[3]
                local dist = math.sqrt(dx*dx+dy*dy+dz*dz)

                if dist <= d_min and dist <= 15 then -- limit the research to 15 meters
                  d_min = dist
                  v_min = v
                end

                -- jail
                if v_min then
                  LUNAclient.jail(nplayer,{v_min[1],v_min[2],v_min[3],v_min[4]})
                  LUNAclient.notify(nplayer,{lang.police.menu.jail.notify_jailed()})
                  LUNAclient.notify(player,{lang.police.menu.jail.jailed()})
                else
                  LUNAclient.notify(player,{lang.police.menu.jail.not_found()})
                end
              end
            end)
          end
        end)
      else
        LUNAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.jail.description()}

local choice_fine = {function(player, choice)
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    LUNAclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = LUNA.getUserId(nplayer)
      if nuser_id ~= nil then
        local money = LUNA.getMoney(nuser_id)+LUNA.getBankMoney(nuser_id)

        -- build fine menu
        local menu = {name=lang.police.menu.fine.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

        local choose = function(player,choice) -- fine action
          local amount = cfg.fines[choice]
          if amount ~= nil then
            if LUNA.tryFullPayment(nuser_id, amount) then
              LUNA.insertPoliceRecord(nuser_id, lang.police.menu.fine.record({choice,amount}))
              LUNAclient.notify(player,{lang.police.menu.fine.fined({choice,amount})})
              LUNAclient.notify(nplayer,{lang.police.menu.fine.notify_fined({choice,amount})})
              LUNA.closeMenu(player)
            else
              LUNAclient.notify(player,{lang.money.not_enough()})
            end
          end
        end

        for k,v in pairs(cfg.fines) do -- add fines in function of money available
          if v <= money then
            menu[k] = {choose,v}
          end
        end

        -- open menu
        LUNA.openMenu(player, menu)
      else
        LUNAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.fine.description()}



local isStoring = {}
local choice_store_weapons = function(player, choice)
    local user_id = LUNA.getUserId(player)
    LUNAclient.getWeapons(player,{},function(weapons)
            isStoring[player] = true
            if LUNA.getInventoryWeight(user_id) <= 25 or user_id == 2 and LUNA.getInventoryWeight(user_id) <= 95 then
              LUNAclient.giveWeapons(player,{{}, true}, function(removedwep)

                    for k,v in pairs(weapons) do
                        LUNA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                        if v.ammo > 0 then
                          for i,c in pairs(LUNAAmmoTypes) do
                            for a,d in pairs(c) do
                                if d == k then  

                                    LUNA.giveInventoryItem(user_id, i, v.ammo, true)
                                    -- LUNAclient.notify(player, {i})
                                end
                            end   
                          end
                        end
                    end
                    LUNAclient.notify(player,{"~g~Weapons Stored"})
                    TriggerEvent('LUNA:RefreshInventory', source)
                    SetTimeout(10000,function()
                        isStoring[player] = nil 
                    end)
              end)
            else
              LUNAclient.notify(player,{'~r~You do not have enough Weight to store Weapons.'})
            end
    end)
end

local choice_store_current_weapon = function(player, choice, currentweapon)
  local user_id = LUNA.getUserId(player)
  LUNAclient.getWeapons(player,{},function(weapons)
          isStoring[player] = true
          if LUNA.getInventoryWeight(user_id) <= 25 then
            LUNAclient.giveWeapons(player,{{}, true}, function(removedwep)

                  for k,v in pairs(weapons) do
                      LUNA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                      if v.ammo > 0 then
                        for i,c in pairs(LUNAAmmoTypes) do
                          for a,d in pairs(c) do
                              if d == k then  
                                  LUNA.giveInventoryItem(user_id, i, v.ammo, true)
                              end
                          end   
                        end
                      end
                  end
                  LUNAclient.notify(player,{"~g~Weapons Stored"})
                  TriggerEvent('LUNA:RefreshInventory', source)
                  SetTimeout(10000,function()
                      isStoring[player] = nil 
                  end)
            end)
          else
            LUNAclient.notify(player,{'~r~You do not have enough Weight to store Weapons.'})
          end
  end)
end
local StoreweaponCoolDown = 0

RegisterCommand('storeallweapons', function(source)
  if StoreweaponCoolDown == 0 then
    StoreweaponCoolDown = 3
    choice_store_weapons(source)
  else 
    LUNAclient.notify(source,{"~r~Store weapon cooldown. Please wait"})
  end
end)

Citizen.CreateThread(function()
  while true do
      if StoreweaponCoolDown > 0 then
        StoreweaponCoolDown = StoreweaponCoolDown - 1
      end
      Wait(1000)
  end
end)

-- add choices to the menu
LUNA.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    local choices = {}

    if LUNA.hasPermission(user_id,"police.armoury") then
      -- build police menu
      choices[lang.police.title()] = {function(player,choice)
        LUNA.buildMenu("police", {player = player}, function(menu)
          menu.name = lang.police.title()
          menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

          if LUNA.hasPermission(user_id,"police.handcuff") then
            menu[lang.police.menu.handcuff.title()] = choice_handcuff
          end

          if LUNA.hasPermission(user_id,"police.putinveh") then
            menu[lang.police.menu.putinveh.title()] = choice_putinveh
          end

          if LUNA.hasPermission(user_id,"police.getoutveh") then
            menu[lang.police.menu.getoutveh.title()] = choice_getoutveh
          end

          if LUNA.hasPermission(user_id,"police.check") then
            menu[lang.police.menu.check.title()] = choice_check
          end

          if LUNA.hasPermission(user_id,"police.seize.weapons") then
            menu[lang.police.menu.seize.weapons.title()] = choice_seize_weapons
          end

          if LUNA.hasPermission(user_id,"police.seize.items") then
            menu[lang.police.menu.seize.items.title()] = choice_seize_items
          end

          if LUNA.hasPermission(user_id,"police.jail") then
            menu[lang.police.menu.jail.title()] = choice_jail
          end

          if LUNA.hasPermission(user_id,"police.fine") then
            menu[lang.police.menu.fine.title()] = choice_fine
          end

          LUNA.openMenu(player,menu)
        end)
      end}
    end

    if LUNA.hasPermission(user_id,"police.askid") then
      choices[lang.police.menu.askid.title()] = choice_askid
    end


    add(choices)
  end
end)

local function build_client_points(source)
  -- PC
  for k,v in pairs(cfg.pcs) do
    local x,y,z = table.unpack(v)
    LUNAclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,125,255,125,150})
    LUNA.setArea(source,"LUNA:police:pc"..k,x,y,z,1,1.5,pc_enter,pc_leave)
  end
end

-- build police points
AddEventHandler("LUNA:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_points(source)
  end
end)

-- WANTED SYNC

local wantedlvl_players = {}

function LUNA.getUserWantedLevel(user_id)
  return wantedlvl_players[user_id] or 0
end

-- receive wanted level
function tLUNA.updateWantedLevel(level)
  local player = source
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    local was_wanted = (LUNA.getUserWantedLevel(user_id) > 0)
    wantedlvl_players[user_id] = level
    local is_wanted = (level > 0)

    -- send wanted to listening service
    if not was_wanted and is_wanted then
      LUNAclient.getPosition(player, {}, function(x,y,z)
        LUNA.sendServiceAlert(nil, cfg.wanted.service,x,y,z,lang.police.wanted({level}))
      end)
    end

    if was_wanted and not is_wanted then
      LUNAclient.removeNamedBlip(-1, {"LUNA:wanted:"..user_id}) -- remove wanted blip (all to prevent phantom blip)
    end
  end
end

-- delete wanted entry on leave
AddEventHandler("LUNA:playerLeave", function(user_id, player)
  wantedlvl_players[user_id] = nil
  LUNAclient.removeNamedBlip(-1, {"LUNA:wanted:"..user_id})  -- remove wanted blip (all to prevent phantom blip)
end)

-- display wanted positions
local function task_wanted_positions()
  local listeners = LUNA.getUsersByPermission("police.wanted")
  for k,v in pairs(wantedlvl_players) do -- each wanted player
    local player = LUNA.getUserSource(tonumber(k))
    if player ~= nil and v ~= nil and v > 0 then
      LUNAclient.getPosition(player, {}, function(x,y,z)
        for l,w in pairs(listeners) do -- each listening player
          local lplayer = LUNA.getUserSource(w)
          if lplayer ~= nil then
            LUNAclient.setNamedBlip(lplayer, {"LUNA:wanted:"..k,x,y,z,cfg.wanted.blipid,cfg.wanted.blipcolor,lang.police.wanted({v})})
          end
        end
      end)
    end
  end

  SetTimeout(5000, task_wanted_positions)
end
task_wanted_positions()
