----------------------------------------------
--            NGUI: HUD Text
-- Copyright � 2012 Tasharen Entertainment
----------------------------------------------
require "cs2lua__utility";
require "cs2lua__attributes";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "HUDRoot";
require "NGUITools";
require "HUDText";
require "UIFollowTarget";
require "ChatManager";

ChatParticipant = {
	__new_object = function(...)
		return newobject(ChatParticipant, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatParticipant;

		local static_methods = {
			cctor = function()
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				__attributes = ChatParticipant__Attrs,
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			get_hudText = function(this)
				return this.mText;
			end,
			Start = function(this)
-- We need the HUD object to know where in the hierarchy to put the element
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", HUDRoot.go, nil) then
					UnityEngine.Object.Destroy(this);
					return ;
				end;
				local child; child = NGUITools.AddChild__UnityEngine_GameObject__UnityEngine_GameObject(NGUITools, HUDRoot.go, this.prefab);
				this.mText = child:GetComponentInChildren(HUDText);
				child:AddComponent(UIFollowTarget).target = this.transform;
-- Add this character as part of conversation.
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", ChatManager.instance, nil) then
					ChatManager.instance:AddParticipant(this);
				end;
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				prefab = __cs2lua_nil_field_value,
				lookAt = __cs2lua_nil_field_value,
				mText = __cs2lua_nil_field_value,
				__attributes = ChatParticipant__Attrs,
			};
			return instance_fields;
		end;

		local instance_props = {
			hudText = {
				get = instance_methods.get_hudText,
			},
		};

		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ChatParticipant", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatParticipant.__define_class();
