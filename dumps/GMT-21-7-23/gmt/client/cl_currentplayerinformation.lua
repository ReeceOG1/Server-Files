local a = {}
RegisterNetEvent("GMT:receiveCurrentPlayerInfo")
AddEventHandler("GMT:receiveCurrentPlayerInfo",function(b)
    a = b
end)
function tGMT.getCurrentPlayerInfo(c)
    for d, e in pairs(a) do
        if d == c then
            return e
        end
    end
end
function tGMT.clientGetPlayerIsStaff(f)
    local g = tGMT.getCurrentPlayerInfo("currentStaff")
    if g then
        for h, i in pairs(g) do
            if i == f then
                return true
            end
        end
        return false
    end
end
