-- **********************************************************************
-- Copyright   2015  EIGHT Team . All rights reserved.
-- File     :  LoginAnimControlCom.cs
-- Author   : qbkira
-- Created  : 2015/1/24  下12:08 
-- Purpose  : 
-- **********************************************************************
require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIEntityBehaviour";

LoginAnimControlCom = {
	__new_object = function(...)
		return newobject(LoginAnimControlCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = LoginAnimControlCom;

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
				if externdelegationcomparewithnil(false, false, "LoginAnimControlCom:_finishCallback", this, nil, "_finishCallback", false) then
					this._finishCallback.Invoke();
				end;
			end,
			OnAnimHandleString = function(this, str)
			end,
			OnAnimHandleInt = function(this, i)
			end,
			OnAnimName = function(this, animName)
--		if (animName == "opendoor")
--		{
--			entity.DispatchEvent(new EIEvent(AudioMessageType.AUDIO_PLAY_SOUND, null , new GameAudioSoundParam(GameAudioName.SoundOpenDoor))); // tmp
--		}
			end,
			SetFinishCallback = function(this, finishCallback)
				delegationset(false, false, "LoginAnimControlCom:_finishCallback", this, nil, "_finishCallback", finishCallback);
			end,
			PlayStart = function(this)
				this.Door:Reset();
				this.LoginStartAnimator:Play(this.AnimNameStart);
			end,
			PlayEnter = function(this)
				this.LoginConnectAnimator:Play(this.AnimNameConnect);
			end,
			PlayOpen = function(this)
				this.LoginLeaveAnimator:Play(this.AnimNameLeave);
			end,
			Init = function(this, entity)
				this:Setup(entity);
				this.Door:Setup(entity);
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				LoginStartAnimator = __cs2lua_nil_field_value,
				AnimNameStart = __cs2lua_nil_field_value,
				LoginConnectAnimator = __cs2lua_nil_field_value,
				AnimNameConnect = __cs2lua_nil_field_value,
				LoginLeaveAnimator = __cs2lua_nil_field_value,
				AnimNameLeave = __cs2lua_nil_field_value,
				_finishCallback = delegationwrap(),
				Door = __cs2lua_nil_field_value,
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


		return defineclass(EIEntityBehaviour, "LoginAnimControlCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



LoginAnimControlCom.__define_class();
