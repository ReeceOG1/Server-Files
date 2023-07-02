grindBoost = 1.0

local defaultPrices = {
    ["Weed"] = math.floor(1500*grindBoost),
    ["Cocaine"] = math.floor(2500*grindBoost),
    ["Meth"] = math.floor(3000*grindBoost),
    ["Heroin"] = math.floor(10000*grindBoost),
    ["LSDNorth"] = math.floor(15000*grindBoost),
    ["LSDSouth"] = math.floor(15000*grindBoost),
    ["Copper"] = math.floor(1000*grindBoost),
    ["Limestone"] = math.floor(2000*grindBoost),
    ["Gold"] = math.floor(4000*grindBoost),
    ["Diamond"] = math.floor(6000*grindBoost),
}

function GMT.getCommissionPrice(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            if v.commission == nil then
                v.commission = 0
            end
            if v.commission == 0 then
                return defaultPrices[drugtype]
            else
                return defaultPrices[drugtype]-defaultPrices[drugtype]*v.commission/100
            end
        end
    end
end

function GMT.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function GMT.updateTraderInfo()
    TriggerClientEvent('GMT:updateTraderCommissions', -1, 
    GMT.getCommission('Weed'),
    GMT.getCommission('Cocaine'),
    GMT.getCommission('Meth'),
    GMT.getCommission('Heroin'),
    GMT.getCommission('LargeArms'),
    GMT.getCommission('LSDNorth'),
    GMT.getCommission('LSDSouth'))
    TriggerClientEvent('GMT:updateTraderPrices', -1, 
    GMT.getCommissionPrice('Weed'), 
    GMT.getCommissionPrice('Cocaine'),
    GMT.getCommissionPrice('Meth'),
    GMT.getCommissionPrice('Heroin'),
    GMT.getCommissionPrice('LSDNorth'),
    GMT.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end

RegisterNetEvent('GMT:requestDrugPriceUpdate')
AddEventHandler('GMT:requestDrugPriceUpdate', function()
    local source = source
	local user_id = GMT.getUserId(source)
    GMT.updateTraderInfo()
end)

local function checkTraderBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        GMTclient.notify(source, {'You cannot sell drugs in this dimension.'})
        return false
    end
    return true
end

RegisterNetEvent('GMT:sellCopper')
AddEventHandler('GMT:sellCopper', function()
    local source = source
	local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'Copper') > 0 then
            GMT.tryGetInventoryItem(user_id, 'Copper', 1, false)
            GMTclient.notify(source, {'~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper'])})
            GMT.giveBankMoney(user_id, defaultPrices['Copper'])
        else
            GMTclient.notify(source, {'You do not have Copper.'})
        end
    end
end)

RegisterNetEvent('GMT:sellLimestone')
AddEventHandler('GMT:sellLimestone', function()
    local source = source
	local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'Limestone') > 0 then
            GMT.tryGetInventoryItem(user_id, 'Limestone', 1, false)
            GMTclient.notify(source, {'~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone'])})
            GMT.giveBankMoney(user_id, defaultPrices['Limestone'])
        else
            GMTclient.notify(source, {'You do not have Limestone.'})
        end
    end
end)

RegisterNetEvent('GMT:sellGold')
AddEventHandler('GMT:sellGold', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'Gold') > 0 then
            GMT.tryGetInventoryItem(user_id, 'Gold', 1, false)
            GMTclient.notify(source, {'~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold'])})
            GMT.giveBankMoney(user_id, defaultPrices['Gold'])
        else
            GMTclient.notify(source, {'You do not have Gold.'})
        end
    end
end)

RegisterNetEvent('GMT:sellDiamond')
AddEventHandler('GMT:sellDiamond', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
            GMT.tryGetInventoryItem(user_id, 'Processed Diamond', 1, false)
            GMTclient.notify(source, {'~g~Sold Processed Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond'])})
            GMT.giveBankMoney(user_id, defaultPrices['Diamond'])
        else
            GMTclient.notify(source, {'You do not have Diamond.'})
        end
    end
end)

RegisterNetEvent('GMT:sellWeed')
AddEventHandler('GMT:sellWeed', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'Weed') > 0 then
            GMT.tryGetInventoryItem(user_id, 'Weed', 1, false)
            GMTclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(GMT.getCommissionPrice('Weed'))})
            GMT.giveMoney(user_id, GMT.getCommissionPrice('Weed'))
            GMT.turfSaleToGangFunds(GMT.getCommissionPrice('Weed'), 'Weed')
        else
            GMTclient.notify(source, {'You do not have Weed.'})
        end
    end
end)

RegisterNetEvent('GMT:sellCocaine')
AddEventHandler('GMT:sellCocaine', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
            GMT.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
            GMTclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(GMT.getCommissionPrice('Cocaine'))})
            GMT.giveMoney(user_id, GMT.getCommissionPrice('Cocaine'))
            GMT.turfSaleToGangFunds(GMT.getCommissionPrice('Cocaine'), 'Cocaine')
        else
            GMTclient.notify(source, {'You do not have Cocaine.'})
        end
    end
end)

RegisterNetEvent('GMT:sellMeth')
AddEventHandler('GMT:sellMeth', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'Meth') > 0 then
            GMT.tryGetInventoryItem(user_id, 'Meth', 1, false)
            GMTclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(GMT.getCommissionPrice('Meth'))})
            GMT.giveMoney(user_id, GMT.getCommissionPrice('Meth'))
            GMT.turfSaleToGangFunds(GMT.getCommissionPrice('Meth'), 'Meth')
        else
            GMTclient.notify(source, {'You do not have Meth.'})
        end
    end
end)

RegisterNetEvent('GMT:sellHeroin')
AddEventHandler('GMT:sellHeroin', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'Heroin') > 0 then
            GMT.tryGetInventoryItem(user_id, 'Heroin', 1, false)
            GMTclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(GMT.getCommissionPrice('Heroin'))})
            GMT.giveMoney(user_id, GMT.getCommissionPrice('Heroin'))
            GMT.turfSaleToGangFunds(GMT.getCommissionPrice('Heroin'), 'Heroin')
        else
            GMTclient.notify(source, {'You do not have Heroin.'})
        end
    end
end)

RegisterNetEvent('GMT:sellLSDNorth')
AddEventHandler('GMT:sellLSDNorth', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'LSD') > 0 then
            GMT.tryGetInventoryItem(user_id, 'LSD', 1, false)
            GMTclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(GMT.getCommissionPrice('LSDNorth'))})
            GMT.giveMoney(user_id, GMT.getCommissionPrice('LSDNorth'))
            GMT.turfSaleToGangFunds(GMT.getCommissionPrice('LSDNorth'), 'LSDNorth')
        else
            GMTclient.notify(source, {'You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('GMT:sellLSDSouth')
AddEventHandler('GMT:sellLSDSouth', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        if GMT.getInventoryItemAmount(user_id, 'LSD') > 0 then
            GMT.tryGetInventoryItem(user_id, 'LSD', 1, false)
            GMTclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(GMT.getCommissionPrice('LSDSouth'))})
            GMT.giveMoney(user_id, GMT.getCommissionPrice('LSDSouth'))
            GMT.turfSaleToGangFunds(GMT.getCommissionPrice('LSDSouth'), 'LSDSouth')
        else
            GMTclient.notify(source, {'You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('GMT:sellAll')
AddEventHandler('GMT:sellAll', function()
    local source = source
    local user_id = GMT.getUserId(source)
    if checkTraderBucket(source) then
        for k,v in pairs(defaultPrices) do
            if k == 'Copper' or k == 'Limestone' or k == 'Gold' then
                if GMT.getInventoryItemAmount(user_id, k) > 0 then
                    local amount = GMT.getInventoryItemAmount(user_id, k)
                    GMT.tryGetInventoryItem(user_id, k, amount, false)
                    GMTclient.notify(source, {'~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    GMT.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            elseif k == 'Diamond' then
                if GMT.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
                    local amount = GMT.getInventoryItemAmount(user_id, 'Processed Diamond')
                    GMT.tryGetInventoryItem(user_id, 'Processed Diamond', amount, false)
                    GMTclient.notify(source, {'~g~Sold '..'Processed Diamond'..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    GMT.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            end
        end
    end
end)