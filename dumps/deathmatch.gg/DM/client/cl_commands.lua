ArmourCooldown = false
HealthCooldown = false

RegisterCommand("a", function()
    if GetEntityHealth(PlayerPedId()) > 100 then
        if SelectedZone == "American" then
            if ArmourCooldown == false then
                SetPedArmour(PlayerPedId(), 100)
                ArmourCooldown = true
                Draw_Native_Notify("~b~Armour replenished")
                SetTimeout(5000, function()
                    ArmourCooldown = false
                end)
            else
                Draw_Native_Notify("~o~Armour command is on cooldown. This command can only be used every 5 seconds.")
            end
        end
    end
end)

RegisterCommand("h", function()
    if GetEntityHealth(PlayerPedId()) > 100 then
        if SelectedZone == "American" then
            if HealthCooldown == false then
                SetEntityHealth(PlayerPedId(), 200)
                HealthCooldown = true
                Draw_Native_Notify("~g~Health replenished")
                SetTimeout(5000, function()
                    HealthCooldown = false
                end)
            else
                Draw_Native_Notify("~o~Health command is on cooldown. This command can only be used every 5 seconds.")
            end
        end
    end
end)