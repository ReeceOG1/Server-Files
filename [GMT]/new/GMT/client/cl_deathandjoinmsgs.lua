local a = false
local b = true
RegisterCommand("togglekillfeed",function()
    if not a then
        b = not b
        if b then
            tGMT.notify("~g~Killfeed is now enabled")
            SendNUIMessage({type = "killFeedEnable"})
        else
            tGMT.notify("Killfeed is now disabled")
            SendNUIMessage({type = "killFeedDisable"})
        end
    end
end)
RegisterNetEvent("GMT:showHUD",function(c)
    a = not c
    if b then
        if c then
            SendNUIMessage({type = "killFeedEnable"})
        else
            SendNUIMessage({type = "killFeedDisable"})
        end
    end
end)

RegisterNetEvent(
    "GMT:newKillFeed",
    function(d, e, f, g, h, i, j)
        if GetIsLoadingScreenActive() then
            return
        end
        local k = "other"
        local l = GetPlayerName(tGMT.getPlayerId())
        if e == l or d == l then
            k = "self"
        end
        local m = GetResourceKvpString("gmt_oldkillfeed") or "false"
        if m == "false" then
            oldKillfeed = false
        else
            oldKillfeed = true
        end
        if oldKillfeed and (tGMT.isPlatClub() or tGMT.isPlusClub()) then
            if g then
                tGMT.notify("~o~" .. e .. " ~w~died.")
            else
                tGMT.notify("~o~" .. d .. " ~w~killed ~o~" .. e .. "~w~.")
            end
        else
            SendNUIMessage(
                {
                    type = "addKill",
                    victim = e,
                    killer = d,
                    weapon = f,
                    suicide = g,
                    victimGroup = i,
                    killerGroup = j,
                    range = h,
                    uuid = tGMT.generateUUID("kill", 10, "alphabet"),
                    category = k
                }
            )
        end
    end
)