RegisterServerEvent('GMT:openAAMenu')
AddEventHandler('GMT:openAAMenu', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id ~= nil and GMT.hasPermission(user_id, "aa.menu")then
      GMTclient.openAAMenu(source,{})
    end
end)

RegisterServerEvent('GMT:setAAMenu')
AddEventHandler('GMT:setAAMenu', function(status)
    local source = source
    local user_id = GMT.getUserId(source)
end)