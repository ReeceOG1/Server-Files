RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('GMT:openCinematicMenu', source)
    end
end)