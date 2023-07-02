cfg = {
	Guild_ID = '995069542852202557',
  	Multiguild = true,
  	Guilds = {
		['Main'] = '995069542852202557', 
		['Police'] = '1008187019219972096', 
		['NHS'] = '1008265982420193350',
		['HMP'] = '1008207447963484192',
		['LFB'] = '1008206756226277477',
  	},
	RoleList = {},

	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

cfg.Guild_Roles = {
	['Main'] = {
		['Founder'] = 995069542961254425, -- 12
		['Lead Developer'] = 995069542961254424, -- 11
		['Developer'] = 995069542961254423, -- 10
		['Community Manager'] = 995069542931906659, -- 9
		['Staff Manager'] = 995069542961254420, -- 8
		['Head Administrator'] = 995069542931906658, -- 7
		['Senior Administrator'] = 995069542931906655, -- 6
		['Administrator'] = 995069542931906654, -- 5
		['Senior Moderator'] = 995069542931906653, -- 4
		['Moderator'] = 995069542931906652, -- 3
		['Support Team'] = 995069542931906651, -- 2
		['Trial Staff'] = 995069542931906650, -- 1
		['cardev'] = 995069542898335909,
		['Cinematic'] = 1008093603534487643,
	},

	['Police'] = {
		['Commissioner'] = 1008187019647795214,
		['Deputy Commissioner'] = 1008187019647795213,
		['Assistant Commissioner'] = 1008187019647795212,
		['Dep. Asst. Commissioner'] = 1008187019647795211,
		['Commander'] = 1008187019647795210,
		['Chief Superintendent'] = 1008187019610038333,
		['Superintendent'] = 1008187019572293671,
		['Chief Inspector'] = 1008187019572293664,
		['Inspector'] = 1008187019572293663,
		['Sergeant'] = 1008187019547115619,
		['Special Constable'] = 1008187019547115614,
		['Senior Constable'] = 1008187019547115618,
		['PC'] = 1008187019547115617,
		['PCSO'] = 1008187019547115616,
		['Large Arms Access'] = 1008187019345797174,
		['Police Horse Trained'] = 1008187019320635395,
		['Drone Trained'] = 1008187019320635394,
		['NPAS'] = 1008187019383554096,
		['Trident Officer'] = 991819633097183322,
		['Trident Command'] = 991809551802310767,
		['K9 Trained'] = 1008187019320635393,
	},

	['NHS'] = {
		['NHS Head Chief'] = 1008266180047421460,
		['NHS Assistant Chief'] = 1008266181146320996,
		['NHS Deputy Chief'] = 1008266182203285524,
		['NHS Captain'] = 1008266183042138142,
		['NHS Consultant'] = 1008266197000802314,
		['NHS Specialist'] = 1008266197936128111,
		['NHS Senior Doctor'] = 1008266205120974970,
		['NHS Doctor'] = 1008266206198894602,
		['NHS Junior Doctor'] = 1008266207310397460,
		['NHS Critical Care Paramedic'] = 1008266208224755812,
		['NHS Paramedic'] = 1008266211886375002,
		['NHS Trainee Paramedic'] = 1008266212788158515,
		['Drone Trained'] = 1008266238969008248,
		['HEMS'] = 1008266230869803008,
	},

	['HMP'] = {
		['Governor'] = 1008207624338161696,
		['Deputy Governor'] = 1008207625734860891,
		['Divisional Commander'] = 1008207626699542528,
		['Custodial Supervisor'] = 1008207643346731090,
		['Custodial Officer'] = 1008207644298838086,
		['Honourable Guard'] = 1008207656101617725,
		['Supervising Officer'] = 1008207650158301296,
		['Principal Officer'] = 1008207651345281054,
		['Specialist Officer'] = 1008207652414816317,
		['Senior Officer'] = 1008207653316612126,
		['Prison Officer'] = 1008207654214176838,
		['Trainee Prison Officer'] = 1008207655346647160,
	},

	['LFB'] = {
		['Chief Fire Command'] = 1008206875923324988,
		['Divisional Command'] = 1008206879731757157,
		['Sector Command'] = 1008206880738390016,
		['Honourable Firefighter'] = 1008206885251469353,
		['Leading Firefighter'] = 1008206886002237571,
		['Specialist Firefighter'] = 1008206886761418762,
		['Advanced Firefighter'] = 1008206887558324246,
		['Senior Firefighter'] = 1008206888778862733,
		['Firefighter'] = 1008206889768730695,
		['Junior Firefighter'] = 1008206890775359590,
		['Provisional Firefighter'] = 1008206891157028927,	
	},	
}

for faction_name, faction_roles in pairs(cfg.Guild_Roles) do
	for role_name, role_id in pairs(faction_roles) do
		cfg.RoleList[role_name] = role_id
	end
end


cfg.Bot_Token = 'MTAwODIyNjY0Njg3NDE0ODk1NQ.Gapep0.6HqX87EZPmFy-uul9s_uxbf16nb5mDXZPL3Plo'

return cfg