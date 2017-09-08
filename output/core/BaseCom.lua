
local this = nil

BaseCom = {}

function BaseCom:New(name, o)
 	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.Name = name
	return o
end

function BaseCom:Execute()
	GameLog("BaseCom:Execute")
end

function BaseCom:Awake()
	GameLog("BaseCom:Awake")
end

function BaseCom:Start()
	GameLog("BaseCom:Start")
end

function BaseCom:OnClick()
	GameLog("BaseCom:OnClick")
end

function BaseCom:Update()
	GameLog("BaseCom:Update")
end

function BaseCom:StartCoroutine( func )
	
end

function BaseCom:FindRef(root, target)
	return self:FindRef(root, target, "gameObject")
end

function BaseCom:FindRef(root, target, sComponent, fullpath)
	if root then
		sComponent = sComponent and sComponent or "gameObject"
		fullpath = fullpath and fullpath or ""
		local len = root.transform.childCount
		if fullpath == "" then
			root.name = string.gsub(root.name, "%(Clone%)", "")
			fullpath = root.name
		else
			fullpath = fullpath .. "/" .. root.name
		end
		for i=0, len-1 do
	   		local obj = root.transform:GetChild(i)
	   		if obj then
	   			local fullname = fullpath .. "/" .. obj.name
	   			if xstr:endswith(fullname, target) then
		   			--print("===>get ", fullname, obj.gameObject)
		   			if sComponent == "gameObject" then
		   				return obj.gameObject
		   			else
		   				return obj.gameObject:GetComponent(sComponent)
		   			end
	   			end
	   			local go = self:FindRef(obj.gameObject, target, sComponent, fullpath)
	   			if go then
	   				return go
	   			end
	   		end
	   	end
	end
end

