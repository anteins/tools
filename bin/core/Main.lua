local this = nil
local file = nil

Main = BaseCom:New("Main")

function Main:__init(ref)
	self:HotfixMain()
end

function Main:HotfixMain()
	GameLog("========================= Main:HotfixMain =========================")
	if IsIOS() then
        toast("iOS平台")
        initGlobal(file)
        self:testHotfix()
        self:releaseHotfix()
    else
    	toast("...........")
	end
end

function Main:testHotfix()
	for i,v in pairs(g_tbHotfix) do
		if v then
			GameLog("====>hotfix: ", obj_tostring(v.Name))
			v:hotfix()
		end
	end
end

function Main:releaseHotfix()
    
end
