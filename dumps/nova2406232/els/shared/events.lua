local lookup = {
    ["NOVAELS:changeStage"] = "NOVAELS:1",
    ["NOVAELS:toggleSiren"] = "NOVAELS:2",
    ["NOVAELS:toggleBullhorn"] = "NOVAELS:3",
    ["NOVAELS:patternChange"] = "NOVAELS:4",
    ["NOVAELS:vehicleRemoved"] = "NOVAELS:5",
    ["NOVAELS:indicatorChange"] = "NOVAELS:6"
}

local origRegisterNetEvent = RegisterNetEvent
RegisterNetEvent = function(name, callback)
    origRegisterNetEvent(lookup[name], callback)
end

if IsDuplicityVersion() then
    local origTriggerClientEvent = TriggerClientEvent
    TriggerClientEvent = function(name, target, ...)
        origTriggerClientEvent(lookup[name], target, ...)
    end

    TriggerClientScopeEvent = function(name, target, ...)
        exports["NOVA"]:TriggerClientScopeEvent(lookup[name], target, ...)
    end
else
    local origTriggerServerEvent = TriggerServerEvent
    TriggerServerEvent = function(name, ...)
        origTriggerServerEvent(lookup[name], ...)
    end
end