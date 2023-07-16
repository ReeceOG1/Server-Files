--discord.gg/boronide, code generated using luamin.js™




local L_1_ = false;
local L_2_ = false;
local function L_3_func(L_4_arg0)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(L_4_arg0)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end;
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 288) then
			if IsUsingKeyboard(2) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					type = 'openGuideHud'
				})
				L_1_ = true
			end
		end;
		if L_1_ and L_2_ then
			L_3_func("Press ~INPUT_REPLAY_START_STOP_RECORDING~ to toggle the Help Menu.")
		end
	end
end)
RegisterNUICallback('closeGuideHud', function(L_5_arg0, L_6_arg1)
	SetNuiFocus(false, false)
	L_1_ = false
end)
RegisterNetEvent("NOVA:setIsNewPlayer", function()
	L_2_ = true
end)
exports("isOpen", function()
	return L_1_
end)