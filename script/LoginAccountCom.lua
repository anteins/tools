-- **********************************************************************
-- Copyright   2015  EIGHT Team . All rights reserved.
-- File     :  LoginAccountCom.cs
-- Author   : qbkira
-- Created  : 2015/1/21  下2:13 
-- Purpose  : 
-- **********************************************************************
require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIBehaviour";
require "EightGame__Logic__LoginUserParam";
require "Eight__Framework__EIFrameWork";
require "Eight__Framework__EIEvent";
require "EightGame__Logic__TipStruct";

LoginAccountCom = {
	__new_object = function(...)
		return newobject(LoginAccountCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = LoginAccountCom;

		local static_methods = {
			cctor = function()
				EIBehaviour.cctor(this);
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
			set_SetCurrentObj = function(this, value)
				this.GameCurryContainer = value;
			end,
			get_IsLoginAgain = function(this)
				return this._isAgain;
			end,
			SetFieldActive = function(this, on)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Implicit", this.GameObjectFieldContainer) then
					this.GameObjectFieldContainer:SetActive(on);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this.GameCurryContainer, nil) then
					this.GameCurryContainer:SetActive(on);
				end;
			end,
			SetLatestAccount = function(this, latestAccount)
				if System.String.IsNullOrEmpty(latestAccount) then
					latestAccount = "";
					this._isAgain = false;
				else
					this._isAgain = true;
				end;
--EIDebuger.Log (latestAccount);
				this.LabelAccount.value = latestAccount;
				this.CurryAccout.text = latestAccount;
				this.LabelAccount:UpdateLabel();
			end,
			LoginAccount = function(this)
				if (getforbasicvalue(this.LabelAccount.value, false, System.String, "Length") == 0) then
					this:ShowFloatTip("请输入账号！");
					return ;
				end;
				local userInfo; userInfo = newobject(EightGame.Logic.LoginUserParam, "ctor", nil, "eichannel_empty", "eichannel_empty", this.LabelAccount.value, "null");
--内置保留的无渠道号.
--内置保留的无渠道号.
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "LOGIN_SDK_ACCOUNT_SUCCESS", nil, userInfo, 0.00));
			end,
			LoginOut = function(this)
				this.LabelPassword.value = "";
				this.LabelPassword:UpdateLabel();
			end,
			GetAccountObj = function(this)
				return this.AccountObj;
			end,
			ShowFloatTip = function(this, msg)
				local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, msg, 0.20);
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				GameObjectFieldContainer = __cs2lua_nil_field_value,
				AccountObj = __cs2lua_nil_field_value,
				SDKAccountObj = __cs2lua_nil_field_value,
				SDKAccountObj_ysdk = __cs2lua_nil_field_value,
				GameCurryContainer = __cs2lua_nil_field_value,
				LabelAccount = __cs2lua_nil_field_value,
				LabelPassword = __cs2lua_nil_field_value,
				CurryAccout = __cs2lua_nil_field_value,
				_isAgain = false,
			};
			return instance_fields;
		end;

		local instance_props = {
			SetCurrentObj = {
				set = instance_methods.set_SetCurrentObj,
			},
			IsLoginAgain = {
				get = instance_methods.get_IsLoginAgain,
			},
		};

		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIBehaviour, "LoginAccountCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



LoginAccountCom.__define_class();
