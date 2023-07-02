RegisterNetEvent("LUNA:getNumOfNHSOnline")
AddEventHandler("LUNA:getNumOfNHSOnline", function()
    local source = source
    TriggerClientEvent('LUNA:getNumberOfDocsOnline', source, LUNA.getUsersByPermission('nhs.menu'))
end)