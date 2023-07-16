local a = 0
local b = 0
local c = 0
local d = 3
proximityIdToString = {[1] = "Whisper", [2] = "Talking", [3] = "Shouting"}
local e, f = GetActiveScreenResolution()
local g = {}
RegisterNetEvent("FR:showHUD")
AddEventHandler(
    "FR:showHUD",
    function(h)
        showhudUI(h)
    end
)
AddEventHandler(
    "pma-voice:setTalkingMode",
    function(i)
        d = i
        local j = tFR.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
function updateMoneyUI(k, l, m, n, j, o)
    SendNUIMessage(
        {
            updateMoney = true,
            cash = k,
            bank = l,
            redmoney = m,
            proximity = proximityIdToString[n],
            topLeftAnchor = j,
            yAnchor = o
        }
    )
end
function showhudUI(h)
    SendNUIMessage({showMoney = h})
end
RegisterNetEvent("FR:setProfilePictures")
AddEventHandler(
    "FR:setProfilePictures",
    function(p)
        g = p
    end
)
RegisterNetEvent("FR:setDisplayMoney")
RegisterNetEvent(
    "FR:setDisplayMoney",
    function(q)
        local r = tostring(math.floor(q))
        a = getMoneyStringFormatted(r)
        local j = tFR.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
RegisterNetEvent("FR:setDisplayBankMoney")
AddEventHandler(
    "FR:setDisplayBankMoney",
    function(q)
        local r = tostring(math.floor(q))
        b = getMoneyStringFormatted(r)
        local j = tFR.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
RegisterNetEvent("FR:setDisplayRedMoney")
AddEventHandler(
    "FR:setDisplayRedMoney",
    function(q)
        local r = tostring(math.floor(q))
        c = getMoneyStringFormatted(r)
        local j = tFR.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
RegisterNetEvent("FR:initMoney")
AddEventHandler(
    "FR:initMoney",
    function(k, l)
        local s = tostring(math.floor(k))
        a = getMoneyStringFormatted(s)
        local r = tostring(math.floor(l))
        b = getMoneyStringFormatted(r)
        local j = tFR.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, j.rightX * j.resX)
    end
)
Citizen.CreateThread(
    function()
        Wait(4000)
        while tFR.getUserId() == nil do
            Wait(100)
        end
        TriggerServerEvent("FR:requestPlayerBankBalance")
        local t = false
        while true do
            local u, v = GetActiveScreenResolution()
            if u ~= e or v ~= f then
                e, f = GetActiveScreenResolution()
                cachedMinimapAnchor = GetMinimapAnchor()
                updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, cachedMinimapAnchor.rightX * cachedMinimapAnchor.resX)
            end
            if NetworkIsPlayerTalking(PlayerId()) then
                if not t then
                    t = true
                    SendNUIMessage({moneyTalking = true})
                end
            else
                if t then
                    t = false
                    SendNUIMessage({moneyTalking = false})
                end
            end
            Wait(0)
        end
    end
)
RegisterNUICallback(
    "moneyUILoaded",
    function(w, x)
        local j = tFR.getCachedMinimapAnchor()
        updateMoneyUI("£" .. tostring(a), "£" .. tostring(b), "£" .. tostring(c), d, j.rightX * j.resX)
    end
)
function tFR.updatePFPType(y)
    if not tFR.isPlatClub() and not tFR.isPlusClub() then
        y = "Steam"
    end
    SendNUIMessage({setPFP = g[y]})
end
