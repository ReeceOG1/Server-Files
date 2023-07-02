local a = false
SetNuiFocus(false, false)
function func_playerlistControl()
    if IsUsingKeyboard(2) then
        if IsControlJustPressed(0, 212) then
            a = not a
            TriggerServerEvent("LUNA:getPlayerListData")
            Wait(100)
            sendFullPlayerListData()
            SetNuiFocus(true, true)
            SendNUIMessage({showPlayerList = true})
        end
    end
end
tLUNA.createThreadOnTick(func_playerlistControl)
RegisterNUICallback(
    "closeLUNAPlayerList",
    function(b, c)
        SetNuiFocus(false, false)
    end
)
AddEventHandler(
    "LUNA:onClientSpawn",
    function(d, e)
        if e then
            TriggerServerEvent("LUNA:getPlayerListData")
        end
    end
)
RegisterNetEvent(
    "LUNA:gotFullPlayerListData",
    function(f, g, h, i, j, k)
        StaffPlayerData = f
        PoliceData = g
        NHSData = h
        LFBData = i
        HMPData = j
        playerData = k
    end
)
local l, m, n
RegisterNetEvent(
    "LUNA:playerListMetaUpdate",
    function(o)
        l, m, n = table.unpack(o)
        SendNUIMessage({wipeFooterPlayerList = true})
        SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #1 | </span>'})
        SendNUIMessage(
            {
                appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                    tostring(l) .. "</span>"
            }
        )
        SendNUIMessage(
            {
                appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                    tostring(m) .. "/" .. tostring(n) .. "</span>"
            }
        )
    end
)
function getLength(p)
    local q = 0
    for r in pairs(p) do
        q = q + 1
    end
    return q
end
function sendFullPlayerListData()
    local s = getLength(StaffPlayerData)
    local t = getLength(PoliceData)
    local u = getLength(NHSData)
    local v = getLength(LFBData)
    local w = getLength(HMPData)
    local x = getLength(playerData)
    SendNUIMessage({wipePlayerList = true})
    SendNUIMessage({clearServerMetaData = true})
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/luna.png" align="top" width="20px",height="20px"><span class="staff">' ..
                tostring(s) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/nhs.png" align="top" width="20",height="20"><span class="nhs">' ..
                tostring(u) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/lfb.png" align="top" width="20",height="20"><span class="lfb">' ..
                tostring(v) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/met.png" align="top"  width="24",height="24"><span class="police">' ..
                tostring(t) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/hmp.png" align="top"  width="24",height="24"><span class="hmp">' ..
                tostring(w) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/danny.png" align="top" width="20",height="20"><span class="aa">' ..
                tostring(x) .. "</span>"
        }
    )
    SendNUIMessage({wipeFooterPlayerList = true})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #1 | </span>'})
    SendNUIMessage(
        {
            appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                tostring(l) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                tostring(m) .. "/" .. tostring(n) .. "</span>"
        }
    )
    if s >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_staff">Staff</span>'})
    end
    for y, z in pairs(StaffPlayerData) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(StaffPlayerData[y].name) ..
                        '</span><span class="job">' ..
                            tostring(StaffPlayerData[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(StaffPlayerData[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if t >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_police">MET Police</span>'})
    end
    for y, z in pairs(PoliceData) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(PoliceData[y].name) ..
                        '</span><span class="job">' ..
                            tostring(PoliceData[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(PoliceData[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if u >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_nhs">NHS</span>'})
    end
    for y, z in pairs(NHSData) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(NHSData[y].name) ..
                        '</span><span class="job">' ..
                            tostring(NHSData[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(NHSData[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if v >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_lfb">LFB</span>'})
    end
    for y, z in pairs(LFBData) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(LFBData[y].name) ..
                        '</span><span class="job">' ..
                            tostring(LFBData[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(LFBData[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if w >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_hmp">HMP</span>'})
    end
    for y, z in pairs(HMPData) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(HMPData[y].name) ..
                        '</span><span class="job">' ..
                            tostring(HMPData[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(HMPData[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if x >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_civs">Civilians</span>'})
    end
    for y, z in pairs(playerData) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(playerData[y].name) ..
                        '</span><span class="job">' ..
                            tostring(playerData[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(playerData[y].hours) .. "hrs</span><br/>"
            }
        )
    end
end