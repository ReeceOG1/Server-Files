local a = nil
local b = {}
local c = ""
local function checkOutfits()
    if next(b) then
        return true
    end
    return false
end
RMenu.Add("gmtwardrobe","mainmenu",RageUI.CreateMenu("", "", tGMT.getRageUIMenuWidth(), tGMT.getRageUIMenuHeight(), "gmt_wardrobeui", "gmt_wardrobeui"))
RMenu:Get("gmtwardrobe", "mainmenu"):SetSubtitle("HOME")
RMenu.Add("gmtwardrobe","listoutfits",RageUI.CreateSubMenu(RMenu:Get("gmtwardrobe", "mainmenu"),"","Wardrobe",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight()))
RMenu.Add("gmtwardrobe","equip",RageUI.CreateSubMenu(RMenu:Get("gmtwardrobe", "listoutfits"),"","Wardrobe",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('gmtwardrobe', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("List Outfits","",{RightLabel = "→→→"},checkOutfits(),function(d, e, f)
            end,RMenu:Get("gmtwardrobe", "listoutfits"))
            RageUI.Button("Save Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    c = getGenericTextInput("outfit name:")
                    if c then
                        if not tGMT.isPlayerInAnimalForm() then
                            TriggerServerEvent("GMT:saveWardrobeOutfit", c)
                        else
                            tGMT.notify("~r~Cannot save animal in wardrobe.")
                        end
                    else
                        tGMT.notify("~r~Invalid outfit name")
                    end
                end
            end)
            RageUI.Button("Get Outfit Code","Gets a code for your current outfit which can be shared with other players.",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    if tGMT.isPlusClub() or tGMT.isPlatClub() then
                        TriggerServerEvent("GMT:getCurrentOutfitCode")
                    else
                        tGMT.notify("~y~You need to be a subscriber of GMT Plus or GMT Platinum to use this feature.")
                        tGMT.notify("~y~Available @ store.gmtstudios.uk")
                    end
                end
            end,nil)
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('gmtwardrobe', 'listoutfits')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if b ~= {} then
                for g, h in pairs(b) do
                    RageUI.Button(g,"",{RightLabel = "→→→"},true,function(d, e, f)
                        if f then
                            c = g
                        end
                    end,RMenu:Get("gmtwardrobe", "equip"))
                end
            else
                RageUI.Button("No outfits saved","",{RightLabel = "→→→"},true,function(d, e, f)
                end,RMenu:Get("gmtwardrobe", "mainmenu"))
            end
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('gmtwardrobe', 'equip')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Equip Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("GMT:equipWardrobeOutfit", c)
                end
            end,RMenu:Get("gmtwardrobe", "listoutfits"))
            RageUI.Button("Delete Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("GMT:deleteWardrobeOutfit", c)
                end
            end,RMenu:Get("gmtwardrobe", "listoutfits"))
        end, function()
        end)
    end
end)

local function i()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('gmtwardrobe', 'mainmenu'), true)
end
local function j()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("gmtwardrobe", "mainmenu"), false)
end
RegisterNetEvent("GMT:openOutfitMenu",function(k)
    if k then
        b = k
    else
        TriggerServerEvent("GMT:initWardrobe")
    end
    i()
end)
RegisterNetEvent("GMT:refreshOutfitMenu",function(k)
    b = k
end)
RegisterNetEvent("GMT:closeOutfitMenu",function()
    j()
end)