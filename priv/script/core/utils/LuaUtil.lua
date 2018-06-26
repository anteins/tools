--==============================================
-- LuaUtil.cs的Lua封装
-- 
--==============================================
local LuaUtil = {}

local LogicStatic = {}
function LogicStatic.Get( cs_class, id )
	return CS.LuaUtil.LogicStatic_Get(typeof(cs_class), id)
end


local EIFrameWork = {}
function EIFrameWork.GetComponent(cs_class)
	return CS.LuaUtil.GetEIComponent(typeof(cs_class))
end

return {
	LogicStatic = LogicStatic,
	EIFrameWork = EIFrameWork,
}