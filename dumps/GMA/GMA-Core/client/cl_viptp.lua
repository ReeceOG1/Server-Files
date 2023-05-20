local distanceToVIPEntrance = 1000
local VIPEntranceVector = vector3(-2176.3305664062, 5141.0712890625, 2.8159818649292)
local VIPExitVector = vector3(152.74851989746,-1034.6242675781,29.338396072388)

RMenu.Add('VIP_enter', 'VIP', RageUI.CreateMenu("", "", 0, 100, "shopui_title_VIP", "shopui_title_VIP"))
RMenu:Get('VIP_enter', 'VIP'):SetSubtitle("~b~ENTER")

function showVIPEnter(flag)
    RageUI.Visible(RMenu:Get('VIP_enter', 'VIP'), flag)
end

RageUI.CreateWhile(1.0, RMenu:Get('VIP_enter', 'VIP'), nil, function()
    RageUI.IsVisible(RMenu:Get('VIP_enter', 'VIP'), true, false, true, function()

        RageUI.ButtonWithStyle("Legion", nil, { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if (Selected) then
                SetEntityCoords(PlayerPedId(), VIPExitVector.x, VIPExitVector.y, VIPExitVector.z)
            end
        end)

    end)
end)

Citizen.CreateThread(function()
    while true do
        if distanceToVIPEntrance < 1.5 then
            showVIPEnter(true)
        elseif distanceToVIPEntrance < 2.5 then
            showVIPEnter(false)
        end

        DrawMarker(27, VIPEntranceVector.x, VIPEntranceVector.y, VIPEntranceVector.z - 1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 255, 255, 255, 200, 0, 0, 0, 0)
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        distanceToVIPEntrance = #(playerCoords - VIPEntranceVector)
        Wait(100)
    end
end)
