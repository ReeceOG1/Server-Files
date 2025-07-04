local a = {
    Cooldown = 15,
    DisableAllMessages = false,
    ChatSuggestions = true,
    Reminder = true,
    Message = "Attention all units, MET officer in distress!"
}

local b = {
    Cooling = 0,
    Tuned = true
}

function getHeadshot(c)
    local handle = RegisterPedheadshot(c)
    if not IsPedheadshotValid(handle) then
        return "CHAR_BLOCKED"
    end
    local d = GetGameTimer()
    while not IsPedheadshotReady(handle) do
        if GetGameTimer() - d > 2500 then
            UnregisterPedheadshot(handle)
            return "CHAR_BLOCKED"
        end
        Wait(0)
    end
    local e = GetPedheadshotTxdString(handle)
    return e, handle
end

RegisterCommand("panic", function()
    if globalOnPoliceDuty or globalNHSOnDuty or globalOnPrisonDuty or globalLFBOnDuty or PlayerIsInGang then
        if b.Cooling == 0 then
            local f = {
                Player = tGMT.getPlayerId(),
                Ped = tGMT.getPlayerPed(),
                Name = tGMT.getPlayerName(tGMT.getPlayerId()),
                Coords = GetEntityCoords(tGMT.getPlayerPed()),
                Location = {}
            }
            f.Location.Street, f.Location.CrossStreet = GetStreetNameAtCoord(f.Coords.x, f.Coords.y, f.Coords.z)
            f.Location.Street = GetStreetNameFromHashKey(f.Location.Street)
            if f.Location.CrossStreet ~= 0 then
                f.Location.CrossStreet = GetStreetNameFromHashKey(f.Location.CrossStreet)
                f.Location = f.Location.Street .. " X " .. f.Location.CrossStreet
            else
                f.Location = f.Location.Street
            end
            if globalOnPoliceDuty then
                TriggerServerEvent("GMT:newPanic", f, 3)
            elseif globalNHSOnDuty then
                TriggerServerEvent("GMT:newPanic", f, 2)
            elseif globalOnPrisonDuty then
                TriggerServerEvent("GMT:newPanic", f, 4)
            elseif globalLFBOnDuty then
                TriggerServerEvent("GMT:newPanic", f, 5)
            elseif PlayerIsInGang then
                f.isInGang = PlayerIsInGang
                TriggerServerEvent("GMT:newGangPanic", f,6)
            end
            
            b.Cooling = a.Cooldown
        else
            NewNoti("~r~Panic Button still cooling down.", true)
        end
    end
end)

RegisterNetEvent("GMT:returnPanic", function(g, f, h)
    local i = tGMT.getUserId()
    if globalOnPoliceDuty or globalNHSOnDuty or globalOnPrisonDuty or globalLFBOnDuty and (h == 5 or h == 6) and not tGMT.isEmergencyService() then
        if h == 6 and tGMT.isEmergencyService() then
            return
        end
        SendNUIMessage({PayloadType = "Panic", Payload = g})
        f.Headshot, handle = getHeadshot(GetPlayerPed(GetPlayerFromServerId(f.Source)))
        if h == 2 then
            tGMT.notifyPicture2(f.Headshot, 2, string.format("NHS - %s", f.Name), false, "~r~NHS Paramedic in distress! - " .. f.Location)
        elseif h == 3 then
            tGMT.notifyPicture2(f.Headshot, 2, string.format("MET Police - %s", f.Name), false, "~r~Officer in distress! - " .. f.Location)
        elseif h == 4 then
            tGMT.notifyPicture2(f.Headshot, 2, string.format("HM Prison - %s", f.Name), false, "~r~Prison Guard in distress! - " .. f.Location)
        elseif h == 5 then
            tGMT.notifyPicture2(f.Headshot, 2, string.format("LFB - %s", f.Name), false, "~r~LFB Panic Alarm Activated! - " .. f.Location)
        elseif h == 6 then
            tGMT.notifyPicture2(f.Headshot, 2, string.format("%s", f.Name), false, "~r~Gang Member Panic! - " .. f.Location)
        end
        if handle ~= nil then
            UnregisterPedheadshot(handle)
        end
        Citizen.CreateThread(function()
            local j = AddBlipForRadius(f.Coords.x, f.Coords.y, f.Coords.z, 100.0)
            SetBlipRoute(j, true)
            Citizen.CreateThread(function()
                while j do
                    SetBlipRouteColour(j, 1)
                    Citizen.Wait(150)
                    SetBlipRouteColour(j, 6)
                    Citizen.Wait(150)
                    SetBlipRouteColour(j, 35)
                    Citizen.Wait(150)
                    SetBlipRouteColour(j, 6)
                end
            end)
            SetBlipColour(j, h)
            SetBlipAlpha(j, 60)
            SetBlipFlashes(j, true)
            SetBlipFlashInterval(j, 200)
            Citizen.Wait(90000)
            RemoveBlip(j)
            j = nil
        end)
        local k = GetSoundId()
        PlaySoundFrontend(k, "police_notification", "DLC_AS_VNT_Sounds", true)
        ReleaseSoundId(k)
    end
end)

function NewNoti(l, m)
    if not a.DisableAllMessages then
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(l)
        EndTextCommandThefeedPostTicker(m, true)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if b.Cooling ~= 0 then
            b.Cooling = b.Cooling - 1
            Citizen.Wait(1000)
        end
    end
end)

function printTable(tbl, indent)
    indent = indent or ""
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(indent .. k .. ":")
            printTable(v, indent .. "  ")
        else
            print(indent .. k .. " " .. tostring(v))
        end
    end
end