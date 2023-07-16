local cfg = module("cfg/player_state")
local lang = LUNA.lang

-- client -> server events
AddEventHandler("LUNA:playerSpawn", function(user_id, source, first_spawn)
    Debug.pbegin("playerSpawned_player_state")
    local player = source
    tLUNA.getFactionGroups(source)
    local data = LUNA.getUserDataTable(user_id)
    local tmpdata = LUNA.getUserTmpTable(user_id)

    if first_spawn then -- first spawn
        -- cascade load customization then weapons
        if data.customization == nil then
            data.customization = cfg.default_customization
        end

        if data.position == nil and cfg.spawn_enabled then
            local x = cfg.spawn_position[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_position[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_position[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
        end

        if data.position ~= nil then -- teleport to saved pos
            LUNAclient.teleport(source, {data.position.x, data.position.y, data.position.z})
        end

        if data.customization ~= nil then
            LUNAclient.setCustomization(source, {data.customization},
                function() -- delayed weapons/health, because model respawn
                    if data.weapons ~= nil then -- load saved weapons
                        LUNAclient.giveWeapons(source, {data.weapons, true})

                        if data.health ~= nil then -- set health
                            LUNAclient.setHealth(source, {data.health})
                            SetTimeout(5000, function() -- check coma, kill if in coma
                                LUNAclient.isInComa(player, {}, function(in_coma)
                                    LUNAclient.killComa(player, {})
                                end)
                            end)
                        end
                        
                        if data.armour ~= nil then
                            LUNAclient.setArmour(source, {data.armour})
                        end
                    end
                end)
                LUNAclient.spawnAnim(source, {data.customization})
        else
            if data.weapons ~= nil then -- load saved weapons
                LUNAclient.giveWeapons(source, {data.weapons, true})
            end
            if data.armour ~= nil then
                LUNAclient.setArmour(source, {data.armour})
            end
            if data.health ~= nil then
                LUNAclient.setHealth(source, {data.health})
            end
        end

        -- notify last login
    else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory

        if cfg.clear_phone_directory_on_death then
            data.phone_directory = {} -- clear phone directory after death
        end

        if cfg.lose_aptitudes_on_death then
            data.gaptitudes = {} -- clear aptitudes after death
        end

        if LUNAConfig.LoseItemsOnDeath then 
            LUNA.clearInventory(user_id) 
        end
        
        LUNA.setMoney(user_id, 0)

        -- disable handcuff
        LUNAclient.setHandcuffed(player, {false})

        if cfg.spawn_enabled then -- respawn (CREATED SPAWN_DEATH)
            local x = cfg.spawn_death[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_death[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_death[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
            LUNAclient.teleport(source, {x, y, z})
        end

        -- load character customization
        if data.customization ~= nil then
            LUNAclient.setCustomization(source, {data.customization})
        end
    end
    Debug.pend()
end)

-- updates

function tLUNA.updatePos(x, y, z)
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        local data = LUNA.getUserDataTable(user_id)
        local tmp = LUNA.getUserTmpTable(user_id)
        if data ~= nil and (tmp == nil or tmp.home_stype == nil) then -- don't save position if inside home slot
            data.position = {
                x = tonumber(x),
                y = tonumber(y),
                z = tonumber(z)
            }
        end
    end
end

function tLUNA.updateWeapons(weapons)
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        local data = LUNA.getUserDataTable(user_id)
        if data ~= nil then
            data.weapons = weapons
        end
    end
end

function tLUNA.updateCustomization(customization)
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        local data = LUNA.getUserDataTable(user_id)
        if data ~= nil then
            data.customization = customization
        end
    end
end

function tLUNA.updateHealth(health)
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        local data = LUNA.getUserDataTable(user_id)
        if data ~= nil then
            data.health = health
        end
    end
end

function tLUNA.updateArmour(armour)
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        local data = LUNA.getUserDataTable(user_id)
        if data ~= nil then
            data.armour = armour
        end
    end
end

function tLUNA.UpdatePlayTime()
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        local data = LUNA.getUserDataTable(user_id)
        if data ~= nil then
            if data.PlayerTime ~= nil then
                data.PlayerTime = tonumber(data.PlayerTime) + 1
            else
                data.PlayerTime = 1
            end
        end
    end
end

local isStoring = {}
function tLUNA.StoreWeaponsDead()
    local player = source 
    local user_id = LUNA.getUserId(player)
    LUNAclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            LUNAclient.giveWeapons(player,{{},true}, function(removedwep)
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
                SetTimeout(10000,function()
                    isStoring[player] = nil 
                end)
            end)
        end
    end)
  end

AddEventHandler('LUNA:StoreWeaponsRequest', function(source)
    local player = source 
    local user_id = LUNA.getUserId(player)
	LUNAclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            LUNAclient.giveWeapons(player, {{}, true}, function(removedwep)
                for k,v in pairs(weapons) do
                    if v.ammo > 0 then
                        --LUNA.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                        LUNA.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                    end
                end
                LUNAclient.notify(player,{"~g~Weapons Stored"})
                SetTimeout(10000,function()
                    isStoring[player] = nil 
                end)
            end)
        end
	end)
end)



function tLUNA.oldskinback()
    local user_id = LUNA.getUserId(source)
    local data = LUNA.getUserDataTable(user_id)

    LUNAclient.setCustomization(source, {data.customization})
end