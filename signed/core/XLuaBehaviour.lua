/~�k�����4�[i��Usu����pL�����a[]me�x:SR	b�~�:�̊9�ӿjW�E��Bۂ �.D�N�XW�N�Q�Sxg?�2ǂ��$?�:nN�릜�Zj��3,��5?�Ι
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