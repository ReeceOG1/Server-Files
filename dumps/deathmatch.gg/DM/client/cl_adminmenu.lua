RMenu.Add('AdminMenu', 'main', RageUI.CreateMenu("", "~b~DM - Administration", 1300,100, "", ""))
RMenu.Add('AdminMenu', 'allplayers',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "main")))
RMenu.Add('AdminMenu', 'searchplayers',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "main")))
RMenu.Add('AdminMenu', 'searchedPlayers',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "searchplayers")))
RMenu.Add('AdminMenu', 'search_History',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "searchplayers")))
RMenu.Add('AdminMenu', 'playeroptionsOffline',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "search_History")))
RMenu.Add('AdminMenu', 'functions',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "main")))
RMenu.Add('AdminMenu', 'updatechattag',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "functions")))
RMenu.Add('AdminMenu', 'updatechattag2',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "updatechattag")))
RMenu.Add('AdminMenu', 'presetChattag',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "updatechattag")))
RMenu.Add('AdminMenu', 'playeroptions',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "main")))
RMenu.Add('AdminMenu', 'groups',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "playeroptions")))
RMenu.Add('AdminMenu', 'BanReasons',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "playeroptions")))
RMenu.Add('AdminMenu', 'generatingban',  RageUI.CreateSubMenu(RMenu:Get("AdminMenu", "BanReasons")))


PlayerList = {}
SelectedPlayer = nil
PlayerGroups = {}
PlayerSearchHistory = {}
AdminL = 0
chatTagSelPermID = 0
offlinePlayerSelected = nil
searchPlayerOpt = {}
banDataAdmin        = nil
banDataDuration     = nil
banDatabanMessage   = nil
banDataSeperator    = nil
returnedBanning     = false
groupIndex = {
    ["Founder"] = {"Founder", 2},
    ["Staff"] = {"Staff", 2},
    ["Noclip"] = {"No Clip", 2},
    ["Premium"] = {"Premium", 2},
    ["Pov"] = {"Pov List", 1},
}

chatTag_Index = {
    {"~r~Founder", "^1Founder"},
    {"~b~Staff","^5Staff"},
    {"~p~Premium", "^8Premium"},
    
    {"Widow", "^9^*Widow^r"},
}

local SBIDs = {}
local banReasons = {
    {
        id = "banevading",
        banName = "Ban Evading",
        bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A",
        itemchecked = false,
    },
    {
        id = "cheating",
        banName = "Cheating",
        bandescription = "1st offense: Permanent\n2nd offense: N/A\n3rd offense: N/A",
        itemchecked = false,
    },
    {
        id = "toxicity",
        banName = "Toxicity",
        bandescription = "1st offense: 24 Hours\n2nd offense: 48 Hours\n3rd offense: 72 Hours",
        itemchecked = false,
    },
    {
        id = "racism",
        banName = "Racism",
        bandescription = "1st offense: 168 Hours\n2nd offense: Permanent\n3rd offense: Permanent",
        itemchecked = false,
    },
    {
        id = "homophobia",
        banName = "Homophobia",
        bandescription = "1st offense: 168 Hours\n2nd offense: Permanent\n3rd offense: Permanent",
        itemchecked = false,
    },
    {
        id = "griefing",
        banName = "Griefing",
        bandescription = "~y~Only Applied for Redzone Wagers\n1st offense: 72 Hours\n2nd offense: 168 Hours\n3rd offense: Permanent",
        itemchecked = false,
    },
    {
        id = "scamming",
        banName = "Scamming",
        bandescription = "~y~Only Applied for Redzone Wagers\n1st offense: 168 Hours\n2nd offense: Permanent\n3rd offense: Permanent",
        itemchecked = false,
    },
}

RageUI.CreateWhile(1.0,RMenu:Get("AdminMenu", "main"),nil,function()
    RageUI.IsVisible(RMenu:Get("AdminMenu", "main"),true, false,true,function()

        RageUI.ButtonWithStyle("All Players", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('AdminMenu', 'allplayers'))

        RageUI.ButtonWithStyle("Search Players", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('AdminMenu', 'searchplayers'))

        RageUI.ButtonWithStyle("Functions", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('AdminMenu', 'functions'))

    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "allplayers"),true, false,true,function()
        for k,v in pairs(PlayerList) do
            RageUI.ButtonWithStyle(v[3].. " ["..v[1].."]", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    SelectedPlayer = k
                end
            end, RMenu:Get('AdminMenu', 'playeroptions'))
        end
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "playeroptions"),true, false,true,function()
        RageUI.Separator("", function() end)

        RageUI.ButtonWithStyle("Kick Player", "To Be Done....", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                local Message = KeyboardInput("Kick Reason", "", 25)
                if Message ~= nil or Message ~= "" or Message ~= " " then
                    TriggerServerEvent("DM:KickPlayer", SelectedPlayer, Message)
                end
            end
        end, RMenu:Get('AdminMenu', 'main'))

        RageUI.ButtonWithStyle("Ban Player", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                banDataRequired = {}
            end
        end, RMenu:Get('AdminMenu', 'BanReasons'))

        RageUI.ButtonWithStyle("Teleport To Player", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("DM:GoToPlayer", SelectedPlayer)
            end
        end)

        RageUI.ButtonWithStyle("Teleport To Me", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("DM:BringPlayer", SelectedPlayer)
            end
        end)

        RageUI.ButtonWithStyle("Teleport To Admin Zone", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("DM:PlayerAdminZone", SelectedPlayer)
            end
        end)

        RageUI.ButtonWithStyle("Slap Player", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("DM:Slap", SelectedPlayer)
            end
        end)

        if AdminL >= 1 then
            RageUI.ButtonWithStyle("See Groups", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("DM:RequestGroups", SelectedPlayer)
                end
            end, RMenu:Get('AdminMenu', 'groups'))
        end
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "groups"),true, false,true,function()
        for k,v in pairs(groupIndex) do 
            if PlayerGroups[k] then
                RageUI.ButtonWithStyle("~g~"..v[1], "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if AdminL >= v[2] then
                            TriggerServerEvent("DM:PlayerGroup", SelectedPlayer, k, "-")
                            TriggerServerEvent("DM:RequestGroups", SelectedPlayer)
                        end
                    end
                end)
            else
                RageUI.ButtonWithStyle("~r~"..v[1], "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if AdminL >= v[2] then
                            TriggerServerEvent("DM:PlayerGroup", SelectedPlayer, k, "+")
                            TriggerServerEvent("DM:RequestGroups", SelectedPlayer)
                        end
                        
                    end
                end)
            end
        end
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "BanReasons"),true, false,true,function()
        for k, v in pairs(banReasons) do
            local function SelectedTrue()
                SBIDs[v.id] = true
            end
            local function SelectedFalse()
                SBIDs[v.id] = nil
            end
            RageUI.Checkbox(v.banName, v.bandescription, v.itemchecked, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                if Selected then
                    if v.itemchecked then
                        SelectedTrue()
                    end
                    if not v.itemchecked then
                        SelectedFalse()
                    end
                end
                v.itemchecked = Checked
            end)
        end

        RageUI.ButtonWithStyle("Create Ban Data", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                returnedBanning = false
                TriggerServerEvent("DM:GenerateBan", SelectedPlayer, SBIDs)
            end
        end, RMenu:Get('AdminMenu', 'generatingban'))

        RageUI.ButtonWithStyle("Cancel Ban", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('AdminMenu', 'playeroptions'))
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "generatingban"), true, false, true,function()
        if not returnedBanning then
            RageUI.Separator("~r~Creating ban data for " ..PlayerList[SelectedPlayer][3], function() end)
            RageUI.Separator("~y~Warning: If ban data hasn't been generated, regenerate ban.", function() end)
        else
            RageUI.Separator("~r~You are about to ban " ..PlayerList[SelectedPlayer][3].. " for the following", function() end)
            for k,v in pairs(banDataSeperator) do
                RageUI.Separator(v, function() end)
            end
            if banDataDuration ~= "-1" or banDataDuration ~= -1 then
                RageUI.Separator("~y~Total Duration: ~w~" ..banDataDuration.. " Hours", function() end)
            else
                RageUI.Separator("~y~Total Duration: ~w~Permanent", function() end)
            end
            RageUI.ButtonWithStyle("Confirm Ban", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("DM:PlayerBan", SelectedPlayer, banDataDuration,  banDatabanMessage)
                    returnedBanning = false
                end
            end, RMenu:Get('AdminMenu', 'generatingban'))
        end
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "searchplayers"),true, false,true,function()
        RageUI.ButtonWithStyle("Search PermID", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                local PermID = KeyboardInput("Enter PermID", "", 25)
                if PermID ~= nil or PermID ~= "" or PermID ~= " " and PermID > 0 then
                    searchPlayerOpt[1] = {"PermID", PermID}
                else
                    Draw_Native_Notify("~r~Invalid UserID")
                end
            end
        end, RMenu:Get('AdminMenu', 'searchedPlayers'))
        RageUI.ButtonWithStyle("Search TempID", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                local TempID = KeyboardInput("Enter TempID", "", 25)
                if TempID ~= nil or TempID ~= "" or TempID ~= " " and TempID > 0 then
                    searchPlayerOpt[1] = {"TempID", TempID}
                else
                    Draw_Native_Notify("~r~Invalid TempID")
                end
            end
        end, RMenu:Get('AdminMenu', 'searchedPlayers'))
        RageUI.ButtonWithStyle("Search Name", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                local Name = KeyboardInput("Enter Name", "", 25)
                if Name ~= nil or Name ~= "" or Name ~= " " and Name > 0 then
                    searchPlayerOpt[1] = {"Name", Name}
                else
                    Draw_Native_Notify("~r~Invalid TempID")
                end
            end
        end, RMenu:Get('AdminMenu', 'searchedPlayers'))
        RageUI.ButtonWithStyle("Search History", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
        end, RMenu:Get('AdminMenu', 'search_History'))
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "searchedPlayers"),true, false,true,function()
        if searchPlayerOpt[1][1] == "PermID" then
            for k, v in pairs(PlayerList) do
                if searchPlayerOpt[1][2] ~= 0 then
                    if string.match(v[2], searchPlayerOpt[1][2]) then
                        RageUI.ButtonWithStyle(v[3].. " ["..v[1].."]", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = k
                                PlayerSearchHistory[k] = {v[1], v[2], v[3]}
                            end
                        end, RMenu:Get('AdminMenu', 'playeroptions'))
                    end
                end
            end
        elseif searchPlayerOpt[1][1] == "TempID" then
            for k, v in pairs(PlayerList) do
                if searchPlayerOpt[1][2] ~= 0 then
                    if string.match(v[1], searchPlayerOpt[1][2]) then
                        RageUI.ButtonWithStyle(v[3].. " ["..v[1].."]", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = k
                                PlayerSearchHistory[k] = {v[1], v[2], v[3]}
                            end
                        end, RMenu:Get('AdminMenu', 'playeroptions'))
                    end
                end
            end
        elseif searchPlayerOpt[1][1] == "Name" then
            for k, v in pairs(PlayerList) do
                if searchPlayerOpt[1][2] ~= nil then
                    if string.match(string.lower(v[3]), string.lower(searchPlayerOpt[1][2])) then
                        RageUI.ButtonWithStyle(v[3].. " ["..v[1].."]", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                SelectedPlayer = k
                                PlayerSearchHistory[k] = {v[1], v[2], v[3]}
                            end
                        end, RMenu:Get('AdminMenu', 'playeroptions'))
                    end
                end
            end
        end
    end)
    
    RageUI.IsVisible(RMenu:Get("AdminMenu", "search_History"),true, false,true,function()
        for k, v in pairs(PlayerSearchHistory) do
            if PlayerList[k] then
                RageUI.ButtonWithStyle("~g~Online~w~ | "..v[3].. " ["..v[1].."]", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SelectedPlayer = k
                    end
                end, RMenu:Get('AdminMenu', 'playeroptions'))
            else
                RageUI.ButtonWithStyle("~r~Offline~w~ | "..v[3].. " ["..v[1].."]", "", {RightLabel = ""}, true, function(Hovered, Active, Selected) 
                    if Selected then
                        offlinePlayerSelected = k
                    end
                end, RMenu:Get('AdminMenu', 'playeroptionsOffline'))
            end
        end
        RageUI.ButtonWithStyle("~r~Clear History", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                if PlayerSearchHistory then
                    PlayerSearchHistory = {}
                    Draw_Native_Notify("~r~History Cleared")
                else
                    RageUI.Separator("~g~There is nothing here to clear", function() end)
                end
            end
        end)
    end)
    
    RageUI.IsVisible(RMenu:Get("AdminMenu", "playeroptionsOffline"),true, false,true,function()
        RageUI.ButtonWithStyle("Offline Ban", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                local Reason = KeyboardInput("Enter Reason", "", 25)
                if Reason ~= nil or Reason ~= "" or Reason ~= " " then
                    local Duration = KeyboardInput("Enter Duration", "", 25)
                    if Duration ~= nil or Duration ~= "" or Duration ~= " " then
                        TriggerServerEvent("DM:OfflineBan", offlinePlayerSelected, Reason, Duration)
                    end
                end
            end
        end)
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "functions"),true, false,true,function()
        RageUI.ButtonWithStyle("Offline Ban", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                if Selected then
                    local PermID = KeyboardInput("Enter PermID", "", 25)
                    if PermID ~= nil or PermID ~= "" or PermID ~= " " and PermID > 0 then
                        local Reason = KeyboardInput("Enter Reason", "", 25)
                        if Reason ~= nil or Reason ~= "" or Reason ~= " " then
                            local Duration = KeyboardInput("Enter Duration", "", 25)
                            if Duration ~= nil or Duration ~= "" or Duration ~= " " then
                                TriggerServerEvent("DM:OfflineBan", PermID, Reason, Duration)
                            end
                        end
                    end
                end
            end
        end)
        RageUI.ButtonWithStyle("Unban", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                local PermID = KeyboardInput("Enter PermID", "", 25)
                if PermID ~= nil or PermID ~= "" or PermID ~= " " and PermID > 0 then
                    TriggerServerEvent("DM:Unban", PermID)
                end
            end
        end)

        if AdminL >= 2 then
            RageUI.ButtonWithStyle("Update Chat Tag", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    chatTagSelPermID = 0
                end
            end, RMenu:Get('AdminMenu', 'updatechattag'))
            RageUI.ButtonWithStyle("~p~Add Premium", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local PermID = KeyboardInput("Enter PermID", "", 25)
                    if PermID ~= nil or PermID ~= "" or PermID ~= " " and PermID > 0 then
                        local Duration = KeyboardInput("Enter Duration", "", 25)
                        if Duration ~= nil or Duration ~= "" or Duration ~= " " then
                            TriggerServerEvent("DM:AddPremium", PermID, Duration)
                        end
                    end
                end
            end)
            RageUI.ButtonWithStyle("~p~Remove Premium", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local PermID = KeyboardInput("Enter PermID", "", 25)
                    if PermID ~= nil or PermID ~= "" or PermID ~= " " and PermID > 0 then
                        TriggerServerEvent("DM:RemovePremium", PermID)
                    end
                end
            end)
            RageUI.ButtonWithStyle("~r~Spawn Weapon", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local Spawncode = KeyboardInput("Enter Spawncode", "", 25)
                    if Spawncode ~= nil or Spawncode ~= "" or Spawncode ~= " " then
                        GiveWeaponToPed(PlayerPedId(), Spawncode, 250, false, true)
                    end
                end
            end)
        end
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "updatechattag"),true, false,true,function()
        RageUI.Separator("PermID: " ..chatTagSelPermID, function() end)
        RageUI.Separator("", function() end)


        RageUI.ButtonWithStyle("~g~Enter PermID", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                local PermID = KeyboardInput("Enter PermID", "", 25)
                if PermID ~= nil or PermID ~= "" or PermID ~= " " and PermID > 0 then
                    chatTagSelPermID = PermID
                end
            end
        end)

        RageUI.ButtonWithStyle("~g~Update Chat Tag", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
            end
        end, RMenu:Get('AdminMenu', 'updatechattag2'))

        RageUI.ButtonWithStyle("~r~Remove Chat Tag", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("DM:UpdateChatTag", chatTagSelPermID, "REMOVE CHAT TAG")
            end
        end)
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "updatechattag2"),true, false,true,function()
        RageUI.Separator("PermID: " ..chatTagSelPermID, function() end)
        RageUI.Separator("", function() end)

        RageUI.ButtonWithStyle("~g~Preset Chat Tags", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
            end
        end, RMenu:Get('AdminMenu', 'presetChattag'))

        RageUI.ButtonWithStyle("~g~Custom Chat Tag", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
            if Selected then
                local Chattag = KeyboardInput("Enter Chat Tag", "", 25)
                if Chattag ~= nil or Chattag ~= "" or Chattag ~= " " then
                    TriggerServerEvent("DM:UpdateChatTag", chatTagSelPermID, Chattag)
                end
            end
        end)
    end)

    RageUI.IsVisible(RMenu:Get("AdminMenu", "presetChattag"),true, false,true,function()
        RageUI.Separator("PermID: " ..chatTagSelPermID, function() end)
        RageUI.Separator("", function() end)

        for k,v in pairs(chatTag_Index) do
            RageUI.ButtonWithStyle(v[1], "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("DM:UpdateChatTag", chatTagSelPermID, v[2])
                end
            end)
        end
    end)
end)


function DMclient.SendRequest(Groups)
    PlayerGroups = Groups
end

RegisterCommand("admin-menu", function()
    TriggerServerEvent("DM:RequestPlayers")
end)

RegisterKeyMapping("admin-menu","Opens DM - Administration", "keyboard", "F2")

function DMclient.SendPlayerInfo(Players, AdminLvL)
    print(Players, AdminLvL)
    AdminL = AdminLvL
    if AdminLvL > 0 then
        PlayerList = Players
        RageUI.Visible(RMenu:Get('AdminMenu', 'main'), not RageUI.Visible(RMenu:Get('AdminMenu', 'main')))
    end
end

function DMclient.sendPlayerBanData(adminName, banDuration, banMessage, seperatorSettin)
    banDataAdmin        = adminName
    banDataDuration     = banDuration
    banDatabanMessage   = banMessage
    banDataSeperator    = seperatorSettin
    returnedBanning     = true
end