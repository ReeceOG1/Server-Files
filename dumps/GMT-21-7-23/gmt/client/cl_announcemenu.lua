RMenu.Add("gmtannouncements","main",RageUI.CreateMenu("","Announcement Menu",tGMT.getRageUIMenuWidth(),tGMT.getRageUIMenuHeight(),"gmt_announceui","gmt_announceui"))
local a = {}
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('gmtannouncements', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for b, c in pairs(a) do
                RageUI.Button(c.name, string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)), {RightLabel = "→→→"}, true, function(d, e, f)
                    if f then
                        TriggerServerEvent("GMT:serviceAnnounce", c.name)
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("GMT:serviceAnnounceCl",function(h, i)
    tGMT.announce(h, i)
end)

RegisterNetEvent("GMT:buildAnnounceMenu",function(g)
    a = g
    RageUI.Visible(RMenu:Get("gmtannouncements", "main"), not RageUI.Visible(RMenu:Get("gmtannouncements", "main")))
end)

RegisterCommand("announcemenu",function()
    TriggerServerEvent('GMT:getAnnounceMenu')
end)
