math.randomseed(os.clock()*100000000000)
local rewardjew = math.random(3,5)
local rewardmoney = math.random(525,5974)
local moneygive = math.random(5120,7421)
local RobberyPickUpAmount = {}
local lastrobbeed = 0
local IsRobbing = false
local Counts = 0

RegisterServerEvent("jewelryrobberry:serverstart")
AddEventHandler("jewelryrobberry:serverstart", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)

    local players = GetPlayers()
    local policeCount = 0

    for k,v in pairs(players) do 
        local userid = LUNA.getUserId(v)
        if LUNA.hasPermission(userid, "police.menu") then 
            policeCount = policeCount + 1
        end
    end
    if (os.time() - lastrobbeed) < 600 and lastrobbeed ~= 0 then
        TriggerClientEvent(
            "chatMessage",
            source,
            "ROBBERY",
            {255, 0, 0},
            "This store has already been hit. You'll have to wait another: ^2" .. (1200 - (os.time() - lastrobbeed)) .. "^0 seconds.")
        return
    end

    if policeCount >= 2 then
        lastrobbeed = os.time()
        IsRobbing = true 
        TriggerClientEvent("jewelryrobberry:start", source)
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="padding: 0.5vw; margin: 0.4vw; background-color: rgba(0, 0, 255, 0.9); border-radius: 4px;"><i class="fas fa-globe"></i> Sky News | The Jewelry Store Is Being Robbed, Police Are now responding to the scene' .. '</div>'
          })
    else
        LUNAclient.notify(source, {"~r~Not enough cops online."})
    end
end)


function tLUNA.JRobbery2()
    local source = source
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)
    local ped = GetPlayerPed(source)
    local plycoords = GetEntityCoords(ped)
    local coords = vector3(-626.39184570313,-239.2056427002,39.243705749512)
    if not IsRobbing then 
        return print("[LUNA_jewelryheist] - IsRobbing is false |" .. user_id .. " could be cheating or something.")
    end
    if Counts > 30 then 
        return print("[LUNA_jewelryheist] - Counts is greater than 30 |" .. user_id .. " could be cheating or something.")
    end
    Counts = Counts + 1
    if(user_id)then
        if #(plycoords - coords) < 30 then
            LUNA.giveInventoryItem(user_id, "Jewelry", rewardjew, true)
        else
            print("Player " ..player.. " Perm ID: " ..user_id.. " Is Probably Cheating - Jewellery Reward - Coords Check")
        end
    end
end

function tLUNA.JRobbery()
    local source = source
    local user_id = LUNA.getUserId(source)
    local player = LUNA.getUserSource(user_id)
    local ped = GetPlayerPed(source)
    local plycoords = GetEntityCoords(ped)
    local coords = vector3(-626.39184570313,-239.2056427002,39.243705749512)
    if not IsRobbing then 
        return print("[LUNA_jewelryheist] - IsRobbing is false |" .. user_id .. " could be cheating or something.")
    end
    if Counts > 30 then 
        return print("[LUNA_jewelryheist] - Counts is greater than 30 |" .. user_id .. " could be cheating or something.")
    end
    Counts = Counts + 1
    if (user_id) then
        if #(plycoords - coords) < 30 then
            LUNA.giveInventoryItem(user_id, "Jewelry", 1, true)
        else
            print("Player " ..player.. " Perm ID: " ..user_id.. " Is Probably Cheating - Jewellery Reward - Coords Check")
        end
    end
end

function tLUNA.Robbed()
    IsRobbing = false 
    Counts = 0
end


--RegisterServerEvent('jewelryrobberry:allarmpolice')
--AddEventHandler('jewelryrobberry:allarmpolice', function()
 --   local user_id = LUNA.getUserId(source)
 --   local player = LUNA.getUserSource(user_id)
 ----   if(user_id)then
 --       local users = LUNA.getUsers()
 --   end
--end)


RegisterNetEvent("FGS:Sellj", function()
    local user_id = LUNA.getUserId(source)
    local amount = LUNA.getInventoryItemAmount(user_id, "Jewelry")
    local amounttogive = math.floor(amount * 4500)
    if LUNA.tryGetInventoryItem(user_id, "Jewelry", amount, true) then 
        LUNA.giveMoney(user_id, amounttogive)
    end
end)
