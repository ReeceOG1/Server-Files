local isDisplaying = false
RegisterCommand("crosshairmenu", function ()
    if not isDisplaying then 
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openMenu'
        })
        isDisplaying = true
    end
end)

RegisterNUICallback("exit" , function(data, cb)
    SetNuiFocus(false, false)
    isDisplaying = false
end)


RegisterNUICallback("loadData" , function(data, cb)
    for k,v in pairs(Crosshairs) do 
        SendNUIMessage({
            action = 'Load',
            imagenes = v.img,
            valor = v.name, 
            label = v.label
        })
    end
end)
