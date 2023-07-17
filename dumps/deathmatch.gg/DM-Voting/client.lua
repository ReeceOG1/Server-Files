local display = false
local gunGameVoted = false

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

-- RegisterCommand("startvote", function()
--     SetDisplay(not display)
-- end)

RegisterNetEvent("toggleVote:GG")
AddEventHandler("toggleVote:GG", function()
    SetDisplay(not display)
    if not display == true then
        gunGameVoted = false
    end
end)


RegisterNUICallback("sentVote:GG", function(vote)
    if not gunGameVoted then
        gunGameVoted = true
        TriggerServerEvent("DM-GunGame:Module:VoteMap", vote.loc)
        print(gunGameVoted)
    else
        Draw_Native_Notify("~r~You have already voted once.")
    end
end)

function Draw_Native_Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
