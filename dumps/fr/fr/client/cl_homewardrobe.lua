local a = nil
local b = {}
local c = ""
local function checkOutfits()
    if next(b) then
        return true
    end
    return false
end
RMenu.Add("frwardrobe","mainmenu",RageUI.CreateMenu("", "", tFR.getRageUIMenuWidth(), tFR.getRageUIMenuHeight(), "fr_wardrobeui", "fr_wardrobeui"))
RMenu:Get("frwardrobe", "mainmenu"):SetSubtitle("HOME")
RMenu.Add("frwardrobe","listoutfits",RageUI.CreateSubMenu(RMenu:Get("frwardrobe", "mainmenu"),"","Wardrobe",tFR.getRageUIMenuWidth(),tFR.getRageUIMenuHeight()))
RMenu.Add("frwardrobe","equip",RageUI.CreateSubMenu(RMenu:Get("frwardrobe", "listoutfits"),"","Wardrobe",tFR.getRageUIMenuWidth(),tFR.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('frwardrobe', 'mainmenu')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("List Outfits","",{RightLabel = "→→→"},checkOutfits(),function(d, e, f)
            end,RMenu:Get("frwardrobe", "listoutfits"))
            RageUI.Button("Save Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    c = getGenericTextInput("outfit name:")
                    if c then
                        if not tFR.isPlayerInAnimalForm() then
                            TriggerServerEvent("FR:saveWardrobeOutfit", c)
                        else
                            tFR.notify("Cannot save animal in wardrobe.")
                        end
                    else
                        tFR.notify("~r~Invalid outfit name")
                    end
                end
            end)
            RageUI.Button("Get Outfit Code","Gets a code for your current outfit which can be shared with other players.",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    if tFR.isPlusClub() or tFR.isPlatClub() then
                        TriggerServerEvent("FR:getCurrentOutfitCode")
                    else
                        tFR.notify("~y~You need to be a subscriber of FR Plus or FR Platinum to use this feature.")
                        tFR.notify("~y~Available @ frstudios.tebex.io")
                    end
                end
            end,nil)
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('frwardrobe', 'listoutfits')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            if b ~= {} then
                for g, h in pairs(b) do
                    RageUI.Button(g,"",{RightLabel = "→→→"},true,function(d, e, f)
                        if f then
                            c = g
                        end
                    end,RMenu:Get("frwardrobe", "equip"))
                end
            else
                RageUI.Button("No outfits saved","",{RightLabel = "→→→"},true,function(d, e, f)
                end,RMenu:Get("frwardrobe", "mainmenu"))
            end
        end, function()
        end)
    end
    if RageUI.Visible(RMenu:Get('frwardrobe', 'equip')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Button("Equip Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("FR:equipWardrobeOutfit", c)
                end
            end,RMenu:Get("frwardrobe", "listoutfits"))
            RageUI.Button("Delete Outfit","",{RightLabel = "→→→"},true,function(d, e, f)
                if f then
                    TriggerServerEvent("FR:deleteWardrobeOutfit", c)
                end
            end,RMenu:Get("frwardrobe", "listoutfits"))
        end, function()
        end)
    end
end)

local function i()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get('frwardrobe', 'mainmenu'), true)
end
local function j()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("frwardrobe", "mainmenu"), false)
end
RegisterNetEvent("FR:openOutfitMenu",function(k)
    if k then
        b = k
    else
        TriggerServerEvent("FR:initWardrobe")
    end
    i()
end)
RegisterNetEvent("FR:refreshOutfitMenu",function(k)
    b = k
end)
RegisterNetEvent("FR:closeOutfitMenu",function()
    j()
end)