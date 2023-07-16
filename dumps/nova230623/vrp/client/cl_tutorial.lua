local a = false
local b = false
local c = vector3(-1039.2645263672,-2740.3603515625,13.868202209473)
local d = ""
local f = nil
local g = 0
local h = "prop_amb_phone"
local i = 0
local j = "out"
local k = nil
local l = nil
local m = false
local n = {
    ["cellphone@"] = {
        ["out"] = {["text"] = "cellphone_text_in", ["call"] = "cellphone_call_listen_base"},
        ["text"] = {["out"] = "cellphone_text_out", ["text"] = "cellphone_text_in", ["call"] = "cellphone_text_to_call"},
        ["call"] = {
            ["out"] = "cellphone_call_out",
            ["text"] = "cellphone_call_to_text",
            ["call"] = "cellphone_text_to_call"
        }
    },
    ["anim@cellphone@in_car@ps"] = {
        ["out"] = {["text"] = "cellphone_text_in", ["call"] = "cellphone_call_in"},
        ["text"] = {["out"] = "cellphone_text_out", ["text"] = "cellphone_text_in", ["call"] = "cellphone_text_to_call"},
        ["call"] = {
            ["out"] = "cellphone_horizontal_exit",
            ["text"] = "cellphone_call_to_text",
            ["call"] = "cellphone_text_to_call"
        }
    }
}
local function o()
    if g ~= 0 then
        DeleteEntity(g)
        g = 0
    end
end
local function p()
    o()
    loadModel(h)
    g = CreateObject(h, 1.0, 1.0, 1.0, 1, 1, 0)
    local q = GetPedBoneIndex(getPlayerPed(), 28422)
    AttachEntityToEntity(g, getPlayerPed(), q, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    SetModelAsNoLongerNeeded(h)
end
local function r(s, t, u)
    if j == s and u ~= true then
        return
    end
    f = getPlayerPed()
    local t = t or false
    local v = "cellphone@"
    if IsPedInAnyVehicle(f, false) then
        v = "anim@cellphone@in_car@ps"
    end
    loadAnimDict(v)
    local w = n[v][j][s]
    if j ~= "out" then
        StopAnimTask(f, k, l, 1.0)
    end
    local x = 50
    if t == true then
        x = 14
    end
    TaskPlayAnim(f, v, w, 3.0, -1, -1, x, 0, false, false, false)
    RemoveAnimDict(v)
    if s ~= "out" and j == "out" then
        Citizen.Wait(380)
        p()
    end
    k = v
    l = w
    m = t
    j = s
    if s == "out" then
        Citizen.Wait(180)
        o()
        StopAnimTask(f, k, l, 1.0)
    end
end
Citizen.CreateThread(function()
    if true then 
        Wait(10000)
        TriggerServerEvent("NOVA:checkTutorial")
    end 
end)
RegisterCommand("tutorial", function()
    TriggerServerEvent("NOVA:checkTutorial")
end)
RegisterNetEvent("NOVA:playTutorial",function()
        i = 1
        DoScreenFadeOut(500)
        NetworkFadeOutEntity(getPlayerPed(), true, false)
        Wait(5000)
        SetEntityCoords(getPlayerPed(), -1039.2645263672,-2740.3603515625,13.868202209473)
        FreezeEntityPosition(getPlayerPed(), true)
        SetEntityHeading(getPlayerPed(), 146.0)
        Citizen.Wait(5000)
        FreezeEntityPosition(getPlayerPed(), false)
        NetworkFadeInEntity(getPlayerPed(), 0)
        DoScreenFadeIn(3000)
        initializeTutorial()
    end
)
function initializeTutorial()
    local B = GetEntityCoords(getPlayerPed())
    local C = #(c - B)
    while C > 5.0 do
        C = #(c - GetEntityCoords(getPlayerPed()))
        Wait(100)
    end
    a = true
    initializeTutorialScaleform()
    while not b do
        C = #(c - GetEntityCoords(getPlayerPed()))
        if C < 3.0 then
            a = true
        else
            a = false
        end
        Wait(100)
    end
end
Citizen.CreateThread(
    function()
        while true do
            if a then
                if IsControlJustPressed(0, 38) then
                    a = false
                    b = true
                    beginTutorial()
                end
            end
            if i == 1 then
                local D = PlayerPedId()
                if GetSelectedPedWeapon(D) ~= "WEAPON_UNARMED" then
                    drawNativeNotification("Your weapon has been stored. You must complete the tutorial first by doing /tutorial.")
                end
                tvRP.setWeapon(D, "WEAPON_UNARMED", true)
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if b then
                drawTxttutorial(d, 7, 1, 0.5, 0.8, 0.6, 50, 205, 50, 205)
            end
            Wait(0)
        end
    end
)
function initializeTutorialScaleform()
    Citizen.CreateThread(
        function()
            function Initialize(scaleform)
                local scaleform = RequestScaleformMovie(scaleform)
                while not HasScaleformMovieLoaded(scaleform) do
                    Citizen.Wait(0)
                end
                BeginScaleformMovieMethod(scaleform, "SET_MISSION_INFO")
                ScaleformMovieMethodAddParamTextureNameString("NOVA TUTORIAL")
                ScaleformMovieMethodAddParamTextureNameString("~g~Welcome to NOVA")
                ScaleformMovieMethodAddParamTextureNameString("0")
                ScaleformMovieMethodAddParamTextureNameString("")
                ScaleformMovieMethodAddParamTextureNameString("")
                ScaleformMovieMethodAddParamTextureNameString("")
                ScaleformMovieMethodAddParamTextureNameString("")
                ScaleformMovieMethodAddParamTextureNameString("0")
                ScaleformMovieMethodAddParamTextureNameString("0")
                ScaleformMovieMethodAddParamTextureNameString("~g~Press [E] begin!")
                EndScaleformMovieMethod()
                return scaleform
            end
            scaleform = Initialize("mp_mission_name_freemode")
            while true do
                if not b and a then
                    local E = 0.5
                    local F = 0.35
                    local G = 0.3
                    local H = G / 0.65
                    DrawScaleformMovie(scaleform, E, F, G, H)
                end
                Wait(0)
            end
        end
    )
end
function initializeEndTutorial()
    Citizen.CreateThread(
        function()
            function Initialize(scaleform)
                local scaleform = RequestScaleformMovie(scaleform)
                while not HasScaleformMovieLoaded(scaleform) do
                    Citizen.Wait(0)
                end
                BeginScaleformMovieMethod(scaleform, "SET_MISSION_INFO")
                ScaleformMovieMethodAddParamTextureNameString(
                    "Press F1 for a quick starter guide and the rules to our server!"
                )
                ScaleformMovieMethodAddParamTextureNameString("~g~Tutorial Complete")
                ScaleformMovieMethodAddParamTextureNameString("0")
                ScaleformMovieMethodAddParamTextureNameString("")
                ScaleformMovieMethodAddParamTextureNameString("")
                ScaleformMovieMethodAddParamTextureNameString("")
                ScaleformMovieMethodAddParamTextureNameString("")
                ScaleformMovieMethodAddParamTextureNameString("0")
                ScaleformMovieMethodAddParamTextureNameString("0")
                ScaleformMovieMethodAddParamTextureNameString("")
                EndScaleformMovieMethod()
                return scaleform
            end
            scaleform = Initialize("mp_mission_name_freemode")
            while b do
                local E = 0.5
                local F = 0.35
                local G = 0.3
                local H = G / 0.65
                DrawScaleformMovie(scaleform, E, F, G, H)
                Wait(0)
            end
        end
    )
end
function beginTutorial()
    TriggerEvent("vrp:PlaySound", "ring")
    Wait(2000)
    r("text")
    Wait(6000)
    r("call")
    TriggerEvent("vrp:PlaySound", "herewegoagain")
    Wait(7000)
    r("out")
    TriggerEvent("NOVARP:Announce", "FOLLOW THE YELLOW MARKERS!")
    cc1 =CreateCheckpoint(1,-1040.8200683594,
        -2742.2243652344,
        12.5,
        -1054.2639160156,
        -2766.0249023438,
        3.0,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = "Yo welcome brother Im CJ and Im gonna help you settle in"
    local I = 20
    while I >= 3 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-1040.8200683594, -2742.2243652344, 12.5))
        Wait(100)
    end
    DeleteCheckpoint(cc1)
    cc2 =
        CreateCheckpoint(
        1,
        -1054.2639160156,
        -2766.0249023438,
        3.0,
        -1032.3704833984,
        -2773.8217773438,
        3.0,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = "You are at Heathrow Airport make your way to the tube station and get on the damn tube"
    I = 20
    while I >= 3 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-1054.2639160156, -2766.0249023438, 3.0))
        Wait(100)
    end
    DeleteCheckpoint(cc2)
    cc3 =
        CreateCheckpoint(
        1,
        -1032.3704833984,
        -2773.8217773438,
        3.0,
        -1014.4043579102,
        -2752.3588867188,
        -0.5,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = "You can get your phone up by pressing [K] and close it with [BACKSPACE]"
    I = 20
    while I >= 3 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-1032.3704833984, -2773.8217773438, 3.0))
        Wait(100)
    end
    DeleteCheckpoint(cc3)
    cc4 =
        CreateCheckpoint(
        1,
        -1014.4043579102,
        -2752.3588867188,
        -0.5,
        -1061.8685302734,
        -2717.7609863282,
        -0.5,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = "You can open your Inventory with [L] and close it with [L]"
    I = 20
    while I >= 3 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-1014.4043579102, -2752.3588867188, -0.5))
        Wait(100)
    end
    DeleteCheckpoint(cc4)
    cc5 =
        CreateCheckpoint(
        1,
        -1061.8685302734,
        -2717.7609863282,
        -0.5,
        -1075.8397216796,
        -2728.1538085938,
        -0.5,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = "Follow the markers to get on the damn tube!"
    I = 20
    while I >= 3 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-1061.8685302734, -2717.7609863282, -0.5))
        Wait(100)
    end
    DeleteCheckpoint(cc5)
    cc6 =
        CreateCheckpoint(
        1,
        -1075.8397216796,
        -2728.1538085938,
        -0.5,
        -1080.8995361328,
        -2715.8703613282,
        -0.5,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = ""
    TriggerEvent("vrp:PlaySound", "tubearriving")
    I = 20
    while I >= 3 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-1075.8397216796, -2728.1538085938, -0.5))
        Wait(100)
    end
    DeleteCheckpoint(cc6)
    cc7 =
        CreateCheckpoint(
        1,
        -1080.8995361328,
        -2715.8703613282,
        -0.5,
        -1063.7435302734,
        -2699.1303710938,
        -9.4100732803344,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = "Hurry up fool!"
    I = 20
    while I >= 3 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-1080.8995361328, -2715.8703613282, -0.5))
        Wait(100)
    end
    DeleteCheckpoint(cc7)
    cc8 =
        CreateCheckpoint(
        45,
        -1063.7435302734,
        -2699.1303710938,
        -8.4100732803344,
        -1063.7435302734,
        -2699.1303710938,
        -8.4100732803344,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = ""
    I = 20
    while I >= 3 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-1063.7435302734, -2699.1303710938, -9.4100732803344))
        Wait(100)
    end
    DeleteCheckpoint(cc8)
    TriggerEvent("vrp:PlaySound", "tubeleaving")
    DoScreenFadeOut(2000)
    NetworkFadeOutEntity(getPlayerPed(), true, false)
    Wait(5000)
    SetEntityCoords(getPlayerPed(), 99.8304977417, -1711.280883789, 30.113786697388)
    SetEntityHeading(getPlayerPed(), 200.0)
    NetworkFadeInEntity(getPlayerPed(), 0)
    TriggerEvent("vrp:PlaySound", "tubearriving")
    DoScreenFadeIn(3000)
    d = "I called a taxi for you"
    Wait(2000)
    local J = loadModel("taxi")
    d = "Oh shit looks like he had to run It should be parked pretty close"
    Wait(5000)
    d = "Get in the taxi and make your way to the Job Centre a waypoint has been set on your GPS"
    SetTimeout(
        5000,
        function()
            d = ""
        end
    )
    math.randomseed(GetGameTimer())
    local K = math.random(1, 7)
    if K == 1 then
        tempTaxi = CreateVehicle(J, 95.41603088379, -1727.3582763672, 28.85818862915, 50, 1, 0)
        DecorSetInt(tempTaxi, "NOVARPACVehicle", 955)
        cc7 =
            CreateCheckpoint(
            1,
            95.41603088379,
            -1727.3582763672,
            28.85818862915,
            -515.47406005859,
            -264.78549194336,
            34.403575897217,
            2.0,
            204,
            204,
            1,
            100,
            0
        )
    elseif K == 2 then
        tempTaxi = CreateVehicle(J, 94.067138671875, -1740.6694335938, 29.305875778198, 320, 1, 0)
        DecorSetInt(tempTaxi, "NOVARPACVehicle", 955)
        cc7 =
            CreateCheckpoint(
            1,
            94.067138671875,
            -1740.6694335938,
            28.305875778198,
            -515.47406005859,
            -264.78549194336,
            34.403575897217,
            2.0,
            204,
            204,
            1,
            100,
            0
        )
    elseif K == 3 then
        tempTaxi = CreateVehicle(J, 96.752075195312, -1745.4302978516, 29.315612792968, 320, 1, 0)
        DecorSetInt(tempTaxi, "NOVARPACVehicle", 955)
        cc7 =
            CreateCheckpoint(
            1,
            96.752075195312,
            -1745.4302978516,
            28.315612792968,
            -515.47406005859,
            -264.78549194336,
            34.403575897217,
            2.0,
            204,
            204,
            1,
            100,
            0
        )
    elseif K == 4 then
        tempTaxi = CreateVehicle(J, 103.90421295166, -1751.818359375, 29.321237564086, 320, 1, 0)
        DecorSetInt(tempTaxi, "NOVARPACVehicle", 955)
        cc7 =
            CreateCheckpoint(
            1,
            103.90421295166,
            -1751.818359375,
            28.321237564086,
            -515.47406005859,
            -264.78549194336,
            34.403575897217,
            2.0,
            204,
            204,
            1,
            100,
            0
        )
    elseif K == 5 then
        tempTaxi = CreateVehicle(J, 108.07794952392, -1756.5098876954, 29.360332489014, 320, 1, 0)
        DecorSetInt(tempTaxi, "NOVARPACVehicle", 955)
        cc7 =
            CreateCheckpoint(
            1,
            108.07794952392,
            -1756.5098876954,
            28.360332489014,
            -515.47406005859,
            -264.78549194336,
            34.403575897217,
            2.0,
            204,
            204,
            1,
            100,
            0
        )
    elseif K == 6 then
        tempTaxi = CreateVehicle(J, 111.3772354126, -1740.8269042968, 28.854513168334, 50, 1, 0)
        DecorSetInt(tempTaxi, "NOVARPACVehicle", 955)
        cc7 =
            CreateCheckpoint(
            1,
            111.3772354126,
            -1740.8269042968,
            28.854513168334,
            -515.47406005859,
            -264.78549194336,
            34.403575897217,
            2.0,
            204,
            204,
            1,
            100,
            0
        )
    elseif K == 7 then
        tempTaxi = CreateVehicle(J, 97.749137878418, -1728.8994140625, 28.873386383056, 50, 1, 0)
        DecorSetInt(tempTaxi, "NOVARPACVehicle", 955)
        cc7 =
            CreateCheckpoint(
            1,
            97.749137878418,
            -1728.8994140625,
            28.873386383056,
            -515.47406005859,
            -264.78549194336,
            34.403575897217,
            2.0,
            204,
            204,
            1,
            100,
            0
        )
    end
    SetModelAsNoLongerNeeded(J)
    while GetVehiclePedIsIn(getPlayerPed()) ~= tempTaxi do
        Wait(100)
    end
    DeleteCheckpoint(cc7)
    BLIP_1 = AddBlipForCoord(-515.47406005859, -264.78549194336, 35.403575897217)
    SetBlipSprite(BLIP_1, 50)
    SetBlipAlpha(BLIP_1, 0)
    SetBlipRoute(BLIP_1, true)
    cc9 =
        CreateCheckpoint(
        45,
        -515.47406005859,
        -264.78549194336,
        34.403575897217,
        -542.36938476563,
        -207.75384521484,
        36.649753570557,
        2.0,
        204,
        204,
        1,100,0)
    d = "Make your way inside the City Hall and explore!"
    I = 20
    while I >= 5 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-515.47406005859, -264.78549194336, 35.403575897217))
        Wait(100)
    end
    DeleteCheckpoint(cc9)
    cc10 =
        CreateCheckpoint(
        45,
        -542.36938476563,
        -207.75384521484,
        36.649753570557,
        -542.36938476563,
        -207.75384521484,
        36.649753570557,
        2.0,
        204,
        204,
        1,
        100,
        0
    )
    d = "Aite got some ballas to kill see you around"
    I = 20
    while I >= 5 do
        plyCoords = GetEntityCoords(getPlayerPed(), false)
        I = #(plyCoords - vector3(-542.36938476563, -207.75384521484, 36.649753570557))
        Wait(100)
    end
    DeleteCheckpoint(cc10)
    SetBlipRoute(BLIP_1, false)
    Citizen.CreateThread(
        function()
            Wait(5000)
            TriggerEvent("vrp:PlaySound", "questcomplete")
            d = ""
            for L = 1, 700 do
                Wait(0)
                drawTxttutorial("Tutorial Complete", 2, 1, 0.5, 0.8, 2.5, 255, 255, 0, 255)
            end
            initializeEndTutorial()
            Wait(7000)
            b = false
        end
    )
    TriggerServerEvent("NOVA:setCompletedTutorial")
    i = 2
end
function drawTxttutorial(M, N, O, E, F, P, Q, R, S, T)
    SetTextFont(N)
    SetTextProportional(0)
    SetTextScale(P, P)
    SetTextColour(Q, R, S, T)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(O)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(M)
    EndTextCommandDisplayText(E, F)
end

function HelpText(M)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(M)
    EndTextCommandDisplayHelp(100, 0, 0, -1)
end
function StartIntroCutscene()
    local U = tvRP.getCustomization()
    local x = 31
    local V = "mp_m_freemode_01"
    local W = "MP_Male_Character"
    if GetEntityModel(getPlayerPed()) == "mp_f_freemode_01" then
        x = 103
        V = "mp_f_freemode_01"
        W = "MP_Female_Character"
    end
    RequestCutsceneWithPlaybackList("mp_intro_concat", x, 8)
    while not HasThisCutsceneLoaded("mp_intro_concat") do
        Citizen.Wait(0)
    end
    StartCutscene(0)
    if V == "mp_m_freemode_01" then
        RegisterEntityForCutscene(getPlayerPed(), W, 0, 0, 64)
        RegisterEntityForCutscene(0, "MP_Female_Character", 3, "mp_f_freemode_01", 0)
    elseif V == "mp_f_freemode_01" then
        RegisterEntityForCutscene(0, "MP_Male_Character", 3, "mp_f_freemode_01", 0)
        RegisterEntityForCutscene(getPlayerPed(), W, 0, 0, 64)
    end
    SetCutsceneEntityStreamingFlags(W, 0, 1)
    while not DoesCutsceneEntityExist(W, V) do
        Citizen.Wait(0)
    end
    SetCutscenePedClothing(getPlayerPed(), U)
end
function StartCasinoCutscene()
    local U = tvRP.getCustomization()
    local x = 59301
    local V = "mp_m_freemode_01"
    if GetEntityModel(getPlayerPed()) == "mp_f_freemode_01" then
        x = 40905
        V = "mp_f_freemode_01"
        print("is female", V)
    end
    EnableMovieSubtitles(true)
    RequestCutsceneWithPlaybackList("mpcas_int", x, 8)
    while not HasThisCutsceneLoaded("mpcas_int") do
        Citizen.Wait(0)
    end
    StartCutscene(0)
    RegisterEntityForCutscene(getPlayerPed(), "MP_1", 0, 0, 64)
    while not DoesCutsceneEntityExist("MP_1", V) do
        Citizen.Wait(0)
    end
    local X = GetEntityIndexOfCutsceneEntity("MP_1", V)
    SetCutscenePedClothing(getPlayerPed(), U)
end
local function Y(Z)
    if type(Z) == "string" and string.sub(Z, 1, 1) == "p" then
        return true, tonumber(string.sub(Z, 2))
    else
        return false, tonumber(Z)
    end
end
function SetCutscenePedClothing(X, U)
    for _, a0 in pairs(U) do
        if _ ~= "model" and _ ~= "modelhash" then
            local a1, a2 = Y(_)
            if a1 then
                if a0[1] < 0 then
                    ClearPedProp(X, a2)
                else
                    SetPedPropIndex(X, a2, a0[1], a0[2], a0[3] or 2)
                end
            else
                SetPedComponentVariation(X, a2, a0[1], a0[2], a0[3] or 2)
            end
        end
    end
end


function tvRP.setWeapon(m, s, t)
    SetCurrentPedWeapon(m, s, t)
end

function drawNativeNotification(B, X)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(B)
    if X then
        EndTextCommandDisplayHelp(0, false, false, -1)
    else
        EndTextCommandDisplayHelp(0, 0, 1, -1)
    end
end
function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(1)
	end
end