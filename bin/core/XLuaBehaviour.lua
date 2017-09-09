
function GetLuaComponent(go)
	if go and table then
		return CS.XLuaBehaviour.GetLuaComponent(go)
	end
	return nil
end

function AddLuaComponent(go, textAsset)
	if go and textAsset then
		return CS.XLuaBehaviour.AddLuaComponent(go, textAsset)
	end
	return nil
end