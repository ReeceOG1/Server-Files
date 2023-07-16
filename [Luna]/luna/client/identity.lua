local registration_number = "000AAA"

function tLUNA.setRegistrationNumber(registration)
  registration_number = registration
end

function tLUNA.getRegistrationNumber()
  return registration_number
end

-- function tLUNA.getUserID()
--   local player = GetPlayerServerId(-1)
--   return player
-- end
