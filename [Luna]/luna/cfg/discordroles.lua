cfg = {
    Guild_ID = '1095505472028688534',
      Multiguild = true,
      Guilds = {
        ['MAIN'] = '1095505472028688534', 
        ['Police'] = '1070813701944377414', 
        ['NHS'] = '1073365105468788877', 
        ['HMP'] = '1093990154739388509', 
      },
    RoleList = {},

    CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
    CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
    ['MAIN'] = {
      ['founder'] = 1095505978419597342,
      ['staffmanager'] = 1095837865755295884,
      ['commanager'] = 1096201359440748665,
    --  ['operationsmanager'] = 1096891191225761852,
      ['headadmin'] = 1095838298544554094,
      ['dev'] = 1096182178775306302,
      ['leaddev'] = 1095918619965276330,
      ['senioradmin'] = 1095838568804528229,
      ['administrator'] = 1095838851341234296,
      ['srmoderator'] = 1095839179121901729,
      ['moderator'] = 1095839331580641320,
      ['supportteam'] = 1095839621264461924,
      ['trialstaff'] = 1095839779234533466,
      ['cardev'] = 1095839975578292244,
      ['VIP'] = 1102568507780116480,
      ['AA'] = 1113171088948592792,
        -- ['streamer'] = 1098236301171499030,
        -- ['nitro'] = 1096824073134297249,
        -- ['trusted'] = 1098997080388808815,
        -- ['kingpin'] = 1097944666604851220,
        -- ['supreme'] = 1097944593758158888,
        -- ['premium'] = 1097944522333364335,
        -- ['supporter'] = 1097944441509122159,
        -- ['rainmaker'] = 1104398103110496297,
      --  ['WGuns'] = 1102944001285439568,
        -- ['recruit'] = 1076226264676958223,
        -- ['soldier'] = 1076226264676958224,
        -- ['warrior'] = 1076226264676958225,
        -- ['diamond'] = 1076226264676958226,
      --  ['GANGWHITELIST'] = 1093631629886496816,
       -- ['pov'] = 1097944262320074794,
        -- ['DJ'] = 1093631629920055327,
    }, 
    ['Police'] = {
        ['Commissioner'] = 1070815092716871751,
        ['Deputy Commissioner'] = 1070815622822383666,
        ['Assistant Commissioner'] = 1070815790124765214,
        ['Dep. Asst. Commissioner'] = 1070816213573320816,
        ['Commander'] = 1089654652997472356,
        ['Chief Superintendent'] = 1070816357958037524,
        ['Superintendent'] = 1070816988089286737,
        ['Chief Inspector'] = 1070817021119430678,
        ['Inspector'] = 1070817109522788392,
        ['Sergeant'] = 1070817205861765120,
        ['Special Constable'] = 1070817291345862726,
        ['Senior Constable'] = 1089697063702384751,
        ['pdlargearms'] = 1070818158740504588,
        ['PC'] = 1070817377266176011,
        ['NPAS'] = 1070821355680976947,
        ['SCO-19'] = 1070817735367471144,
        ['CTSFO'] = 1071092806711521320,
        ['PCSO'] = 1073367478308196392, 
    },
    ['HMP'] = {
        ['Governor'] = 1093990155360161952,
        ['Deputy Governor'] = 1093990155360161951,
        ['Divisional Commander'] = 1093990155360161950,
        ['Custodial Supervisor'] = 1093990155347562531,
        ['Custodial Officer'] = 1093990155347562530,
        ['Honourable Guard'] = 1093990155330781228,
        ['Supervising Officer'] = 1093990155347562526,
        ['Principal Officer'] = 1093990155330781233, 
        ['Specialist Officer'] = 1093990155330781232, 
        ['Senior Officer'] = 1093990155330781231,
        ['Prison Officer'] = 1093990155330781230,
        ['Trainee Prison Officer'] = 1093990155330781229, 
    },
    ['NHS'] = {
        ['Head Chief Medical Officer'] = 1073365105707851873,
        ['Assistant Chief Medical Officer'] = 1073365105707851872,
        ['Deputy Chief Medical Officer'] = 1073365105707851871,
        ['Captain'] = 1073365105707851870,
        ['Consultant'] = 1073365105707851868,
        ['Specialist'] = 1073365105670111243,
        ['Senior Doctor'] = 1073365105649143863,
        ['Junior Doctor'] = 1073365105649143861,
        ['Critical Care Paramedic'] = 1073365105649143860,
        ['Paramedic'] = 1073365105649143859,
        ['Trainee Paramedic'] = 1073365105649143858,
    }, 
    

    -- ['name in cfg above'] = {
    --     ['in game group name'] = discord id here
    -- } --

}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
    for role_name, role_id in pairs(faction_roles) do
        cfg.RoleList[role_name] = role_id
    end
end


cfg.Bot_Token = ''

return cfg