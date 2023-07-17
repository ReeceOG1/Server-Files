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

cfg.ped = {
    modelHash = `ig_trafficwarden`,
    position = vector3(369.81695556641,-1607.9230957031,28.3031152344),
    animDict = "amb@world_human_hang_out_street@male_c@idle_a",
    animName = "idle_b",
}

cfg.driveToPosition = vector3(406.3603515625,-1600.9317626953,29.237545013428)

cfg.reasonsForImpound = {
    {option = "Vehicle has been stolen", selected = false, isCriminal = true},
    {option = "Vehicle has been involved in a collision", selected = false, isCriminal = false},
    {option = "Vehicle was parked illegally", selected = false, isCriminal = true},
    {option = "Vehicle was involved in a crime and abandoned", selected = false, isCriminal = true},
    {option = "Vehicle was driven in an anti-social manner", selected = false, isCriminal = true},
    {option = "Vehicle was causing an obstruction or danger", selected = false, isCriminal = false},
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


