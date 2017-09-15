require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "Eight__Framework__EINode";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__ServiceCenter";
require "EightGame__Component__ChatSerice";
require "ChatMsgManager";

ChatOverallController = {
	__new_object = function(...)
		return newobject(ChatOverallController, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ChatOverallController;

		local static_methods = {
			cctor = function()
				Eight.Framework.EINode.cctor(this);
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
			ctor = function(this)
				this.base.ctor__System_String(this, "ChatOverallController");
				return this;
			end,
			Execute = function(this)
				this._isReady = false;
--开启全局的聊天信息相关监听
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ChatSerice);
				delegationset(false, false, "EightGame.Component.ChatSerice:ReceiveMessage", srv, nil, "ReceiveMessage", (function() local __compiler_delegation_18 = (function(notify) this:ReceiveMessage(notify); end); setdelegationkey(__compiler_delegation_18, "ChatOverallController:ReceiveMessage", this, this.ReceiveMessage); return __compiler_delegation_18; end)());
				delegationset(false, false, "EightGame.Component.ChatSerice:ReceiveSysMessage", srv, nil, "ReceiveSysMessage", (function() local __compiler_delegation_19 = (function(notify) this:ReceiveSysMessage(notify); end); setdelegationkey(__compiler_delegation_19, "ChatOverallController:ReceiveSysMessage", this, this.ReceiveSysMessage); return __compiler_delegation_19; end)());
				delegationset(false, false, "EightGame.Component.ChatSerice:ReceiveKeyWordMessage", srv, nil, "ReceiveKeyWordMessage", (function() local __compiler_delegation_20 = (function(notify) this:ReceiveKeyWordMessage(notify); end); setdelegationkey(__compiler_delegation_20, "ChatOverallController:ReceiveKeyWordMessage", this, this.ReceiveKeyWordMessage); return __compiler_delegation_20; end)());
				this._isReady = true;
				return this.base:Execute();
			end,
			ReceiveMessage = function(this, notify)
				ChatMsgManager.Instance:ReceiveMessage(notify);
			end,
			ReceiveSysMessage = function(this, notify)
				ChatMsgManager.Instance:ReceiveSysMessage(notify);
			end,
			ReceiveKeyWordMessage = function(this, notify)
				ChatMsgManager.Instance:ReceiveKeyWordMessage(notify);
			end,
			Dispose = function(this)
				ChatMsgManager.Instance:ClearAllData();
				return this.base:Dispose();
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = {
			"System.Collections.IEnumerable",
		};

		local interface_map = {
			IEnumerable_GetEnumerator = "EINode_GetEnumerator",
		};


		return defineclass(Eight.Framework.EINode, "ChatOverallController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatOverallController.__define_class();
