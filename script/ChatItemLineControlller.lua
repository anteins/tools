require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "GameUtility";
require "ItemModelCom";
require "AvatarModelCom";
require "EquipmentModelCom";
require "NGUITools";
require "ItemModelUtility";
require "LogicStatic";

ChatItemLineControlller = {
	__new_object = function(...)
		return newobject(ChatItemLineControlller, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatItemLineControlller;

		local static_methods = {
			cctor = function()
				EIUIBehaviour.cctor(this);
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				_eachLineItemCount = 6,
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			SetData = function(this, cEnum, datalist, callbackClickItem)
				this:HideAllItem();
				this._dataList = datalist;
				delegationset(false, false, "ChatItemLineControlller:_callbackClickItem", this, nil, "_callbackClickItem", callbackClickItem);
				if (cEnum == 0) then
					if (this._itemModelList.Count == 0) then
						this:InitModels(cEnum);
					end;
				elseif (cEnum == 2) then
					if (this._avatorModelList.Count == 0) then
						this:InitModels(cEnum);
					end;
				elseif (cEnum == 1) then
					if (this._equipmentModelList.Count == 0) then
						this:InitModels(cEnum);
					end;
				end;
				this:InitDatas(cEnum);
			end,
			HideAllItem = function(this)
				this._itemModelList:ForEach((function(F) return F.gameObject:SetActive(false); end));
				this._equipmentModelList:ForEach((function(F) return F.gameObject:SetActive(false); end));
				this._avatorModelList:ForEach((function(F) return F.gameObject:SetActive(false); end));
			end,
			InitModels = function(this, cEnum)
				local index; index = 0;
				while (index < ChatItemLineControlller._eachLineItemCount) do
					if (cEnum == 0) then
						local go; go = GameUtility.InstantiateGameObject(this._itemModelPrefab, this._grid.gameObject, System.String.Format("{0}{1}", "item", index), nil, nil, nil);
						go.gameObject:SetActive(false);
						local com; com = go:GetComponent(ItemModelCom);
						delegationset(false, false, "ItemModelCom:onClick", com, nil, "onClick", (function() local __compiler_delegation_73 = (function() this:OnClickItem(); end); setdelegationkey(__compiler_delegation_73, "ChatItemLineControlller:OnClickItem", this, this.OnClickItem); return __compiler_delegation_73; end)());
						this._itemModelList:Add(com);
					elseif (cEnum == 2) then
						local go; go = GameUtility.InstantiateGameObject(this._avatorModelPrefab, this._grid.gameObject, System.String.Format("{0}{1}", "avator", index), nil, nil, nil);
						go.gameObject:SetActive(false);
						local com; com = go:GetComponent(AvatarModelCom);
						this._avatorModelList:Add(com);
					elseif (cEnum == 1) then
						local go; go = GameUtility.InstantiateGameObject(this._equipmentModelPrefab, this._grid.gameObject, System.String.Format("{0}{1}", "equipment", index), nil, nil, nil);
						go.gameObject:SetActive(false);
						local com; com = go:GetComponent(EquipmentModelCom);
						delegationset(false, false, "EquipmentModelCom:onClick", com, nil, "onClick", (function() local __compiler_delegation_88 = (function(eid) this:OnClickEquipment(eid); end); setdelegationkey(__compiler_delegation_88, "ChatItemLineControlller:OnClickEquipment", this, this.OnClickEquipment); return __compiler_delegation_88; end)());
						this._equipmentModelList:Add(com);
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
			end,
			InitDatas = function(this, cEnum)
				if (cEnum == 0) then
					local index; index = 0;
					while (index < this._itemModelList.Count) do
						if (index < this._dataList.Count) then
							local itemserdata; itemserdata = typeas(getexterninstanceindexer(this._dataList, nil, "get_Item", index), EightGame.Data.Server.ItemSerData, false);
							if (itemserdata == nil) then
								getexterninstanceindexer(this._itemModelList, nil, "get_Item", index).gameObject:SetActive(false);
								return ;
							end;
							getexterninstanceindexer(this._itemModelList, nil, "get_Item", index).gameObject:SetActive(true);
							NGUITools.AddWidgetCollider__UnityEngine_GameObject(getexterninstanceindexer(this._itemModelList, nil, "get_Item", index).gameObject);
							ItemModelUtility.UpdateView__ItemModelCom__EightGame_Data_Server_ItemSerData__System_Boolean__System_Boolean(ItemModelUtility, getexterninstanceindexer(this._itemModelList, nil, "get_Item", index), itemserdata, false, false);
						else
							getexterninstanceindexer(this._itemModelList, nil, "get_Item", index).gameObject:SetActive(false);
						end;
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				elseif (cEnum == 2) then
					local index; index = 0;
					while (index < this._avatorModelList.Count) do
						if (index < this._dataList.Count) then
							local figherserdata; figherserdata = typeas(getexterninstanceindexer(this._dataList, nil, "get_Item", index), EightGame.Data.Server.FighterSerData, false);
							if (figherserdata == nil) then
								getexterninstanceindexer(this._avatorModelList, nil, "get_Item", index).gameObject:SetActive(false);
								return ;
							end;
							local role; role = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_role_role), figherserdata.staticId);
							if (role == nil) then
								getexterninstanceindexer(this._avatorModelList, nil, "get_Item", index).gameObject:SetActive(false);
								return ;
							end;
							local skin; skin = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_role_skin), figherserdata.skin);
							if (skin == nil) then
								getexterninstanceindexer(this._avatorModelList, nil, "get_Item", index).gameObject:SetActive(false);
								return ;
							end;
							getexterninstanceindexer(this._avatorModelList, nil, "get_Item", index).gameObject:SetActive(true);
							NGUITools.AddWidgetCollider__UnityEngine_GameObject(getexterninstanceindexer(this._avatorModelList, nil, "get_Item", index).gameObject);
							getexterninstanceindexer(this._avatorModelList, nil, "get_Item", index):ShowRoleAvatarData(skin.common, role.element, role.job, figherserdata.level, figherserdata.quality, true);
						else
							getexterninstanceindexer(this._avatorModelList, nil, "get_Item", index).gameObject:SetActive(false);
						end;
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				elseif (cEnum == 1) then
					local index; index = 0;
					while (index < this._equipmentModelList.Count) do
						if (index < this._dataList.Count) then
							local equipmentserdata; equipmentserdata = typeas(getexterninstanceindexer(this._dataList, nil, "get_Item", index), EightGame.Data.Server.EquipmentSerData, false);
							if (equipmentserdata == nil) then
								getexterninstanceindexer(this._equipmentModelList, nil, "get_Item", index).gameObject:SetActive(false);
								return ;
							end;
							local equipmentStatic; equipmentStatic = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_equipment_equip), equipmentserdata.staticid);
							if (equipmentStatic == nil) then
								getexterninstanceindexer(this._equipmentModelList, nil, "get_Item", index).gameObject:SetActive(false);
								return ;
							end;
							getexterninstanceindexer(this._equipmentModelList, nil, "get_Item", index).gameObject:SetActive(true);
							NGUITools.AddWidgetCollider__UnityEngine_GameObject(getexterninstanceindexer(this._equipmentModelList, nil, "get_Item", index).gameObject);
							getexterninstanceindexer(this._equipmentModelList, nil, "get_Item", index).SpriteWeared:SetActive((equipmentserdata.wearfighter > 0));
							getexterninstanceindexer(this._equipmentModelList, nil, "get_Item", index):SetValue(equipmentserdata.id, equipmentStatic.rank, equipmentStatic.icon, equipmentStatic.uselv, equipmentserdata.rankuplv, 99999);
						else
							getexterninstanceindexer(this._equipmentModelList, nil, "get_Item", index).gameObject:SetActive(false);
						end;
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				end;
				this._grid.repositionNow = true;
			end,
			OnClickItem = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", ItemModelCom.current, nil) then
					local serdata; serdata = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.ItemSerData), ItemModelCom.current.GID);
					if (serdata == nil) then
						return ;
					end;
					if externdelegationcomparewithnil(false, false, "ChatItemLineControlller:_callbackClickItem", this, nil, "_callbackClickItem", false) then
						this._callbackClickItem(serdata);
					end;
				end;
			end,
			OnClickEquipment = function(this, eid)
				local serdata; serdata = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.EquipmentSerData), eid);
				if (serdata == nil) then
					return ;
				end;
				if externdelegationcomparewithnil(false, false, "ChatItemLineControlller:_callbackClickItem", this, nil, "_callbackClickItem", false) then
					this._callbackClickItem(serdata);
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_grid = __cs2lua_nil_field_value,
				_itemModelPrefab = __cs2lua_nil_field_value,
				_equipmentModelPrefab = __cs2lua_nil_field_value,
				_avatorModelPrefab = __cs2lua_nil_field_value,
				_itemModelList = newexternlist(System.Collections.Generic.List_ItemModelCom, "System.Collections.Generic.List_ItemModelCom", "ctor", {}),
				_equipmentModelList = newexternlist(System.Collections.Generic.List_EquipmentModelCom, "System.Collections.Generic.List_EquipmentModelCom", "ctor", {}),
				_avatorModelList = newexternlist(System.Collections.Generic.List_AvatarModelCom, "System.Collections.Generic.List_AvatarModelCom", "ctor", {}),
				_dataList = newexternlist(System.Collections.Generic.List_System.Object, "System.Collections.Generic.List_System.Object", "ctor", {}),
				_callbackClickItem = delegationwrap(),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatItemLineControlller", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatItemLineControlller.__define_class();
