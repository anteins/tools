-- **********************************************************************
-- Copyright   2015  EIGHT Team . All rights reserved.
-- File     : LoginDoorCom.cs
-- Author   : qbkira
-- Created  : 2015/3/15  下6:15 
-- Purpose  : 
-- **********************************************************************
require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIEntityBehaviour";
require "Eight__Framework__EIEvent";
require "GameAudioSoundParam";
require "GameAudioName";

LoginDoorCom = {
	__new_object = function(...)
		return newobject(LoginDoorCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = LoginDoorCom;

		local static_methods = {
			cctor = function()
				EIEntityBehaviour.cctor(this);
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
			OnAnimHandler = function(this)
			end,
			OnAnimHandleString = function(this, str)
			end,
			OnAnimHandleInt = function(this, i)
			end,
			OnAnimName = function(this, animName)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this.AnimControl, nil) then
					this.AnimControl:Play(animName);
				end;
				if (animName == "opendoor") then
					this.entity:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "AUDIO_PLAY_SOUND", nil, newobject(GameAudioSoundParam, "ctor", nil, GameAudioName.SoundOpenDoor), 0.00));
				end;
			end,
			Awake = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this.AnimControl, nil) then
					this.AnimControl = this.gameObject:GetComponent(typeof(UnityEngine.Animator));
				end;
			end,
			Reset = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this.AnimControl, nil) then
					this.AnimControl:Play("none");
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				AnimControl = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = {
			"IAnimationEventHandler",
		};

		local interface_map = {
			IAnimationEventHandler_OnAnimHandler = "OnAnimHandler",
			IAnimationEventHandler_OnAnimHandleString = "OnAnimHandleString",
			IAnimationEventHandler_OnAnimHandleInt = "OnAnimHandleInt",
			IAnimationEventHandler_OnAnimName = "OnAnimName",
		};


		return defineclass(EIEntityBehaviour, "LoginDoorCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



LoginDoorCom.__define_class();
