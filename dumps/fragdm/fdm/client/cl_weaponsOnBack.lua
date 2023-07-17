local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
}

local attached_weapons = {}
Citizen.CreateThread(function()
  while true do
      local me = cFDM.Ped()
      for _, v in pairs(FDMConfig.Weapons) do
          if HasPedGotWeapon(me, GetHashKey(v.hash), false) then
              if not attached_weapons[v.hash] and GetSelectedPedWeapon(me) ~= GetHashKey(v.hash) then
                  AttachWeapon(v.hash, GetHashKey(v.hash), SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(v.hash))
              end
          end
      end
      for name, attached_object in pairs(attached_weapons) do
          if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
      end
  Wait(0)
  end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(cFDM.Ped(), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, false, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end

  SetEntityCollision(attached_weapons[attachModel].handle, false, false)
  AttachEntityToEntity(attached_weapons[attachModel].handle, cFDM.Ped(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(hash)
    if hash == "prop_golf_iron_01" then
        return true
    elseif hash == "w_me_bat" then
        return true
    elseif hash == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end
