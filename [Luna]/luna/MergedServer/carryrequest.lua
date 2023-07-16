carrying = {}
--carrying[source] = targetSource, source is carrying targetSource
carried = {}
--carried[targetSource] = source, targetSource is being carried by source

RegisterServerEvent("CarryPeople:sync")
AddEventHandler("CarryPeople:sync", function(targetSrc)
    local targetSrc = targetSrc
    local sourcePed = GetPlayerPed(source)
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetPed = GetPlayerPed(targetSrc)
    local targetCoords = GetEntityCoords(targetPed)
    if #(sourceCoords - targetCoords) <= 3.0 then 
        TriggerClientEvent("CarryPeople:syncTarget", targetSrc, source)
        carrying[source] = targetSrc
        carried[targetSrc] = source
    end
end)

RegisterServerEvent("CarryPeople:stop")
AddEventHandler("CarryPeople:stop", function(targetSrc)
    local source = source

    if carrying[source] then
        TriggerClientEvent("CarryPeople:cl_stop", targetSrc)
        carrying[source] = nil
        carried[targetSrc] = nil
    elseif carried[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carried[source])            
        carrying[carried[source]] = nil
        carried[source] = nil
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    
    if carrying[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carrying[source])
        carried[carrying[source]] = nil
        carrying[source] = nil
    end

    if carried[source] then
        TriggerClientEvent("CarryPeople:cl_stop", carried[source])
        carrying[carried[source]] = nil
        carried[source] = nil
    end
end)

RegisterServerEvent("LUNAEXTRAS:CarryAccepted")
AddEventHandler("LUNAEXTRAS:CarryAccepted", function(senderSrc)
    local senderSrc = senderSrc
    local targetSrc = source
    local targetSrcName = GetPlayerName(targetSrc)
    LUNAclient.notify(targetSrc,{"~g~Carry request accepted."})
    LUNAclient.notify(senderSrc,{"~g~Your carry request to "..targetSrcName.." has been accepted."})
    TriggerClientEvent("LUNAEXTRAS:StartCarry", senderSrc, targetSrc)
end)

RegisterServerEvent("LUNAEXTRAS:CarryDeclined")
AddEventHandler("LUNAEXTRAS:CarryDeclined", function(senderSrc)
    local senderSrc = senderSrc
    local targetSrc = source
    local targetSrcName = GetPlayerName(targetSrc)
    LUNAclient.notify(senderSrc,{"~r~Your carry request to "..targetSrcName.." has been declined."})
    LUNAclient.notify(targetSrc,{"~r~Carry request denied."})
end)

RegisterServerEvent("LUNA:CarryRequest")
AddEventHandler("LUNA:CarryRequest", function(targetSrc, OMioDioMode)
    local targetSrc = targetSrc
    local senderSrc = source
    user_id = LUNA.getUserId(senderSrc)
    local senderSrcName = GetPlayerName(senderSrc)
    if OMioDioMode and LUNA.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("LUNAEXTRAS:StartCarry", senderSrc, targetSrc)
    else
        LUNAclient.notify(targetSrc,{"Player: ~b~"..senderSrcName.."~w~ is trying to carry you, press ~g~=~w~ to accept or ~r~-~w~ to refuse"})
        LUNAclient.notify(senderSrc,{"request sent to Temp ID: "..targetSrc})
        TriggerClientEvent('LUNAEXTRAS:CarryTargetAsk', targetSrc, senderSrc)
    end
end)