local a = false
SetNuiFocus(false, false)
function func_playerlistControl()
    if IsUsingKeyboard(2) then
        if IsControlJustPressed(0, 212) then
            a = not a
            TriggerServerEvent("GMT:getPlayerListData")
            Wait(100)
            sendFullPlayerListData()
            SetNuiFocus(true, true)
            SendNUIMessage({showPlayerList = true})
        end
    end
end
tGMT.createThreadOnTick(func_playerlistControl)
RegisterNUICallback(
    "closeGMTPlayerList",
    function(b, c)
        SetNuiFocus(false, false)
    end
)
AddEventHandler(
    "GMT:onClientSpawn",
    function(d, e)
        if e then
            TriggerServerEvent("GMT:getPlayerListData")
        end
    end
)
RegisterNetEvent(
    "GMT:gotFullPlayerListData",
    function(f, g, h, i, j, l0, k)
        sortedPlayersStaff = f
        sortedPlayersPolice = g
        sortedPlayersNHS = h
        sortedPlayersLFB = i
        sortedPlayersHMP = j
        sortedPlayersAA = l0
        sortedPlayersCivillians = k
    end
)
local l, m, n
RegisterNetEvent(
    "GMT:playerListMetaUpdate",
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
    local s = getLength(sortedPlayersStaff)
    local t = getLength(sortedPlayersPolice)
    local u = getLength(sortedPlayersNHS)
    local v = getLength(sortedPlayersLFB)
    local w = getLength(sortedPlayersHMP)
    local z0 = getLength(sortedPlayersAA)
    local x = getLength(sortedPlayersCivillians)
    SendNUIMessage({wipePlayerList = true})
    SendNUIMessage({clearServerMetaData = true})
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/gmt.png" align="top" width="20px",height="20px"><span class="staff">' ..
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
            setServerMetaData = '<img src="playerlist_images/aa.png" align="top" width="20",height="20"><span class="aa">' ..
                tostring(z0) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/danny.png" align="top" width="20",height="20"><span class="Civilians">' ..
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
    for y, z in pairs(sortedPlayersStaff) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersStaff[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersStaff[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersStaff[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if t >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_police">MET Police</span>'})
    end
    for y, z in pairs(sortedPlayersPolice) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersPolice[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersPolice[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersPolice[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if u >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_nhs">NHS</span>'})
    end
    for y, z in pairs(sortedPlayersNHS) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersNHS[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersNHS[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersNHS[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if v >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_lfb">LFB</span>'})
    end
    for y, z in pairs(sortedPlayersLFB) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersLFB[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersLFB[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersLFB[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if w >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_hmp">HMP</span>'})
    end
    for y, z in pairs(sortedPlayersHMP) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersHMP[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersHMP[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersHMP[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if z0 >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_aa">AA</span>'})
    end
    for y, z in pairs(sortedPlayersAA) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersAA[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersAA[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersAA[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if x >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_civs">Civilians</span>'})
    end
    for y, z in pairs(sortedPlayersCivillians) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersCivillians[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersCivillians[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersCivillians[y].hours) .. "hrs</span><br/>"
            }
        )
    end
end
Citizen.CreateThread(
    function()
        while true do
            Wait(5000)
            if l ~= nil and m ~= nil and n ~= nil then
                SetDiscordAppId(1001015089022902292)
                SetDiscordRichPresenceAsset('gmtlogo')
                SetDiscordRichPresenceAssetText('GMT British RP')
                SetDiscordRichPresenceAssetSmall('gmtlogo')
                SetDiscordRichPresenceAssetSmallText('GMT British Roleplay')
                SetDiscordRichPresenceAction(1, "Join GMT", "fivem://connect/s1.gmt.city")
                --SetDiscordRichPresenceAction(0, "Join Discord", "https://discord.gg/gmt")
                SetRichPresence("[ID:" .. tostring(tGMT.getUserId()) .. "] | " .. tostring(m) .. "/" .. tostring(n))
            end
            Wait(15000)
        end
    end
)