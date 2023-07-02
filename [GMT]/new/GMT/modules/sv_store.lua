function getStoreRankName(source)
    local user_id = GMT.getUserId(source)
    local ranks = {
        [1] = 'Baller',
        [2] = 'Rainmaker',
        [3] = 'Kingpin',
        [4] = 'Supreme',
        [5] = 'Premium',
        [6] = 'Supporter',
    }
    for k,v in ipairs(ranks) do
        if GMT.hasGroup(user_id, v) then
            return v
        end
    end
    return "None"
end
    
AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn and user_id == 1 then
        TriggerClientEvent('GMT:setStoreRankName', source, getStoreRankName(source))
        local storeItemsOwned = {
            'premium',
            'baller',
            'lock_slot',
            'phone_number',
            'license_plate',
            'smg_import',
            'baller_id',
            'shotgun_whitelist',
            'gmt_platinum',
            'supporter_to_supreme',
            'import_slot',
            'import_slot',
            'vip_car',
            'black_friday',
            'baller_id',
        }
        TriggerClientEvent('GMT:sendStoreItems', source, storeItemsOwned)
    end
end)

-- NO WHERE NEAR DONE BTW SORRY