require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIEntityBehaviour";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "LoginLogoCom";
require "UITweener";
require "TweenAlpha";
require "Eight__Framework__EIStringEvent";
require "EightGame__Logic__LoginUserParam";
require "Eight__Framework__EIEvent";
require "ClickGameAudioSoundParam";
require "EightGame__Logic__CommonTipsParam";
require "VersionUtility";
require "EightGame__Logic__LoginHelp";
require "Eight__Framework__EIBoolEvent";
require "EightGame__Logic__TipStruct";
require "ServerButtonCom";

LoginCom = {
	__new_object = function(...)
		return newobject(LoginCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = LoginCom;

		local static_methods = {
			cctor = function()
				EIEntityBehaviour.cctor(this);
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				_logonPath = "eff_logo_002",
				IS_ENABLE_SDK = false,
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			set_IsServerNull = function(this, value)
				this._isServerNull = value;
			end,
			Init = function(this)
--在编辑器状态下，没必要开放SDK.
				if UnityEngine.Application.isEditor then
					LoginCom.IS_ENABLE_SDK = false;
				end;
--调用SDK的初始化接口.
				this:OnSDKInitSlot();
				this:LogoFinsh();
			end,
			InitMessage = function(this)
--Modiy by breen
--		EIFrameWork.Instance.AddEventListener (LoginMessageType.LOGIN_ACCOUNT,LoginAccount);
--		EIFrameWork.Instance.AddEventListener (LoginMessageType.LOGIN_REGISTER,RegisterAccount);
--		EIFrameWork.Instance.AddEventListener (LoginMessageType.LOGIN_CHOICE_SERVER,ChoiceServer);
				this.entity:AddEventListener("LOGIN_SDK_ACCOUNT_SUCCESS", (function() local __compiler_delegation_74 = (function(e) this:OnSDKLoginSuccessSlot(e); end); setdelegationkey(__compiler_delegation_74, "LoginCom:OnSDKLoginSuccessSlot", this, this.OnSDKLoginSuccessSlot); return __compiler_delegation_74; end)());
				this.entity:AddEventListener("LOGIN_SDK_ACCOUNT_FAILED", (function() local __compiler_delegation_75 = (function(e) this:OnSDKLoginFailedSlot(e); end); setdelegationkey(__compiler_delegation_75, "LoginCom:OnSDKLoginFailedSlot", this, this.OnSDKLoginFailedSlot); return __compiler_delegation_75; end)());
				this.entity:AddEventListener("LOGOUT_SDK_ACCOUNT", (function() local __compiler_delegation_76 = (function(e) this:OnSDKLogoutSlot(e); end); setdelegationkey(__compiler_delegation_76, "LoginCom:OnSDKLogoutSlot", this, this.OnSDKLogoutSlot); return __compiler_delegation_76; end)());
				this.entity:AddEventListener("LOGIN_ACCOUNT", (function() local __compiler_delegation_77 = (function(e) this:LoginAccount(e); end); setdelegationkey(__compiler_delegation_77, "LoginCom:LoginAccount", this, this.LoginAccount); return __compiler_delegation_77; end)());
				this.entity:AddEventListener("LOGIN_REGISTER", (function() local __compiler_delegation_78 = (function(e) this:RegisterAccount(e); end); setdelegationkey(__compiler_delegation_78, "LoginCom:RegisterAccount", this, this.RegisterAccount); return __compiler_delegation_78; end)());
				this.entity:AddEventListener("LOGIN_CHOICE_SERVER", (function() local __compiler_delegation_79 = (function(e) this:ChoiceServer(e); end); setdelegationkey(__compiler_delegation_79, "LoginCom:ChoiceServer", this, this.ChoiceServer); return __compiler_delegation_79; end)());
			end,
			LogoFinsh = function(this)
				this:InitMessage();
--Account.LoginOut ();
				this.Account.SDKAccountObj:SetActive(false);
				this.Account.AccountObj:SetActive(false);
				this.Account.SDKAccountObj_ysdk:SetActive(false);
				this.Account.CurryAccout.transform.parent.gameObject:SetActive((not LoginCom.IS_ENABLE_SDK));
				this.Server.ServerObj:SetActive(false);
				this.Other:Init();
				this.LogoObj.gameObject:SetActive(false);
				this.Anim:Init(this.entity);
				this.Anim:SetFinishCallback((function() local __compiler_delegation_96 = (function() this:OnLeaveLogin(); end); setdelegationkey(__compiler_delegation_96, "LoginCom:OnLeaveLogin", this, this.OnLeaveLogin); return __compiler_delegation_96; end)());
				this._sceneState = 1;
				this._canStart = false;
				this.Account:SetFieldActive(false);
				this:StartCoroutine(this:LoadLogonEffect("eff_logo_002"));
				this:SetVersion();
			end,
			LoadLogonEffect = function(this, path)
				local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(("BaseAssets/Prefabs/Effects/UI/" + path), "prefab", false);
				wrapyield(coroutine.coroutine, false, true);
				local prefab; prefab = typeas(coroutine.res, UnityEngine.GameObject, false);
				this._canStart = true;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", prefab, nil) then
					return nil;
				end;
				local go; go = GameUtility.InstantiateGameObject(prefab, this._logoParent.gameObject, "logo", nil, nil, nil);
				this._logoEffect = go:GetComponent(typeof(UnityEngine.Animator));
				go:AddComponent(LoginLogoCom):SetAnimaiton01FinishCallBack((function()
--根据是否接入SDK来改变账号输入的UI
					this.Account:GetAccountObj():SetActive(true);
--if (!Application.isEditor) 
					if ((not UnityEngine.Application.isEditor) and (not this.Other.IsDelayOpen)) then
						this.Other:OpenNoticePage();
					end;
					this.Account:SetFieldActive(true);
					if (not this._isServerNull) then
						local tweenAlpha; tweenAlpha = UITweener.Begin(TweenAlpha, this.Account.GameObjectFieldContainer, 0.50);
						tweenAlpha.from = 0;
						tweenAlpha.to = 1.00;
--				EventDelegate.Add( tweenAlpha.onFinished , delegate() {
--					_canStart = true;
--				} );
						tweenAlpha:PlayForward();
					end;
				end));
			end),
			ResetAnim = function(this)
				this.Anim:PlayStart();
--if (Account) Account.SetFieldActive(true);
			end,
			Next = function(this)
				this._sceneState = invokeintegeroperator(2, "+", this._sceneState, 1, LoginCom.SceneState, LoginCom.SceneState);
				local __compiler_switch_164 = this._sceneState;
				if __compiler_switch_164 == 1 then
					this:OnStartLogin();
				elseif __compiler_switch_164 == 2 then
					this:OnEnterLogin();
				elseif __compiler_switch_164 == 3 then
					this:OnOpenLogin();
				elseif __compiler_switch_164 == 4 then
					this:OnLeaveLogin();
				else
				end;
			end,
			Previous = function(this)
				this._sceneState = invokeintegeroperator(3, "-", this._sceneState, 1, LoginCom.SceneState, LoginCom.SceneState);
			end,
			OnSDKInitSlot = function(this)
				if LoginCom.IS_ENABLE_SDK then
				end;
			end,
			OnSDKLoginBtnClickSlot = function(this)
				this:ExecuteLogin("common login");
				Eight.Framework.EIDebuger.Log("OnSDKLoginBtnClickSlot");
			end,
			OnSDKLoginQQBtnClickSlot = function(this)
				this:ExecuteLogin("login_qq");
			end,
			OnSDKLoginWXBtnClickSlot = function(this)
				this:ExecuteLogin("login_wx");
			end,
			ExecuteLogin = function(this, loginCustomParam)
				if LoginCom.IS_ENABLE_SDK then
				end;
			end,
			OnSDKLogoutBtnClickSlot = function(this)
				if LoginCom.IS_ENABLE_SDK then
				else
--如果没有接入SDK，就直接发送“注销成功”的事件.
					this.Account:LoginOut();
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIStringEvent, "ctor__System_String__System_String", nil, "LOGOUT_SDK_ACCOUNT", "logout of none SDK"));
				end;
			end,
			OnSDKLoginSuccessSlot = function(this, e)
				local eParam; eParam = typecast(e.extraInfo, EightGame.Logic.LoginUserParam, false);
--保存账号的登录信息 .
				this.loginUserInfo = newobject(EightGame.Logic.LoginUserParam, "ctor", nil, eParam.channelLabel, eParam.channelCode, eParam.channelUid, eParam.token);
--如果不是接入了渠道SDK的，channelUid就绝对不会为空，使用这个登录就行.
				if LoginCom.IS_ENABLE_SDK then
					this.Account:SetLatestAccount(eParam.channelUid);
				end;
--显示“进入游戏”按钮.
				Eight.Framework.EIDebuger.GameLog("OnSDKLoginFinishedSlot");
				GameUtility.TweenAlphaClose(this.Account:GetAccountObj(), this.Server.ServerObj);
			end,
			OnSDKLoginFailedSlot = function(this, e)
				local customParams; customParams = ( typeas(e, Eight.Framework.EIStringEvent, false) ).stringParam;
--ShowFloatTip("登录失败");
			end,
			OnSDKLogoutSlot = function(this, e)
				Eight.Framework.EIDebuger.GameLog("OnSDKLogoutSlot");
				local customParams; customParams = ( typeas(e, Eight.Framework.EIStringEvent, false) ).stringParam;
				GameUtility.TweenAlphaClose(this.Server.ServerObj, this.Account:GetAccountObj());
			end,
			OnTouchStart = function(this)
				if (not this._canStart) then
					return ;
				end;
				this:OnEnterLogin();
				this.entity:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "AUDIO_PLAY_SOUND", nil, newobject(ClickGameAudioSoundParam, "ctor", nil, 1), 0.00));
			end,
			OnStartLogin = function(this)
--if (Account) Account.SetFieldActive(true);
			end,
			OnEnterLogin = function(this)
--人数限制.
				local server; server = this.Server:GetSelectServer();
				if (server == nil) then
					return ;
				end;
				if (server.BaseState == 3) then
					local param; param = newobject(EightGame.Logic.CommonTipsParam, "ctor", nil, "服务器人数已满，请稍后再登录", 0, nil, nil, "");
					param.isShowOKCancelBtn = false;
					this.entity:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_TIPS", nil, param, 0.00));
					return ;
				end;
-- Login
				if (this.entity ~= nil) then
					this.entity:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "LOGIN_START", nil, nil, 0.00));
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Implicit", this.Account) then
					this.Account:SetFieldActive(false);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._logoEffect, nil) then
					this._logoEffect.gameObject:SetActive(false);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Implicit", this.Anim) then
					this.Anim:PlayEnter();
				end;
			end,
			OnOpenLogin = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Implicit", this.Anim) then
					this.Anim:PlayOpen();
				end;
			end,
			OnLeaveLogin = function(this)
--leave login, enter main scene
				if (this.entity ~= nil) then
					this.entity:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "LOGIN_LEAVE", nil, nil, 0.00));
				end;
			end,
			Dispose = function(this)
				this.Anim:Dispose();
				this.entity:RemoveEventListener("LOGIN_ACCOUNT");
				this.entity:AddEventListener("LOGIN_REGISTER", (function() local __compiler_delegation_365 = (function(e) this:RegisterAccount(e); end); setdelegationkey(__compiler_delegation_365, "LoginCom:RegisterAccount", this, this.RegisterAccount); return __compiler_delegation_365; end)());
				this.entity:AddEventListener("LOGIN_CHOICE_SERVER", (function() local __compiler_delegation_366 = (function(e) this:ChoiceServer(e); end); setdelegationkey(__compiler_delegation_366, "LoginCom:ChoiceServer", this, this.ChoiceServer); return __compiler_delegation_366; end)());
				this.base:Dispose();
			end,
			OnAwake = function(this)
				this.base:OnAwake();
			end,
			PlayerLogoEffect = function(this, effectName)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._logoEffect, nil) then
					return ;
				end;
				Eight.Framework.EIDebuger.GameLog(effectName);
				this._logoEffect:Play(effectName);
			end,
			SetVersion = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._versionLbl, nil) then
					return ;
				end;
				this._versionLbl.text = System.String.Format("版本号: {0}.{1}.{2}", VersionUtility.GetVersion(), VersionUtility.GetSubVersion(), VersionUtility.GetMSubVersion());
			end,
			SetChangeIp = function(this)
				EightGame.Logic.LoginHelp.ChangeIp();
			end,
			ReturnAccountPage = function(this)
				this:OnSDKLogoutBtnClickSlot();
			end,
			OpenAllServerPage = function(this)
				GameUtility.TweenScaleOpen(this.Server.AllServerPage);
				GameUtility.TweenAlphaClose(this.Server.ServerObj, nil);
			end,
			ColseAllServerPage = function(this)
--StartCoroutine (GameUtility.TweenScaleClose(Server.AllServerPage));
				GameUtility.TweenScaleClose(this.Server.AllServerPage);
				GameUtility.TweenAlphaOpen(this.Server.ServerObj);
			end,
			LoginAccount = function(this, e)
--在此处重新加入服务器申请数据
				local eb; eb = ( typecast(e, Eight.Framework.EIBoolEvent, false) ).boolParam;
				if eb then
					GameUtility.TweenAlphaClose(this.Account:GetAccountObj(), this.Server.ServerObj);
				else
					this:ErrorTips("账号或密码错误");
--提示什么的应该也从外部加载
				end;
			end,
			RegisterAccount = function(this, e)
				local rInfo; rInfo = typecast(e.extraInfo, EightGame.Logic.LoginUserParam, false);
				local accountName; accountName = rInfo.channelUid;
--注册前判断 密码是否一致
--发消息服务器验证 
--注册前判断 密码是否一致
--发消息服务器验证 
				local IsRegister; IsRegister = true;
				if IsRegister then
					this.Account:SetLatestAccount(accountName);
					UnityEngine.Debug.Log("注册成功！ ");
				else
					this:ErrorTips("该账号已经存在");
				end;
			end,
			ShowFloatTip = function(this, msg)
				local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, msg, 0.20);
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
			end,
			ErrorTips = function(this, errorStr)
				local tip; tip = newobject(EightGame.Logic.CommonTipsParam, "ctor", nil, errorStr, 0, nil, nil, "");
				tip.isShowOKCancelBtn = false;
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_TIPS", nil, tip, 0.00));
			end,
			ChoiceServer = function(this, e)
				local ei; ei = typecast(e.extraInfo, ServerButtonCom.ServerButtonData, false);
				this.Server.CurrentServer.text = ei.ServerName;
				this.Server.CurrentServerInAll.MyButtonData = ei;
				this.Server.CurrentServerInAll.SVName.text = System.String.Format("[b][u]{0}[/u][/b]", ei.ServerName);
				this:ColseAllServerPage();
--GameUtility.TweenScaleClose (Server.AllServerPage);
--StartCoroutine(GameUtility.TweenAlphaOpen (Server.ServerObj));
			end,
			LoginServer = function(this)
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				Account = __cs2lua_nil_field_value,
				Server = __cs2lua_nil_field_value,
				Other = __cs2lua_nil_field_value,
				Anim = __cs2lua_nil_field_value,
				_logoEffect = __cs2lua_nil_field_value,
				_logoParent = __cs2lua_nil_field_value,
				_versionLbl = __cs2lua_nil_field_value,
				Hero000Mount = __cs2lua_nil_field_value,
				LogoObj = __cs2lua_nil_field_value,
				AllServerObj = __cs2lua_nil_field_value,
				loadingtips = __cs2lua_nil_field_value,
				_isServerNull = true,
				_canStart = false,
				_dealPath = "Deal.tex",
				loginUserInfo = __cs2lua_nil_field_value,
				_sceneState = 0,
			};
			return instance_fields;
		end;

		local instance_props = {
			IsServerNull = {
				set = instance_methods.set_IsServerNull,
			},
		};

		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIEntityBehaviour, "LoginCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




LoginCom.SceneState = {
	["None"] = 0,
	["Start"] = 1,
	["Enter"] = 2,
	["Open"] = 3,
	["Leave"] = 4,
};

rawset(LoginCom.SceneState, "Value2String", {
		[0] = "None",
		[1] = "Start",
		[2] = "Enter",
		[3] = "Open",
		[4] = "Leave",
});
LoginCom.__define_class();
