local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local userid = LUNA.getUserId(source)
    if LUNA.hasGroup(userid,"DJ") then
        TriggerClientEvent('LUNA:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local userid = LUNA.getUserId(source)
    if LUNA.hasPermission(userid,"admin.menu") then
        TriggerClientEvent('LUNA:toggleDjAdminMenu', source,c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = LUNA.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = GetPlayerName(source)
    if LUNA.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('LUNA:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("LUNA:adminStopSong")
AddEventHandler("LUNA:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('LUNA:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('LUNA:toggleDjAdminMenu', source,c)
        end
    end
end)
RegisterServerEvent("LUNA:playDjSongServer")
AddEventHandler("LUNA:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = LUNA.getUserId(source)
    local name = GetPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('LUNA:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("LUNA:skipServer")
AddEventHandler("LUNA:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('LUNA:skipDj', -1,coords,param)
end)
RegisterServerEvent("LUNA:stopSongServer")
AddEventHandler("LUNA:stopSongServer", function(coords)
    local source = source
    TriggerClientEvent('LUNA:stopSong', -1,coords)
end)
RegisterServerEvent("LUNA:updateVolumeServer")
AddEventHandler("LUNA:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('LUNA:updateDjVolume', -1,coords,volume)
end)