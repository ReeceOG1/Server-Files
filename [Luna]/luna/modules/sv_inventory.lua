local Tunnel = module("luna", "lib/Tunnel")
local Proxy = module("luna", "lib/Proxy")
local LUNA = Proxy.getInterface("LUNA")
local LUNAclient = Tunnel.getInterface("LUNA","LUNA") -- server -> client tunnel
local Inventory = module("luna-vehicles", "cfg/cfg_inventory")
local Housing = module("LUNA-Core", "cfg/cfg_homes")
local InventorySpamTrack = {} -- Stops inventory being spammed by users.
local LootBagEntities = {}
local InventoryCoolDown = {}
local houseName = ""


RegisterNetEvent('LUNA:FetchPersonalInventory')
AddEventHandler('LUNA:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local UserId = LUNA.getUserId({source}) 
        local data = LUNA.getUserDataTable({UserId})
        if data and data.inventory then
            local FormattedInventoryData = {}
            --print(json.encode(data.inventory))
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
            end
            TriggerClientEvent('LUNA:FetchPersonalInventory', source, FormattedInventoryData, LUNA.computeItemsWeight({data.inventory}), LUNA.getInventoryMaxWeight({UserId}))
            InventorySpamTrack[source] = false;
        else 
            -- print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('LUNA:RefreshInventory', function(source)
    local UserId = LUNA.getUserId({source}) 
    local data = LUNA.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
        end
        TriggerClientEvent('LUNA:FetchPersonalInventory', source, FormattedInventoryData, LUNA.computeItemsWeight({data.inventory}), LUNA.getInventoryMaxWeight({UserId}))
    else 
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('LUNA:GiveItem')
AddEventHandler('LUNA:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  LUNAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        LUNA.RunGiveTask({source, itemId})
    else
        LUNAclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('LUNA:TrashItem')
AddEventHandler('LUNA:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  LUNAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        LUNA.RunTrashTask({source, itemId})
    else
        LUNAclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterServerEvent("LUNA:flashLights")
AddEventHandler("LUNA:flashLights", function(nearestVeh)
    local nearestVeh = nearestVeh
    TriggerClientEvent("LUNA:flashCarLightsAlarm", -1, nearestVeh)

end) 

RegisterNetEvent('LUNA:FetchTrunkInventory')
AddEventHandler('LUNA:FetchTrunkInventory', function(spawnCode, vehid)
    local source = source
    local idz = NetworkGetEntityFromNetworkId(vehid)
    local user_id = LUNA.getUserId({NetworkGetEntityOwner(idz)})
    if InventoryCoolDown[source] then LUNAclient.notify(source, {'~r~The server is having trouble caching the boot linked with your ID. Please rejoin.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    LUNA.getSData({carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
    end})
end)

RegisterNetEvent('LUNA:FetchHouseInventory')
AddEventHandler('LUNA:FetchHouseInventory', function(nameHouse)
    local source = source
    houseName = nameHouse
    local user_id = LUNA.getUserId({source})
    local homeformat = "chest:u" .. user_id .. "home" ..houseName
    --print(homeformat)
    LUNA.getSData({homeformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
        end
        local maxVehKg = Housing.chestsize[houseName] or 500
      
        TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
    
    end})
end)



RegisterNetEvent('LUNA:LockPick')
AddEventHandler('LUNA:LockPick', function()
    local user_id = LUNA.getUserId({source})
    if LUNA.tryGetInventoryItem({user_id, "lockpick", 1, true}) then
        TriggerClientEvent('LUNA:whatIsThis', source)
    end  
end)

RegisterNetEvent('LUNA:UseItem')
AddEventHandler('LUNA:UseItem', function(itemId, itemLoc)
    local source = source
    if not itemId then    LUNAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        LUNA.RunInventoryTask({source, itemId})
    else
        LUNAclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)

RegisterNetEvent('LUNA:UseAllItem')
AddEventHandler('LUNA:UseAllItem', function(itemId, itemLoc)
    local source = source
    if not itemId then    
        LUNAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        LUNA.RunInventoryTask({source, itemId})
    else
        LUNAclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('LUNA:MoveItem')
AddEventHandler('LUNA:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = LUNA.getUserId({source}) 
    local data = LUNA.getUserDataTable({UserId})
    if InventoryCoolDown[source] then LUNAclient.notify(source, {'~r~Inventory Cooldown.'}) return end
    if not itemId then  LUNAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            --InventoryCoolDown[source] = true;
            local Quantity = parseInt(1)
            if Quantity then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                LUNA.getSData({carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount >= 1 then
                        local weightCalculation = LUNA.getInventoryWeight({UserId})+LUNA.getItemWeight({itemId})
                        if weightCalculation <= LUNA.getInventoryMaxWeight({UserId}) then
                            if cdata[itemId].amount > 1 then
                                cdata[itemId].amount = cdata[itemId].amount - 1; 
                                LUNA.giveInventoryItem({UserId, itemId, 1, true})
                            else 
                                cdata[itemId] = nil;
                                LUNA.giveInventoryItem({UserId, itemId, 1, true})
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('LUNA:RefreshInventory', source)
                            --InventoryCoolDown[source] = false;
                            LUNA.setSData({carformat, json.encode(cdata)})
                        else 
                            --InventoryCoolDown[source] = false;
                            LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        --InventoryCoolDown[source] = false;
                        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                    end
                end})
            end
        elseif inventoryType == "LootBag" then  
            if LootBagEntities[inventoryInfo] ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = LUNA.getInventoryWeight({UserId})+LUNA.getItemWeight({itemId})
                    if weightCalculation <= LUNA.getInventoryMaxWeight({UserId}) then
                        if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                            LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                            LUNA.giveInventoryItem({UserId, itemId, 1, true})
                        else 
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            LUNA.giveInventoryItem({UserId, itemId, 1, true})
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                        TriggerEvent('LUNA:RefreshInventory', source)
                    else 
                        LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            else
                LUNAclient.notify(source,{"~r~This item isn't available!"})
            end
        elseif inventoryType == "Housing" then
            local Quantity = parseInt(1)
            if Quantity then
                local homeformat = "chest:u" .. UserId .. "home" ..houseName
                LUNA.getSData({homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and cdata[itemId].amount >= 1 then
                        local weightCalculation = LUNA.getInventoryWeight({UserId})+LUNA.getItemWeight({itemId})
                        if weightCalculation <= LUNA.getInventoryMaxWeight({UserId}) then
                            if cdata[itemId].amount > 1 then
                                cdata[itemId].amount = cdata[itemId].amount - 1; 
                                LUNA.giveInventoryItem({UserId, itemId, 1, true})
                            else 
                                cdata[itemId] = nil;
                                LUNA.giveInventoryItem({UserId, itemId, 1, true})
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                            end
                            local maxVehKg = Housing.chestsize[houseName] or 500
                            --local maxVehKg = 500
                            TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                            TriggerEvent('LUNA:RefreshInventory', source)
                            LUNA.setSData({homeformat, json.encode(cdata)})
                        else 
                            LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                    end
                end})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    --InventoryCoolDown[source] = true;
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                        LUNA.getSData({homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = LUNA.computeItemsWeight({cdata})+LUNA.getItemWeight({itemId})
                                local maxVehKg = Housing.chestsize[houseName] or 500
                                if weightCalculation <= maxVehKg then
                                    if LUNA.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Housing.chestsize[houseName] or 500
                                    TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LUNA:RefreshInventory', source)
                                    LUNA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                                else 
                                    LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end}) --end of housing intergration (moveitem)
                    else
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        LUNA.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = LUNA.computeItemsWeight({cdata})+LUNA.getItemWeight({itemId})
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if LUNA.tryGetInventoryItem({UserId, itemId, 1, true}) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LUNA:RefreshInventory', source)
                                    --InventoryCoolDown[source] = nil;
                                    LUNA.setSData({carformat, json.encode(cdata)})
                                else 
                                    --InventoryCoolDown[source] = nil;
                                    LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --InventoryCoolDown[source] = nil;
                                -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end})
                    end
                else
                    --InventoryCoolDown[source] = nil;
                    -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --InventoryCoolDown[source] = nil;
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)



RegisterNetEvent('LUNA:MoveItemX')
AddEventHandler('LUNA:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local UserId = LUNA.getUserId({source}) 
    local data = LUNA.getUserDataTable({UserId})
    if InventoryCoolDown[source] then LUNAclient.notify(source, {'~r~Inventory Cooldown.'}) return end
    if not itemId then  LUNAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            --InventoryCoolDown[source] = true;
            TriggerClientEvent('LUNA:ToggleNUIFocus', source, false)
            LUNA.prompt({source, 'How many ' .. LUNA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('LUNA:ToggleNUIFocus', source, true)
                if Quantity >= 1 then
                    local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                    LUNA.getSData({carformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                            local weightCalculation = LUNA.getInventoryWeight({UserId})+(LUNA.getItemWeight({itemId}) * Quantity)
                            if weightCalculation <= LUNA.getInventoryMaxWeight({UserId}) then
                                if cdata[itemId].amount > Quantity then
                                    cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                    LUNA.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    cdata[itemId] = nil;
                                    LUNA.giveInventoryItem({UserId, itemId, Quantity, true})
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('LUNA:RefreshInventory', source)
                                --InventoryCoolDown[source] = nil;
                                LUNA.setSData({carformat, json.encode(cdata)})
                            else 
                                --InventoryCoolDown[source] = nil;
                                LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            --InventoryCoolDown[source] = nil;
                            LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end})
                else
                    --InventoryCoolDown[source] = nil;
                    LUNAclient.notify(source, {'~r~Invalid Amount!'})
                end
            end})
        elseif inventoryType == "LootBag" then 
            if LootBagEntities[inventoryInfo] ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    TriggerClientEvent('LUNA:ToggleNUIFocus', source, false)
                    LUNA.prompt({source, 'How many ' .. LUNA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                        Quantity = parseInt(Quantity)
                        TriggerClientEvent('LUNA:ToggleNUIFocus', source, true)
                        if Quantity then
                            local weightCalculation = LUNA.getInventoryWeight({UserId})+(LUNA.getItemWeight({itemId}) * Quantity)
                            if weightCalculation <= LUNA.getInventoryMaxWeight({UserId}) then
                                if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                                    if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                        LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                        LUNA.giveInventoryItem({UserId, itemId, Quantity, true})
                                    else 
                                        LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                        LUNA.giveInventoryItem({UserId, itemId, Quantity, true})
                                    end
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                    end
                                    local maxVehKg = 200
                                    TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                                    TriggerEvent('LUNA:RefreshInventory', source)
                                else 
                                    LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end 
                            else 
                                LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            LUNAclient.notify(source, {'~r~Invalid input!'})
                        end
                    end})
                else
                    LUNAclient.notify(source,{"~r~This item isn't available!"})
                end
            end
        elseif inventoryType == "Housing" then
            TriggerClientEvent('LUNA:ToggleNUIFocus', source, false)
            LUNA.prompt({source, 'How many ' .. LUNA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                Quantity = parseInt(Quantity)
                TriggerClientEvent('LUNA:ToggleNUIFocus', source, true)
                if Quantity then
                    local homeformat = "chest:u" .. UserId .. "home" ..houseName
                    LUNA.getSData({homeformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                            local weightCalculation = LUNA.getInventoryWeight({UserId})+(LUNA.getItemWeight({itemId}) * Quantity)
                            if weightCalculation <= LUNA.getInventoryMaxWeight({UserId}) then
                                if cdata[itemId].amount > Quantity then
                                    cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                    LUNA.giveInventoryItem({UserId, itemId, Quantity, true})
                                else 
                                    cdata[itemId] = nil;
                                    LUNA.giveInventoryItem({UserId, itemId, Quantity, true})
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                end
                                local maxVehKg = Housing.chestsize[houseName] or 500
                                TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                                TriggerEvent('LUNA:RefreshInventory', source)
                                LUNA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                            else 
                                LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end})
                else 
                    LUNAclient.notify(source, {'~r~Invalid input!'})
                end
            end})
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    --InventoryCoolDown[source] = true;
                    TriggerClientEvent('LUNA:ToggleNUIFocus', source, false)
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        TriggerClientEvent('LUNA:ToggleNUIFocus', source, false)
                        LUNA.prompt({source, 'How many ' .. LUNA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('LUNA:ToggleNUIFocus', source, true)
                            if Quantity then
                                local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                                LUNA.getSData({homeFormat, function(cdata)
                                    cdata = json.decode(cdata) or {}
                                    if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                        local weightCalculation = LUNA.computeItemsWeight({cdata})+(LUNA.getItemWeight({itemId}) * Quantity)
                                        local maxVehKg = Housing.chestsize[houseName] or 500
                                        if weightCalculation <= maxVehKg then
                                            if LUNA.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                                if cdata[itemId] then
                                                    cdata[itemId].amount = cdata[itemId].amount + Quantity
                                                else 
                                                    cdata[itemId] = {}
                                                    cdata[itemId].amount = Quantity
                                                end
                                            end 
                                            local FormattedInventoryData = {}
                                            for i, v in pairs(cdata) do
                                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                            end
                                            local maxVehKg = Housing.chestsize[houseName] or 500
                                            TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                                            TriggerEvent('LUNA:RefreshInventory', source)
                                            LUNA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                                        else 
                                            LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                        end
                                    else 
                                        LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                    end
                                end})
                            else 
                                LUNAclient.notify(source, {'~r~Invalid input!'})
                            end
                        end}) --end of housing intergration (moveitemx)
                    else
                        LUNA.prompt({source, 'How many ' .. LUNA.getItemName({itemId}) .. 's. Do you want to move?', "", function(player, Quantity)
                            Quantity = parseInt(Quantity)
                            TriggerClientEvent('LUNA:ToggleNUIFocus', source, true)
                            if Quantity then
                                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                                LUNA.getSData({carformat, function(cdata)
                                    cdata = json.decode(cdata) or {}
                                    if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                        local weightCalculation = LUNA.computeItemsWeight({cdata})+(LUNA.getItemWeight({itemId}) * Quantity)
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        if weightCalculation <= maxVehKg then
                                            if LUNA.tryGetInventoryItem({UserId, itemId, Quantity, true}) then
                                                if cdata[itemId] then
                                                    cdata[itemId].amount = cdata[itemId].amount + Quantity
                                                else 
                                                    cdata[itemId] = {}
                                                    cdata[itemId].amount = Quantity
                                                end
                                            end 
                                            local FormattedInventoryData = {}
                                            for i, v in pairs(cdata) do
                                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                            end
                                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                            TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                                            TriggerEvent('LUNA:RefreshInventory', source)
                                            --InventoryCoolDown[source] = nil;
                                            LUNA.setSData({carformat, json.encode(cdata)})
                                        else 
                                            --InventoryCoolDown[source] = nil;
                                            LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                        end
                                    else 
                                        --InventoryCoolDown[source] = nil;
                                        LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                    end
                                end})
                            else 
                                LUNAclient.notify(source, {'~r~Invalid input!'})
                            end
                        end})
                    end
                else
                    -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('LUNA:MoveItemAll')
AddEventHandler('LUNA:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local UserId = LUNA.getUserId({source}) 
    local data = LUNA.getUserDataTable({UserId})
    if not itemId then  LUNAclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then LUNAclient.notify(source, {'~r~Inventory Cooldown.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            --InventoryCoolDown[source] = true;
            local idz = NetworkGetEntityFromNetworkId(vehid)
            local user_id = LUNA.getUserId({NetworkGetEntityOwner(idz)})
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            LUNA.getSData({carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = LUNA.getInventoryWeight({user_id})+(LUNA.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= LUNA.getInventoryMaxWeight({user_id}) then
                        LUNA.giveInventoryItem({user_id, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('LUNA:RefreshInventory', source)
                        --InventoryCoolDown[source] = nil;
                        LUNA.setSData({carformat, json.encode(cdata)})
                    else 
                        --InventoryCoolDown[source] = nil;
                        LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    --InventoryCoolDown[source] = nil;
                    LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "LootBag" then 
            if LootBagEntities[inventoryInfo] ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = LUNA.getInventoryWeight({UserId})+(LUNA.getItemWeight({itemId}) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                    if weightCalculation <= LUNA.getInventoryMaxWeight({UserId}) then
                        if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            LUNA.giveInventoryItem({UserId, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true})
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({LootBagEntities[inventoryInfo].Items}), maxVehKg)                
                            TriggerEvent('LUNA:RefreshInventory', source)
                        else 
                            LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            else
                LUNAclient.notify(source,{"~r~This item isn't available!"})
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. UserId .. "home" ..houseName
            LUNA.getSData({homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = LUNA.getInventoryWeight({UserId})+(LUNA.getItemWeight({itemId}) * cdata[itemId].amount)
                    if weightCalculation <= LUNA.getInventoryMaxWeight({UserId}) then
                        LUNA.giveInventoryItem({UserId, itemId, cdata[itemId].amount, true})
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                        end
                        local maxVehKg = Housing.chestsize[houseName] or 500
                        TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                        TriggerEvent('LUNA:RefreshInventory', source)
                        LUNA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                    else 
                        LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end})
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    --InventoryCoolDown[source] = true;
                    if inventoryInfo == "home" then --start of housing intergration (moveitemall)
                        local homeFormat = "chest:u" .. UserId .. "home" ..houseName
                        LUNA.getSData({homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local weightCalculation = LUNA.computeItemsWeight({cdata})+(LUNA.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                local maxVehKg = Housing.chestsize[houseName] or 500
                                if weightCalculation <= maxVehKg then
                                    if LUNA.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = data.inventory[itemId].amount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Housing.chestsize[houseName] or 500
                                    TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LUNA:RefreshInventory', source)
                                    LUNA.setSData({"chest:u" .. UserId .. "home" ..houseName, json.encode(cdata)})
                                else 
                                    LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end}) --end of housing intergration (moveitemall)
                    else 
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. UserId
                        LUNA.getSData({carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local weightCalculation = LUNA.computeItemsWeight({cdata})+(LUNA.getItemWeight({itemId}) * data.inventory[itemId].amount)
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if LUNA.tryGetInventoryItem({UserId, itemId, data.inventory[itemId].amount, true}) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + data.inventory[itemId].amount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = data.inventory[itemId].amount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({cdata}), maxVehKg)
                                    TriggerEvent('LUNA:RefreshInventory', source)
                                    --InventoryCoolDown[source] = nil;
                                    LUNA.setSData({carformat, json.encode(cdata)})
                                else 
                                    --InventoryCoolDown[source] = nil;
                                    LUNAclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --InventoryCoolDown[source] = nil;
                                LUNAclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end})
                    end
                else
                    --InventoryCoolDown[source] = nil;
                    -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --InventoryCoolDown[source] = nil;
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to move an item. Inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('LUNA:InComa')
AddEventHandler('LUNA:InComa', function()
    local source = source
    local user_id = LUNA.getUserId({source})
    LUNAclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(3000)
           
            local weight = LUNA.getInventoryWeight({user_id})

            if LUNA.hasPermission({user_id, "police.armoury"}) or weight == 0 then 
                return 
            end

            local model = GetHashKey('ch_prop_ch_bag_02a')
            local name1 = GetPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)), true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            --PlaceObjectOnGroundProperly(lootbag)
            local ndata = LUNA.getUserDataTable({user_id})
            local stored_inventory = nil;

            TriggerEvent('LUNA:StoreWeaponsRequest', source)

            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
         
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    LUNA.clearInventory({user_id})
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)

RegisterNetEvent('LUNA:LootBag')
AddEventHandler('LUNA:LootBag', function(netid)
    local source = source
    LUNAclient.isInComa(source, {}, function(in_coma) 
        if not in_coma then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = LUNA.getUserId({source})
                if user_id ~= nil then
                    TriggerClientEvent("luna:PlaySound", source, "zipper")
                    LootBagEntities[netid][5] = source

                    if LUNA.hasPermission({user_id, "police.armoury"}) then
                        LUNA.clearInventory({LootBagEntities[netid].id})
                        LUNAclient.notify(source,{"~r~You have seized ~y~" .. LootBagEntities[netid].name .. "'s ~r~items"})

                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end  
                end
            else
                LUNAclient.notify(source, {'~r~This loot bag is unavailable.'})
            end
        else 
            LUNAclient.notify(source, {'~r~You cannot open this while dead silly.'})
        end
    end)
end)

Citizen.CreateThread(function()
    while true do 
        Wait(250)
        for i,v in pairs(LootBagEntities) do 
            if v[5] then 
                local coords = GetEntityCoords(GetPlayerPed(v[5]))
                local objectcoords = GetEntityCoords(v[1])
                if #(objectcoords - coords) > 5.0 then
                    CloseInv(v[5])
                    Wait(3000)
                    v[3] = false; 
                    v[5] = nil;
                end
            end
        end
    end
end)

RegisterNetEvent('LUNA:CloseLootbag')
AddEventHandler('LUNA:CloseLootbag', function()
    local source = source
    for i,v in pairs(LootBagEntities) do 
        if v[5] and v[5] == source then 
            CloseInv(v[5])
            Wait(3000)
            v[3] = false; 
            v[5] = nil;
        end
    end
end)

function CloseInv(source)
    TriggerClientEvent('LUNA:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local UserId = LUNA.getUserId({source})
    local data = LUNA.getUserDataTable({UserId})
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
        end
        TriggerClientEvent('LUNA:FetchPersonalInventory', source, FormattedInventoryData, LUNA.computeItemsWeight({data.inventory}), LUNA.getInventoryMaxWeight({UserId}))
        InventorySpamTrack[source] = false;
    else 
        -- print('[^7JamesUKInventory]^1: An error has occured while trying to fetch inventory data from: ' .. UserId .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('LUNA:InventoryOpen', source, true, true)
    local FormattedInventoryData = {}

    if LUNA.hasPermission({UserId, "police.armoury"}) then
        for i,v in pairs(LootBagEntities) do 
            if DoesEntityExist(v[1]) then 
                DeleteEntity(v[1])
                -- print('Deleted Lootbag')
                LootBagEntities[i] = nil;
            end
        end
    else
        for i, v in pairs(LootBagItems) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = LUNA.getItemName({i}), Weight = LUNA.getItemWeight({i})}
        end
        local maxVehKg = 200
        TriggerClientEvent('LUNA:SendSecondaryInventoryData', source, FormattedInventoryData, LUNA.computeItemsWeight({LootBagItems}), maxVehKg)

        LUNAclient.notify(source,{"~g~You have opened ~y~" .. LootBagEntities[netid].name .. "'s ~g~lootbag"})
    end
    -- print(json.encode(FormattedInventoryData))
end


-- Garabge collector for empty lootbags.
Citizen.CreateThread(function()
    while true do 
        Wait(500)
        for i,v in pairs(LootBagEntities) do 
            local itemCount = 0;
            for i,v in pairs(v.Items) do
                itemCount = itemCount + 1
            end
            if itemCount == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    --print('Deleted Lootbag')
                    LootBagEntities[i] = nil;
                end
            end
        end
        --print('All Lootbag garbage collected.')
    end
end)