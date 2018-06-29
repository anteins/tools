--==============================================
-- LuaUtil.cs的Lua封装
-- 
--==============================================
local LuaUtil = {}

local LogicStatic = {}
function LogicStatic.Get( cs_class, id )
	if type(id) == "number" then
		return CS.LuaUtil.LogicStatic_Get(typeof(cs_class), id)
	elseif type(id) == "function" then
		local d2 = util.createdelegate(CS.System.Func, nil, CS.TestClass, 'SFoo', {typeof(CS.System.Boolean)})
		return CS.LuaUtil.LogicStatic_Get(typeof(cs_class), func)
	end
end

function LogicStatic.GetList( cs_class, id )
	return CS.LuaUtil.LogicStatic_GetList(typeof(cs_class), id)
end

local EIFrameWork = {}
function EIFrameWork.GetComponent(cs_class)
	return CS.LuaUtil.GetEIComponent(typeof(cs_class))
end

function LuaUtil.GetDataByCls(cs_class)
	return CS.LuaUtil.Net_GetDataByCls(typeof(cs_class))
end

function LuaUtil.new_Dictionary(cs_key, cs_value)
	if not cs_key or not cs_value then
		return nil
	end
	return CS.LuaUtil.new_Dictionary(typeof(cs_key), typeof(cs_value))
end

function LuaUtil.new_List(cs_class)
	if not cs_class then
		return nil
	end
	return CS.LuaUtil.new_List(typeof(cs_class))
end

function LuaUtil.new_Array(cs_class, length)
	if not cs_class or length < 1 then
		return nil
	end
	return CS.LuaUtil.GetEIComponent(typeof(cs_class), length)
end

LuaUtil.LogicStatic = LogicStatic
LuaUtil.EIFrameWork = EIFrameWork

return LuaUtil
