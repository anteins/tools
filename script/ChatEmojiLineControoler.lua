require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "GameUtility";
require "ChatEmojiItemCom";
require "NGUITools";

ChatEmojiLineControoler = {
	__new_object = function(...)
		return newobject(ChatEmojiLineControoler, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatEmojiLineControoler;

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
			SetData = function(this, cEnum, datalist, callbackClickEmoji)
				this._dataList = datalist;
				delegationset(false, false, "ChatEmojiLineControoler:_callbackClickEmoji", this, nil, "_callbackClickEmoji", callbackClickEmoji);
				this:InitModels();
				this:InitDatas();
			end,
			InitModels = function(this)
				if (this._itemModelList.Count > 0) then
					return ;
				end;
				local index; index = 0;
				while (index < ChatEmojiLineControoler._eachLineItemCount) do
					local go; go = GameUtility.InstantiateGameObject(this._itemModelPrefab, this._grid.gameObject, System.String.Format("{0}{1}", "item", index), nil, nil, nil);
					go.gameObject:SetActive(false);
					local com; com = go:GetComponent(ChatEmojiItemCom);
					this._itemModelList:Add(com);
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
			end,
			InitDatas = function(this)
				local index; index = 0;
				while (index < this._itemModelList.Count) do
					if (index < this._dataList.Count) then
						local itemserdata; itemserdata = typeas(getexterninstanceindexer(this._dataList, nil, "get_Item", index), EightGame.Data.Server.sd_chatemoji, false);
						if (itemserdata == nil) then
							getexterninstanceindexer(this._itemModelList, nil, "get_Item", index).gameObject:SetActive(false);
							return ;
						end;
						getexterninstanceindexer(this._itemModelList, nil, "get_Item", index).gameObject:SetActive(true);
						NGUITools.AddWidgetCollider__UnityEngine_GameObject(getexterninstanceindexer(this._itemModelList, nil, "get_Item", index).gameObject);
						getexterninstanceindexer(this._itemModelList, nil, "get_Item", index):SetData(typeas(getexterninstanceindexer(this._dataList, nil, "get_Item", index), EightGame.Data.Server.sd_chatemoji, false), (function() local __compiler_delegation_52 = (function(com) this:CallbackClickEmoji(com); end); setdelegationkey(__compiler_delegation_52, "ChatEmojiLineControoler:CallbackClickEmoji", this, this.CallbackClickEmoji); return __compiler_delegation_52; end)());
					else
						getexterninstanceindexer(this._itemModelList, nil, "get_Item", index).gameObject:SetActive(false);
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				this._grid.repositionNow = true;
			end,
			CallbackClickEmoji = function(this, com)
				if externdelegationcomparewithnil(false, false, "ChatEmojiLineControoler:_callbackClickEmoji", this, nil, "_callbackClickEmoji", false) then
					this._callbackClickEmoji(com);
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_grid = __cs2lua_nil_field_value,
				_dataList = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.sd_chatemoji, "System.Collections.Generic.List_EightGame.Data.Server.sd_chatemoji", "ctor", {}),
				_itemModelPrefab = __cs2lua_nil_field_value,
				_callbackClickEmoji = wrapdelegation{},
				_itemModelList = newexternlist(System.Collections.Generic.List_ChatEmojiItemCom, "System.Collections.Generic.List_ChatEmojiItemCom", "ctor", {}),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatEmojiLineControoler", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatEmojiLineControoler.__define_class();
