function Crosshair(enable)
    SendNUIMessage({
      crosshair = enable
    })
  end
  
  RegisterNetEvent("GMA:PutCrossHairOnScreen")
  AddEventHandler("GMA:PutCrossHairOnScreen", function(bool)
    Crosshair(bool)
  end)