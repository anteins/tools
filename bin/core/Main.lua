local this = nil
local file = nil

Main = BaseCom:New("Main")

function Main:Ref(ref)
	if ref then
		this = ref
	end
	return this
end

function Main:__init(ref)
	self:HotFix()
	--memory()
	return IsLuaMode
end

function Main:HotFix()
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
			GameLog("hotfix...", obj_tostring(v.Name))
			v:hotfix()
		end
	end
end

function Main:releaseHotfix()
    
end
