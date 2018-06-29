
Main = class("Main", nil)

function Main:HotfixMain()
	GameLog("========================= Main:HotfixMain =========================")
	if IsIOS() then
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
    local count = 0
    local ClassName = require("core/CsClassName")
    for i,v in pairs(ClassName) do
        local _load = load("return " .. v)
        if type(_load) == "function" then
            _G[i] = _load()
            try(function ()
                xlua.private_accessible(_G[i])
            end, function ( exception )
                error = exception
                local error_str = "error:[" .. i .. "]:" .. _e_ .. "\n", debug.traceback()
                local file = io.open(CS.PathUtility:GetDataPath() .. "/luaError.log", "w")
                assert(file)
                file:write(error_str)
                GameLog(error_str)
            end)
            count = count + 1
        end
    end
end
