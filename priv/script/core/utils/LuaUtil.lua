--==============================================
-- LuaUtil.cs的Lua封装
-- 
--==============================================
local LuaUtil = {}

local LogicStatic = {}
function LogicStatic.Get( cs_class, args )
	local tt = cs_class
	if type(cs_class) ~= "userdata" then
		--is not yield typeof
		tt = typeof(cs_class)
	end

	if type(args) == "number" then
		local id = args
		return CS.LuaUtil.LogicStatic_Get(tt, id)
	elseif type(iargsd) == "function" then
		local func = args
		return CS.LuaUtil.LogicStatic_Get(tt, func)
	else
		return CS.LuaUtil.LogicStatic_Get(tt)
	end
end

function LogicStatic.GetList( cs_class, args)
	local tt = cs_class
	if type(cs_class) ~= "userdata" then
		--is not yield typeof
		tt = typeof(cs_class)
	end

	if type(args) == "number" then
		local id = args
		return CS.LuaUtil.LogicStatic_GetList(tt, id)
	elseif type(iargsd) == "function" then
		local func = args
		return CS.LuaUtil.LogicStatic_GetList(tt, func)
	else
		return CS.LuaUtil.LogicStatic_GetList(tt)
	end
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
