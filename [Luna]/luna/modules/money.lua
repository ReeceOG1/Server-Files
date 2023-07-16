local lang = LUNA.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)



MySQL.createCommand("LUNA/money_init_user","INSERT IGNORE INTO luna_user_moneys(user_id,wallet,bank) VALUES(@user_id,@wallet,@bank)")
MySQL.createCommand("LUNA/get_money","SELECT wallet,bank FROM luna_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("LUNA/set_money","UPDATE luna_user_moneys SET wallet = @wallet, bank = @bank WHERE user_id = @user_id")


-- load config
local cfg = module("cfg/money")

-- API

-- get money
-- cbreturn nil if error
function LUNA.getMoney(user_id)
  local tmp = LUNA.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- set money
function LUNA.setMoney(user_id,value)
  local tmp = LUNA.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = LUNA.getUserSource(user_id)
  if source ~= nil then
    LUNAclient.setDivContent(source,{"money",lang.money.display({Comma(LUNA.getMoney(user_id))})})
  end
end

-- try a payment
-- return true or false (debited if true)
function LUNA.tryPayment(user_id,amount)
  local money = LUNA.getMoney(user_id)
  if amount >= 0 and money >= amount then
    LUNA.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

function LUNA.tryBankPayment(user_id,amount)
  local bank = LUNA.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
    LUNA.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end

-- give money
function LUNA.giveMoney(user_id,amount)
  local money = LUNA.getMoney(user_id)
  LUNA.setMoney(user_id,money+amount)
end

-- Give money with rad

RegisterServerEvent("LUNA:GiveMoney")
AddEventHandler("LUNA:GiveMoney", function()
  local player = source
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    LUNAclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = LUNA.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          LUNA.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and LUNA.tryPayment(user_id,amount) then
              LUNA.giveMoney(nuser_id,amount)
              LUNAclient.notify(player,{lang.money.given({amount})})
              LUNAclient.notify(nplayer,{lang.money.received({amount})})
              webhook = "https://ptb.discord.com/api/webhooks/1110524408822501427/eeoDEeRRbpnnZFjTcqlnQ6tLqCBxE31qZCKSF44yPt8am-F4rbsQDxCZ5g2DDgreEkp4"
       
                    PerformHttpRequest(webhook, function(err, text, headers) 
                    end, "POST", json.encode({username = "LUNA", embeds = {
                        {
                            ["color"] = "15158332",
                            ["title"] = "Cash Given",
                            ["description"] = "**Sender Name: **" .. GetPlayerName(source) .. "** \nUser ID: **" .. user_id.. "** \nGave: **£" .. amount .. '**\nReciever ID: **' ..nuser_id,
                            ["footer"] = {
                                ["text"] = "Time - "..os.date("%x %X %p"),
                            }
                    }
                }}), { ["Content-Type"] = "application/json" })
            else
              LUNAclient.notify(player,{lang.money.not_enough()})
            end
          end)
        else
          LUNAclient.notify(player,{lang.common.no_player_near()})
        end
      else
        LUNAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end)

-- get bank money
function LUNA.getBankMoney(user_id)
  local tmp = LUNA.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- set bank money
function LUNA.setBankMoney(user_id,value)
  local tmp = LUNA.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
  local source = LUNA.getUserSource(user_id)
  if source ~= nil then
    LUNAclient.setDivContent(source,{"bmoney",lang.money.bdisplay({Comma(LUNA.getBankMoney(user_id))})})
  end
end

-- give bank money
function LUNA.giveBankMoney(user_id, amount)
  if type(amount) == "number" and amount > 0 then
    local money = LUNA.getBankMoney(user_id)
    LUNA.setBankMoney(user_id, money + amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function LUNA.tryWithdraw(user_id,amount)
  local money = LUNA.getBankMoney(user_id)
  if amount > 0 and money >= amount then
    LUNA.setBankMoney(user_id,money-amount)
    LUNA.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function LUNA.tryDeposit(user_id,amount)
  if amount > 0 and LUNA.tryPayment(user_id,amount) then
    LUNA.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function LUNA.tryFullPayment(user_id,amount)
  local money = LUNA.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return LUNA.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if LUNA.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return LUNA.tryPayment(user_id, amount)
    end
  end

  return false
end

-- events, init user account if doesn't exist at connection
AddEventHandler("LUNA:playerJoin",function(user_id,source,name,last_login)
  MySQL.query("LUNA/money_init_user", {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank}, function(affected)
    local tmp = LUNA.getUserTmpTable(user_id)
    if tmp then
      MySQL.query("LUNA/get_money", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
          tmp.bank = rows[1].bank
          tmp.wallet = rows[1].wallet
        end
      end)
    end
  end)
end)

-- save money on leave
AddEventHandler("LUNA:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = LUNA.getUserTmpTable(user_id)
  if tmp and tmp.wallet ~= nil and tmp.bank ~= nil then
    MySQL.execute("LUNA/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("LUNA:save", function()
  for k,v in pairs(LUNA.user_tmp_tables) do
    if v.wallet ~= nil and v.bank ~= nil then
      MySQL.execute("LUNA/set_money", {user_id = k, wallet = v.wallet, bank = v.bank})
    end
  end
end)

-- money hud
AddEventHandler("LUNA:playerSpawn",function(user_id, source, first_spawn)
  Wait(500)
  if first_spawn and LUNAConfig.MoneyUiEnabled then
    -- add money display
    LUNAclient.setDiv(source,{"money",cfg.display_css,lang.money.display({Comma(LUNA.getMoney(user_id))})})
    LUNAclient.setDiv(source,{"bmoney",cfg.display_css,lang.money.bdisplay({Comma(LUNA.getBankMoney(user_id))})})
  end
end)

local function ch_give(player,choice)
  -- get nearest player
  local user_id = LUNA.getUserId(player)
  if user_id ~= nil then
    LUNAclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = LUNA.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          LUNA.prompt(player,lang.money.give.prompt(),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 and LUNA.tryPayment(user_id,amount) then
              LUNA.giveMoney(nuser_id,amount)
              LUNAclient.notify(player,{lang.money.given({amount})})
              LUNAclient.notify(nplayer,{lang.money.received({amount})})
            else
              LUNAclient.notify(player,{lang.money.not_enough()})
            end
          end)
        else
          LUNAclient.notify(player,{lang.common.no_player_near()})
        end
      else
        LUNAclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end

-- add player give money to main menu
LUNA.registerMenuBuilder("main", function(add, data)
  local user_id = LUNA.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}
    choices[lang.money.give.title()] = {ch_give, lang.money.give.description()}

    add(choices)
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
