local lang = LUNA.lang
local cfg = module("luna-vehicles", "cfg/cfg_inventory")

-- this module define the player inventory (lost after respawn, as wallet)

LUNA.items = {}

-- define an inventory item (call this at server start) (parametric or plain text data)
-- idname: unique item name
-- name: display name or genfunction
-- description: item description (html) or genfunction
-- choices: menudata choices (see gui api) only as genfunction or nil
-- weight: weight or genfunction
--
-- genfunction are functions returning a correct value as: function(args) return value end
-- where args is a list of {base_idname,arg,arg,arg,...}
function LUNA.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  LUNA.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil then
      -- prompt number
      LUNA.prompt(player,lang.inventory.trash.prompt({LUNA.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if LUNA.tryGetInventoryItem(user_id,idname,amount,false) then
          LUNAclient.notify(player,{lang.inventory.trash.done({LUNA.getItemName(idname),amount})})
          LUNAclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          LUNAclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end

-- give action
function ch_give(idname, player, choice)
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    -- get nearest player
    LUNAclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = LUNA.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          LUNA.prompt(player,lang.inventory.give.prompt({LUNA.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
            local amount = parseInt(amount)
            -- weight check
            local new_weight = LUNA.getInventoryWeight(nuser_id)+LUNA.getItemWeight(idname)*amount
            if new_weight <= LUNA.getInventoryMaxWeight(nuser_id) then
              if LUNA.tryGetInventoryItem(user_id,idname,amount,true) then
                LUNA.giveInventoryItem(nuser_id,idname,amount,true)

                LUNAclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                LUNAclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
              else
                LUNAclient.notify(player,{lang.common.invalid_value()})
              end
            else
              LUNAclient.notify(player,{lang.inventory.full()})
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
end

-- trash action
function ch_trash(idname, player, choice)
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    LUNA.prompt(player,lang.inventory.trash.prompt({LUNA.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
      local amount = parseInt(amount)
      if LUNA.tryGetInventoryItem(user_id,idname,amount,false) then
        LUNAclient.notify(player,{lang.inventory.trash.done({LUNA.getItemName(idname),amount})})
        LUNAclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
      else
        LUNAclient.notify(player,{lang.common.invalid_value()})
      end
    end)
  end
end

function LUNA.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function LUNA.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function LUNA.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function LUNA.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function LUNA.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function LUNA.getItemDefinition(idname)
  local args = LUNA.parseItem(idname)
  local item = LUNA.items[args[1]]
  if item ~= nil then
    return LUNA.computeItemName(item,args), LUNA.computeItemDescription(item,args), LUNA.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function LUNA.getItemName(idname)
  local args = LUNA.parseItem(idname)
  local item = LUNA.items[args[1]]
  if item ~= nil then return LUNA.computeItemName(item,args) end
  return args[1]
end

function LUNA.getItemDescription(idname)
  local args = LUNA.parseItem(idname)
  local item = LUNA.items[args[1]]
  if item ~= nil then return LUNA.computeItemDescription(item,args) end
  return ""
end

function LUNA.getItemChoices(idname)
  local args = LUNA.parseItem(idname)
  local item = LUNA.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = LUNA.computeItemChoices(item,args)
    if cchoices then -- copy computed choices
      for k,v in pairs(cchoices) do
        choices[k] = v
      end
    end

    -- add give/trash choices
    choices[lang.inventory.give.title()] = {function(player,choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.trash.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.trash.description()}
  end

  return choices
end

function LUNA.getItemWeight(idname)
  local args = LUNA.parseItem(idname)
  local item = LUNA.items[args[1]]
  if item ~= nil then return LUNA.computeItemWeight(item,args) end
  return 0
end

-- compute weight of a list of items (in inventory/chest format)
function LUNA.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = LUNA.getItemWeight(k)
    weight = weight+iweight*v.amount
  end

  return weight
end

-- add item to a connected user inventory
function LUNA.giveInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = LUNA.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end

    -- notify
    if notify then
      local player = LUNA.getUserSource(user_id)
      if player ~= nil then
        LUNAclient.notify(player,{lang.inventory.give.received({LUNA.getItemName(idname),amount})})
      end
    end
  end
end

-- try to get item from a connected user inventory
function LUNA.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = LUNA.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil 
      end

      -- notify
      if notify then
        local player = LUNA.getUserSource(user_id)
        if player ~= nil then
          LUNAclient.notify(player,{lang.inventory.give.given({LUNA.getItemName(idname),amount})})
        end
      end

      return true
    else
      -- notify
      if notify then
        local player = LUNA.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          LUNAclient.notify(player,{lang.inventory.missing({LUNA.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function LUNA.getInventoryItemAmount(user_id,idname)
  local data = LUNA.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function LUNA.getInventoryWeight(user_id)
  local data = LUNA.getUserDataTable(user_id)
  if data and data.inventory then
    return LUNA.computeItemsWeight(data.inventory)
  end

  return 0
end

-- -- return maximum weight of the user inventory
-- function LUNA.getInventoryMaxWeight(user_id)
--   if user_id == 1  then 
--     return 100
--   else
--  return cfg.inventory_weight_per_strength
--   end
-- end

-- clear connected user inventory
function LUNA.clearInventory(user_id)
  local data = LUNA.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end

-- INVENTORY MENU

-- open player inventory
function LUNA.openInventory(source)
  local user_id = LUNA.getUserId(source)

  if user_id ~= nil then
    local data = LUNA.getUserDataTable(user_id)
    if data then
      -- build inventory menu
      local menudata = {name=lang.inventory.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}
      -- add inventory info
      local weight = LUNA.getInventoryWeight(user_id)
      local max_weight = LUNA.getInventoryMaxWeight(user_id)
      local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
      menudata["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}
      local kitems = {}

      -- choose callback, nested menu, create the item menu
      local choose = function(player,choice)
        if string.sub(choice,1,1) ~= "@" then -- ignore info choices
        local choices = LUNA.getItemChoices(kitems[choice])
          -- build item menu
          local submenudata = {name=choice,css={top="75px",header_color="rgba(0,125,255,0.75)"}}

          -- add computed choices
          for k,v in pairs(choices) do
            submenudata[k] = v
          end

          -- nest menu
          submenudata.onclose = function()
            LUNA.openInventory(source) -- reopen inventory when submenu closed
          end

          -- open menu
          LUNA.openMenu(source,submenudata)
        end
      end

      -- add each item to the menu
      for k,v in pairs(data.inventory) do 
        local name,description,weight = LUNA.getItemDefinition(k)
        if name ~= nil then
          kitems[name] = k -- reference item by display name
          menudata[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f",weight)})}
        end
      end

      -- open menu
      LUNA.openMenu(source,menudata)
    end
  end
end

-- init inventory
AddEventHandler("LUNA:playerJoin", function(user_id,source,name,last_login)
  local data = LUNA.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}

    if LUNA.computeItemsWeight(data.inventory) > 15 then
      TriggerClientEvent("equipBackpack", source)
    else
      TriggerClientEvent("removeBackpack", source)
    end
  end
end)


-- add open inventory to main menu
local choices = {}
choices[lang.inventory.title()] = {function(player, choice) LUNA.openInventory(player) end, lang.inventory.description()}

LUNA.registerMenuBuilder("main", function(add, data)
  add(choices)
end)

-- CHEST SYSTEM

local chests = {}

-- build a menu from a list of items and bind a callback(idname)
local function build_itemlist_menu(name, items, cb)
  local menu = {name=name, css={top="75px",header_color="rgba(0,255,125,0.75)"}}

  local kitems = {}

  -- choice callback
  local choose = function(player,choice)
    local idname = kitems[choice]
    if idname then
      cb(idname)
    end
  end

  -- add each item to the menu
  for k,v in pairs(items) do 
    local name,description,weight = LUNA.getItemDefinition(k)
    if name ~= nil then
      kitems[name] = k -- reference item by display name
      menu[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f", weight)})}
    end
  end

  return menu
end

-- open a chest by name
-- cb_close(): called when the chest is closed (optional)
-- cb_in(idname, amount): called when an item is added (optional)
-- cb_out(idname, amount): called when an item is taken (optional)
function LUNA.openChest(source, name, max_weight, cb_close, cb_in, cb_out)
  local user_id = LUNA.getUserId(source)
  if user_id ~= nil then
    local data = LUNA.getUserDataTable(user_id)
    if data.inventory ~= nil then
      if not chests[name] then
        local close_count = 0 -- used to know when the chest is closed (unlocked)

        -- load chest
        local chest = {max_weight = max_weight}
        chests[name] = chest 
        LUNA.getSData("chest:"..name, function(cdata)
          chest.items = json.decode(cdata) or {} -- load items

          -- open menu
          local menu = {name=lang.inventory.chest.title(), css={top="75px",header_color="rgba(0,255,125,0.75)"}}
          -- take
          local cb_take = function(idname)
            local citem = chest.items[idname]
            LUNA.prompt(source, lang.inventory.chest.take.prompt({citem.amount}), "", function(player, amount)
              amount = parseInt(amount)
              if amount >= 0 and amount <= citem.amount then
                -- take item
                
                -- weight check
                local new_weight = LUNA.getInventoryWeight(user_id)+LUNA.getItemWeight(idname)*amount
                if new_weight <= LUNA.getInventoryMaxWeight(user_id) then
                  LUNA.giveInventoryItem(user_id, idname, amount, true)
                  citem.amount = citem.amount-amount

                  if citem.amount <= 0 then
                    chest.items[idname] = nil -- remove item entry
                  end

                  if cb_out then cb_out(idname,amount) end

                  -- actualize by closing
                  LUNA.closeMenu(player)
                else
                  LUNAclient.notify(source,{lang.inventory.full()})
                end
              else
                LUNAclient.notify(source,{lang.common.invalid_value()})
              end
            end)
          end

          local ch_take = function(player, choice)
            local submenu = build_itemlist_menu(lang.inventory.chest.take.title(), chest.items, cb_take)
            -- add weight info
            local weight = LUNA.computeItemsWeight(chest.items)
            local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
            submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}


            submenu.onclose = function()
              close_count = close_count-1
              LUNA.openMenu(player, menu)
            end
            close_count = close_count+1
            LUNA.openMenu(player, submenu)
          end


          -- put
          local cb_put = function(idname)
            LUNA.prompt(source, lang.inventory.chest.put.prompt({LUNA.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
              amount = parseInt(amount)

              -- weight check
              local new_weight = LUNA.computeItemsWeight(chest.items)+LUNA.getItemWeight(idname)*amount
              if new_weight <= max_weight then
                if amount >= 0 and LUNA.tryGetInventoryItem(user_id, idname, amount, true) then
                  local citem = chest.items[idname]

                  if citem ~= nil then
                    citem.amount = citem.amount+amount
                  else -- create item entry
                    chest.items[idname] = {amount=amount}
                  end

                  -- callback
                  if cb_in then cb_in(idname,amount) end

                  -- actualize by closing
                  LUNA.closeMenu(player)
                end
              else
                LUNAclient.notify(source,{lang.inventory.chest.full()})
              end
            end)
          end

          local ch_put = function(player, choice)
            local submenu = build_itemlist_menu(lang.inventory.chest.put.title(), data.inventory, cb_put)
            -- add weight info
            local weight = LUNA.computeItemsWeight(data.inventory)
            local max_weight = LUNA.getInventoryMaxWeight(user_id)
            local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
            submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}

            submenu.onclose = function() 
              close_count = close_count-1
              LUNA.openMenu(player, menu) 
            end
            close_count = close_count+1
            LUNA.openMenu(player, submenu)
          end


          -- choices
          menu[lang.inventory.chest.take.title()] = {ch_take}
          menu[lang.inventory.chest.put.title()] = {ch_put}

          menu.onclose = function()
            if close_count == 0 then -- close chest
              -- save chest items
              LUNA.setSData("chest:"..name, json.encode(chest.items))
              chests[name] = nil
              if cb_close then cb_close() end -- close callback
            end
          end

          -- Ugly patch to close the "already opened" chest. 
			    SetTimeout(300000, function()
            if not close_count == 0 then
			        close_count = 0
              LUNA.setSData("chest:"..name, json.encode(chest.items))
              chests[name] = nil
			      end
          end)
          -- Ugly patch to close the "already opened" chest.

          -- open menu
          LUNA.openMenu(source, menu)
        end)
      else
        LUNAclient.notify(source,{lang.inventory.chest.already_opened()})
      end
    end
  end
end