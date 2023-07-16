local lang = LUNA.lang
local Tunnel = module("luna", "lib/Tunnel")
local Proxy = module("luna", "lib/Proxy")
tLUNA = Proxy.getInterface("LUNA") 
LUNAclient = Tunnel.getInterface("LUNA","LUNA")

RegisterServerEvent('LUNA:OpenNHSMenu')
AddEventHandler('LUNA:OpenNHSMenu', function()
    local source = source
    local user_id = tLUNA.getUserId({source})
    if user_id ~= nil and tLUNA.hasPermission({user_id, "nhs.menu"}) then
        TriggerClientEvent("LUNA:NHSMenuOpened", source)
    elseif user_id ~= nil and tLUNA.hasPermission({user_id, "nhs.whitelisted"}) then
      LUNAclient.notify(source,{"~r~You are not on duty"})
    else
        print("You are not a part of the NHS")
    end
end)

local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

RegisterServerEvent('LUNA:nhsRevive')
AddEventHandler('LUNA:nhsRevive', function()
    Player = source
    local user_id = LUNA.getUserId(Player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "nhs.menu") then
        LUNAclient.getNearestPlayer(Player, {3}, function(Player)
            local user_id = LUNA.getUserId(Player)
            if user_id ~= nil then
                LUNAclient.isInComa(Player, {}, function(in_coma)
                    if in_coma then
                          TriggerClientEvent('LUNA:reviveRadial2',Player)
                          LUNAclient.varyHealth(Player, 50) -- heal 50
                          LUNAclient.notify(Player,{"~g~You have been revived by an NHS Member, free of charge"})
                          LUNAclient.notify(Player,{"~g~You revived someone, as a reward, here is £10,000 into your bank"})
                          LUNA.giveBankMoney(Player,10000)
                    else
                        LUNAclient.notify(Player, {"~r~Player is alive and healthy"})
                    end
                end)
            else
                LUNAclient.notify(Player, {"~r~There is no Player nearby"})
            end
        end)
    end
end)

RegisterServerEvent('LUNA:HealPlayer')
AddEventHandler('LUNA:HealPlayer', function()
    Player = source
    local user_id = LUNA.getUserId(Player)
    if user_id ~= nil and LUNA.hasPermission(user_id, "nhs.menu") then
        LUNAclient.getNearestPlayer(Player, {3}, function(Player)
            local user_id = LUNA.getUserId(Player)
            if user_id ~= nil then
                LUNAclient.playAnim(Player, {false, revive_seq, false}) -- anim
                SetTimeout(10000, function()
                    LUNAclient.varyHealth(Player, 100) -- heal 100
                    LUNAclient.notify(Player,{"~g~You have been healed by an NHS Member, free of charge"})
                    LUNAclient.notify(Player,{"~g~You healed someone, as a reward, here is £5,000 into your bank"})
                    LUNA.giveBankMoney(Player, 5000)
                end)
            else
                LUNAclient.notify(Player, {"~r~There is no Player nearby"})
            end
        end)
    end
end)