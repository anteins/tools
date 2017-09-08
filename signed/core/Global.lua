�m��@ay��6t��4p�U���:����l"��� �Dn�?y�|����l"��"p���
��O�d��-<�l^�J~G_A�.$D'��+m�<��
�fvb��f�)9�w=K�,��Vg����Ex�9;
--[[
    公共方法
]]

g_tbHotfix = {} --热更模块列表
UNITY_EDITOR = 1
UNITY_PHONE = 1
IsLuaMode = true

--使用Lua遍历指定目录，获取所有文件，并使用自定义的函数处理每一个文件
--遍历目录，并对所有的文件进行处理
function get_dir_file(dirpath,func)
    os.execute('dir "' .. dirpath .. '" /s > temp.txt')
    io.input("temp.txt")
    local dirname = ""
    local filename = ""
    for line in io.lines() do
        local a,b,c
        --匹配目录
        a,b,c=string.find(line,"^%s*(.+)%s+的目录")
        if a then
         dirname = c
     end
     --匹配文件
        a,b,c=string.find(line,"^%d%d%d%d%-%d%d%-%d%d%s-%d%d:%d%d%s-[%d%,]+%s+(.+)%s-$")
        if a then
         filename = c
         func(dirname .. "\\" .. filename)
        end
    end
end

function initGlobal()
    local count = 0
    for i,v in pairs(g_tbCSGlobal) do
        local _load = load("return " .. v)
        if type(_load) == "function" then
            _G[i] = _load()
            try(function ()
                xlua.private_accessible(_G[i])
            end, function ( _e_ )
                error = _e_
                local error_str = "error:[" .. i .. "]:" .. _e_ .. "\n", debug.traceback()
                local file = io.open(CS.PathUtility:GetDataPath().."/luaError.txt", "w")
                assert(file)
                file:write(error_str)
                GameLog(error_str)
            end)
            count = count + 1
        end
    end
end

function try(func, catch_do)
    local error = ""
    return xpcall(func, function (args)
        if catch_do then
            catch_do(args)
        end
    end)
end

function IsIOS()
    local sPlatform = CS.PlatformUtil:GetDeviceOS()
    return string.find(sPlatform, "iPhone")
end

function toast(msg)
    local param = CS.EightGame.Logic.TipStruct(obj2str(msg) , 0.2)
    CS.Eight.Framework.EIFrameWork.Instance:DispatchEvent( CS.Eight.Framework.EIEvent( CS.UIMessageType.UI_FLOATING_TIPS, nil, param))
end

function LogError( str )
    CS.Eight.Framework.EIDebuger.LogError(str)
end

function GameLog(...)
    print(...)
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

---
-- @function: 打印table的内容，递归
-- @param: tbl 要打印的table
-- @param: level 递归的层数，默认不用传值进来
-- @param: filteDefault 是否过滤打印构造函数，默认为是
-- @return: return
function PrintTable( tbl , level, filteDefault)
    local msg = ""
    filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
    level = level or 1
    local indent_str = ""
    for i = 1, level do
    indent_str = indent_str.."  "
    end

    print(indent_str .. "{")
    for k,v in pairs(tbl) do
        if filteDefault then
            if k ~= "_class_type" and k ~= "DeleteMe" then
                local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
                print(item_str)
                if type(v) == "table" then
                    PrintTable(v, level + 1)
                end
            end
        else
            local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
            print(item_str)
            if type(v) == "table" then
                PrintTable(v, level + 1)
            end
        end
    end
    print(indent_str .. "}")
end

function copy_table(ori_tab)
    if type(ori_tab) ~= "table" then
        return
    end
    local new_tab = {}
    for k,v in pairs(ori_tab) do
        local vtype = type(v)
        if vtype == "table" then
            new_tab[k] = copy_table(v)
        else
            new_tab[k] = v
        end
    end
    return new_tab
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end

        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

--判断字符串中 汉字、字母、数字、其他字符 的个数
function getStringNumCount(content)
    local chineseCount = 0
    local englishCount = 0
    local numberCount = 0
    local otherCount = 0
    local contentArray = string.gmatch(content, ".[\128-\191]*")
    for w in contentArray do   
        local ascii = string.byte(w)
        if (ascii >= 65 and ascii <= 90) or (ascii>=97 and ascii <=122) then
            englishCount = englishCount + 1
        elseif ascii >= 48 and ascii <= 57 then
            numberCount = numberCount + 1
        elseif (ascii >= 0 and ascii <= 47) or (ascii >= 58 and ascii <= 64) or 
            (ascii >= 91 and ascii <= 96) or (ascii >= 123 and ascii <= 127)  then
            otherCount = otherCount + 1
        else
            --ios输入法上可以输入系统表情，而此表情的ascii码值正好在这个区间，所以要用字节数来判断是否是中文
            --226 227 239 240 为ios系统表情的ascii码值
            if string.len(w) == 3 and ascii ~= 226 and ascii ~= 227 and ascii ~= 239 and ascii ~= 240  then
                chineseCount = chineseCount + 1
            else
                otherCount = otherCount + 1
            end
        end
    end
    return chineseCount,englishCount,numberCount,otherCount
end

--判断输入的字符串个数（2个英文字母算一个，1个汉字算一个，如果含特殊字符，返回-1,否则返回正确个数）
function getStringCount(content)
    local chineseCount,englishCount,numberCount,otherCount = M2.util.getCharCount(content)
    if otherCount > 0 then
        return -1
    else
        local eCount = englishCount / 2
        return chineseCount+eCount+numberCount
    end
end


--[[
    CS2Lua.lua
    统一处理c#、lua类型的方法
]]

function DictGetValue(dict, key)
    if isnil(dict) then
        return nil
    end

    if isluatype(dict) then
        if type(key) == "number" then
            key = key
        end
        return dict[key]
    else
        local enum = dict:GetEnumerator()
        local _count = 0
        while enum:MoveNext() do
            if type(key) == "string" then
                if key == enum.Current.Key then
                    return enum.Current.Value
                end
            elseif type(key) == "number" then
                if key == _count then
                    return enum.Current
                end
            end
            _count = _count + 1
        end
    end
    return nil
end

function DictSetValue(dict, key, value)
    if isnil(dict) then
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

function foreach( dict , func)
    if not isnil(dict) then
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
            if not isnil(enumerator) then
                local _index = 0
                while not isnil(enumerator) and enumerator:MoveNext() do
                    local item = {}
                    item.index = _index
                    item.current = enumerator.Current or nil
                    item.key = nil
                    item.value = nil 
                    if not isnil(item.current) then
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

function isnil( obj )
    if isluatype(obj) then
        return obj == nil
    else
        if obj ~= nil then
            -- GameLog("~~~~~A: ", obj, type(obj), typeof(obj))
            local iden = tostring(obj)
            if iden == "<invalid c# object>" then
                return true
            else
                return obj:Equals(nil)
            end
        else
            return true
        end
    end
end

function obj2str( msg )
    local ret = "nil"
    if not isnil(msg) then
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
            if ret then
                ret = tostring(ret)
            end
        end
    end
    return ret
end

function obj_len(obj)
    local count = 0
    if not isnil(obj) then
        if isluatype(obj) then
            if type(obj) == "string" then
                count = utf8.len(obj)
            elseif type(obj) == "table" then
                for i,v in pairs(obj) do
                    count = count + 1
                end
            end
        else
            count = obj.Count
        end
    end
    return count
end

--[[
    通用c#接口的实现
]]

--字符串分割函数
--传入字符串和分隔符，返回分割后的table
function Split(str, delimiter)
    if isnil(str) or isnil(delimiter) then
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

function Replace(str, sour, dict)
    if isnil(str) then
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

function div(a, b)
    return math.ceil(a / b)
end

function ToCharArray(str, m, n)
    GameLog("str:", obj2str(str), obj2str(m), obj2str(n))
    local ret = {}
    if not isnil(m) and not isnil(n) then
        if m == 0 then
            m = m + 1
            n = n + 1
        end 
        str = xutf8.sub(str, m, n)
        GameLog("change:", obj2str(str), obj2str(m), obj2str(n))
    end
    local slen = obj_len(str)
    
    for i=1, slen do
        ret[i] = string.byte(xutf8.sub(str, i, i))
    end
    return ret
end

function fromCharCode(Bytes)
    local str = ""
    if not isnil(Bytes) then
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

function Contains(str, target)
    if not isnil(str) and not isnil(target) then
        if isluatype(str) then
            if type(str) == "string" then
                return string.find(str, target) ~= nil
            else
                GameLog("Contains: argv[str] == nil.!!")
            end
        else
            return str:Contains(target)
        end
    end
end

function Trim(s)
    if not isnil(s) then
        if isluatype(s) then
            return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
        else
            return s:Trim()
        end
    end
end

function EndsWith(str, delimiter)
    if not isnil(s) then
        if isluatype(s) then
            return xstr:endswith(str, delimiter)
        else
            return str:EndsWith(delimiter)
        end
    end
end
