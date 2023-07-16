local a = {["demonhawkk"] = {1, 2}, ["hycadesupra"] = {1, 2}, ["customx6m"] = {1, 2}}
local function b(c)
	DisableControlAction(0, 32, true)
	DisableControlAction(0, 33, true)
	DisableControlAction(0, 34, true)
 	DisableControlAction(0, 35, true)
	DisableControlAction(0, 71, true)
   	DisableControlAction(0, 72, true)
	DisableControlAction(0, 87, true)
  	DisableControlAction(0, 88, true)
	DisableControlAction(0, 129, true)
	DisableControlAction(0, 130, true)
 	DisableControlAction(0, 107, true)
	DisableControlAction(0, 108, true)
	DisableControlAction(0, 109, true)
	DisableControlAction(0, 110, true)
	DisableControlAction(0, 111, true)
	DisableControlAction(0, 112, true)
	DisableControlAction(0, 170, true)
    SetVehicleRocketBoostPercentage(c, 0.0)
    BeginTextCommandThefeedPost("STRING")
    drawNativeText("This vehicle is locked biometrically to the owner.")
    EndTextCommandThefeedPostTicker(false, false)
end
local function d()
    local c, e = tLUNA.getPlayerVehicle()
    local f = tLUNA.getUserId()
    if c ~= 0 and e then
        local g = GetEntityModel(c)
        for d, h in pairs(a) do
            if GetHashKey(d) == g then
                local i = false
                for j, k in pairs(h) do
                    if k == f then
                        i = true
                        break
                    end
                end
                if not i then
                    b(c)
                end
                return
            end
        end
    end
end
tLUNA.createThreadOnTick(d)