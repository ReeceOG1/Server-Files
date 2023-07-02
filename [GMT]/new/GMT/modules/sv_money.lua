local lang = GMT.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

MySQL.createCommand("GMT/money_init_user","INSERT IGNORE INTO gmt_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("GMT/get_money","SELECT wallet,bank FROM gmt_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("GMT/set_money","UPDATE gmt_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")

-- get money
-- cbreturn nil if error
function GMT.getMoney(user_id)
  local tmp = GMT.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function GMT.setMoney(user_id,value)
  local tmp = GMT.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = GMT.getUserSource(user_id)
  if source ~= nil then
    GMTclient.setDivContent(source,{"money",lang.money.display({Comma(GMT.getMoney(user_id))})})
    TriggerClientEvent('GMT:initMoney', source, GMT.getMoney(user_id), GMT.getBankMoney(user_id))
  end
end

-- try a payment
-- return true or false (debited if true)
function GMT.tryPayment(user_id,amount)
  local money = GMT.getMoney(user_id)
  if amount >= 0 and money >= amount then
    GMT.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function GMT.tryBankPayment(user_id,amount)
  local bank = GMT.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    GMT.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function GMT.giveMoney(user_id,amount)
  local money = GMT.getMoney(user_id)
  GMT.setMoney(user_id,money+amount)
end

-- get bank money
function GMT.getBankMoney(user_id)
  local tmp = GMT.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function GMT.setBankMoney(user_id,value)
  local tmp = GMT.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = GMT.getUserSource(user_id)
  if source ~= nil then
    GMTclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(GMT.getBankMoney(user_id))})})
    TriggerClientEvent('GMT:initMoney', source, GMT.getMoney(user_id), GMT.getBankMoney(user_id))
  end
end

-- give bank money
function GMT.giveBankMoney(user_id,amount)
  if amount > 0 then
    local money = GMT.getBankMoney(user_id)
    GMT.setBankMoney(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function GMT.tryWithdraw(user_id,amount)
  local money = GMT.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    GMT.setBankMoney(user_id,money-amount)
    GMT.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function GMT.tryDeposit(user_id,amount)
  if amount > 0 and GMT.tryPayment(user_id,amount) then
    GMT.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function GMT.tryFullPayment(user_id,amount)
  local money = GMT.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return GMT.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if GMT.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return GMT.tryPayment(user_id, amount)
    end
  end

  return false
end

local startingCash = 5000
local startingBank = 50000

-- events, init user account if doesn't exist at connection
AddEventHandler("GMT:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("GMT/money_init_user", {user_id = user_id, wallet = startingCash, bank = startingBank}, function(affected)
    local tmp = GMT.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("GMT/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("GMT:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = GMT.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("GMT/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("GMT:save", function()
  for k,v in pairs(GMT.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("GMT/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

RegisterNetEvent('GMT:giveCashToPlayer')
AddEventHandler('GMT:giveCashToPlayer', function(nplayer)
  local source = source
  local user_id = GMT.getUserId(source)
  if user_id ~= nil then
    if nplayer ~= nil then
      local nuser_id = GMT.getUserId(nplayer)
      if nuser_id ~= nil then
        GMT.prompt(source,lang.money.give.prompt(),"",function(source,amount)
          local amount = parseInt(amount)
          if amount > 0 and GMT.tryPayment(user_id,amount) then
            GMT.giveMoney(nuser_id,amount)
            GMTclient.notify(source,{lang.money.given({getMoneyStringFormatted(math.floor(amount))})})
            GMTclient.notify(nplayer,{lang.money.received({getMoneyStringFormatted(math.floor(amount))})})
            tGMT.sendWebhook('give-cash', "GMT Give Cash Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..GetPlayerName(nplayer).."**\n> Target PermID: **"..nuser_id.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**")
          else
            GMTclient.notify(source,{lang.money.not_enough()})
          end
        end)
      else
        GMTclient.notify(source,{lang.common.no_player_near()})
      end
    else
      GMTclient.notify(source,{lang.common.no_player_near()})
    end
  end
end)


function Comma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

RegisterServerEvent("GMT:takeAmount")
AddEventHandler("GMT:takeAmount", function(amount)
    local source = source
    local user_id = GMT.getUserId(source)
    if GMT.tryFullPayment(user_id,amount) then
      GMTclient.notify(source,{'~g~Paid £'..getMoneyStringFormatted(amount)..'.'})
      return
    end
end)

RegisterServerEvent("GMT:bankTransfer")
AddEventHandler("GMT:bankTransfer", function(id, amount)
    local source = source
    local user_id = GMT.getUserId(source)
    local id = tonumber(id)
    local amount = tonumber(amount)
    if GMT.getUserSource(id) then
      if GMT.tryBankPayment(user_id,amount) then
        GMTclient.notify(source,{'~g~Transferred £'..getMoneyStringFormatted(amount)..' to ID: '..id})
        GMTclient.notify(GMT.getUserSource(id),{'~g~Received £'..getMoneyStringFormatted(amount)..' from ID: '..user_id})
        TriggerClientEvent("gmt:PlaySound", source, "apple")
        TriggerClientEvent("gmt:PlaySound", GMT.getUserSource(id), "apple")
        GMT.giveBankMoney(id, amount)
        tGMT.sendWebhook('bank-transfer', "GMT Bank Transfer Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Target Name: **"..GetPlayerName(GMT.getUserSource(id)).."**\n> Target PermID: **"..id.."**\n> Amount: **£"..amount.."**")
      else
        GMTclient.notify(source,{'You do not have enough money.'})
      end
    else
      GMTclient.notify(source,{'Player is not online'})
    end
end)

RegisterServerEvent('GMT:requestPlayerBankBalance')
AddEventHandler('GMT:requestPlayerBankBalance', function()
    local user_id = GMT.getUserId(source)
    local bank = GMT.getBankMoney(user_id)
    local wallet = GMT.getMoney(user_id)
    TriggerClientEvent('GMT:setDisplayMoney', source, wallet)
    TriggerClientEvent('GMT:setDisplayBankMoney', source, bank)
    TriggerClientEvent('GMT:initMoney', source, wallet, bank)
end)