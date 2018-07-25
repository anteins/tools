
local PlatformUtil = require("core.utils.PlatformUtil")
local LuaUtil = require("core.utils.LuaUtil")
local Hotfix = require("Hotfix")
Main = {}

function Main:HotfixMain()
	print("========================= Main:HotfixMain =========================")
	if PlatformUtil:IsIOS() then
        print("========================= iOS平台 =========================")
        Toast("iOS平台")
        -- self:InitGlobal()
        -- self:TestHotfix()
        -- self:ReleaseHotfix()
    else
        print("========================= Normal平台 =========================")
    	self:InitGlobal()
        self:TestHotfix()
        self:ReleaseHotfix()
	end
end

function Main:TestHotfix()
	for i, modname in pairs(Hotfix:GetList()) do
		if modname then
            local mod = require("hotfix." .. modname)
            if mod then
                try(function ()
                    mod:hotfix()
                    print("==================>hotfix setup: " .. modname)
                end, function (exception)
                    print("================== hotfix error! ==================")
                    print(modname)
                    print(exception)
                    print("================== hotfix error! ==================")
                    return
                end)
            end
		end
	end
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
