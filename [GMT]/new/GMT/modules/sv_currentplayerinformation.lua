function GMT.updateCurrentPlayerInfo()
  local currentPlayersInformation = {}
  local playersJobs = {}
  for k,v in pairs(GMT.getUsers()) do
    table.insert(playersJobs, {user_id = k, jobs = GMT.getUserGroups(k)})
  end
  currentPlayersInformation['currentStaff'] = GMT.getUsersByPermission('admin.tickets')
  currentPlayersInformation['jobs'] = playersJobs
  TriggerClientEvent("GMT:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
end


AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
  if first_spawn then
    GMT.updateCurrentPlayerInfo()
  end
end)