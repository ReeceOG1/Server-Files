local weapons=module("cfg/weapons")
RegisterNetEvent('LUNA:onPlayerKilled')
AddEventHandler('LUNA:onPlayerKilled', function(killtype, killerid,weapon,suicide, distance)
    local source = source
    local user_id = LUNA.getUserId(source)
    local killer_id = LUNA.getUserId(killerid)
    local killergroup = 'none'
    local killedgroup = 'none'
    local weaponclass = 'suicide'
    -- Weapon class
    for r,s in pairs(weapons.weapons)do 
        if weapon == s.name then
        weaponclass = s.class
        end
    end
    if distance ~= nil then
        distance = math.floor(distance)
    end
    if LUNA.hasPermission(user_id, "police.armoury") then
        victimGroup = "police"
    elseif LUNA.hasPermission(user_id, "nhs.menu") then
        victimGroup = "nhs"
    else
        victimGroup = "none"
    end
    if LUNA.hasPermission(killer_id, "police.armoury") then
        killerGroup = "police"
    elseif LUNA.hasPermission(killer_id, "nhs.menu") then
        killerGroup = "nhs"
    else
        killerGroup = "none"
    end
    if killtype == 'killed' then
        if suicide == true then
            TriggerClientEvent('LUNA:newKillFeed', -1, GetPlayerName(source), GetPlayerName(source), "suicide", true, distance, victimGroup, victimGroup)
        else
            TriggerClientEvent('LUNA:newKillFeed', -1, GetPlayerName(killerid), GetPlayerName(source), weaponclass, false, distance, victimGroup, killerGroup)
        end
    elseif killtype == 'finished off' and killer ~= nil then -- if the killer is nil, it means the player killed themselves
        -- Kill log
        -- Killer ID & Weapon
        return
    end
end)