local cfg = {}

cfg.licenseShopLocation = vector3(-532.92028808594,-189.90745544434,38.219657897949)
cfg.casinolicenseShopLocation = vector3(1088.4821777344,219.38232421875,-49.200370788574)

cfg.licenses = {
    {name = "Gang License", group = "Gang", price = 500000, type = "other"},      
    {name = "Advanced Rebel", group = "AdvancedRebel", price  = 10000000, type = "other"},   
    {name = "Rebel License", group = "Rebel", price = 10000000, type = "other"},
    
    {name = "Scrap Job", group = "Scrap Job", price = 50000, type = "grinding"},
    {name = "Weed", group = "Weed", price = 300000, type = "grinding"},
    {name = "Iron Job", group = "Iron", price = 500000, type = "grinding"},
    {name = "Cocaine", group = "Cocaine", price = 750000, type = "grinding"},
    {name = "Heroin", group = "Heroin", price = 10000000, type = "grinding"}, 
    {name = "Diamond", group = "Diamond", price = 15000000, type = "grinding"},
    {name = "LSD", group = "LSD", price = 40000000, type = "grinding"},

}

return cfg