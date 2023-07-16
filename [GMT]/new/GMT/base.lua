MySQL = module("modules/MySQL")

Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")


local verify_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "https://cdn.discordapp.com/attachments/1082779702936215585/1117158086654824488/image_1.png",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "In order to connect to GMT you must be in our discord and verify your account, please follow the instructions below",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "1. Join the GMT discord (discord.gg/gmt)",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "2. In the #verify channel, type the following command:",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["text"] = "3. !verify NULL",
                    ["wrap"] = true,
                }
            }
        },
        {
            ["type"] = "ActionSet",
            ["actions"] = {
                {
                    ["type"] = "Action.Submit",
                    ["title"] = "Enter GMT",
                    ["id"] = "played"
                }
            }
        },
    }
}

Debug.active = config.debug
GMT = {}
Proxy.addInterface("GMT",GMT)

tGMT = {}
Tunnel.bindInterface("GMT",tGMT) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
GMT.lang = Lang.new(dict)

-- init
GMTclient = Tunnel.getInterface("GMT","GMT") -- server -> client tunnel

GMT.users = {} -- will store logged users (id) by first identifier
GMT.rusers = {} -- store the opposite of users
GMT.user_tables = {} -- user data tables (logger storage, saved to database)
GMT.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
GMT.user_sources = {} -- user sources 
-- queries
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    username VARCHAR(100),
    whitelisted BOOLEAN,
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    baninfo VARCHAR(2000) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_user_tokens (
    token VARCHAR(200),
    user_id INTEGER,
    banned BOOLEAN  NOT NULL DEFAULT 0,
    CONSTRAINT pk_user_tokens PRIMARY KEY(token)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES gmt_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES gmt_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    locked BOOLEAN NOT NULL DEFAULT 0,
    fuel_level FLOAT NOT NULL DEFAULT 100,
    impounded BOOLEAN NOT NULL DEFAULT 0,
    impound_info varchar(2048) NOT NULL DEFAULT '',
    impound_time VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES gmt_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES gmt_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_warnings (
    warning_id INT AUTO_INCREMENT,
    user_id INT,
    warning_type VARCHAR(25),
    duration INT,
    admin VARCHAR(100),
    warning_date DATE,
    reason VARCHAR(2000),
    PRIMARY KEY (warning_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_gangs (
    gangname VARCHAR(255) NULL DEFAULT NULL,
    gangmembers VARCHAR(3000) NULL DEFAULT NULL,
    funds BIGINT NULL DEFAULT NULL,
    logs VARCHAR(3000) NULL DEFAULT NULL,
    gangfit VARCHAR(255) DEFAULT NULL,
    lockedfunds BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (gangname)
    )
    ]])   
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_user_notes (
    user_id INT,
    info VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES gmt_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_bans_offenses(
    UserID INTEGER AUTO_INCREMENT,
    Rules TEXT NULL DEFAULT NULL,
    points INT(10) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(UserID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_dvsa(
    user_id INT(11),
    licence VARCHAR(100) NULL DEFAULT NULL,
    testsaves VARCHAR(1000) NULL DEFAULT NULL,
    points VARCHAR(500) NULL DEFAULT NULL,
    id VARCHAR(500) NULL DEFAULT NULL,
    datelicence VARCHAR(500) NULL DEFAULT NULL,
    penalties VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_subscriptions(
    user_id INT(11),
    plathours FLOAT(10) NULL DEFAULT NULL,
    plushours FLOAT(10) NULL DEFAULT NULL,
    last_used VARCHAR(100) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_casino_chips(
    user_id INT(11),
    chips bigint NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_verification(
    user_id INT(11),
    code VARCHAR(100) NULL DEFAULT NULL,
    discord_id VARCHAR(100) NULL DEFAULT NULL,
    verified TINYINT NULL DEFAULT NULL,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_users_contacts (
    id int(11) NOT NULL AUTO_INCREMENT,
    identifier varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
    number varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
    display varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_messages (
    id int(11) NOT NULL AUTO_INCREMENT,
    transmitter varchar(10) NOT NULL,
    receiver varchar(10) NOT NULL,
    message varchar(255) NOT NULL DEFAULT '0',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    isRead int(11) NOT NULL DEFAULT 0,
    owner int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_calls (
    id int(11) NOT NULL AUTO_INCREMENT,
    owner varchar(10) NOT NULL COMMENT 'Num such owner',
    num varchar(10) NOT NULL COMMENT 'Reference number of the contact',
    incoming int(11) NOT NULL COMMENT 'Defined if we are at the origin of the calls',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    accepts int(11) NOT NULL COMMENT 'Calls accept or not',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_app_chat (
    id int(11) NOT NULL AUTO_INCREMENT,
    channel varchar(20) NOT NULL,
    message varchar(255) NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_tweets (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) NOT NULL,
    realUser varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    message varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    likes int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY FK_twitter_tweets_twitter_accounts (authorId),
    CONSTRAINT FK_twitter_tweets_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_likes (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) DEFAULT NULL,
    tweetId int(11) DEFAULT NULL,
    PRIMARY KEY (id),
    KEY FK_twitter_likes_twitter_accounts (authorId),
    KEY FK_twitter_likes_twitter_tweets (tweetId),
    CONSTRAINT FK_twitter_likes_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id),
    CONSTRAINT FK_twitter_likes_twitter_tweets FOREIGN KEY (tweetId) REFERENCES twitter_tweets (id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_accounts (
    id int(11) NOT NULL AUTO_INCREMENT,
    username varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
    password varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
    avatar_url varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY username (username)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_community_pot (
    gmt VARCHAR(65) NOT NULL,
    value BIGINT(11) NOT NULL,
    PRIMARY KEY (gmt)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_quests (
    user_id INT(11),
    quests_completed INT(11) NOT NULL DEFAULT 0,
    reward_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_weapon_whitelists (
    user_id INT(11),
    weapon_info varchar(2048) DEFAULT '{}',
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_weapon_codes (
    user_id INT(11),
    spawncode varchar(2048) NOT NULL DEFAULT '',
    weapon_code int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (weapon_code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_prison (
    user_id INT(11),
    prison_time INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_staff_tickets (
    user_id INT(11),
    ticket_count INT(11) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_daily_rewards (
    user_id INT(11),
    last_reward INT(11) NOT NULL DEFAULT 0,
    streak INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS gmt_police_hours (
    user_id INT(11),
    weekly_hours FLOAT(10) NOT NULL DEFAULT 0,
    total_hours FLOAT(10) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    last_clocked_date VARCHAR(100) NOT NULL,
    last_clocked_rank VARCHAR(100) NOT NULL,
    total_players_fined INT(11) NOT NULL DEFAULT 0,
    total_players_jailed INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery("ALTER TABLE gmt_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE gmt_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE gmt_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE gmt_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE gmt_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE gmt_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("GMTls/create_modifications_column", "alter table gmt_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("GMTls/update_vehicle_modifications", "update gmt_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("GMTls/get_vehicle_modifications", "select modifications, vehicle_plate from gmt_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("GMTls/create_modifications_column")
    print("[GMT] ^2Base tables initialised.^0")
end)

MySQL.createCommand("GMT/create_user","INSERT INTO gmt_users(whitelisted,banned) VALUES(false,false)")
MySQL.createCommand("GMT/add_identifier","INSERT INTO gmt_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("GMT/userid_byidentifier","SELECT user_id FROM gmt_user_ids WHERE identifier = @identifier")
MySQL.createCommand("GMT/identifier_all","SELECT * FROM gmt_user_ids WHERE identifier = @identifier")
MySQL.createCommand("GMT/select_identifier_byid_all","SELECT * FROM gmt_user_ids WHERE user_id = @id")

MySQL.createCommand("GMT/set_userdata","REPLACE INTO gmt_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("GMT/get_userdata","SELECT dvalue FROM gmt_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("GMT/set_srvdata","REPLACE INTO GMT_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("GMT/get_srvdata","SELECT dvalue FROM GMT_srv_data WHERE dkey = @key")

MySQL.createCommand("GMT/get_banned","SELECT banned FROM gmt_users WHERE id = @user_id")
MySQL.createCommand("GMT/set_banned","UPDATE gmt_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin, baninfo = @baninfo WHERE id = @user_id")
MySQL.createCommand("GMT/set_identifierbanned","UPDATE gmt_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("GMT/getbanreasontime", "SELECT * FROM gmt_users WHERE id = @user_id")

MySQL.createCommand("GMT/get_whitelisted","SELECT whitelisted FROM gmt_users WHERE id = @user_id")
MySQL.createCommand("GMT/set_whitelisted","UPDATE gmt_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("GMT/set_last_login","UPDATE gmt_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("GMT/get_last_login","SELECT last_login FROM gmt_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("GMT/add_token","INSERT INTO gmt_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("GMT/check_token","SELECT user_id, banned FROM gmt_user_tokens WHERE token = @token")
MySQL.createCommand("GMT/check_token_userid","SELECT token FROM gmt_user_tokens WHERE user_id = @id")
MySQL.createCommand("GMT/ban_token","UPDATE gmt_user_tokens SET banned = @banned WHERE token = @token")
--Token Banning

-- removing anticheat ban entry
MySQL.createCommand("ac/delete_ban","DELETE FROM gmt_anticheat WHERE @user_id = user_id")


-- init tables


-- identification system

function GMT.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    if ids ~= nil and #ids then
        local i = 0
        local function search()
            i = i+1
            if i <= #ids then
                if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
                    MySQL.query("GMT/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
                        if #rows > 0 then  -- found
                            task({rows[1].user_id})
                        else -- not found
                            search()
                        end
                    end)
                else
                    search()
                end
            else -- no ids found, create user
                MySQL.query("GMT/create_user", {}, function(rows, affected)
                    if rows.affectedRows > 0 then
                        local user_id = rows.insertId
                        -- add identifiers
                        for l,w in pairs(ids) do
                            if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                                MySQL.execute("GMT/add_identifier", {user_id = user_id, identifier = w})
                            end
                        end
                        for k,v in pairs(GMT.getUsers()) do
                            GMTclient.notify(v, {'~g~You have received £10,000 as someone new has joined the server.'})
                            GMT.giveBankMoney(k, 10000)
                        end
                        task({user_id})
                    else
                        task()
                    end
                end)
            end
        end
        search()
    else
        task()
    end
end

-- return identification string for the source (used for non GMT identifications, for rejected players)
function GMT.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(ids) do
        idk = idk..v
    end
    return idk
end

function GMT.getPlayerIP(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

function GMT.getPlayerName(player)
    return GetPlayerName(player) or "unknown"
end

--- sql

function GMT.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    GMT.getUserIdByIdentifiers(ids, function(user_id)
        if user_id ~= nil then  
            GMT.StoreTokens(source, user_id) 
            if GMT.rusers[user_id] == nil then -- not present on the server, init
                GMT.users[ids[1]] = user_id
                GMT.rusers[user_id] = ids[1]
                GMT.user_tables[user_id] = {}
                GMT.user_tmp_tables[user_id] = {}
                GMT.user_sources[user_id] = source
                GMT.getUData(user_id, "GMT:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then GMT.user_tables[user_id] = data end
                    local tmpdata = GMT.getUserTmpTable(user_id)
                    GMT.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.execute("GMT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                        print("[GMT] "..name.." ("..GetPlayerName(source)..") joined (Perm ID = "..user_id..")")
                        TriggerEvent("GMT:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("GMT:CheckIdRegister", source)
                    end)
                end)
            else -- already connected
                print("[GMT] "..name.." ("..GetPlayerName(source)..") re-joined (Perm ID = "..user_id..")")
                TriggerEvent("GMT:playerRejoin", user_id, source, name)
                TriggerClientEvent("GMT:CheckIdRegister", source)
                local tmpdata = GMT.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end

exports("gmtbot", function(method_name, params, cb)
    if cb then 
        cb(GMT[method_name](table.unpack(params)))
    else 
        return GMT[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("GMT:CheckID")
AddEventHandler("GMT:CheckID", function()
    local source = source
    local user_id = GMT.getUserId(source)
    if not user_id then
        GMT.ReLoadChar(source)
    end
end)

function GMT.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("GMT/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

function GMT.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("GMT/get_whitelisted", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

function GMT.setWhitelisted(user_id,whitelisted)
    MySQL.execute("GMT/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

function GMT.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("GMT/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function GMT.fetchBanReasonTime(user_id,cbr)
    MySQL.query("GMT/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function GMT.setUData(user_id,key,value)
    MySQL.execute("GMT/set_userdata", {user_id = user_id, key = key, value = value})
end

function GMT.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    MySQL.query("GMT/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function GMT.setSData(key,value)
    MySQL.execute("GMT/set_srvdata", {key = key, value = value})
end

function GMT.getSData(key, cbr)
    local task = Task(cbr,{""})
    MySQL.query("GMT/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for GMT internal persistant connected user storage
function GMT.getUserDataTable(user_id)
    return GMT.user_tables[user_id]
end

function GMT.getUserTmpTable(user_id)
    return GMT.user_tmp_tables[user_id]
end

function GMT.isConnected(user_id)
    return GMT.rusers[user_id] ~= nil
end

function GMT.isFirstSpawn(user_id)
    local tmp = GMT.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function GMT.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return GMT.users[ids[1]]
        end
    end
    return nil
end

-- return map of user_id -> player source
function GMT.getUsers()
    local users = {}
    for k,v in pairs(GMT.user_sources) do
        users[k] = v
    end
    return users
end

-- return source or nil
function GMT.getUserSource(user_id)
    return GMT.user_sources[user_id]
end

function GMT.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('GMT/identifier_all', {identifier = v}, function(rows)
            for i = 1,#rows do 
                if rows[i].banned then 
                    if user_id ~= rows[i].user_id then 
                        cb(true, rows[i].user_id)
                    end 
                end
            end
        end)
    end
end

function GMT.BanIdentifiers(user_id, value)
    MySQL.query('GMT/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("GMT/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function calculateTimeRemaining(expireTime)
    local datetime = ''
    local expiry = os.date("%d/%m/%Y at %H:%M", tonumber(expireTime))
    local hoursLeft = ((tonumber(expireTime)-os.time()))/3600
    local minutesLeft = nil
    if hoursLeft < 1 then
        minutesLeft = hoursLeft * 60
        minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
        datetime = minutesLeft .. " mins" 
        return datetime
    else
        hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
        datetime = hoursLeft .. " hours" 
        return datetime
    end
    return datetime
end

function GMT.setBanned(user_id,banned,time,reason,admin,baninfo)
    if banned then 
        MySQL.execute("GMT/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, baninfo = baninfo})
        GMT.BanIdentifiers(user_id, true)
        GMT.BanTokens(user_id, true) 
    else 
        MySQL.execute("GMT/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  "", baninfo = ""})
        GMT.BanIdentifiers(user_id, false)
        GMT.BanTokens(user_id, false) 
        MySQL.execute("ac/delete_ban", {user_id = user_id})
    end 
end

function GMT.ban(adminsource,permid,time,reason,baninfo)
    local adminPermID = GMT.getUserId(adminsource)
    local getBannedPlayerSrc = GMT.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then
            GMT.setBanned(permid,true,time,reason,GetPlayerName(adminsource),baninfo)
            GMT.kick(getBannedPlayerSrc,"[GMT] Ban expires in: "..calculateTimeRemaining(time).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ www.gmtstudios.uk") 
        else
            GMT.setBanned(permid,true,"perm",reason,GetPlayerName(adminsource),baninfo)
            GMT.kick(getBannedPlayerSrc,"[GMT] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ www.gmtstudios.uk") 
        end
        GMTclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    else 
        if tonumber(time) then 
            GMT.setBanned(permid,true,time,reason,GetPlayerName(adminsource),baninfo)
        else 
            GMT.setBanned(permid,true,"perm",reason,GetPlayerName(adminsource),baninfo)
        end
        GMTclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    end
end

function GMT.banConsole(permid,time,reason)
    local adminPermID = "GMT"
    local getBannedPlayerSrc = GMT.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            GMT.setBanned(permid,true,banTime,reason, adminPermID)
            GMT.kick(getBannedPlayerSrc,"[GMT] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by GMT \nAppeal @ www.gmtstudios.uk") 
        else 
            GMT.setBanned(permid,true,"perm",reason, adminPermID)
            GMT.kick(getBannedPlayerSrc,"[GMT] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by GMT \nAppeal @ www.gmtstudios.uk") 
        end
        print("Successfully banned Perm ID: " .. permid)
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            GMT.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            GMT.setBanned(permid,true,"perm",reason, adminPermID)
        end
        print("Successfully banned Perm ID: " .. permid)
    end
end

function GMT.banDiscord(permid,time,reason,adminPermID)
    local getBannedPlayerSrc = GMT.getUserSource(tonumber(permid))
    if tonumber(time) then 
        local banTime = os.time()
        banTime = banTime  + (60 * 60 * tonumber(time))  
        GMT.setBanned(permid,true,banTime,reason, adminPermID)
        if getBannedPlayerSrc then 
            GMT.kick(getBannedPlayerSrc,"[GMT] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ www.gmtstudios.uk") 
        end
    else 
        GMT.setBanned(permid,true,"perm",reason,  adminPermID)
        if getBannedPlayerSrc then 
            GMT.kick(getBannedPlayerSrc,"[GMT] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ www.gmtstudios.uk") 
        end
    end
end

-- To use token banning you need the latest artifacts.
function GMT.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("GMT/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("GMT/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function GMT.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("GMT/check_token", {token = token, user_id = user_id})
                if #rows > 0 then 
                if rows[1].banned then 
                    return rows[1].banned, rows[1].user_id
                end
            end
        end
    else 
        return false; 
    end
end

function GMT.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("GMT/check_token_userid", {id = user_id}, function(id)
            for i = 1, #id do 
                MySQL.execute("GMT/ban_token", {token = id[i].token, banned = banned})
            end
        end)
    end
end


function GMT.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("GMT:save")
    Debug.pbegin("GMT save datatables")
    for k,v in pairs(GMT.user_tables) do
        GMT.setUData(k,"GMT:datatable",json.encode(v))
    end
    Debug.pend()
    SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()

-- handlers

AddEventHandler("playerConnecting",function(name,setMessage, deferrals)
    deferrals.defer()
    local source = source
    Debug.pbegin("playerConnecting")
    local ids = GetPlayerIdentifiers(source)
    if ids ~= nil and #ids > 0 then
        --[[PerformHttpRequest('https://api.steampowered.com/IPlayerService/GetSteamLevel/v1/?key=FA07C557F1580D724478EC2D9781F438&steamid=' .. tostring(ids[1]):gsub("steam:", ""), function(statusCode, responseText, headers)
            if statusCode == 200 then
                local steamLevel = tonumber(responseText:('"player_level":(%d+)'))
                if not steamLevel or steamLevel < 1 then
                    defferals.done("[GMT]: Connection refused. Your steam account is not of a sufficient level to connect.")
                    return
                else]]     -- need to sort a few things out until properly works 
        deferrals.update("[GMT] Checking identifiers...")
        GMT.getUserIdByIdentifiers(ids, function(user_id)
            local numtokens = GetNumPlayerTokens(source)
            if numtokens == 0 then
                deferrals.done("[GMT]: Permanent Ban\nYour ID: "..user_id.."\nReason: Ban evading is not permitted.\nAppeal @ www.gmtstudios.uk")
                tGMT.sendWebhook('ban-evaders', 'GMT Ban Evade Logs', "> Player Name: **"..name.."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Token Amount: **"..numtokens.."**")
                return 
            end
            GMT.IdentifierBanCheck(source, user_id, function(status, id, bannedIdentifier)
                if status then
                    deferrals.done("[GMT]: Permanent Ban\nYour ID: "..user_id.."\nReason: Ban evading is not permitted.\nAppeal @ www.gmtstudios.uk")
                    tGMT.sendWebhook('ban-evaders', 'GMT Ban Evade Logs', "> Player Name: **"..name.."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Banned PermID: **"..id.."**\n> Player Banned Identifier: **"..bannedIdentifier.."**")
                    return 
                end
            end)
            if user_id ~= nil then -- check user validity 
                deferrals.update("[GMT] Fetching Tokens...")
                GMT.StoreTokens(source, user_id) 
                deferrals.update("[GMT] Checking banned...")
                GMT.isBanned(user_id, function(banned)
                    if not banned then
                        deferrals.update("[GMT] Checking whitelisted...")
                        GMT.isWhitelisted(user_id, function(whitelisted)
                            if not config.whitelist or whitelisted then
                                Debug.pbegin("playerConnecting_delayed")
                                if GMT.rusers[user_id] == nil then -- not present on the server, init
                                    ::try_verify::
                                    local verified = exports["ghmattimysql"]:executeSync("SELECT * FROM gmt_verification WHERE user_id = @user_id", {user_id = user_id})
                                    if #verified > 0 then 
                                        if verified[1]["verified"] == 0 then
                                            local code = nil
                                            local data_code = exports["ghmattimysql"]:executeSync("SELECT * FROM gmt_verification WHERE user_id = @user_id", {user_id = user_id})
                                            code = data_code[1]["code"]
                                            if code == nil then
                                                code = math.random(100000, 999999)
                                            end
                                            ::regen_code::
                                            local checkCode = exports["ghmattimysql"]:executeSync("SELECT * FROM gmt_verification WHERE code = @code", {code = code})
                                            if checkCode ~= nil then
                                                if #checkCode > 0 then
                                                    code = math.random(100000, 999999)
                                                    goto regen_code
                                                end
                                            end
                                            exports["ghmattimysql"]:executeSync("UPDATE gmt_verification SET code = @code WHERE user_id = @user_id", {user_id = user_id, code = code})
                                            local function show_auth_card(code, deferrals, callback)
                                                verify_card["body"][2]["items"][3]["text"] = "3. !verify "..code
                                                deferrals.presentCard(verify_card, callback)
                                            end
                                            local function check_verified()
                                                local data_verified = exports["ghmattimysql"]:executeSync("SELECT * FROM gmt_verification WHERE user_id = @user_id", {user_id = user_id})
                                                local verified_code = data_verified[1]["verified"]
                                                if verified_code == true then
                                                    if GMT.CheckTokens(source, user_id) then 
                                                        deferrals.done("[GMT]: You are banned from this server, please do not try to evade your ban.")
                                                    end
                                                    GMT.users[ids[1]] = user_id
                                                    GMT.rusers[user_id] = ids[1]
                                                    GMT.user_tables[user_id] = {}
                                                    GMT.user_tmp_tables[user_id] = {}
                                                    GMT.user_sources[user_id] = source
                                                    GMT.getUData(user_id, "GMT:datatable", function(sdata)
                                                        local data = json.decode(sdata)
                                                        if type(data) == "table" then GMT.user_tables[user_id] = data end
                                                        local tmpdata = GMT.getUserTmpTable(user_id)
                                                        GMT.getLastLogin(user_id, function(last_login)
                                                            tmpdata.last_login = last_login or ""
                                                            tmpdata.spawns = 0
                                                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                            MySQL.execute("GMT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                            print("[GMT] "..name.." Joined | PermID: "..user_id..")")
                                                            TriggerEvent("GMT:playerJoin", user_id, source, name, tmpdata.last_login)
                                                            Wait(500)
                                                            deferrals.done()
                                                        end)
                                                    end)
                                                else
                                                    show_auth_card(code, deferrals, check_verified)
                                                end
                                            end
                                            show_auth_card(code, deferrals, check_verified)
                                        else
                                            deferrals.update("[GMT] Checking discord verification...")
                                            if not tGMT.checkForRole(user_id, '1008092889345175674') then
                                                deferrals.done("[GMT]: You are required to be verified within discord.gg/gmt to join the server. If you previously were verified, please contact management.")
                                            end

                                            deferrals.update("[GMT] Checking identifiers...")
                                            if GMT.CheckTokens(source, user_id) then 
                                                deferrals.done("[GMT]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                            end
                                            GMT.users[ids[1]] = user_id
                                            GMT.rusers[user_id] = ids[1]
                                            GMT.user_tables[user_id] = {}
                                            GMT.user_tmp_tables[user_id] = {}
                                            GMT.user_sources[user_id] = source
                                            GMT.getUData(user_id, "GMT:datatable", function(sdata)
                                                local data = json.decode(sdata)
                                                if type(data) == "table" then GMT.user_tables[user_id] = data end
                                                local tmpdata = GMT.getUserTmpTable(user_id)
                                                GMT.getLastLogin(user_id, function(last_login)
                                                    tmpdata.last_login = last_login or ""
                                                    tmpdata.spawns = 0
                                                    local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                    MySQL.execute("GMT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                    print("[GMT] "..name.." Joined | PermID: "..user_id..")")
                                                    TriggerEvent("GMT:playerJoin", user_id, source, name, tmpdata.last_login)
                                                    Wait(500)
                                                    deferrals.done()
                                                end)
                                            end)
                                        end
                                    else
                                        exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO gmt_verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                                        goto try_verify
                                    end
                                else -- already connected
                                    if GMT.CheckTokens(source, user_id) then 
                                        deferrals.done("[GMT]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                    end
                                    print("[GMT] "..name.." Reconnected | PermID: "..user_id)
                                    TriggerEvent("GMT:playerRejoin", user_id, source, name)
                                    Wait(500)
                                    deferrals.done()
                                    
                                    -- reset first spawn
                                    local tmpdata = GMT.getUserTmpTable(user_id)
                                    tmpdata.spawns = 0
                                end
                                Debug.pend()
                            else
                                print("[GMT] "..name.." ("..GetPlayerName(source)..") rejected: not whitelisted (Perm ID = "..user_id..")")
                                deferrals.done("[GMT] Not whitelisted (Perm ID = "..user_id..").")
                            end
                        end)
                    else
                        deferrals.update("[GMT] Fetching Tokens...")
                        GMT.StoreTokens(source, user_id) 
                        GMT.fetchBanReasonTime(user_id,function(bantime, banreason, banadmin)
                            if tonumber(bantime) then 
                                local timern = os.time()
                                if timern > tonumber(bantime) then 
                                    GMT.setBanned(user_id,false)
                                    if GMT.rusers[user_id] == nil then -- not present on the server, init
                                        GMT.users[ids[1]] = user_id
                                        GMT.rusers[user_id] = ids[1]
                                        GMT.user_tables[user_id] = {}
                                        GMT.user_tmp_tables[user_id] = {}
                                        GMT.user_sources[user_id] = source
                                        deferrals.update("[GMT] Loading datatable...")
                                        GMT.getUData(user_id, "GMT:datatable", function(sdata)
                                            local data = json.decode(sdata)
                                            if type(data) == "table" then GMT.user_tables[user_id] = data end
                                            local tmpdata = GMT.getUserTmpTable(user_id)
                                            deferrals.update("[GMT] Getting last login...")
                                            GMT.getLastLogin(user_id, function(last_login)
                                                tmpdata.last_login = last_login or ""
                                                tmpdata.spawns = 0
                                                local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                MySQL.execute("GMT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                print("[GMT] "..name.." ("..GetPlayerName(source)..") joined after his ban expired. (Perm ID = "..user_id..")")
                                                TriggerEvent("GMT:playerJoin", user_id, source, name, tmpdata.last_login)
                                                deferrals.done()
                                            end)
                                        end)
                                    else -- already connected
                                        print("[GMT] "..name.." ("..GetPlayerName(source)..") re-joined after his ban expired.  (Perm ID = "..user_id..")")
                                        TriggerEvent("GMT:playerRejoin", user_id, source, name)
                                        deferrals.done()
                                        local tmpdata = GMT.getUserTmpTable(user_id)
                                        tmpdata.spawns = 0
                                    end
                                    return 
                                end
                                print("[GMT] "..name.." ("..GetPlayerName(source)..") rejected: banned (Perm ID = "..user_id..")")
                                deferrals.done("\n[GMT] Ban expires in "..calculateTimeRemaining(bantime).."\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ www.gmtstudios.uk")
                            else 
                                print("[GMT] "..name.." ("..GetPlayerName(source)..") rejected: banned (Perm ID = "..user_id..")")
                                deferrals.done("\n[GMT] Permanent Ban\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ www.gmtstudios.uk")
                            end
                        end)
                    end
                end)
            else
                print("[GMT] "..name.." ("..GetPlayerName(source)..") rejected: identification error")
                deferrals.done("[GMT] Identification error.")
            end
        end)
    else
        print("[GMT] "..name.." ("..GetPlayerName(source)..") rejected: missing identifiers")
        deferrals.done("[GMT] Missing identifiers.")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = GMT.getUserId(source)
    local playerHex = GetPlayerIdentifier(source)
    local player = source
    local discord  = "N/A"
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end 
    end
    if user_id ~= nil then
        TriggerEvent("GMT:playerLeave", user_id, source)
        -- save user data table
        GMT.setUData(user_id,"GMT:datatable",json.encode(GMT.getUserDataTable(user_id)))
        print("[GMT] "..GetPlayerName(source).." disconnected (Perm ID = "..user_id..")")
        GMT.users[GMT.rusers[user_id]] = nil
        GMT.rusers[user_id] = nil
        GMT.user_tables[user_id] = nil
        GMT.user_tmp_tables[user_id] = nil
        GMT.user_sources[user_id] = nil
        print('[GMT] Player Leaving Save:  Saved data for: ' .. GetPlayerName(source))
        tGMT.sendWebhook('leave', "GMT Leave Logs", "\n> **Player Name:** "..GetPlayerName(source).."\n> **PermID:** "..user_id.."\n> **Temp ID:** "..source.."\n> **Discord:** "..discord.."\n> **Steam:** "..playerHex..'')
    else 
        print('[GMT] SEVERE ERROR: Failed to save data for: ' .. GetPlayerName(source) .. ' Rollback expected!')
    end
    GMTclient.removeBasePlayer(-1,{source})
    GMTclient.removePlayer(-1,{source})
end)


MySQL.createCommand("GMT/setusername","UPDATE gmt_users SET username = @username WHERE id = @user_id")

RegisterServerEvent("GMTcli:playerSpawned")
AddEventHandler("GMTcli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local source = source
    local playerHex = GetPlayerIdentifier(source)
    local user_id = GMT.getUserId(source)
    local player = source
    local discord  = "N/A"
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end 
    end
    GMTclient.addBasePlayer(-1, {player, user_id})
    if user_id ~= nil then
        GMT.user_sources[user_id] = source
        local tmp = GMT.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns+1
        local first_spawn = (tmp.spawns == 1)
        tGMT.sendWebhook('join', "GMT Join Logs", "\n> **Player Name:** "..GetPlayerName(source).."\n> **PermID:** "..user_id.."\n> **Temp ID:** "..source.."\n> **Discord:** "..discord.."\n> **Steam:** "..playerHex..'')
        if first_spawn then
            for k,v in pairs(GMT.user_sources) do
                GMTclient.addPlayer(source,{v})
            end
            GMTclient.addPlayer(-1,{source})
            MySQL.execute("GMT/setusername", {user_id = user_id, username = GetPlayerName(source)})
        end
        TriggerEvent("GMT:playerSpawn",user_id,player,first_spawn)
        TriggerClientEvent("GMT:onClientSpawn",player,user_id,first_spawn)
    end
    Debug.pend()
end)
RegisterServerEvent("GMT:playerRespawned")
AddEventHandler("GMT:playerRespawned", function()
    local source = source
    TriggerClientEvent('GMT:onClientSpawn', source)
end)


exports("getServerStatus", function(params, cb)
    if CloseToRestart then
        cb("❌ Offline")
    else
        cb("✅ Online")
    end
end)

exports("getConnected", function(params, cb)
    if GMT.getUserSource(params[1]) then
        cb('connected')
    else
        cb('not connected')
    end
end)