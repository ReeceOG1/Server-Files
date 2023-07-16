-- -- a basic garage implementation
-- -- vehicle db
local lang = LUNA.lang
local cfg = module("luna-vehicles", "cfg/cfg_garages")
local cfg_inventory = module("luna-vehicles", "cfg/cfg_inventory")
local vehicle_groups = cfg.garage_types
local limit = 500000000
MySQL.createCommand("LUNA/add_vehicle","INSERT IGNORE INTO luna_user_vehicles(user_id,vehicle,vehicle_plate) VALUES(@user_id,@vehicle,@registration)")
MySQL.createCommand("LUNA/remove_vehicle","DELETE FROM luna_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("LUNA/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate FROM luna_user_vehicles WHERE user_id = @user_id AND rented = 0")
MySQL.createCommand("LUNA/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id FROM luna_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("LUNA/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id FROM luna_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("LUNA/get_vehicle","SELECT vehicle FROM luna_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("LUNA/check_rented","SELECT * FROM luna_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("LUNA/sell_vehicle_player","UPDATE luna_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("LUNA/rentedupdate", "UPDATE luna_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("LUNA/fetch_rented_vehs", "SELECT * FROM luna_user_vehicles WHERE rented = 1")


Citizen.CreateThread(function()
    while true do
        Wait(300000)
        MySQL.query('LUNA/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('LUNA/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
               end
            end
        end)
        print('[LUNA] Vehicle Rent Check | Successful')
    end
end)

RegisterNetEvent('LUNA:FetchCars')
AddEventHandler('LUNA:FetchCars', function(owned, type)
    local source = source
    local user_id = LUNA.getUserId(source)
    local returned_table = {}
    if user_id then
        if not owned then
            for i, v in pairs(vehicle_groups) do
                local noperms = false;
                local config = vehicle_groups[i]._config
                if config.vtype == type or config.vtype2 == type or config.vtype3 == type then 
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not LUNA.hasPermission(user_id, v) then
                                noperms = true;
                            end
                        end
                    end
                    if not noperms then 
                        returned_table[i] = {
                            ["config"] = config
                        }
                        returned_table[i].vehicles = {}
                        for a, z in pairs(v) do
                            if a ~= "_config" then
                                returned_table[i].vehicles[a] = {z[1], z[2]}
                            end
                        end
                    end
                end 
            end
            TriggerClientEvent('LUNA:ReturnFetchedCars', source, returned_table)
        else
            MySQL.query("LUNA/get_vehicles", {
                user_id = user_id
            }, function(pvehicles, affected, plate)
                for _, veh in pairs(pvehicles) do
                    for i, v in pairs(vehicle_groups) do
                        local noperms = false;
                        local config = vehicle_groups[i]._config
                        if config.vtype == type or config.vtype2 == type or config.vtype3 == type then 
                            local perm = config.permissions or nil
                            if perm then
                                for i, v in pairs(perm) do
                                    if not LUNA.hasPermission(user_id, v) then
                                        noperms = true;
                                    end
                                end
                            end
                            if not noperms then 
                                for a, z in pairs(v) do
                                    if a ~= "_config" and veh.vehicle == a then
                                        if not returned_table[i] then 
                                            returned_table[i] = {
                                                ["config"] = config
                                            }
                                        end
                                        if not returned_table[i].vehicles then 
                                            returned_table[i].vehicles = {}
                                        end
                                        returned_table[i].vehicles[a] = {z[1], z[2], veh.vehicle_plate} -- plate from LUNA/get_vehicles
                                    end
                                end
                            end
                        end
                    end
                end
                TriggerClientEvent('LUNA:ReturnFetchedCars', source, returned_table)
            end)
        end
    end
end)

RegisterNetEvent('LUNA:ScrapVehicle')
AddEventHandler('LUNA:ScrapVehicle', function(vehicle)
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id then 
        MySQL.query("LUNA/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("LUNA/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    LUNAclient.notify(source,{"~r~You cannot destroy a vehicle you do not own"})
                    return
                end
                if #pvehicles > 0 then 
                    LUNAclient.notify(source,{"~r~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('LUNA/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                TriggerClientEvent('LUNA:CloseGarage', source)
            end)
        end)
    end
end)

RegisterNetEvent('LUNA:SellVehicle')
AddEventHandler('LUNA:SellVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = LUNA.getUserId(source)
    if playerID ~= nil then
		LUNAclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. LUNA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				LUNA.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = LUNA.getUserSource(tonumber(user_id))
						if target ~= nil then
							LUNA.prompt(player,"Price £: ","",function(player,amount)
								if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
									MySQL.query("LUNA/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
										if #pvehicle > 0 then
											LUNAclient.notify(player,{"~r~The player already has this vehicle type."})
										else
											local tmpdata = LUNA.getUserTmpTable(playerID)
											MySQL.query("LUNA/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                if #pvehicles > 0 then 
                                                    LUNAclient.notify(player,{"~r~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    LUNA.request(target,GetPlayerName(player).." wants to sell: " ..name.. " Price: £"..amount, 10, function(target,ok)
                                                        if ok then
                                                            local pID = LUNA.getUserId(target)
                                                            amount = tonumber(amount)
                                                            if LUNA.tryFullPayment(pID,amount) then
                                                                LUNAclient.despawnGarageVehicle(player,{'car',15}) 
                                                                LUNA.getUserIdentity(pID, function(identity)
                                                                    MySQL.execute("LUNA/sell_vehicle_player", {user_id = user_id, registration = "P "..identity.registration, oldUser = playerID, vehicle = name}) 
                                                                end)
                                                                LUNA.giveBankMoney(playerID, amount)
                                                                LUNAclient.notify(player,{"~g~You have successfully sold the vehicle to ".. GetPlayerName(target).." for £"..amount.."!"})
                                                                LUNAclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully sold you the car for £"..amount.."!"})
                                                                TriggerClientEvent('LUNA:CloseGarage', player)
                                                                webhook = "https://ptb.discord.com/api/webhooks/1110524293500116992/ldoWet513NW39iNkDFCp90Ybl9NKjk7wtMCVUsc1ME_hKqvJ83yKE5ZsGaP3nU4RktPF"
       
                                                                PerformHttpRequest(webhook, function(err, text, headers) 
                                                                end, "POST", json.encode({username = "LUNA", embeds = {
                                                                    {
                                                                        ["color"] = "15158332",
                                                                        ["title"] = "Car Sale",
                                                                        ["description"] = "**Seller Name: **" .. GetPlayerName(player) .. "** \nUser ID: **" .. playerID.. "** \nPrice: **£" .. amount .. '**\nReciever ID: **' ..pID..'**\nSpawncode:** '..name,
                                                                        ["footer"] = {
                                                                            ["text"] = "Time - "..os.date("%x %X %p"),
                                                                        }
                                                                }
                                                            }}), { ["Content-Type"] = "application/json" })
                                                            else
                                                                LUNAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                LUNAclient.notify(target,{"~r~You don't have enough money!"})
                                                            end
                                                        else
                                                            LUNAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to buy the car."})
                                                            LUNAclient.notify(target,{"~r~You have refused to buy "..GetPlayerName(player).."'s car."})
                                                        end
                                                    end)
                                                end
                                            end)
										end
									end) 
								else
									LUNAclient.notify(player,{"~r~The price of the car has to be a number."})
								end
							end)
						else
							LUNAclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						LUNAclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				LUNAclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)


RegisterNetEvent('LUNA:RentVehicle')
AddEventHandler('LUNA:RentVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = LUNA.getUserId(source)
    if playerID ~= nil then
		LUNAclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. LUNA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				LUNA.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = LUNA.getUserSource(tonumber(user_id))
						if target ~= nil then
							LUNA.prompt(player,"Price £: ","",function(player,amount)
                                LUNA.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("LUNA/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    LUNAclient.notify(player,{"~r~The player already has this vehicle type."})
                                                else
                                                    local tmpdata = LUNA.getUserTmpTable(playerID)
                                                    MySQL.query("LUNA/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            LUNAclient.notify(player,{"~r~You cannot rent a rented vehicle!"})
                                                            return
                                                        else
                                                            LUNA.request(target,GetPlayerName(player).." wants to rent: " ..name.. " Price: £"..amount .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                if ok then
                                                                    local pID = LUNA.getUserId(target)
                                                                    amount = tonumber(amount)
                                                                    if LUNA.tryFullPayment(pID,amount) then
                                                                        LUNAclient.despawnGarageVehicle(player,{'car',15}) 
                                                                        LUNA.getUserIdentity(pID, function(identity)
                                                                            local rentedTime = os.time()
                                                                            rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                            MySQL.execute("LUNA/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                        end)
                                                                        LUNA.giveBankMoney(playerID, amount)
                                                                        LUNAclient.notify(player,{"~g~You have successfully rented the vehicle to ".. GetPlayerName(target).." for £"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                        LUNAclient.notify(target,{"~g~"..GetPlayerName(player).." has successfully rented you the car for £"..amount.."!" .. ' | for: ' .. rent .. 'hours'})
                                                                        TriggerClientEvent('LUNA:CloseGarage', player)
                                                                    else
                                                                        LUNAclient.notify(player,{"~r~".. GetPlayerName(target).." doesn't have enough money!"})
                                                                        LUNAclient.notify(target,{"~r~You don't have enough money!"})
                                                                    end
                                                                else
                                                                    LUNAclient.notify(player,{"~r~"..GetPlayerName(target).." has refused to rent the car."})
                                                                    LUNAclient.notify(target,{"~r~You have refused to rent "..GetPlayerName(player).."'s car."})
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            LUNAclient.notify(player,{"~r~The price of the car has to be a number."})
                                        end
                                    else 
                                        LUNAclient.notify(player,{"~r~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							LUNAclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						LUNAclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				LUNAclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)



RegisterNetEvent('LUNA:FetchVehiclesIn')
AddEventHandler('LUNA:FetchVehiclesIn', function()
    local returned_table = {}
    local source = source
    local user_id = LUNA.getUserId(source)
    MySQL.query("LUNA/get_rented_vehicles_in", {
        user_id = user_id
    }, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not LUNA.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not returned_table[i] then 
                            returned_table[i] = {
                                ["config"] = config
                            }
                        end
                        if not returned_table[i].vehicles then 
                            returned_table[i].vehicles = {}
                        end
                        local time = tonumber(veh.rentedtime) - os.time()
                        local datetime = ""
                        local date = os.date("!*t", time)
                        if date.hour >= 1 and date.min >= 1 then 
                            datetime = date.hour .. " hours and " .. date.min .. " minutes left"
                        elseif date.hour <= 1 and date.min >= 1 then 
                            datetime = date.min .. " minutes left"
                        elseif date.hour >= 1 and date.min <= 1 then 
                            datetime = date.hour .. " hours left"
                        end
                        returned_table[i].vehicles[a] = {z[1], datetime}
                    end
                end
            end
        end
        TriggerClientEvent('LUNA:ReturnFetchedCars', source, returned_table)
    end)
end)

RegisterNetEvent('LUNA:FetchVehiclesOut')
AddEventHandler('LUNA:FetchVehiclesOut', function()
    local returned_table = {}
    local source = source
    local user_id = LUNA.getUserId(source)
    MySQL.query("LUNA/get_rented_vehicles_out", {
        user_id = user_id
    }, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not LUNA.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not returned_table[i] then 
                            returned_table[i] = {
                                ["config"] = config
                            }
                        end
                        if not returned_table[i].vehicles then 
                            returned_table[i].vehicles = {}
                        end
                        local time = tonumber(veh.rentedtime) - os.time()
                        local datetime = ""
                        local date = os.date("!*t", time)
                        if date.hour >= 1 and date.min >= 1 then 
                            datetime = date.hour .. " hours and " .. date.min .. " minutes left."
                        elseif date.hour <= 1 and date.min >= 1 then 
                            datetime = date.min .. " minutes left"
                        elseif date.hour >= 1 and date.min <= 1 then 
                            datetime = date.hour .. " hours left"
                        end
                        returned_table[i].vehicles[a .. ':' .. veh.user_id] = {z[1], datetime, veh.user_id, a}
                    end
                end
            end
        end
        TriggerClientEvent('LUNA:ReturnFetchedCars', source, returned_table)
    end)
end)


local veh_actions = {}

-- open trunk
veh_actions[lang.vehicle.trunk.title()] = {function(user_id,player,vtype,name)
  local chestname = "u"..user_id.."veh_"..string.lower(name)
  local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

  -- open chest
  LUNAclient.vc_openDoor(player, {vtype,5})
  LUNA.openChest(player, chestname, max_weight, function()
    LUNAclient.vc_closeDoor(player, {vtype,5})
  end)
end, lang.vehicle.trunk.description()}

--sell2
MySQL.createCommand("LUNA/sell_vehicle_player","UPDATE luna_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")




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

-- ask trunk (open other user car chest)
local function ch_asktrunk(player,choice)
  LUNAclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = LUNA.getUserId(nplayer)
    if nuser_id ~= nil then
      LUNAclient.notify(player,{lang.vehicle.asktrunk.asked()})
      LUNA.request(nplayer,lang.vehicle.asktrunk.request(),15,function(nplayer,ok)
        if ok then -- request accepted, open trunk
          LUNAclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
            if ok then
              local chestname = "u"..nuser_id.."veh_"..string.lower(name)
              local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

              -- open chest
              local cb_out = function(idname,amount)
                LUNAclient.notify(nplayer,{lang.inventory.give.given({LUNA.getItemName(idname),amount})})
              end

              local cb_in = function(idname,amount)
                LUNAclient.notify(nplayer,{lang.inventory.give.received({LUNA.getItemName(idname),amount})})
              end

              LUNAclient.vc_openDoor(nplayer, {vtype,5})
              LUNA.openChest(player, chestname, max_weight, function()
                LUNAclient.vc_closeDoor(nplayer, {vtype,5})
              end,cb_in,cb_out)
            else
              LUNAclient.notify(player,{lang.vehicle.no_owned_near()})
              LUNAclient.notify(nplayer,{lang.vehicle.no_owned_near()})
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
end

-- repair nearest vehicle
local function attemptRepairVehicle(player)
    local user_id = LUNA.getUserId(player)
    if user_id ~= nil then
      -- anim and repair
      if LUNA.tryGetInventoryItem(user_id,"repair_kit",1,true) then
        LUNAclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
        SetTimeout(15000, function()
          LUNAclient.fixeNearestVehicle(player,{7})
          LUNAclient.stopAnim(player,{false})
        end)
      end
    end
  end

  RegisterNetEvent("LUNA:attemptRepairVehicle")
AddEventHandler("LUNA:attemptRepairVehicle", attemptRepairVehicle)

-- replace nearest vehicle
local function ch_replace(player,choice)
  LUNAclient.replaceNearestVehicle(player,{7})
end

RegisterNetEvent("returnVIP")
AddEventHandler("returnVIP", function()
    
    local source = source 
    userid = LUNA.getUserId(source)
    if LUNA.hasGroup(userid, "VIP") then 
        TriggerClientEvent("openVIP", source)
    end
end)
RegisterNetEvent("returnVIPaircraft")
AddEventHandler("returnVIPaircraft", function()
    
    local source = source 
    userid = LUNA.getUserId(source)
    if LUNA.hasGroup(userid, "VIP") then 
        TriggerClientEvent("openVIPaircraft", source)
    end
end)

RegisterServerEvent("LUNA:FetchFolders")
AddEventHandler('LUNA:FetchFolders', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    exports["ghmattimysql"]:execute("SELECT * from `luna_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            TriggerClientEvent("LUNA:ReturnFolders", source, json.decode(Result[1].folder))
        end
    end)
end)


RegisterServerEvent("LUNA:UpdateFolders")
AddEventHandler('LUNA:UpdateFolders', function(FolderUpdated)
    local source = source
    local user_id = LUNA.getUserId(source)

    exports["ghmattimysql"]:execute("SELECT * from `luna_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            exports['ghmattimysql']:execute("UPDATE luna_custom_garages SET folder = @folder WHERE user_id = @user_id", {folder = json.encode(FolderUpdated), user_id = user_id}, function() end)
        else
            exports['ghmattimysql']:execute("INSERT INTO luna_custom_garages (`user_id`, `folder`) VALUES (@user_id, @folder);", {user_id = user_id, folder = json.encode(FolderUpdated)}, function() end)
        end
    end)
end)

RegisterNetEvent("returnpolice")
AddEventHandler("returnpolice", function()
    
    local source = source 
    userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid, "police.armoury" ) then
        TriggerClientEvent("openPolice", source)
    end
end)

RegisterNetEvent("returnRebel")
AddEventHandler("returnRebel", function()
    
    local source = source 
    userid = LUNA.getUserId(source)
   if LUNA.hasGroup(userid, "rebel.guns") then 
        TriggerClientEvent("openRebel", source)
    end
end)

RegisterNetEvent("LUNA:PayVehicleTax")
AddEventHandler("LUNA:PayVehicleTax", function()
    local user_id = LUNA.getUserId(source)

    if user_id ~= nil then
        local bank = LUNA.getBankMoney(user_id)
        local payment = bank / 10000
    
       
        if bank == 0 then
            LUNAclient.notify(source,{"~r~Its fine... Tax payers will pay your vehicle tax instead."})
        elseif LUNA.tryBankPayment(user_id, payment) then
            LUNAclient.notify(source,{"~g~Paid £"..getMoneyStringFormatted(roundnumber(payment, 0)).." vehicle tax."})
        end
    end
end)

RegisterNetEvent("LUNA:DVSATAX")
AddEventHandler("LUNA:DVSATAX", function()
    local user_id = LUNA.getUserId(source)

    if user_id ~= nil then
        local bank = LUNA.getBankMoney(user_id)
        local payment = 20000
    
         if LUNA.tryBankPayment(user_id, payment) then
            LUNAclient.notify(source,{"~g~Paid £"..getMoneyStringFormatted(roundnumber(payment, 0)).." DVSA Test"})
        end
    end
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function roundnumber(P, Q)
    local R = 10 ^ (Q or 0)
    return math.floor(P * R + 0.5)
end

Citizen.CreateThread(function()
    Wait(1500)
    exports['ghmattimysql']:execute([[
        CREATE TABLE IF NOT EXISTS `luna_custom_garages` (
            `user_id` INT(11) NOT NULL AUTO_INCREMENT,
            `folder` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`user_id`) USING BTREE
        );
    ]])
end)