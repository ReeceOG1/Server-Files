RMenu.Add('settingz', 'main', RageUI.CreateMenu("", "~b~DM Main Menu", 0,200, "", ""))

RageUI.CreateWhile(1.0, RMenu:Get("settingz", "main"),nil,function()
    RageUI.IsVisible(RMenu:Get("settingz", "main"),true, false,true,function()
        RageUI.List("Render Distance", ConfigMain.Settings.Distances, ConfigMain.Settings.DistanceIndex, "~y~Change render distance, lowering this will increase FPS.", {}, true, function(Hovered, Active, Selected, Index)
            ConfigMain.Settings.DistanceIndex = Index
        end)

        local function ToggleUI()
            if HudActive then
                HudActive = false
            else
                HudActive = true
            end
        end
        RageUI.Checkbox("HUD", "~g~Toggle HUD On/Off", HudActive, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Select, Checked)
        end, ToggleUI, ToggleUI)

        RageUI.List("Weather", ConfigMain.Settings.Weather, ConfigMain.Settings.WeatherIndex, "~g~Change your clients weather.", {}, true, function(Hovered, Active, Selected, Index)
            ConfigMain.Settings.WeatherIndex = Index
        end)

        local function ToggleHSTrue()
            Hitsounds = true
            Draw_Native_Notify("Hitsounds ~g~Enabled~w~, remember to select hitsound ~y~below~w~.")
        end
        local function ToggleHSFalse()
            Hitsounds = false
            Draw_Native_Notify("Hitsounds ~r~Disabled")
        end
        RageUI.Checkbox("Hitsounds","~w~Toggle your hitsounds!", Hitsounds, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Selected, Checked)
        end, ToggleHSTrue, ToggleHSFalse)

        if Hitsounds then
            RageUI.List("Sound", hitsounds, Index, "~g~Press enter to select hitsound", {}, true, function(a,b,Selected, Idex)
                if Selected then
                    TriggerEvent("SetHitSounds", hitsounds[Index])
                    Draw_Native_Notify("Hitsounds set to ~g~" ..hitsounds[Index])
                end

                Index = Idex
            end)
        end

        local function ToggleKDR()
            if KDR then
                KDR = false
            else
                KDR = true
            end
        end
        RageUI.Checkbox("KDR", "~g~Toggle KDR On/Off", KDR, {Style = RageUI.CheckboxStyle.Car}, function(Hovered, Active, Select, Checked)
        end, ToggleKDR, ToggleKDR)

    end)
end)