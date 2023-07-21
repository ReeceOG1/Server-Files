GMT = GMT or {}

local a = 0
local b = 0
local c = 0
local d = 0

RMenu.Add("lottery", "mainmenu", RageUI.CreateMenu("", "Main Menu", tGMT.getRageUIMenuWidth(), tGMT.getRageUIMenuHeight(), "gmt_lotteryui", "gmt_lotteryui"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("lottery", "mainmenu")) then
        RageUI.IsVisible(RMenu:Get("lottery", "mainmenu"), true, true, true, function()
            RageUI.Separator("------------------")
            RageUI.Separator("Pot £" .. getMoneyStringFormatted(b))

            if c > 0 then
                RageUI.Separator(tostring(c) .. " Participant" .. (c > 1 and "s" or ""))
            else
                RageUI.Separator("No Participants")
            end

            if d > 0 then
                local e = math.floor(b / a)
                local f = d > 1 and " tickets" or " ticket"
                RageUI.Separator("You have purchased " .. tostring(d) .. f .. " (" .. tostring(math.floor(d / e * 100)) .. "%)")
            else
                RageUI.Separator("You haven't purchased any tickets")
            end

            RageUI.Separator("------------------")
           -- RageUI.Separator("~y~Drawn at 8:00PM UK Time")
           -- RageUI.Separator("~y~Tickets can be purchased at a convenience store")
           RageUI.Separator("~y~This is a upcoming feature")
           RageUI.Separator("~y~Tickets cannot be purchased at this time") -- This is here for a placeholder until we get store tickets working
        end)
    end
end)


RegisterNetEvent("GMT:setLotteryInfo")
AddEventHandler("GMT:setLotteryInfo", function(potValue)
    b = potValue -- Update the pot value
end)

RegisterNetEvent("GMT:setPersonalAmountBought", function(j)
    d = j
end)

RegisterCommand("lottery", function()
    RageUI.Visible(RMenu:Get("lottery", "mainmenu"), true)
    TriggerServerEvent("GMT:getLotteryInfo")
end, false)

function GMT.getLotteryTicketPrice()
    return a
end
