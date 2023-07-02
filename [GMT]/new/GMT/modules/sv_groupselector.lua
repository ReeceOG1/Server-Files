local cfg=module("cfg/cfg_groupselector")

function GMT.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = GMT.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if GMT.hasPermission(GMT.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if GMT.hasGroup(user_id, b[1]) then
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
    TriggerClientEvent("GMT:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("GMT:getJobSelectors")
AddEventHandler("GMT:getJobSelectors",function()
    local source = source
    GMT.getJobSelectors(source)
end)

function GMT.removeAllJobs(user_id)
    local source = GMT.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and GMT.hasGroup(user_id, v[1]) then
                GMT.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and GMT.hasGroup(user_id, v[1]..' Clocked') then
                GMT.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                GMTclient.setArmour(source, {0})
                TriggerEvent('GMT:clockedOffRemoveRadio', source)
            end
        end
    end
    -- remove all faction ranks
    GMTclient.setPolice(source, {false})
    TriggerClientEvent('GMTUI5:globalOnPoliceDuty', source, false)
    GMTclient.setNHS(source, {false})
    TriggerClientEvent('GMTUI5:globalOnNHSDuty', source, false)
    GMTclient.setHMP(source, {false})
    TriggerClientEvent('GMTUI5:globalOnPrisonDuty', source, false)
    GMTclient.setLFB(source, {false})
    TriggerClientEvent('GMT:disableFactionBlips', source)
    TriggerClientEvent('GMT:radiosClearAll', source)
    -- toggle all main jobs to false
    TriggerClientEvent('GMT:toggleTacoJob', source, false)
end

RegisterNetEvent("GMT:jobSelector")
AddEventHandler("GMT:jobSelector",function(a,b)
    local source = source
    local user_id = GMT.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("GMT:acBan", user_id, 11, GetPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        GMT.removeAllJobs(user_id)
        GMTclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if GMT.hasGroup(user_id, b) then
                GMT.removeAllJobs(user_id)
                GMT.addUserGroup(user_id,b..' Clocked')
                GMTclient.setPolice(source, {true})
                TriggerClientEvent('GMTUI5:globalOnPoliceDuty', source, true)
                GMTclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tGMT.sendWebhook('pd-clock', 'GMT Police Clock On Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                GMTclient.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if GMT.hasGroup(user_id, b) then
                GMT.removeAllJobs(user_id)
                GMT.addUserGroup(user_id,b..' Clocked')
                GMTclient.setNHS(source, {true})
                TriggerClientEvent('GMTUI5:globalOnNHSDuty', source, true)
                GMTclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tGMT.sendWebhook('nhs-clock', 'GMT NHS Clock On Logs',"> Medic Name: **"..GetPlayerName(source).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                GMTclient.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if GMT.hasGroup(user_id, b) then
                GMT.removeAllJobs(user_id)
                GMT.addUserGroup(user_id,b..' Clocked')
                GMTclient.setLFB(source, {true})
                GMTclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tGMT.sendWebhook('lfb-clock', 'GMT LFB Clock On Logs',"> Firefighter Name: **"..GetPlayerName(source).."**\n> Firefighter TempID: **"..source.."**\n> Firefighter PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                GMTclient.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if GMT.hasGroup(user_id, b) then
                GMT.removeAllJobs(user_id)
                GMT.addUserGroup(user_id,b..' Clocked')
                GMTclient.setHMP(source, {true})
                TriggerClientEvent('GMTUI5:globalOnPrisonDuty', source, true)
                GMTclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tGMT.sendWebhook('hmp-clock', 'GMT HMP Clock On Logs',"> Prison Officer Name: **"..GetPlayerName(source).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                GMTclient.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        else
            GMT.removeAllJobs(user_id)
            GMT.addUserGroup(user_id,b)
            GMTclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('GMT:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('GMT:toggleTacoJob', source, true)
            end
        end
        TriggerEvent('GMT:clockedOnCreateRadio', source)
        TriggerClientEvent('GMT:radiosClearAll', source)
        TriggerClientEvent('GMT:refreshGunStorePermissions', source)
        GMT.updateCurrentPlayerInfo()
    end
end)