require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "UISprite";

ChatShowItemBtnCom = {
	__new_object = function(...)
		return newobject(ChatShowItemBtnCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatShowItemBtnCom;

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
			SetData = function(this, cEnum, callbackClick)
				this._enum = cEnum;
				delegationset(false, false, "ChatShowItemBtnCom:_callbackClick", this, nil, "_callbackClick", callbackClick);
				this:SetLbl();
			end,
			OnClick = function(this)
				if externdelegationcomparewithnil(false, false, "ChatShowItemBtnCom:_callbackClick", this, nil, "_callbackClick", false) then
					this._callbackClick(this);
				end;
			end,
			SetLbl = function(this)
				local str; str = "";
				local __compiler_switch_38 = this._enum;
				if __compiler_switch_38 == 0 then
					str = "物品";
				elseif __compiler_switch_38 == 1 then
					str = "装备";
				elseif __compiler_switch_38 == 2 then
					str = "伙伴";
				elseif __compiler_switch_38 == 3 then
					str = "表情";
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._btnLbl, nil) then
					return ;
				end;
				this._btnLbl.text = str;
			end,
			SetBtnSprite = function(this, b)
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._btn, nil) or invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._btnLbl, nil)) then
					return ;
				end;
				this._btnLbl.color = condexp(b, false, (function() return newexternobject(UnityEngine.Color, "UnityEngine.Color", "ctor", nil, 0.37, 0.26, 0.12); end), false, (function() return UnityEngine.Color.white; end));
				this._btnLbl.effectStyle = condexp(b, true, 0, true, 2);
				local _bgsprite; _bgsprite = this._btn:GetComponentInChildren(UISprite);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", _bgsprite, nil) then
					return ;
				end;
				_bgsprite:SetDimensions(condexp(b, true, 46, true, 42), _bgsprite.height);
				_bgsprite.spriteName = condexp(b, true, "1234", true, "124");
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_btnLbl = __cs2lua_nil_field_value,
				_btn = __cs2lua_nil_field_value,
				_enum = 0,
				_callbackClick = delegationwrap(),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatShowItemBtnCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




ChatShowItemBtnCom.ChatShowItemEnum = {
	["Show_Goods"] = 0,
	["Show_Equipment"] = 1,
	["Show_Role"] = 2,
	["Show_Emoji"] = 3,
};

rawset(ChatShowItemBtnCom.ChatShowItemEnum, "Value2String", {
		[0] = "Show_Goods",
		[1] = "Show_Equipment",
		[2] = "Show_Role",
		[3] = "Show_Emoji",
});
ChatShowItemBtnCom.__define_class();
