local lang = GMT.lang
RegisterNetEvent('GMT:Withdraw')
AddEventHandler('GMT:Withdraw', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = GMT.getUserId(source)
        if user_id ~= nil then
            if GMT.tryWithdraw(user_id, amount) then
                GMTclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                GMTclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        GMTclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('GMT:Deposit')
AddEventHandler('GMT:Deposit', function(amount)
    local source = source
    local amount = parseInt(amount)
    if amount > 0 then
        local user_id = GMT.getUserId(source)
        if user_id ~= nil then
            if GMT.tryDeposit(user_id, amount) then
                GMTclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                GMTclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        GMTclient.notify(source, {lang.common.invalid_value()})
    end
end)

RegisterNetEvent('GMT:WithdrawAll')
AddEventHandler('GMT:WithdrawAll', function()
    local source = source
    local amount = GMT.getBankMoney(GMT.getUserId(source))
    if amount > 0 then
        local user_id = GMT.getUserId(source)
        if user_id ~= nil then
            if GMT.tryWithdraw(user_id, amount) then
                GMTclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
            else
                GMTclient.notify(source, {lang.atm.withdraw.not_enough()})
            end
        end
    else
        GMTclient.notify(source, {lang.common.invalid_value()})
    end
end)


RegisterNetEvent('GMT:DepositAll')
AddEventHandler('GMT:DepositAll', function()
    local source = source
    local amount = GMT.getMoney(GMT.getUserId(source))
    if amount > 0 then
        local user_id = GMT.getUserId(source)
        if user_id ~= nil then
            if GMT.tryDeposit(user_id, amount) then
                GMTclient.notify(source, {lang.atm.deposit.deposited({amount})})
            else
                GMTclient.notify(source, {lang.money.not_enough()})
            end
        end
    else
        GMTclient.notify(source, {lang.common.invalid_value()})
    end
end)