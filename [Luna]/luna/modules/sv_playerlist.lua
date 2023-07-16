local ServerUptime = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        ServerUptime = ServerUptime + 1
    end
end)

RegisterServerEvent("LUNA:getPlayerListData")
AddEventHandler("LUNA:getPlayerListData", function()
    local players = GetPlayers()
    local v = source
    local UID = LUNA.getUserId(v)
    local userData = LUNA.getUserDataTable(UID)
    local PlayersHours = math.ceil(userData.PlayerTime / 60) or 0
    local playerData = {}
    local staffPlayerData = {}
    local policeData = {}
    local NHSData = {}
    local LFBData = {}
    local HMPData = {}

    for _, player in ipairs(players) do
        local playerUID = LUNA.getUserId(player)
        local playerRank = ""

        if LUNA.hasGroup(playerUID, "founder") then
            playerRank = "Founder"
        elseif LUNA.hasGroup(playerUID, "leaddev") then
            playerRank = "Lead Developer"
        elseif LUNA.hasGroup(playerUID, "operationsmanager") then
            playerRank = "Operations Manager"
        elseif LUNA.hasGroup(playerUID, "commanager") then
            playerRank = "Community Manager"
        elseif LUNA.hasGroup(playerUID, "staffmanager") then
            playerRank = "Staff Manager"
        elseif LUNA.hasGroup(playerUID, "headadmin") then
            playerRank = "Head Administrator"
        elseif LUNA.hasGroup(playerUID, "senioradmin") then
            playerRank = "Senior Administrator"
        elseif LUNA.hasGroup(playerUID, "administrator") then
            playerRank = "Administrator"
        elseif LUNA.hasGroup(playerUID, "srmoderator") then
            playerRank = "Senior Moderator"
        elseif LUNA.hasGroup(playerUID, "moderator") then
            playerRank = "Moderator"
        elseif LUNA.hasGroup(playerUID, "supportteam") then
            playerRank = "Support Team"
        elseif LUNA.hasGroup(playerUID, "trialstaff") then
            playerRank = "Trial Staff"
        elseif LUNA.hasGroup(playerUID, "Commissioner Clocked") then
            playerRank = "Commissioner"
        elseif LUNA.hasGroup(playerUID, "Deputy Commissioner Clocked") then
            playerRank = "Deputy Commissioner"
        elseif LUNA.hasGroup(playerUID, "Assistant Commissioner Clocked") then
            playerRank = "Assistant Commissioner"
        elseif LUNA.hasGroup(playerUID, "Dep. Asst. Commissioner Clocked") then
            playerRank = "Dep. Asst. Commissioner"
        elseif LUNA.hasGroup(playerUID, "Commander Clocked") then
            playerRank = "Commander"
        elseif LUNA.hasGroup(playerUID, "Chief Superintendent Clocked") then
            playerRank = "Chief Superintendent"
        elseif LUNA.hasGroup(playerUID, "Superintendent Clocked") then
            playerRank = "Superintendent"
        elseif LUNA.hasGroup(playerUID, "Chief Inspector Clocked") then
            playerRank = "Chief Inspector"
        elseif LUNA.hasGroup(playerUID, "Inspector Clocked") then
            playerRank = "Inspector"
        elseif LUNA.hasGroup(playerUID, "Sergeant Clocked") then
            playerRank = "Sergeant"
        elseif LUNA.hasGroup(playerUID, "Senior Constable Clocked") then
            playerRank = "Senior Constable"
        elseif LUNA.hasGroup(playerUID, "PC Clocked") then
            playerRank = "Police Constable"
        elseif LUNA.hasGroup(playerUID, "NPAS Clocked") then
            playerRank = "NPAS"
        elseif LUNA.hasGroup(playerUID, "CTSFO Clocked") then
            playerRank = "CTSFO"
        elseif LUNA.hasGroup(playerUID, "PCSO Clocked") then
            playerRank = "PCSO"
        elseif LUNA.hasGroup(playerUID, "Head Chief Medical Officer Clocked") then
            playerRank = "Head Chief"
        elseif LUNA.hasGroup(playerUID, "Assistant Chief Medical Officer Clocked") then
            playerRank = "Assistant Chief"
        elseif LUNA.hasGroup(playerUID, "Deputy Chief Medical Officer Clocked") then
            playerRank = "Deputy Chief"
        elseif LUNA.hasGroup(playerUID, "Captain Clocked") then
            playerRank = "Captain"
        elseif LUNA.hasGroup(playerUID, "Consultant Clocked") then
            playerRank = "Consultant"
        elseif LUNA.hasGroup(playerUID, "Specialist Clocked") then
            playerRank = "Specialist"
        elseif LUNA.hasGroup(playerUID, "Senior Doctor Clocked") then
            playerRank = "Senior Doctor"
        elseif LUNA.hasGroup(playerUID, "Junior Doctor Clocked") then
            playerRank = "Junior Doctor"
        elseif LUNA.hasGroup(playerUID, "Critical Care Paramedic Clocked") then
            playerRank = "Critical Care Paramedic"
        elseif LUNA.hasGroup(playerUID, "Paramedic Clocked") then
            playerRank = "Paramedic"
        elseif LUNA.hasGroup(playerUID, "Trainee Paramedic Clocked") then
            playerRank = "Trainee Paramedic"
        elseif LUNA.hasGroup(playerUID, "Governor Clocked") then
            playerRank = "Governor"
        elseif LUNA.hasGroup(playerUID, "Deputy Governor Clocked") then
            playerRank = "Deputy Governor"
        elseif LUNA.hasGroup(playerUID, "Divisional Commander Clocked") then
            playerRank = "Divisional Commander"
        elseif LUNA.hasGroup(playerUID, "Custodial Supervisor Clocked") then
            playerRank = "Custodial Supervisor"
        elseif LUNA.hasGroup(playerUID, "Custodial Officer Clocked") then
            playerRank = "Custodial Officer"
        elseif LUNA.hasGroup(playerUID, "Honourable Guard Clocked") then
            playerRank = "Honourable Guard"
        elseif LUNA.hasGroup(playerUID, "Supervising Officer Clocked") then
            playerRank = "Supervising Officer"
        elseif LUNA.hasGroup(playerUID, "Principal Officer Clocked") then
            playerRank = "Principal Officer"
        elseif LUNA.hasGroup(playerUID, "Specialist Officer Clocked") then
            playerRank = "Specialist Officer"
        elseif LUNA.hasGroup(playerUID, "Senior Officer Clocked") then
            playerRank = "Senior Officer"
        elseif LUNA.hasGroup(playerUID, "Prison Officer Clocked") then
            playerRank = "Prison Officer"
        elseif LUNA.hasGroup(playerUID, "Trainee Prison Officer Clocked") then
            playerRank = "Trainee Prison Officer"
        elseif LUNA.hasGroup(playerUID, "user") then
            playerRank = "Unemployed"
        end

        table.insert(playerData, {
            name = GetPlayerName(player),
            rank = playerRank,
            hours = PlayersHours,
        })

        -- Insert the player into respective sections based on their rank
        if LUNA.hasGroup(playerUID, "founder") or LUNA.hasGroup(playerUID, "leaddev") then
            table.insert(staffPlayerData, {
                name = GetPlayerName(player),
                rank = playerRank,
                hours = PlayersHours,
            })
        end

        if LUNA.hasGroup(playerUID, "Commissioner Clocked") or LUNA.hasGroup(playerUID, "Deputy Commissioner Clocked") or LUNA.hasGroup(playerUID, "Assistant Commissioner Clocked") or LUNA.hasGroup(playerUID, "Dep. Asst. Commissioner Clocked") or LUNA.hasGroup(playerUID, "Commander Clocked") or LUNA.hasGroup(playerUID, "Special Constable Clocked") or LUNA.hasGroup(playerUID, "Chief Superintendent Clocked") or LUNA.hasGroup(playerUID, "Superintendent Clocked") or LUNA.hasGroup(playerUID, "Chief Inspector Clocked") or LUNA.hasGroup(playerUID, "Inspector Clocked") or LUNA.hasGroup(playerUID, "Sergeant Clocked") or LUNA.hasGroup(playerUID, "Senior Constable Clocked") or LUNA.hasGroup(playerUID, "PC Clocked") or LUNA.hasGroup(playerUID, "NPAS Clocked") or LUNA.hasGroup(playerUID, "CTSFO Clocked") or LUNA.hasGroup(playerUID, "PCSO Clocked") then
            table.insert(policeData, {
                name = GetPlayerName(player),
                rank = playerRank,
                hours = PlayersHours,
            })
        end

        if LUNA.hasGroup(playerUID, "Head Chief Medical Officer Clocked") or LUNA.hasGroup(playerUID, "Assistant Chief Medical Officer Clocked") or LUNA.hasGroup(playerUID, "Deputy Chief Medical Officer Clocked") or LUNA.hasGroup(playerUID, "Captain Clocked") or LUNA.hasGroup(playerUID, "Consultant Clocked") or LUNA.hasGroup(playerUID, "Specialist Clocked") or LUNA.hasGroup(playerUID, "Senior Doctor Clocked") or LUNA.hasGroup(playerUID, "Junior Doctor Clocked") or LUNA.hasGroup(playerUID, "Critical Care Paramedic Clocked") or LUNA.hasGroup(playerUID, "Paramedic Clocked") or LUNA.hasGroup(playerUID, "Trainee Paramedic Clocked") then
            table.insert(NHSData, {
                name = GetPlayerName(player),
                rank = playerRank,
                hours = PlayersHours,
            })
        end

        if LUNA.hasGroup(playerUID, "Governor Clocked") or LUNA.hasGroup(playerUID, "Deputy Governor Clocked") or LUNA.hasGroup(playerUID, "Divisional Commander Clocked") or LUNA.hasGroup(playerUID, "Custodial Supervisor Clocked") or LUNA.hasGroup(playerUID, "Custodial Officer Clocked") or LUNA.hasGroup(playerUID, "Honourable Guard Clocked") or LUNA.hasGroup(playerUID, "Supervising Officer Clocked") or LUNA.hasGroup(playerUID, "Principal Officer Clocked") or LUNA.hasGroup(playerUID, "Specialist Officer Clocked") or LUNA.hasGroup(playerUID, "Senior Officer Clocked") or LUNA.hasGroup(playerUID, "Prison Officer Clocked") or LUNA.hasGroup(playerUID, "Trainee Prison Officer Clocked") then
            table.insert(HMPData, {
                name = GetPlayerName(player),
                rank = playerRank,
                hours = PlayersHours,
            })
        end
    end

    local uptimeHours = math.floor(ServerUptime / 3600)
    local uptimeMinutes = math.floor(ServerUptime / 60) % 60
    local uptimeSeconds = ServerUptime % 60
    local uptimeString = GetUptimeString(uptimeHours, uptimeMinutes, uptimeSeconds)
    local numberOfPlayers = #GetPlayers()
    local playerLimit = 64

    TriggerClientEvent("LUNA:playerListMetaUpdate", source, { uptimeString, numberOfPlayers, playerLimit })
    TriggerClientEvent("LUNA:gotFullPlayerListData", source, staffPlayerData, policeData, NHSData, LFBData, HMPData, playerData)
end)

function GetUptimeString(hours, minutes, seconds)
    local uptimeString = ""

    if hours > 0 then
        uptimeString = uptimeString .. hours .. " hour"
        if hours > 1 then
            uptimeString = uptimeString .. "s"
        end
    end

    if minutes > 0 then

        uptimeString = uptimeString .. minutes .. " minute"
        if minutes > 1 then
            uptimeString = uptimeString .. "s"
        end
    end

    if seconds > 0 then
        if hours > 0 or minutes > 0 then
            uptimeString = uptimeString .. " and "
        end

        uptimeString = uptimeString .. seconds .. " second"
        if seconds > 1 then
            uptimeString = uptimeString .. "s"
        end
    end

    return uptimeString
end
