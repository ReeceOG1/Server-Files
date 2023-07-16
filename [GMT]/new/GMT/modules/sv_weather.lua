voteCooldown = 1800
currentWeather = "CLEAR"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("GMT:vote") 
AddEventHandler("GMT:vote", function(weatherType)
    TriggerClientEvent("GMT:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("GMT:tryStartWeatherVote") 
AddEventHandler("GMT:tryStartWeatherVote", function()
	local source = source
    local user_id = GMT.getUserId(source)
    if GMT.hasPermission(user_id, 'admin.managecommunitypot') then
        if weatherVoterCooldown >= voteCooldown then
            TriggerClientEvent("GMT:startWeatherVote", -1)
            weatherVoterCooldown = 0
        else
            TriggerClientEvent("chatMessage", source, "Another vote can be started in " .. tostring(voteCooldown-weatherVoterCooldown) .. " seconds!", {255, 0, 0})
        end
    else
        GMTclient.notify(source, {'You do not have permission for this.'})
    end
end)

RegisterServerEvent("GMT:getCurrentWeather") 
AddEventHandler("GMT:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("GMT:voteFinished",source,currentWeather)
end)

RegisterServerEvent("GMT:setCurrentWeather")
AddEventHandler("GMT:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)