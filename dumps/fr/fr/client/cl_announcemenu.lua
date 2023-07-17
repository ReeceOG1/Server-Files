RMenu.Add("frannouncements","main",RageUI.CreateMenu("","Announcement Menu",tFR.getRageUIMenuWidth(),tFR.getRageUIMenuHeight(),"fr_announceui","fr_announceui"))
local a = {}
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('frannouncements', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for b, c in pairs(a) do
                RageUI.Button(c.name, string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)), {RightLabel = "→→→"}, true, function(d, e, f)
                    if f then
                        TriggerServerEvent("FR:serviceAnnounce", c.name)
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("FR:serviceAnnounceCl",function(h, i)
    tFR.announce(h, i)
end)

RegisterNetEvent("FR:buildAnnounceMenu",function(g)
    a = g
    RageUI.Visible(RMenu:Get("frannouncements", "main"), not RageUI.Visible(RMenu:Get("frannouncements", "main")))
end)

RegisterCommand("announcemenu",function()
    TriggerServerEvent('FR:getAnnounceMenu')
end)
