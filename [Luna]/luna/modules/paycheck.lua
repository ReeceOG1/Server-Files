local cfg = module("cfg/paychecks")
local paychecks = cfg.paychecks
local playersPaid = {}

Citizen.CreateThread(function() 
	while true do
		local players = LUNA.rusers
		for i=1, #paychecks do 
			local paycheck = paychecks[i]
			for k,v in pairs(players) do
				for i=1, #paycheck.permissions do 
					if LUNA.hasPermission(k, paycheck.permissions[i]) then 
						if not playersPaid[k] then 
							local source = LUNA.getUserSource(k)
							LUNA.giveBankMoney(k, paycheck.paycheck)
							LUNAclient.notifyPicture(source,{"CHAR_BANK_MAZE",1,paycheck.name,false,"~g~Payday: £"..paycheck.paycheck})
							playersPaid[k] = true
						end
						break
					end
				end
			end
		end
		playersPaid = {}
		Citizen.Wait(cfg.interval)
	end
end)