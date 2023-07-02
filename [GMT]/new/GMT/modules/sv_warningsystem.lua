RegisterCommand('sw', function(player, args)
    local user_id = GMT.getUserId(player)
    local permID =  tonumber(args[1])
    if permID ~= nil then
        if GMT.hasPermission(user_id,"admin.tickets") then
			gmtwarningstables = getgmtWarnings(permID,player)
			a = exports['ghmattimysql']:executeSync("SELECT * FROM gmt_bans_offenses WHERE UserID = @uid", {uid = permID})
			for k,v in pairs(a) do
				if v.UserID == permID then
					TriggerClientEvent("gmt:showWarningsOfUser",player,gmtwarningstables,v.points)
				end
			end
        end
    end
end)
	
function getgmtWarnings(user_id,source) 
	gmtwarningstables = exports['ghmattimysql']:executeSync("SELECT * FROM gmt_warnings WHERE user_id = @uid", {uid = user_id})
	for warningID,warningTable in pairs(gmtwarningstables) do
		date = warningTable["warning_date"]
		newdate = tonumber(date) / 1000
		newdate = os.date('%Y-%m-%d', newdate)
		warningTable["warning_date"] = newdate
	end
	return gmtwarningstables
end

RegisterServerEvent("gmt:refreshWarningSystem")
AddEventHandler("gmt:refreshWarningSystem",function()
	local source = source
	local user_id = GMT.getUserId(source)	
	gmtwarningstables = getgmtWarnings(user_id,source)
	a = exports['ghmattimysql']:executeSync("SELECT * FROM gmt_bans_offenses WHERE UserID = @uid", {uid = user_id})
	for k,v in pairs(a) do
		if v.UserID == user_id then
			TriggerClientEvent("gmt:recievedRefreshedWarningData",source,gmtwarningstables,v.points)
		end
	end
end)

function f10Ban(target_id,adminName,warningReason,warning_duration)
	if warning_duration == -1 then
		warning_duration = 0
	end
	warning = "Ban"
	exports['ghmattimysql']:execute("INSERT INTO gmt_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @duration, @admin, @warning_date,@reason);", {user_id = target_id, warning_type = "Ban", admin = adminName, duration = warning_duration, warning_date = os.date("%Y/%m/%d"), reason = warningReason}, function() end)
end
