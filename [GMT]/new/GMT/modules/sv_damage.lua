RegisterNetEvent("GMT:syncEntityDamage")
AddEventHandler("GMT:syncEntityDamage",function(u, v, t, s, m, n)
    local source=source
    local user_id=GMT.getUserId(source)
    TriggerClientEvent('GMT:onEntityHealthChange', t, GetPlayerPed(source), u, v, s)
end)