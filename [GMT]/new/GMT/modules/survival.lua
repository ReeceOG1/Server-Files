local cfg = module("cfg/survival")
local lang = GMT.lang


-- handlers

-- init values
AddEventHandler("GMT:playerJoin", function(user_id, source, name, last_login)
    local data = GMT.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = GMT.getUserId(player)
    if user_id ~= nil then
        GMTclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = GMT.getUserId(nplayer)
            if nuser_id ~= nil then
                GMTclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if GMT.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            GMTclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                GMTclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        GMTclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                GMTclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('GMT:SearchForPlayer')
AddEventHandler('GMT:SearchForPlayer', function()
    TriggerClientEvent('GMT:ReceiveSearch', -1, source)
end)


