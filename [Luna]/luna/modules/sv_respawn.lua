local Tables = {
    {Name = "Mission Row Police Station", Permission = "police.armoury", Price = 0},
    {Name = "Sandy Shores Police Station", Permission = "police.armoury", Price = 0},
    {Name = "Paleto Police Station", Permission = "police.armoury", Price = 0},
    {Name = "Vespucci Police Station", Permission = "police.armoury", Price = 0},
    {Name = "VIP Island", Permission = "vip.guns", Price = 0},
    {Name = "Rebel Diner", Permission = "rebel.guns", Price = 0},
    {Name = "St Thomas Hospital", Permission = "user", Price = 0},
    {Name = "Legion Square", Permission = "user", Price = 20000},
    {Name = "Royal London Hospital", Permission = "user", Price = 0},
    {Name = "Sandy Shores Medical Centre", Permission = "user", Price = 0},
}


RegisterNetEvent("LUNA:SendSpawnMenu")
AddEventHandler("LUNA:SendSpawnMenu", function()
    local source = source
    local UserID = LUNA.getUserId(source)
    local hasPermission ={}
    for k,v in pairs(Tables) do
        if LUNA.hasPermission(UserID, v.Permission) or LUNA.hasGroup(UserID, v.Permission) then
            table.insert(hasPermission, v.Name)
            TriggerClientEvent("LUNA:CLOSE_DEATH_SCREEN", source)
            TriggerClientEvent("LUNA:OpenSpawnMenu", source, hasPermission)
        end
    end
end)

RegisterNetEvent("LUNA:takeAmount")
AddEventHandler("LUNA:takeAmount", function(Price)
    local source = source
    local UserID = LUNA.getUserId(source)
    if LUNA.tryPayment(UserID, Price) then
        LUNAclient.notify(source, "You Have Paid £"..Price.." To Spawn At This Location")
    else
        LUNAclient.notify(source, "You Were Not Able To Pay The Price, Benifits Paid.")
    end
end)

RegisterNetEvent("LUNA:ProvideHealth")
AddEventHandler("LUNA:ProvideHealth", function()
    local source = source
    local UserID = LUNA.getUserId(source)
    if UserID ~= nil then
        TriggerClientEvent("LUNA:ProvideHealth", source)
    end
end)