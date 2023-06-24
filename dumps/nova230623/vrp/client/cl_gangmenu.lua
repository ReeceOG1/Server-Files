showNoGangUI = false
showGangUI = false
showPermUI = false
PlayerIsInGang = false
GangBalance = 0
NOVAGangInvites = {}
NOVAGangInviteIndex = 0
selectedGangInvite = nil
selectedMember = nil
gangID = nil
local globalWeedCommissionPercent = "(Owned by N/A Commission - 0%)"
local L_1_ = false
gangPermission = 0
local L_2_ = {}
local L_3_ = {}
local L_4_ = 1
local L_5_ = 1
local L_6_ = 1
local L_7_ = 1
NOVAGangMembers = {}
local L_8_ = false
local L_9_ = nil
local L_10_ = nil
local L_11_ = {}
local L_12_ = {
	hud = 6
}
local function L_13_func()
	return NOVAGangMembers
end
RegisterNetEvent("NOVA:GotGangData")
AddEventHandler("NOVA:GotGangData", function(L_25_arg0, L_26_arg1, L_27_arg2, L_28_arg3, L_29_arg4, L_30_arg5, L_31_arg6)
	if L_25_arg0 == nil then
		PlayerIsInGang = false
	else
		PlayerIsInGang = true
		L_2_ = {}
		gangLogs = {}
		L_6_ = 1
		L_7_ = 1
		GangBalance = getMoneyStringFormatted(math.floor(L_25_arg0.money))
		gangID = L_25_arg0.id
		gangPermission = tonumber(L_27_arg2)
		L_8_ = L_29_arg4
		gangMaxWithdraw = L_30_arg5
		gangLimitWithdrawDeposit = L_31_arg6
		if L_26_arg1 ~= nil then
			NOVAGangMembers = L_26_arg1
			local L_32_ = 1
			L_2_[L_32_] = {}
			for L_33_forvar0, L_34_forvar1 in pairs(L_26_arg1) do
				if L_33_forvar0 % 11 == 0 then
					L_32_ = L_32_ + 1
					L_2_[L_32_] = {}
					L_6_ = L_6_ + 1
				else
					L_2_[L_32_][L_33_forvar0 - (L_32_ - 1) * 11] = L_34_forvar1
				end
			end
		end
		if L_28_arg3 ~= nil then
			local L_35_ = 1
			gangLogs[L_35_] = {}
			for L_36_forvar0, L_37_forvar1 in pairs(L_28_arg3) do
				if L_36_forvar0 % 11 == 0 then
					L_35_ = L_35_ + 1
					gangLogs[L_35_] = {}
					L_7_ = L_7_ + 1
				else
					gangLogs[L_35_][L_36_forvar0 - (L_35_ - 1) * 11] = L_37_forvar1
				end
			end
		end
	end
end)
RegisterNetEvent("NOVA:disbandedGang")
AddEventHandler("NOVA:disbandedGang", function()
	PlayerIsInGang = false
	showGangUI = false
	showNoGangUI = true
	showSettingsGangUI = false
	showTurfsGangUI = false
	showThemesGangUI = false
	showFundsGangUI = false
	L_1_ = false
	showMembersGangUI = false
	NOVAGangMembers = {}
	deleteGangBlips()
	TriggerEvent("NOVA:ForceRefreshData")
end)
RegisterNetEvent("NOVA:ForceRefreshData")
AddEventHandler("NOVA:ForceRefreshData", function()
	TriggerServerEvent("NOVA:GetGangData")
end)
RegisterNetEvent("NOVA:InviteReceived")
AddEventHandler("NOVA:InviteReceived", function(L_38_arg0, L_39_arg1)
	NOVAGangInvites[NOVAGangInviteIndex] = L_39_arg1
	NOVAGangInviteIndex = NOVAGangInviteIndex + 1
	vRP.notify(L_38_arg0)
end)
RegisterNetEvent("NOVA:gangNameNotTaken")
AddEventHandler("NOVA:gangNameNotTaken", function()
	showNoGangUI = false
	showGangUI = true
	PlayerIsInGang = true
end)
function func_drawGangUI()
	if showNoGangUI then
		DrawRect(0.471, 0.329, 0.285, - 0.005, 0, 168, 255, 204)
		DrawRect(0.471, 0.304, 0.285, 0.046, 0, 0, 0, 150)
		DrawRect(0.471, 0.428, 0.285, 0.194, 0, 0, 0, 150)
		DrawRect(0.383, 0.442, 0.066, 0.046, CreateGangSelectionRed, CreateGangSelectionGreen, CreateGangSelectionBlue, 150)
		DrawRect(0.469, 0.442, 0.066, 0.046, JoinGangSelectionRed, JoinGangSelectionGreen, JoinGangSelectionBlue, 150)
		DrawAdvancedText(0.558, 0.303, 0.005, 0.0028, 0.539, "NOVA Gangs", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.478, 0.442, 0.005, 0.0028, 0.473, "Create Gang", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.564, 0.443, 0.005, 0.0028, 0.473, "Join Gang", 255, 255, 255, 255, 4, 0)
		DrawRect(0.561, 0.377, 0.065, - 0.003, 0, 168, 255, 204)
		DrawAdvancedText(0.654, 0.37, 0.005, 0.0028, 0.364, "Invite list", 255, 255, 255, 255, 4, 0)
		for L_40_forvar0, L_41_forvar1 in pairs(NOVAGangInvites) do
			DrawAdvancedText(0.656, 0.398 + 0.020 * L_40_forvar0, 0.005, 0.0028, 0.234, L_41_forvar1, 255, 255, 255, 255, 0, 0)
			if CursorInArea(0.525, 0.59, 0.38 + 0.02 * L_40_forvar0, 0.396 + 0.02 * L_40_forvar0) and L_40_forvar0 ~= selectedGangInvite then
				DrawRect(0.56, 0.39 + 0.02 * L_40_forvar0, 0.062, 0.019, 0, 168, 255, 150)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					selectedGangInvite = L_40_forvar0
				end
			elseif L_40_forvar0 == selectedGangInvite then
				DrawRect(0.56, 0.39 + 0.02 * L_40_forvar0, 0.062, 0.019, 0, 168, 255, 150)
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
					TriggerServerEvent("NOVA:CreateGang", createGangName)
				else
					vRP.notify("~r~No gang name entered!")
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
					selectedGangInvite = NOVAGangInvites[selectedGangInvite]
					TriggerServerEvent("NOVA:addUserToGang", selectedGangInvite)
					NOVAGangInvites = {}
					showNoGangUI = false
					NOVAGangInviteIndex = 0
					showGangUI = true
					PlayerIsInGang = true
				else
					vRP.notify("~r~No gang invite selected")
				end
			end
		else
			JoinGangSelectionRed = 0
			JoinGangSelectionGreen = 0
			JoinGangSelectionBlue = 0
		end
	end
	if showFundsGangUI then
		DrawRect(0.501, 0.558, 0.421, 0.326, 0, 0, 0, 150)
		DrawRect(0.501, 0.374, 0.421, 0.047, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 248)
		DrawAdvancedText(0.591, 0.378, 0.005, 0.0028, 0.48, "NOVA Gang - Funds", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.581, 0.464, 0.005, 0.0028, 0.5, "Gang Funds", 255, 255, 255, 255, 0, 0)
		DrawAdvancedText(0.581, 0.502, 0.005, 0.0028, 0.4, "£" .. GangBalance, 25, 199, 65, 255, 0, 0)
		DrawAdvancedText(0.436, 0.578, 0.005, 0.0028, 0.4, "Deposit (1% Fee)", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.536, 0.578, 0.005, 0.0028, 0.4, "Deposit All (1% Fee)", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.637, 0.578, 0.005, 0.0028, 0.4, "Withdraw", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.737, 0.578, 0.005, 0.0028, 0.4, "Withdraw All", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.3083, 0.3718, 0.5490, 0.5999) then
			DrawRect(0.341, 0.576, 0.075, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				amount = GetMoneyAmountText()
				if amount ~= nil then
					Wait(300)
					TriggerServerEvent("NOVA:depositGangBalance", gangID, amount)
				else
					vRP.notify("~r~No amount entered!")
				end
			end
		else
			DrawRect(0.341, 0.576, 0.075, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.4083, 0.4718, 0.5490, 0.5999) then
			DrawRect(0.441, 0.576, 0.075, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				TriggerServerEvent("NOVA:depositAllGangBalance", gangID)
			end
		else
			DrawRect(0.441, 0.576, 0.075, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.5088, 0.5739, 0.5481, 0.6018) then
			DrawRect(0.542, 0.576, 0.075, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				amount = GetMoneyAmountText()
				if amount ~= nil then
					if gangPermission >= 3 then
						Wait(300)
						TriggerServerEvent("NOVA:withdrawGangBalance", gangID, amount)
					else
						vRP.notify("~r~You don't have a high enough rank to withdraw")
					end
				else
					vRP.notify("~r~No amount entered!")
				end
			end
		else
			DrawRect(0.542, 0.576, 0.075, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.6088, 0.6739, 0.5481, 0.6018) then
			DrawRect(0.642, 0.576, 0.075, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if gangPermission >= 3 then
					Wait(300)
					TriggerServerEvent("NOVA:withdrawAllGangBalance", gangID)
				else
					vRP.notify("~r~You don't have a high enough rank to withdraw")
				end
			end
		else
			DrawRect(0.642, 0.576, 0.075, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
			DrawRect(0.681, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showFundsGangUI = false
				showGangUI = true
			end
		else
			DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
	end
	if showMembersGangUI then
		DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
		DrawRect(0.501, 0.308, 0.421, 0.047, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 248)
		DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "NOVA Gang - Members", 255, 255, 255, 255, 7, 0)
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
		DrawAdvancedText(0.536, 0.695, 0.005, 0.0028, 0.4, tostring(L_4_) .. "/" .. tostring(L_6_), 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
		for L_42_forvar0, L_43_forvar1 in pairs(L_2_[L_4_]) do
			name, id, rank, lastseen, playtime = table.unpack(L_43_forvar1)
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
			DrawAdvancedText(0.429, 0.361 + 0.0287 * L_42_forvar0, 0.005, 0.0028, 0.4, name, 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.486, 0.361 + 0.0287 * L_42_forvar0, 0.005, 0.0028, 0.4, id, 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.535, 0.361 + 0.0287 * L_42_forvar0, 0.005, 0.0028, 0.4, rank, 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.605, 0.361 + 0.0287 * L_42_forvar0, 0.005, 0.0028, 0.4, "~r~Unavaliable~w~", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.665, 0.361 + 0.0287 * L_42_forvar0, 0.005, 0.0028, 0.4, "~r~Unavaliable~w~", 255, 255, 255, 255, 6, 0)
			if CursorInArea(0.3005, 0.5955, 0.3731 + 0.0287 * (L_42_forvar0 - 1), 0.4018 + 0.0287 * (L_42_forvar0 - 1)) and selectedMember ~= id then
				DrawRect(0.448, 0.388 + 0.0287 * (L_42_forvar0 - 1), 0.295, 0.027, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					selectedMember = id
				end
			elseif selectedMember == id then
				DrawRect(0.448, 0.388 + 0.0287 * (L_42_forvar0 - 1), 0.295, 0.027, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			end
		end
		if CursorInArea(0.6182, 0.6822, 0.360, 0.416) then
			DrawRect(0.651, 0.388, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if selectedMember ~= nil and PlayerIsInGang and gangID ~= nil then
					if gangPermission >= 4 then
						TriggerServerEvent("NOVA:PromoteUser", gangID, tonumber(selectedMember))
					else
						vRP.notify("~r~You don't have permission to promote!")
					end
				else
					vRP.notify("~r~No gang member selected")
				end
			end
		else
			DrawRect(0.651, 0.388, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.6182, 0.6822, 0.435, 0.491) then
			DrawRect(0.651, 0.463, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if selectedMember ~= nil and PlayerIsInGang and gangID ~= nil then
					if gangPermission >= 4 then
						TriggerServerEvent("NOVA:DemoteUser", gangID, selectedMember)
					else
						vRP.notify("~r~You don't have permission to demote!")
					end
				else
					vRP.notify("~r~No gang member selected")
				end
			end
		else
			DrawRect(0.651, 0.463, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.6182, 0.6822, 0.510, 0.566) then
			DrawRect(0.651, 0.538, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if selectedMember ~= nil then
					if gangPermission >= 3 then
						if YesNoConfirm() then
							TriggerServerEvent("NOVA:kickMemberFromGang", gangID, selectedMember)
						end
					else
						vRP.notify("~r~You don't have permission to kick!")
					end
				else
					vRP.notify("~r~No gang member selected")
				end
			end
		else
			DrawRect(0.651, 0.538, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.6182, 0.6822, 0.585, 0.641) then
			DrawRect(0.651, 0.613, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				local L_44_ = GetPlayerPermID()
				if L_44_ ~= nil then
					if gangPermission >= 2 then
						TriggerServerEvent("NOVA:InviteUserToGang", gangID, L_44_)
					else
						vRP.notify("~r~You don't have permission to invite players")
					end
				else
					vRP.notify("No player name entered")
				end
			end
		else
			DrawRect(0.651, 0.613, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.3735, 0.4185, 0.6768, 0.7074) then
			DrawRect(0.396, 0.693, 0.045, 0.033, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if L_4_ <= 1 then
					vRP.notify("~r~Lowest page reached")
				else
					L_4_ = L_4_ - 1
				end
			end
		else
			DrawRect(0.396, 0.693, 0.045, 0.033, 0, 0, 0, 150)
		end
		if CursorInArea(0.4635, 0.5085, 0.6712, 0.7064) then
			DrawRect(0.486, 0.693, 0.045, 0.033, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if L_4_ >= L_6_ then
					vRP.notify("~r~Max page reached")
				else
					L_4_ = L_4_ + 1
				end
			end
		else
			DrawRect(0.486, 0.693, 0.045, 0.033, 0, 0, 0, 150)
		end
		if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
			DrawRect(0.681, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showMembersGangUI = false
				showGangUI = true
			end
		else
			DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
	end
	if L_1_ then
		DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
		DrawRect(0.501, 0.308, 0.421, 0.047, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 248)
		DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "NOVA Gang - Logs", 255, 255, 255, 255, 7, 0)
		DrawRect(0.502, 0.518, 0.387, 0.283, 0, 0, 0, 150)
		DrawAdvancedText(0.449, 0.365, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.51, 0.365, 0.005, 0.0028, 0.4, "UserID", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.583, 0.365, 0.005, 0.0028, 0.4, "Date", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.460, 0.688, 0.005, 0.0028, 0.4, "Set Webhook", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.547, 0.688, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.639, 0.688, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.591, 0.688, 0.005, 0.0028, 0.4, tostring(L_5_) .. "/" .. tostring(L_7_), 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.673, 0.365, 0.005, 0.0028, 0.4, "Action", 255, 255, 255, 255, 4, 0)
		DrawAdvancedText(0.757, 0.365, 0.005, 0.0028, 0.4, "Value", 255, 255, 255, 255, 4, 0)
		if gangLogs[L_5_] ~= nil then
			for L_45_forvar0, L_46_forvar1 in pairs(gangLogs[L_5_]) do
				name, id, date, action, value = table.unpack(L_46_forvar1)
				DrawAdvancedText(0.449, 0.361 + 0.0287 * L_45_forvar0, 0.005, 0.0028, 0.4, name, 255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.51, 0.361 + 0.0287 * L_45_forvar0, 0.005, 0.0028, 0.4, id, 255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.583, 0.361 + 0.0287 * L_45_forvar0, 0.005, 0.0028, 0.4, date, 255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.673, 0.361 + 0.0287 * L_45_forvar0, 0.005, 0.0028, 0.4, action, 255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.757, 0.361 + 0.0287 * L_45_forvar0, 0.005, 0.0028, 0.4, value, 255, 255, 255, 255, 6, 0)
			end
		end
		if CursorInArea(0.33, 0.395, 0.667593, 0.699074) then
			DrawRect(0.365, 0.686, 0.065, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				TriggerServerEvent("NOVA:SetGangWebhook", gangid)
			end
		else
			DrawRect(0.365, 0.686, 0.065, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.419271, 0.482813, 0.667593, 0.699074) then
			DrawRect(0.452, 0.686, 0.065, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if L_5_ <= 1 then
					vRP.notify("~r~Lowest page reached")
				else
					L_5_ = L_5_ - 1
				end
			end
		else
			DrawRect(0.452, 0.686, 0.065, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.512500, 0.575521, 0.667593, 0.699074) then
			DrawRect(0.545, 0.686, 0.065, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if L_5_ >= L_7_ then
					vRP.notify("~r~Max page reached")
				else
					L_5_ = L_5_ + 1
				end
			end
		else
			DrawRect(0.545, 0.686, 0.065, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
			DrawRect(0.681, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				L_1_ = false
				showGangUI = true
			end
		else
			DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
	end
	if showSettingsGangUI then
		DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
		DrawRect(0.501, 0.308, 0.421, 0.047, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 248)
		DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "NOVA Gang - Settings", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.7, 0.360, 0.005, 0.0028, 0.46, "Current Gang: " .. gangID, 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.7, 0.398, 0.005, 0.0028, 0.46, "Permissions Guide", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.7, 0.436, 0.005, 0.0028, 0.46, "A Recruit can deposit to the gang funds only.", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.7, 0.472, 0.005, 0.0028, 0.46, "A Member can invite users", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.7, 0.51, 0.005, 0.0028, 0.46, "A Senior can invite and kick members,", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.7, 0.532, 0.005, 0.0028, 0.46, "withdraw from gang funds and set logs webhook.", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.7, 0.572, 0.005, 0.0028, 0.46, "A Leader can promote and demote members", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.7, 0.594, 0.005, 0.0028, 0.46, "and lock gang funds.", 255, 255, 255, 255, 6, 0)
		local L_47_ = L_9_.blips and "Disable" or "Enable"
		DrawAdvancedText(0.451, 0.416, 0.005, 0.0028, 0.4, L_47_ .. " Blips", 255, 255, 255, 255, 6, 0)
		if CursorInArea(0.3187, 0.3937, 0.3712, 0.4462) then
			DrawRect(0.357, 0.41, 0.075, 0.076, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				deleteGangBlips()
				L_9_.blips = not L_9_.blips
				SetResourceKvp("NOVA_gang_blips", tostring(L_9_.blips))
			end
		else
			DrawRect(0.357, 0.41, 0.075, 0.076, 0, 0, 0, 150)
		end
		local L_48_ = L_9_.pings and "Disable" or "Enable"
		DrawAdvancedText(0.554, 0.415, 0.005, 0.0028, 0.4, L_48_ .. " Pings", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.4197, 0.4932, 0.3712, 0.4462) then
			DrawRect(0.457, 0.41, 0.075, 0.076, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				L_9_.pings = not L_9_.pings
				SetResourceKvp("NOVA_gang_pings", tostring(L_9_.pings))
			end
		else
			DrawRect(0.457, 0.41, 0.075, 0.076, 0, 0, 0, 150)
		end
		local L_49_ = L_9_.names and "Disable" or "Enable"
		DrawAdvancedText(0.451, 0.516, 0.005, 0.0028, 0.4, L_49_ .. " Names", 255, 255, 255, 255, 6, 0)
		if CursorInArea(0.3187, 0.3937, 0.4712, 0.5462) then
			DrawRect(0.357, 0.51, 0.075, 0.076, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				L_9_.names = not L_9_.names
				SetResourceKvp("NOVA_gang_turf_alerts", tostring(L_9_.names))
			end
		else
			DrawRect(0.357, 0.51, 0.075, 0.076, 0, 0, 0, 150)
		end
		DrawAdvancedText(0.554, 0.515, 0.005, 0.0028, 0.4, "Rename Gang", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.4197, 0.4932, 0.4712, 0.5462) then
			DrawRect(0.457, 0.51, 0.075, 0.076, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				newGangName = GetGangNameText()
				if newGangName ~= nil and newGangName ~= "null" and newGangName ~= "" and gangID ~= nil then
					TriggerServerEvent("NOVA:RenameGang", gangID, newGangName)
				else
					vRP.notify("~r~No gang name entered!")
				end
			end
		else
			DrawRect(0.457, 0.51, 0.075, 0.076, 0, 0, 0, 150)
		end
		DrawAdvancedText(0.451, 0.616, 0.005, 0.0028, 0.4, "Leave Gang", 255, 255, 255, 255, 6, 0)
		if CursorInArea(0.3187, 0.3937, 0.5712, 0.6462) then
			DrawRect(0.357, 0.61, 0.075, 0.076, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if YesNoConfirm() then
					TriggerServerEvent("NOVA:memberLeaveGang", gangID)
					setCursor(0)
					SetPlayerControl(PlayerId(), 1, 0)
				end
			end
		else
			DrawRect(0.357, 0.61, 0.075, 0.076, 0, 0, 0, 150)
		end
		DrawAdvancedText(0.554, 0.615, 0.005, 0.0028, 0.4, "Disband Gang", 255, 255, 255, 255, 6, 0)
		if CursorInArea(0.4197, 0.4932, 0.5712, 0.6462) then
			DrawRect(0.457, 0.61, 0.075, 0.076, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if gangPermission >= 4 then
					if YesNoConfirm() == true and gangID ~= nil then
						TriggerServerEvent("NOVA:DeleteGang", gangID)
					end
				else
					vRP.notify("~r~You don't have permission to disband!")
				end
			end
		else
			DrawRect(0.457, 0.61, 0.075, 0.076, 0, 0, 0, 150)
		end
		DrawAdvancedText(0.451, 0.693, 0.005, 0.0028, 0.4, L_9_.healthui and "Disable Health UI" or "Enable Health UI", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.31, 0.39, 0.6712, 0.7064) then
			DrawRect(0.357, 0.689, 0.075, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				L_9_.healthui = not L_9_.healthui
				SetResourceKvp("NOVA_gang_healthui", tostring(L_9_.healthui))
			end
		else
			DrawRect(0.357, 0.689, 0.075, 0.036, 0, 0, 0, 150)
		end
		DrawAdvancedText(0.551, 0.693, 0.005, 0.0028, 0.4, "Set Gang Fit", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.41, 0.49, 0.6712, 0.7064) then
			DrawRect(0.457, 0.689, 0.075, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if gangPermission >= 4 then
					TriggerServerEvent("NOVA:setGangFit", gangID)
				else
					vRP.notify("~r~You don't have permission to set gang fit!")
				end
			end
		else
			DrawRect(0.457, 0.689, 0.075, 0.036, 0, 0, 0, 150)
		end
		DrawAdvancedText(0.653, 0.644, 0.005, 0.0028, 0.4, "Join Gang Discord", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.51, 0.59, 0.62, 0.65) then
			DrawRect(0.557, 0.640, 0.075, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				TriggerServerEvent("NOVA:joinGangDiscord", gangID)
			end
		else
			DrawRect(0.557, 0.640, 0.075, 0.036, 0, 0, 0, 150)
		end
		DrawAdvancedText(0.653, 0.693, 0.005, 0.0028, 0.4, "Set Gang Discord", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.51, 0.59, 0.6712, 0.7064) then
			DrawRect(0.557, 0.689, 0.075, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if gangPermission >= 4 then
					TriggerServerEvent("NOVA:setGangDiscord", gangID)
				else
					vRP.notify("~r~You don't have permission to set gang discord!")
				end
			end
		else
			DrawRect(0.557, 0.689, 0.075, 0.036, 0, 0, 0, 150)
		end
		DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
			DrawRect(0.681, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showSettingsGangUI = false
				showGangUI = true
			end
		else
			DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
	end
	if showTurfsGangUI then
		DrawRect(0.501, 0.533, 0.421, 0.497, 0, 0, 0, 150)
		DrawRect(0.501, 0.308, 0.421, 0.047, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 248)
        DrawAdvancedText(0.591,0.312,0.005,0.0028,0.48,"NOVA gang - Turfs",255,255,255,255,7,0)
        DrawAdvancedText(0.399,0.38,0.005,0.0028,0.4,"Weed Turf - (Owned by N/A Commission - 0%)",255,255,255,255,0,1)
        DrawAdvancedText(0.399,0.44,0.005,0.0028,0.4,"Cocaine Turf - (Owned by N/A Commission - 0%)",255,255,255,255,0,1)
        DrawAdvancedText(0.399,0.50,0.005,0.0028,0.4,"Meth Turf - (Owned by N/A Commission - 0%)",255,255,255,255,0,1)
        DrawAdvancedText(0.399,0.56,0.005,0.0028,0.4,"Heroin Turf - (Owned by N/A Commission - 0%)",255,255,255,255,0,1)
        DrawAdvancedText(0.399,0.62,0.005,0.0028,0.4,"Large Arms - (Owned by N/A Commission - 0%)",255,255,255,255,0,1)
        DrawAdvancedText(0.399,0.68,0.005,0.0028,0.4,"LSD Turf - (Owned by N/A Commission - 0%)",255,255,255,255,0,1)
		DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
			DrawRect(0.681, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showTurfsGangUI = false
				showGangUI = true
			end
		else
			DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
	end
	if showSecurityGangUI then
		DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
		DrawRect(0.501, 0.308, 0.421, 0.047, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 248)
		DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "NOVA Gang - security", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.4, 0.375, 0.005, 0.0028, 0.46, "Maximum withdraw amount per member:", 255, 255, 255, 255, 6, 1)
		DrawAdvancedText(0.4, 0.405, 0.005, 0.0028, 0.4, "Sets the maximum amount of money a member can withdraw within a 24 hour time period.", 255, 255, 255, 255, 6, 1)
		DrawRect(0.525, 0.377, 0.1, 0.03, 0, 0, 0, 175)
		DrawAdvancedText(0.575, 0.377, 0.005, 0.0028, 0.44, "~r~Unavaliable~w~", 255, 255, 255, 255, 6, 1)
		if CursorInArea(0.31, 0.65, 0.36, 0.41) then
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if gangPermission >= 4 then
					local L_50_ = GetMoneyAmountText()
					if L_50_ and tonumber(L_50_) and tonumber(L_50_) >= 0 then
						TriggerServerEvent("NOVA:setGangMaximumWithdrawAmount", gangID, tonumber(L_50_))
					else
						vRP.notify("~r~Invalid amount entered.")
					end
				else
					vRP.notify("~r~You must be a leader to change security.")
				end
			end
		end
		DrawAdvancedText(0.4, 0.475, 0.005, 0.0028, 0.46, "Limit withdraw amount to deposit amount:", 255, 255, 255, 255, 6, 1)
		DrawAdvancedText(0.4, 0.505, 0.005, 0.0028, 0.4, "Prevents a member withdrawing more money then they have deposited into the funds.", 255, 255, 255, 255, 6, 1)
		DrawRect(0.525, 0.475, 0.1, 0.03, 0, 0, 0, 175)
		DrawAdvancedText(0.575, 0.475, 0.005, 0.0028, 0.46, "~r~Unavaliable~w~" and "~r~Unavaliable~w~" or "~r~Unavaliable~w~", 255, 255, 255, 255, 6, 1)
		if CursorInArea(0.31, 0.65, 0.46, 0.51) then
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if gangPermission >= 4 then
					local L_51_ = YesNoConfirm()
					TriggerServerEvent("NOVA:setGangLimitWithdrawDeposit", gangID, L_51_)
				else
					vRP.notify("~r~You must be a leader to change security.")
				end
			end
		end
		DrawAdvancedText(0.4, 0.575, 0.005, 0.0028, 0.46, "Lock gang funds:", 255, 255, 255, 255, 6, 1)
		DrawAdvancedText(0.4, 0.605, 0.005, 0.0028, 0.4, "Prevents any member from withdrawing funds from the gang.", 255, 255, 255, 255, 6, 1)
		DrawRect(0.525, 0.575, 0.1, 0.03, 0, 0, 0, 175)
		DrawAdvancedText(0.575, 0.575, 0.005, 0.0028, 0.46, "~r~Unavaliable~w~" and "~r~Unavaliable~w~" or "~r~Unavaliable~w~", 255, 255, 255, 255, 6, 1)
		if CursorInArea(0.31, 0.65, 0.56, 0.61) then
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				if gangPermission >= 4 then
					TriggerServerEvent("NOVA:LockGangFunds", gangID)
				else
					vRP.notify("~r~You must be a leader to change security.")
				end
			end
		end
		DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
		if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
			DrawRect(0.681, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showSecurityGangUI = false
				showGangUI = true
			end
		else
			DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
	end
	if showThemesGangUI then
		DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
		DrawRect(0.501, 0.308, 0.421, 0.047, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 248)
		DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "NOVA Gang - Theme", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.7, 0.360, 0.005, 0.0028, 0.46, "The theme will be frequent throughout the", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.7, 0.396, 0.005, 0.0028, 0.46, "gang menu and used as your marker colour.", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.490, 0.380, 0.005, 0.0028, 0.48, "Current Theme", 255, 255, 255, 255, 6, 0)
		DrawAdvancedText(0.490, 0.405, 0.005, 0.0028, 0.48, "(" .. L_9_.theme.r .. "," .. L_9_.theme.g .. "," .. L_9_.theme.b .. ")", 255, 255, 255, 255, 6, 0)
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
		DrawRect(0.395, 0.51, 0.1, 0.13, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 248)
		if CursorInArea(0.5187, 0.5828, 0.4138, 0.4694) then
			DrawRect(0.552, 0.443, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				CopyToClipBoard(L_9_.theme.r .. "," .. L_9_.theme.g .. "," .. L_9_.theme.b)
				vRP.notify("~g~Theme copied to clipboard.")
			end
		else
			DrawRect(0.552, 0.443, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.5187, 0.5828, 0.5407, 0.5962) then
			DrawRect(0.552, 0.569, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				gangMenuTheme(math.random(1, 255), math.random(1, 255), math.random(1, 255))
			end
		else
			DrawRect(0.552, 0.569, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.6182, 0.6822, 0.4138, 0.4694) then
			DrawRect(0.651, 0.443, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				gangMenuTheme(18, 82, 228)
			end
		else
			DrawRect(0.651, 0.443, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.6182, 0.6822, 0.5407, 0.5962) then
			DrawRect(0.651, 0.569, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				tvRP.prompt(source,"Enter rgb value eg 255,100,150:", "", function(L_52_arg0)
					if L_52_arg0 ~= "" then
						local L_53_ = stringsplit(L_52_arg0, ",")
						if L_53_[1] ~= nil and L_53_[2] ~= nil and L_53_[3] ~= nil then
							gangMenuTheme(tonumber(L_53_[1]), tonumber(L_53_[2]), tonumber(L_53_[3]))
						else
							vRP.notify("~r~Invalid value")
						end
					else
						vRP.notify("~r~Invalid value")
					end
				end)
			end
		else
			DrawRect(0.651, 0.569, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.3033, 0.3506, 0.6712, 0.7064) then
			DrawRect(0.326, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				gangMenuTheme(18, 82, 228)
			end
		else
			DrawRect(0.326, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.3633, 0.4106, 0.6712, 0.7064) then
			DrawRect(0.386, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				gangMenuTheme(255, 0, 255)
			end
		else
			DrawRect(0.386, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.4233, 0.4706, 0.6712, 0.7064) then
			DrawRect(0.446, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				gangMenuTheme(0, 128, 0)
			end
		else
			DrawRect(0.446, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.4833, 0.5306, 0.6712, 0.7064) then
			DrawRect(0.506, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				gangMenuTheme(255, 0, 0)
			end
		else
			DrawRect(0.506, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.5433, 0.5906, 0.6712, 0.7064) then
			DrawRect(0.566, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				gangMenuTheme(0, 100, 100)
			end
		else
			DrawRect(0.566, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.6033, 0.6506, 0.6712, 0.7064) then
			DrawRect(0.626, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				gangMenuTheme(255, 165, 0)
			end
		else
			DrawRect(0.626, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
		if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
			DrawRect(0.681, 0.689, 0.045, 0.036, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showThemesGangUI = false
				showGangUI = true
			end
		else
			DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
		end
	end
	if showGangUI then
		DrawRect(0.501, 0.532, 0.375, 0.225, 0, 0, 0, 150)
		DrawRect(0.501, 0.396, 0.375, 0.046, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 255)
		DrawAdvancedText(0.591, 0.399, 0.005, 0.0028, 0.51, "NOVA Gangs", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.46, 0.534, 0.005, 0.0028, 0.4, "funds", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.554, 0.534, 0.005, 0.0028, 0.4, "members", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.642, 0.534, 0.005, 0.0028, 0.4, "logs", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.732, 0.534, 0.005, 0.0028, 0.4, "settings", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.51, 0.604, 0.005, 0.0028, 0.4, "Turfs", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.598, 0.604, 0.005, 0.0028, 0.4, "Security", 255, 255, 255, 255, 7, 0)
		DrawAdvancedText(0.686, 0.604, 0.005, 0.0028, 0.4, "Theme", 255, 255, 255, 255, 7, 0)
		if CursorInArea(0.3333, 0.3973, 0.4981, 0.5537) then
			DrawRect(0.366, 0.527, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showGangUI = false
				showFundsGangUI = true
			end
		else
			DrawRect(0.366, 0.527, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.4244, 0.4903, 0.4981, 0.5537) then
			DrawRect(0.458, 0.527, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showGangUI = false
				showMembersGangUI = true
			end
		else
			DrawRect(0.458, 0.527, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.5140, 0.5776, 0.4981, 0.5537) then
			DrawRect(0.546, 0.527, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showGangUI = false
				L_1_ = true
			end
		else
			DrawRect(0.546, 0.527, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.6020, 0.6677, 0.4981, 0.5537) then
			DrawRect(0.635, 0.527, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showGangUI = false
				showSettingsGangUI = true
			end
		else
			DrawRect(0.635, 0.527, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.3804, 0.4463, 0.5722, 0.6259) then
			DrawRect(0.414, 0.6, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showGangUI = false
				showTurfsGangUI = true
			end
		else
			DrawRect(0.414, 0.6, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.47, 0.5336, 0.5722, 0.6259) then
			DrawRect(0.502, 0.6, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showGangUI = false
				showSecurityGangUI = true
			end
		else
			DrawRect(0.502, 0.6, 0.065, 0.056, 0, 0, 0, 150)
		end
		if CursorInArea(0.558, 0.6216, 0.5722, 0.6259) then
			DrawRect(0.59, 0.6, 0.065, 0.056, L_9_.theme.r, L_9_.theme.g, L_9_.theme.b, 150)
			if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
				PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				showGangUI = false
				showThemesGangUI = true
			end
		else
			DrawRect(0.59, 0.6, 0.065, 0.056, 0, 0, 0, 150)
		end
	end
end
createThreadOnTick(func_drawGangUI)
createThreadOnTick(b5)
Citizen.CreateThread(
    function()
	L_9_ = {
		blips = GetResourceKvpString("nova_gang_blips") == "true",
		pings = GetResourceKvpString("nova_gang_pings") == "true",
		names = GetResourceKvpString("nova_gang_turf_alerts") == "true",
		healthui = GetResourceKvpString("nova_gang_healthui") == "true"
	}
	L_9_.theme = json.decode(GetResourceKvpString("nova_gang_theme")) or {
		r = 18,
		g = 82,
		b = 228
	}
	while true do
		if IsControlJustPressed(0, 166) or IsDisabledControlJustPressed(0, 166) then
			TriggerEvent("NOVA:ForceRefreshData")
			if not PlayerIsInGang then
				if showNoGangUI then
					showNoGangUI = false
					setCursor(0)
					inGUINOVA = false
					selectedGangInvite = nil
				else
					showNoGangUI = true
					setCursor(1)
					inGUINOVA = true
				end
			end
			if PlayerIsInGang then
				showSettingsGangUI = false
				showTurfsGangUI = false
				showSecurityGangUI = false
				showThemesGangUI = false
				showFundsGangUI = false
				L_1_ = false
				showMembersGangUI = false
				showNoGangUI = false
				if showGangUI then
					showGangUI = false
					setCursor(0)
					inGUINOVA = false
					selectedMember = nil
				else
					showGangUI = true
					setCursor(1)
					inGUINOVA = true
				end
			end
			Wait(100)
		end
		Wait(0)
	end
end)
function GetGangNameText()
	AddTextEntry("FMMC_MPM_NA", "Enter Gang Name:")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
	while UpdateOnscreenKeyboard() == 0 do
		DisableAllControlActions(0)
		Wait(0)
	end
	if GetOnscreenKeyboardResult() then
		local L_54_ = GetOnscreenKeyboardResult()
		return L_54_
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
		local L_55_ = GetOnscreenKeyboardResult()
		return L_55_
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
		local L_56_ = GetOnscreenKeyboardResult()
		if string.upper(L_56_) == "YES" then
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
		local L_57_ = GetOnscreenKeyboardResult()
		return L_57_
	end
	return nil
end
RegisterNetEvent("NOVA:vRP.notify", function(L_58_arg0)
	vRP.notify(L_58_arg0)
end)
function getMoneyStringFormatted(L_59_arg0)
	local L_60_, L_61_, L_62_, L_63_, L_64_ = tostring(L_59_arg0):find("([-]?)(%d+)([.]?%d*)")
	L_63_ = L_63_:reverse():gsub("(%d%d%d)", "%1,")
	return L_62_ .. L_63_:reverse():gsub("^,", "") .. L_64_
end
function gangMenuTheme(L_65_arg0, L_66_arg1, L_67_arg2)
	if L_65_arg0 ~= nil and L_66_arg1 ~= nil and L_67_arg2 ~= nil then
		L_9_.theme = {
			r = L_65_arg0,
			g = L_66_arg1,
			b = L_67_arg2
		}
		SetResourceKvp("nova_gang_theme", json.encode(L_9_.theme))
	else
		vRP.notify("~r~Invalid value")
	end
end
function deleteGangBlips()
	for L_68_forvar0, L_69_forvar1 in pairs(L_11_) do
		if DoesBlipExist(L_69_forvar1) then
			RemoveBlip(L_69_forvar1)
		end
	end
	L_11_ = {}
end
function hasGangNamesEnabled()
	local L_70_ = L_13_func()
	return L_70_ and L_9_.names
end
function isPlayerInSelectedGang(L_71_arg0)
	local L_72_ = L_13_func()
	if L_72_ then
		local L_73_ = vRP.clientGetUserIdFromSource(L_71_arg0)
		if L_73_ and getJobType(L_73_) == "" then
			for L_74_forvar0, L_75_forvar1 in pairs(NOVAGangMembers) do
				if L_73_ == L_75_forvar1[2] then
					return true, L_12_
				end
			end
		end
	end
	return false, L_12_
end
local function L_14_func(L_76_arg0, L_77_arg1, L_78_arg2)
	if not DoesBlipExist(L_76_arg0) then
		local L_79_ = AddBlipForEntity(L_77_arg1)
		table.insert(L_11_, L_79_)
		SetBlipSprite(L_79_, 1)
		SetBlipScale(L_76_arg0, 0.85)
		SetBlipAlpha(L_76_arg0, 255)
		SetBlipColour(L_76_arg0, L_78_arg2)
		ShowHeadingIndicatorOnBlip(L_76_arg0, true)
	else
		if GetEntityHealth(L_77_arg1) > 102 then
			SetBlipSprite(L_76_arg0, 1)
		else
			SetBlipSprite(L_76_arg0, 274)
		end
		SetBlipScale(L_76_arg0, 0.85)
		SetBlipAlpha(L_76_arg0, 255)
		SetBlipColour(L_76_arg0, L_78_arg2)
		ShowHeadingIndicatorOnBlip(L_76_arg0, true)
	end
end
function hasGangBlipsEnabled()
	if L_9_ ~= nil and L_9_.blips then
		return true
	end
	return false
end
local function L_15_func(L_80_arg0)
	local L_81_ = GetGameplayCamRot()
	local L_82_ = GetGameplayCamCoord()
	local L_83_ = rotationToDirection(L_81_)
	local L_84_ = {
		x = L_82_.x + L_83_.x * L_80_arg0,
		y = L_82_.y + L_83_.y * L_80_arg0,
		z = L_82_.z + L_83_.z * L_80_arg0
	}
	local L_85_, L_86_, L_87_, L_88_, L_89_ = GetShapeTestResult(StartShapeTestRay(L_82_.x, L_82_.y, L_82_.z, L_84_.x, L_84_.y, L_84_.z, -1, -1, 1))
	return L_86_, L_87_, L_89_
end
local L_16_ = nil
local L_17_ = false
RegisterKeyMapping("drawmarker", "Gang Marker", "MOUSE_BUTTON", "MOUSE_MIDDLE")
RegisterCommand("drawmarker", function()
	if L_9_.pings and not vRP.isEmergencyService() and not globalHideUi and not vRP.inEvent() then
		local L_90_, L_91_, L_92_ = L_15_func(1000.0)
		if L_91_ == vector3(0.0, 0.0, 0.0) then
			return
		end
		TriggerServerEvent("NOVA:sendGangMarker", gangID, L_91_)
	end
end)
RegisterNetEvent("NOVA:drawGangMarker")
AddEventHandler("NOVA:drawGangMarker", function(L_93_arg0, L_94_arg1)
	if L_9_.pings and not vRP.isEmergencyService() and not globalHideUi and not vRP.inEvent() then
		if L_17_ then
			L_17_ = false
			Wait(0)
		end
		local L_95_ = # (GetEntityCoords(PlayerPedId()) - L_94_arg1)
		if L_95_ > 500.0 then
			return
		end
		RemoveBlip(L_16_)
		L_16_ = AddBlipForCoord(L_94_arg1)
		SetBlipSprite(L_16_, 148)
		SetBlipScale(L_16_, 0.25)
		SetBlipColour(L_16_, 1)
		L_17_ = true
		local L_96_ = GetGameTimer()
		while GetGameTimer() - L_96_ < 10000 and L_17_ == true do
			Wait(0)
			L_95_ = # (GetEntityCoords(PlayerPedId()) - L_94_arg1)
			DrawSprite3d(
                    {
				pos = L_94_arg1 + vector3(0.0, 0.0, L_95_ / 100),
				textureDict = "nova_gang",
				textureName = "ping",
				width = 0.06,
				height = 0.1,
				r = L_9_.theme.r,
				g = L_9_.theme.g,
				b = L_9_.theme.b,
				a = 255
			})
			DrawText3D(L_94_arg1, L_93_arg0 .. "\n" .. tostring(math.floor(L_95_)) .. "m", 0.2)
			RemoveBlip(L_16_)
		end
	end
end)
local L_18_ = {}
RegisterNetEvent("NOVA:sendGangHPStats", function(L_97_arg0)
	L_18_ = L_97_arg0
end)
local L_19_ = 0.008
local L_20_ = 0.35
local L_21_ = {
	0,
	0,
	0,
	255
}
local L_22_ = 0.8
local function L_23_func(L_98_arg0, L_99_arg1, L_100_arg2, L_101_arg3, L_102_arg4, L_103_arg5, L_104_arg6, L_105_arg7)
	DrawRect(L_98_arg0 + L_100_arg2 / 2.0, L_99_arg1 + L_101_arg3 / 2.0, L_100_arg2, L_101_arg3, L_102_arg4, L_103_arg5, L_104_arg6, L_105_arg7)
end
local function L_24_func()
	local L_106_ = 0
	local L_107_ = L_13_func()
	if L_9_ ~= nil and L_9_.healthui and PlayerIsInGang then
		if L_107_ and not vRP.isEmergencyService() and not globalHideUi and not vRP.inEvent() then
			local L_108_ = 0
			local L_109_ = getShowHealthPercentageFlag()
			if L_2_[L_4_] ~= nil then
				for L_110_forvar0, L_111_forvar1 in pairs(L_2_[L_4_]) do
					name, id, rank, lastseen, playtime = table.unpack(L_111_forvar1)
					local L_112_ = 150
					local L_113_ = 30
					if lastseen == "~g~Online" and vRP.getJobType(id) == "" then
						local L_114_ = true
						local L_115_ = nil
						local L_116_ = nil
						local L_117_ = L_18_[id]
						if L_117_ then
							L_115_ = L_117_.health
							L_116_ = L_117_.armour
						end
						local L_118_ = vRP.getTempFromPerm(id)
						if L_118_ then
							local L_119_ = GetPlayerFromServerId(L_118_)
							if L_119_ ~= -1 then
								local L_120_ = GetPlayerPed(L_119_)
								if L_120_ ~= 0 then
									L_115_ = GetEntityHealth(L_120_)
									L_116_ = GetPedArmour(L_120_)
									L_114_ = false
								end
							end
						end
						if L_115_ and L_116_ then
							local L_121_ = L_108_ * 0.05 + L_20_
							DrawText(L_19_, L_121_, name, 0.3)
							L_23_func(L_19_ + 0.0011, L_121_ + 0.025, 0.125, 0.0035, 9, 31, 0, 100)
							local L_122_ = 0.125 * L_116_ / 100
							if L_115_ <= 102 then
								L_122_ = 0.0
							end
							L_23_func(L_19_ + 0.0011, L_121_ + 0.025, L_122_, 0.0035, 66, 145, 243, 255)
							L_23_func(L_19_ + 0.0011, L_121_ + 0.032, 0.125, 0.009, 9, 31, 0, 100)
							if L_115_ >= 198 then
								L_115_ = 200
							end
							local L_123_ = 0.125 * (L_115_ - 100) / 100
							if L_123_ < 0.0 then
								L_123_ = 0.0
							end
							L_23_func(L_19_ + 0.0011, L_121_ + 0.032, L_123_, 0.009, 104, 212, 73, 255)
							if L_109_ then
								local L_124_ = math.floor((L_115_ - 100) / 100.0 * 100)
								if L_124_ < 0 then
									L_124_ = 0
								end
								DrawText(
                                    L_19_ + 0.125 / 2.0 - 0.0025, L_121_ + 0.03, tostring(L_124_) .. "%", 0.15, nil, nil, L_21_)
							end
							L_108_ = L_108_ + 1
						end
						if L_114_ then
							L_106_ = L_106_ + 1
						end
					end
				end
			end
		end
	end
	if L_10_ and L_10_ == L_107_ then
		if L_106_ <= 0 then
			TriggerServerEvent("NOVA:getGangHealthTable", nil)
			L_10_ = nil
		end
	else
		if L_106_ > 0 then
			TriggerServerEvent("NOVA:getGangHealthTable", gangID)
			L_10_ = L_107_
		end
	end
end
createThreadOnTick(L_24_func)
