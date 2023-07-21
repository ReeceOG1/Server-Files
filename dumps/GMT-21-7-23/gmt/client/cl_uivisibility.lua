local disableMainUI = false
local disableKillfeed = false
local disableChat = false

function tGMT.setShowHealthPercentageFlag(q)
    SetResourceKvp("gmt_healthpercentage", tostring(q))
end

local t = GetResourceKvpString("gmt_healthpercentage") or "false"
if t == "false" then
    h = false
else
    h = true
end

function tGMT.getShowHealthPercentageFlag()
    return h
end

RMenu.Add('uivisibility','main',RageUI.CreateMenu("","~b~UI Visibility",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight(),"gmt_settingsui","gmt_settingsui"))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('uivisibility', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false}, function()
            local function a9()
                tGMT.hideUI()
                hideUI = true
            end
            local function aa()
                tGMT.showUI()
                hideUI = false
            end
            local function a9()
                tGMT.toggleBlackBars()
                e = true
            end
            local function aa()
                tGMT.toggleBlackBars()
                e = false
            end
            RageUI.Checkbox(
                "Show Health Percentage",
                "Displays the health and armour percentage on the bars.",
                h,
                {},
                function()
                end,
                function()
                    h = true
                    tGMT.setShowHealthPercentageFlag(true)
                end,
                function()
                    h = false
                    tGMT.setShowHealthPercentageFlag(false)
                end
            )
            RageUI.Checkbox(
                "Streetnames",
                "",
                tGMT.isStreetnamesEnabled(),
                {RightBadge = RageUI.CheckboxStyle.Car},
                function(a4, a6, a5, a8)
                end,
                function()
                    tGMT.setStreetnamesEnabled(true)
                end,
                function()
                    tGMT.setStreetnamesEnabled(false)
                end
            )
            RageUI.Checkbox(
                "Compass",
                "",
                tGMT.isCompassEnabled(),
                {RightBadge = RageUI.CheckboxStyle.Car},
                function(a4, a6, a5, a8)
                end,
                function()
                    tGMT.setCompassEnabled(true)
                end,
                function()
                    tGMT.setCompassEnabled(false)
                end
            )
            RageUI.Checkbox(
                "Cinematic Black Bars",
                "",
                e,
                {RightBadge = RageUI.CheckboxStyle.Car},
                function(a4, a6, a5, a8)
                end,
                a9,
                aa
            )
            RageUI.Separator("~y~These changes are persistent across restarts")
            RageUI.ButtonWithStyle(
                "Crosshair",
                "Create a custom built-in crosshair here.",
                {RightLabel = "→→→"},
                true,
                function(a4, a5, a6)
                end,
                RMenu:Get("crosshair", "main")
            )
            RageUI.Checkbox("Disable Main UI","/hideui",disableMainUI,{Style = RageUI.CheckboxStyle.Car},function(Hovered, Active, Selected)
                if Selected then
                    if disableMainUI then
                        ExecuteCommand("showui")
                    else
                        ExecuteCommand("hideui")
                    end
                    disableMainUI = not disableMainUI
                end
            end)

            RageUI.Checkbox("Disable Killfeed","/togglekillfeed",disableKillfeed,{},function(Hovered, Active, Selected)
                if Selected then
                    if disableKillfeed then
                        ExecuteCommand("showkillfeed")
                    else
                        ExecuteCommand("togglekillfeed")
                    end
                    disableKillfeed = not disableKillfeed
                end
            end) 

            RageUI.Checkbox("Disable Chat","/hidechat",disableChat,{Style = RageUI.CheckboxStyle.Car},function(Hovered, Active, Selected)
                if Selected then
                    if disableChat then
                        ExecuteCommand("showchat")
                    else
                        ExecuteCommand("hidechat")
                    end
                    disableChat = not disableChat
                end
            end)
            
        end)
    end
end)
