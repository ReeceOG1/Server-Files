local Tickets = {}
RMenu.Add('Callmanager', 'main', RageUI.CreateMenu("", "~b~DM - Callmanager", 1300,100, "", ""))
RMenu.Add('Callmanager', 'selectedticket',  RageUI.CreateSubMenu(RMenu:Get("Callmanager", "main")))

local SelectedTicket = nil
local TakenTicket = nil
local Coords = nil

RageUI.CreateWhile(1.0,RMenu:Get("Callmanager", "main"),nil,function()
    RageUI.IsVisible(RMenu:Get("Callmanager", "main"),true, false,true,function()

        if #Tickets < 1 then
            RageUI.Separator("~g~~h~There aren't any tickets available.", function() end)
        else
            for k,v in pairs(Tickets) do
                RageUI.ButtonWithStyle(v[1].. " ["..v[3].."] [Reason: "..v[2].."]", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        SelectedTicket = k
                    end
                end, RMenu:Get('Callmanager', 'selectedticket'))
            end
        end

    end)

    RageUI.IsVisible(RMenu:Get("Callmanager", "selectedticket"),true, false,true,function()
        RageUI.Separator("~y~"..Tickets[SelectedTicket][1].. " ["..Tickets[SelectedTicket][3].."] [Reason: "..Tickets[SelectedTicket][2].."]", function() end)
        RageUI.ButtonWithStyle("Take Ticket", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                Coords = GetEntityCoords(PlayerPedId())
                TriggerServerEvent("DM:TakeTicket", SelectedTicket, Tickets[SelectedTicket][3])
            end
        end, RMenu:Get('Callmanager', 'main'))
        RageUI.ButtonWithStyle("Send Message To Player", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                local Message = KeyboardInput("Enter Your Message", "", 25)
                if Message ~= nil or Message ~= "" or Message ~= " " then
                    TriggerServerEvent("DM:SendAdminMessage", Tickets[SelectedTicket][4], Message)
                end
            end
        end, RMenu:Get('Callmanager', 'main'))
        RageUI.ButtonWithStyle("Close Ticket", "", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent("DM:CloseTicket", SelectedTicket) 
            end
        end, RMenu:Get('Callmanager', 'main'))
    end)
end)

local cooldown = false
RegisterCommand("calladmin", function(source, args)
    local Reason = KeyboardInput("Describe Your Problem", "", 50)
    if Reason ~= nil or Reason ~= "" or Reason ~= " " then
        if cooldown == false then
            TriggerServerEvent("DM:SendAdminTicket", Reason)
            Draw_Native_Notify("~b~Admin Ticket Sent!")
            cooldown = true
            SetTimeout(120000, function()
                cooldown = false
            end)
        else
            Draw_Native_Notify("~r~You can only call a ticket every 2 minutes")
        end
    else
        Draw_Native_Notify("Invalid String Type!")
    end
end)


RegisterCommand("callmanager", function()
    TriggerServerEvent("DM:RequestTickets")
    RageUI.Visible(RMenu:Get('Callmanager', 'main'), not RageUI.Visible(RMenu:Get('Callmanager', 'main')))
end)

RegisterKeyMapping("callmanager","Opens Callmanager", "keyboard", "F4")

RegisterCommand("return", function()
    if TakenTicket then
        SetEntityCoords(PlayerPedId(), Coords)
        TakenTicket = false
        Coords = nil
        TriggerServerEvent("DM:ResetBucket")
    else
        Draw_Native_Notify("~r~No return location found.")
    end
end)

RegisterNetEvent("DM:SendAdminTicketNotification")
AddEventHandler("DM:SendAdminTicketNotification", function(Text)
    Draw_Native_Notify(Text)
end)

RegisterNetEvent("DM:SentTickets")
AddEventHandler("DM:SentTickets", function(Ticket)
    Tickets = Ticket
end)

function DMclient.UpdateTickets(Update)
    Tickets = Update
end

function DMclient.ShowTicketTaken(Name, Reason, UserID)
    TakenTicket = true
    Citizen.CreateThread(function()
        while true do
            Wait(1)
            if TakenTicket then
                DrawMissionText("~y~Taken ticket of " ..Name.. "("..UserID..") Reason: " ..Reason, 1)
            else
                break;
            end
        end
    end)
end

function AdminMessage(message)
    Citizen.CreateThread(function()
        local ScaleForm = RequestScaleformMovie("mp_big_message_freemode")
        local ShowMessage = true
        while not HasScaleformMovieLoaded(ScaleForm) do
            Citizen.Wait(0)
        end
        while HasScaleformMovieLoaded(ScaleForm) do
            Citizen.Wait(0)
            if ShowMessage then
                if IsControlPressed(0, 191) then
                    ShowMessage = false
                end
                BeginScaleformMovieMethod(ScaleForm, "SHOW_SHARD_WASTED_MP_MESSAGE")
                PushScaleformMovieFunctionParameterString("~y~Admin Message")
                PushScaleformMovieFunctionParameterString(message)
                PushScaleformMovieMethodParameterInt(5)
                EndScaleformMovieMethod()
                DrawScaleformMovieFullscreen(ScaleForm, 255, 255, 255, 255)
            else
                break;
            end
        end
    end)
end