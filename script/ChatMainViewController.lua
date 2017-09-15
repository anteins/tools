require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";

ChatMainViewController = {
	__new_object = function(...)
		return newobject(ChatMainViewController, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatMainViewController;

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
			InitChat = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._com, nil) then
					return ;
				end;
				this._com.gameObject:SetActive(true);
				this._com:Init((function() local __compiler_delegation_17 = (function() this:CallbackClickChatBtn(); end); setdelegationkey(__compiler_delegation_17, "ChatMainViewController:CallbackClickChatBtn", this, this.CallbackClickChatBtn); return __compiler_delegation_17; end)());
			end,
			CloseChat = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._com, nil) then
					return ;
				end;
				this._com.gameObject:SetActive(false);
				this._com:UnRegisterEvent();
			end,
			CallbackClickChatBtn = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._com, nil) then
					return ;
				end;
				if this.chatViewState then
					this.chatViewState = false;
					this._com:CloseChat();
				else
					this.chatViewState = true;
					this._com:OpenChatView();
				end;
			end,
			ForceSetChatViewState = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._com, nil) then
					return ;
				end;
				this.chatViewState = b;
				if this.chatViewState then
					this._com:OpenChatView();
				else
					this._com:CloseChat();
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_com = __cs2lua_nil_field_value,
				chatViewState = false,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatMainViewController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatMainViewController.__define_class();
