function test_generic_call() then
	local obj = CS.XLuaReflectionMethod()
	-- local Get_int32 = obj:FindMethods(typeof(LogicStatic), "Get", 1, {typeof(CS.System.Int32)})
	-- local Get_int64 = obj:FindMethods(typeof(LogicStatic), "Get", 1, {typeof(CS.System.Int64)})
	-- local ret = obj:Call(Get_int32, {
	-- 		T= typeof(CS.EightGame.Data.Server.sd_gamerule),
	-- 		args = {9008}
	-- 	}
	-- )
	-- GameLog("ret32.value", ret.value)

	-- local ret = obj:Call(Get_int64, {
	-- 	T= typeof(CS.EightGame.Data.Server.sd_gamerule),
	-- 	args = {9008}}
	-- )
	-- GameLog("ret64.value", ret.value)


	local GetList = obj:FindMethods(typeof(LogicStatic), "GetList", 1, {})
	local tt = typeof("System.Predicate`1[EightGame.Data.Server.sd_role_role]")
	GameLog("tt", tt)
	local retlist = obj:Call(GetList, {
		T= typeof(CS.EightGame.Data.Server.sd_role_role),
		args = {tt}}
	)
	GameLog("retlist", retlist)
end