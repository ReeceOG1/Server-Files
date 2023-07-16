local c = {}
RegisterCommand("djmenu", function(source, args, rawCommand)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id,"DJ") then
        TriggerClientEvent('GMT:toggleDjMenu', source)
    end
end)
RegisterCommand("djadmin", function(source, args, rawCommand)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id,"admin.noclip") then
        TriggerClientEvent('GMT:toggleDjAdminMenu', source, c)
    end
end)
RegisterCommand("play",function(source,args,rawCommand)
    local source = source
    local user_id = GMT.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = GetPlayerName(source)
    if GMT.hasGroup(user_id,"DJ") then
        if #args > 0 then
            TriggerClientEvent('GMT:finaliseSong', source,args[1])
        end
    end
end)
RegisterServerEvent("GMT:adminStopSong")
AddEventHandler("GMT:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(c) do
        if v[1] == PARAM then
            TriggerClientEvent('GMT:stopSong', -1,v[2])
            c[tostring(k)] = nil
            TriggerClientEvent('GMT:toggleDjAdminMenu', source, c)
        end
    end
end)
RegisterServerEvent("GMT:playDjSongServer")
AddEventHandler("GMT:playDjSongServer", function(PARAM,coords)
    local source = source
    local user_id = GMT.getUserId(source)
    local name = GetPlayerName(source)
    c[tostring(source)] = {PARAM,coords,user_id,name,"true"}
    TriggerClientEvent('GMT:playDjSong', -1,PARAM,coords,user_id,name)
end)
RegisterServerEvent("GMT:skipServer")
AddEventHandler("GMT:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('GMT:skipDj', -1,coords,param)
end)
RegisterServerEvent("GMT:stopSongServer")
AddEventHandler("GMT:stopSongServer", function(coords)
    local source = source
    c[tostring(source)] = nil
    TriggerClientEvent('GMT:stopSong', -1,coords)
end)
RegisterServerEvent("GMT:updateVolumeServer")
AddEventHandler("GMT:updateVolumeServer", function(coords,volume)
    local source = source
    TriggerClientEvent('GMT:updateDjVolume', -1,coords,volume)
end)


RegisterServerEvent("GMT:requestCurrentProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("GMT:requestCurrentProgressServer", function(a,b)
    TriggerClientEvent('GMT:requestCurrentProgress', -1, a, b)
end)

RegisterServerEvent("GMT:returnProgressServer") -- doing this will fix the issue of the song not playing when you leave and re enter the area
AddEventHandler("GMT:returnProgressServer", function(x,y,z)
    for k,v in pairs(c) do
        if tonumber(k) == GMT.getUserSource(x) then
            TriggerClientEvent('GMT:returnProgress', -1, x, y, z, v[1])
        end
    end
end)
