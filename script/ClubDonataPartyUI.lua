require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EventDelegate";
require "LogicStatic";
require "ShowRewardUtil";
require "EightGame__Logic__TipStruct";
require "Eight__Framework__EIFrameWork";
require "Eight__Framework__EIEvent";
require "RoleInfoUtil";
require "ClubDonataTipsUI";
require "EightGame__Logic__TipsDialogParam";
require "EightGame__Component__ServiceCenter";
require "EightGame__Component__ClubService";
require "EightGame__Logic__FloatingTextTipUIRoot";

ClubDonataPartyUI = {
	__new_object = function(...)
		return newobject(ClubDonataPartyUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubDonataPartyUI;

		local static_methods = {
			cctor = function()
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
			Init = function(this)
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.DonataBt.onClick, (function() local __compiler_delegation_21 = (function() this:OnDonata(); end); setdelegationkey(__compiler_delegation_21, "ClubDonataPartyUI:OnDonata", this, this.OnDonata); return __compiler_delegation_21; end)());
			end,
			SetUp = function(this)
				local numdata; numdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildNum), nil);
				if (this.daymax == 0) then
					this.daymax = LogicStatic.GetList(typeof(EightGame.Data.Server.sd_guild_diamond_donation), nil).Count;
				end;
				this.curcount = numdata.donation;
				this.CountValLab.text = System.String.Format("{0}/{1}", this.curcount, this.daymax);
				local guilddonation; guilddonation = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_diamond_donation), invokeintegeroperator(2, "+", this.curcount, 1, System.Int32, System.Int32));
				if (guilddonation == nil) then
					guilddonation = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_diamond_donation), this.curcount);
				end;
				this:SetReward(guilddonation);
				this.DiamonCost = guilddonation.costdiamond;
			end,
			SetReward = function(this, guilddonation)
				local rewardstr; rewardstr = "";
				if (guilddonation.getmoney ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 1);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilddonation.getmoney);
				end;
				if (guilddonation.getstone ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 2);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilddonation.getstone);
				end;
				if (guilddonation.getwood ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 3);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilddonation.getwood);
				end;
				if (guilddonation.getmana ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 4);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilddonation.getmana);
				end;
				if (guilddonation.getprestige ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 5);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilddonation.getprestige);
				end;
				if (guilddonation.getprosperity ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 6);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilddonation.getprosperity);
				end;
				this.AllRewardValLab.text = rewardstr;
				if (guilddonation.getcontribution ~= 0) then
					this.MyRewardValLab.gameObject:SetActive(true);
					local rstr; rstr = ShowRewardUtil.GetTypeWords(11, 0);
					this.MyRewardValLab.text = System.String.Format("{0} {1}", rstr, guilddonation.getcontribution);
				else
					this.MyRewardValLab.gameObject:SetActive(false);
				end;
			end,
			OnDonata = function(this)
				if (this.curcount >= this.daymax) then
					local _tipstr; _tipstr = "已到达今日捐献上限";
					local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, _tipstr, 0.20);
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
				else
					local _tippath; _tippath = "ClubUI/ClubTipsUI/DonataTips";
					Eight.Framework.EIFrameWork.StartCoroutine(RoleInfoUtil.LoadAsynUIPrefab(nil, _tippath, (function(obj)
						local _tipui; _tipui = obj:GetComponent(ClubDonataTipsUI);
						_tipui:SetUp(this.AllRewardValLab.text, this.MyRewardValLab.text, this.DiamonCost);
						local tipsDialogParam; tipsDialogParam = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__UnityEngine_GameObject__System_String__System_Func_System_Boolean__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "DoDonataTips", "捐献", obj, "确定", (function()
							this:OnDonataMsg();
							return true;
						end), "返回", (function() local __compiler_delegation_104 = (function() return this:OnCancel(); end); setdelegationkey(__compiler_delegation_104, "ClubDonataPartyUI:OnCancel", this, this.OnCancel); return __compiler_delegation_104; end)(), 5, 0);
						delegationset(false, false, "EightGame.Logic.TipsDialogParam:ondismiss", tipsDialogParam, nil, "ondismiss", (function()
							if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", obj, nil) then
								UnityEngine.Object.Destroy(obj);
							end;
						end));
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, tipsDialogParam, 0.00));
					end)), false);
				end;
			end,
			OnCancel = function(this)
				return true;
			end,
			OnDonataMsg = function(this)
				if this.IsRequst then
					return ;
				end;
				this.IsRequst = true;
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
				local request; request = newexternobject(EightGame.Data.Server.SendDonation, "EightGame.Data.Server.SendDonation", "ctor", (function(newobj)  end));
				srv:SendDonation(request, (function(arg1)
					local errorc; errorc = typecast(arg1, System.Int32, false);
					if (errorc ~= 200) then
						local _tipstr; _tipstr = EightGame.Component.NetCode.GetDesc(errorc);
						local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, _tipstr, 0.20);
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
					else
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("捐献成功", 0.00);
						this:SetUp();
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "FRESH_CLUB_PARTYINFO", nil, nil, 0.00));
					end;
					this.IsRequst = false;
				end), nil);
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				AllRewardValLab = __cs2lua_nil_field_value,
				MyRewardValLab = __cs2lua_nil_field_value,
				CountValLab = __cs2lua_nil_field_value,
				DonataBt = __cs2lua_nil_field_value,
				DiamonCost = 0,
				daymax = 0,
				curcount = 0,
				IsRequst = false,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ClubDonataPartyUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubDonataPartyUI.__define_class();
