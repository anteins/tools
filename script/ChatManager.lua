----------------------------------------------
--            NGUI: HUD Text
-- Copyright � 2012 Tasharen Entertainment
----------------------------------------------
require "cs2lua__utility";
require "cs2lua__attributes";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

ChatManager = {
	__new_object = function(...)
		return newobject(ChatManager, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatManager;

		local static_methods = {
			cctor = function()
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				instance = __cs2lua_nil_field_value,
				__attributes = ChatManager__Attrs,
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			Awake = function(this)
				ChatManager.instance = this;
			end,
			OnDestroy = function(this)
				ChatManager.instance = nil;
			end,
			AddParticipant = function(this, participant)
				this.mParticipants:Add(participant);
			end,
			Update = function(this)
				if ((not this.mDisplay) and (this.chatMessages ~= nil)) then
					this:StartCoroutine(this:ProgressChat());
				end;
			end,
			ProgressChat = function(this)
				this.mDisplay = true;
-- Get the Combat text for the current chatter.
				local ct; ct = getexterninstanceindexer(this.mParticipants, nil, "get_Item", this.mCurrentChatter).hudText;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", ct, nil) then
					ct:Add(invokeforbasicvalue(this.chatMessages[this.mCurrentMessage + 1], false, System.String, "Replace", "\\n", "\n"), UnityEngine.Color.white, 2.00, "");
					this.cameraLookAt.target = getexterninstanceindexer(this.mParticipants, nil, "get_Item", this.mCurrentChatter).lookAt;
				end;
				wrapyield(newexternobject(UnityEngine.WaitForSeconds, "UnityEngine.WaitForSeconds", "ctor", nil, 4.00), false, true);
				this.mCurrentChatter = invokeintegeroperator(2, "+", this.mCurrentChatter, 1, System.Int32, System.Int32);
				this.mCurrentMessage = invokeintegeroperator(2, "+", this.mCurrentMessage, 1, System.Int32, System.Int32);
				if (this.mCurrentChatter >= this.mParticipants.Count) then
					this.mCurrentChatter = 0;
				end;
-- Rand out of message start again
				if (this.mCurrentMessage >= this.chatMessages.Length) then
					this.mCurrentMessage = 0;
					wrapyield(newexternobject(UnityEngine.WaitForSeconds, "UnityEngine.WaitForSeconds", "ctor", nil, 5.00), false, true);
				end;
				this.mDisplay = false;
			end),
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				chatMessages = __cs2lua_nil_field_value,
				cameraLookAt = __cs2lua_nil_field_value,
				mParticipants = newexternlist(System.Collections.Generic.List_ChatParticipant, "System.Collections.Generic.List_ChatParticipant", "ctor", {}),
				mCurrentChatter = 0,
				mCurrentMessage = 0,
				mDisplay = false,
				__attributes = ChatManager__Attrs,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ChatManager", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatManager.__define_class();
