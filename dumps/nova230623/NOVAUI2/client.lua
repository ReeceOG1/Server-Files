function Crosshair(enable)
    SendNUIMessage({
      crosshair = enable
    })
  end
  
  RegisterNetEvent("NOVA:PutCrossHairOnScreen")
  AddEventHandler("NOVA:PutCrossHairOnScreen", function(bool)
    Crosshair(bool)
  end)