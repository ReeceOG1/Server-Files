function openGui()
    SetNuiFocus(false)
    SendNUIMessage({openNUI = true})
end
function closeGui()
    SetNuiFocus(false)
    SendNUIMessage({openNUI = false})
end
local a = 0
local b = 0
RegisterNetEvent("GMT:placeHeadBag")
AddEventHandler(
    "GMT:placeHeadBag",
    function()
        b = b + 1
        if b % 2 ~= 0 then
            local c = tGMT.getPlayerPed()
            a = CreateObject("prop_money_bag_01", 0, 0, 0, true, true, true)
            AttachEntityToEntity(
                a,
                c,
                GetPedBoneIndex(c, 12844),
                0.2,
                0.04,
                0,
                0,
                270.0,
                60.0,
                true,
                true,
                false,
                true,
                1,
                true
            )
            openGui()
        else
            DeleteEntity(a)
            closeGui()
        end
    end
)
