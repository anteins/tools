require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ChatWorldChanelItemCom";

ChatWorldChanelController = {
	__new_object = function(...)
		return newobject(ChatWorldChanelController, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatWorldChanelController;

		local static_methods = {
			cctor = function()
			end,
		};

		local static_fields_build = function()
			local static_fields = {
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			SetData = function(this, notify, callbackSelect)
				this._notify = notify;
				this._notify.msgList:Sort((function(x, y)
					if (x.word_room_id > y.word_room_id) then
						return 1;
					elseif (x.word_room_id < y.word_room_id) then
						return -1;
					else
						return 0;
					end;
				end));
				delegationset(false, false, "ChatWorldChanelController:_callbackSelect", this, nil, "_callbackSelect", callbackSelect);
				this:MatchBgSpriteAndPanel();
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._uiRecycledList, nil) then
					delegationset(false, false, "UIRecycledList:onUpdateItem", this._uiRecycledList, nil, "onUpdateItem", (function() local __compiler_delegation_38 = (function(go, itemIndex, dataIndex) this:OnUpdateItem(go, itemIndex, dataIndex); end); setdelegationkey(__compiler_delegation_38, "ChatWorldChanelController:OnUpdateItem", this, this.OnUpdateItem); return __compiler_delegation_38; end)());
				end;
				Eight.Framework.EIFrameWork.StartCoroutine(this:LoadPrefab(), false);
			end,
			OnUpdateItem = function(this, go, itemIndex, dataIndex)
				if (dataIndex < this._notify.msgList.Count) then
					local com; com = nil;
					if (function() local __compiler_invoke_47; __compiler_invoke_47, com = this._applicationItemDic:TryGetValue(go); return __compiler_invoke_47; end)() then
						if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", com, nil) then
							return ;
						end;
						com:SetData(getexterninstanceindexer(this._notify.msgList, nil, "get_Item", dataIndex), (function() local __compiler_delegation_50 = (function(msg) this:CallbackSelect(msg); end); setdelegationkey(__compiler_delegation_50, "ChatWorldChanelController:CallbackSelect", this, this.CallbackSelect); return __compiler_delegation_50; end)(), (this._notify.chanelId == getexterninstanceindexer(this._notify.msgList, nil, "get_Item", dataIndex).word_room_id));
					end;
				end;
			end,
			CallbackSelect = function(this, msg)
				if externdelegationcomparewithnil(false, false, "ChatWorldChanelController:_callbackSelect", this, nil, "_callbackSelect", false) then
					this._callbackSelect(msg);
				end;
			end,
			LoadPrefab = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._prefab, nil) then
					local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(System.String.Format("{0}{1}", "GameAssets/Prefabs/UI/", this._itemLinePrefabPath), "prefab", false);
					wrapyield(coroutine.coroutine, false, true);
					this._prefab = typeas(coroutine.res, UnityEngine.GameObject, false);
					this:InitItems();
				end;
				this._uiRecycledList:UpdateDataCount(this._notify.msgList.Count, true);
			end),
			InitItems = function(this)
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._prefab, nil) or (this._applicationItemDic.Count > 0)) then
					return ;
				end;
				local index; index = 0;
				while (index < 12) do
					local go; go = GameUtility.InstantiateGameObject(this._prefab, this._uiRecycledList.gameObject, ("WorldChanel" + index), nil, nil, nil);
					local r; r = go:GetComponent(ChatWorldChanelItemCom);
					this._applicationItemDic:Add(go, r);
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
			end,
			OnClickClose = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this, nil) then
					this.gameObject:SetActive(false);
				end;
			end,
			MatchBgSpriteAndPanel = function(this)
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._bgSprite, nil) or invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._bgPanel, nil)) then
					return ;
				end;
				local height; height = invokeintegeroperator(4, "*", 30, this._notify.msgList.Count, System.Int32, System.Int32);
				if (height < 150) then
					height = 150;
				end;
				if (height > 450) then
					height = 450;
				end;
				this._bgSprite:SetDimensions(this._bgSprite.width, height);
				this._bgPanel:SetRect(0, UnityEngine.Mathf.CeilToInt((height / 2.00)), 176.00, ( (height - 5.00) ));
				this._bgPanel.clipOffset = UnityEngine.Vector2.zero;
				this._bgPanel.transform.localPosition = UnityEngine.Vector3.zero;
				this._uiRecycledList.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 0, (height - 20.00), 0);
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_uiRecycledList = __cs2lua_nil_field_value,
				_bgSprite = __cs2lua_nil_field_value,
				_bgPanel = __cs2lua_nil_field_value,
				_itemLinePrefabPath = "ChatUI/ChatWorldChanelLabel",
				_applicationItemDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatWorldChanelItemCom, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatWorldChanelItemCom", "ctor", {}),
				_prefab = __cs2lua_nil_field_value,
				_callbackSelect = delegationwrap(),
				_notify = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ChatWorldChanelController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatWorldChanelController.__define_class();
