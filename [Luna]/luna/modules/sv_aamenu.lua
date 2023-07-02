RegisterServerEvent('LUNA:openAAMenu')
AddEventHandler('LUNA:openAAMenu', function()
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil and LUNA.hasPermission(user_id, "aa.menu") then 
      LUNAclient.openAAMenu(source,{})
    end
end)

RegisterServerEvent('LUNA:setAAMenu')
AddEventHandler('LUNA:setAAMenu', function(status)
    local source = source
    local user_id = LUNA.getUserId(source)
end)