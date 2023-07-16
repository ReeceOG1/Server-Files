RegisterCommand('restartserver', function(source, args)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasGroup(user_id, 'Founder') or source == '' then
        if args[1] ~= nil then
            timeLeft = args[1]
            TriggerClientEvent('GMT:announceRestart', -1, tonumber(timeLeft), false)
            TriggerEvent('GMT:restartTime', timeLeft)
            TriggerClientEvent('GMT:CloseToRestart', -1)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t") -- 0-23 (24 hour format)
        local hour = tonumber(time["hour"])
        if hour == 8 then
            if tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                TriggerClientEvent('GMT:announceRestart', -1, 60, true)
                TriggerEvent('GMT:restartTime', 60)
                TriggerClientEvent('GMT:CloseToRestart', -1)
            end
        end
    end
end)

RegisterServerEvent("GMT:restartTime")
AddEventHandler("GMT:restartTime", function(time)
    time = tonumber(time)
    if source ~= '' then return end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            time = time - 1
            if time == 0 then
                for k,v in pairs(GMT.getUsers({})) do
                    DropPlayer(v, "Server restarting, please join back in a few minutes.")
                end
                os.exit()
            end
        end
    end)
end)
