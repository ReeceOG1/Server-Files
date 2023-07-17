RMenu.Add('PremiumMenu', 'main', RageUI.CreateMenu("", "~b~DM Premium Menu", 1300,100, "", ""))
RMenu.Add('PremiumMenu', 'Weapons',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "main")))
RMenu.Add('PremiumMenu', 'Clothing',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "main")))
RMenu.Add('PremiumMenu', 'Clothes',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "Clothing")))
RMenu.Add('PremiumMenu', 'Skin',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "Clothes")))

-- Weapons Submenu's
RMenu.Add('PremiumMenu', 'Pistols',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "Weapons")))
RMenu.Add('PremiumMenu', 'Shotguns',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "Weapons")))
RMenu.Add('PremiumMenu', 'SMGs',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "Weapons")))
RMenu.Add('PremiumMenu', 'AssualtRifles',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "Weapons")))
RMenu.Add('PremiumMenu', 'SniperRifles',  RageUI.CreateSubMenu(RMenu:Get("PremiumMenu", "Weapons")))

local Skin = {
    Dad = 0,
    Mum = 0,
    DadMumPercentage = 0,
}

local Face = {Max = {}, Index = 0, TextureIndex = 0};
local Mask = {Max = {}, Index = 0, TextureIndex = 0};
local Hair = {Max = {}, Index = 0, TextureIndex = 0};
local Torso = {Max = {}, Index = 0, TextureIndex = 0};
local Legs =  {Max = {}, Index = 0, TextureIndex = 0};
local Parachute = {Max = {}, Index = 0, TextureIndex = 0};
local Shoes = {Max = {}, Index = 0, TextureIndex = 0};
local Accessory = {Max = {}, Index = 0, TextureIndex = 0};
local Undershirt = {Max = {}, Index = 0, TextureIndex = 0};
local Kevlar = {Max = {}, Index = 0, TextureIndex = 0}; 
local Badge = {Max = {}, Index = 0, TextureIndex = 0};
local Torso2 = {Max = {}, Index = 0, TextureIndex = 0};
local Hats = {Max = {}, Index = 0, TextureIndex = 0};
local Glasses = {Max = {}, Index = 0, TextureIndex = 0};
local Earings = {Max = {}, Index = 0, TextureIndex = 0};
local Watches = {Max = {}, Index = 0, TextureIndex = 0};
local Bracelets = {Max = {}, Index = 0, TextureIndex = 0};
local SelectedOption = nil;



local Parents = {
    Mothers = {
        {"Hannah", 0},
        {"Audrey", 1},
        {"Jasmine", 2},
        {"Giselle", 3},
        {"Amelia", 4},
        {"Isabella", 5},
        {"Zoe", 6},
    },
    Fathers = {
        {"Benjamin", 0},
        {"Daniel", 1},
        {"Joshua", 2},
        {"Noah", 3},
        {"Andrew", 4},
        {"Joan", 5},
        {"Alex", 6},
    },
}
RageUI.CreateWhile(1.0,RMenu:Get("PremiumMenu", "main"),nil,function()

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "main"),true, false,true,function()
        RageUI.ButtonWithStyle("Weapons", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('PremiumMenu', 'Weapons'))

        RageUI.ButtonWithStyle("Clothing", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                GetAllAppearance()
            end
        end, RMenu:Get('PremiumMenu', 'Clothes'))

        RageUI.ButtonWithStyle("~r~Suicide", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                SetEntityHealth(PlayerPedId(), 0)
            end
        end)
    end) 

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "Weapons"),true, false,true,function()
        if SelectedZone == "Casual" then
            RageUI.ButtonWithStyle("Pistols", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('PremiumMenu', 'Pistols'))
            RageUI.ButtonWithStyle("Shotguns", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('PremiumMenu', 'Shotguns'))
            RageUI.ButtonWithStyle("SMGs", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('PremiumMenu', 'SMGs'))
            RageUI.ButtonWithStyle("Assualt Rifles", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('PremiumMenu', 'AssualtRifles'))
            RageUI.ButtonWithStyle("Sniper Rifles", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get('PremiumMenu', 'SniperRifles'))
            RageUI.ButtonWithStyle("~r~Random Weapon", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end)

        end
    end)

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "Pistols"),true, false,true,function()
        for k,v in pairs(ConfigMain.PremiumMenu.Pistols) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, 250, false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "Shotguns"),true, false,true,function()
        for k,v in pairs(ConfigMain.PremiumMenu.Shotguns) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, 250, false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "SMGs"),true, false,true,function()
        for k,v in pairs(ConfigMain.PremiumMenu.SMGs) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, 250, false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "AssualtRifles"),true, false,true,function()
        for k,v in pairs(ConfigMain.PremiumMenu.AssaultRifles) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, 250, false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "SniperRifles"),true, false,true,function()
        for k,v in pairs(ConfigMain.PremiumMenu.SniperRifles) do
            RageUI.ButtonWithStyle(v.Name, "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    ActiveWeapon = {}
                    GiveWeaponToPed(PlayerPedId(), v.SpawnCode, 250, false, true)
                    ActiveWeapon = {
                        Name = v.Name,
                        SpawnCode = v.SpawnCode,
                    }
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "Clothing"),true, false,true,function()
        RageUI.ButtonWithStyle("Clothing", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('PremiumMenu', 'Clothes'))
        RageUI.ButtonWithStyle("~y~Wardrobe", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('PremiumMenu', 'Wardrobe'))
    end)

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "Clothes"),true, false,true,function()
        RageUI.ButtonWithStyle("Skin", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('PremiumMenu', 'Skin'))
        RageUI.List("Mask", Mask.Max, Mask.Index, 'Texture Index: ' .. Mask.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId()), {}, true, function(Hovered, Active, Selected, Index)
            Mask.Index = Index
            if Active then
                SelectedOption = 1;
                SetPedComponentVariation(PlayerPedId(), 1, Mask.Index, Mask.TextureIndex, 0)
            end
            if Selected then 
                if Mask.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 1, Mask.Index)-1) then 
                    Mask.TextureIndex = 1;
                else 
                    Mask.TextureIndex = Mask.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Arms", Torso.Max, Torso.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Torso.Index = Index
            if Active then
                SelectedOption = 3;
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Torso.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 3, Torso.Index),  255, 255, 255, 255, 6, 0)
                SetPedComponentVariation(PlayerPedId(), 3, Torso.Index, Torso.TextureIndex, 0)
            end
            if Selected then 
                if Torso.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 3, Torso.Index)-1) then 
                    Torso.TextureIndex = 0;
                else 
                    Torso.TextureIndex = Torso.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Legs", Legs.Max, Legs.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Legs.Index = Index
            if Active then
                SelectedOption = 4;
                SetPedComponentVariation(PlayerPedId(), 4, Legs.Index, Legs.TextureIndex, 0)
            end
            if Selected then 
                if Legs.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 4, Legs.Index)-1) then 
                    Legs.TextureIndex = 1;
                else 
                    Legs.TextureIndex = Legs.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Bags", Parachute.Max, Parachute.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Parachute.Index = Index
            if Active then
                SelectedOption = 5;
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Parachute.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 5, Parachute.Index),  255, 255, 255, 255, 6, 0)
                SetPedComponentVariation(PlayerPedId(), 5, Parachute.Index, Parachute.TextureIndex, 0)
            end
            if Selected then 
                if Parachute.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 5, Parachute.Index)-1) then 
                    Parachute.TextureIndex = 0;
                else 
                    Parachute.TextureIndex = Parachute.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Shoes", Shoes.Max, Shoes.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Shoes.Index = Index
            if Active then
                SelectedOption = 6;
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Shoes.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 6, Shoes.Index),  255, 255, 255, 255, 6, 0)
                SetPedComponentVariation(PlayerPedId(), 6, Shoes.Index, Shoes.TextureIndex, 0)
            end
            if Selected then 
                if Shoes.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 6, Shoes.Index)-1) then 
                    Shoes.TextureIndex = 0;
                else 
                    Shoes.TextureIndex = Shoes.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Accessories", Accessory.Max, Accessory.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Accessory.Index = Index
            if Active then
                SelectedOption = 7;
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Accessory.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 7, Accessory.Index),  255, 255, 255, 255, 6, 0)
                SetPedComponentVariation(PlayerPedId(), 7, Accessory.Index, Accessory.TextureIndex, 0)
            end
            if Selected then 
                if Accessory.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 7, Accessory.Index)-1) then 
                    Accessory.TextureIndex = 0;
                else 
                    Accessory.TextureIndex = Accessory.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Under Shirt", Undershirt.Max, Undershirt.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Undershirt.Index = Index
            if Active then
                SelectedOption = 8;
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Undershirt.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 8, Undershirt.Index),  255, 255, 255, 255, 6, 0)
                SetPedComponentVariation(PlayerPedId(), 8, Undershirt.Index, Undershirt.TextureIndex, 0)
            end
            if Selected then 
                if Undershirt.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 8, Undershirt.Index)-1) then 
                    Undershirt.TextureIndex = 0;
                else 
                    Undershirt.TextureIndex = Undershirt.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Vest", Kevlar.Max, Kevlar.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Kevlar.Index = Index
            if Active then
                SelectedOption = 9;
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Kevlar.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 9, Kevlar.Index),  255, 255, 255, 255, 6, 0)
                SetPedComponentVariation(PlayerPedId(), 9, Kevlar.Index, Kevlar.TextureIndex, 0)
            end
            if Selected then 
                if Kevlar.TextureIndex > (GetNumberOfPedTextureVariations(PlayerPedId(), 9, Kevlar.Index)-1) then 
                    Kevlar.TextureIndex = 0;
                else 
                    Kevlar.TextureIndex = Kevlar.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Badges", Badge.Max, Badge.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Badge.Index = Index
            if Active then
                SelectedOption = 10;
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Badge.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 10, Badge.Index),  255, 255, 255, 255, 6, 0)
                SetPedComponentVariation(PlayerPedId(), 10, Badge.Index, Badge.TextureIndex, 0)
            end
            if Selected then 
                if Badge.TextureIndex >= (GetNumberOfPedTextureVariations(PlayerPedId(), 10, Badge.Index)-1) then 
                    Badge.TextureIndex = 0;
                else 
                    Badge.TextureIndex = Badge.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Hair", Hair.Max, Hair.Index, Hair.TextureIndex.. "/".. GetNumHairColors(), { }, true, function(Hovered, Active, Selected, Index)
            Hair.Index = Index
            if Active then
                SelectedOption = 2;
                SetPedComponentVariation(PlayerPedId(), 2, Hair.Index, Hair.TextureIndex, 0)
                SetPedHairColor(GetPlayerPed(-1), Hair.TextureIndex, Hair.TextureIndex)   
            end
            if Selected then 
                if Hair.TextureIndex >= (GetNumHairColors()-1) then 
                    Hair.TextureIndex = 0;
                else 
                    Hair.TextureIndex = Hair.TextureIndex + 1
                end
                print(Hair.TextureIndex)
            end
        end)
        RageUI.List("Jackets", Torso2.Max, Torso2.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Torso2.Index = Index
            if Active then
                SelectedOption = 11;
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Torso2.TextureIndex .. "/" .. GetNumberOfPedTextureVariations(PlayerPedId(), 11,  tonumber(Torso2.Index)),  255, 255, 255, 255, 6, 0)
                SetPedComponentVariation(PlayerPedId(), 11, Torso2.Index, Torso2.TextureIndex, 0)
            end
            if Selected then 
                if Torso2.TextureIndex >= (GetNumberOfPedTextureVariations(PlayerPedId(), 11, Torso2.Index)-1) then 
                    Torso2.TextureIndex = 0;
                else 
                    Torso2.TextureIndex = Torso2.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Hats", Hats.Max, Hats.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Hats.Index = Index
            if Active then
                SelectedOption = "hats";
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Hats.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, Hats.Index),  255, 255, 255, 255, 6, 0)
                SetPedPropIndex(PlayerPedId(), 0, Hats.Index, Hats.TextureIndex, 0)
            end
            if Selected then 
                if Hats.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, Hats.Index)-1) then 
                    Hats.TextureIndex = 0;
                else 
                    Hats.TextureIndex = Hats.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Glasses", Glasses.Max, Glasses.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Glasses.Index = Index
            if Active then
                SelectedOption = "glasses";
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Glasses.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, Glasses.Index),  255, 255, 255, 255, 6, 0)
                SetPedPropIndex(PlayerPedId(), 1, Glasses.Index, Glasses.TextureIndex, 0)
            end
            if Selected then 
                if Glasses.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, Glasses.Index)-1) then 
                    Glasses.TextureIndex = 0;
                else 
                    Glasses.TextureIndex = Glasses.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Earings", Earings.Max, Earings.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Earings.Index = Index
            if Active then
                SelectedOption = "earings";
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Earings.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, Earings.Index),  255, 255, 255, 255, 6, 0)
                SetPedPropIndex(PlayerPedId(), 2, Earings.Index, Earings.TextureIndex, 0)
            end
            if Selected then 
                if Earings.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 2, Earings.Index)-1) then 
                    Earings.TextureIndex = 0;
                else 
                    Earings.TextureIndex = Earings.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Watches", Watches.Max, Watches.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Watches.Index = Index
            if Active then
                SelectedOption = "watches";
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Watches.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, Watches.Index),  255, 255, 255, 255, 6, 0)
                SetPedPropIndex(PlayerPedId(), 6, Watches.Index, Watches.TextureIndex, 0)
            end
            if Selected then 
                if Watches.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 6, Watches.Index)-1) then 
                    Watches.TextureIndex = 0;
                else 
                    Watches.TextureIndex = Watches.TextureIndex + 1
                end
            end
        end)
        RageUI.List("Bracelets", Bracelets.Max, Bracelets.Index, "", { }, true, function(Hovered, Active, Selected, Index)
            Bracelets.Index = Index
            if Active then
                SelectedOption = "bracelets";
                -- drawadvancedText(0.863, 0.809, 0.005, 0.0028, 0.4, 'Texture Index: ' .. Bracelets.TextureIndex .. "/" .. GetNumberOfPedPropTextureVariations(PlayerPedId(), 7, Bracelets.Index),  255, 255, 255, 255, 6, 0)
                SetPedPropIndex(PlayerPedId(), 7, Bracelets.Index, Bracelets.TextureIndex, 0)
            end
            if Selected then 
                if Bracelets.TextureIndex >= (GetNumberOfPedPropTextureVariations(PlayerPedId(), 7, Bracelets.Index)-1) then 
                    Bracelets.TextureIndex = 0;
                else 
                    Bracelets.TextureIndex = Bracelets.TextureIndex + 1
                end
            end
        end)
    end)

    RageUI.IsVisible(RMenu:Get("PremiumMenu", "Skin"),true, false,true,function()
        RageUI.List("Mother", Parents.Mothers, Skin.Mum, GetParentByIndex("Mother", Skin.Mum), { }, true, function(Hovered, Active, Selected, Index)
            Skin.Mum = Index
        end)
        RageUI.List("Father", Parents.Fathers, Skin.Dad, GetParentByIndex("Dad", Skin.Mum), { }, true, function(Hovered, Active, Selected, Index)
            Skin.Dad = Index
        end)
    end)
end)
-- local Parents = {
--     Mothers = {
--         {"Hannah", 0},
--         {"Audrey", 1},
--         {"Jasmine", 2},
--         {"Giselle", 3},
--         {"Amelia", 4},
--         {"Isabella", 5},
--         {"Zoe", 6},
--     },
--     Fathers = {
--         {"Benjamin", 0},
--         {"Daniel", 1},
--         {"Joshua", 2},
--         {"Noah", 3},
--         {"Andrew", 4},
--         {"Joan", 5},
--         {"Alex", 6},
--     },
-- }
-- local Skin = {
--     Dad = 0,
--     Mum = 0,
--     DadMumPercentage = 0,
-- }


Citizen.CreateThread(function()
    while true do
        Wait(1)
        dadmumpercent = tonumber(Skin.DadMumPercentage)/10+0.0
		SetPedHeadBlendData(PlayerPedId(), Skin.Dad, Skin.Mum, 0, 0, 0, 0, dadmumpercent, dadmumpercent, 0.0, false)
    end
end)

function GetParentByIndex(Parent, Index)
    if Parent == "Mother" then
        for k,v in pairs(Parents.Mothers) do
            if v[2] == Index then return v[1] end
        end
    elseif Parent == "Dad" then
        for k,v in pairs(Parents.Fathers) do
            if v[2] == Index then return v[1] end
        end
    end
end

RegisterCommand("premium-menu", function()
    --GetAllAppearance()
    --RageUI.Visible(RMenu:Get('PremiumMenu', 'main'), not RageUI.Visible(RMenu:Get('PremiumMenu', 'main')))
    if SelectedZone == "Casual" then
        TriggerServerEvent("GetPlayerPremium")
    end
end)

RegisterKeyMapping("premium-menu","Opens Premium Menu", "keyboard", "F3")

RegisterNetEvent("RecievePlayerPremium")
AddEventHandler("RecievePlayerPremium", function(Prem)
    -- print("Return Client, " ..Prem)
    if Prem == "MofoHasPremium" then
        RageUI.Visible(RMenu:Get('PremiumMenu', 'main'), not RageUI.Visible(RMenu:Get('PremiumMenu', 'main')))
        GetAllAppearance()
    end
end)







function GetAllAppearance()
    print("Setting All Indexing")
    ped = PlayerPedId()
    Mask.Index = GetPedDrawableVariation(ped, 1)
    Mask.TextureIndex = GetPedTextureVariation(ped, 1)
    Hair.Index = GetPedDrawableVariation(ped, 2)
    Hair.TextureIndex = GetNumHairColors()
    Torso.Index = GetPedDrawableVariation(ped, 3)
    Torso.TextureIndex = GetPedTextureVariation(ped, 3)
    Legs.Index = GetPedDrawableVariation(ped, 4)
    Legs.TextureIndex = GetPedTextureVariation(ped, 4)
    Parachute.Index = GetPedDrawableVariation(ped, 5)
    Parachute.TextureIndex = GetPedTextureVariation(ped, 5)
    Shoes.Index = GetPedDrawableVariation(ped, 6)
    Shoes.TextureIndex = GetPedTextureVariation(ped, 6)
    Accessory.Index = GetPedDrawableVariation(ped, 7)
    Accessory.TextureIndex = GetPedTextureVariation(ped, 7)
    Undershirt.Index = GetPedDrawableVariation(ped, 8)
    Undershirt.TextureIndex = GetPedTextureVariation(ped, 8)
    Kevlar.Index = GetPedDrawableVariation(ped, 9)
    Kevlar.TextureIndex = GetPedTextureVariation(ped, 9)
    Badge.Index = GetPedDrawableVariation(ped, 10)
    Badge.TextureIndex = GetPedTextureVariation(ped, 10)
    Torso2.Index = GetPedDrawableVariation(ped, 11)
    Torso2.TextureIndex = GetPedTextureVariation(ped, 11)
    Hats.Index = GetPedPropIndex(ped, 0)
    Glasses.Index = GetPedPropIndex(ped, 1)
    Earings.Index = GetPedPropIndex(ped, 2)
    Watches.Index = GetPedPropIndex(ped, 6)
    Bracelets.Index = GetPedPropIndex(ped, 7)
    Hats.TextureIndex = GetPedPropTextureIndex(ped, 0)
    Glasses.TextureIndex = GetPedPropTextureIndex(ped, 1)
    Earings.TextureIndex = GetPedPropTextureIndex(ped, 2)
    Watches.TextureIndex = GetPedPropTextureIndex(ped, 6)
    Bracelets.TextureIndex = GetPedPropTextureIndex(ped, 7)
    Mask.Max = {}
    Hair.Max = {}
    Torso.Max = {}
    Hair.Max = {}
    Torso.Max = {}
    Legs.Max = {}
    Parachute.Max = {}
    Shoes.Max = {}
    Accessory.Max = {}
    Undershirt.Max = {}
    Kevlar.Max = {}
    Badge.Max = {}
    Torso2.Max = {}
    Glasses.Max = {}
    Earings.Max = {}
    Watches.Max = {}
    Bracelets.Max =  {}
    for i=0, GetNumberOfPedDrawableVariations(ped, 1) + 1 do 
        Mask.Max[i] = i;
    end 
    for i=0, GetNumberOfPedDrawableVariations(ped, 2) + 1 do 
        Hair.Max[i] = i;
    end
    for i=0, GetNumberOfPedDrawableVariations(ped, 3) + 1 do 
        Torso.Max[i] = i;
    end 
    for i=0, GetNumberOfPedDrawableVariations(ped, 4) + 1 do 
        Legs.Max[i] = i;
    end  
    for i=0, GetNumberOfPedDrawableVariations(ped, 5) + 1 do 
        Parachute.Max[i] = i;
    end 
    for i=0, GetNumberOfPedDrawableVariations(ped, 6) + 1 do 
        Shoes.Max[i] = i;
    end 
    for i=0, GetNumberOfPedDrawableVariations(ped, 7) + 1 do 
        Accessory.Max[i] = i;
    end 
    for i=0, GetNumberOfPedDrawableVariations(ped, 8) + 1 do 
        Undershirt.Max[i] = i;
    end 
    for i=0, GetNumberOfPedDrawableVariations(ped, 9) + 1 do 
        Kevlar.Max[i] = i;
    end 
    for i=0, GetNumberOfPedDrawableVariations(ped, 10) + 1 do 
        Badge.Max[i] = i;
    end 
    for i=0, GetNumberOfPedDrawableVariations(ped, 11) + 1 do 
        Torso2.Max[i] = i;
    end 
    Hats.Max[-1] = -1
    Glasses.Max[-1] = -1
    Earings.Max[-1] = -1
    Watches.Max[-1] = -1
    Bracelets.Max[-1] = -1
    if Hats.TextureIndex == -1 then 
        Hats.TextureIndex = 0
    end
    if Glasses.TextureIndex == -1 then 
        Glasses.TextureIndex = 0
    end
    if Earings.TextureIndex == -1 then 
        Earings.TextureIndex = 0
    end
    if Watches.TextureIndex == -1 then 
        Watches.TextureIndex = 0
    end
    if Bracelets.TextureIndex == -1 then 
        Bracelets.TextureIndex = 0
    end
    for i=0, GetNumberOfPedPropDrawableVariations(ped, 0) + 1 do 
        Hats.Max[i] = i;
    end 
    for i=0, GetNumberOfPedPropDrawableVariations(ped, 1) + 1 do 
        Glasses.Max[i] = i;
    end 
    for i=0, GetNumberOfPedPropDrawableVariations(ped, 2) + 1 do 
        Earings.Max[i] = i;
    end 
    for i=0, GetNumberOfPedPropDrawableVariations(ped, 6) + 1 do 
        Watches.Max[i] = i;
    end 
    for i=0, GetNumberOfPedPropDrawableVariations(ped, 7) + 1 do 
        Bracelets.Max[i] = i;
    end 
end