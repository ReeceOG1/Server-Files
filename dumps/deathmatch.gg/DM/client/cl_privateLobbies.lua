-- local returnedLobbies = {
--     -- -- ["PermID"] = {
--     --     "Name", 
--     --     "Password", 
--     --     "Bucket", 
--     --     ""
--     --     ["OwnerTable"] = {Name, PermID, Source}
--     --      
--     -- }
-- } 

-- local currentLobby = nil 
-- --[[ 
--     CurrentLobby = {
--         "Name"
--         "Index"
--         "Location"
--         ["OwnerTable"]
--         ["Players"]
--         ["BanList"]
--     }
-- ]]
-- local selectedLobby = nil
-- local lobbyCreation = {
--     ["Name"] = "N/A",
--     ["Password"] = "N/A",
--     ["Location"] = "N/A",
-- }

-- local PrvLocations = {
--     ["LSD North"] = {
--         {1381.047, 4286.697, 36.4719},
--         {1367.061, 4384.743, 44.33835},
--         {1389.246, 4359.652, 42.8476},
--         {1274.423, 4377.098, 47.44622},
--         {1297.435, 4303.796, 37.00053},
--         {1353.218, 4355.316, 43.75933},
--         {1341.454, 4387.35, 44.3438},
--         {1306.116, 4375.59, 47.67176},
--         {1265.752, 4312.614, 32.34309}, 
--     },
--     ["Oil Rig"] = {
--         {-1724.853, 8889.377, 13.76496},
--         {-1704.827, 8870.96, 27.36192},
--         {-1685.034, 8877.664, 27.34559},
--         {-1706.022, 8862.598, 19.74932},
--         {-1688.025, 8890.083, 19.87496},
--         {-1727.846, 8893.126, 19.90699},
--         {-1730.095, 8873.619, 21.71975},
--         {-1684.004, 8886.047, 13.751061},
--         {-1698.292, 8875.55, 19.86008},
--     },

-- }



-- RMenu.Add('PrvLobbies', 'main', RageUI.CreateMenu("", "~b~DM - Private Lobby Manager", 1300,100, "", ""))
-- RMenu.Add('PrvLobbies', 'createLobby',  RageUI.CreateSubMenu(RMenu:Get("PrvLobbies", "main")))
-- RMenu.Add('PrvLobbies', 'createLobbyLocations',  RageUI.CreateSubMenu(RMenu:Get("PrvLobbies", "createLobby")))
-- RMenu.Add('PrvLobbies', 'selectedLobby',  RageUI.CreateSubMenu(RMenu:Get("PrvLobbies", "main")))
-- RMenu.Add('PrvLobbies', 'selectedLobbyPlayers',  RageUI.CreateSubMenu(RMenu:Get("PrvLobbies", "selectedLobby")))

-- RageUI.CreateWhile(1.0,RMenu:Get("PrvLobbies", "main"),nil,function()
--     RageUI.IsVisible(RMenu:Get("PrvLobbies", "main"),true, false,true,function()
--         if currentLobby == nil then
--             for k, v in pairs(returnedLobbies) do 
--                 RageUI.ButtonWithStyle(v[1].." ~g~["..v[4].."]", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--                     if Selected then
--                         selectedLobby = k
--                     end
--                 end, RMenu:Get('PrvLobbies', 'selectedLobby'))
--             end
--         else
--             RageUI.Separator("~y~You must leave your current lobby to join another", function() end)
--             currentLobby["OwnerTable"] = returnedLobbies[selectedLobby]["OwnerTable"]
--             currentLobby["Players"] = returnedLobbies[selectedLobby]["Players"]
--             currentLobby["BanList"] = returnedLobbies[selectedLobby]["BanList"]
--         end

--         if currentLobby == nil then
--             RageUI.ButtonWithStyle("~g~Create Lobby", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--                 if Selected then
--                 end
--             end, RMenu:Get('PrvLobbies', 'createLobby'))
--         end

--         if currentLobby ~= nil then
--             if currentLobby["OwnerTable"][2] == GetPlayerName(PlayerPedId()) then
--                 RageUI.ButtonWithStyle("~r~Disband Lobby", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--                     if Selected then

--                     end
--                 end)
--             else
--                 RageUI.ButtonWithStyle("~r~Leave Lobby", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--                     if Selected then
--                         TriggerServerEvent("DM:LeavePrvLobby", selected)
--                         currentLobby = nil
--                         selectedLobby = nil
--                     end
--                 end)
--             end
--         end

--         if currentLobby ~= nil then
--             if currentLobby["OwnerTable"][2] == GetPlayerName(PlayerPedId()) then
--                 RageUI.ButtonWithStyle("Admin Panel", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--                     if Selected then
                        
--                     end
--                 end)
--             end
--         end
--     end)

--     RageUI.IsVisible(RMenu:Get("PrvLobbies", "selectedLobby"),true, false,true,function()
--         RageUI.Separator("Lobby Name: " ..returnedLobbies[selectedLobby][1], function() end)
--         RageUI.ButtonWithStyle("Join Lobby", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--             if Selected then
--                 local passwordEntered = KeyboardInput("Enter Password", "", 25)
--                 if passwordEntered ~= nil or passwordEntered ~= "" or passwordEntered ~= " "then
--                     if returnedLobbies[selectedLobby][2] == passwordEntered then
--                         Draw_Native_Notify("Joined ~g~" ..returnedLobbies[selectedLobby][1])
--                         TriggerServerEvent("DM:JoinLobby", selectedLobby)
--                         currentLobby = {
--                             returnedLobbies[selectedLobby][1],
--                             selectedLobby,
--                             returnedLobbies[selectedLobby][4],
--                             ["OwnerTable"] = returnedLobbies[selectedLobby]["OwnerTable"],
--                             ["Players"] = returnedLobbies[selectedLobby]["Players"],
--                             ["BanList"] = returnedLobbies[selectedLobby]["BanList"],
--                         }
--                     else
--                         Draw_Native_Notify("Incorrect Password")
--                     end
--                 else
--                     Draw_Native_Notify("~r~Invalid UserID")
--                 end
--             end
--         end)

--         RageUI.ButtonWithStyle("Player List", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--             if Selected then

--             end
--         end, RMenu:Get('PrvLobbies', 'selectedLobbyPlayers'))
--     end)

--     RageUI.IsVisible(RMenu:Get("PrvLobbies", "selectedLobbyPlayers"),true, false,true,function()
        
--         RageUI.Separator("~g~Player List For " ..returnedLobbies[selectedLobby][1], function() end)

--         for k,v in pairs(returnedLobbies[selectedLobby]["Players"]) do
--             RageUI.Separator(v[2].." ["..k.."]", function() end)
--         end
--     end)

--     RageUI.IsVisible(RMenu:Get("PrvLobbies", "createLobby"),true, false,true,function()
--         RageUI.Separator("Name: "..lobbyCreation["Name"], function() end)
--         RageUI.Separator("Password: "..lobbyCreation["Password"], function() end)
--         RageUI.Separator("Location: "..lobbyCreation["Location"], function() end)

--         RageUI.ButtonWithStyle("Enter Name", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
--             if Selected then
--                 local Name = KeyboardInput("Enter Lobby Name", "", 25)
--                 if Name ~= nil or Name ~= "" or Name ~= " "then
--                     lobbyCreation["Name"] = Name
--                 end
--             end
--         end)

--         RageUI.ButtonWithStyle("Enter Password", "", {RightLabel = ""}, true, function(Hovered, Active, Selected)
--             if Selected then
--                 local Password = KeyboardInput("Enter Lobby Password", "", 25)
--                 if Password ~= nil or Password ~= "" or Password ~= " "then
--                     lobbyCreation["Password"] = Password
--                 end
--             end
--         end)

--         RageUI.ButtonWithStyle("Location", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--             if Selected then

--             end
--         end, RMenu:Get('PrvLobbies', 'createLobbyLocations'))

--         if lobbyCreation["Name"] ~= "N/A" and lobbyCreation["Password"] ~= "N/A" and lobbyCreation["Location"] ~= "N/A" then
--             RageUI.ButtonWithStyle("~g~Create Lobby", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--                 if Selected then
--                     TriggerServerEvent("DM:CreateLobby", lobbyCreation["Name"], lobbyCreation["Password"], lobbyCreation["Location"])
--                 end
--             end)
--         else 
--             RageUI.Separator("~y~This lobby doesn't meet the requirements to create a lobby.", function() end)
--         end
--     end)

--     RageUI.IsVisible(RMenu:Get("PrvLobbies", "createLobbyLocations"),true, false,true,function()
--         for k,v in pairs(PrvLocations) do
--             RageUI.ButtonWithStyle(k, "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
--                 if Selected then
--                     lobbyCreation["Location"] = k
--                 end
--             end, RMenu:Get('PrvLobbies', 'createLobby'))
--         end
--     end)
-- end)

-- RegisterCommand("private-lobby", function()
--     if SelectedZone == "Casual" then
--         TriggerServerEvent("DM:RequestLobbies")
--         RageUI.Visible(RMenu:Get('PrvLobbies', 'main'), not RageUI.Visible(RMenu:Get('PrvLobbies', 'main')))
--     end
-- end)

-- RegisterKeyMapping("private-lobby","Opens Private Lobby Manager", "keyboard", "F7")


-- function DMclient.forceLobbyLeave(reason) 

-- end

-- function DMclient.returnLobbies(ActiveLobbies) 
--     returnedLobbies = ActiveLobbies
--     print(json.encode(ActiveLobbies))
-- end
