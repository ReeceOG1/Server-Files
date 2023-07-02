-- a basic ATM implementation
local lang = LUNA.lang
local cfg = module("cfg/atms")
local atms = cfg.atms
local onesync = GetConvar("onesync", nil)

RegisterNetEvent("LUNA:Withdraw")
AddEventHandler(
    "LUNA:Withdraw",
    function(amount)
        local source = source
        amount = parseInt(amount)
        if amount < 0 then
            return
        end
        if onesync ~= "off" then
            --Onesync allows extra security behind events should enable it if it's not already.
            local ped = GetPlayerPed(source)
            local playerCoords = GetEntityCoords(ped)
            for i, v in pairs(cfg.atms) do
                local coords = vec3(v[1], v[2], v[3])
                if #(playerCoords - coords) <= 2.50 then
                    if amount > 0 then
                        local user_id = LUNA.getUserId(source)
                        if user_id ~= nil then
                            if LUNA.tryWithdraw(user_id, amount) then
                                LUNAclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                                LUNAclient.playAnim(source, {false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
                            else
                                LUNAclient.notify(source, {lang.atm.withdraw.not_enough()})
                            end
                        end
                    else
                        LUNAclient.notify(source, {lang.common.invalid_value()})
                    end
                end
            end
        else
            if amount > 0 then
                local user_id = LUNA.getUserId(source)
                if user_id ~= nil then
                    if LUNA.tryWithdraw(user_id, amount) then
                        LUNAclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                        LUNAclient.playAnim(source, {false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
                    else
                        LUNAclient.notify(source, {lang.atm.withdraw.not_enough()})
                    end
                end
            else
                LUNAclient.notify(source, {lang.common.invalid_value()})
            end
        end
    end
)

RegisterNetEvent("LUNA:Deposit")
AddEventHandler(
    "LUNA:Deposit",
    function(amount)
        local source = source
        amount = parseInt(amount)
        if onesync ~= "off" then
            --Onesync allows extra security behind events should enable it if it's not already.
            local ped = GetPlayerPed(source)
            local playerCoords = GetEntityCoords(ped)
            for i, v in pairs(cfg.atms) do
                local coords = vec3(v[1], v[2], v[3])
                if #(playerCoords - coords) <= 2.50 then
                    if amount > 0 then
                        local user_id = LUNA.getUserId(source)
                        if user_id ~= nil then
                            if LUNA.tryDeposit(user_id, amount) then
                                LUNAclient.notify(source, {lang.atm.deposit.deposited({amount})})
                                LUNAclient.playAnim(
                                    source,
                                    {
                                        false,
                                        {
                                            {"amb@prop_human_atm@male@enter", "enter"},
                                            {"amb@prop_human_atm@male@idle_a", "idle_a"}
                                        },
                                        false
                                    }
                                )
                            else
                                LUNAclient.notify(source, {lang.money.not_enough()})
                            end
                        end
                    else
                        LUNAclient.notify(source, {lang.common.invalid_value()})
                    end
                end
            end
        else
            if amount > 0 then
                local user_id = LUNA.getUserId(source)
                if user_id ~= nil then
                    if LUNA.tryDeposit(user_id, amount) then
                        LUNAclient.notify(source, {lang.atm.deposit.deposited({amount})})
                        LUNAclient.playAnim(
                            source,
                            {
                                false,
                                {
                                    {"amb@prop_human_atm@male@enter", "enter"},
                                    {"amb@prop_human_atm@male@idle_a", "idle_a"}
                                },
                                false
                            }
                        )
                    else
                        LUNAclient.notify(source, {lang.money.not_enough()})
                    end
                end
            else
                LUNAclient.notify(source, {lang.common.invalid_value()})
            end
        end
    end
)

RegisterNetEvent("LUNA:DepositALL")
AddEventHandler(
    "LUNA:DepositALL",
    function()
        local source = source
        local userid = LUNA.getUserId(source)
        local amount = LUNA.getMoney(userid)
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        if onesync ~= "off" then
        if userid ~= nil then
            for a, b in pairs(cfg.atms) do
                local coords = vec3(b[1], b[2], b[3])
                if #(playerCoords - coords) <= 2.50 then
                    if amount > 0 then
                        if LUNA.tryDeposit(userid, amount) then
                            LUNAclient.notify(source, {lang.atm.deposit.deposited({roundnumber(amount, 1)})})
                            LUNAclient.playAnim(
                                source,
                                {
                                    false,
                                    {
                                        {"amb@prop_human_atm@male@enter", "enter"},
                                        {"amb@prop_human_atm@male@idle_a", "idle_a"}
                                    },
                                    false
                                }
                            )
                        else
                            LUNAclient.notify(source, {lang.money.not_enough()})
                        end
                    end
                end
            end
        end
    end
end
)

RegisterNetEvent('LUNA:WithdrawAll')
AddEventHandler('LUNA:WithdrawAll', function()
    local source = source
    userid = LUNA.getUserId(source)
    amount = LUNA.getBankMoney(userid)
    print(amount)
    if onesync ~= "off" then    
        --Onesync allows extra security behind events should enable it if it's not already.
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        for i, v in pairs(cfg.atms) do
            local coords = vec3(v[1], v[2], v[3])
            if #(playerCoords - coords) <= 5.0 then
            
                    local user_id = LUNA.getUserId(source)
                    if user_id ~= nil then
                        if LUNA.tryWithdraw(user_id, amount) then
                            LUNAclient.notify(source, {lang.atm.withdraw.withdrawn({roundnumber(amount, 1)})})
                            LUNAclient.playAnim(
                                source,
                                {
                                    false,
                                    {
                                        {"amb@prop_human_atm@male@enter", "enter"},
                                        {"amb@prop_human_atm@male@idle_a", "idle_a"}
                                    },
                                    false
                                }
                            )
                        else
                            LUNAclient.notify(source, {lang.atm.withdraw.not_enough()})
                        end
                    end
                end
        end
    end
end)


function roundnumber(P, Q)
    local R = 10 ^ (Q or 0)
    return math.floor(P * R + 0.5) / R
end
