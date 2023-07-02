--(Thanks to Rubbertoe98) (https://github.com/rubbertoe98/FiveM-Scripts/tree/master/luna_punishments) for the original script.
-- Edits by JamesUK#6793 (to support js ghmatti version)



RegisterCommand('sw', function(player, args)
    local user_id = LUNA.getUserId(player)
    local permID =  tonumber(args[1])
    if permID ~= nil then
        if LUNA.hasPermission(user_id,"admin.showwarn") then
            lunawarningstables = getlunaWarnings(permID,player)
            TriggerClientEvent("luna:showWarningsOfUser",player,lunawarningstables)
        end
    end
end)


	
function getlunaWarnings(user_id,source) 
	lunawarningstables = exports['ghmattimysql']:executeSync("SELECT * FROM luna_warnings WHERE user_id = @uid", {uid = user_id})
	for warningID,warningTable in pairs(lunawarningstables) do
		date = warningTable["warning_date"]
		newdate = tonumber(date) / 1000
		newdate = os.date('%Y-%m-%d', newdate)
		warningTable["warning_date"] = newdate
	end
	return lunawarningstables
end

RegisterServerEvent("luna:refreshWarningSystem")
AddEventHandler("luna:refreshWarningSystem",function()
	local source = source
	local user_id = LUNA.getUserId(source)	
	lunawarningstables = getlunaWarnings(user_id,source)
	TriggerClientEvent("luna:recievedRefreshedWarningData",source,lunawarningstables)
end)

RegisterServerEvent("luna:warnPlayer")
AddEventHandler("luna:warnPlayer",function(target_id,warningReason)
	local source = source
	local user_id = LUNA.getUserId(source)
	local targetSource = LUNA.getUserSource(target_id)
    local adminName = GetPlayerName(source)
	if LUNA.hasPermission(user_id,"admin.warn") then
		warning = "Warning"
		warningDate = getCurrentDate()
		webhook = "https://ptb.discord.com/api/webhooks/1110523121598992405/zruewSZztECtuEvMCW6x1uoORpW0rAMXyAh1kcCHw2KOb-4t1uSM5jT6ThgivM_lf370"
        PerformHttpRequest(webhook, function(err, text, headers) 
        end, "POST", json.encode({username = "LUNA", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Warned Player",
                ["description"] = "**Admin Name:** "..adminName .."\n**Admin ID:** "..user_id.."\n**Player ID:** "..target_id.."\n**Reason:** " ..warningReason,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
		f10Warn(target_id, adminName, warningReason)
		LUNAclient.notify(targetSource, {'~r~You have received a warning for '..warningReason})
	else
		LUNAclient.notify(source,{"~r~You do not have permissions to warn."})
	end
end)

function f10Warn(target_id,adminName,warningReason)
	warning = "Warning"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO luna_warnings (`user_id`, `warning_type`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @admin, @warning_date,@reason);", {user_id = target_id, warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
end

function f10Kick(target_id,adminName,warningReason)
	warning = "Kick"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO luna_warnings (`user_id`, `warning_type`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @admin, @warning_date,@reason);", {user_id = target_id, warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
end

function f10Ban(target_id,adminName,warningReason,warning_duration)
	warning = "Ban"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO luna_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @duration, @admin, @warning_date,@reason);", {user_id = target_id, warning_type = warning, admin = adminName, duration = warning_duration, warning_date = warningDate, reason = warningReason}, function() end)
end


function getCurrentDate()
	date = os.date("%Y/%m/%d")
	return date
end
