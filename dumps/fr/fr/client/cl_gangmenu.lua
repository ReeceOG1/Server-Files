PlayerIsInGang = false
GangBalance = 0
FRGangInvites = {}
FRGangInviteIndex = 0
selectedGangInvite = nil
selectedMember = nil
gangID = nil
gangPermission = 0
local a = nil
local b = {}
local c = 1
local d = 1
local e = 1
local f = 1
FRGangMembers = {}
local g = false
local h = nil
local i = nil
local j = {
    ["White"] = {hud = 0, blip = 0},
    ["Red"] = {hud = 6, blip = 1},
    ["Green"] = {hud = 18, blip = 2},
    ["Blue"] = {hud = 9, blip = 3},
    ["Yellow"] = {hud = 12, blip = 5},
    ["Violet"] = {hud = 21, blip = 7},
    ["Pink"] = {hud = 24, blip = 8},
    ["Orange"] = {hud = 15, blip = 17},
    ["Cyan"] = {hud = 52, blip = 30},
    ["Black"] = {hud = 3, blip = 39},
    ["Baby Pink"] = {hud = 193, blip = 34}
}
local k = j["White"]
local l = GetResourceKvpString("fr_gang_colour") or "White"
local function m()
    return FRGangMembers
end
RegisterNetEvent("FR:GotGangData")
AddEventHandler(
    "FR:GotGangData",
    function(n, o, h, p, q, r, s)
        if n == nil then
            PlayerIsInGang = false
        else
            PlayerIsInGang = true
            TriggerServerEvent("FR:setPersonalGangBlipColour", l)
            b = {}
            gangLogs = {}
            e = 1
            f = 1
            GangBalance = getMoneyStringFormatted(math.floor(n.money))
            gangID = n.id
            gangPermission = tonumber(h)
            g = q
            gangMaxWithdraw = r
            gangLimitWithdrawDeposit = s
            if o ~= nil then
                FRGangMembers = o
                local t = 1
                b[t] = {}
                for n, u in ipairs(o) do
                    if (n - 1) % 10 == 0 and n ~= 1 then
                        t = t + 1
                        b[t] = {}
                        e = e + 1
                    end
                    b[t][n - (t - 1) * 10] = u
                end
            end
            if p ~= nil then
                local t = 1
                gangLogs[t] = {}
                for i, u in pairs(p) do
                    if i % 11 == 0 then
                        t = t + 1
                        gangLogs[t] = {}
                        f = f + 1
                    else
                        gangLogs[t][i - (t - 1) * 11] = u
                    end
                end
            end
        end
    end
)
RegisterNetEvent("FR:disbandedGang")
AddEventHandler("FR:disbandedGang",function()
        a = "none"
        PlayerIsInGang = false
        FRGangMembers = {}
        TriggerEvent("FR:ForceRefreshData")
end)
RegisterNetEvent("FR:ForceRefreshData")
AddEventHandler("FR:ForceRefreshData",function()
        TriggerServerEvent("FR:GetGangData")
    end)
RegisterNetEvent("FR:InviteReceived")
AddEventHandler(
    "FR:InviteReceived",
    function(v, w)
        FRGangInvites[FRGangInviteIndex] = w
        FRGangInviteIndex = FRGangInviteIndex + 1
        tFR.notify(v)
    end
)
RegisterNetEvent("FR:gangNameNotTaken")
AddEventHandler(
    "FR:gangNameNotTaken",
    function()
        a = "main"
        PlayerIsInGang = true
    end
)
function func_drawGangUI()
    if a == "none" then
        DrawRect(0.471, 0.329, 0.285, -0.005, 0, 168, 255, 204)
        DrawRect(0.471, 0.304, 0.285, 0.046, 0, 0, 0, 150)
        DrawRect(0.471, 0.428, 0.285, 0.194, 0, 0, 0, 150)
        DrawRect(
            0.383,
            0.442,
            0.066,
            0.046,
            CreateGangSelectionRed,
            CreateGangSelectionGreen,
            CreateGangSelectionBlue,
            150
        )
        DrawRect(0.469, 0.442, 0.066, 0.046, JoinGangSelectionRed, JoinGangSelectionGreen, JoinGangSelectionBlue, 150)
        DrawAdvancedText(0.558, 0.303, 0.005, 0.0028, 0.539, "FR Gangs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.478, 0.442, 0.005, 0.0028, 0.473, "Create Gang", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.564, 0.443, 0.005, 0.0028, 0.473, "Join Gang", 255, 255, 255, 255, 4, 0)
        DrawRect(0.561, 0.377, 0.065, -0.003, 0, 168, 255, 204)
        DrawAdvancedText(0.654, 0.37, 0.005, 0.0028, 0.364, "Invite list", 255, 255, 255, 255, 4, 0)
        for x, y in pairs(FRGangInvites) do
            DrawAdvancedText(0.656, 0.398 + 0.020 * x, 0.005, 0.0028, 0.234, y, 255, 255, 255, 255, 0, 0)
            if CursorInArea(0.525, 0.59, 0.38 + 0.02 * x, 0.396 + 0.02 * x) and x ~= selectedGangInvite then
                DrawRect(0.56, 0.39 + 0.02 * x, 0.062, 0.019, 0, 168, 255, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    selectedGangInvite = x
                end
            elseif x == selectedGangInvite then
                DrawRect(0.56, 0.39 + 0.02 * x, 0.062, 0.019, 0, 168, 255, 150)
            end
        end
        if CursorInArea(0.35, 0.415, 0.415, 0.46) then
            CreateGangSelectionRed = 0
            CreateGangSelectionGreen = 168
            CreateGangSelectionBlue = 255
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                createGangName = GetGangNameText()
                if createGangName ~= nil and createGangName ~= "null" and createGangName ~= "" then
                    TriggerServerEvent("FR:CreateGang", createGangName)
                else
                    tFR.notify("~r~No gang name entered!")
                end
            end
        else
            CreateGangSelectionRed = 0
            CreateGangSelectionGreen = 0
            CreateGangSelectionBlue = 0
        end
        if CursorInArea(0.435, 0.51, 0.415, 0.46) then
            JoinGangSelectionRed = 0
            JoinGangSelectionGreen = 168
            JoinGangSelectionBlue = 255
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if selectedGangInvite ~= nil then
                    selectedGangInvite = FRGangInvites[selectedGangInvite]
                    TriggerServerEvent("FR:addUserToGang", selectedGangInvite)
                    FRGangInvites = {}
                    a = "main"
                    FRGangInviteIndex = 0
                    PlayerIsInGang = true
                else
                    tFR.notify("~r~No gang invite selected")
                end
            end
        else
            JoinGangSelectionRed = 0
            JoinGangSelectionGreen = 0
            JoinGangSelectionBlue = 0
        end
    end
    if a == "funds" then
        DrawRect(0.501, 0.558, 0.421, 0.326, 0, 0, 0, 150)
        DrawRect(0.501, 0.374, 0.421, 0.047, h.theme.r, h.theme.g, h.theme.b, 248)
        DrawAdvancedText(0.591, 0.378, 0.005, 0.0028, 0.48, "FR Gang - Funds", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.581, 0.464, 0.005, 0.0028, 0.5, "Gang Funds", 255, 255, 255, 255, 0, 0)
        DrawAdvancedText(0.581, 0.502, 0.005, 0.0028, 0.4, "£" .. GangBalance, 25, 199, 65, 255, 0, 0)
        DrawAdvancedText(0.436, 0.578, 0.005, 0.0028, 0.4, "Deposit (1% Fee)", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.536, 0.578, 0.005, 0.0028, 0.4, "Deposit All (1% Fee)", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.637, 0.578, 0.005, 0.0028, 0.4, "Withdraw", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.737, 0.578, 0.005, 0.0028, 0.4, "Withdraw All", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.3083, 0.3718, 0.5490, 0.5999) then
            DrawRect(0.341, 0.576, 0.075, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                amount = GetMoneyAmountText()
                if amount ~= nil then
                    TriggerServerEvent("FR:depositGangBalance", gangID, amount)
                else
                    tFR.notify("~r~No amount entered!")
                end
            end
        else
            DrawRect(0.341, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.4083, 0.4718, 0.5490, 0.5999) then
            DrawRect(0.441, 0.576, 0.075, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                TriggerServerEvent("FR:depositAllGangBalance", gangID)
            end
        else
            DrawRect(0.441, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.5088, 0.5739, 0.5481, 0.6018) then
            DrawRect(0.542, 0.576, 0.075, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                amount = GetMoneyAmountText()
                if amount ~= nil then
                    if gangPermission >= 3 then
                        TriggerServerEvent("FR:withdrawGangBalance", gangID, amount)
                    else
                        tFR.notify("~r~You don't have a high enough rank to withdraw")
                    end
                else
                    tFR.notify("~r~No amount entered!")
                end
            end
        else
            DrawRect(0.542, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6088, 0.6739, 0.5481, 0.6018) then
            DrawRect(0.642, 0.576, 0.075, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 3 then
                    TriggerServerEvent("FR:withdrawAllGangBalance", gangID)
                else
                    tFR.notify("~r~You don't have a high enough rank to withdraw")
                end
            end
        else
            DrawRect(0.642, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "contributions" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, h.theme.r, h.theme.g, h.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "FR Gang - Contributions", 255, 255, 255, 255, 7, 0)
        DrawRect(0.502, 0.518, 0.387, 0.283, 0, 0, 0, 150)
        DrawAdvancedText(0.449, 0.365, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.53, 0.365, 0.005, 0.0028, 0.4, "UserID", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.63, 0.365, 0.005, 0.0028, 0.4, "Last Contribution", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.730, 0.365, 0.005, 0.0028, 0.4, "Total Amount", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.547, 0.688, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.639, 0.688, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.591, 0.688, 0.005, 0.0028, 0.4, tostring(c) .. "/" .. tostring(e), 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        for x, z in pairs(b[c]) do
            name, id = table.unpack(z)
            DrawAdvancedText(0.449, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, name, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.53, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, id, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(
                0.63,
                0.361 + 0.0287 * x,
                0.005,
                0.0028,
                0.4,
                z.contributions.date,
                255,
                255,
                255,
                255,
                6,
                0
            )
            DrawAdvancedText(
                0.730,
                0.361 + 0.0287 * x,
                0.005,
                0.0028,
                0.4,
                z.contributions.amount,
                255,
                255,
                255,
                255,
                6,
                0
            )
        end
        if CursorInArea(0.419271, 0.482813, 0.667593, 0.699074) then
            DrawRect(0.452, 0.686, 0.065, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if c <= 1 then
                    tFR.notify("~r~Lowest page reached")
                else
                    c = c - 1
                end
            end
        else
            DrawRect(0.452, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.512500, 0.575521, 0.667593, 0.699074) then
            DrawRect(0.545, 0.686, 0.065, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if c >= e then
                    tFR.notify("~r~Max page reached")
                else
                    c = c + 1
                end
            end
        else
            DrawRect(0.545, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "funds"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "members" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, h.theme.r, h.theme.g, h.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "FR Gang - Members", 255, 255, 255, 255, 7, 0)
        DrawRect(0.448, 0.52, 0.295, 0.291, 0, 0, 0, 150)
        DrawAdvancedText(0.429, 0.359, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.486, 0.359, 0.005, 0.0028, 0.4, "ID", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.535, 0.359, 0.005, 0.0028, 0.4, "Rank", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.605, 0.359, 0.005, 0.0028, 0.4, "Last Seen", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.665, 0.359, 0.005, 0.0028, 0.4, "Playtime", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.746, 0.39, 0.005, 0.0028, 0.4, "Promote", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.465, 0.005, 0.0028, 0.4, "Demote", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.54, 0.005, 0.0028, 0.4, "Kick", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.615, 0.005, 0.0028, 0.4, "Invite", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.491, 0.695, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.581, 0.695, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.536, 0.695, 0.005, 0.0028, 0.4, tostring(c) .. "/" .. tostring(e), 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        for x, z in pairs(b[c]) do
            name, id, rank, lastseen, playtime = table.unpack(z)
            rank = tostring(rank)
            if rank == nil or rank == "nil" or rank == "NULL" then
                rank = "1"
            elseif rank <= "1" then
                rank = "Recruit"
            elseif rank == "2" then
                rank = "Member"
            elseif rank == "3" then
                rank = "Senior"
            elseif rank >= "4" then
                rank = "Leader"
            end
            DrawAdvancedText(0.429, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, name, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.486, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, id, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.535, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, rank, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.605, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, lastseen, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(
                0.665,
                0.361 + 0.0287 * x,
                0.005,
                0.0028,
                0.4,
                playtime .. " hours",
                255,
                255,
                255,
                255,
                6,
                0
            )
            if
                CursorInArea(0.3005, 0.5955, 0.3731 + 0.0287 * (x - 1), 0.4018 + 0.0287 * (x - 1)) and
                    selectedMember ~= id
             then
                DrawRect(0.448, 0.388 + 0.0287 * (x - 1), 0.295, 0.027, h.theme.r, h.theme.g, h.theme.b, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    selectedMember = id
                end
            elseif selectedMember == id then
                DrawRect(0.448, 0.388 + 0.0287 * (x - 1), 0.295, 0.027, h.theme.r, h.theme.g, h.theme.b, 150)
            end
        end
        if CursorInArea(0.6182, 0.6822, 0.360, 0.416) then
            DrawRect(0.651, 0.388, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if selectedMember ~= nil and PlayerIsInGang and gangID ~= nil then
                    if gangPermission >= 4 then
                        TriggerServerEvent("FR:PromoteUser", gangID, tonumber(selectedMember))
                    else
                        tFR.notify("~r~You don't have permission to promote!")
                    end
                else
                    tFR.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.388, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.435, 0.491) then
            DrawRect(0.651, 0.463, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if selectedMember ~= nil and PlayerIsInGang and gangID ~= nil then
                    if gangPermission >= 4 then
                        if selectedMember == tFR.getUserId() then
                            tFR.notify("~r~You can't demote yourself.")
                        else
                            TriggerServerEvent("FR:DemoteUser", gangID, selectedMember)
                        end
                    else
                        tFR.notify("~r~You don't have permission to demote!")
                    end
                else
                    tFR.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.463, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.510, 0.566) then
            DrawRect(0.651, 0.538, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if selectedMember ~= nil then
                    if gangPermission >= 3 then
                        if YesNoConfirm() then
                            TriggerServerEvent("FR:kickMemberFromGang", gangID, selectedMember)
                        end
                    else
                        tFR.notify("~r~You don't have permission to kick!")
                    end
                else
                    tFR.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.538, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.585, 0.641) then
            DrawRect(0.651, 0.613, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                local A = GetPlayerPermID()
                if A ~= nil then
                    if gangPermission >= 2 then
                        TriggerServerEvent("FR:InviteUserToGang", gangID, A)
                    else
                        tFR.notify("~r~You don't have permission to invite players")
                    end
                else
                    tFR.notify("No player name entered")
                end
            end
        else
            DrawRect(0.651, 0.613, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.3735, 0.4185, 0.6768, 0.7074) then
            DrawRect(0.396, 0.693, 0.045, 0.033, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if c <= 1 then
                    tFR.notify("~r~Lowest page reached")
                else
                    c = c - 1
                end
            end
        else
            DrawRect(0.396, 0.693, 0.045, 0.033, 0, 0, 0, 150)
        end
        if CursorInArea(0.4635, 0.5085, 0.6712, 0.7064) then
            DrawRect(0.486, 0.693, 0.045, 0.033, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if c >= e then
                    tFR.notify("~r~Max page reached")
                else
                    c = c + 1
                end
            end
        else
            DrawRect(0.486, 0.693, 0.045, 0.033, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "logs" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, h.theme.r, h.theme.g, h.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "FR Gang - Logs", 255, 255, 255, 255, 7, 0)
        DrawRect(0.502, 0.518, 0.387, 0.283, 0, 0, 0, 150)
        DrawAdvancedText(0.449, 0.365, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.51, 0.365, 0.005, 0.0028, 0.4, "UserID", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.583, 0.365, 0.005, 0.0028, 0.4, "Date", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.460, 0.688, 0.005, 0.0028, 0.4, "Set Webhook", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.547, 0.688, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.639, 0.688, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.591, 0.688, 0.005, 0.0028, 0.4, tostring(d) .. "/" .. tostring(f), 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.673, 0.365, 0.005, 0.0028, 0.4, "Action", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.757, 0.365, 0.005, 0.0028, 0.4, "Value", 255, 255, 255, 255, 4, 0)
        if gangLogs[d] ~= nil then
            for x, z in pairs(gangLogs[d]) do
                name, id, date, action, value = table.unpack(z)
                DrawAdvancedText(0.449, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, name, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.51, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, id, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.583, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, date, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.673, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, action, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.757, 0.361 + 0.0287 * x, 0.005, 0.0028, 0.4, value, 255, 255, 255, 255, 6, 0)
            end
        end
        if CursorInArea(0.33, 0.395, 0.667593, 0.699074) then
            DrawRect(0.365, 0.686, 0.065, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                TriggerServerEvent("FR:SetGangWebhook", gangID)
            end
        else
            DrawRect(0.365, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.419271, 0.482813, 0.667593, 0.699074) then
            DrawRect(0.452, 0.686, 0.065, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if d <= 1 then
                    tFR.notify("~r~Lowest page reached")
                else
                    d = d - 1
                end
            end
        else
            DrawRect(0.452, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.512500, 0.575521, 0.667593, 0.699074) then
            DrawRect(0.545, 0.686, 0.065, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if d >= f then
                    tFR.notify("~r~Max page reached")
                else
                    d = d + 1
                end
            end
        else
            DrawRect(0.545, 0.686, 0.065, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "settings" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, h.theme.r, h.theme.g, h.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "FR Gang - Settings", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.7, 0.360, 0.005, 0.0028, 0.46, "Current Gang: " .. gangID, 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.7, 0.398, 0.005, 0.0028, 0.46, "Permissions Guide", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(
            0.7,
            0.436,
            0.005,
            0.0028,
            0.46,
            "A Recruit can deposit to the gang funds only.",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.7, 0.472, 0.005, 0.0028, 0.46, "A Member can invite users", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(
            0.7,
            0.51,
            0.005,
            0.0028,
            0.46,
            "A Senior can invite and kick members,",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(
            0.7,
            0.532,
            0.005,
            0.0028,
            0.46,
            "withdraw from gang funds and set logs webhook.",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(
            0.7,
            0.572,
            0.005,
            0.0028,
            0.46,
            "A Leader can promote and demote members",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.7, 0.594, 0.005, 0.0028, 0.46, "and lock gang funds.", 255, 255, 255, 255, 6, 0)
        local B = h.blips and "Disable" or "Enable"
        DrawAdvancedText(0.451, 0.416, 0.005, 0.0028, 0.4, B .. " Blips", 255, 255, 255, 255, 6, 0)
        if CursorInArea(0.3187, 0.3937, 0.3712, 0.4462) then
            DrawRect(0.357, 0.41, 0.075, 0.076, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                h.blips = not h.blips
                SetResourceKvp("fr_gang_blips", tostring(h.blips))
            end
        else
            DrawRect(0.357, 0.41, 0.075, 0.076, 0, 0, 0, 150)
        end
        local C = h.pings and "Disable" or "Enable"
        DrawAdvancedText(0.554, 0.415, 0.005, 0.0028, 0.4, C .. " Pings", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.4197, 0.4932, 0.3712, 0.4462) then
            DrawRect(0.457, 0.41, 0.075, 0.076, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                h.pings = not h.pings
                SetResourceKvp("fr_gang_pings", tostring(h.pings))
            end
        else
            DrawRect(0.457, 0.41, 0.075, 0.076, 0, 0, 0, 150)
        end
        local D = h.names and "Disable" or "Enable"
        DrawAdvancedText(0.451, 0.516, 0.005, 0.0028, 0.4, D .. " Names", 255, 255, 255, 255, 6, 0)
        if CursorInArea(0.3187, 0.3937, 0.4712, 0.5462) then
            DrawRect(0.357, 0.51, 0.075, 0.076, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                h.names = not h.names
                SetResourceKvp("fr_gang_turf_alerts", tostring(h.names))
            end
        else
            DrawRect(0.357, 0.51, 0.075, 0.076, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.554, 0.515, 0.005, 0.0028, 0.4, "Rename Gang", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.4197, 0.4932, 0.4712, 0.5462) then
            DrawRect(0.457, 0.51, 0.075, 0.076, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                newGangName = GetGangNameText()
                if newGangName ~= nil and newGangName ~= "null" and newGangName ~= "" and gangID ~= nil then
                    TriggerServerEvent("FR:RenameGang", gangID, newGangName)
                else
                    tFR.notify("~r~No gang name entered!")
                end
            end
        else
            DrawRect(0.457, 0.51, 0.075, 0.076, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.451, 0.616, 0.005, 0.0028, 0.4, "Leave Gang", 255, 255, 255, 255, 6, 0)
        if CursorInArea(0.3187, 0.3937, 0.5712, 0.6462) then
            DrawRect(0.357, 0.61, 0.075, 0.076, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if YesNoConfirm() then
                    TriggerServerEvent("FR:memberLeaveGang", gangID)
                    setCursor(0)
                    SetPlayerControl(PlayerId(), 1, 0)
                end
            end
        else
            DrawRect(0.357, 0.61, 0.075, 0.076, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.554, 0.615, 0.005, 0.0028, 0.4, "Disband Gang", 255, 255, 255, 255, 6, 0)
        if CursorInArea(0.4197, 0.4932, 0.5712, 0.6462) then
            DrawRect(0.457, 0.61, 0.075, 0.076, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 4 then
                    if YesNoConfirm() == true and gangID ~= nil then
                        TriggerServerEvent("FR:DeleteGang", gangID)
                    end
                else
                    tFR.notify("~r~You don't have permission to disband!")
                end
            end
        else
            DrawRect(0.457, 0.61, 0.075, 0.076, 0, 0, 0, 150)
        end
        DrawAdvancedText(
            0.451,
            0.693,
            0.005,
            0.0028,
            0.4,
            h.healthui and "Disable Health UI" or "Enable Health UI",
            255,
            255,
            255,
            255,
            4,
            0
        )
        if CursorInArea(0.31, 0.39, 0.6712, 0.7064) then
            DrawRect(0.357, 0.689, 0.075, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                h.healthui = not h.healthui
                SetResourceKvp("fr_gang_healthui", tostring(h.healthui))
            end
        else
            DrawRect(0.357, 0.689, 0.075, 0.036, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.551, 0.693, 0.005, 0.0028, 0.4, "Set Gang Fit", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.41, 0.49, 0.6712, 0.7064) then
            DrawRect(0.457, 0.689, 0.075, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 4 then
                    TriggerServerEvent("FR:setGangFit", gangID)
                else
                    tFR.notify("~r~You don't have permission to set gang fit!")
                end
            end
        else
            DrawRect(0.457, 0.689, 0.075, 0.036, 0, 0, 0, 150)
        end
        local E, F, G = GetHudColour(j[l].hud)
        --DrawAdvancedText(0.645, 0.63, 0.005, 0.0028, 0.46, "Your Blip Colour: ", 255, 255, 255, 255, 6, 0)
       -- DrawRect(0.62, 0.628, 0.05, 0.025, E, F, G, 255)
        if CursorInArea(0.595, 0.645, 0.6155, 0.6405) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                local H = false
                local I = false
                for J in pairs(j) do
                    if J == l then
                        H = true
                    elseif H then
                        l = J
                        I = true
                        break
                    end
                end
                if not I then
                    for J in pairs(j) do
                        l = J
                        break
                    end
                end
                SetResourceKvp("fr_gang_colour", l)
                TriggerServerEvent("FR:setPersonalGangBlipColour", l)
            end
        end
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "turfs" then
        DrawRect(0.501, 0.533, 0.421, 0.497, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, h.theme.r, h.theme.g, h.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "FR Gang - Turfs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(
            0.399,
            0.38,
            0.005,
            0.0028,
            0.4,
            "Weed Turf - (Owned by " .. turfData[1].gangOwner .. ") Commission - " .. globalWeedCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.44,
            0.005,
            0.0028,
            0.4,
            "Cocaine Turf - (Owned by " ..
                turfData[2].gangOwner .. ") Commission - " .. globalCocaineCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.50,
            0.005,
            0.0028,
            0.4,
            "Meth Turf - (Owned by " .. turfData[3].gangOwner .. ") Commission - " .. globalMethCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.56,
            0.005,
            0.0028,
            0.4,
            "Heroin Turf - (Owned by " ..
                turfData[4].gangOwner .. ") Commission - " .. globalHeroinCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.62,
            0.005,
            0.0028,
            0.4,
            "Large Arms - (Owned by " .. turfData[5].gangOwner .. ") Commission - " .. globalLargeArmsCommission .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.68,
            0.005,
            0.0028,
            0.4,
            "LSD North Turf - (Owned by " ..
                turfData[6].gangOwner .. ") Commission - " .. globalLSDNorthCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.399,
            0.74,
            0.005,
            0.0028,
            0.4,
            "LSD South Turf - (Owned by " ..
                turfData[7].gangOwner .. ") Commission - " .. globalLSDSouthCommissionPercent .. "%",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "security" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, h.theme.r, h.theme.g, h.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "FR gang - security", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.4, 0.575, 0.005, 0.0028, 0.46, "Lock gang funds:", 255, 255, 255, 255, 6, 1)
        DrawAdvancedText(
            0.4,
            0.605,
            0.005,
            0.0028,
            0.4,
            "Prevents any member from withdrawing funds from the gang.",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawRect(0.525, 0.575, 0.1, 0.03, 0, 0, 0, 175)
        DrawAdvancedText(0.575, 0.575, 0.005, 0.0028, 0.46, g and "Yes" or "No", 255, 255, 255, 255, 6, 1)
        if CursorInArea(0.31, 0.65, 0.56, 0.61) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if gangPermission >= 4 then
                    TriggerServerEvent("FR:LockGangFunds", gangID)
                else
                    notify("~r~You must be a leader to change security.")
                end
            end
        end
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "theme" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, h.theme.r, h.theme.g, h.theme.b, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "FR Gang - Theme", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(
            0.7,
            0.360,
            0.005,
            0.0028,
            0.46,
            "The theme will be frequent throughout the",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(
            0.7,
            0.396,
            0.005,
            0.0028,
            0.46,
            "gang menu and used as your marker colour.",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.490, 0.380, 0.005, 0.0028, 0.48, "Current Theme", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(
            0.490,
            0.405,
            0.005,
            0.0028,
            0.48,
            "(" .. h.theme.r .. "," .. h.theme.g .. "," .. h.theme.b .. ")",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.420, 0.693, 0.005, 0.0028, 0.4, "Blue", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.480, 0.693, 0.005, 0.0028, 0.4, "Pink", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.540, 0.693, 0.005, 0.0028, 0.4, "Green", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.600, 0.693, 0.005, 0.0028, 0.4, "Red", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.660, 0.693, 0.005, 0.0028, 0.4, "Cyan", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.720, 0.693, 0.005, 0.0028, 0.4, "Orange", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.647, 0.447, 0.005, 0.0028, 0.4, "Copy theme", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.647, 0.573, 0.005, 0.0028, 0.4, "Random Colour", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.447, 0.005, 0.0028, 0.4, "Reset Colour", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.572, 0.005, 0.0028, 0.4, "Custom Colour", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        DrawRect(0.395, 0.51, 0.1, 0.13, h.theme.r, h.theme.g, h.theme.b, 248)
        if CursorInArea(0.5187, 0.5828, 0.4138, 0.4694) then
            DrawRect(0.552, 0.443, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.CopyToClipboard(h.theme.r .. "," .. h.theme.g .. "," .. h.theme.b)
                tFR.notify("~g~Theme copied to clipboard.")
            end
        else
            DrawRect(0.552, 0.443, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.5187, 0.5828, 0.5407, 0.5962) then
            DrawRect(0.552, 0.569, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.gangMenuTheme(math.random(1, 255), math.random(1, 255), math.random(1, 255))
            end
        else
            DrawRect(0.552, 0.569, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.4138, 0.4694) then
            DrawRect(0.651, 0.443, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.gangMenuTheme(18, 82, 228)
            end
        else
            DrawRect(0.651, 0.443, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.5407, 0.5962) then
            DrawRect(0.651, 0.569, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.clientPrompt(
                    "Enter rgb value eg 255,100,150:",
                    "",
                    function(K)
                        if K ~= "" then
                            local L = stringsplit(K, ",")
                            if L[1] ~= nil and L[2] ~= nil and L[3] ~= nil then
                                tFR.gangMenuTheme(tonumber(L[1]), tonumber(L[2]), tonumber(L[3]))
                            else
                                tFR.notify("~r~Invalid value")
                            end
                        else
                            tFR.notify("~r~Invalid value")
                        end
                    end
                )
            end
        else
            DrawRect(0.651, 0.569, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.3033, 0.3506, 0.6712, 0.7064) then
            DrawRect(0.326, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.gangMenuTheme(18, 82, 228)
            end
        else
            DrawRect(0.326, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.3633, 0.4106, 0.6712, 0.7064) then
            DrawRect(0.386, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.gangMenuTheme(255, 0, 255)
            end
        else
            DrawRect(0.386, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.4233, 0.4706, 0.6712, 0.7064) then
            DrawRect(0.446, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.gangMenuTheme(0, 128, 0)
            end
        else
            DrawRect(0.446, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.4833, 0.5306, 0.6712, 0.7064) then
            DrawRect(0.506, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.gangMenuTheme(255, 0, 0)
            end
        else
            DrawRect(0.506, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.5433, 0.5906, 0.6712, 0.7064) then
            DrawRect(0.566, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.gangMenuTheme(0, 100, 100)
            end
        else
            DrawRect(0.566, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.6033, 0.6506, 0.6712, 0.7064) then
            DrawRect(0.626, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                tFR.gangMenuTheme(255, 165, 0)
            end
        else
            DrawRect(0.626, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "main"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "main" then
        DrawRect(0.501, 0.532, 0.375, 0.225, 0, 0, 0, 150)
        DrawRect(0.501, 0.396, 0.375, 0.046, h.theme.r, h.theme.g, h.theme.b, 255)
        DrawAdvancedText(0.591, 0.399, 0.005, 0.0028, 0.51, "FR Gangs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.46, 0.534, 0.005, 0.0028, 0.4, "funds", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.554, 0.534, 0.005, 0.0028, 0.4, "members", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.642, 0.534, 0.005, 0.0028, 0.4, "logs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.732, 0.534, 0.005, 0.0028, 0.4, "settings", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.51, 0.604, 0.005, 0.0028, 0.4, "Turfs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.598, 0.604, 0.005, 0.0028, 0.4, "Security", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.686, 0.604, 0.005, 0.0028, 0.4, "Theme", 255, 255, 255, 255, 7, 0)
        if CursorInArea(0.3333, 0.3973, 0.4981, 0.5537) then
            DrawRect(0.366, 0.527, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "funds"
            end
        else
            DrawRect(0.366, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.4244, 0.4903, 0.4981, 0.5537) then
            DrawRect(0.458, 0.527, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "members"
            end
        else
            DrawRect(0.458, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.5140, 0.5776, 0.4981, 0.5537) then
            DrawRect(0.546, 0.527, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "logs"
            end
        else
            DrawRect(0.546, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6020, 0.6677, 0.4981, 0.5537) then
            DrawRect(0.635, 0.527, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "settings"
            end
        else
            DrawRect(0.635, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.3804, 0.4463, 0.5722, 0.6259) then
            DrawRect(0.414, 0.6, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "turfs"
            end
        else
            DrawRect(0.414, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.47, 0.5336, 0.5722, 0.6259) then
            DrawRect(0.502, 0.6, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "security"
            end
        else
            DrawRect(0.502, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.558, 0.6216, 0.5722, 0.6259) then
            DrawRect(0.59, 0.6, 0.065, 0.056, h.theme.r, h.theme.g, h.theme.b, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "theme"
            end
        else
            DrawRect(0.59, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
    end
end
createThreadOnTick(func_drawGangUI)
tFR.createThreadOnTick(b5)
Citizen.CreateThread(
    function()
        h = {
            blips = GetResourceKvpString("fr_gang_blips") == "true",
            pings = GetResourceKvpString("fr_gang_pings") == "true",
            names = GetResourceKvpString("fr_gang_turf_alerts") == "true",
            healthui = GetResourceKvpString("fr_gang_healthui") == "true"
        }
        h.theme = json.decode(GetResourceKvpString("fr_gang_theme")) or {r = 18, g = 82, b = 228}
        while true do
            if IsControlJustPressed(0, 166) or IsDisabledControlJustPressed(0, 166) then
                TriggerEvent("FR:ForceRefreshData")
                if not PlayerIsInGang then
                    if a == "none" then
                        a = nil
                        setCursor(0)
                        inGUIFR = false
                        selectedGangInvite = nil
                    else
                        a = "none"
                        setCursor(1)
                        inGUIFR = true
                    end
                end
                if PlayerIsInGang then
                    if a == "main" then
                        a = nil
                        setCursor(0)
                        inGUIFR = false
                        selectedMember = nil
                    else
                        a = "main"
                        setCursor(1)
                        inGUIFR = true
                    end
                end
                Wait(100)
            end
            Wait(0)
        end
    end
)
function GetGangNameText()
    AddTextEntry("FMMC_MPM_NA", "Enter Gang Name:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local K = GetOnscreenKeyboardResult()
        return K
    end
    return nil
end
function GetPlayerPermID()
    AddTextEntry("FMMC_MPM_NA", "Enter exact player permid to invite:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local K = GetOnscreenKeyboardResult()
        return K
    end
    return nil
end
function YesNoConfirm()
    AddTextEntry("FMMC_MPM_NA", "Are you sure?")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Are you sure?", "Yes | No", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local K = GetOnscreenKeyboardResult()
        if string.upper(K) == "YES" then
            return true
        else
            return false
        end
    end
    return false
end
function GetMoneyAmountText()
    AddTextEntry("FMMC_MPM_NA", "Enter amount:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount:", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local K = GetOnscreenKeyboardResult()
        return K
    end
    return nil
end
RegisterNetEvent(
    "FR:Notify",
    function(j)
        tFR.notify(j)
    end
)
RegisterNetEvent(
    "FR:setGangMemberColour",
    function(M, J)
        for h, k in pairs(FRGangMembers) do
            if k[2] == M then
                FRGangMembers[h].colour = J
            end
        end
    end
)
function tFR.gangMenuTheme(N, O, P)
    if N ~= nil and O ~= nil and P ~= nil then
        h.theme = {r = N, g = O, b = P}
        SetResourceKvp("fr_gang_theme", json.encode(h.theme))
    else
        tFR.notify("~r~Invalid value")
    end
end
function tFR.hasGangNamesEnabled()
    local L = m()
    return L and h.names
end
function tFR.isPlayerInSelectedGang(Q)
    local L = m()
    if L then
        local M = tFR.clientGetUserIdFromSource(Q)
        if M and tFR.getJobType(M) == "" then
            for R, S in pairs(FRGangMembers) do
                if M == S[2] then
                    return true, j[S.colour] or k
                end
            end
        end
    end
    return false, k
end
function tFR.hasGangBlipsEnabled()
    if h ~= nil and h.blips then
        return true
    end
    return false
end
local T = {}
RegisterKeyMapping("drawmarker", "Gang Marker", "MOUSE_BUTTON", "MOUSE_MIDDLE")
RegisterCommand(
    "drawmarker",
    function()
        if h.pings and not tFR.isEmergencyService() and not globalHideUi and not tFR.inEvent() then
            local U = GetGameplayCamCoord()
            local V = tFR.rotationToDirection(GetGameplayCamRot(2))
            local W = {x = U.x + V.x * 1000.0, y = U.y + V.y * 1000.0, z = U.z + V.z * 1000.0}
            local R, S, X, c = GetShapeTestResult(StartShapeTestRay(U.x, U.y, U.z, W.x, W.y, W.z, -1, -1, 1))
            if X ~= vector3(0.0, 0.0, 0.0) then
                TriggerServerEvent("FR:sendGangMarker", gangID, X)
            end
        end
    end
)
local function Y(Z)
    if tFR.getGangPingMarkerIndex() == 2 and not tFR.isEmergencyService() and not tFR.inEvent() then
        local _, a0 = GetGroundZFor_3dCoord(Z.x, Z.y, Z.z, Z.z, false)
        local a1 = math.abs(a0 - Z.z)
        local a2 = (a1 > 10.0 and Z.z or a0) - 1.0
        return CreateCheckpoint(47, Z.x, Z.y, a2, Z.x, Z.y, Z.z + 200.0, 1.0, h.theme.r, h.theme.g, h.theme.b, 150, 0)
    else
        return nil
    end
end
RegisterNetEvent("FR:drawGangMarker")
AddEventHandler(
    "FR:drawGangMarker",
    function(a3, a4)
        if h.pings and not tFR.isEmergencyService() and not globalHideUi and not tFR.inEvent() then
            local a5 = #(GetEntityCoords(PlayerPedId()) - a4)
            if a5 < 1000.0 then
                local a6 = T[a3]
                if a6 and a6.checkpoint then
                    DeleteCheckpoint(a6.checkpoint)
                    a6.checkpoint = nil
                end
                if a4 then
                    T[a3] = {coords = a4, time = GetGameTimer(), dist = a5, creator = a3, checkpoint = Y(a4)}
                    if tFR.getGangPingSound() > 1 then
                        SendNUIMessage(
                            {
                                transactionType = "gangping" .. tFR.getGangPingSound() - 1,
                                volume = tFR.getGangPingVolume() * 0.1
                            }
                        )
                    end
                else
                    T[a3] = nil
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if h ~= nil and h.pings and PlayerIsInGang then
                for R, S in pairs(T) do
                    if GetGameTimer() - S.time > 10000 then
                        DeleteCheckpoint(T[R].checkpoint)
                        T[R] = nil
                    end
                end
            end
            Citizen.Wait(1000)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if h ~= nil and h.pings and PlayerIsInGang then
                for R, S in pairs(T) do
                    if T[R] ~= nil then
                        if tFR.getGangPingMarkerIndex() == 3 then
                            tFR.DrawSprite3d(
                                {
                                    pos = S.coords + vector3(0.0, 0.0, S.dist / 100),
                                    textureDict = "fr_gang",
                                    textureName = "ping",
                                    width = 0.06,
                                    height = 0.1,
                                    r = h.theme.r,
                                    g = h.theme.g,
                                    b = h.theme.b,
                                    a = 255
                                }
                            )
                        end
                        tFR.DrawText3D(S.coords, S.creator .. "\n" .. tostring(math.floor(S.dist)) .. "m", 0.2)
                    end
                end
            end
            Citizen.Wait(0)
        end
    end
)
local a7 = {}
RegisterNetEvent(
    "FR:sendGangHPStats",
    function(a8)
        a7 = a8
    end
)
local a9 = 0.008
local aa = 0.35
local ab = {0, 0, 0, 255}
local function ac(ad, ae, af, ag, E, F, G, b5)
    DrawRect(ad + af / 2.0, ae + ag / 2.0, af, ag, E, F, G, b5)
end
local function ah()
    local ai = 0
    local L = m()
    if h ~= nil and h.healthui and PlayerIsInGang then
        if L and not tFR.isEmergencyService() and not globalHideUi and not tFR.inEvent() then
            local aj = 0
            local ak = tFR.getShowHealthPercentageFlag()
            if FRGangMembers ~= nil then
                for al, am in pairs(FRGangMembers) do
                    name, id, rank, lastseen, playtime = table.unpack(am)
                    if lastseen == "~g~Online" and tFR.getJobType(id) == "" then
                        local an = true
                        local ao = nil
                        local ap = nil
                        local a8 = a7[id]
                        if a8 then
                            ao = a8.health
                            ap = a8.armour
                        end
                        local aq = tFR.getTempFromPerm(id)
                        if aq then
                            local ar = GetPlayerFromServerId(aq)
                            if ar ~= -1 then
                                local as = GetPlayerPed(ar)
                                if as ~= 0 then
                                    ao = GetEntityHealth(as)
                                    ap = GetPedArmour(as)
                                    an = false
                                end
                            end
                        end
                        if ao and ap then
                            local at = aj * 0.05 + aa
                            tFR.DrawText(a9, at, name, 0.3)
                            ac(a9 + 0.0011, at + 0.025, 0.125, 0.0035, 9, 31, 0, 100)
                            local au = 0.125 * ap / 100
                            if ao <= 102 then
                                au = 0.0
                            end
                            ac(a9 + 0.0011, at + 0.025, au, 0.0035, 66, 145, 243, 255)
                            ac(a9 + 0.0011, at + 0.032, 0.125, 0.009, 9, 31, 0, 100)
                            if ao >= 198 then
                                ao = 200
                            end
                            local av = 0.125 * (ao - 100) / 100
                            if av < 0.0 then
                                av = 0.0
                            end
                            ac(a9 + 0.0011, at + 0.032, av, 0.009, 104, 212, 73, 255)
                            if ak then
                                local aw = math.floor((ao - 100) / 100.0 * 100)
                                if aw < 0 then
                                    aw = 0
                                end
                                tFR.DrawText(
                                    a9 + 0.125 / 2.0 - 0.0025,
                                    at + 0.03,
                                    tostring(aw) .. "%",
                                    0.15,
                                    nil,
                                    nil,
                                    ab
                                )
                            end
                            aj = aj + 1
                        end
                        if an then
                            ai = ai + 1
                        end
                    end
                end
            end
        end
    end
    if i and i == L then
        if ai <= 0 then
            TriggerServerEvent("FR:getGangHealthTable", nil)
            i = nil
        end
    else
        if ai > 0 then
            TriggerServerEvent("FR:getGangHealthTable", gangID)
            i = L
        end
    end
end
tFR.createThreadOnTick(ah)
function tFR.setGangUIXPos(ax)
    local ay = tonumber(string.match(ax, "%d+")) / 100
    a9 = 0.008 * ay
end
function tFR.setGangUIYPos(ax)
    local ay = tonumber(string.match(ax, "%d+")) / 100
    aa = 0.35 * ay
end
