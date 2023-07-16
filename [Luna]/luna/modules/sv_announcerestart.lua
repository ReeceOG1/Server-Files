-- Command to start a scheduled server restart.
AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
        TriggerClientEvent('LUNA:announceRestart', -1, 60, true)
    end
end)

RegisterCommand('announcerestart', function(source, args, rawCommand)
    local player = source
    if player and LUNA.hasPermission(player, "dev.menu") then
        TriggerClientEvent('LUNA:announceRestart', -1, 60, true)
        Wait(60000)
        restartServer()
    end
end, false)

RegisterCommand('announcerestart2', function(source, args, rawCommand)
    local player = source
    if player and LUNA.hasPermission(player, "dev.menu") then
        TriggerClientEvent('LUNA:announceRestart2', -1, 60, false)
        Wait(60000)
        restartServer()
    end
end, false)

-- Command to start an unscheduled server restart.
RegisterCommand('restartserver', function(source, args, rawCommand)
    local player = source
    if player and LUNA.hasPermission(player, "dev.menu") then
        local restartTime = tonumber(args[1])
        if restartTime == nil then
            TriggerClientEvent('chat:addMessage', source, {
                color = { 255, 0, 0},
                multiline = true,
                args = {"System", "You need to provide the restart time (in seconds)."}
            })
            return
        end
        local restartTimeMilliseconds = restartTime * 1000
        TriggerClientEvent('LUNA:announceRestart', -1, restartTime, false)
        Wait(restartTimeMilliseconds)
        restartServer()
    end
end, false)


function restartServer()
    for i,v in pairs(GetPlayers()) do 
        DropPlayer(v, 'Server Restarting')
    end
    Citizen.Wait(2000)
    os.exit()
end
