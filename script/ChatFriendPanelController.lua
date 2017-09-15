require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ChatFriendItemCom";
require "FriendsMainUIBehaviour";
require "LogicStatic";
require "EightGame__Component__ServiceCenter";
require "EightGame__Component__ChatSerice";
require "EightGame__Logic__FloatingTextTipUIRoot";

ChatFriendPanelController = {
	__new_object = function(...)
		return newobject(ChatFriendPanelController, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatFriendPanelController;

		local static_methods = {
			cctor = function()
				EIUIBehaviour.cctor(this);
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
			SetData = function(this, callbackSelcetFriend, callbackClose)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._uiRecycledList, nil) then
					delegationset(false, false, "UIRecycledList:onUpdateItem", this._uiRecycledList, nil, "onUpdateItem", (function() local __compiler_delegation_31 = (function(go, prefabIndex, dataindex) this:OnUpdateItem(go, prefabIndex, dataindex); end); setdelegationkey(__compiler_delegation_31, "ChatFriendPanelController:OnUpdateItem", this, this.OnUpdateItem); return __compiler_delegation_31; end)());
				end;
				delegationset(false, false, "ChatFriendPanelController:_callbackClose", this, nil, "_callbackClose", callbackClose);
				delegationset(false, false, "ChatFriendPanelController:_callbackSelectFriend", this, nil, "_callbackSelectFriend", callbackSelcetFriend);
				Eight.Framework.EIFrameWork.StartCoroutine(this:LoadItemPrefab(), false);
			end,
			LoadItemPrefab = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._itemPrefab, nil) then
					local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(System.String.Format("{0}{1}", "GameAssets/Prefabs/UI/", this._itemPrefabPath), "prefab", false);
					wrapyield(coroutine.coroutine, false, true);
					this._itemPrefab = typeas(coroutine.res, UnityEngine.GameObject, false);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._itemPrefab, nil) then
					if (this._applicationItemDic.Count == 0) then
						local index; index = 0;
						while (index < 7) do
							local go; go = GameUtility.InstantiateGameObject(this._itemPrefab, this._uiRecycledList.gameObject, ("Friend" + index), nil, nil, nil);
							local r; r = go:GetComponent(ChatFriendItemCom);
							this._applicationItemDic:Add(go, r);
							go.gameObject:SetActive(false);
						index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
						end;
					end;
				end;
				this:RequestFriendSerData((function(obj)
					if ((obj == nil) or (obj.Count == 0)) then
						this:SetTipActive(true);
						this._allDatas:Clear();
						this._uiRecycledList:UpdateDataCount(0, false);
					else
						this:SetTipActive(false);
						this._allDatas = obj;
						this._uiRecycledList:UpdateDataCount(this._allDatas.Count, false);
					end;
				end));
			end),
			RequestFriendSerData = function(this, callback)
--先去请求一次最新的好友数据
				FriendsMainUIBehaviour.FreshFriendsData((function()
					local friendSerDatas; friendSerDatas = LogicStatic.GetList(typeof(EightGame.Data.Server.FriendSerData), nil);
					if ((friendSerDatas == nil) or (friendSerDatas.Count == 0)) then
						if externdelegationcomparewithnil(false, false, "ChatFriendPanelController:callback", callback, nil, nil, false) then
							callback(nil);
						end;
						return ;
					end;
					local friendids; friendids = newexternlist(System.Collections.Generic.List_System.Int64, "System.Collections.Generic.List_System.Int64", "ctor", {});
					friendSerDatas:ForEach((function(F) return friendids:Add(F.fid); end));
					local msg; msg = newexternobject(EightGame.Data.Server.OnLineFriendIdsMsg, "EightGame.Data.Server.OnLineFriendIdsMsg", "ctor", nil);
					friendids:ForEach((function(F) return msg.friendids:Add(F); end));
					local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ChatSerice);
					srv:GetOnlineFriendIds(msg, (function(arg1, arg2)
						if (typecast(arg1, System.Int32, false) ~= 200) then
							EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(EightGame.Component.NetCode.GetDesc(typecast(arg1, System.Int32, false)), 0.00);
							if externdelegationcomparewithnil(false, false, "ChatFriendPanelController:callback", callback, nil, nil, false) then
								callback(nil);
							end;
							return ;
						end;
						local newList; newList = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.FriendSerData, "System.Collections.Generic.List_EightGame.Data.Server.FriendSerData", "ctor", {});
						friendSerDatas = LogicStatic.GetList(typeof(EightGame.Data.Server.FriendSerData), nil);
						local index; index = 0;
						while (index < friendSerDatas.Count) do
							if arg2.friendids:Contains(getexterninstanceindexer(friendSerDatas, nil, "get_Item", index).fid) then
								newList:Add(getexterninstanceindexer(friendSerDatas, nil, "get_Item", index));
							end;
						index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
						end;
						if externdelegationcomparewithnil(false, false, "ChatFriendPanelController:callback", callback, nil, nil, false) then
							callback(newList);
						end;
					end), nil);
				end));
			end,
			OnUpdateItem = function(this, go, prefabIndex, dataindex)
				if ((this._allDatas == nil) or (this._allDatas.Count == 0)) then
					return ;
				end;
				local com; com = nil;
				if (function() local __compiler_invoke_128; __compiler_invoke_128, com = this._applicationItemDic:TryGetValue(go); return __compiler_invoke_128; end)() then
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", com, nil) then
						return ;
					end;
					if ((this._allDatas.Count > 0) and (dataindex < this._allDatas.Count)) then
--更新界面
						com:SetData(getexterninstanceindexer(this._allDatas, nil, "get_Item", dataindex), (function() local __compiler_delegation_134 = (function(friendSerData) this:CallbackSelectFriend(friendSerData); end); setdelegationkey(__compiler_delegation_134, "ChatFriendPanelController:CallbackSelectFriend", this, this.CallbackSelectFriend); return __compiler_delegation_134; end)());
--com.SetData( _curBtnEnum, GetItemSerDatasByDataIndex(_sourceDatas ,dataIndex) ,OnSelectionChange  );
					end;
				end;
			end,
			CallbackSelectFriend = function(this, friendSerData)
				if externdelegationcomparewithnil(false, false, "ChatFriendPanelController:_callbackSelectFriend", this, nil, "_callbackSelectFriend", false) then
					this._callbackSelectFriend(friendSerData);
				end;
			end,
			OnClickClose = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this, nil) then
					this.gameObject:SetActive(false);
				end;
				if externdelegationcomparewithnil(false, false, "ChatFriendPanelController:_callbackClose", this, nil, "_callbackClose", false) then
					this._callbackClose();
				end;
			end,
			SetTipActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._tipLbl, nil) then
					return ;
				end;
				this._tipLbl.gameObject:SetActive(b);
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_uiRecycledList = __cs2lua_nil_field_value,
				_tipLbl = __cs2lua_nil_field_value,
				_itemPrefabPath = "ChatUI/ChatFriendItem",
				_itemPrefab = __cs2lua_nil_field_value,
				_applicationItemDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatFriendItemCom, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatFriendItemCom", "ctor", {}),
				_allDatas = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.FriendSerData, "System.Collections.Generic.List_EightGame.Data.Server.FriendSerData", "ctor", {}),
				_callbackSelectFriend = delegationwrap(),
				_callbackClose = delegationwrap(),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatFriendPanelController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatFriendPanelController.__define_class();
