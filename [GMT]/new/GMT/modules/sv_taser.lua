RegisterServerEvent('GMT:playTaserSound')
AddEventHandler('GMT:playTaserSound', function(coords, sound)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') or GMT.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('GMT:reactivatePed')
AddEventHandler('GMT:reactivatePed', function(id)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') or GMT.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('GMT:receiveActivation', id)
      TriggerClientEvent('TriggerTazer', id)
    end
end)

RegisterServerEvent('GMT:arcTaser')
AddEventHandler('GMT:arcTaser', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') or GMT.hasPermission(user_id, 'hmp.menu') then
      GMTclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = GMT.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('GMT:receiveBarbs', nplayer, source)
            TriggerClientEvent('TriggerTazer', id)
        end
      end)
    end
end)

RegisterServerEvent('GMT:barbsNoLongerServer')
AddEventHandler('GMT:barbsNoLongerServer', function(id)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'police.armoury') or GMT.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('GMT:barbsNoLonger', id)
    end
end)

RegisterServerEvent('GMT:barbsRippedOutServer')
AddEventHandler('GMT:barbsRippedOutServer', function(id)
    local source = source
    local user_id = GMT.getUserId(source)
    TriggerClientEvent('GMT:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = GMT.getUserId(source)
  if GMT.hasPermission(user_id, 'police.armoury') or GMT.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('GMT:reloadTaser', source)
  end
end)