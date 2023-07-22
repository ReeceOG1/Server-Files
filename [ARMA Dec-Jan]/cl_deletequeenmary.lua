hey guys this is how to delete big boats at rig

@TomDevCMG please use this when Kimber imports about 20 of em thanks

```lua
local function delQM2()
    local f = tARMA.getPlayerVehicle()
	local be = GetEntityModel(f)
    if GetHashKey("qm2") == be then
        DeleteEntity(f)
    end
end
tARMA.createArea("rig_delete_qm2",vector3(-1703.7, 8886.5, 28.7),300.0,250.0,delQM2,C,function()end)
```
