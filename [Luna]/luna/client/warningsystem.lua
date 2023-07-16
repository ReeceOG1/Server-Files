lunaWarnings = {}

showWarningSystem = false

xoffset = 0.031
rowcounter = 0
warningColourR = 0
warningColourG = 0
warningColourB = 0



RegisterNetEvent("luna:showWarningsOfUser")
AddEventHandler("luna:showWarningsOfUser",function(lunawarningstables)
	showWarningSystem = true
	lunaWarnings = lunawarningstables
end)

RegisterNetEvent("luna:recievedRefreshedWarningData")
AddEventHandler("luna:recievedRefreshedWarningData",function(lunawarningstables)
	lunaWarnings = lunawarningstables
end)


RegisterCommand('warnings', function()
    showWarningSystem = not showWarningSystem
    if showWarningSystem then
        TriggerServerEvent("luna:refreshWarningSystem")
    end
end)


    RegisterKeyMapping('warnings', 'Opens Warnings', 'keyboard', 'F10')


Citizen.CreateThread(function() -- Your warning points are reduced by 2 every month
	while true do
		if showWarningSystem then
			--DrawRect(0.498, 0.482, 0.615, 0.636, 0, 0, 0, 170)
			DrawRect(0.498, 0.482, 0.615, 0.636, 0, 0, 0, 210)
			DrawAdvancedText(0.59, 0.185, 0.005, 0.0028, 0.759, 'LUNA WARNINGS', 255, 255, 255, 255, 4, 0)
			--DrawRect(0.498, 0.232, 0.615, -0.0040000000000001, 222, 222, 222, 204) -- Under Warning title
			DrawRect(0.498, 0.295, 0.505, -0.0030000000000001, 222, 222, 222, 204) -- Reason section
			DrawRect(0.498, 0.711, 0.535, -0.0290000000000009, 222, 222, 222, 204) -- Above the yellow text
			DrawAdvancedText(0.600, 0.66, 0.005, 0.0028, 0.519, '~g~0 Points', 255, 255, 255, 255, 4, 0)
			DrawAdvancedText(0.600, 0.76, 0.005, 0.0028, 0.509, '~y~Your warning points are reduced by 2 every month', 255, 255, 255, 255, 4, 0)
            DrawAdvancedText(0.364, 0.27, 0.005, 0.0028, 0.5, "ID", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.449, 0.27, 0.005, 0.0028, 0.5, "Type", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.527, 0.271, 0.005, 0.0028, 0.5, "Duration", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.593, 0.271, 0.005, 0.0028, 0.5, "Admin", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.677, 0.271, 0.005, 0.0028, 0.5, "Date", 255, 255, 255, 255, 6, 0)
			DrawAdvancedText(0.779, 0.271, 0.005, 0.0028, 0.5, "Reason", 255, 255, 255, 255, 6, 0)
			for warningID,warningTable in pairs(lunaWarnings) do
				local warning_id, warning_type,duration,admin,date,reason = warningTable["warning_id"], warningTable["warning_type"],warningTable["duration"],warningTable["admin"],warningTable["warning_date"],warningTable["reason"]
				if warning_type == "Warning" then
					warningColourR = 255
					warningColourG = 255
					warningColourB = 255
				elseif warning_type == "Kick" then
					warningColourR = 255
					warningColourG = 255
					warningColourB = 255
				elseif warning_type == "Ban" then
					warningColourR = 255
					warningColourG = 255
					warningColourB = 255
				end
                DrawAdvancedText(0.364, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, warning_id,  255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.449, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, warning_type, warningColourR, warningColourG, warningColourB, 255, 6, 0)
				DrawAdvancedText(0.527, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, duration,  255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.593, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, admin,  255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.677, 0.309+(rowcounter*xoffset), 0.005, 0.0028, 0.4, date,  255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.779, 0.290+(rowcounter*xoffset), 0.005, 0.0028, 0.4, reason,  255, 255, 255, 255, 6, 0)
				rowcounter = rowcounter + 1
			end
			rowcounter = 0
		end
		Wait(0)
	end	
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
   -- SetTextDropShadow(0, 0, 0, 0,255)
   -- SetTextEdge(1, 0, 0, 0, 255)
   -- SetTextDropShadow()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end