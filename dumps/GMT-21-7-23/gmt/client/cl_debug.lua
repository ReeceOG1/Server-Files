isDebugModeEnabled = false
function tGMT.toggleDebugMode()
    isDebugModeEnabled = not isDebugModeEnabled
    local a = isDebugModeEnabled and "enabled" or "disabled"
    print("[GMT] debug mode " .. a)
end
function tGMT.debugLog(...)
    if isDebugModeEnabled then
        print("[GMT DEBUG] ", ...)
    end
end
function tGMT.debugLog_export(b, ...)
    if isDebugModeEnabled then
        local c = string.format("[GMT DEBUG : %s]", b)
        print(c, ...)
    end
end
RegisterCommand(
    "debugmode",
    function()
        tGMT.toggleDebugMode()
    end,
    false
)
exports(
    "debugLog",
    function(...)
        local b = GetInvokingResource()
        tGMT.debugLog_export(b, ...)
    end
)
