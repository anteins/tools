require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "EventDelegate";
require "LogicStatic";
require "Eight__Framework__EIFrameWork";
require "Eight__Framework__EIStringEvent";
require "ClubUtility";
require "RoleInfoUtil";
require "ClubEditorTipUI";
require "EightGame__Logic__TipsDialogParam";
require "Eight__Framework__EIEvent";
require "ClubApplyerListDialogNode";
require "EightGame__Component__ServiceCenter";
require "EightGame__Component__ClubService";
require "EightGame__Logic__TipStruct";
require "NGUITools";
require "SingleMemberUI";
require "ChatMsgManager";
require "PlayerInfoUtil";

ClubInfoPageUI = {
	__new_object = function(...)
		return newobject(ClubInfoPageUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubInfoPageUI;

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
			Init = function(this, _call)
				delegationset(false, false, "ClubInfoPageUI:ActiveCall", this, nil, "ActiveCall", _call);
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.EditorBt.onClick, (function() local __compiler_delegation_78 = (function() this:OnShowEditorTip(); end); setdelegationkey(__compiler_delegation_78, "ClubInfoPageUI:OnShowEditorTip", this, this.OnShowEditorTip); return __compiler_delegation_78; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.ApplyListBt.onClick, (function() local __compiler_delegation_79 = (function() this:OnOpenApplyList(); end); setdelegationkey(__compiler_delegation_79, "ClubInfoPageUI:OnOpenApplyList", this, this.OnOpenApplyList); return __compiler_delegation_79; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.ExitBt.onClick, (function() local __compiler_delegation_80 = (function() this:OnClubExit(); end); setdelegationkey(__compiler_delegation_80, "ClubInfoPageUI:OnClubExit", this, this.OnClubExit); return __compiler_delegation_80; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.UpGradeBt.onClick, (function() local __compiler_delegation_81 = (function() this:OnOpenUpGradePage(); end); setdelegationkey(__compiler_delegation_81, "ClubInfoPageUI:OnOpenUpGradePage", this, this.OnOpenUpGradePage); return __compiler_delegation_81; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.ProbleBt.onClick, (function() local __compiler_delegation_82 = (function() this:OnClickProble(); end); setdelegationkey(__compiler_delegation_82, "ClubInfoPageUI:OnClickProble", this, this.OnClickProble); return __compiler_delegation_82; end)());
				this:InitDic();
				delegationadd(false, false, "UIRecycledList:onUpdateItem", this.BrRecyced, nil, "onUpdateItem", (function() local __compiler_delegation_85 = (function(item, itemIndex, dataIndex) this:OnUpdata(item, itemIndex, dataIndex); end); setdelegationkey(__compiler_delegation_85, "ClubInfoPageUI:OnUpdata", this, this.OnUpdata); return __compiler_delegation_85; end)());
				this.Pid = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil).id;
				this.ShowPrivilegeUI.gameObject:SetActive(false);
				this.ShowPrivilegeUI:Init();
				this.UpGradePage:Init();
			end,
			OnEnter = function(this, _page)
				this:SetInfoData(nil);
				if (_page == 1) then
					this.UpGradePage.gameObject:SetActive(false);
					this.MemberObjs:SetActive(true);
					this.Mshow = 0;
					this:SetSort();
					this.ActiveCall(true);
				elseif (_page == 2) then
					this.MemberObjs:SetActive(false);
					this.UpGradePage.gameObject:SetActive(true);
					this.UpGradePage:OnEnter();
					this.ActiveCall(false);
				end;
			end,
			OnAddFresh = function(this, e)
				this:SetSort();
			end,
			OnExit = function(this)
				this.MemberObjs:SetActive(false);
				this.UpGradePage.gameObject:SetActive(false);
			end,
			OnChangeSort = function(this)
				local labstr; labstr = "";
				this.Mshow = typecast(( invokeintegeroperator(1, "%", ( invokeintegeroperator(2, "+", ( typecast(this.Mshow, System.Int32, false) ), 1, System.Int32, System.Int32) ), 7, System.Int32, System.Int32) ), ClubInfoPageUI.MemberShow, true);
--修正关闭按钮显示
				this:SetSort();
				local __compiler_switch_131 = this.Mshow;
				if __compiler_switch_131 == 0 then
					labstr = "筛选: 综合";
				elseif __compiler_switch_131 == 1 then
					labstr = "筛选: 权限";
				elseif __compiler_switch_131 == 2 then
					labstr = "筛选: 周贡献";
				elseif __compiler_switch_131 == 3 then
					labstr = "筛选: 总贡献";
				elseif __compiler_switch_131 == 4 then
					labstr = "筛选: 等级";
				elseif __compiler_switch_131 == 5 then
					labstr = "筛选: 会员";
				elseif __compiler_switch_131 == 6 then
					labstr = "筛选: 在线";
				end;
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIStringEvent, "ctor__System_String__System_String", nil, "CHANGE_SHOW_CLUB_MEMBERS", labstr));
			end,
			SetInfoData = function(this, e)
				local _data; _data = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil);
				this.ClubIDLab.text = System.String.Format("ID:{0}", _data.id);
				local Level; Level = _data.clubLv;
				this.ClubNameLab.text = System.String.Format("等级{0}  {1}", Level, System.Text.Encoding.UTF8:GetString(_data.name));
				this.ClubPrestigeLab.text = invokeforbasicvalue(_data.clubPrestige, false, System.Int64, "ToString");
				this.ClubMoneyLab.text = invokeforbasicvalue(_data.money, false, System.Int64, "ToString");
				this.ClubWoodLab.text = invokeforbasicvalue(_data.resources1, false, System.Int64, "ToString");
				this.ClubMineralLab.text = invokeforbasicvalue(_data.resources2, false, System.Int64, "ToString");
				this.ClubManaLab.text = invokeforbasicvalue(_data.resources3, false, System.Int64, "ToString");
				this.DailyCostLab.text = invokeforbasicvalue(ClubUtility.GetAllDailyMoney(_data.clubLv), false, System.Int32, "ToString");
				local gp; gp = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildProsperity), nil);
				local nowNum; nowNum = LogicStatic.GetList(typeof(EightGame.Data.Server.MemberDataNotify), nil).Count;
				local maxNum; maxNum = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_lv_info), Level).peoplemax;
				this.ClubMemberNumLab.text = System.String.Format("团员列表  [{0}/{1}]", nowNum, maxNum);
				this.ClubSignatureLab.text = System.Text.Encoding.UTF8:GetString(_data.signature);
				local _p; _p = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildProsperity), nil);
				this.ClubProsperitySpr.spriteName = ("lv" + _p.lv);
			end,
			SetStaticInfo = function(this, _data)
				this.MaxMoneyLab.text = "";
				this.MaxWoodLab.text = "";
				this.MaxMineralLab.text = "";
				this.MaxManaLab.text = "";
			end,
			SetSort = function(this)
				this.Memerbers = LogicStatic.GetList(typeof(EightGame.Data.Server.MemberDataNotify), nil);
				local privilegeid; privilegeid = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_guild_permissions), (function(x) return (x.permissionslv == 4); end)).id;
				local Headdata; Headdata = this.Memerbers:Find((function(x) return (x.privilege == privilegeid); end));
				this.Memerbers:Remove(Headdata);
				this:SetMemverShow();
				local Mlist; Mlist = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.MemberDataNotify, "System.Collections.Generic.List_EightGame.Data.Server.MemberDataNotify", "ctor", {});
				Mlist:Add(Headdata);
				Mlist:AddRange(this.Memerbers);
				this.Memerbers:Clear();
				this.Memerbers = Mlist;
--		for(int i = 0 ; i <Mlist.Count;++i )
--		{
--			EIDebuger.GameLog( string.Format(" i is {0}", i)  );
--			EIDebuger.GameLog( string.Format("   member id is {0}", Mlist[i].id)  );
--		}
--		for(int i = 0 ; i <Mlist.Count;++i )
--		{
--			EIDebuger.GameLog( string.Format(" i is {0}", i)  );
--			EIDebuger.GameLog( string.Format("   member id is {0}", Mlist[i].id)  );
--		}
				local Mydata; Mydata = Mlist:Find((function(x) return (x.id == this.Pid); end));
				this.MyClubData:SetUp(Mydata);
				this.BrRecyced:UpdateDataCount(this.Memerbers.Count, true);
				this.BrRecyced.ScrollView:ResetPosition();
--		BrRecyced.MoveTo (0,true);
				this:ResetAnyBts(Mydata);
			end,
			SetMemverShow = function(this)
				this.Memerbers:Sort((function(x, y)
					local result; result = -1;
					local __compiler_switch_228 = this.Mshow;
					if __compiler_switch_228 == 0 then
						if (invokeforbasicvalue(x.lefttime, false, System.Int64, "CompareTo", y.lefttime) == 0) then
							if (invokeforbasicvalue(x.privilege, false, System.Int32, "CompareTo", y.privilege) == 0) then
								result = invokeforbasicvalue(x.weekPrestige, false, System.Int32, "CompareTo", y.weekPrestige);
							else
								result = invokeforbasicvalue(x.privilege, false, System.Int32, "CompareTo", y.privilege);
							end;
						else
							result = invokeforbasicvalue(x.lefttime, false, System.Int64, "CompareTo", y.lefttime);
						end;
					elseif __compiler_switch_228 == 1 then
						local xp; xp = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_permissions), x.privilege);
						local yp; yp = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_permissions), y.privilege);
						result = invokeforbasicvalue(xp.permissionslv, false, System.Int32, "CompareTo", yp.permissionslv);
					elseif __compiler_switch_228 == 2 then
						result = invokeforbasicvalue(x.weekPrestige, false, System.Int32, "CompareTo", y.weekPrestige);
					elseif __compiler_switch_228 == 3 then
						result = invokeforbasicvalue(x.allPrestige, false, System.Int32, "CompareTo", y.allPrestige);
					elseif __compiler_switch_228 == 4 then
						result = invokeforbasicvalue(x.level, false, System.Int32, "CompareTo", y.level);
					elseif __compiler_switch_228 == 5 then
						result = invokeforbasicvalue(x.viplv, false, System.Int32, "CompareTo", y.viplv);
					elseif __compiler_switch_228 == 6 then
						result = invokeforbasicvalue(x.lefttime, false, System.Int64, "CompareTo", y.lefttime);
					end;
					return invokeintegeroperator(3, "-", nil, result, nil, System.Int32);
				end));
			end,
			OnShowEditorTip = function(this)
				local _tippath; _tippath = "ClubUI/ClubTipsUI/SignEditorTips";
				Eight.Framework.EIFrameWork.StartCoroutine(RoleInfoUtil.LoadAsynUIPrefab(nil, _tippath, (function(obj)
					local _tipui; _tipui = obj:GetComponent(ClubEditorTipUI);
					_tipui:Init();
					local tipsDialogParam; tipsDialogParam = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__UnityEngine_GameObject__System_String__System_Func_System_Boolean__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "ClubInfoEditor", "团队公告编辑", obj, "确定", (function()
						this:SendInput(_tipui.EInput.value);
						return true;
					end), "返回", (function() local __compiler_delegation_281 = (function() return this:OnCancel(); end); setdelegationkey(__compiler_delegation_281, "ClubInfoPageUI:OnCancel", this, this.OnCancel); return __compiler_delegation_281; end)(), 5, 0);
					delegationset(false, false, "EightGame.Logic.TipsDialogParam:ondismiss", tipsDialogParam, nil, "ondismiss", (function()
						if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", obj, nil) then
							UnityEngine.Object.Destroy(obj);
						end;
					end));
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, tipsDialogParam, 0.00));
				end)), false);
			end,
			OnShowApplyerListPage = function(this)
				ClubApplyerListDialogNode.Open();
			end,
			OnClubExit = function(this)
				local _m; _m = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.MemberDataNotify), this.Pid);
				local _power; _power = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_permissions), _m.privilege);
				local deital; deital = "[ff6767]离开冒险图后,您的贡献将会清空,需间隔24小时才可以继续创建或加入冒险团![-]";
				if (_power.permissionslv == 4) then
					deital = (deital + "\n[团长]的职务会转让给团内成员");
				end;
				local tipsDialogParam; tipsDialogParam = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__System_String__System_String__System_Func_System_Boolean__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "ClubExit", "退出冒险团", deital, "确定", (function()
					this:OnExitMsg();
					return true;
				end), "返回", (function() local __compiler_delegation_312 = (function() return this:OnCancel(); end); setdelegationkey(__compiler_delegation_312, "ClubInfoPageUI:OnCancel", this, this.OnCancel); return __compiler_delegation_312; end)(), 5, 0);
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, tipsDialogParam, 0.00));
			end,
			OnExitMsg = function(this)
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
				local request; request = newexternobject(EightGame.Data.Server.SendMyGetoutRequest, "EightGame.Data.Server.SendMyGetoutRequest", "ctor", (function(newobj) newobj.playerid = this.Pid;newobj.clubid = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil).id; end));
				srv:SendMyGetoutRequest(request, (function(arg1)
					local errorc; errorc = typecast(arg1, System.Int32, false);
					if (errorc ~= 200) then
						local _tipstr; _tipstr = EightGame.Component.NetCode.GetDesc(errorc);
						local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, _tipstr, 0.20);
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
					else
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "SELF_EXIT_CLUB_FRESH", nil, nil, 0.00));
					end;
				end), nil);
			end,
			OnSendEditor = function(this)
				return true;
			end,
			OnCancel = function(this)
				return true;
			end,
			ResetAnyBts = function(this, mydata)
				local sd_g; sd_g = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_permissions), mydata.privilege);
				this.EditorBt.gameObject:SetActive((sd_g.announcement == 1));
				this.ApplyListBt.gameObject:SetActive((sd_g.addmember == 1));
				this.UpGradeBt.gameObject:SetActive((sd_g.storeupgraded == 1));
				this.BtGrid:Reposition();
			end,
			OnOpenApplyList = function(this)
				ClubApplyerListDialogNode.Open();
			end,
			OnOpenUpGradePage = function(this)
				this:OnEnter(2);
			end,
			InitDic = function(this)
				if (this.dataDic.Count == 0) then
					local i; i = 0;
					while (i < 8) do
						local obj; obj = NGUITools.AddChild__UnityEngine_GameObject__UnityEngine_GameObject(NGUITools, this.BrRecyced.gameObject, this.SingleMemberSample);
						local com; com = obj:GetComponent(SingleMemberUI);
						EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(com.MoreThingsBt.onClick, (function()
							this:OnShowPrivilegeUI(com.MyMember, com.MoreThingsBt.transform.localPosition);
						end));
						obj.name = System.String.Format("member_{0}", i);
						obj:SetActive(true);
						this.dataDic:Add(obj, com);
					i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
					end;
				end;
			end,
			OnUpdata = function(this, item, itemIndex, dataIndex)
				local _Sui; _Sui = nil;
				if (function() local __compiler_invoke_396; __compiler_invoke_396, _Sui = this.dataDic:TryGetValue(item); return __compiler_invoke_396; end)() then
					if ((this.Memerbers.Count > 0) and (dataIndex < this.Memerbers.Count)) then
						_Sui = item:GetComponent(SingleMemberUI);
						_Sui:SetUp(getexterninstanceindexer(this.Memerbers, nil, "get_Item", dataIndex));
					end;
				end;
			end,
			OnShowPrivilegeUI = function(this, _other, pos)
				if (this.Pid == _other.id) then
					return ;
				end;
--		Vector3 pos = ClubHouseNode.ClubCamera.WorldToScreenPoint (btpos);
				local _m; _m = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.MemberDataNotify), this.Pid);
				this.ShowPrivilegeUI.gameObject:SetActive(true);
				this.ShowPrivilegeUI:SetUp(_m, _other);
				this.ShowPrivilegeUI.DatasObj.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, (pos.x - invokeintegeroperator(4, "*", this.ShowPrivilegeUI.BgSpr.width, 2, System.Int32, System.Int32)), pos.y, pos.z);
			end,
			SendInput = function(this, str)
--		bool isHaveUnSpecChar = Regex.IsMatch(str, "[^\u4e00-\u9fa5\u0800-\u4e00\uac00-\ud7a3 _a-zA-Z0-9]");
				local _tips; _tips = System.String.Empty;
--去掉颜色值
				local newstr; newstr = ChatMsgManager.Instance:FifterString(str);
--		SensitiveParam sensitiveParam = ChatMsgManager.Instance.ReplaceSendMsg( fifter );
--		string newstr = sensitiveParam.replacedStr;
--		byte[]  fifterStr 				= System.Text.Encoding.UTF8.GetBytes(  sensitiveParam.replacedStr  );
--		if (isHaveUnSpecChar){_tips ="含有非法字符,请重新设置";}
				if (getforbasicvalue(newstr, false, System.String, "Length") > 70) then
					_tips = "公告文字过长(70字),请重新设置";
				end;
				if PlayerInfoUtil.CheckBlackList(newstr) then
					_tips = "公告不能含有非法词汇,请重新设置";
				end;
				if (not System.String.IsNullOrEmpty(_tips)) then
					local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, _tips, 0.20);
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
					return ;
				end;
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
				local request; request = newexternobject(EightGame.Data.Server.SendNewSignRequest, "EightGame.Data.Server.SendNewSignRequest", "ctor", (function(newobj) newobj.newSign = newstr; end));
				srv:SendNewSignRequest(request, (function(arg1)
					local errorc; errorc = typecast(arg1, System.Int32, false);
					if (errorc ~= 200) then
						local _tipstr; _tipstr = EightGame.Component.NetCode.GetDesc(errorc);
						local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, _tipstr, 0.20);
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
					else
						this.ClubSignatureLab.text = str;
					end;
				end), nil);
			end,
			OnClickProble = function(this)
				local detalstr; detalstr = "[99ff82]每日维护资金：[-]\n冒险团每日需要支付维护资金,冒险团等级越高、设施等级越高,需要支付的资金也越多。当维护资金不支付时，将会使用声望值支付,当声望也无法支付时，冒险团将解散\n\n[99ff82]繁荣：[-]\n团内成员进行特定的冒险团活动可获得繁荣值,繁荣值每天结算一次,繁荣值没达到指定量则结算时会扣除相应的,繁荣值繁荣等级越高,在讨伐任务中获得的奖励就越好\n\n[99ff82]资金：[-]\n可用于冒险团升级和冒险团维护，可在冒险团活动中获得\n\n[99ff82]木材：[-]\n冒险团升级所需，可在冒险团活动中获得\n\n[99ff82]石材：[-]\n冒险团升级所需，可在冒险团活动中获得";
				ClubUtility.ShowCommonExpainTips(detalstr);
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				ClubIDLab = __cs2lua_nil_field_value,
				ClubNameLab = __cs2lua_nil_field_value,
				ClubPrestigeLab = __cs2lua_nil_field_value,
				ClubMoneyLab = __cs2lua_nil_field_value,
				ClubWoodLab = __cs2lua_nil_field_value,
				ClubMineralLab = __cs2lua_nil_field_value,
				ClubManaLab = __cs2lua_nil_field_value,
				ClubMemberNumLab = __cs2lua_nil_field_value,
				BrRecyced = __cs2lua_nil_field_value,
				ClubSignatureLab = __cs2lua_nil_field_value,
				ClubProsperitySpr = __cs2lua_nil_field_value,
				MyClubData = __cs2lua_nil_field_value,
				DailyCostLab = __cs2lua_nil_field_value,
				MaxMoneyLab = __cs2lua_nil_field_value,
				MaxWoodLab = __cs2lua_nil_field_value,
				MaxMineralLab = __cs2lua_nil_field_value,
				MaxManaLab = __cs2lua_nil_field_value,
				SingleMemberSample = __cs2lua_nil_field_value,
				ShowPrivilegeUI = __cs2lua_nil_field_value,
				BtGrid = __cs2lua_nil_field_value,
				UpGradeBt = __cs2lua_nil_field_value,
				ApplyListBt = __cs2lua_nil_field_value,
				ExitBt = __cs2lua_nil_field_value,
				EditorBt = __cs2lua_nil_field_value,
				ProbleBt = __cs2lua_nil_field_value,
				MemberObjs = __cs2lua_nil_field_value,
				UpGradePage = __cs2lua_nil_field_value,
				dataDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_SingleMemberUI, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_SingleMemberUI", "ctor", {}),
				Memerbers = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.MemberDataNotify, "System.Collections.Generic.List_EightGame.Data.Server.MemberDataNotify", "ctor", {}),
				Pid = 0,
				Mshow = 0,
				ActiveCall = wrapdelegation{},
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubInfoPageUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




ClubInfoPageUI.PageShow = {
	["MemberPage"] = 1,
	["UpgradePage"] = 2,
};

rawset(ClubInfoPageUI.PageShow, "Value2String", {
		[1] = "MemberPage",
		[2] = "UpgradePage",
});

ClubInfoPageUI.MemberShow = {
	["Normal"] = 0,
	["Privilege"] = 1,
	["WeekPrestige"] = 2,
	["AllPrestige"] = 3,
	["Level"] = 4,
	["VipLevel"] = 5,
	["OnlineTime"] = 6,
};

rawset(ClubInfoPageUI.MemberShow, "Value2String", {
		[0] = "Normal",
		[1] = "Privilege",
		[2] = "WeekPrestige",
		[3] = "AllPrestige",
		[4] = "Level",
		[5] = "VipLevel",
		[6] = "OnlineTime",
});
ClubInfoPageUI.__define_class();
