--Log
local rawPrint = print
function GameLog( ... )
    if DEBUG_MODE then
        -- local info = debug.getinfo(2,"Sl")
        -- local fname = info.source
        -- local lines = info.currentline
        -- local extra = string.format("\n[%s:%d]", fname, lines)
        -- rawPrint(extra, ...)
        rawPrint(...)
    else
        -- rawPrint(...)
    end
end

function LogError( msg )
    CS.UnityEngine.Debug.LogError(debug.traceback(msg, 2))
end