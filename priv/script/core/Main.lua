local this = nil

Main = BaseCom:New("Main")

function Main:HotfixMain()
	GameLog("========================= Main:HotfixMain =========================")
	if IsIOS() then
        Toast("iOS平台")
        InitGlobal()
        -- self:TestHotfix()
        self:ReleaseHotfix()
	end
end

function Main:TestHotfix()
	for i,v in pairs(g_tbHotfix) do
		if v then
			GameLog("====>hotfix: ", obj_tostring(v.Name))
			v:hotfix()
		end
	end
end

function Main:ReleaseHotfix()
    
end
