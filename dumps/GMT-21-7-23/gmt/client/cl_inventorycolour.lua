local b=false
RMenu.Add('inventorycolour','main',RageUI.CreateMenu("","~b~GMT Inventory Customiser ",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight(),"gmt_settingsui","gmt_settingsui"))
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('inventorycolour', 'main')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = false}, function()
            if not b then 
                b=true 
            end
            RageUI.ButtonWithStyle("Change Inventory Colour","Set inventory colour with RGB values.",{RightLabel = "→→→"},true,function(ad, ae, af)
                if af then
                    tGMT.setInventoryColour()
                end
            end)
            RageUI.ButtonWithStyle("Reset Inventory Colour","Set inventory colour back to it's old value.",{RightLabel = "→→→"},true,function(ad, ae, af)
                if af then
                    tGMT.setInventoryOriginalColour()
                end
            end)
        end)
    end
end, 1)