local webhooks = {
    -- general
    ['join'] = 'https://discord.com/api/webhooks/1108461529428398230/-YiK0CiaCYYp6zbQxU6W7gVvaWIDA4e8BB2AXkXSL7k7dHRemhCrvsKVZpp-PR0KB1nU',--done
    ['leave'] = 'https://discord.com/api/webhooks/1108466295718023220/PSUGxQWTrCZ38mNWm8QjvCNC5owh8EsWNie70e5-v78GnZHkvDVfEMpKD-VFnoY4FPT1',--done
    -- civ
    ['give-cash'] = 'https://discord.com/api/webhooks/1108461796542660700/r4aDI71I-gQ4K9ttmGexZbiw4HJHBtUTkGQxZMrQ5UC_Nuw1xlWfk7RbQQfbU545XmpI', --done
    ['bank-transfer'] = 'https://discord.com/api/webhooks/1108461936024223865/VOocAR8K1VoVM7AJU8JiOHLYQhTwlc0bkddq0ObrvCB9JAdTDRA2Ud0auIlwlC6k-XKm', --done
    ['search-player'] = 'https://discord.com/api/webhooks/1108462142711144489/aVJeTw57kkqIevI_MjDi8a3Ll_SmhMP2M2QV7kiWz5qXBamZWg1NeVrK4QIjRchCd-7U', --done
    ['ask-id'] = 'https://discord.com/api/webhooks/1108462258918539345/dfrYlD1PloisILOWbCXfVjJzOYgM41cyLx-NG7i6AohDPawS5Ux_R4_AJaRgnJA-MxXV',--done
    -- chat
    ['ooc'] = 'https://discord.com/api/webhooks/1108462603447046184/Jq96VrotgM8WTJxElneSp7-mJ_lZS7ZsKGT11UJbUttfMsgRiuLzHkRXOkNbT7z6fhvc', --done
    ['twitter'] = 'https://discord.com/api/webhooks/1108462671478669412/BkLKllCqzLvxebAVFS1bD4-WmpKpM4GnhIzK42FC00RL0NHemxeajOPbTcisWkEKB-_f', --done
    ['staff'] = 'https://discord.com/api/webhooks/1108462729074835476/RbIHZy0l3m77nQMmM6dEfsEXQHUZsGmZud3HH9o_i8ajQPEUFCgHVntDHKvC2mJAYOT-',--done
    ['gang'] = 'https://discord.com/api/webhooks/1108462772867575850/HAduSvDu89XdlKrjHysrXepjeHLuA9gJIvmxeqrQWK5CBwFQmNZuBbPMRdPf2oTcVxmF',--done
    ['anon'] = 'https://discord.com/api/webhooks/1108462816035360939/5pDEYVk-GoiV-81qzQQ4ZP3xb-_im_7H9FE00-JM8dy5WYTN5n-xRhxramzhMJyHxZZN', --done
    -- admin menu
    ['kick-player'] = 'https://discord.com/api/webhooks/1008323584965488640/8xzRmmBRtfwgLWtl17BqIgC51yQtp2WZ8funcNQsD2aJfcBOpIykYKMwTnA7qV_j3cSO', --done --done
    ['ban-player'] = 'https://discord.com/api/webhooks/1008323225157115964/bfq5GL9-GsQZTX3UYW35Y-11kIxmArjmL1Aw_WHMR0Nf5M07OYYay2sFVDxFw4kh0xrI', --done
    ['spectate'] = 'https://discord.com/api/webhooks/1108463366286102580/rnyCwQVZStlH4CgMp5klGiiErcewOzbBNwiG__ZKzFMrgRr1FMw6QxQIzV3V9E605TdB', --done
    ['revive'] = 'https://discord.com/api/webhooks/1008323911978586172/XMP5TMqsuqbZpaB8S1OBP7iXOeJ7-Yi3WEovxhuNFVBSMuLXB4QVdoTqrnaNJEQ7R2kf', --done
    ['tp-player-to-me'] = 'https://discord.com/api/webhooks/1108463954306551818/y5YA83Sh7QXxwtl7Dvk4AeQacc4l3LVCLkcpXLPLCo_snKT2dhAnBYHbQznzUYYPJes3', --done
    ['tp-to-player'] = 'https://discord.com/api/webhooks/1008324169731145759/TBS40RYQnqnd9xiQ8QR0fyaDm-5dOZGQhLTldwW8W68j6zMwfsSGcKJE7xxlZsrvUOPF', --done
    ['tp-to-admin-zone'] = 'https://discord.com/api/webhooks/1108464100213788857/ib0aSAETMT3HI5mE-ZpjbCL-IpKTeQ41fPFHQ4g2eSaXV7HM8vUy5eMezZhbsfoBSV9C', --done
    ['tp-back-from-admin-zone'] = 'https://discord.com/api/webhooks/1108464214491803669/-UqnJyLF_OZ7XnWWMvhhYg44PaigO_qBkbouc_G3wlGpRUV3UG3RiO0JapzI3Xe19VGW', --done
    ['tp-to-legion'] = 'https://discord.com/api/webhooks/1108464321937289256/1xkwpl6-QO1escA_daMVUh3X7RcPnHxCcvvTbqqFxble2tKWwiHoD7Jq0ak4x2dbkozr', --done
    ['freeze'] = 'https://discord.com/api/webhooks/1008323962008252437/msv-5VGMrTs7uR0HQZVkAuikLB-zpcOWASfsNhPd1SUbl3VKpID9sbSkBQS3ziFTeHFW', --done
    ['slap'] = 'https://discord.com/api/webhooks/1008323809981517854/nBKxjEjvJTohrUyJ_TySQLGrteMxy5Tal4bLNS4GoxVvkEN2pfSlHzwWuRYGqwhImTey', --done
    ['force-clock-off'] = 'https://discord.com/api/webhooks/1108464585465405592/gG-31sdIl8Y3wHEeFJF9JcswTj9DmHLf4fhEhLfEP4_AxVsmwNvF3vZgmsHjBv_xhTuv', --done
    ['screenshot'] = 'https://discord.com/api/webhooks/1108464717107826699/sb6rQIJWpSf2kyV9szGMLz2lgZq4uduHnm6yeUz3eYOcQmWrkT5bPCafXYfV-tEFDwDX', --done
    ['video'] = 'https://discord.com/api/webhooks/1008322566315847843/6Xa6YJtJuxYfM7q7mw1q89wx5wHbXD0l1VrN5mT2YpoN2vNeEdW2k7vSsjBSqL024w6S', --done
    ['group'] = 'https://discord.com/api/webhooks/1008322877373829291/c_TfJeea5HHPmyjlUwGgsuuIsKsnFBiP4ih_01f-Imk3T6EVYw7JrTuXEcrojRDN9fla', --done
    ['unban-player'] = 'https://discord.com/api/webhooks/1008322621802283068/tMcYscXRtcT5y7KehUeG10_b5B1zoX25QECeM-y7okZUAdPiK5q7fY-ANZERq6VjnX8u', --done
    ['remove-warning'] = 'https://discord.com/api/webhooks/1008322778459541545/0CroTCPt-FG2bl94E2IR3Y-LIB6WVVrnhMzEyasBfkx0EFNDVOyXPbM3Tp-Lxxi9mJkR', --done
    ['add-car'] = 'https://discord.com/api/webhooks/1008323032990888016/Rv8-HiM-bPXXas2yqQEuBbGFTpvcJGobNfw8tOowW0UCs8xnVAGJempzl9QpOqY7tHvM', --done
    ['manage-balance'] = 'https://discord.com/api/webhooks/1008322951843684373/jK--mJ9OCCsqkjq2HQZXLJLzTUM0LQLy5WA_udObY2l4qpY3B9XFJrvx4znbsGwqncHI', --done
    ['ticket-logs'] = 'https://discord.com/api/webhooks/1008323373769707582/5_PPI3UAB-YSBGPN30zlOTkaj7jfK8P4cSTZA16gOu7hU3BvIppPpKCSckMN-nVEfITO',
    ['com-pot'] = 'https://discord.com/api/webhooks/1008323760354492477/44ENXQSueikMq5YcRSxuawK9RRClw0zr7utWFD26_NpydtA8ZIYc05T2dtr-RVNuiShe', --done
    -- vehicles
    ['crush-vehicle'] = 'https://discord.com/api/webhooks/1108465861934727198/yBRAIhy4gxzXDP8ZMhjpyQ0xCoP98CAIpDwo435dTjFiQXWb4EqVR7NQO7gIgBfg6_u4', --done
    ['rent-vehicle'] = 'https://discord.com/api/webhooks/1108465946626113578/0d5q5q4MOZvcgWvbheHi-CJh__x-xo5gNE6PuLWW8H3nBnP2GIMZis68iWNl1FNk-B4v', --done
    ['sell-vehicle'] = 'https://discord.com/api/webhooks/1108466024661143592/-sTvHbi6JbbHgzPXA9aCQaNkBjBm7WJud4LMAoWEkwWXDMk-9L27L-xOLSjhYVyF_ojC', --done 
    -- mpd
    ['pd-clock'] = 'https://discord.com/api/webhooks/1108467050466254878/KqXBuTGz1mg_hYHuKtcnqzqNkWlWAXTXEvTo_Slqb-5fh8i0QqBAokF3qRBo3KxV393a',--done
    ['pd-afk'] = 'https://discord.com/api/webhooks/1108467110893588620/wcdFJOZiF1tsNKR2VCwgZEVErPjGRFwZxF8colK97RNjH3bfth9oWbbda0J5ZhEfBmUd',--done
    ['pd-armoury'] = 'https://discord.com/api/webhooks/1108467190971244554/2MmIkqP3Vk06XDcpcK3Sb56LXizQy9B7hj5gTfan8y9v0j5Wir-Cl3MA8w40ezZJNJsY',--done
    ['fine-player'] = 'https://discord.com/api/webhooks/1108467280607707136/LxH5uD4o6KaZaEJMoTcz1mLnkcy-OLr6PDEb_qDHqStzAgVsjWtWeTCCwYI-m6aAadN2',--done
    ['jail-player'] = 'https://discord.com/api/webhooks/1108467361436160050/puJtRs8kzaw47xAVbnz5CfDatmkh6EIoagq2JDIa8xupcOAsZOG_SqawtyXBVCmBFO0N',--done
    ['pd-panic'] = 'https://discord.com/api/webhooks/1108467429882990592/-vNyA1oqLdsOcKIKe9ibnsogna1R5ioSSDJOgSLKbaJcsW_coab5jgGys7KlFOo0eKj0',--done
    ['seize-boot'] = 'https://discord.com/api/webhooks/1108468559765569609/07aNGAr0EVRH5JOoXFGDcKbj3ZO0yKYpPDYejp3AiYkMr423p-oNeXAcJCnYWmJLFADQ',--done
    ['impound'] = 'https://discord.com/api/webhooks/1108468623586119720/RSWX0y2HkyYl1n53yzX6PgM49L2O6tDPdNsspBEvl4_G0trtKe0w5OsqiIs_aqT2Nlqw',--done
    ['police-k9'] = 'https://discord.com/api/webhooks/1108468700455112775/9Dv1EVvPlUvpgXaCBCY3slg5-Jql9-PaUMMkEos7odAGlULSzw1TZTbzjoGe50qYRXgq',--done
    -- nhs
    ['nhs-clock'] = 'https://discord.com/api/webhooks/1108468805090431037/r5vZI8vD8GCuNBbAXMF4wKxuZsgf5hQzTWbMAwZy6bODn8IUqqzj-ANQYZRyZYKbJ8IL',--done
    ['nhs-panic'] = 'https://discord.com/api/webhooks/1108468860925001798/JOIeK69i9NxqdpIZ-MUk2RUwzL4MgTU8vTdL6FmL6gF3sn4AJPs3t5OkLmBIMvBaoNwy',--done
    ['nhs-afk'] = 'https://discord.com/api/webhooks/1108468919104196679/JVgoQ6UzBBEgi4wJq_tGioiexiob3WKKES5JneDsQ79Dpe5zeBKntAlEkZOzQHAl41Lw',--done
    ['cpr'] = 'https://discord.com/api/webhooks/1108468978118045807/I82KF5kLCgk5zkDVP-waI6AJ5TFkaFw4W5Jj_xRM8-7Qe3rpC6O4KARblkvlfXyPQ9nW',--done
    -- licenses
    ['purchases'] = 'https://discord.com/api/webhooks/1108469129238818886/aR3Wd7Id2ubieAF10aTBu6A_eWyW1ORbPDv4jM7qRdhC6lBawbrivwHUGXHagrBB_RKL', --done
    ['sell-to-nearest-player'] = 'https://discord.com/api/webhooks/1108469200458108928/svGQiaVDp_kHFwOJysbES10cYoT9NL2WaOruNz8yXFb_Y-HlY9uTYKRu7qTtOIDPcNGQ', --done
    -- casino
    ['blackjack-bet'] = 'https://discord.com/api/webhooks/1108469296432164915/BPUGSr1jv12tnQsWXThWkiKzM6ZPgAo2SZrBi7lOqxhDSYG21sKcyA7Fon1pTHXtgFuk', --done 
    ['coinflip-bet'] = 'https://discord.com/api/webhooks/1108469349557227560/aXkryWqfkWsb-8iLwOM7o-m1xlbyf1pHk0v5naxE8PPPLMjyBYgU8SNnbifzJHh8w5oH', --done 
    ['purchase-chips'] = 'https://discord.com/api/webhooks/1108469406624907394/Bd9R39RuJbt347589rPY8OO1jwo6uof3JMYEJnLwm0cghe-cB05F3Mx-0Sho7AZwIEXF', --done 
    ['sell-chips'] = 'https://discord.com/api/webhooks/1108469471317868595/SSqLhgYifFcfgFm1nuVkA0SreE7BgtcUyzAJKbizWpqCHHTHNPreCjuy8Jm57ZjayNxY', --done 
    ['purchase-highrollers'] = 'https://discord.com/api/webhooks/1108469551408095302/b9PBT3uiXuC8XSLu2L0-WscOCM96BtsFMG4z0LYoXiuK1SsGPHMWh3kDL0rw6_XaQV_R', --done 
    -- weapon shops
    ['weapon-shops'] = 'https://discord.com/api/webhooks/1108469661235949568/THRwG88ESnpuf4rmFGEzx2nbSV3EYtjECMC0Gy_UmaVXWdeXfPQY2BMsrF-C4V4LAue3', --done 
    -- housing (no logs atm)
    [''] = '',
    -- anticheat
    ['anticheat'] = 'https://discord.com/api/webhooks/1108469818526531665/THJI35068wPTAHodjyTxQtaFPtFrl-qK85CfvXSWGevsCwBjrxSj1HmEEXMI3REpZzoH', --done
    ['ban-evaders'] = 'https://discord.com/api/webhooks/1108469909060583424/UJV2RvFqJVj1ZLDnjEtJtwAXJdV-nc3Q3bqwyMil6ejutF6_XbP6W8sOmnKyQONjaNnf', --done
    -- dono
    ['donation'] = 'https://discord.com/api/webhooks/1108470085678551072/RA-kFbwEWssqKq5HOfZYvTiemUNvGGnCt-bxgP68UwckRoyaq-nxAOLcZdUdB6Yk4zZf', -- done
    -- general
    ['tutorial'] = 'https://discord.com/api/webhooks/1108470175763800095/Upw_UUozcfbtWMzqU-L4Lwa2SczdaWjzAHWMegArdprt3PVNI9nD8XzwX_F9jfL_Apwc', -- done
    ['feedback'] = 'https://discord.com/api/webhooks/1114670524606455868/Gqoeq7hT1uCdF84s4547entyMwI45F8PZzEzB7-dBLxaQ_nPCH85aN4RNJ8kmLoR2sR3', -- done
}

local webhookQueue = {}
Citizen.CreateThread(function()
    while true do
        if next(webhookQueue) then
            for k,v in pairs(webhookQueue) do
                Citizen.Wait(100)
                if webhooks[v.webhook] ~= nil then
                    PerformHttpRequest(webhooks[v.webhook], function(err, text, headers) 
                    end, "POST", json.encode({username = "GMT Logs", avatar_url = 'https://cdn.discordapp.com/icons/995069542852202557/579fe666d0f4c3c077c360a9a6db95e3.webp?size=512', embeds = {
                        {
                            ["color"] = 0x60d1f6,
                            ["title"] = v.name,
                            ["description"] = v.message,
                            ["footer"] = {
                                ["text"] = "GMT Server #1 - "..v.time,
                                ["icon_url"] = "",
                            }
                    }
                    }}), { ["Content-Type"] = "application/json" })
                end
                webhookQueue[k] = nil
            end
        end
        Citizen.Wait(0)
    end
end)
local webhookID = 1
function tGMT.sendWebhook(webhook, name, message)
    webhookID = webhookID + 1
    webhookQueue[webhookID] = {webhook = webhook, name = name, message = message, time = os.date("%c")}
end

function GMT.sendWebhook(webhook, name, message) -- used for other resources to send through webhook logs 
   tGMT.sendWebhook(webhook, name, message)
end

function tGMT.getWebhook(webhook)
    if webhooks[webhook] ~= nil then
        return webhooks[webhook]
    end
end