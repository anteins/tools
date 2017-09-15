require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ChatItemLineControlller";
require "LogicStatic";
require "EquipmentUtil";

ChatShowPanelController = {
	__new_object = function(...)
		return newobject(ChatShowPanelController, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatShowPanelController;

		local static_methods = {
			cctor = function()
				EIUIBehaviour.cctor(this);
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				_latestShowItemBtnCom = __cs2lua_nil_field_value,
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			SetData = function(this, callbackSelectItem)
				this._sourceDatas:Clear();
				delegationset(false, false, "ChatShowPanelController:_callbackSelectItem", this, nil, "_callbackSelectItem", callbackSelectItem);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._uiRecycledList, nil) then
					delegationset(false, false, "UIRecycledList:onUpdateItem", this._uiRecycledList, nil, "onUpdateItem", (function() local __compiler_delegation_37 = (function(go, itemIndex, dataIndex) this:OnUpdateItem(go, itemIndex, dataIndex); end); setdelegationkey(__compiler_delegation_37, "ChatShowPanelController:OnUpdateItem", this, this.OnUpdateItem); return __compiler_delegation_37; end)());
				end;
				Eight.Framework.EIFrameWork.StartCoroutine(this:LoadPrefab(), false);
			end,
			LoadPrefab = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._itemLinePrefab, nil) then
					local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(System.String.Format("{0}{1}", "GameAssets/Prefabs/UI/", this._itemLinePrefabPath), "prefab", false);
					wrapyield(coroutine.coroutine, false, true);
					this._itemLinePrefab = typeas(coroutine.res, UnityEngine.GameObject, false);
					this:InitItemLine();
					this:InitBtns();
				else
					this:InitBtns();
				end;
			end),
			InitItemLine = function(this)
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._itemLinePrefab, nil) or (this._applicationItemDic.Count > 0)) then
					return ;
				end;
				local index; index = 0;
				while (index < 5) do
					local go; go = GameUtility.InstantiateGameObject(this._itemLinePrefab, this._uiRecycledList.gameObject, ("itemLine" + index), nil, nil, nil);
					local r; r = go:GetComponent(ChatItemLineControlller);
					this._applicationItemDic:Add(go, r);
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
			end,
			InitBtns = function(this)
				local enumlist; enumlist = newexternlist(System.Collections.Generic.List_ChatShowItemBtnCom.ChatShowItemEnum, "System.Collections.Generic.List_ChatShowItemBtnCom.ChatShowItemEnum", "ctor", {});
				enumlist:Add(0);
				enumlist:Add(1);
--enumlist.Add( ChatShowItemBtnCom.ChatShowItemEnum.Show_Role );
				local index; index = 0;
				while (index < this._btns.Count) do
					if (index < enumlist.Count) then
						getexterninstanceindexer(this._btns, nil, "get_Item", index).gameObject:SetActive(true);
						getexterninstanceindexer(this._btns, nil, "get_Item", index):SetData(getexterninstanceindexer(enumlist, nil, "get_Item", index), (function() local __compiler_delegation_86 = (function(com) this:CallbackSelectBtn(com); end); setdelegationkey(__compiler_delegation_86, "ChatShowPanelController:CallbackSelectBtn", this, this.CallbackSelectBtn); return __compiler_delegation_86; end)());
						getexterninstanceindexer(this._btns, nil, "get_Item", index):SetBtnSprite(false);
					else
						getexterninstanceindexer(this._btns, nil, "get_Item", index).gameObject:SetActive(false);
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				this:CallbackSelectBtn(getexterninstanceindexer(this._btns, nil, "get_Item", 0));
			end,
			CallbackSelectBtn = function(this, com)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", ChatShowPanelController._latestShowItemBtnCom, nil) then
					ChatShowPanelController._latestShowItemBtnCom:SetBtnSprite(false);
				end;
				ChatShowPanelController._latestShowItemBtnCom = com;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", ChatShowPanelController._latestShowItemBtnCom, nil) then
					ChatShowPanelController._latestShowItemBtnCom:SetBtnSprite(true);
				end;
				this._curBtnEnum = com._enum;
				this._sourceDatas:Clear();
				if (this._curBtnEnum == 0) then
					this:InitItemData();
				elseif (this._curBtnEnum == 1) then
					this:InitEquipmentData();
				elseif (this._curBtnEnum == 2) then
					this:InitAvatorData();
				end;
				this._uiRecycledList:UpdateDataCount(UnityEngine.Mathf.CeilToInt((typecast(this._sourceDatas.Count, System.Single, false) / ChatItemLineControlller._eachLineItemCount)), true);
			end,
			InitItemData = function(this)
				this._itemSerDatas:Clear();
				local datas; datas = LogicStatic.GetList(typeof(EightGame.Data.Server.ItemSerData), nil);
				if ((datas == nil) or (datas.Count == 0)) then
					return ;
				end;
				this._itemSerDatas:AddRange(datas);
				if ((this._itemSerDatas == nil) or (this._itemSerDatas.Count == 0)) then
					return ;
				end;
				this._itemSerDatas:ForEach((function(F) return this._sourceDatas:Add(typeas(F, System.Object, false)); end));
			end,
			InitEquipmentData = function(this)
				this._equipmentSerDatas:Clear();
				local datas; datas = LogicStatic.GetList(typeof(EightGame.Data.Server.EquipmentSerData), nil);
				if ((datas == nil) or (datas.Count == 0)) then
					return ;
				end;
				this._equipmentSerDatas = EquipmentUtil.SortEquipDataList(datas);
				if (this._equipmentSerDatas == nil) then
					return ;
				end;
				this._equipmentSerDatas:ForEach((function(F) return this._sourceDatas:Add(typeas(F, System.Object, false)); end));
			end,
			InitAvatorData = function(this)
				this._fighterSerDatas:Clear();
				local datas; datas = LogicStatic.GetList(typeof(EightGame.Data.Server.FighterSerData), nil);
				if ((datas == nil) or (datas.Count == 0)) then
					return ;
				end;
				this._fighterSerDatas:AddRange(datas);
				if (this._fighterSerDatas == nil) then
					return ;
				end;
				this._fighterSerDatas:ForEach((function(F) return this._sourceDatas:Add(typeas(F, System.Object, false)); end));
			end,
			OnUpdateItem = function(this, go, itemIndex, dataIndex)
				local com; com = nil;
				if (function() local __compiler_invoke_166; __compiler_invoke_166, com = this._applicationItemDic:TryGetValue(go); return __compiler_invoke_166; end)() then
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", com, nil) then
						return ;
					end;
					if ((this._sourceDatas.Count > 0) and (dataIndex < this._sourceDatas.Count)) then
--更新界面
						com:SetData(this._curBtnEnum, this:GetItemSerDatasByDataIndex(this._sourceDatas, dataIndex), (function() local __compiler_delegation_172 = (function(obj) this:OnSelectionChange(obj); end); setdelegationkey(__compiler_delegation_172, "ChatShowPanelController:OnSelectionChange", this, this.OnSelectionChange); return __compiler_delegation_172; end)());
					end;
				end;
			end,
			GetItemSerDatasByDataIndex = function(this, sourcedatas, dataIndex)
				local resulutDatas; resulutDatas = newexternlist(System.Collections.Generic.List_System.Object, "System.Collections.Generic.List_System.Object", "ctor", {});
				if ((sourcedatas == nil) or (sourcedatas.Count == 0)) then
					return resulutDatas;
				end;
				if (sourcedatas.Count < ( invokeintegeroperator(4, "*", ( invokeintegeroperator(2, "+", dataIndex, 1, System.Int32, System.Int32) ), ChatItemLineControlller._eachLineItemCount, System.Int32, System.Int32) )) then
					if (invokeintegeroperator(3, "-", sourcedatas.Count, invokeintegeroperator(4, "*", dataIndex, ChatItemLineControlller._eachLineItemCount, System.Int32, System.Int32), System.Int32, System.Int32) > 0) then
						resulutDatas = sourcedatas:GetRange(invokeintegeroperator(4, "*", dataIndex, ChatItemLineControlller._eachLineItemCount, System.Int32, System.Int32), invokeintegeroperator(3, "-", sourcedatas.Count, invokeintegeroperator(4, "*", dataIndex, ChatItemLineControlller._eachLineItemCount, System.Int32, System.Int32), System.Int32, System.Int32));
					end;
				else
					resulutDatas = sourcedatas:GetRange(invokeintegeroperator(4, "*", dataIndex, ChatItemLineControlller._eachLineItemCount, System.Int32, System.Int32), ChatItemLineControlller._eachLineItemCount);
				end;
				return resulutDatas;
			end,
			OnSelectionChange = function(this, obj)
				if externdelegationcomparewithnil(false, false, "ChatShowPanelController:_callbackSelectItem", this, nil, "_callbackSelectItem", false) then
					this._callbackSelectItem(obj);
				end;
			end,
			OnClickClose = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this, nil) then
					this.gameObject:SetActive(false);
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_btns = newexternlist(System.Collections.Generic.List_ChatShowItemBtnCom, "System.Collections.Generic.List_ChatShowItemBtnCom", "ctor", {}),
				_uiRecycledList = __cs2lua_nil_field_value,
				_itemLinePrefabPath = "ChatUI/ShowItemLine",
				_itemLinePrefab = __cs2lua_nil_field_value,
				_itemModelPrefab = __cs2lua_nil_field_value,
				_equipmentPrefab = __cs2lua_nil_field_value,
				_avatarPrefab = __cs2lua_nil_field_value,
				_applicationItemDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatItemLineControlller, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatItemLineControlller", "ctor", {}),
				_curBtnEnum = 0,
				_sourceDatas = newexternlist(System.Collections.Generic.List_System.Object, "System.Collections.Generic.List_System.Object", "ctor", {}),
				_callbackSelectItem = delegationwrap(),
				_itemSerDatas = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.ItemSerData, "System.Collections.Generic.List_EightGame.Data.Server.ItemSerData", "ctor", {}),
				_equipmentSerDatas = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.EquipmentSerData, "System.Collections.Generic.List_EightGame.Data.Server.EquipmentSerData", "ctor", {}),
				_fighterSerDatas = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.FighterSerData, "System.Collections.Generic.List_EightGame.Data.Server.FighterSerData", "ctor", {}),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatShowPanelController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatShowPanelController.__define_class();
