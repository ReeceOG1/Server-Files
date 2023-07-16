
local cfg = module("cfg/cfg_licensecentre")

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(job, name)
    local source = source
    local user_id = GMT.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if not GMT.hasGroup(user_id, "Rebel") and job == "AdvancedRebel" then
        GMTclient.notify(source, {"You need to have Rebel License."})
        return
    end
    if #(playerCoords - coords) <= 15.0 then
        if GMT.hasGroup(user_id, job) then 
            GMTclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("gmt:PlaySound", source, 2)
        else
            for k,v in pairs(cfg.licenses) do
                if v.group == job then
                    if GMT.tryFullPayment(user_id, v.price) then
                        GMT.addUserGroup(user_id,job)
                        GMTclient.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
                        tGMT.sendWebhook('purchases',"GMT License Centre Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**")
                        TriggerClientEvent("gmt:PlaySound", source, 1)
                        TriggerClientEvent("GMT:gotOwnedLicenses", source, getLicenses(user_id))
                        TriggerClientEvent("GMT:refreshGunStorePermissions", source)
                    else 
                        GMTclient.notify(source, {"You do not have enough money to purchase this license!"})
                        TriggerClientEvent("gmt:PlaySound", source, 2)
                    end
                end
            end
        end
    else 
        TriggerEvent("GMT:acBan", userid, 11, GetPlayerName(source), source, 'Trigger License Menu Purchase')
    end
end)





function getLicenses(user_id)
    local licenses = {}
    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if GMT.hasGroup(user_id, v.group) then
                table.insert(licenses, v.name)
            end
        end
        return licenses
    end
end

RegisterNetEvent("GMT:GetLicenses")
AddEventHandler("GMT:GetLicenses", function()
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("GMT:RecievedLicenses", source, getLicenses(user_id))
    end
end)

RegisterNetEvent("GMT:getOwnedLicenses")
AddEventHandler("GMT:getOwnedLicenses", function()
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("GMT:gotOwnedLicenses", source, getLicenses(user_id))
    end
end)