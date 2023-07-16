--[[local a = module("cfg/cfg_guntrader")
local b = {}
local c = nil
RMenu.Add(
    "FRGunTrader",
    "main",
    RageUI.CreateMenu("", "", tFR.getRageUIMenuWidth(), tFR.getRageUIMenuHeight(), "banners", "gunstore")
)
RMenu:Get("FRGunTrader", "main"):SetSubtitle("~b~FR Weapon Trader")
RMenu.Add(
    "FRGunTrader",
    "guns",
    RageUI.CreateSubMenu(
        RMenu:Get("FRGunTrader", "main"),
        "",
        "",
        tFR.getRageUIMenuWidth(),
        tFR.getRageUIMenuHeight()
    )
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        RageUI.IsVisible(
            RMenu:Get("FRGunTrader", "main"),
            true,
            true,
            true,
            function()
                for d, e in pairs(b) do
                    if a.sellableCategories[d] then
                        for f, g in pairs(e) do
                            if f == "_config" then
                                RageUI.ButtonWithStyle(
                                    g[4],
                                    "Sell weapons bought from " .. g[4],
                                    {RightLabel = "→→→"},
                                    true,
                                    function(h, i, j)
                                        if j then
                                            c = d
                                            RMenu:Get("FRGunTrader", "guns"):SetSubtitle("~b~" .. g[4] .. " Weapons")
                                        end
                                    end,
                                    RMenu:Get("FRGunTrader", "guns")
                                )
                            end
                        end
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("FRGunTrader", "guns"),
            true,
            true,
            true,
            function()
                for d, e in pairs(b) do
                    if d == c then
                        for f, g in pairs(e) do
                            if f ~= "_config" and not string.find(g[1], "Armour") then
                                RageUI.ButtonWithStyle(
                                    g[1],
                                    "Sell back for £" .. getMoneyStringFormatted(g[2] * a.refundPercentage),
                                    {RightLabel = "→→→"},
                                    true,
                                    function(h, i, j)
                                        if j then
                                            TriggerServerEvent("FR:gunTraderSell", d, f)
                                        end
                                    end
                                )
                            end
                        end
                    end
                end
            end,
            function()
            end
        )
    end
)
CreateThread(
    function()
        tFR.createDynamicPed(
            a.pedModel,
            a.pedPosition,
            a.pedHeading,
            true,
            "mini@strip_club@idles@bouncer@base",
            "base",
            75.0,
            nil,
            function(d)
                SetEntityCanBeDamaged(d, 0)
                SetPedAsEnemy(d, 0)
                SetBlockingOfNonTemporaryEvents(d, 1)
                SetPedResetFlag(d, 249, 1)
                SetPedConfigFlag(d, 185, true)
                SetPedConfigFlag(d, 108, true)
                SetPedCanEvasiveDive(d, 0)
                SetPedCanRagdollFromPlayerImpact(d, 0)
                SetPedConfigFlag(d, 208, true)
                SetEntityCollision(d, false)
                SetEntityCoordsNoOffset(d, a.pedPosition.x, a.pedPosition.y, a.pedPosition.z, a.pedHeading, 0, 0)
                SetEntityHeading(d, a.pedHeading)
                FreezeEntityPosition(d, true)
            end
        )
        local k = function(l)
            RageUI.ActuallyCloseAll()
            c = nil
            RageUI.Visible(RMenu:Get("FRGunTrader", "main"), true)
        end
        local m = function(l)
            RageUI.ActuallyCloseAll()
            RageUI.Visible(RMenu:Get("FRGarages", "main"), false)
        end
        local n = function(l)
        end
        tFR.createArea("weapontrader", a.location, 1.5, 6, k, m, n, {})
        local o = a.location
        tFR.addBlip(o.x, o.y, o.z, 110, 1, "Weapon Trader", 0.7, false)
        tFR.addMarker(o.x, o.y, o.z, 0.7, 0.7, 0.5, 255, 0, 0, 125, 50, 27, true)
        local p = AddBlipForRadius(o.x, o.y, o.z, 35.0)
        SetBlipColour(p, 44)
        SetBlipAlpha(p, 180)
    end
)
RegisterNetEvent("FR:receiveFilteredGunStoreData")
AddEventHandler(
    "FR:receiveFilteredGunStoreData",
    function(q)
        b = q
        table.sort(
            b,
            function(r, s)
                return r._config[4] < s._config[4]
            end
        )
    end
)]]
