local killlogs = 'https://discord.com/api/webhooks/1115755704402317412/OMyvZ2QFxIBRpyNVQVafRraFVrAk_0gDQOMBtYebxcJRUb2c7FlD06dLC4Shy5-qRFk3'
local damagelogs = 'https://discord.com/api/webhooks/1115755759666483230/teugEHQUhTmH5Z_Uap4sJbHK70ArO9seAsSJ4_plvrANciHN1qpeuvuoIKf-a9v1cy3G'

local f = module("cfg/weapons")
f=f.weapons
illegalWeapons = f.nativeWeaponModelsToNames

local function getWeaponName(weapon)
    for k,v in pairs(f) do
        if weapon == 'Fists' then
            return 'Fist'
        elseif weapon == 'Fire' then
            return 'Fire'
        elseif weapon == 'Explosion' then
            return 'Explode'
        end
        if v.name == weapon then
            return v.class
        end
    end
    return "Unknown"
end

RegisterNetEvent('GMT:onPlayerKilled')
AddEventHandler('GMT:onPlayerKilled', function(killtype, killer, weaponhash, suicide, distance)
    local source = source
    local killergroup = 'none'
    local killedgroup = 'none'
    if distance ~= nil then
        distance = math.floor(distance) 
    end
    if killtype == 'killed' then
        if GMT.hasPermission(GMT.getUserId(source), 'police.onduty.permission') then
            killedgroup = 'police'
        elseif GMT.hasPermission(GMT.getUserId(source), 'nhs.onduty.permission') then
            killedgroup = 'nhs'
        end
        if GMT.hasPermission(GMT.getUserId(killer), 'police.onduty.permission') then
            killergroup = 'police'
        elseif GMT.hasPermission(GMT.getUserId(killer), 'nhs.onduty.permission') then
            killergroup = 'nhs'
        end
        if killer ~= nil then
            weaponhash = getWeaponName(weaponhash)
            TriggerClientEvent('GMT:newKillFeed', -1, GetPlayerName(killer), GetPlayerName(source), weaponhash, suicide, distance, killedgroup, killergroup)
            local embed = {
                {
                  ["color"] = "16448403",
                  ["title"] = "Kill Logs",
                  ["description"] = "",
                  ["text"] = "GMT Server #1",
                  ["fields"] = {
                    {
                        ["name"] = "Killer Name",
                        ["value"] = GetPlayerName(killer),
                        ["inline"] = true
                    }, 
                    {
                        ["name"] = "Killer ID",
                        ["value"] = GMT.getUserId(killer),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Victim Name",
                        ["value"] = GetPlayerName(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Victim ID",
                        ["value"] = GMT.getUserId(source),
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Weapon Used",
                        ["value"] = weaponhash,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Distance",
                        ["value"] = distance..'m',
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Kill Type",
                        ["value"] = killtype,
                        ["inline"] = true
                    },
                  }
                }
              }
              PerformHttpRequest(killlogs, function(err, text, headers) end, 'POST', json.encode({username = "GMT", embeds = embed}), { ['Content-Type'] = 'application/json' })
        else
            TriggerClientEvent('GMT:newKillFeed', -1, GetPlayerName(source), GetPlayerName(source), 'suicide', suicide, distance, killedgroup, killergroup)
        end
    elseif killtype == 'finished off' and killer ~= nil then
        weaponhash = getWeaponName(weaponhash)
        local embed = {
            {
              ["color"] = "16448403",
              ["title"] = "Finished Off Logs",
              ["description"] = "",
              ["text"] = "GMT Server #1",
              ["fields"] = {
                {
                    ["name"] = "Killer Name",
                    ["value"] = GetPlayerName(killer),
                    ["inline"] = true
                },
                {
                    ["name"] = "Victim Name",
                    ["value"] = GetPlayerName(source),
                    ["inline"] = true
                },
                {
                    ["name"] = "Weapon Used",
                    ["value"] = weaponhash,
                    ["inline"] = true
                },
                {
                    ["name"] = "Killer Group",
                    ["value"] = killergroup,
                    ["inline"] = true
                },
                {
                    ["name"] = "Victim Group",
                    ["value"] = killedgroup,
                    ["inline"] = true
                },
                {
                    ["name"] = "Kill Type",
                    ["value"] = killtype,
                    ["inline"] = true
                },
              }
            }
          }
          PerformHttpRequest(killlogs, function(err, text, headers) end, 'POST', json.encode({username = "GMT", embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
    TriggerClientEvent('GMT:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
end)

AddEventHandler('weaponDamageEvent', function(sender, ev)
    local user_id = GMT.getUserId(sender)
    local name = GetPlayerName(sender)
	if ev.weaponDamage ~= 0 then
        if ev.weaponType == 3218215474 or (ev.weaponType == 911657153 and not GMT.hasPermission(user_id, 'police.onduty.permission')) then
            TriggerEvent("GMT:acBan", user_id, 8, name, sender, ev.weaponType)
        end
        local embed = {
            {
              ["color"] = "16448403",
              ["title"] = "Damage Logs",
              ["description"] = "",
              ["text"] = "GMT Server #1",
              ["fields"] = {
                {
                    ["name"] = "Player Name",
                    ["value"] = name,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Temp ID",
                    ["value"] = sender,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Perm ID",
                    ["value"] = user_id,
                    ["inline"] = true
                },
                {
                    ["name"] = "Damage",
                    ["value"] = ev.weaponDamage,
                    ["inline"] = true
                },
                {
                    ["name"] = "Weapon Hash",
                    ["value"] = ev.weaponType,
                    ["inline"] = true
                },
              }
            }
          }        
        PerformHttpRequest(damagelogs, function(err, text, headers) end, 'POST', json.encode({username = "GMT", embeds = embed}), { ['Content-Type'] = 'application/json' })
	end
end)
