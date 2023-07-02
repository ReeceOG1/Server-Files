local currentPlayerInfo = {}

RegisterNetEvent("GMT:receiveCurrentPlayerInfo")
AddEventHandler("GMT:receiveCurrentPlayerInfo",function(playerInfo)
    currentPlayerInfo = playerInfo
end)

function tGMT.getCurrentPlayerInfo(z)
    for k,v in pairs(currentPlayerInfo) do
        if k == z then
            return v
        end
    end
end