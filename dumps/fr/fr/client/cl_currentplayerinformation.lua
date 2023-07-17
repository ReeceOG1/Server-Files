local currentPlayerInfo = {}

RegisterNetEvent("FR:receiveCurrentPlayerInfo")
AddEventHandler("FR:receiveCurrentPlayerInfo",function(playerInfo)
    currentPlayerInfo = playerInfo
end)

function tFR.getCurrentPlayerInfo(z)
    for k,v in pairs(currentPlayerInfo) do
        if k == z then
            return v
        end
    end
end