RegisterNetEvent("LUNA:speedGunFinePlayer")
AddEventHandler("LUNA:speedGunFinePlayer",function(playerfined,fineamount)
    local source = source
    local officer_id = LUNA.getUserId(source)
    local user_id = LUNA.getUserId(playerfined)
    local player_id = LUNA.getUserSource(playerfined)
    if LUNA.hasPermission(user_id,"police.armoury") then
        LUNAclient.notify(source,{'~r~You cannot fine another officer'})
        return
    end
    if not LUNA.hasPermission(user_id, "police.armoury") and LUNA.hasPermission(officer_id, "police.armoury") then
        if tonumber(LUNA.getBankMoney(user_id)) > tonumber(fineamount*100) then
            LUNA.setBankMoney(user_id,tonumber(LUNA.getBankMoney(user_id))-tonumber(fineamount*100))
            LUNA.setBankMoney(officer_id,tonumber(LUNA.getBankMoney(officer_id))+tonumber(fineamount*100))
            LUNAclient.notify(playerfined,{'~r~You have been issued a speeding fine of £'..(fineamount*100)..' for going '..fineamount.."MPH over the speed limit."})
            LUNAclient.notify(source,{'~r~You issused a speeding fine '..GetPlayerName(playerfined)..' £'..(fineamount*100)..' for going '..fineamount.."MPH over the speed limit."})
            TriggerClientEvent('LUNA:speedGunPlayerFined', playerfined)
        else
            LUNAclient.notify(playerfined,{"~r~You have been issued a fine for speeding"})
            LUNAclient.notify(source,{"~r~This player dosnt have enough money"}) 
        end
    end
end)

