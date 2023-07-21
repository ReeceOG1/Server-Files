local cfg = {}

cfg.positions = {
    {
        x = 393.99752807617,
        y = -1620.1383056641,
        z = 29.29195022583,
        heading = 320.85,
    },
    {
        x = 391.22680664062,
        y = -1617.6063232422,
        z =29.29195022583,
        heading = 320.85,
    },
    {
        x = 408.68963623047,
        y = -1638.9798583984,
        z = 29.291952133179,
        heading = 230.27,
    },
    {
        x = 411.12161254883,
        y = -1636.5198974609,
        z = 29.291952133179,
        heading = 230.27,
    },
    {
        x = 402.46197509766,
        y = -1633.4318847656,
        z = 29.291952133179,
        heading = 141.36
    },
    {
        x = 389.99276733398,
        y = -1630.65234375,
        z = 29.291940689087,
        heading = 319.89,
    }
}

cfg.paletoPositions = {
    {
        x = -453.27032470703,
        y = 6050.5581054688,
        z = 31.335571289062,
        heading = 221.10237121582,
    },
    {
        x = -449.52526855469,
        y = 6053.0112304688,
        z = 31.335571289062,
        heading = 223.93701171875,
    },
    {
        x = -445.71429443359,
        y = 6055.4638671875,
        z = 31.335571289062,
        heading = 218.2677154541,
    }
}

cfg.CityPed = {
    modelHash = `ig_trafficwarden`,
    position = vector3(369.81695556641,-1607.9230957031,28.3031152344),
    animDict = "amb@world_human_hang_out_street@male_c@idle_a",
    animName = "idle_b",
}

cfg.paletoPed = {
    modelHash = `ig_trafficwarden`,
    position = vector3(-450.68811035156,6026.015625,30.490116119385),
    animDict = "amb@world_human_hang_out_street@male_c@idle_a",
    animName = "idle_b",
}

cfg.driveToPosition = vector3(406.3603515625,-1600.9317626953,29.237545013428)

cfg.reasonsForImpound = {
    {option = "Vehicle has been stolen", selected = false},
    {option = "Vehicle has been involved in a collision", selected = false},
    {option = "Vehicle was parked illegally", selected = false},
    {option = "Vehicle was involved in a crime and abandoned", selected = false},
    {option = "Vehicle was driven in an anti-social manner", selected = false},
    {option = "Vehicle was causing an obstruction or danger", selected = false},
}

cfg.disallowedGarageTypes = {
    -- Government vehicles
    ["Met Police Vehicles"] = true,
    ["Met Police Boats"] = true,
    ["NHS Vehicles"] = true,
    ["LFB Garage"] = true,
    ["Police Helicopters"] = true,
    ["NHS Helicopters"] = true,
    ["HMP Vehicles"] = true,
    ["AA"] = true,
    ["Diamond Casino"] = true,
    
    -- Large vehicles
    ["Standard Aircraft"] = true,
    ["Standard Helicopters"] = true,
    ["VIP Aircraft"] = true,
    ["VIP Helicopters"] = true,

}

cfg.disallowedVehicleClasses = {
    [10] = true,
    [13] = true,
    [14] = true,
    [21] = true,
    [18] = true,
    [15] = true,
    [16] = true,
}

return cfg