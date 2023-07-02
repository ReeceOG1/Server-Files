local cfg=module("cfg/cfg_groupselector")

function LUNA.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = LUNA.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if LUNA.hasPermission(LUNA.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if LUNA.hasGroup(user_id, b[1]) then
                                table.insert(v['jobs'], b)
                            end
                        end
                        jobSelectors[k] = v
                    end
                else
                    v['_config'] = j._config
                    v['jobs'] = j.jobs
                    jobSelectors[k] = v
                end
            end
        end
    end
    TriggerClientEvent("LUNA:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("LUNA:getJobSelectors")
AddEventHandler("LUNA:getJobSelectors",function()
    local source = source
    LUNA.getJobSelectors(source)
end)

function LUNA.removeAllJobs(user_id)
    local source = LUNA.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and LUNA.hasGroup(user_id, v[1]) then
                LUNA.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and LUNA.hasGroup(user_id, v[1]..' Clocked') then
                LUNA.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                LUNAclient.setArmour(source, {0})
            end
        end
    end
    -- remove all faction ranks
    LUNAclient.setPolice(source, {false})
    TriggerClientEvent('LUNA:setPoliceOnDuty', source, false)
     LUNAclient.setNHS(source, {false})
     TriggerClientEvent('LUNA:setNHSOnDuty', source, false)
     LUNAclient.setHMP(source, {false})
     TriggerClientEvent('LUNA:setPrisonGuardOnDuty', source, false)
     LUNAclient.setLFB(source, {false})
end

RegisterNetEvent("LUNA:jobSelector")
AddEventHandler("LUNA:jobSelector",function(a,b)
    local source = source
    local user_id = LUNA.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("LUNA:AnticheatBan", user_id, 11, GetPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        LUNA.removeAllJobs(user_id)
        LUNAclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if LUNA.hasGroup(user_id, b) then
                LUNA.removeAllJobs(user_id)
                LUNA.addUserGroup(user_id,b..' Clocked')
                LUNAclient.setPolice(source, {true})
                TriggerClientEvent('LUNA:setPoliceOnDuty', source, true)
                LUNAclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
            else
                LUNAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'NHS' then
            if LUNA.hasGroup(user_id, b) then
                LUNA.removeAllJobs(user_id)
                LUNA.addUserGroup(user_id,b..' Clocked')
                LUNAclient.setNHS(source, {true})
                TriggerClientEvent('LUNA:setNHSOnDuty', source, true)
                LUNAclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
            else
                LUNAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if LUNA.hasGroup(user_id, b) then
                LUNA.removeAllJobs(user_id)
                LUNA.addUserGroup(user_id,b..' Clocked')
                LUNAclient.setLFB(source, {true})
                TriggerClientEvent('LUNA:setLFBOnDuty', source, true)
                LUNAclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
            else
                LUNAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'HMP' then
            if LUNA.hasGroup(user_id, b) then
                LUNA.removeAllJobs(user_id)
                LUNA.addUserGroup(user_id,b..' Clocked')
                LUNAclient.setHMP(source, {true})
                TriggerClientEvent('LUNA:setPrisonGuardOnDuty', source, true)
                LUNAclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
            else
                LUNAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        else
            LUNA.removeAllJobs(user_id)
            LUNA.addUserGroup(user_id,b)
            LUNAclient.notify(source, {"~g~Employed as "..b.."."})
        end
    end
end)