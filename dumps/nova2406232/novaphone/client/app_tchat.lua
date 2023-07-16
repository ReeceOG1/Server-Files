RegisterNetEvent("NOVA:tchat_receive")
AddEventHandler("NOVA:tchat_receive", function(message)
  SendNUIMessage({event = 'tchat_receive', message = message})
end)

RegisterNetEvent("NOVA:tchat_channel")
AddEventHandler("NOVA:tchat_channel", function(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  TriggerServerEvent('NOVA:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('NOVA:tchat_channel', data.channel)
end)
