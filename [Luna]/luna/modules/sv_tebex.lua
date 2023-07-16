function Supporter(_, arg)
    if _ == 0 then 
        print("^3User Has Bought Package! ^7")
        user_id = tonumber(arg[1])
        usource = LUNA.getUserSource(user_id)

        print(GetPlayerName(usource)..'['..user_id..'] has bought Supporter')

        LUNAclient.notify(usource, {"~g~You have purchased the Supporter Rank! ❤️"})
        LUNA.giveBankMoney(user_id, 200)
        LUNA.addUserGroup(user_id,"Supporter")


    end
end

function Premium(_, arg)
    if _ == 0 then 
	user_id = tonumber(arg[1])
    usource = LUNA.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought Premium')

    LUNAclient.notify(usource, {"~g~You have purchased the Premium Rank! ❤️"})
    LUNA.giveBankMoney(user_id, 400)
    LUNA.addUserGroup(user_id,"Premium")


    end
end

function Supreme(_, arg)
    if _ == 0 then 
	user_id = tonumber(arg[1])
    usource = LUNA.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought Supreme')

    LUNAclient.notify(usource, {"~g~You have purchased the Supreme Rank! ❤️"})
    LUNA.giveBankMoney(user_id, 10000)
    LUNA.addUserGroup(user_id,"Supreme")


    end
end

function King_Pin(_, arg)
    if _ == 0 then 
	user_id = tonumber(arg[1])
    usource = LUNA.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought King Pin')

    LUNAclient.notify(usource, {"~g~You have purchased the King pin Rank! ❤️"})
    LUNA.giveBankMoney(user_id, 200000)
    LUNA.addUserGroup(user_id,"King Pin")


    end
end


function Rainmaker(_, arg)
    if _ == 0 then 
	user_id = tonumber(arg[1])
    usource = LUNA.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought Rainmaker')

    LUNAclient.notify(usource, {"~g~You have purchased the Rainmaker Rank! ❤️"})
    LUNA.giveBankMoney(user_id, 222000)
    LUNA.addUserGroup(user_id,"Rainmaker")


    end
end

function Baller(_, arg)
    if _ == 0 then 
	user_id = tonumber(arg[1])
    usource = LUNA.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought Baller')

    LUNAclient.notify(usource, {"~g~You have purchased the Baller Rank! ❤️"})
    LUNA.giveBankMoney(user_id, 20433200)
    LUNA.addUserGroup(user_id,"Baller")


    end
end

function tokens(_, arg)
    if _ == 0 then 
    user_id = tonumber(arg[1])
    usource = LUNA.getUserSource(user_id)

    print(GetPlayerName(usource)..'['..user_id..'] has bought a '..tostring(arg[2])..' Money Bag')

    LUNAclient.notify(usource, {"~g~You have purchased a £" .. tostring(arg[2]) .. " Money bag! ❤️"})
    LUNA.giveBankMoney(user_id, tonumber(arg[2]))
    end
end


RegisterCommand("Supporter", Supporter, true)
RegisterCommand("Premium", Premium, true)
RegisterCommand("Supreme", Supreme, true)
RegisterCommand("King_Pin", King_Pin, true)
RegisterCommand("Baller", Baller, true)
RegisterCommand("givemoney", tokens, true)

RegisterCommand('commandName', function(source, args, RawCommand)
    
end)