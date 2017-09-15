require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "Eight__Framework__EIFrameWork";
require "GameUtility";
require "EightGame__Logic__LoginUserParam";
require "Eight__Framework__EIEvent";
require "EightGame__Logic__CommonTipsParam";

LoginOtherCom = {
	__new_object = function(...)
		return newobject(LoginOtherCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = LoginOtherCom;

		local static_methods = {
			cctor = function()
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				SET_NOTIC = "SET_NOTIC",
				OPEN_NOTICPAGE_WHEN_DISCON = "OPEN_NOTICPAGE",
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			Init = function(this)
				this:LoadText("LinshiTxt/Deal", this.DealData);
				this.NoticData.text = "[00ff00]冒险者,请打开你的网络![-]";
--LoadText ("LinshiTxt/Notice",NoticData);
--DealSB.value = 0;
				this.NoticSB.value = 0;
				Eight.Framework.EIFrameWork.Instance:AddEventListener("SET_NOTIC", (function() local __compiler_delegation_51 = (function(e) this:FreshNoticStr(e); end); setdelegationkey(__compiler_delegation_51, "LoginOtherCom:FreshNoticStr", this, this.FreshNoticStr); return __compiler_delegation_51; end)());
				Eight.Framework.EIFrameWork.Instance:AddEventListener("OPEN_NOTICPAGE", (function() local __compiler_delegation_52 = (function(e) this:WhenDisconnet(e); end); setdelegationkey(__compiler_delegation_52, "LoginOtherCom:WhenDisconnet", this, this.WhenDisconnet); return __compiler_delegation_52; end)());
--CreatTest ();
			end,
			OpenRegisterPage = function(this)
				this:ResetData();
				this:OpenDealPage();
				this.IsRegister = true;
--GameUtility.TweenScaleOpen (RegisterObj);
--StartCoroutine(GameUtility.TweenScaleOpen ( RegisterObj)); 
			end,
			CloseRegisterPage = function(this)
--GameUtility.TweenScaleClose (RegisterObj);
--		StartCoroutine(GameUtility.TweenScaleClose (RegisterObj));
				GameUtility.TweenScaleClose(this.RegisterObj);
			end,
			OpenDealPage = function(this)
--GameUtility.TweenScaleOpen (DealObj);
--		StartCoroutine(GameUtility.TweenScaleOpen ( DealObj));
				GameUtility.TweenScaleOpen(this.DealObj);
			end,
			CloseDealPage = function(this, obj)
--		StartCoroutine (GameUtility.TweenScaleClose (DealObj));
				GameUtility.TweenScaleClose(this.DealObj);
--GameUtility.TweenScaleClose (DealObj);
				if this.IsRegister then
					if invokeforbasicvalue(obj.name, false, System.String, "Contains", "Confirm") then
						GameUtility.TweenScaleOpen(this.RegisterObj);
					end;
				end;
				this.IsRegister = false;
--StartCoroutine(GameUtility.TweenScaleClose (DealObj));
			end,
			OpenNoticePage = function(this)
				GameUtility.TweenScaleOpen(this.NoticeObj);
--StartCoroutine(GameUtility.TweenScaleOpen ( NoticeObj));
			end,
			CloseNoticePage = function(this)
--GameUtility.TweenScaleClose (NoticeObj);
				GameUtility.TweenScaleClose(this.NoticeObj);
--		StartCoroutine(GameUtility.TweenScaleClose (NoticeObj));
			end,
			Registersucceed = function(this)
				if (getforbasicvalue(this.RPassword.value, false, System.String, "Length") < 6) then
					this:ErrorTips("密码要6个字符以上");
				elseif (this.RPassword.value ~= this.RCPassword.value) then
					this:ErrorTips("确定密码和密码不同,请重新输入");
				else
					this:CloseRegisterPage();
					Eight.Framework.EIDebuger.Log("要向服务器提交一下申请");
					local rInfo; rInfo = newobject(EightGame.Logic.LoginUserParam, "ctor", nil, "eichannel_empty", "eichannel_empty", this.RName.value, this.RPassword.value);
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "LOGIN_REGISTER", nil, rInfo, 0));
				end;
--CloseRegisterPage ();
--EIFrameWork.Instance.DispatchEvent (new EIEvent( LoginMessageType.LOGIN_REGISTER ,));
			end,
			ResetData = function(this)
				this.RName.value = "";
				this.RPassword.value = "";
				this.RCPassword.value = "";
--PlayerPrefs_Ex.SetInt ("Agree",0);
			end,
			ErrorTips = function(this, errorStr)
				local tip; tip = newobject(EightGame.Logic.CommonTipsParam, "ctor", nil, errorStr, 0, nil, nil, "");
				tip.isShowOKCancelBtn = false;
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_TIPS", nil, tip, 0.00));
			end,
			LoadText = function(this, path, DataLabel)
--TextAsset ta = Resources.Load (path) as TextAsset;
--//string text = System.IO.File.ReadAllText(path,UTF8Encoding.Default);
--if( ta != null )
--{
--    DataLabel.text = ta.ToString();
--}
			end,
			FreshNoticStr = function(this, e)
				local strList; strList = typeas(e.extraInfo, System.Collections.Generic.List_System.String, false);
--		string getdata = (e as EIStringEvent).stringParam;
				if System.String.IsNullOrEmpty(getexterninstanceindexer(strList, nil, "get_Item", 0)) then
					this.NoticeTitle.text = "更新公告";
				else
					this.NoticeTitle.text = getexterninstanceindexer(strList, nil, "get_Item", 0);
				end;
				this.NoticData.text = getexterninstanceindexer(strList, nil, "get_Item", 1);
			end,
			WhenDisconnet = function(this, e)
--NoticComfirBT.SetActive (false);
				this:LoadText("LinshiTxt/Notice", this.NoticData);
--NoticData.text = _localNoticData;
--OpenNoticePage ();
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				DealSV = __cs2lua_nil_field_value,
				DealSB = __cs2lua_nil_field_value,
				DealData = __cs2lua_nil_field_value,
				NoticeSV = __cs2lua_nil_field_value,
				NoticSB = __cs2lua_nil_field_value,
				NoticeTitle = __cs2lua_nil_field_value,
				NoticData = __cs2lua_nil_field_value,
				RegisterObj = __cs2lua_nil_field_value,
				RName = __cs2lua_nil_field_value,
				RPassword = __cs2lua_nil_field_value,
				RCPassword = __cs2lua_nil_field_value,
				DealObj = __cs2lua_nil_field_value,
				NoticeObj = __cs2lua_nil_field_value,
				AllServerPage = __cs2lua_nil_field_value,
				IsDelayOpen = false,
				IsRegister = false,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "LoginOtherCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



LoginOtherCom.__define_class();
