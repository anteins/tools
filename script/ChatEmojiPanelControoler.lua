require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "LogicStatic";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "ChatEmojiLineControoler";
require "GameUtility";

ChatEmojiPanelControoler = {
	__new_object = function(...)
		return newobject(ChatEmojiPanelControoler, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatEmojiPanelControoler;

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
			SetData = function(this, callbackSelectEmoji)
				delegationset(false, false, "ChatEmojiPanelControoler:_callbackSelectEmoji", this, nil, "_callbackSelectEmoji", callbackSelectEmoji);
				if ((this.chatemojis == nil) or (this.chatemojis.Count == 0)) then
					this.chatemojis = LogicStatic.GetList(typeof(EightGame.Data.Server.sd_chatemoji), nil);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._uiRecycledList, nil) then
					delegationset(false, false, "UIRecycledList:onUpdateItem", this._uiRecycledList, nil, "onUpdateItem", (function() local __compiler_delegation_33 = (function(go, itemIndex, dataIndex) this:OnUpdateItem(go, itemIndex, dataIndex); end); setdelegationkey(__compiler_delegation_33, "ChatEmojiPanelControoler:OnUpdateItem", this, this.OnUpdateItem); return __compiler_delegation_33; end)());
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
			InitBtns = function(this)
				local enumlist; enumlist = newexternlist(System.Collections.Generic.List_ChatShowItemBtnCom.ChatShowItemEnum, "System.Collections.Generic.List_ChatShowItemBtnCom.ChatShowItemEnum", "ctor", {});
				enumlist:Add(3);
				local index; index = 0;
				while (index < this._btns.Count) do
					if (index < enumlist.Count) then
						getexterninstanceindexer(this._btns, nil, "get_Item", index).gameObject:SetActive(true);
						getexterninstanceindexer(this._btns, nil, "get_Item", index):SetData(getexterninstanceindexer(enumlist, nil, "get_Item", index), (function() local __compiler_delegation_64 = (function(com) this:CallbackSelectBtn(com); end); setdelegationkey(__compiler_delegation_64, "ChatEmojiPanelControoler:CallbackSelectBtn", this, this.CallbackSelectBtn); return __compiler_delegation_64; end)());
						getexterninstanceindexer(this._btns, nil, "get_Item", index):SetBtnSprite(false);
					else
						getexterninstanceindexer(this._btns, nil, "get_Item", index).gameObject:SetActive(false);
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				this:CallbackSelectBtn(getexterninstanceindexer(this._btns, nil, "get_Item", 0));
			end,
			CallbackSelectBtn = function(this, com)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", ChatEmojiPanelControoler._latestShowItemBtnCom, nil) then
					ChatEmojiPanelControoler._latestShowItemBtnCom:SetBtnSprite(false);
				end;
				ChatEmojiPanelControoler._latestShowItemBtnCom = com;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", ChatEmojiPanelControoler._latestShowItemBtnCom, nil) then
					ChatEmojiPanelControoler._latestShowItemBtnCom:SetBtnSprite(true);
				end;
				this._curBtnEnum = com._enum;
				if (this._curBtnEnum == 3) then
				end;
				this._uiRecycledList:UpdateDataCount(UnityEngine.Mathf.CeilToInt((typecast(this.chatemojis.Count, System.Single, false) / ChatEmojiLineControoler._eachLineItemCount)), true);
			end,
			InitItemLine = function(this)
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._itemLinePrefab, nil) or (this._applicationItemDic.Count > 0)) then
					return ;
				end;
				local index; index = 0;
				while (index < 5) do
					local go; go = GameUtility.InstantiateGameObject(this._itemLinePrefab, this._uiRecycledList.gameObject, ("itemLine" + index), nil, nil, nil);
					local r; r = go:GetComponent(ChatEmojiLineControoler);
					this._applicationItemDic:Add(go, r);
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
			end,
			OnUpdateItem = function(this, go, itemIndex, dataIndex)
				local com; com = nil;
				if (function() local __compiler_invoke_114; __compiler_invoke_114, com = this._applicationItemDic:TryGetValue(go); return __compiler_invoke_114; end)() then
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", com, nil) then
						return ;
					end;
					if ((this.chatemojis.Count > 0) and (dataIndex < this.chatemojis.Count)) then
--更新界面
						com:SetData(this._curBtnEnum, this:GetItemSerDatasByDataIndex(this.chatemojis, dataIndex), (function() local __compiler_delegation_120 = (function(com) this:CallbackSelectEmoji(com); end); setdelegationkey(__compiler_delegation_120, "ChatEmojiPanelControoler:CallbackSelectEmoji", this, this.CallbackSelectEmoji); return __compiler_delegation_120; end)());
					end;
				end;
			end,
			CallbackSelectEmoji = function(this, com)
				if externdelegationcomparewithnil(false, false, "ChatEmojiPanelControoler:_callbackSelectEmoji", this, nil, "_callbackSelectEmoji", false) then
					this._callbackSelectEmoji(com);
				end;
			end,
			GetItemSerDatasByDataIndex = function(this, sourcedatas, dataIndex)
				local resulutDatas; resulutDatas = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.sd_chatemoji, "System.Collections.Generic.List_EightGame.Data.Server.sd_chatemoji", "ctor", {});
				if ((sourcedatas == nil) or (sourcedatas.Count == 0)) then
					return resulutDatas;
				end;
				if (sourcedatas.Count < ( invokeintegeroperator(4, "*", ( invokeintegeroperator(2, "+", dataIndex, 1, System.Int32, System.Int32) ), ChatEmojiLineControoler._eachLineItemCount, System.Int32, System.Int32) )) then
					if (( invokeintegeroperator(3, "-", sourcedatas.Count, invokeintegeroperator(4, "*", dataIndex, ChatEmojiLineControoler._eachLineItemCount, System.Int32, System.Int32), System.Int32, System.Int32) ) > 0) then
						resulutDatas = sourcedatas:GetRange(invokeintegeroperator(4, "*", dataIndex, ChatEmojiLineControoler._eachLineItemCount, System.Int32, System.Int32), invokeintegeroperator(3, "-", sourcedatas.Count, invokeintegeroperator(4, "*", dataIndex, ChatEmojiLineControoler._eachLineItemCount, System.Int32, System.Int32), System.Int32, System.Int32));
					end;
				else
					resulutDatas = sourcedatas:GetRange(invokeintegeroperator(4, "*", dataIndex, ChatEmojiLineControoler._eachLineItemCount, System.Int32, System.Int32), ChatEmojiLineControoler._eachLineItemCount);
				end;
				return resulutDatas;
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
				_itemLinePrefabPath = "ChatUI/ChatEmojiLineController",
				_itemLinePrefab = __cs2lua_nil_field_value,
				_applicationItemDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatEmojiLineControoler, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatEmojiLineControoler", "ctor", {}),
				_curBtnEnum = 0,
				chatemojis = __cs2lua_nil_field_value,
				_callbackSelectEmoji = delegationwrap(),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatEmojiPanelControoler", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatEmojiPanelControoler.__define_class();
