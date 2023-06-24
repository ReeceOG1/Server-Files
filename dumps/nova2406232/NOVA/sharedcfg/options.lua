NOVAConfig = {} -- Global variable for easy referencing. 

NOVAConfig.MoneyUiEnabled = false; -- Set to false to disable Money in the top right corner. 
NOVAConfig.SurvivalUiEnabled = false; -- Controls the UI under the healthbar.
NOVAConfig.EnableComa = true; -- Controls the NOVA coma on death.
NOVAConfig.EnableFoodAndWater = false; -- Controls the food and water system.
NOVAConfig.EnableHealthRegen = true; -- Controls the health regen. (Whether they regen health after taking damage do not disable if coma is enabled.)
NOVAConfig.EnableBuyVehicles = true; -- Enables ability to buy vehicles from the RageUI Garages.  
NOVAConfig.LoadPreviews = true; -- Controls the car previews with the RageUI Garages.
NOVAConfig.VehicleStoreRadius = 250; -- Controls radius a vehicle can be stored from.
NOVAConfig.AdminCoolDown = false; -- Enables an admin cooldown on call admin.
NOVAConfig.AdminCooldownTime = 60; -- 1 minute in (seconds) duration of cooldown. 
NOVAConfig.StoreWeaponsOnDeath = true; -- Stores the players weapon on death allowing them to be looted.
NOVAConfig.DoNotDisplayIps = true; -- Removes all NOVA related references in the console to player ip addresses.
NOVAConfig.LoseItemsOnDeath = true; -- Controls whether you lose inventory items on death.
NOVAConfig.AllowMoreThenOneCar = false; -- Controls if you can have more than one car out.
NOVAConfig.F10System = true; -- Logs warnings and can be accessed via F10 (Thanks to Rubbertoe98) (https://github.com/rubbertoe98/FiveM-Scripts/tree/master/nova_punishments)
NOVAConfig.ServerName = "NOVA" -- Controls the name that is displayed on warnings title etc.
NOVAConfig.PlayerSavingTime = 3000 -- Time in milliseconds to update Player saving
---------------
NOVAConfig.LootBags = true; -- Enables loot bags and disables looting. 
NOVAConfig.DisplayNamelLootbag = false; -- Enables notification of who's lootbag you have opened