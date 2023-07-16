RegisterServerEvent('GMT:setCarDevMode')
AddEventHandler('GMT:setCarDevMode', function(status)
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id ~= nil and GMT.hasPermission(user_id, "cardev.menu") then 
      if status then
        tGMT.setBucket(source, 333)
      else
        tGMT.setBucket(source, 0)
      end
    else
      TriggerEvent("GMT:acBan", user_id, 11, GetPlayerName(source), source, 'Attempted to Teleport to Car Dev Universe')
    end
end)