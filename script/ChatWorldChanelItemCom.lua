require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

ChatWorldChanelItemCom = {
	__new_object = function(...)
		return newobject(ChatWorldChanelItemCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatWorldChanelItemCom;

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
			SetData = function(this, chatsysmsg, callbackSelect, iscurchannel)
				this._chatsysmsg = chatsysmsg;
				delegationset(false, false, "ChatWorldChanelItemCom:_callbackSelect", this, nil, "_callbackSelect", callbackSelect);
				this:SetLbl(chatsysmsg.chat_statue, invokeforbasicvalue(chatsysmsg.word_room_id, false, System.Int32, "ToString"), iscurchannel);
				this:SetPointColor(chatsysmsg.chat_statue);
			end,
			SetLbl = function(this, state, str, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._lbl, nil) then
					return ;
				end;
				local cur; cur = condexp(b, true, "(当前)", true, "");
				this._lbl.text = System.String.Format("CH.{0}{1}", str, cur);
				local c; c = newexternobject(UnityEngine.Color, "UnityEngine.Color", "ctor", nil);
				if (state == 100) then
					c = UnityEngine.Color.red;
				elseif ((0 <= state) and (state <= 60)) then
					c = UnityEngine.Color.white;
				elseif ((state > 60) and (state < 100)) then
					c = UnityEngine.Color.yellow;
				end;
				this._lbl.color = c;
			end,
			SetPointColor = function(this, state)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._pointSprite, nil) then
					return ;
				end;
				local c; c = newexternobject(UnityEngine.Color, "UnityEngine.Color", "ctor", nil);
				if (state == 100) then
					c = UnityEngine.Color.red;
				elseif ((0 <= state) and (state <= 60)) then
					c = UnityEngine.Color.white;
				elseif ((state > 60) and (state < 100)) then
					c = UnityEngine.Color.yellow;
				end;
				this._pointSprite.color = c;
			end,
			OnClick = function(this)
				if externdelegationcomparewithnil(false, false, "ChatWorldChanelItemCom:_callbackSelect", this, nil, "_callbackSelect", false) then
					this._callbackSelect(this._chatsysmsg);
				end;
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_lbl = __cs2lua_nil_field_value,
				_pointSprite = __cs2lua_nil_field_value,
				_callbackSelect = delegationwrap(),
				_chatsysmsg = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ChatWorldChanelItemCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatWorldChanelItemCom.__define_class();
