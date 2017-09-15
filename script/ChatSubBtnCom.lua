require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";

ChatSubBtnCom = {
	__new_object = function(...)
		return newobject(ChatSubBtnCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatSubBtnCom;

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
			SetData = function(this, chatSubType, callbaclClick)
				this._subtype = chatSubType;
				delegationset(false, false, "ChatSubBtnCom:_callbackClick", this, nil, "_callbackClick", callbaclClick);
				this:SetLbl(this._subtype);
			end,
			SetLbl = function(this, subtype)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._contentLbl, nil) then
					return ;
				end;
				local str; str = System.String.Empty;
				local __compiler_switch_31 = subtype;
				if __compiler_switch_31 == 0 then
				elseif __compiler_switch_31 == 1 then
					str = "添加好友";
				elseif __compiler_switch_31 == 2 then
					str = "私聊";
				end;
				this._contentLbl.text = str;
			end,
			OnClick = function(this)
				if externdelegationcomparewithnil(false, false, "ChatSubBtnCom:_callbackClick", this, nil, "_callbackClick", false) then
					this._callbackClick(this._subtype);
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_subtype = 0,
				_contentLbl = __cs2lua_nil_field_value,
				_callbackClick = delegationwrap(),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatSubBtnCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




ChatSubBtnCom.ChatSubType = {
	["NOTHING"] = 0,
	["ADD_FRIEND"] = 1,
	["PRIVATE_TALK"] = 2,
};

rawset(ChatSubBtnCom.ChatSubType, "Value2String", {
		[0] = "NOTHING",
		[1] = "ADD_FRIEND",
		[2] = "PRIVATE_TALK",
});
ChatSubBtnCom.__define_class();
