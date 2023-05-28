local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")

RegisterCommand('dm', function(source, args)
    local user_id = vRP.getUserId({source})
    local their_id = tonumber(args[1])
    local their_source = vRP.getUserSource({their_id})
    if their_source == nil then return vRPclient.notify(source, {'~r~User is not online.'}) end
    vRP.prompt({source, 'Please Enter Message:', '', function(source,msg)
        if msg == '' then return vRPclient.notify(source, {'~r~Invalid Message'}) end
        vRPclient.notify(their_source, {'~r~DM From: ~w~'..vRP.getPlayerName({source})..'\n~r~Message: ~w~'..msg})
        vRPclient.notify(source, {'~g~Message sent'})
    end})
end)
