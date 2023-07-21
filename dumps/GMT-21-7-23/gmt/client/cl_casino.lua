insideDiamondCasino = false
AddEventHandler("GMT:onClientSpawn",function(a, b)
    if b then
        local c = vector3(1121.7922363281, 239.42251586914, -50.440742492676)
        local d = function(e)
            insideDiamondCasino = true
            tGMT.setCanAnim(false)
            tGMT.overrideTime(12, 0, 0)
            TriggerEvent("GMT:enteredDiamondCasino")
            TriggerServerEvent('GMT:getChips')
        end
        local f = function(e)
            insideDiamondCasino = false
            tGMT.setCanAnim(true)
            tGMT.cancelOverrideTimeWeather()
            TriggerEvent("GMT:exitedDiamondCasino")
        end
        local g = function(e)
        end
        tGMT.createArea("diamondcasino", c, 100.0, 20, d, f, g, {})
    end
end)