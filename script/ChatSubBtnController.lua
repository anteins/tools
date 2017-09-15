require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "LogicStatic";
require "GameUtility";
require "ChatSubBtnCom";
require "ChatSubCallBackParam";

ChatSubBtnController = {
	__new_object = function(...)
		return newobject(ChatSubBtnController, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatSubBtnController;

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
			Awake = function(this)
				this.gameObject:SetActive(false);
			end,
			SetData = function(this, com, callback)
				this._moveGroup.transform.parent = com.transform;
				this._moveGroup.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -150.00, 10.00, 0);
				this:SetMoveGroupActive(true);
				this._chatMsg = com._chatmsg;
				delegationset(false, false, "ChatSubBtnController:_callbackSelect", this, nil, "_callbackSelect", callback);
				Eight.Framework.EIFrameWork.StartCoroutine(this:LoadItemPrefab(), false);
--_friendId = friendId;
--EIFrameWork.Instance.AddEventListener(  );
			end,
			LoadItemPrefab = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._itemPrefab, nil) then
					local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(System.String.Format("{0}{1}", "GameAssets/Prefabs/UI/", this._itemPrefabPath), "prefab", false);
					wrapyield(coroutine.coroutine, false, true);
					this._itemPrefab = typeas(coroutine.res, UnityEngine.GameObject, false);
					this:InitItems();
				else
					this:InitItems();
				end;
			end),
			InitItems = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._itemPrefab, nil) then
					return ;
				end;
				local serdata; serdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.FriendSerData), (function(F) return (F.fid == this._chatMsg.playerid); end));
				local chatSubTypes; chatSubTypes = newexternlist(System.Collections.Generic.List_ChatSubBtnCom.ChatSubType, "System.Collections.Generic.List_ChatSubBtnCom.ChatSubType", "ctor", {});
				if (serdata == nil) then
					chatSubTypes:Add(1);
				else
					chatSubTypes:Add(2);
				end;
				if (this._cachBtnComs.Count > chatSubTypes.Count) then
					local index; index = 0;
					while (index < this._cachBtnComs.Count) do
						if (index < chatSubTypes.Count) then
							getexterninstanceindexer(this._cachBtnComs, nil, "get_Item", index).gameObject:SetActive(true);
							getexterninstanceindexer(this._cachBtnComs, nil, "get_Item", index):SetData(getexterninstanceindexer(chatSubTypes, nil, "get_Item", index), (function() local __compiler_delegation_77 = (function(chatSubType) this:CallbackClickSubBtn(chatSubType); end); setdelegationkey(__compiler_delegation_77, "ChatSubBtnController:CallbackClickSubBtn", this, this.CallbackClickSubBtn); return __compiler_delegation_77; end)());
						else
							getexterninstanceindexer(this._cachBtnComs, nil, "get_Item", index).gameObject:SetActive(false);
						end;
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				else
					local index; index = 0;
					while (index < chatSubTypes.Count) do
					repeat
						if (index < this._cachBtnComs.Count) then
							getexterninstanceindexer(this._cachBtnComs, nil, "get_Item", index).gameObject:SetActive(true);
							getexterninstanceindexer(this._cachBtnComs, nil, "get_Item", index):SetData(getexterninstanceindexer(chatSubTypes, nil, "get_Item", index), (function() local __compiler_delegation_93 = (function(chatSubType) this:CallbackClickSubBtn(chatSubType); end); setdelegationkey(__compiler_delegation_93, "ChatSubBtnController:CallbackClickSubBtn", this, this.CallbackClickSubBtn); return __compiler_delegation_93; end)());
						else
							local go; go = GameUtility.InstantiateGameObject(this._itemPrefab, this._table.gameObject, "subBtn", nil, nil, nil);
							local com; com = go:GetComponent(ChatSubBtnCom);
							if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", com, nil) then
								break;
							end;
							com:SetData(getexterninstanceindexer(chatSubTypes, nil, "get_Item", index), (function() local __compiler_delegation_100 = (function(chatSubType) this:CallbackClickSubBtn(chatSubType); end); setdelegationkey(__compiler_delegation_100, "ChatSubBtnController:CallbackClickSubBtn", this, this.CallbackClickSubBtn); return __compiler_delegation_100; end)());
							this._cachBtnComs:Add(com);
						end;
					until true;
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._table, nil) then
					this._table.repositionNow = true;
				end;
			end,
			CallbackClickSubBtn = function(this, chatSubType)
				local param; param = newobject(ChatSubCallBackParam, "ctor", nil);
				param.chatsubtype = chatSubType;
				param._friendId = this._chatMsg.playerid;
				param.friendName = this._chatMsg.playername;
				this:SetMoveGroupActive(false);
				if externdelegationcomparewithnil(false, false, "ChatSubBtnController:_callbackSelect", this, nil, "_callbackSelect", false) then
					this._callbackSelect(param);
				end;
			end,
			ClickClose = function(this)
				this:SetMoveGroupActive(false);
			end,
			SetMoveGroupActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._moveGroup, nil) then
					return ;
				end;
				this._moveGroup.gameObject:SetActive(b);
				this.gameObject:SetActive(b);
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_table = __cs2lua_nil_field_value,
				_moveGroup = __cs2lua_nil_field_value,
				_itemPrefabPath = "ChatUI/ChatSubBtn",
				_itemPrefab = __cs2lua_nil_field_value,
				_cachBtnComs = newexternlist(System.Collections.Generic.List_ChatSubBtnCom, "System.Collections.Generic.List_ChatSubBtnCom", "ctor", {}),
				_chatMsg = __cs2lua_nil_field_value,
				_callbackSelect = delegationwrap(),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatSubBtnController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatSubBtnController.__define_class();
