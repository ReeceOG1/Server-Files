local cfg=module("cfg/cfg_spawn")


RegisterNetEvent("GMT:SendSpawnMenu")
AddEventHandler("GMT:SendSpawnMenu",function()
    local source = source
    local user_id = GMT.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if GMT.hasPermission(GMT.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['ghmattimysql']:execute("SELECT * FROM `gmt_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            TriggerClientEvent("GMT:OpenSpawnMenu",source,spawnTable)
            GMT.clearInventory(user_id) 
            GMTclient.setPlayerCombatTimer(source, {0})
        end
    end)
end)