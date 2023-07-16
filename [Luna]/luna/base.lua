MySQL = module("luna_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")

-- verify card
local verify_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "https://cdn.discordapp.com/attachments/1110327017565597749/1112433963928133662/Screenshot_2023-05-27_035345.png",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "In order to connect to LUNA you must be in our discord and verify your account. please follow the below instructions",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "1. Join the LUNA Discord (discord.gg/luna5m)",
                    ["wrap"] = true,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "2. In the #verify channel, type the following command",
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
                    ["title"] = "Join Discord",
                    ["id"] = "https://discord.gg/kXZx5yMtxX"
                },
                {
                    ["type"] = "Action.Submit",
                    ["title"] = "Connect",
                    ["id"] = "attempt_connection"
                }
            }
        },
    }
}



Debug.active = config.debug
LUNA = {}
Proxy.addInterface("LUNA",LUNA)

tLUNA = {}
Tunnel.bindInterface("LUNA",tLUNA) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
LUNA.lang = Lang.new(dict)

-- init
LUNAclient = Tunnel.getInterface("LUNA","LUNA") -- server -> client tunnel

LUNA.users = {} -- will store logged users (id) by first identifier
LUNA.rusers = {} -- store the opposite of users
LUNA.user_tables = {} -- user data tables (logger storage, saved to database)
LUNA.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
LUNA.user_sources = {} -- user sources 
-- queries
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
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
    CREATE TABLE IF NOT EXISTS phone_stocks (
    ID int(11) NOT NULL AUTO_INCREMENT,
    Name varchar(50) NOT NULL,
    Label varchar(50) NOT NULL,
    Current double DEFAULT NULL,
    Min double NOT NULL,
    Max double NOT NULL,
    Med double unsigned DEFAULT NULL,
    PRIMARY KEY (ID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_dvsadata(
    user_id INT(11),
    licence VARCHAR(100) NULL DEFAULT NULL,
    testsaves VARCHAR(1000) NULL DEFAULT NULL,
    points VARCHAR(500) NULL DEFAULT NULL,
    id VARCHAR(500) NULL DEFAULT NULL,
    datelicence VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS player_settings (
    user_id VARCHAR(50) NOT NULL,
    render_distance INT,
    compass BOOLEAN,
    cinematic_bars BOOLEAN,
    kill_notification BOOLEAN,
    hitsounds BOOLEAN,
    weapon_orientation BOOLEAN,
    ui BOOLEAN,
    health_percentage_display BOOLEAN,
    streetnames BOOLEAN,
    crosshair BOOLEAN,
    PRIMARY KEY(user_id)
    );        
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_casino_chips(
    user_id INT(11),
    chips INT(11) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS player_connections 
    (id INT AUTO_INCREMENT PRIMARY KEY, 
    identifier VARCHAR(50)
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
    CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `number` VARCHAR(255) NOT NULL
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `phone_messages` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `receiver` VARCHAR(255) NOT NULL,
    `transmitter` VARCHAR(255) NOT NULL,
    `message` TEXT NOT NULL,
    `isRead` BOOLEAN NOT NULL DEFAULT 0,
    `time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    username VARCHAR(100),
    whitelisted BOOLEAN,
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_user_tokens (
    token VARCHAR(200),
    user_id INTEGER,
    banned BOOLEAN  NOT NULL DEFAULT 0,
    CONSTRAINT pk_user_tokens PRIMARY KEY(token)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_verification(
    user_id INT(11),
    code VARCHAR(100) NULL DEFAULT NULL,
    discord_id VARCHAR(100) NULL DEFAULT NULL,
    verified TINYINT NULL DEFAULT NULL,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES luna_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES luna_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    locked BOOLEAN NOT NULL DEFAULT 0,
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES luna_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES luna_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES luna_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_warnings (
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
    CREATE TABLE IF NOT EXISTS luna_user_notes (
    note_id INT AUTO_INCREMENT,
    user_id INT,
    text VARCHAR(250),
    admin_name VARCHAR(250),
    admin_id INT,
    PRIMARY KEY (note_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS LUNA_gangs (
    gangname VARCHAR(3000) NULL DEFAULT NULL,
    gangmembers VARCHAR(3000) NULL DEFAULT NULL,
    funds BIGINT NULL DEFAULT NULL,
    logs VARCHAR(3000) NULL DEFAULT NULL
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS luna_club(
    user_id int(11) NOT NULL,
    plathours float DEFAULT NULL,
    plushours float DEFAULT NULL,
    last_used varchar(50) NOT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery("ALTER TABLE luna_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE luna_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE luna_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE luna_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE luna_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE luna_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("LUNAls/create_modifications_column", "alter table luna_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("LUNAls/update_vehicle_modifications", "update luna_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("LUNAls/get_vehicle_modifications", "select modifications from luna_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("LUNAls/create_modifications_column")
    print("init base tables")
end)






MySQL.createCommand("LUNA/create_user","INSERT INTO luna_users(whitelisted,banned) VALUES(false,false)")
MySQL.createCommand("LUNA/add_identifier","INSERT INTO luna_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("LUNA/userid_byidentifier","SELECT user_id FROM luna_user_ids WHERE identifier = @identifier")
MySQL.createCommand("LUNA/identifier_all","SELECT * FROM luna_user_ids WHERE identifier = @identifier")
MySQL.createCommand("LUNA/select_identifier_byid_all","SELECT * FROM luna_user_ids WHERE user_id = @id")

MySQL.createCommand("LUNA/set_userdata","REPLACE INTO luna_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("LUNA/get_userdata","SELECT dvalue FROM luna_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("LUNA/set_srvdata","REPLACE INTO luna_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("LUNA/get_srvdata","SELECT dvalue FROM luna_srv_data WHERE dkey = @key")

MySQL.createCommand("LUNA/get_banned","SELECT banned FROM luna_users WHERE id = @user_id")
MySQL.createCommand("LUNA/set_banned","UPDATE luna_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin WHERE id = @user_id")
MySQL.createCommand("LUNA/set_identifierbanned","UPDATE luna_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("LUNA/getbanreasontime", "SELECT * FROM luna_users WHERE id = @user_id")

MySQL.createCommand("LUNA/get_whitelisted","SELECT whitelisted FROM luna_users WHERE id = @user_id")
MySQL.createCommand("LUNA/set_whitelisted","UPDATE luna_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("LUNA/set_last_login","UPDATE luna_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("LUNA/get_last_login","SELECT last_login FROM luna_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("LUNA/add_token","INSERT INTO luna_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("LUNA/check_token","SELECT user_id, banned FROM luna_user_tokens WHERE token = @token")
MySQL.createCommand("LUNA/check_token_userid","SELECT token FROM luna_user_tokens WHERE user_id = @id")
MySQL.createCommand("LUNA/ban_token","UPDATE luna_user_tokens SET banned = @banned WHERE token = @token")
--Token Banning

-- init tables


-- identification system

--- sql.
-- cbreturn user id or nil in case of error (if not found, will create it)
function LUNA.getUserIdByIdentifiers(ids, cbr)
    local task = Task(cbr)
    
    if ids ~= nil and #ids then
        local i = 0
        
        -- search identifiers
        local function search()
            i = i+1
            if i <= #ids then
                if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
                    MySQL.query("LUNA/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
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
                MySQL.query("LUNA/create_user", {}, function(rows, affected)
                    if rows.affectedRows > 0 then
                        local user_id = rows.insertId
                        -- add identifiers
                        for l,w in pairs(ids) do
                            if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                                MySQL.execute("LUNA/add_identifier", {user_id = user_id, identifier = w})
                            end
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

-- return identification string for the source (used for non LUNA identifications, for rejected players)
function LUNA.getSourceIdKey(source)
    local ids = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(ids) do
        idk = idk..v
    end
    
    return idk
end


function LUNA.getPlayerName(player)
    return GetPlayerName(player) or "unknown"
end

--- sql

function LUNA.ReLoadChar(source)
    local name = GetPlayerName(source)
    local ids = GetPlayerIdentifiers(source)
    LUNA.getUserIdByIdentifiers(ids, function(user_id)
        if user_id ~= nil then  
            LUNA.StoreTokens(source, user_id) 
            if LUNA.rusers[user_id] == nil then -- not present on the server, init
                LUNA.users[ids[1]] = user_id
                LUNA.rusers[user_id] = ids[1]
                LUNA.user_tables[user_id] = {}
                LUNA.user_tmp_tables[user_id] = {}
                LUNA.user_sources[user_id] = source
                LUNA.getUData(user_id, "LUNA:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then LUNA.user_tables[user_id] = data end
                    local tmpdata = LUNA.getUserTmpTable(user_id)
                    LUNA.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0
                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.execute("LUNA/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                        print("[LUNA] "..name.. " joined (PermID = "..user_id..")")
                        TriggerEvent("LUNA:playerJoin", user_id, source, name, tmpdata.last_login)
                        TriggerClientEvent("LUNA:CheckIdRegister", source)
                    end)
                end)
            else -- already connected
                print("[LUNA] "..name.."re-joined (PermID = "..user_id..")")
                TriggerEvent("LUNA:playerRejoin", user_id, source, name)
                TriggerClientEvent("LUNA:CheckIdRegister", source)
                local tmpdata = LUNA.getUserTmpTable(user_id)
                tmpdata.spawns = 0
            end
        end
    end)
end

-- This can only be used server side and is for the LUNA bot. 
exports("lunabot", function(method_name, params, cb)
    if cb then 
        cb(LUNA[method_name](table.unpack(params)))
    else 
        return LUNA[method_name](table.unpack(params))
    end
end)

local user_id = 0
local MaxPlayers = GetConvarInt("sv_maxclients", 64)

RegisterNetEvent("LUNA:StartGetPlayersLoopSV")
AddEventHandler("LUNA:StartGetPlayersLoopSV", function()
    local UserID = LUNA.getUserId(source)
    local PlayerCount = #GetPlayers()
    TriggerClientEvent('LUNA:ReturnGetPlayersLoopCL', source, UserID, PlayerCount)
end)

RegisterNetEvent("LUNA:CheckID")
AddEventHandler("LUNA:CheckID", function()
    user_id = LUNA.getUserId(source)
    TriggerClientEvent('discord:getpermid2', source, user_id)
    TriggerClientEvent('LUNA:StartGetPlayersLoopCL', source)
    if not user_id then
        LUNA.ReLoadChar(source)
    end
end)

function LUNA.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    
    MySQL.query("LUNA/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end

--- sql

--- sql
function LUNA.isWhitelisted(user_id, cbr)
    local task = Task(cbr, {false})
    
    MySQL.query("LUNA/get_whitelisted", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].whitelisted})
        else
            task()
        end
    end)
end

--- sql
function LUNA.setWhitelisted(user_id,whitelisted)
    MySQL.execute("LUNA/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

--- sql
function LUNA.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("LUNA/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function LUNA.fetchBanReasonTime(user_id,cbr)
    MySQL.query("LUNA/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function LUNA.setUData(user_id,key,value)
    MySQL.execute("LUNA/set_userdata", {user_id = user_id, key = key, value = value})
end

function LUNA.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    
    MySQL.query("LUNA/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function LUNA.setSData(key,value)
    MySQL.execute("LUNA/set_srvdata", {key = key, value = value})
end

function LUNA.getSData(key, cbr)
    local task = Task(cbr,{""})
    
    MySQL.query("LUNA/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for LUNA internal persistant connected user storage
function LUNA.getUserDataTable(user_id)
    return LUNA.user_tables[user_id]
end

function LUNA.getUserTmpTable(user_id)
    return LUNA.user_tmp_tables[user_id]
end

function LUNA.isConnected(user_id)
    return LUNA.rusers[user_id] ~= nil
end

function LUNA.isFirstSpawn(user_id)
    local tmp = LUNA.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function LUNA.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return LUNA.users[ids[1]]
        end
    end
    
    return nil
end

-- return map of user_id -> player source
function LUNA.getUsers()
    local users = {}
    for k,v in pairs(LUNA.user_sources) do
        users[k] = v
    end
    
    return users
end

-- return source or nil
function LUNA.getUserSource(user_id)
    return LUNA.user_sources[user_id]
end

function LUNA.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('LUNA/identifier_all', {identifier = v}, function(rows)
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

function LUNA.BanIdentifiers(user_id, value)
    MySQL.query('LUNA/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("LUNA/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function LUNA.setBanned(user_id,banned,time,reason, admin)
    if banned then 
        MySQL.execute("LUNA/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, banevidence})
        LUNA.BanIdentifiers(user_id, true)
        LUNA.BanTokens(user_id, true) 
    else 
        MySQL.execute("LUNA/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  ""})
        LUNA.BanIdentifiers(user_id, false)
        LUNA.BanTokens(user_id, false) 
    end 
end

function LUNA.ban(adminsource,permid,time,reason)
    local adminPermID = LUNA.getUserId(adminsource)
    local getBannedPlayerSrc = LUNA.getUserSource(tonumber(permid))
    local adminname = GetPed
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            LUNA.setBanned(permid,true,banTime,reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
            LUNA.kick(getBannedPlayerSrc,"\n[LUNA] You have been banned from LUNA\nYour ban will expire on: \n" .. os.date("%c", banTime) .. "\nReason: " .. reason .. "\n\n [Your ID: " .. permid .. "] \nIf You Believe This Is A False Ban, You Can Appeal It @ discord.gg/LUNA5M") 
            LUNAclient.notify(adminsource,{"~g~Success banned! User PermID:" .. permid})
        else 
            LUNAclient.notify(adminsource,{"~g~Success banned! User PermID:" .. permid})
            LUNA.setBanned(permid,true,"perm",reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
            LUNA.kick(getBannedPlayerSrc,"\n[LUNA] Permanently banned\nReason: " .. reason .. "\nID: " .. permid) 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            LUNAclient.notify(adminsource,{"~g~Success banned! User PermID:" .. permid})
            LUNA.setBanned(permid,true,banTime,reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
        else 
            LUNAclient.notify(adminsource,{"~g~Success banned! User PermID:" .. permid})
            LUNA.setBanned(permid,true,"-1",reason, GetPlayerName(adminsource) .. " | ID Of Admin: " .. adminPermID)
        end
    end
end


    

function LUNA.banConsole(permid,reason)
    local adminPermID = "LUNA"
    local getBannedPlayerSrc = LUNA.getUserSource(tonumber(permid))
    print("Success banned! User PermID:" .. permid)
    LUNA.setBanned(permid,true,"perm",reason,  adminPermID)
    f10Ban(permid, adminPermID, reason, "perm")
    if getBannedPlayerSrc then
    LUNA.kick(getBannedPlayerSrc,"\n[LUNA] Permanently banned\nReason: " .. reason .. "\nID: " .. permid ) 
    end
end

function LUNA.banDiscord(permid,time,reason,adminPermID)
    local getBannedPlayerSrc = LUNA.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))
            LUNA.setBanned(permid,true,banTime,reason, adminPermID)
            LUNA.kick(getBannedPlayerSrc,"[LUNA] You have been banned from LUNA. 🤬\n\nYour ban will expire on: \n" .. os.date("%c", banTime) .. "\n\nReason: " .. reason .. "\n\n [Your ID: " .. permid .. "]\n\n\n\n If you think it was a mistake make a support ticket") 
            print("~g~Success banned! User PermID:" .. permid)
            f10Ban(permid, adminPermID, reason, time)
        else 
            print("~g~Success banned! User PermID:" .. permid)
            LUNA.setBanned(permid,true,"perm",reason,  adminPermID)
            f10Ban(permid, adminPermID, reason, "perm")
            LUNA.kick(getBannedPlayerSrc,"[LUNA] You have been permanently banned from LUNA. 🤬\n\nReason: " .. reason .. "\n\n [Your ID: " .. permid .. "]") 
        end
    end
  end

-- To use token banning you need the latest artifacts.
function LUNA.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("LUNA/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("LUNA/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end



function LUNA.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("LUNA/check_token", {token = token, user_id = user_id})
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

function LUNA.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("LUNA/check_token_userid", {id = user_id}, function(id)
            for i = 1, #id do 
                MySQL.execute("LUNA/ban_token", {token = id[i].token, banned = banned})
            end
        end)
    end
end


function LUNA.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("LUNA:save")
    
    Debug.pbegin("LUNA save datatables")
    for k,v in pairs(LUNA.user_tables) do
        LUNA.setUData(k,"LUNA:datatable",json.encode(v))
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
        deferrals.update("[LUNA] Checking identifiers...")
        LUNA.getUserIdByIdentifiers(ids, function(user_id)
            LUNA.IdentifierBanCheck(source, user_id, function(status, id)
                if status then
                    print("[LUNA] User rejected for attempting to evade ID: " .. user_id .. " | (Ignore joined message, they were rejected)") 
                    deferrals.done("[LUNA Antievade] Ban Evading Is Not Permitted, Your ID Is: " .. id .. "\nIf You Think This Is A Mistake, please Join Our Discord\n[discord.gg/LUNA5M]")
                    return 
                end
            end)
            -- if user_id ~= nil and LUNA.rusers[user_id] == nil then -- check user validity and if not already connected (old way, disabled until playerDropped is sure to be called)
            if user_id ~= nil then -- check user validity 
                deferrals.update("[LUNA] Fetching Tokens...")
                LUNA.StoreTokens(source, user_id) 
                deferrals.update("[LUNA] Checking banned...")
                LUNA.isBanned(user_id, function(banned)
                    if not banned then
                        deferrals.update("[LUNA] Checking whitelisted...")
                        LUNA.isWhitelisted(user_id, function(whitelisted)
                            if not config.whitelist or whitelisted then
                                Debug.pbegin("playerConnecting_delayed")
                                if LUNA.rusers[user_id] == nil then -- not present on the server, init
                                    ::try_verify::
                                    local verified = exports["ghmattimysql"]:executeSync("SELECT * FROM luna_verification WHERE user_id = @user_id", {user_id = user_id})
                                    if #verified > 0 then 
                                        if verified[1]["verified"] == 0 then
                                            local code = nil
                                            local data_code = exports["ghmattimysql"]:executeSync("SELECT * FROM luna_verification WHERE user_id = @user_id", {user_id = user_id})
                                            code = data_code[1]["code"]
                                            if code == nil then
                                                code = math.random(100000, 999999)
                                            end
                                            ::regen_code::
                                            local checkCode = exports["ghmattimysql"]:executeSync("SELECT * FROM luna_verification WHERE code = @code", {code = code})
                                            if checkCode ~= nil then
                                                if #checkCode > 0 then
                                                    code = math.random(100000, 999999)
                                                    goto regen_code
                                                end
                                            end
                                            exports["ghmattimysql"]:executeSync("UPDATE luna_verification SET code = @code WHERE user_id = @user_id", {user_id = user_id, code = code})
                                            local function show_auth_card(code, deferrals, callback)
                                                verify_card["body"][2]["items"][3]["text"] = "3. !verify "..code
                                                deferrals.presentCard(verify_card, callback)
                                            end
                                            local function check_verified(data)
                                                local data_verified = exports["ghmattimysql"]:executeSync("SELECT * FROM luna_verification WHERE user_id = @user_id", {user_id = user_id})
                                                local verified_code = data_verified[1]["verified"]
                                                if verified_code == true or verified_code == 1 then
                                                    if LUNA.CheckTokens(source, user_id) then 
                                                        deferrals.done("[LUNA]: You are banned from this server, please do not try to evade your ban.")
                                                    end
                                                    LUNA.users[ids[1]] = user_id
                                                    LUNA.rusers[user_id] = ids[1]
                                                    LUNA.user_tables[user_id] = {}
                                                    LUNA.user_tmp_tables[user_id] = {}
                                                    LUNA.user_sources[user_id] = source
                                                    LUNA.getUData(user_id, "LUNA:datatable", function(sdata)
                                                        local data = json.decode(sdata)
                                                        if type(data) == "table" then LUNA.user_tables[user_id] = data end
                                                        local tmpdata = LUNA.getUserTmpTable(user_id)
                                                        LUNA.getLastLogin(user_id, function(last_login)
                                                            tmpdata.last_login = last_login or ""
                                                            tmpdata.spawns = 0
                                                            local last_login_stamp = os.date("%d/%m/%Y at %X")
                                                            MySQL.execute("LUNA/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                            print("[LUNA] "..name.." Joined | PermID: "..user_id..")")
                                                            TriggerEvent("LUNA:playerJoin", user_id, source, name, tmpdata.last_login)
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
                                            deferrals.update("[LUNA] Checking discord verification...")
                                            if LUNA.CheckTokens(source, user_id) then 
                                                deferrals.done("[LUNA]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                            end
                                            LUNA.users[ids[1]] = user_id
                                            LUNA.rusers[user_id] = ids[1]
                                            LUNA.user_tables[user_id] = {}
                                            LUNA.user_tmp_tables[user_id] = {}
                                            LUNA.user_sources[user_id] = source
                                            LUNA.getUData(user_id, "LUNA:datatable", function(sdata)
                                                local data = json.decode(sdata)
                                                if type(data) == "table" then LUNA.user_tables[user_id] = data end
                                                local tmpdata = LUNA.getUserTmpTable(user_id)
                                                LUNA.getLastLogin(user_id, function(last_login)
                                                    tmpdata.last_login = last_login or ""
                                                    tmpdata.spawns = 0
                                                    local last_login_stamp = os.date("%d/%m/%Y at %X")
                                                    MySQL.execute("LUNA/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                    print("[LUNA] "..name.." Joined | PermID: "..user_id..")")
                                                    TriggerEvent("LUNA:playerJoin", user_id, source, name, tmpdata.last_login)
                                                    Wait(500)
                                                    deferrals.done()
                                                end)
                                            end)
                                        end
                                    else
                                        exports["ghmattimysql"]:executeSync("INSERT IGNORE INTO luna_verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                                        goto try_verify
                                    end
                                else -- already connected
                                    if LUNA.CheckTokens(source, user_id) then 
                                        deferrals.done("[LUNA Antievade] Ban Evading Is Not Permitted, Your ID Is: " .. user_id .. "\nIf You Think This Is A Mistake, please Join Our Discord\n[discord.gg/LUNA5M]")
                                    end
                                    print("[LUNA] "..name.. " re-joined (user_id = "..user_id..")")
                                    TriggerEvent("LUNA:playerRejoin", user_id, source, name)
                                    deferrals.done()
                                    
                                    -- reset first spawn
                                    local tmpdata = LUNA.getUserTmpTable(user_id)
                                    tmpdata.spawns = 0
                                end
                                
                                Debug.pend()
                            else
                                print("[LUNA] "..name.." Rejected | Reason: Not Whitelisted | PermID: "..user_id)
                                deferrals.done("[LUNA] "..name.." Rejected | Reason: Not Whitelisted | PermID: "..user_id)
                            end
                        end)
                    else
                        deferrals.update("[LUNA] Fetching Tokens...")
                        LUNA.StoreTokens(source, user_id) 
                        LUNA.fetchBanReasonTime(user_id,function(bantime, banreason, banadmin)
                            if tonumber(bantime) then 
                                local timern = os.time()
                                if timern > tonumber(bantime) then 
                                    deferrals.update('[LUNA] Your Ban Has Expired\nDo NOT Violate This Server\'s rules again \nYou Will Now Be Automatically Connected\nEnjoy Your Time On The Server\n\nConnecting To LUNA...')
                                    Wait(2000)
                                    LUNA.setBanned(user_id,false)
                                    if LUNA.rusers[user_id] == nil then -- not present on the server, init
                                        -- init entries
                                        LUNA.users[ids[1]] = user_id
                                        LUNA.rusers[user_id] = ids[1]
                                        LUNA.user_tables[user_id] = {}
                                        LUNA.user_tmp_tables[user_id] = {}
                                        LUNA.user_sources[user_id] = source
                                        
                                        -- load user data table
                                        deferrals.update("[LUNA] Loading datatable...")
                                        LUNA.getUData(user_id, "LUNA:datatable", function(sdata)
                                            local data = json.decode(sdata)
                                            if type(data) == "table" then LUNA.user_tables[user_id] = data end
                                            
                                            -- init user tmp table
                                            local tmpdata = LUNA.getUserTmpTable(user_id)
                                            
                                            deferrals.update("[LUNA] Getting last login...")
                                            LUNA.getLastLogin(user_id, function(last_login)
                                                tmpdata.last_login = last_login or ""
                                                tmpdata.spawns = 0
                                                
                                                -- set last login
                                               
                                                local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                MySQL.execute("LUNA/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                
                                                -- trigger join
                                                print("[LUNA] "..name.."  joined after his ban expired. (user_id = "..user_id..")")
                                                TriggerEvent("LUNA:playerJoin", user_id, source, name, tmpdata.last_login)
                                                deferrals.done()
                                            end)
                                        end)
                                    else -- already connected
                                        print("[LUNA] "..name.." re-joined after his ban expired.  (user_id = "..user_id..")")
                                        TriggerEvent("LUNA:playerRejoin", user_id, source, name)
                                        deferrals.done()
                                        
                                        -- reset first spawn
                                        local tmpdata = LUNA.getUserTmpTable(user_id)
                                        tmpdata.spawns = 0
                                    end
                                    return 
                                end
                                print("[LUNA] "..name.." rejected: banned (user_id = "..user_id..")")
                                deferrals.done("LUNA\n\nExpires in:  " .. os.date("%c", bantime) ..  " \nYour Perm ID is: " .. user_id .. "\nReason: " .. banreason .. "\nBanned By:  " .. banadmin .. "\nAppeal @ discord.gg/LUNA5M")
                            else 
                                print("[LUNA] "..name.." rejected: banned (user_id = "..user_id..")")
                                deferrals.done("[LUNA] You have been banned from this server.\nYour ID: " ..user_id .. "Your ban will expire: Never, you have been permanently banned \nReason: " .. banreason .. "\n\nBanning Admin: " .. banadmin)
                            end
                        end)
                    end
                end)
            else
                print("[LUNA] "..name.." rejected: identification error")
                deferrals.done("[LUNA] Error Connecting\nReason: Missing Identifiers\nIf You Carry On Getting This Error Please Contact A Developer")
            end
        end)
    else
        print("[LUNA] "..name.." rejected: missing identifiers")
        deferrals.done("[LUNA] Error Connecting\nReason: Missing Identifiers\nIf You Carry On Getting This Error Please Contact A Developer")
    end
    Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        TriggerEvent("LUNA:playerLeave", user_id, source)
        
        -- save user data table
        LUNA.setUData(user_id,"LUNA:datatable",json.encode(LUNA.getUserDataTable(user_id)))
        LUNA.users[LUNA.rusers[user_id]] = nil
        LUNA.rusers[user_id] = nil
        LUNA.user_tables[user_id] = nil
        LUNA.user_tmp_tables[user_id] = nil
        LUNA.user_sources[user_id] = nil
        print('[LUNA] Player Leaving Save:  Saved data for: ' .. GetPlayerName(source))
    else 
        print('[LUNA] SEVERE ERROR: Failed to save data for: ' .. GetPlayerName(source) .. ' Rollback expected!')
    end
    LUNAclient.removePlayer(-1,{source})
end)


MySQL.createCommand("LUNA/setusername","UPDATE luna_users SET username = @username WHERE id = @user_id")


RegisterServerEvent("LUNAcli:playerSpawned")
AddEventHandler("LUNAcli:playerSpawned", function()
    Debug.pbegin("playerSpawned")
    -- register user sources and then set first spawn to false
    local user_id = LUNA.getUserId(source)
    local player = source
    if user_id ~= nil then
        LUNA.user_sources[user_id] = source
        local tmp = LUNA.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns+1
        local first_spawn = (tmp.spawns == 1)
        if first_spawn then
            for k,v in pairs(LUNA.user_sources) do
                LUNAclient.addPlayer(source,{v})
            end
            LUNAclient.addPlayer(-1,{source})
            MySQL.execute("LUNA/setusername", {user_id = user_id, username = GetPlayerName(source)})
        end
        TriggerEvent("LUNA:playerSpawn",user_id,player,first_spawn)
    end
    Debug.pend()
end)

AddEventHandler("LUNAcli:playerSpawned", function()
    local user_id = LUNA.getUserId(source)
    local steam64 = "N/A"
    steam64 = GetPlayerGuid(source)
    local discord  = "N/A"
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end 
    end
    local command = {
        {
            ["color"] = "0",
            ["title"] = "LUNA Join Logs",
            ["description"] = "**Player Name:** "..GetPlayerName(source).."\n**Temp ID:** "..source.."\n**Perm ID:** "..user_id.."\n**Discord:** "..discord.."\n**Steam: **https://steamid.pro/lookup/"..steam64,
            ["footer"] = {
                ["text"] = "LUNA Server #1 - "..os.date("%A (%d/%m/%Y) at %X"),
            }
        }
    }
    PerformHttpRequest("https://ptb.discord.com/api/webhooks/1110520863234732052/JuIjQv9X6_LZwjKTOHb1L1PHnbq02x-2RjfB2DIMYWKBvrRJGij6OOIUvo5URjP0Ebt3", function(err, text, headers) end, "POST", json.encode({username = "LUNA", embeds = command}), { ["Content-Type"] = "application/json" })
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local user_id = LUNA.getUserId(source)
    if user_id ~= nil then
        local command = {
            {
                ["color"] = "15158332",
                ["title"] = GetPlayerName(source).." TempID: "..source.." PermID: "..user_id.." disconnected",
                ["description"] = "Reason: "..reason,
                ["footer"] = {
                    ["text"] = "LUNA Server #1 - "..os.date("%A (%d/%m/%Y) at %X"),
                }
            }
        }
        PerformHttpRequest("https://ptb.discord.com/api/webhooks/1110618677797199976/LhS7nEjOEVqQA75Tdlh9Uw_LFhP_yoFtXN_6jTBmHnmysvugQgPd6iheu7DcfJTAOvBe", function(err, text, headers) end, "POST", json.encode({username = "LUNA", embeds = command}), { ["Content-Type"] = "application/json" })
    end
end)

RegisterServerEvent("LUNA:gettingUserID")
AddEventHandler("LUNA:gettingUserID", function()
    local source = source
    local user_id = LUNA.getUserId(source)
    TriggerClientEvent("LUNA:setUserID", source, user_id)
end)
function LUNA.banDiscord(permid,time,reason,adminPermID)
    local getBannedPlayerSrc = LUNA.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            LUNA.setBanned(permid,true,banTime,reason, adminPermID)
            LUNA.kick(getBannedPlayerSrc,"[LUNA] You have been banned from LUNA. \n\nYour ban will expire on: \n" .. os.date("%c", banTime) .. "\n\nReason: " .. reason .. "\n\n [Your ID: " .. permid .. "]\n\n\n\n This ban is unappealable, if you think it was a mistake make a support ticket") 
            print("~g~Success banned! User PermID:" .. permid)
            f10Ban(permid, adminPermID, reason, time)
        else 
            print("~g~Success banned! User PermID:" .. permid)
            LUNA.setBanned(permid,true,"perm",reason,  adminPermID)
            f10Ban(permid, adminPermID, reason, "perm")
            LUNA.kick(getBannedPlayerSrc,"[LUNA] You have been permanently banned from LUNA. \n\nReason: " .. reason .. "\n\n [Your ID: " .. permid .. "]") 
        end
    end
end

RegisterServerEvent("LUNA:playerDied")


local developersServerSide = {
    [1] = true,
    [2] = true,
  }

function LUNA.isDeveloper(user_id)
    return developersServerSide[user_id] or false
end