local isDisplayed = false;
local isStaffedon = false;
RegisterCommand("opencallmanager",function()
    isDisplayed = not isDisplayed
    if isDisplayed then
        SendNUIMessage({
            action = "show"
        })
        isDisplayed = true
        sendCurrentCalls()
        SetNuiFocus(isDisplayed, isDisplayed)
        SetNuiFocusKeepInput(isDisplayed)
    else
        SendNUIMessage({
            action = "hide"
        })
        SetNuiFocus(isDisplayed, isDisplayed)
    end
end)

RegisterNetEvent("FDM:closeManager")
AddEventHandler("FDM:closeManager", function()
    if isDisplayed then
        closeCallmanager()
    end
end)

RegisterNetEvent("FDM:updateCalls")
AddEventHandler("FDM:updateCalls", function()
    SendNUIMessage({action = "clear"})
    sendCurrentCalls()
end)

function sendCurrentCalls()
    local fetchedCalls = TriggerServerCallback("callManager:FetchCalls")
    if fetchedCalls ~= nil then
        for k,v in pairs(fetchedCalls) do
            SendNUIMessage({
                action = "update",
                ticketID = v[5],
                type = v[4],
                message = v[3],
                time = v[6]
            })
        end
    end
end

function closeCallmanager()
    SendNUIMessage({
        action = "hide"
    })
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    isDisplayed = false;
end

RegisterKeyMapping("opencallmanager", "Open calls manager", "KEYBOARD", "F6")

RegisterNUICallback('FDM:TakeCall', function(data, cb)
    TriggerServerEvent("FDM:TakeTicket", data.ticketID)
end)

RegisterNUICallback('FDM:DC', function(data, cb)
    TriggerServerEvent("FDM:Declinecall", data.ticketID)
end)

Citizen.CreateThread(function()
    while true do 
        if isDisplayed then
            DisableAllControlActions(0)
        end
        Wait(0)
    end
end)

local staffConfig = {
    [3] = {value = 14, texture = 1};
    [4] = {value = 185, texture = 2};
    [8] = {value = 15, texture = 1};
    [11] = {value = 200, texture = 1};
}


local savedClothing = {
    [3] = {};
    [4] = {};
    [8] = {};
    [11] = {};
}

RegisterNetEvent("FDM:Staff", function(bool)
    setPlayerStaffMode(bool)
end)

function setPlayerStaffMode(bool)
    local playerPed = PlayerPedId()
    if bool then
        for k,v in pairs(staffConfig) do
            savedClothing[k] = {value = GetPedDrawableVariation(playerPed, k), texture = GetPedTextureVariation(playerPed, k)}
            SetPedComponentVariation(playerPed, k, v.value, v.texture, 0)
        end
        SendNUIMessage({
            action = "showStaff";
        })
    else
        for k,v in pairs(savedClothing) do
            SetPedComponentVariation(playerPed, k, v.value, v.texture, 0)
        end
        SendNUIMessage({
            action = "hideStaff";
        })
    end
    isStaffedon = bool;
end