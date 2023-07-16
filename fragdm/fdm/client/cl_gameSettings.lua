Citizen.CreateThread(function()
    while true do
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
        HideHudComponentThisFrame(7) 
        HideHudComponentThisFrame(9) 
        HideHudComponentThisFrame(3) 
        HideHudComponentThisFrame(4)  
        HideHudComponentThisFrame(13) 
        Wait(0)
    end
end)


local timeOut = 1000;
Citizen.CreateThread(function()
  while true do
    if IsPedArmed(cFDM.Ped(), 6) then
      timeOut = 0;
      DisableControlAction(1, 140, true)
      DisableControlAction(1, 141, true)
      DisableControlAction(1, 142, true)
    else
      timeOut = 0;
    end
    Wait(timeOut)
  end
end)



