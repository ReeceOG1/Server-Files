RegisterNetEvent("GMT:getArmour")
AddEventHandler("GMT:getArmour",function()
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, "police.armoury") then
        if GMT.hasPermission(user_id, "police.maxarmour") then
            GMTclient.setArmour(source, {100, true})
        elseif GMT.hasGroup(user_id, "Inspector Clocked") then
            GMTclient.setArmour(source, {75, true})
        elseif GMT.hasGroup(user_id, "Senior Constable Clocked") or GMT.hasGroup(user_id, "Sergeant Clocked") then
            GMTclient.setArmour(source, {50, true})
        elseif GMT.hasGroup(user_id, "PCSO Clocked") or GMT.hasGroup(user_id, "PC Clocked") then
            GMTclient.setArmour(source, {25, true})
        end
        TriggerClientEvent("gmt:PlaySound", source, 1)
        GMTclient.notify(source, {"~g~You have received your armour."})
    else
        local player = GMT.getUserSource(user_id)
        local name = GetPlayerName(source)
        Wait(500)
        TriggerEvent("GMT:acBan", user_id, 11, name, player, 'Attempted to use pd armour trigger')
    end
end)