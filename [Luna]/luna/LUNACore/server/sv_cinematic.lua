RegisterServerEvent("LUNA:RequestCinematic")
AddEventHandler("LUNA:RequestCinematic", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    exports["LUNA-Roles"]:isRolePresent(source, {'1101658818020130886'}, function(hasRole, roles)
        if hasRole then
            LUNAclient.hasCinematicPermission(source, {})
        end
    end)
end)