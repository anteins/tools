
local PlatformUtil = require("core.utils.PlatformUtil")
local LuaUtil = require("core.utils.LuaUtil")
Main = class("Main", nil)

function Main:HotfixMain()
	GameLog("========================= Main:HotfixMain =========================")
	if PlatformUtil:IsIOS() then
        Toast("iOS平台")
        -- self:InitGlobal()
        -- self:TestHotfix()
        -- self:ReleaseHotfix()
    else
    	self:InitGlobal()
        self:TestHotfix()
        self:ReleaseHotfix()
	end
end

function Main:TestHotfix()
	local hotfix_model = require("hotfix.EightGame__Logic__SettingWindowEnterController")
    local exploreviewnode = require("hotfix.eightgame__logic__exploreviewnode")
	if exploreviewnode then
		exploreviewnode:hotfix()
	end
	-- for i,v in pairs(g_tbHotfix) do
	-- 	if v then
	-- 		GameLog("====>hotfix: ", obj_tostring(v.Name))
	-- 		v:hotfix()
	-- 	end
	-- end
end

function Main:ReleaseHotfix()
    
end

function Main:InitGlobal()
    local ClassName = require("core/CsClassName")
    for i, clazz_name in pairs(ClassName) do
        local clazz_load_f = load("return " .. clazz_name)
        if type(clazz_load_f) == "function" then
            _G[i] = clazz_load_f()
            -- self:private_accessible(clazz_name, _G[i])
        end
    end
end

function Main:private_accessible( clazz_name, clazz )
    try(function ()
        -- print("private_accessible ", clazz_name)
        xlua.private_accessible(clazz)
    end, function ( exception )
        error = exception
        local error_str = "error:[" .. i .. "]:" .. exception .. "\n", debug.traceback()
        local file = io.open(CS.PathUtility:GetDataPath() .. "/luaError.log", "w")
        assert(file)
        file:write(error_str)
        GameLog(error_str)
    end)
end
