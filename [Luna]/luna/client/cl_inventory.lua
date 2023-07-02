local drawInventoryUI = false
local NearLootBag = false; 
local a = false

local b = false

local c = false

local currentInventoryWeight = 0.00

local currentInventoryMaxWeight = 0

local e = 0.00

local f = nil

local g = nil

local h = nil

local closeToRestart = false

local j = nil

local k = 0

local l = 0

local NearMoneyBag = false;

local NearestMoney = false;

local NearestMoneyNetID = false;

local Prop = GetHashKey("prop_poly_bag_money")

local IsLootBagOpening = false;

local inventoryType = nil;

local NearLootBag = false;

local LootBagID = nil;

local LootBagIDNew = false;

local LootBagCoords = nil;

local model = GetHashKey('xs_prop_arena_bag_01')

local bulletsSelected = false

local bullets = {

    ["9mm Bullets"] = true,

    ["50 CAL"] = true,

    ["12 Gauge Pellets"] = true,

    ["12 Gauge"] = true,

    ["7.62 Bullets"] = true,

    [".308 Bullets"] = true,

    ["5.56 NATO"] = true,

    [".357 Bullets"] = true,

    ["Police Issued 5.56mm"] = true,

    ["Police Issued .308"] = true,

    ["Police Issued 9mm"] = true,

    ["Police Issued 12 Gauge"] = true,

}



local rad = math.rad

local cos = math.cos

local sin = math.sin

local abs = math.abs

local function RotationToDirection(rotation)

    local x = rad(rotation.x)

    local z = rad(rotation.z)

    return vector3(-sin(z) * abs(cos(x)), cos(z) * abs(cos(x)), sin(x))

end

function RayCastGamePlayCamera(distance)

	local cameraRotation = GetGameplayCamRot()

	local cameraCoord = GetGameplayCamCoord()

	local direction = RotationToDirection(cameraRotation)

	local destination =

	{

		x = cameraCoord.x + direction.x * distance,

		y = cameraCoord.y + direction.y * distance,

		z = cameraCoord.z + direction.z * distance

	}

	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))

	return b, c, e

end

local function updateShapeTest()

    local result, _, _, _, entity = GetShapeTestResult(shapeTestHandle)

    if result ~= 1 then -- Not Pending

        if result == 2 then -- Complete

            Entity = entity

            EntityType = GetEntityType(entity)

        end

        local cameraRotation = GetGameplayCamRot()

        local cameraCoord = GetGameplayCamCoord()

        local direction = RotationToDirection(cameraRotation)

        local destination = vector3(cameraCoord.x + direction.x * 6.0, cameraCoord.y + direction.y * 6.0, cameraCoord.z + direction.z * 6.0)

        shapeTestHandle = StartShapeTestLosProbe(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1)

    end

end

Citizen.CreateThread(function()

    while true do

        Wait(0)

        if NearLootBag then

            local coords = GetEntityCoords(PlayerPedId())

            hit2, coords2, Entity2 = RayCastGamePlayCamera(6.0)

            EntityType2 = GetEntityType(Entity2)

            if EntityType2 and EntityType2 == 3 then

                local entityModel = GetEntityModel(Entity2)

                if entityModel == model and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then

                    local distance = #(coords - coords2)

                    if distance <= 2.5 and IsControlJustReleased(1, 38) then

                        TriggerEvent("LUNA:startCombatTimer", 60)

                        -- print("Lootbag ID: " .. LootBagIDNew)

                        LootBagID = GetClosestObjectOfType(coords, 2.5, model, false, false, false)

                        LootBagIDNew = ObjToNet(LootBagID)

                        TriggerServerEvent('LUNA:LootBag', LootBagIDNew, distance, entityModel)

						if clockedon then 

                        Wait(1000)

						-- print(distance)

						DeleteEntity(LootBagID)

                    	end

					end

				end

			end

		end

	end

end)



Citizen.CreateThread(function()

    while true do

        Wait(0)

        if NearLootBag and clockedon then

			-- print(clockedon)

            local coords = GetEntityCoords(PlayerPedId())

            hit2, coords2, Entity2 = RayCastGamePlayCamera(6.0)

            EntityType2 = GetEntityType(Entity2)

            if EntityType2 and EntityType2 == 3 then

                local entityModel = GetEntityModel(Entity2)

                if entityModel == model and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then

                    local distance = #(coords - coords2)

                    if distance <= 2.5 and IsControlJustReleased(1, 38) then

                        TriggerEvent("LUNA:startCombatTimer", 60)

                        -- print("Lootbag ID: " .. LootBagIDNew)

                        LootBagID = GetClosestObjectOfType(coords, 2.5, model, false, false, false)

                        LootBagIDNew = ObjToNet(LootBagID)

                        TriggerServerEvent('LUNA:LootBag', LootBagIDNew, distance, entityModel)

                        Wait(1000)

						DeleteEntity(LootBagID)

						-- print(distance)

                    end

                end

            end

        end

    end

end)



function sortAlphabetically(aV)

    local aR = {}

    for ad, c in pairsByKeys(aV) do

        table.insert(aR, {title = ad, value = c})

    end

    aV = aR

    return aV

end

function pairsByKeys(aR, aS)

    local E = {}

    for aT in pairs(aR) do

        table.insert(E, aT)

    end

    table.sort(E, aS)

    local j = 0

    local aU = function()

        j = j + 1

        if E[j] == nil then

            return nil

        else

            return E[j], aR[E[j]]

        end

    end

    return aU

end

local BootCar = nil

local VehTypeC = nil

local VehTypeA = nil

local IsLootBagOpening = false

inventoryType = nil

local LootBagCrouchLoop = false



Citizen.CreateThread(function()

    while true do

        if IsControlJustPressed(0, 182) then

            if IsUsingKeyboard(2) and not tLUNA.isInComa() then

                if not closeToRestart then

					TriggerServerEvent('LUNA:FetchPersonalInventory')

					drawInventoryUI = not drawInventoryUI

					a = false

					TriggerEvent("LUNA:AllowWeap",drawInventoryUI)

                    if drawInventoryUI then

                        setCursor(1)

                    else

                        setCursor(0)

                        inGUILUNA = false

                        if BootCar then

                            tLUNA.vc_closeDoor(VehTypeC, 5)

                            --BootCar = nil;

                            --VehTypeC = nil;

                           -- VehTypeA = nil;

                            TriggerEvent('LUNA:clCloseTrunk')

                        end

                        inventoryType = nil

                    end

                else

                    tLUNA.notify("~r~Cannot open inventory right before a restart!")

                end

            end

        end

        Wait(0)

    end

end)

LUNAItemList = {}

LUNASecondItemList = {}

function tLUNA.getSpaceInFirstChest()

    return currentInventoryMaxWeight - currentInventoryWeight

end

function tLUNA.getSpaceInSecondChest()

    local m = 0

    if next(LUNASecondItemList) == nil then

        return e

    else

        for n, o in pairs(LUNASecondItemList) do

            m = m + o.amount * o.Weight

        end

        return e - m

    end

end

RegisterNetEvent("LUNA:FetchPersonalInventory",function(inventory, weight, maxWeight)

    LUNAItemList = inventory

    currentInventoryWeight = weight

    currentInventoryMaxWeight = maxWeight

end)

RegisterNetEvent("LUNA:SendSecondaryInventoryData",function(p, q, r)

    LUNASecondItemList = p

    e = r

    c = true

    --drawInventoryUI = true

    setCursor(1)

    if r then

        g = r

        h = GetEntityCoords(tLUNA.getPlayerPed())

        if r == "notmytrunk" then

            j = GetEntityCoords(tLUNA.getPlayerPed())

        end

        if string.match(r, "player_") then

            l = string.gsub(r, "player_", "")

        else

            l = 0

        end

    end

end)

RegisterNetEvent("LUNA:closeToRestart",function(p)

    closeToRestart = true

    Citizen.CreateThread(function()

        while true do

            LUNASecondItemList = {}

            c = false

            drawInventoryUI = false

            setCursor(0)

            Wait(50)

        end

    end)

end)

RegisterNetEvent("LUNA:closeSecondInventory",function()

    LUNASecondItemList = {}

    c = false

    drawInventoryUI = false

    g = nil

    setCursor(0)

end)



Citizen.CreateThread(function()

    while true do

        if f ~= nil and c then

            local z = GetEntityCoords(tLUNA.getPlayerPed())

            local A = GetEntityCoords(f)

            local B = #(z - A)

            if B > 10.0 then

                TriggerEvent("LUNA:clCloseTrunk")

                TriggerServerEvent("LUNA:closeChest")

            end

        end

        if g == "house" and c then

            local z = GetEntityCoords(tLUNA.getPlayerPed())

            local A = h

            local B = #(z - A)

            if B > 5.0 then

                TriggerEvent("LUNA:clCloseTrunk")

                TriggerServerEvent("LUNA:closeChest")

            end

        end

        if g == "notmytrunk" and c then

            local z = GetEntityCoords(tLUNA.getPlayerPed())

            local A = j

            local B = #(z - A)

            if B > 5.0 then

                TriggerEvent("LUNA:clCloseTrunk")

                TriggerServerEvent("LUNA:closeChest")

            end

        end

        if l ~= 0 and c then

            local z = GetEntityCoords(tLUNA.getPlayerPed())

            local A = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(l))))

            local B = #(z - A)

            if B > 5.0 then

                TriggerEvent("LUNA:clCloseTrunk")

                TriggerServerEvent("LUNA:closeChest")

            end

        end

        if f == nil and g == "trunk" then

            c = false

            drawInventoryUI = false

        end

        Wait(500)

    end

end)



Citizen.CreateThread(function()

	while true do

		if drawInventoryUI then

			DrawRect(0.5, 0.53, 0.572, 0.508, 0, 0, 0, 150);

			DrawAdvancedText(0.593, 0.242, 0.005, 0.0028, 0.66, "LUNA Inventory", 255, 255, 255, 255, 7, 0);

			DrawRect(0.5, 0.24, 0.572, 0.058, 0, 0, 0, 225);

			DrawRect(0.342, 0.536, 0.215, 0.436, 0, 0, 0, 150);

			DrawRect(0.652, 0.537, 0.215, 0.436, 0, 0, 0, 150);

			if bulletsSelected then

				DrawAdvancedText(0.575, 0.364, 0.005, 0.0028, 0.325, "Use", 255, 255, 255, 255, 6, 0);

				DrawAdvancedText(0.615, 0.364, 0.005, 0.0028, 0.325, "Use All", 255, 255, 255, 255, 6, 0);

			else

				DrawAdvancedText(0.594, 0.364, 0.005, 0.0028, 0.4, "Use", 255, 255, 255, 255, 6, 0);

			end

			DrawAdvancedText(0.594, 0.454, 0.005, 0.0028, 0.4, "Move", 255, 255, 255, 255, 6, 0);

			DrawAdvancedText(0.575, 0.545, 0.005, 0.0028, 0.325, "Move X", 255, 255, 255, 255, 6, 0);

			DrawAdvancedText(0.615, 0.545, 0.005, 0.0028, 0.325, "Move All", 255, 255, 255, 255, 6, 0);

			DrawAdvancedText(0.595, 0.634, 0.005, 0.0028, 0.35, "Give to Nearest Player", 255, 255, 255, 255, 6, 0);

			DrawAdvancedText(0.594, 0.722, 0.005, 0.0028, 0.4, "Trash", 255, 255, 255, 255, 6, 0);

			DrawAdvancedText(0.488, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0);

			DrawAdvancedText(0.404, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0);

			DrawAdvancedText(0.521, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0);

			DrawAdvancedText(0.833, 0.776, 0.005, 0.0028, 0.288, "[Press L to close]", 255, 255, 255, 255, 4, 0);

			DrawRect(0.5, 0.273, 0.572, 0.0069999999999999,  0,168,255, 150);

			inGUILUNA = true;

			if not c then

				DrawAdvancedText(0.751, 0.525, 0.005, -0.027, 0.6, "2nd Inventory not available", 255, 255, 255, 118, 6, 0);

			elseif (g ~= nil) then

				DrawAdvancedText(0.798, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0);

				DrawAdvancedText(0.714, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0);

				DrawAdvancedText(0.831, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0);

				local C = 0.026;

				local D = 0.026;

				local E = 0;

				local F = 0;

				local G = sortAlphabetically(LUNASecondItemList);

				for H, I in pairs(G) do

					local v = I.title;

					local w = I['value'];

					local J, K, m = w.ItemName, w.amount, w.Weight;

					F = F + (K * m);

					DrawAdvancedText(0.714, 0.36 + (E * D), 0.005, 0.0028, 0.366, J, 255, 255, 255, 255, 4, 0);

					DrawAdvancedText(0.831, 0.36 + (E * D), 0.005, 0.0028, 0.366, tostring(m * K) .. "kg", 255, 255, 255, 255, 4, 0);

					DrawAdvancedText(0.798, 0.36 + (E * D), 0.005, 0.0028, 0.366, K, 255, 255, 255, 255, 4, 0);

					if CursorInArea(0.5443, 0.7584, 0.3435 + (E * D), 0.369 + (E * D)) then

						DrawRect(0.652, 0.331 + (C * (E + 1)), 0.215, 0.026, 0,168,255, 150);

						if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

							PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

							if not lockInventorySoUserNoSpam then

								b = v;

								a = false;

								k = K;

								selectedItemWeight = m;

								lockInventorySoUserNoSpam = true;

								Citizen.CreateThread(function()

									Wait(250);

									lockInventorySoUserNoSpam = false;

								end);

							end

						end

					elseif (v == b) then

						DrawRect(0.652, 0.331 + (C * (E + 1)), 0.215, 0.026, 0,168,255, 150);

					end

					E = E + 1;

				end

				if ((F / e) > 0.5) then

					if ((F / e) > 0.9) then

						DrawAdvancedText(0.826, 0.307, 0.005, 0.0028, 0.366, "Weight: " .. F .. "/" .. e .. "kg", 255, 50, 0, 255, 4, 0);

					else

						DrawAdvancedText(0.826, 0.307, 0.005, 0.0028, 0.366, "Weight: " .. F .. "/" .. e .. "kg", 255, 165, 0, 255, 4, 0);

					end

				else

					DrawAdvancedText(0.826, 0.307, 0.005, 0.0028, 0.366, "Weight: " .. F .. "/" .. e .. "kg", 255, 255, 153, 255, 4, 0);

				end

			end

			if bulletsSelected then

				if CursorInArea(0.46, 0.496, 0.33, 0.383) then

					DrawRect(0.48, 0.359, 0.0375, 0.056, 0,168,255, 150);

					if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

						PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

						if not lockInventorySoUserNoSpam then

							if a then

								-- print("pressed use item " .. a);

								TriggerServerEvent("LUNA:UseItem", a, "Plr");

							elseif (b and (g ~= nil) and c) then

								-- print("pressed use item");

								LUNAclient.useInventoryItem({b});

							else

								tLUNA.notify("~r~No item selected!");

							end

						end

						lockInventorySoUserNoSpam = true;

						Citizen.CreateThread(function()

							Wait(250);

							lockInventorySoUserNoSpam = false;

						end);

					end

				else

					DrawRect(0.48, 0.359, 0.0375, 0.056, 0, 0, 0, 150);

				end

				if CursorInArea(0.501, 0.536, 0.329, 0.381) then

					DrawRect(0.52, 0.359, 0.0375, 0.056, 0,168,255, 150);

					if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

						PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

						if not lockInventorySoUserNoSpam then

							if a then

								TriggerServerEvent("LUNA:UseAllItem", a, "Plr");

							elseif (b and (g ~= nil) and c) then

								vRRclient.useInventoryItem({b});

							else

								tLUNA.notify("~r~No item selected!");

							end

						end

						lockInventorySoUserNoSpam = true;

						Citizen.CreateThread(function()

							Wait(250);

							lockInventorySoUserNoSpam = false;

						end);

					end

				else

					DrawRect(0.52, 0.359, 0.0375, 0.056, 0, 0, 0, 150);

				end

			elseif CursorInArea(0.4598, 0.5333, 0.3283, 0.3848) then

				DrawRect(0.5, 0.36, 0.075, 0.056, 0,168,255, 150);

				if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

					if not lockInventorySoUserNoSpam then

						if a then

							TriggerServerEvent("LUNA:UseItem", a, "Plr");

						elseif (b and (g ~= nil) and c) then

						else

							tLUNA.notify("~r~No item selected!");

						end

					end

					lockInventorySoUserNoSpam = true;

					Citizen.CreateThread(function()

						Wait(250);

						lockInventorySoUserNoSpam = false;

					end);

				end

			else

				DrawRect(0.5, 0.36, 0.075, 0.056, 0, 0, 0, 150);

			end

			if CursorInArea(0.4598, 0.5333, 0.418, 0.4709) then

				DrawRect(0.5, 0.45, 0.075, 0.056, 0,168,255, 150);

				if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

					if not lockInventorySoUserNoSpam then

						if c then

							if (a and (g ~= nil) and c) then

								if (tLUNA.getPlayerCombatTimer() > 0) then

									tLUNA.notify("~r~You can not store items whilst in combat.");

								elseif (inventoryType == "CarBoot") then

									-- print("line 546 inventory"..VehTypeA .. a);

                                TriggerServerEvent("LUNA:MoveItem", "Plr", a, VehTypeC, false);

                                -- print("Moved Item: "..a.." to Vehicle: "..VehTypeC);

								elseif (inventoryType == "Housing") then

									TriggerServerEvent("LUNA:MoveItem", "Plr", a, "home", false);

									-- print("line 385 inventory"..a);

								elseif IsLootBagOpening then

									TriggerServerEvent("LUNA:MoveItem", "Plr", a, "LootBag", true);

									-- print("line 388 inventory");

								end

							elseif (b and (g ~= nil) and c) then

								if (inventoryType == "CarBoot") then

									TriggerServerEvent("LUNA:MoveItem", inventoryType, b, VehTypeC, false);

									-- print("line 395 inventory");

								elseif (inventoryType == "Housing") then

									TriggerServerEvent("LUNA:MoveItem", inventoryType, b, "home", false);

									-- print("line 398 inventory");

								else

									TriggerServerEvent("LUNA:MoveItem", "LootBag", b, LootBagIDNew, true);

									-- print("Line 401:Item Name = " .. b);

								end

							else

								tLUNA.notify("~r~No item selected!");

							end

						else

							tLUNA.notify("~r~No second inventory available!");

						end

					end

					lockInventorySoUserNoSpam = true;

					Citizen.CreateThread(function()

						Wait(250);

						lockInventorySoUserNoSpam = false;

					end);

				end

			else

				DrawRect(0.5, 0.45, 0.075, 0.056, 0, 0, 0, 150);

			end

			if CursorInArea(0.4598, 0.498, 0.5042, 0.5666) then

				DrawRect(0.48, 0.54, 0.0375, 0.056, 0,168,255, 150);

				if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

					local L = tonumber(GetInvAmountText()) or 1;

					if not lockInventorySoUserNoSpam then

						if c then

							if (a and (g ~= nil) and c) then

								if (tLUNA.getPlayerCombatTimer() > 0) then

									tLUNA.notify("~r~You can not store items whilst in combat.");

								elseif (inventoryType == "CarBoot") then

									TriggerServerEvent("LUNA:MoveItemX", "Plr", a, VehTypeA, false, L);

								elseif (inventoryType == "Housing") then

									TriggerServerEvent("LUNA:MoveItemX", "Plr", a, "home", false, L);

								elseif IsLootBagOpening then

									TriggerServerEvent("LUNA:MoveItemX", "Plr", a, "LootBag", true, L);

								end

							elseif (b and (g ~= nil) and c) then

								if (inventoryType == "CarBoot") then

									TriggerServerEvent("LUNA:MoveItemX", inventoryType, b, VehTypeA, false, L);

								elseif (inventoryType == "Housing") then

									TriggerServerEvent("LUNA:MoveItemX", inventoryType, b, "home", false, L);

								else

									TriggerServerEvent("LUNA:MoveItemX", "LootBag", b, LootBagIDNew, true, L);

								end

							else

								tLUNA.notify("~r~No item selected!");

							end

						else

							tLUNA.notify("~r~No second inventory available!");

						end

					end

					lockInventorySoUserNoSpam = true;

					Citizen.CreateThread(function()

						Wait(250);

						lockInventorySoUserNoSpam = false;

					end);

				end

			else

				DrawRect(0.48, 0.54, 0.0375, 0.056, 0, 0, 0, 150);

			end

			if CursorInArea(0.5004, 0.5333, 0.5042, 0.5666) then

				DrawRect(0.52, 0.54, 0.0375, 0.056, 0,168,255, 150);

				if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

					if not lockInventorySoUserNoSpam then

						if c then

							if (a and (g ~= nil) and c) then

								local M = tLUNA.getSpaceInSecondChest();

								local L = k;

								if ((k * selectedItemWeight) > M) then

									L = math.floor(M / selectedItemWeight);

								end

								if (L > 0) then

									if (tLUNA.getPlayerCombatTimer() > 0) then

										tLUNA.notify("~r~You can not store items whilst in combat.");

									elseif (inventoryType == "CarBoot") then

                                    TriggerServerEvent("LUNA:MoveItemAll", "Plr", a, VehTypeC, false);

									elseif (inventoryType == "Housing") then

										TriggerServerEvent("LUNA:MoveItemAll", "Plr", a, "home");

									elseif IsLootBagOpening then

										TriggerServerEvent("LUNA:MoveItemAll", "Plr", a, "LootBag");

									end

								else

									tLUNA.notify("~r~Not enough space in secondary chest!");

								end

							elseif (b and (g ~= nil) and c) then

								local N = tLUNA.getSpaceInFirstChest();

								local L = k;

								if ((k * selectedItemWeight) > N) then

									L = math.floor(N / selectedItemWeight);

								end

								if (L > 0) then

									if (inventoryType == "CarBoot") then

										TriggerServerEvent("LUNA:MoveItemAll", inventoryType, b, VehTypeC, NetworkGetNetworkIdFromEntity(tLUNA.getNearestVehicle(3)));

									elseif (inventoryType == "Housing") then

										TriggerServerEvent("LUNA:MoveItemAll", inventoryType, b, "home");

									else

										TriggerServerEvent("LUNA:MoveItemAll", "LootBag", b, LootBagIDNew);

									end

								else

									tLUNA.notify("~r~Not enough space in secondary chest!");

								end

							else

								tLUNA.notify("~r~No item selected!");

							end

						else

							tLUNA.notify("~r~No second inventory available!");

						end

					end

					lockInventorySoUserNoSpam = true;

					Citizen.CreateThread(function()

						Wait(250);

						lockInventorySoUserNoSpam = false;

					end);

				end

			else

				DrawRect(0.52, 0.54, 0.0375, 0.056, 0, 0, 0, 150);

			end

			if CursorInArea(0.4598, 0.5333, 0.5931, 0.6477) then

				DrawRect(0.5, 0.63, 0.075, 0.056, 0,168,255, 150);

				if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

					if not lockInventorySoUserNoSpam then

						if a then

							TriggerServerEvent("LUNA:GiveItem", a, "Plr");

						elseif b then

							LUNAclient.giveToNearestPlayer({b});

						else

							tLUNA.notify("~r~No item selected!");

						end

					end

					lockInventorySoUserNoSpam = true;

					Citizen.CreateThread(function()

						Wait(250);

						lockInventorySoUserNoSpam = false;

					end);

				end

			else

				DrawRect(0.5, 0.63, 0.075, 0.056, 0, 0, 0, 150);

			end

			if CursorInArea(0.4598, 0.5333, 0.6831, 0.7377) then

				DrawRect(0.5, 0.72, 0.075, 0.056, 0,168,255, 150);

				if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

					if not lockInventorySoUserNoSpam then

						if a then

							TriggerServerEvent("LUNA:TrashItem", a, "Plr");

						elseif b then

							tLUNA.notify("~r~Please move the item to your inventory in order to trash");

						else

							tLUNA.notify("~r~No item selected!");

						end

					end

					lockInventorySoUserNoSpam = true;

					Citizen.CreateThread(function()

						Wait(250);

						lockInventorySoUserNoSpam = false;

					end);

				end

			else

				DrawRect(0.5, 0.72, 0.075, 0.056, 0, 0, 0, 150);

			end

			local C = 0.026;

			local D = 0.026;

			local E = 0;

			local F = 0;

			local G = sortAlphabetically(LUNAItemList);

			for H, I in pairs(G) do

				local v = I.title;

				local w = I['value'];

				local J, K, m = w.ItemName, w.amount, w.Weight;

				F = F + (K * m);

				DrawAdvancedText(0.404, 0.36 + (E * D), 0.005, 0.0028, 0.366, J, 255, 255, 255, 255, 4, 0);

				DrawAdvancedText(0.521, 0.36 + (E * D), 0.005, 0.0028, 0.366, tostring(m * K) .. "kg", 255, 255, 255, 255, 4, 0);

				DrawAdvancedText(0.488, 0.36 + (E * D), 0.005, 0.0028, 0.366, K, 255, 255, 255, 255, 4, 0);

				if CursorInArea(0.2343, 0.4484, 0.3435 + (E * D), 0.369 + (E * D)) then

					DrawRect(0.342, 0.331 + (C * (E + 1)), 0.215, 0.026, 0,168,255, 150);

					if (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then

						PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);

						a = v;

						if bullets[a] then

							bulletsSelected = true;

						else

							bulletsSelected = false;

						end

						k = K;

						selectedItemWeight = m;

						b = false;

					end

				elseif (v == a) then

					DrawRect(0.342, 0.331 + (C * (E + 1)), 0.215, 0.026, 0,168,255, 150);

				end

				E = E + 1;

			end

			if ((F / currentInventoryMaxWeight) > 0.5) then

				if ((F / currentInventoryMaxWeight) > 0.9) then

					DrawAdvancedText(0.516, 0.307, 0.005, 0.0028, 0.366, "Weight: " .. F .. "/" .. currentInventoryMaxWeight .. "kg", 255, 50, 0, 255, 4, 0);

				else

					DrawAdvancedText(0.516, 0.307, 0.005, 0.0028, 0.366, "Weight: " .. F .. "/" .. currentInventoryMaxWeight .. "kg", 255, 165, 0, 255, 4, 0);

				end

			else

				DrawAdvancedText(0.516, 0.307, 0.005, 0.0028, 0.366, "Weight: " .. F .. "/" .. currentInventoryMaxWeight .. "kg", 255, 255, 255, 255, 4, 0);

			end

		end

		Wait(0);

	end

end);

Citizen.CreateThread(function()

	while true do

		if (GetEntityHealth(tLUNA.getPlayerPed()) <= 102) then

			LUNASecondItemList = {};

			c = false;

			drawInventoryUI = false;

			inGUILUNA = false;

			setCursor(0);

		end

		Wait(50);

	end

end);

function GetInvAmountText()

	AddTextEntry("FMMC_MPM_NA", "Enter amount: (Blank to cancel)");

	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount: (Blank to cancel)", "", "", "", "", 30);

	while UpdateOnscreenKeyboard() == 0 do

		DisableAllControlActions(0);

		Wait(0);

	end

	if GetOnscreenKeyboardResult() then

		local O = GetOnscreenKeyboardResult();

		return O;

	end

	return nil;

end

Citizen.CreateThread(function()

	while true do

		Wait(250);

		if BootCar then

			if (#(BootCar - GetEntityCoords(PlayerPedId())) > 8) then

                setCursor(0)

				drawInventoryUI = false;

                inGUILUNA = false;

				tLUNA.vc_closeDoor(VehTypeC, 5);

				BootCar = nil;

				VehTypeC = nil;

				VehTypeA = nil;

				inventoryType = nil;

                -- print("near boot")

			end

		end

		if drawInventoryUI then

			if tLUNA.isInComa() then

				drawInventoryUI = false;

				inventoryType = nil;

				if BootCar then

					tLUNA.vc_closeDoor(VehTypeC, 5);

					BootCar = nil;

					VehTypeC = nil;

					VehTypeA = nil;

                    -- print("not near boot")

				end

			end

		end

	end

end);

function LoadAnimDict(dict)

	while not HasAnimDictLoaded(dict) do

		RequestAnimDict(dict);

		Citizen.Wait(5);

	end

end

RegisterNetEvent("LUNA:LockPick2");
AddEventHandler("LUNA:LockPick2", function()
	TriggerServerEvent("LUNA:ACBan#76");
end);

RegisterNetEvent("LUNA:InventoryOpen");
AddEventHandler("LUNA:InventoryOpen", function(toggle, lootbag)
	IsLootBagOpening = lootbag;
	if toggle then
		LoadAnimDict('amb@medic@standing@kneel@base')
        LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
        TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false)
    	tLUNA.playAnim(true,{{"anim@gangops@facility@servers@bodysearch@","player_search",1}},true)
    	exports.rprogress:Start("", 2000);
		TriggerServerEvent("LUNA:FetchPersonalInventory");
		drawInventoryUI = true;
		IsLootBagOpening = true;
	else
		TriggerServerEvent("LUNA:CloseLootbag");
		TriggerServerEvent("LUNA:FetchPersonalInventory");
		IsLootBagOpening = false;
		SetNuiFocus(false, false);
		SetNuiFocusKeepInput(false);
		bagid = nil;
		setCursor(0);
		inGUILUNA = false;
		inventoryType = nil;
		ClearPedTasks(PlayerPedId());
		RemoveAnimDict("amb@medic@standing@kneel@base");
		RemoveAnimDict("anim@gangops@facility@servers@bodysearch@");
		c = false;
		LootBagCoords = false;
		NearLootBag = false;
		LootBagID = nil;
		LootBagIDNew = nil;
	end
	if IsLootBagOpening then
        FreezeEntityPosition(PlayerPedId(), true)
		TriggerEvent("LUNA:PlaySound", "zipper");
		LoadAnimDict("amb@medic@standing@kneel@base");

		LoadAnimDict("anim@gangops@facility@servers@bodysearch@");

		TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8, -8, -1, 1, 0, false, false, false);

		TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 8, -8, -1, 48, 0, false, false, false);

		Wait(10000);

		if not IsPedSittingInAnyVehicle(PlayerPedId()) then

			ClearPedTasksImmediately(PlayerPedId());

		end

	end

end);

RegisterNetEvent("LUNA:OpenHomeStorage");

AddEventHandler("LUNA:OpenHomeStorage", function(toggle, houseName)

	if (toggle == true) then

		inventoryType = "Housing";

		drawInventoryUI = true;

		setCursor(1);

		TriggerServerEvent("LUNA:FetchHouseInventory", houseName);

		--TriggerServerEvent("LUNA:FetchPersonalInventory");

	else

		inventoryType = nil;

		drawInventoryUI = false;

		setCursor(0);

	end

end);

RegisterNetEvent("LUNA:SetLootbagFalse");

AddEventHandler("LUNA:SetLootbagFalse", function(a)

	c = a;

	-- print("myVariable is " .. tostring(c));

end);

Citizen.CreateThread(function()

	while true do

		Wait(75);

		if not PlayerInComa then

			local coords = GetEntityCoords(PlayerPedId());

			if DoesObjectOfTypeExistAtCoords(coords, 2.5, model, true) then

				if not NearLootBag then

					NearLootBag = true;

					LootBagID = GetClosestObjectOfType(coords, 2.5, model, false, false, false);

					LootBagIDNew = ObjToNet(LootBagID);

					LootBagCoords = GetEntityCoords(LootBagID);

				end

			else

				LootBagCoords = false;

				NearLootBag = false;

				LootBagID = nil;

				LootBagIDNew = nil;

			end

		end

	end

end);





AddEventHandler("LUNA:clCloseTrunk",function()

    local VehInRadius, VehType, NVeh = tLUNA.getNearestOwnedVehicle(3.5)

    if VehInRadius and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then

        tLUNA.vc_closeDoor(VehType, 5)

     c = false

    drawInventoryUI = false

    g = nil

    setCursor(0)

    f = nil

    inGUILUNA = false

    drawInventoryUI = false

end

end)

AddEventHandler("LUNA:clOpenTrunk",function()

    local VehInRadius, VehType, NVeh = tLUNA.getNearestOwnedVehicle(3.5)

    VehTypeA = VehType

    VehTypeC = NVeh

        drawInventoryUI = true

        if VehInRadius and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then

        BootCar = GetEntityCoords(PlayerPedId())

        tLUNA.vc_openDoor(VehType, 5)

        inventoryType = 'CarBoot'

        TriggerServerEvent('LUNA:FetchPersonalInventory')

        TriggerServerEvent('LUNA:FetchTrunkInventory', VehTypeC)

        -- print(NVeh)

    else

        tLUNA.notify("~r~You don't have the keys to this vehicle!")

    end

end)

local NearMoneyBag = false;
local NearestMoney = false;
local NearestMoneyNetID = false;
local Prop = GetHashKey("prop_poly_bag_money")
Citizen.CreateThread(function()
    while true do 
        Wait(0)
        if not PlayerInComa then
            local Ped = PlayerPedId()
            local coords = GetEntityCoords(Ped)
            if DoesObjectOfTypeExistAtCoords(coords, 1.5, Prop, true) then
                if not NearMoneyBag then
                    NearMoneyBag = true;
                    NearestMoney = GetClosestObjectOfType(coords, 1.5, Prop, false, false, false)
                    NearestMoneyNetID = ObjToNet(NearestMoney)
                end
            else 
                NearMoneyBag = false; 
                NearestMoney = nil;
                NearestMoneyNetID = nil;
            end
            if NearMoneyBag then
                if IsControlJustPressed(0, 38) then
                    if not IsPedSittingInAnyVehicle(Ped) then
                        TriggerServerEvent('LUNA:CollectMoney', NearestMoneyNetID)
                    else
                        Notify("~r~You cannot be in a vehicle!")
                    end
                end
            end
        end
    end
end)

function func_disableGuiControls()

    if inGUILUNA then

        DisableControlAction(0, 1, true)

        DisableControlAction(0, 2, true)

        DisableControlAction(0, 25, true)

        DisableControlAction(0, 106, true)

        DisableControlAction(0, 24, true)

        DisableControlAction(0, 140, true)

        DisableControlAction(0, 141, true)

        DisableControlAction(0, 142, true)

        DisableControlAction(0, 257, true)

        DisableControlAction(0, 263, true)

        DisableControlAction(0, 264, true)

        DisableControlAction(0, 12, true)

        DisableControlAction(0, 14, true)

        DisableControlAction(0, 15, true)

        DisableControlAction(0, 16, true)

        DisableControlAction(0, 17, true)

    end

end

CreateThread( function()

    while true do Wait(1)

        func_disableGuiControls()

    end

end)