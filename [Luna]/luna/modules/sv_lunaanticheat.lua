RegisterNetEvent("LUNA:AnticheatBan")
AddEventHandler("LUNA:AnticheatBan", function(Type, ExtraInfo)
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)
    local name = GetPlayerName(source)
    if not LUNA.hasPermission(user_id, "dev.menu") then
        TriggerClientEvent("chatMessage", -1, "^7^*[LUNA Anticheat]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Was Banned | Reason: " ..Type, "alert")
        Wait(500)
        AnticheatBan(user_id, name, Type, Reason)
        local webhook = "https://ptb.discord.com/api/webhooks/1110525079672066088/XusidhK6VywM-RBuWRIkZqgvExp87mLr4GZG-z0mAtGg8b_-C52eo-BKr7cC2VDdhnPH"
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = "LUNA Anticheat Logs",
                ["description"] = "",
                ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                ["fields"] = {
                    {
                        ["name"] = "Player Name",
                        ["value"] = name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = player,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = user_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Anticheat Type",
                        ["value"] = Type,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Extra Info",
                        ["value"] = ExtraInfo,
                        ["inline"] = true
                    }
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterNetEvent("LUNA:SpectateBan")
AddEventHandler("LUNA:SpectateBan", function(Type, ExtraInfo)
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)
    local name = GetPlayerName(source)
    if not LUNA.hasPermission(user_id, "admin.spectate") then
        TriggerClientEvent("chatMessage", -1, "^7^*[LUNA Anticheat]", {180, 0, 0}, GetPlayerName(source) .. " ^7 Was Banned | Reason: " ..Type, "alert")
        Wait(500)
        AnticheatBan(user_id, name, Type, Reason)
        local webhook = "https://ptb.discord.com/api/webhooks/1110525079672066088/XusidhK6VywM-RBuWRIkZqgvExp87mLr4GZG-z0mAtGg8b_-C52eo-BKr7cC2VDdhnPH"
        local command = {
            {
                ["color"] = "3944703",
                ["title"] = "LUNA Anticheat Logs",
                ["description"] = "",
                ["text"] = "LUNA Server #1 | "..os.date("%A (%d/%m/%Y) at %X"),
                ["fields"] = {
                    {
                        ["name"] = "Player Name",
                        ["value"] = name,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player TempID",
                        ["value"] = player,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Player PermID",
                        ["value"] = user_id,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Anticheat Type",
                        ["value"] = Type,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Extra Info",
                        ["value"] = ExtraInfo,
                        ["inline"] = true
                    }
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "LUNA", embeds = command}), { ['Content-Type'] = 'application/json' })
    end
end)

RegisterNetEvent("LUNA:AnticheatKick")
AddEventHandler("LUNA:AnticheatKick", function(Info)
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)
    local name = GetPlayerName(source)
    if not LUNA.hasPermission(user_id, "dev.menu") then
    AnticheatKick(user_id, Info)
    end
end)

local checking_players = {}
RegisterNetEvent("LUNA:ACCheck", function()
    local _source = source
    local name = GetPlayerName(_source)
    Wait(1500)
    if not checking_players[_source] then
        local user_id = LUNA.getUserId(_source)
        TriggerClientEvent("chatMessage", -1, "^7^*[LUNA Anticheat]", {180, 0, 0}, GetPlayerName(_source) .. " ^7 Was Banned | Reason: " ..Type, "alert")
        AnticheatBan(user_id, name, "Type #Cheater", "Type #Cheater")
    else
        checking_players[_source] = nil
    end
end)
RegisterNetEvent("LUNA:NOTLUNA", function()
    checking_players[source] = true
end)

function AnticheatBan(user_id, name, Type, Reason)
    if not LUNA.hasPermission(user_id, "dev.menu") then
    local player = LUNA.getUserSource(user_id)
    LUNA.setBanned(user_id, true, "perm", Reason, "LUNA Anticheat")
    f10Ban(user_id, "LUNA Anticheat", Reason, "perm")
    DropPlayer(player, "[LUNA] You have been permanently banned from LUNA. \n\nReason: " .. Reason .. "\n\nYou have been banned by: LUNA Anticheat\n\n [Your ID: " .. user_id .. "]")
    end
end

function AnticheatKick(user_id, Info)
    if not LUNA.hasPermission(user_id, "dev.menu") then
    local player = LUNA.getUserSource(user_id)
    local user_id = LUNA.getUserId(player)
    print("Kicked")
    DropPlayer(player, "[LUNA] You have been kicked from LUNA. \n\nReason: " .. Info .. "\n\nYou have been kicked by: LUNA Anticheat")
   end
end

AddEventHandler('ptFxEvent', function(sender, data)
    CancelEvent()
end)

BlacklistedWords = {
	"Ham Mafia",
	"HamHaxia",
	'Brutan',
	'Desudo',
	'EulenCheats',
	"85.190.90.118",
	"AlphaV ~ 5391",
	"Baran#8992",
	"Fallen#0811",
	"hammafia.com",
	"iLostName#7138",
	"Soviet Bear",
	"vjuton.pl",
	"www.renalua.com",
	"34ByTe Community", 
	"Anti-Lynx",
	"Ham Mafia", 
	"HamHaxia", 
	"Lynx 8",
	"lynxmenu.com", 
	"lynxmenu",
	"Melon#1379",
	"Rena 8",
	"www.lynxmenu.com",
	"Xanax#0134", 
	">:D Player Crash",
	"333",
	"333GANG",
	"34ByTe Community",
	"Anti-LRAC",
	"aries.pl",
	"aries",
	"Aries98",
	"dc.xaries.pl",
	"dezet",
	"discord.gg", 
	"discord.gg/",
	"Eulen",
	"EulenCheat",
	"KoGuSzEk#3251",
	"Lynx",
	"lynxmenu.com - Cheats & Anti-Cheats!",
	"lynxmenu.com",
	"MARVIN menu",
	"Rena",
	"Xanax#0134",
	"xaries",
	"XARIES",
	"yo many",
	"youtube.com/c/Aries98/",
    "Nigger",
    "Nigga",
    "Faggot",
    "Fag",
}

AddEventHandler("chatMessage", function(source, name, message)
    local _src = source
        for k, word in pairs(BlacklistedWords) do
            if string.match(message:lower(), word:lower()) then
                DropPlayer(_src, "Prohibited Word was used.")
            end
        end
    local _playername = GetPlayerName(_src);
    if name ~= _playername then
         CancelEvent()
     end
end)