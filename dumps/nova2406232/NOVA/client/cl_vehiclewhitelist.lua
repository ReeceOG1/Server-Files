local h = {
    ["demonhawkk"] = {4},
    ["clavish"] = {1},
}
local function i(j)
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
    drawNativeText("This vehicle is locked biometrically to the owner.")
	SetVehicleMaxSpeed(getPlayerVehicle(), 0)
    SetVehicleRocketBoostPercentage(j, 0.0)
end
local function k()
    local j, l = getPlayerVehicle()
    local m = tNOVA.getUserId()
    if j ~= 0 and l and not tNOVA.isDeveloper(m) then
        local e = GetEntityModel(j)
        for k,v in pairs(h) do
            if GetHashKey(k) == e then
                local o = false
                for f, p in pairs(v) do
                    if p == m then
                        o = true
                        break
                    end
                end
                if not o then
                    i(j)
                end
                return
            end
        end
    end
end
createThreadOnTick(k)