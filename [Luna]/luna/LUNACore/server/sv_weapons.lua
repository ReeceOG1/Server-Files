RegisterCommand("kit", function(source, args, raw)
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id == 1 then
        LUNAclient.giveWeapons(source, {{["WEAPON_MOSIN"] = {ammo = 250}}})
    end
end)