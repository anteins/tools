ÂñØJe‡u©uˆÇYšO'•
xÓuë7Oî××ÀÀ¡_¡Ï­<iþZ<É`È!`<@hLQÁZ…R‚,óÊKÃÎÐÇ’•¼çìî{A²
	f%Nì…ÓÁÓ@÷d†œþ7¬ ²ˆ¹Æ Íú¦å®¬3U,)¹>;¦aÍlocal this = nil
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
	-- if IsLuaMode and IsIOS() then
 --        toast("iOSçƒ­æ›´")
 --        initGlobal(file)
 --        self:testHotfix()
 --        self:releaseHotfix()
	-- end
    initGlobal(file)
    self:testHotfix()
    toast("xluaçƒ­æ›´")
end

function Main:testHotfix()
	for i,v in pairs(g_tbHotfix) do
		if v then
			GameLog("hotfixing: ", obj2str(v.Name))
			v:hotfix()
		end
	end
    -- LoginServerCom:hotfix()
end

function Main:releaseHotfix()
    
end

function UpdateBeat( ... )
	-- GameLog("g_UpdateBeat")
end

function LateUpdateEvent( ... )
	-- GameLog("g_LateUpdateEvent")
end

function FixedUpdateEvent( ... )
	-- GameLog("g_FixedUpdateEvent")
end

