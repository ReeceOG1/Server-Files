--[[































        coords = vector3(559.2889, 2749.858, 42.85172),
        changeNamePrice = 60000,
    },
},
-- test table remove on db done (get owned pets from pets table)
local ownedPets = {
    ["bear"] = {
        awaitingHealthReduction = false,
        name = "Bear",
        id = "bear",
        ownedSkills = {
            teleport = true,
        },
    },
}
-- test table remove on db done (get disabled abilities from pets table)
local disabledAbilities = {
    attack = false,
}


AddEventHandler("GMT:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    local user_id = GMT.getUserId(source)
    if first_spawn then
        TriggerClientEvent('GMT:buildPetCFG', source, ownedPets, disabledAbilities, petStore)
    end
end)

RegisterServerEvent('GMT:receivePetCommand')
AddEventHandler("GMT:receivePetCommand", function(id, M, L, zz)
    local source = source
    local user_id = GMT.getUserId(source)
    -- check if permid owns this pet
    TriggerClientEvent('GMT:receivePetCommand', source, M, L, zz)
end)

RegisterServerEvent('GMT:startPetAttack')
AddEventHandler("GMT:startPetAttack", function(id, M, Y)
    local source = source
    local user_id = GMT.getUserId(source)
    -- check if permid owns this pet and that attacks aren't disabled
    TriggerClientEvent('GMT:sendClientRagdollPet', Y, user_id, GetPlayerName(source))
    TriggerClientEvent('GMT:startPetAttack', source, id)
end)

RegisterCommand('pet', function(source)
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id == 1 then
        TriggerClientEvent('GMT:togglePetMenu', source)
    end
end)]]