AddEventHandler('gameEventTriggered', function(eName, eventArgs)
    if eName == 'CEventNetworkEntityDamage' then 
        if eventArgs[1] ~= PlayerPedId() then
            local settingsData = cFDM.FetchHsData()
            if settingsData[1] then
                local bFound, bone = GetPedLastDamageBone(eventArgs[1])
                if bFound then
                    if bone == 31086 or bone == 39317 then --headshot
                        TriggerEvent("FDM:PlayClientSound", settingsData[2])
                    elseif bone == 24817 or bone == 10706 or bone == 24816 or bone == 18905 or bone == 45509 then 
                        TriggerEvent("FDM:PlayClientSound", settingsData[3])
                    end
                end
            end
        end
    end
end)

AddEventHandler('entityDamaged', function(vic, killer, weapon, dmg)
    print(GetWeaponDamage(weapon))
end)