local htmlEntities = module("lib/htmlEntities")

local cfg = module("cfg/cfg_identity")
local lang = GMT.lang

local sanitizes = module("cfg/sanitizes")

-- this module describe the identity system

-- init sql


MySQL.createCommand("GMT/get_user_identity","SELECT * FROM gmt_user_identities WHERE user_id = @user_id")
MySQL.createCommand("GMT/init_user_identity","INSERT IGNORE INTO gmt_user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)")
MySQL.createCommand("GMT/update_user_identity","UPDATE gmt_user_identities SET firstname = @firstname, name = @name, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
MySQL.createCommand("GMT/get_userbyreg","SELECT user_id FROM gmt_user_identities WHERE registration = @registration")
MySQL.createCommand("GMT/get_userbyphone","SELECT user_id FROM gmt_user_identities WHERE phone = @phone")
MySQL.createCommand("GMT/update_user_phone","UPDATE gmt_user_identities SET phone = @phone WHERE user_id = @user_id")



-- api

-- cbreturn user identity
function GMT.getUserIdentity(user_id, cbr)
    local task = Task(cbr)
    if cbr then 
        MySQL.query("GMT/get_user_identity", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then 
              task({rows[1]})
            else 
               task({})
            end
        end)
    else 
        print('Mis usage detected! CBR Does not exist')
    end
end

-- cbreturn user_id by registration or nil
function GMT.getUserByRegistration(registration, cbr)
  local task = Task(cbr)

  MySQL.query("GMT/get_userbyreg", {registration = registration or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

-- cbreturn user_id by phone or nil
function GMT.getUserByPhone(phone, cbr)
  local task = Task(cbr)

  MySQL.query("GMT/get_userbyphone", {phone = phone or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

function GMT.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
  local abyte = string.byte("A")
  local zbyte = string.byte("0")

  local number = ""
  for i=1,#format do
    local char = string.sub(format, i,i)
    if char == "D" then number = number..string.char(zbyte+math.random(0,9))
    elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
    else number = number..char end
  end

  return number
end

-- cbreturn a unique registration number
function GMT.generateRegistrationNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate registration number
    local registration = GMT.generateStringNumber("DDDLLL")
    GMT.getUserByRegistration(registration, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({registration})
      end
    end)
  end

  search()
end

-- cbreturn a unique phone number (0DDDDD, D => digit)
function GMT.generatePhoneNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate phone number
    local phone = GMT.generateStringNumber(cfg.phone_format)
    GMT.getUserByPhone(phone, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({phone})
      end
    end)
  end

  search()
end

-- events, init user identity at connection
AddEventHandler("GMT:playerJoin",function(user_id,source,name,last_login)
  GMT.getUserIdentity(user_id, function(identity)
    if identity == nil then
      GMT.generateRegistrationNumber(function(registration)
        GMT.generatePhoneNumber(function(phone)
          MySQL.execute("GMT/init_user_identity", {
            user_id = user_id,
            registration = registration,
            phone = phone,
            firstname = cfg.random_first_names[math.random(1,#cfg.random_first_names)],
            name = cfg.random_last_names[math.random(1,#cfg.random_last_names)],
            age = math.random(25,40)
          })
        end)
      end)
    end
  end)
end)

RegisterNetEvent("GMT:getIdentity")
AddEventHandler("GMT:getIdentity", function()
  local source = source
  local user_id = GMT.getUserId(source)
  if user_id ~= nil then
    GMT.getUserIdentity(user_id, function(identity)
      TriggerClientEvent('GMT:gotCurrentIdentity', source, identity['firstname'], identity['name'], identity['age'])
    end)
  end
end)

RegisterNetEvent("GMT:getNewIdentity")
AddEventHandler("GMT:getNewIdentity", function()
  local source = source
  local user_id = GMT.getUserId(source)
  if user_id ~= nil then
    GMT.prompt(source, 'First Name:', '', function(source,firstname)
      if firstname == '' then return end
      if string.len(firstname) >= 2 and string.len(firstname) < 50 then
        local firstname = sanitizeString(firstname, sanitizes.name[1], sanitizes.name[2])
       GMT.prompt(source, 'Last Name:', '', function(source, lastname)
          if lastname == '' then return end
          if string.len(lastname) >= 2 and string.len(lastname) < 50 then
            local lastname = sanitizeString(lastname, sanitizes.name[1], sanitizes.name[2])
            GMT.prompt(source, 'Age:', '', function(source,age)
              if age == '' then return end
              age = parseInt(age)
              if age >= 18 and age <= 150 then
                TriggerClientEvent('GMT:gotNewIdentity', source, firstname, lastname, age)
              else
                GMTclient.notify(source, {'Invalid age'})
              end
            end)
          else
            GMTclient.notify(source, {'Invalid Last Name'})
          end
        end)
      else
        GMTclient.notify(source, {'Invalid First Name'})
      end
    end)
  end
end)

MySQL.createCommand("GMT/set_identity","UPDATE gmt_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")


RegisterNetEvent("GMT:ChangeIdentity")
AddEventHandler("GMT:ChangeIdentity", function(first, second, age)
    local source = source
    local user_id = GMT.getUserId(source)
    if user_id ~= nil then
        if GMT.tryBankPayment(user_id,5000) then
            MySQL.execute("GMT/set_identity", {user_id = user_id, firstname = first, name = second, age = age})
            GMTclient.notifyPicture(source,{"CHAR_FACEBOOK",1,"GOV.UK",false,"You have purchased a new identity!"})
            TriggerClientEvent("gmt:PlaySound", source, 1)
        else
            GMTclient.notify(source,{"You don't have enough money!"})
        end
    end
end)


RegisterServerEvent("GMT:askId")
AddEventHandler("GMT:askId", function(nplayer)
  local player = source
  local nuser_id = GMT.getUserId(nplayer)
  if nuser_id ~= nil then
    GMTclient.notify(player,{'~g~Request sent.'})
    GMT.request(nplayer,"Do you want to give your ID card ?",15,function(nplayer,ok)
      if ok then
        GMT.getUserIdentity(nuser_id, function(identity)
          if identity then
            TriggerClientEvent('GMT:showIdentity', player, nplayer, true, identity.firstname, identity.name, '19/01/1990', identity.phone, '10/02/2015', '10/02/2025', {})
            TriggerClientEvent('GMT:setNameFields', player, identity.name, identity.firstname)
            GMT.request(player, "Hide the ID card.", 1000, function(player,ok)
              TriggerClientEvent('GMT:hideIdentity', player)
            end)
          end
        end)
      else
        GMTclient.notify(player,{"Request refused."})
      end
    end)
  else
    GMTclient.notify(player,{"No player near you."})
  end
end)