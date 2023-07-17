local isPointsDisplaying = false;
local isPointsNumber = 0;
local isCurrentNumber = 0;
local isAlerts = {};

local function addDeath(killer)
    isCurrentNumber = isCurrentNumber + 1
    isAlerts[isCurrentNumber] = {false}
    SendNUIMessage({
        action = "alert",
        reason = "killedby",
        killed = killer,
        id = isCurrentNumber,
        points = 0,
    })
    isPointsDisplaying = true;
end

local function addKill(target)
    isCurrentNumber = isCurrentNumber + 1
    isAlerts[isCurrentNumber] = {false}
    SendNUIMessage({
        action = "alert",
        reason = "killed",
        killed = target,
        id = isCurrentNumber,
        points = 15, -- u can try trigger dis shun doesn't do anything just visual 
    })
    isPointsDisplaying = true;
end

RegisterNetEvent("FDM:AddClientDeath", function(killer)
    addDeath(killer)
end)

RegisterNetEvent("FDM:AddClientKill", function(target)
    addKill(target)
end)

Citizen.CreateThread(function()
    while true do
        Wait(1500)
        for k,v in pairs(isAlerts) do
            if (v[1]) then
                SendNUIMessage({
                    action = "hideAlert",
                    num = k;
                })
                isAlerts[k] = nil;
            else
                v[1] = true;
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        if isPointsDisplaying and not isAlerts[isCurrentNumber] then
            SendNUIMessage({
                action = "hidePoints"
            })
            isPointsDisplaying = false;
        end
        Wait(0)
    end
end)