
g_generic_method = {} --c#泛型方法接口
IsLuaMode = true

function try(func, catch_do)
    local error = ""
    return xpcall(func, function (args)
        if catch_do then
            catch_do(args)
        end
    end)
end

function Toast(msg)
    local param = CS.EightGame.Logic.TipStruct(c_tostring(msg) , 0.2)
    CS.Eight.Framework.EIFrameWork.Instance:DispatchEvent( CS.Eight.Framework.EIEvent( CS.UIMessageType.UI_FLOATING_TIPS, nil, param))
end

function GameLogError( str )
    CS.Eight.Framework.EIDebuger.LogError(str)
end

function memory()
    local memory = require 'perf.memory'
    GameLog("------------------------------------------------------------------------------------")
    GameLog('total memory:', memory.total())
    GameLog(memory.snapshot())
end

function profiler(func, args)
    local profiler = require 'perf.profiler'
    profiler.start()
    GameLog("------------------------------------------------------------------------------------")
    if func and args then
        func(args)
        GameLog(profiler.report())
    end
    profiler.stop()
end

function c_get(dict, key, debug)
    if c_isnil(dict) then
        return nil
    end

    if isluatype(dict) then
        return dict[key]
    else
        local enum = dict:GetEnumerator()
        local _count = 0
        while enum:MoveNext() do
            local foreach_obj_type = "list"
            if enum.Current then
                if enum.Current.Key and enum.Current.Value then
                    --dict
                    foreach_obj_type = "dict"
                end
            end

            local targetK = nil
            if foreach_obj_type == "dict" then
                targetK = enum.Current.Key
            else
                targetK = _count
            end

            if type(key) == "string" then
                if key == targetK then
                    return enum.Current.Value
                end
            elseif type(key) == "number" then
                if key == targetK then
                    return enum.Current
                end
            end
            _count = _count + 1
        end
    end
    return nil
end

function c_set(dict, key, value)
    if c_isnil(dict) then
        return nil
    end

    if isluatype(dict) then
        if type(key) == "number" then
            key = key+1
        end
        dict[key] = value
    else
        local enum = dict:GetEnumerator()
        local _count = 0
        while enum:MoveNext() do
            if type(key) == "string" then
                if key == enum.Current.Key then
                    enum.Current.Value = value
                end
            elseif type(key) == "number" then
                if key == _count then
                    enum.Current = value
                end
            end
            _count = _count + 1
        end
    end
end

function obj_foreach( dict , func)
    if not c_isnil(dict) then
        if isluatype(dict) then
            if type(dict) == "table" then
                local _index = 1
                for i,v in pairs(dict) do
                    local item = {}
                    item.index = _index
                    item.current = {}
                    item.key = i
                    item.value = v
                    _index = _index + 1
                    if func then
                        if func(item) == "break" then
                            break
                        end
                    end
                end
            end
        elseif iscstype(dict) then
            local enumerator = nil
            try(function ()
                enumerator = dict:GetEnumerator()
            end, function ( __e__ )
                GameLog("GetEnumerator __e__:\n ", __e__)
            end)
            -- local enumerator = dict:GetEnumerator()
            if not c_isnil(enumerator) then
                local _index = 0
                while not c_isnil(enumerator) and enumerator:MoveNext() do
                    local item = {}
                    item.index = _index
                    item.current = enumerator.Current or nil
                    item.key = nil
                    item.value = nil 
                    if not c_isnil(item.current) then
                        item.key = enumerator.Current.Key
                        item.value = enumerator.Current.Value
                    end
                    _index = _index + 1
                    if func then
                        if func(item) == "break" then
                            break
                        end
                    end
                end
            end
        end
    else
        LogError("foreach list is nil.")
    end
end

function isluatype( t )
    return not iscstype(t)
end

function iscstype( t )
    return type(t) == "userdata"
end

function c_isnil( obj, debug)
    if isluatype(obj) then
        return obj == nil
    else
        if obj == nil then
            return true
        end
        local ret = nil
        try(function ( ... )
            ret = obj:IsNull()
        end, function ( _e_ )
            ret = obj:Equals(nil)
        end)
        
        return ret
    end
end

function c_tostring( msg )
    local ret = "nil"
    if not c_isnil(msg) then
        if isluatype(msg) then
            if type(msg) == "boolean" then
                ret = msg and "true" or "false"
            elseif type(msg) == "string" or type(msg) == "number" then
                ret = tostring(msg)
            elseif type(msg) == "table" then
                ret = type(msg)
            else
                ret = type(msg)
            end
        else
            ret = msg:ToString()
        end
    end
    return ret
end

function c_len(obj)
    local count = 0
    if not c_isnil(obj) then
        if isluatype(obj) then
            if type(obj) == "string" then
                count = utf8.len(obj)
            elseif type(obj) == "table" then
                for i,v in pairs(obj) do
                    count = count + 1
                end
            end
        else
            count = obj.Count or obj.Length
        end
    end
    return count
end

--[[
    通用c#接口的实现
]]

--字符串分割函数
--传入字符串和分隔符，返回分割后的table
function c_split(str, delimiter)
    if c_isnil(str) or c_isnil(delimiter) then
        return nil
    end
    if isluatype(str) then
        local start = 1
        local t = {}
        while true do
        local pos = string.find (str, delimiter, start, true) -- plain find
            if not pos then
              break
            end

            table.insert (t, string.sub (str, start, pos - 1))
            start = pos + string.len (delimiter)
        end
        table.insert (t, string.sub (str, start))
        return t
    else
        return str:Split(delimiter)
    end
end

function obj_replace(str, sour, dict)
    if c_isnil(str) then
        return nil
    end
    if isluatype(str) then
        if str and sour and dict then
            return string.gsub(str, sour, dict) 
        end
    else
        return str:Replace(sour, dict)
    end
end

function c_div(a, b)
    return math.ceil(a / b)
end

function c_randomRange(a, b)
    GameLog("c_randomRange ", a, b)
    local value = CS.UnityEngine.Random.Range(a, b )
    return math.ceil(value)
end

function c_toCharArray(str, m, n)
    local ret = {}
    if not c_isnil(m) and not c_isnil(n) then
        if m == 0 then
            m = m + 1
            n = n + 1
        end 
        str = EIUtf8.sub(str, m, n)
    end
    local slen = c_len(str)
    
    for i=1, slen do
        ret[i] = string.byte(EIUtf8.sub(str, i, i))
    end
    return ret
end

function c_fromCharCode(Bytes)
    local str = ""
    if not c_isnil(Bytes) then
        if type(Bytes) == "number" then
            str = string.char(Bytes)
        else
            for i,v in pairs(Bytes) do
                str = str .. string.char(v)
            end
        end
    end
    return str
end

function c_contains(str, target)
    if not c_isnil(str) and not c_isnil(target) then
        if isluatype(str) then
            if type(str) == "string" then
                return string.find(str, target) ~= nil
            end
        else
            return str:Contains(target)
        end
    end
end

function c_trim(s)
    if not c_isnil(s) then
        if isluatype(s) then
            return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
        else
            return s:Trim()
        end
    end
end
