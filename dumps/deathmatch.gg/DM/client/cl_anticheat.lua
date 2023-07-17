Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        for i = 1, #Config.AC.WeaponComponents do
            local dmg_mod = GetWeaponComponentDamageModifier(Config.AC.WeaponComponents[i])
            local accuracy_mod = GetWeaponComponentAccuracyModifier(Config.AC.WeaponComponents[i])
            if dmg_mod > 1.1 or accuracy_mod > 1.2 then
                Params = {
                    [1] = dmg_mod,
                    [2] = accuracy_mod,
                    [3] = "Citizen Modification [1]",
                }
                TriggerServerEvent('DM:Client:AnticheatKick', "Citizen Modification", Params)
            end
        end
    end
end)