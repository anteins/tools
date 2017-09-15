require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "UIEventListener";
require "ClubUtility";
require "EventDelegate";
require "LogicStatic";
require "Eight__Framework__EIFrameWork";
require "GameUtility";
require "AlarmManager";
require "SpecialPartyTipsUIcom";
require "ColorScheme";
require "RoleInfoUtil";
require "ShowRewardUtil";
require "BossRanksWindowNode";
require "EightGame__Logic__FloatingTextTipUIRoot";
require "EightGame__Logic__TipsDialogParam";
require "Eight__Framework__EIEvent";
require "BossReadyFormationController";
require "EightGame__Logic__BattleInfoEventIdParam";
require "EightGame__Logic__BattleFormationParam";
require "ClubBossReliveConfirmPageUI";
require "EightGame__Component__ServiceCenter";
require "EightGame__Component__ClubService";
require "ClubIntegralPageUI";
require "EightGame__Logic__BattleStartParam";

ClubBossReadyPageUI = {
	__new_object = function(...)
		return newobject(ClubBossReadyPageUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubBossReadyPageUI;

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
			Init = function(this)
--		UIButton myrewardiconbt = MyRewardBoxTex.gameObject.GetComponent<UIButton> ();
				delegationset(false, false, "UIEventListener:onPress", UIEventListener.Get(this.MyRewardBoxTex.gameObject), nil, "onPress", (function() local __compiler_delegation_59 = (function(_obj, b) ClubUtility.OnPress(_obj, b); end); setdelegationkey(__compiler_delegation_59, "ClubUtility:OnPress", ClubUtility, ClubUtility.OnPress); return __compiler_delegation_59; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.BattleMoreBt.onClick, (function() local __compiler_delegation_60 = (function() this:OnBuyMoreBattleTime(); end); setdelegationkey(__compiler_delegation_60, "ClubBossReadyPageUI:OnBuyMoreBattleTime", this, this.OnBuyMoreBattleTime); return __compiler_delegation_60; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.BattleReadyBt.onClick, (function() local __compiler_delegation_61 = (function() this:OnBeBattle(); end); setdelegationkey(__compiler_delegation_61, "ClubBossReadyPageUI:OnBeBattle", this, this.OnBeBattle); return __compiler_delegation_61; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.ShowDescBt.onClick, (function() local __compiler_delegation_62 = (function() this:OnShowRankList(); end); setdelegationkey(__compiler_delegation_62, "ClubBossReadyPageUI:OnShowRankList", this, this.OnShowRankList); return __compiler_delegation_62; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.PointTakeBtn.onClick, (function() local __compiler_delegation_63 = (function() this:OnPointTakeBtn(); end); setdelegationkey(__compiler_delegation_63, "ClubBossReadyPageUI:OnPointTakeBtn", this, this.OnPointTakeBtn); return __compiler_delegation_63; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.PointViewBtn.onClick, (function() local __compiler_delegation_64 = (function() this:OnPointViewBtn(); end); setdelegationkey(__compiler_delegation_64, "ClubBossReadyPageUI:OnPointViewBtn", this, this.OnPointViewBtn); return __compiler_delegation_64; end)());
				this.FirstSimpleRank:Init();
				this.SecendSimpleRank:Init();
				this.ThirdSimpleRank:Init();
				this.MySimpleRank:Init();
			end,
			OnEnter = function(this, _bossData)
				this._bossData = _bossData;
				this._stData = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.sd_guild_boss), _bossData.id);
				Eight.Framework.EIFrameWork.StartCoroutine(GameUtility.LoadDynamicPic(this._stData.bossicon, (function(tex)
					this.BossTex.mainTexture = tex;
				end), "png"), false);
				this:SetBoxReward();
--      ResetThings ();
--		SetBossThings (_bossData);
--		SetRankthings(_bossData.rank,_stData.rankingreward);
--		CountLab.text = string.Format("参与人数: {0}", _bossData.playernum);
--		long pid = LogicStatic.Get<PlayerSerData> ().id;
--		GuildNum numdata = LogicStatic.Get<GuildNum> (pid);
--		bossnum = numdata.bossnum[0].num;
--		buytime = numdata.buyboss;
--		BattleNumLab.text = string.Format ("{0}/{1}",bossnum,_stData.battlenum);
--
			end,
			Update = function(this)
				if (this._bossData ~= nil) then
					local pid; pid = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil).id;
					this:SetBossThings(this._bossData);
					this:SetRankthings(this._bossData.rank, this._stData.rankingreward);
					this:SetIntegralThings(pid);
					this.CountLab.text = System.String.Format("参与人数: {0}", this._bossData.playernum);
					local numdata; numdata = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.GuildNum), pid);
					this.bossnum = getexterninstanceindexer(numdata.bossnum, nil, "get_Item", 0).num;
					this.buytime = numdata.buyboss;
					this.BattleNumLab.text = System.String.Format("{0}/{1}", this.bossnum, this._stData.battlenum);
				end;
			end,
			SetIntegralThings = function(this, pid)
				if (this._integralList == nil) then
					this._integralList = LogicStatic.GetList(typeof(EightGame.Data.Server.sd_guild_boss_integral), nil);
					local i; i = invokeintegeroperator(3, "-", this._integralList.Count, 1, System.Int32, System.Int32);
					while (i >= 0) do
						if (getexterninstanceindexer(this._integralList, nil, "get_Item", i).id > this._integralMaxId) then
							this._integralMaxId = getexterninstanceindexer(this._integralList, nil, "get_Item", i).id;
						end;
					i = invokeintegeroperator(3, "-", i, 1, System.Int32, System.Int32);
					end;
				end;
--先选择当前能展示哪条数据，再决定数据的状态.
				local m; m = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.MemberDataNotify), pid);
				local maxId; maxId = UnityEngine.Mathf.Max(unpack(m.buycreditlist:ToArray()));
--当查询不到下一级的数据时，说明玩家已经领取了最高级别的奖励.
--当可以查询到下一级的数据时，说明玩家应该接下来要处理的是这条数据，至于能不能领，就要继续判断了.
--当查询不到下一级的数据时，说明玩家已经领取了最高级别的奖励.
--当可以查询到下一级的数据时，说明玩家应该接下来要处理的是这条数据，至于能不能领，就要继续判断了.
				local nextSD; nextSD = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_boss_integral), invokeintegeroperator(2, "+", maxId, 1, System.Int32, System.Int32));
				local isAlreadyTakenMax; isAlreadyTakenMax = (nextSD == nil);
				this.PointAllTakeLab.gameObject:SetActive(isAlreadyTakenMax);
				if isAlreadyTakenMax then
					local curSD; curSD = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_boss_integral), maxId);
					local sd; sd = curSD;
					this.PointRankLab.text = System.String.Format("[ffdd95]Rank[-] [ff7e3f]{0}[-]", condexp((sd.id == this._integralMaxId), true, "Max", false, (function() return invokeforbasicvalue(sd.id, false, System.Int32, "ToString"); end)));
					this.PointProgressLab.text = System.String.Format("[ffdd95]积分[-]  {0}/{1}", UnityEngine.Mathf.Min(m.credit, sd.targetintegral), sd.targetintegral);
					this.PointTakeBtn.gameObject:SetActive(false);
					this.PointViewBtn.gameObject:SetActive(true);
				else
					local isCanTake; isCanTake = (m.credit >= nextSD.targetintegral);
					local sd; sd = nextSD;
					this.PointRankLab.text = System.String.Format("[ffdd95]Rank[-] [ff7e3f]{0}[-]", condexp((sd.id == this._integralMaxId), true, "Max", false, (function() return invokeforbasicvalue(sd.id, false, System.Int32, "ToString"); end)));
					this.PointProgressLab.text = System.String.Format("[ffdd95]积分[-]  {0}/{1}", UnityEngine.Mathf.Min(m.credit, sd.targetintegral), sd.targetintegral);
					this.PointTakeBtn.gameObject:SetActive(isCanTake);
					this.PointViewBtn.gameObject:SetActive((not isCanTake));
				end;
			end,
			SetRankthings = function(this, _bossranks, groupId)
				this.MySimpleRank.gameObject:SetActive(false);
				this.FirstSimpleRank.gameObject:SetActive(false);
				this.SecendSimpleRank.gameObject:SetActive(false);
				this.ThirdSimpleRank.gameObject:SetActive(false);
				if ((_bossranks == nil) or (_bossranks.Count == 0)) then
					return ;
				end;
				if (_bossranks.Count > 1) then
					_bossranks:Sort((function(x, y)
						return invokeforbasicvalue(x.ranknum, false, System.Int32, "CompareTo", y.ranknum);
--                if (x.rankval.CompareTo(y.rankval) ==0)
--                {
--                    return -x.id.CompareTo ( y.id);
--                }
--                return  -x.rankval.CompareTo(y.rankval);
					end));
				end;
				this.NowRanks = _bossranks:FindAll((function(x) return (LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.MemberDataNotify), x.id) ~= nil); end));
				if (this.NowRanks.Count >= 1) then
					this.FirstSimpleRank.gameObject:SetActive(true);
					this.FirstSimpleRank:SetUp(getexterninstanceindexer(this.NowRanks, nil, "get_Item", 0), groupId);
				end;
				if (this.NowRanks.Count >= 2) then
					this.SecendSimpleRank.gameObject:SetActive(true);
					this.SecendSimpleRank:SetUp(getexterninstanceindexer(this.NowRanks, nil, "get_Item", 1), groupId);
				end;
				if (this.NowRanks.Count >= 3) then
					this.ThirdSimpleRank.gameObject:SetActive(true);
					this.ThirdSimpleRank:SetUp(getexterninstanceindexer(this.NowRanks, nil, "get_Item", 2), groupId);
				end;
				local pid; pid = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil).id;
				local mydata; mydata = _bossranks:Find((function(x) return (x.id == pid); end));
				if (mydata ~= nil) then
					this.MySimpleRank.gameObject:SetActive(true);
					this.MySimpleRank:SetUp(mydata, groupId);
				end;
			end,
			SetBossThings = function(this, _bossData)
				if (_bossData == nil) then
					return ;
				end;
				local curTime; curTime = AlarmManager.Instance:currentTimeMillis();
				local issucces; issucces = (_bossData.bosshp == 0);
				local isend; isend = ((not issucces) and (_bossData.closetime < curTime));
				this.SuccesObj:SetActive(issucces);
				this.FailObj:SetActive(isend);
				if (issucces or isend) then
					this.BossTex.isGrey = isend;
					this.EndTimeLab.text = "讨伐结束";
					this.BattleMoreBt.gameObject:SetActive(false);
					this.BattleReadyBt.gameObject:SetActive(false);
					this.ReliveCDLab.gameObject:SetActive(false);
					this.ReliveBt.gameObject:SetActive(false);
					this.OverObjs:SetActive(true);
				else
					local guildNum; guildNum = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildNum), nil);
					local bossNum; bossNum = condexp(((guildNum.bossnum ~= nil) and (guildNum.bossnum.Count > 0)), false, (function() return getexterninstanceindexer(guildNum.bossnum, nil, "get_Item", 0); end), true, nil);
--为空或者已过复活冷却时间 => 显示战斗按钮
					this.BattleReadyBt.gameObject:SetActive(((bossNum == nil) or (bossNum.endtime < curTime)));
--不为空且没过复活冷却时间
					local isInReliveCD; isInReliveCD = ((bossNum ~= nil) and (bossNum.endtime >= curTime));
					this.ReliveCDLab.gameObject:SetActive(isInReliveCD);
					this.ReliveBt.gameObject:SetActive(isInReliveCD);
					if isInReliveCD then
						if (this._grBossFreeTime == nil) then
							this._grBossFreeTime = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_gamerule), (function(x) return (x.paramtype == se_overall.SE_OVERALL_GUILD_BOSS_FREE_TIME); end));
						end;
						if (this._grBossCostTime == nil) then
							this._grBossCostTime = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_gamerule), (function(x) return (x.paramtype == se_overall.SE_OVERALL_GUILD_BOSS_COST_TIME); end));
						end;
						if (this._grBossCostDiamond == nil) then
							this._grBossCostDiamond = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_gamerule), (function(x) return (x.paramtype == se_overall.SE_OVERALL_GUILD_BOSS_COST_DIAMOND); end));
						end;
						local reliveRemainTime; reliveRemainTime = invokeintegeroperator(3, "-", bossNum.endtime, curTime, System.Int64, System.Int64);
						local isFreeRelive; isFreeRelive = (reliveRemainTime <= (this._grBossFreeTime.value * 1000));
--是否处于免费复活时间内.
--是否处于免费复活时间内.
						this.ReliveCDLab.text = System.String.Format("战斗复活中 {0}", SpecialPartyTipsUIcom.ConvertCountDownToTime(reliveRemainTime));
						this.ReliveBtTitleLab.text = condexp(isFreeRelive, true, "立即复活[5cef5c](免费)[-]", true, "立即复活");
						if isFreeRelive then
							EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.ReliveBt.onClick, (function() local __compiler_delegation_244 = (function() this:SendReliveRequest(); end); setdelegationkey(__compiler_delegation_244, "ClubBossReadyPageUI:SendReliveRequest", this, this.SendReliveRequest); return __compiler_delegation_244; end)());
						else
							EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.ReliveBt.onClick, (function()
								this:OnReliveBtn(bossNum, typecast(this._grBossCostDiamond.value, System.Int32, false), typecast(this._grBossFreeTime.value, System.Int32, false), typecast(this._grBossCostTime.value, System.Int32, false));
							end));
						end;
					end;
					if (_bossData.opentime > curTime) then
--处于准备阶段.
						this.EndTimeLab.text = System.String.Format("讨伐准备时间   {0}", SpecialPartyTipsUIcom.ConvertCountDownToTime(invokeintegeroperator(3, "-", _bossData.opentime, curTime, System.Int64, System.Int64)));
					else
--处于战斗阶段.
						this.EndTimeLab.text = System.String.Format("讨伐结束时间   {0}", SpecialPartyTipsUIcom.ConvertCountDownToTime(invokeintegeroperator(3, "-", _bossData.closetime, curTime, System.Int64, System.Int64)));
					end;
				end;
				local sdenemy; sdenemy = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_enemy), this._stData.enemyid);
				local maxhp; maxhp = getexterninstanceindexer(sdenemy.hp, nil, "get_Item", 0);
				local curhp; curhp = _bossData.bosshp;
				local sliderval; sliderval = (_bossData.bosshp / typecast(maxhp, System.Single, false));
				this.BossTitleLab.text = System.String.Format("讨伐 {0}", sdenemy.name);
				this.BossNameLab.text = sdenemy.name;
				this.HpLab.text = System.String.Format("HP {0}[808080]/{1}[-]({2}%)", curhp, maxhp, typecast(( (sliderval * 100) ), System.Int32, false));
				this.HpSlider.value = sliderval;
			end,
			SetEndTimeClock = function(this, endtime)
				AlarmManager.Instance:set("ClubBossEndClock", endtime, (function(start, cur, __compiler_lua_end)
					local remainTime; remainTime = ( invokeintegeroperator(3, "-", __compiler_lua_end, cur, System.Int64, System.Int64) );
					this.EndTimeLab.text = System.String.Format("讨伐结束时间   {0}", SpecialPartyTipsUIcom.ConvertCountDownToTime(remainTime));
				end), (function()
					this.BattleReadyBt.gameObject:SetActive(false);
					this.OverObjs:SetActive(true);
					this.BattleMoreBt.gameObject:SetActive(false);
					this.EndTimeLab.text = "讨伐结束";
					this.BattleMoreBt.gameObject:SetActive(false);
				end));
			end,
			CheckBossTime = function(this, _bossData)
				local issucces, isend;
				if (_bossData.bosshp == 0) then
					issucces = true;
					isend = false;
					return issucces, isend;
				else
					local curtime; curtime = AlarmManager.Instance:currentTimeMillis();
					isend = (_bossData.closetime < curtime);
					issucces = false;
					return issucces, isend;
				end;
				return issucces, isend;
			end,
			SetBoxReward = function(this)
--时间判断
				local prosperityLv; prosperityLv = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildProsperity), nil).lv;
				local _c; _c = ColorScheme.GetRankHexColor(prosperityLv);
--		myRewardBoxSpr.spriteName = string.Format ("bx{0}",prosperityLv);
				local sditem; sditem = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_item_item), this._stData.rewardshow);
				this.MyRewardLab.text = sditem.name;
				Eight.Framework.EIFrameWork.StartCoroutine(RoleInfoUtil.LoadAsynImage(("GameAssets/Textures/Icon/" + sditem.icon), "png", ("GameAssets/Textures/Icon/" + sditem.icon), "png", (function(obj)
					this.MyRewardBoxTex.mainTexture = obj;
					this.MyRewardBoxTex.gameObject.name = invokeforbasicvalue(this._stData.rewardshow, false, System.Int32, "ToString");
				end)), false);
				local rewardstr; rewardstr = "";
				if (this._stData.getmoney ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 1);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, this._stData.getmoney);
				end;
				if (this._stData.getstone ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 2);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, this._stData.getstone);
				end;
				if (this._stData.getwood ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 3);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, this._stData.getwood);
				end;
				if (this._stData.getmana ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 4);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, this._stData.getmana);
				end;
				if (this._stData.getprestige ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 5);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, this._stData.getprestige);
				end;
				if (this._stData.getprosperity ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 6);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, this._stData.getprosperity);
				end;
				this.ClubRewardValLab.text = rewardstr;
			end,
			ResetThings = function(this)
				this.BattleReadyBt.gameObject:SetActive(false);
				this.OverObjs:SetActive(false);
				this.SuccesObj:SetActive(false);
				this.FailObj:SetActive(false);
			end,
			OnShowRankList = function(this)
				BossRanksWindowNode.Open(typecast(this.NowRanks, System.Object, false));
			end,
			OnBuyMoreBattleTime = function(this)
				local bboss; bboss = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildNum), nil).buyboss;
				if (bboss >= getexterninstanceindexer(this._stData.additionalbattlenum, nil, "get_Item", 0)) then
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("今日购买次数已用完", 0.00);
					return ;
				end;
				if this.isClick then
					return ;
				end;
				this.isClick = true;
				local detialstr; detialstr = System.String.Format("花费 #ICON_DIAMOND  {0} 购买 1 次", getexterninstanceindexer(this._stData.additionalbattlenum, nil, "get_Item", 1));
				local tipsDialogParam; tipsDialogParam = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__System_String__System_String__System_Func_System_Boolean__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "ClubBossBattleTime", "购买次数", detialstr, "确定", (function()
					this:BuyBossBattleNumMsg();
					this.isClick = false;
					return true;
				end), "返回", (function() local __compiler_delegation_400 = (function() return this:OnCancel(); end); setdelegationkey(__compiler_delegation_400, "ClubBossReadyPageUI:OnCancel", this, this.OnCancel); return __compiler_delegation_400; end)(), 5, 0);
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, tipsDialogParam, 0.00));
			end,
			OnBeBattle = function(this)
--		if(bossnum<=0)
--		{
--			FloatingTextTipUIRoot.SetFloattingTip( "战斗次数已用完" );
--			return;
--		}
				if this.isClick then
					return ;
				end;
				this.isClick = true;
				local _tippath; _tippath = "ClubUI/ClubPageUI/BossReadyFomationWindowUI";
				Eight.Framework.EIFrameWork.StartCoroutine(RoleInfoUtil.LoadAsynUIPrefab(nil, _tippath, (function(obj)
					local _pageCintroller; _pageCintroller = obj:GetComponent(BossReadyFormationController);
					local fighterArray; fighterArray = LogicStatic.GetList(typeof(EightGame.Data.Server.FighterSerData), nil);
					local battleInfo; battleInfo = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_map_eventbattleinfo), this._stData.battleid);
					fighterArray = this:GetEligibilityFighters(battleInfo, fighterArray);
					local _eventIdParam; _eventIdParam = newobject(EightGame.Logic.BattleInfoEventIdParam, "ctor", nil);
--			_eventIdParam.eventId = _stData.battleid;
					_eventIdParam.eventType = se_battletype.SE_BATTLETYPE_GUILD_BOSS;
					_eventIdParam.eventId = this._stData.id;
					local battleParam; battleParam = newobject(EightGame.Logic.BattleFormationParam, "ctor", nil, _eventIdParam, fighterArray, battleInfo);
					_pageCintroller:SetInfo(battleParam);
					local tipsDialogParam; tipsDialogParam = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__UnityEngine_GameObject__System_String__System_Func_System_Boolean__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "ClubBossFormation", "出战角色", obj, "确定", (function()
						this:GoBossBattleMsg(_eventIdParam, battleInfo, _pageCintroller._com:GetFighterids());
						this.isClick = false;
						this:OnExit();
						return true;
					end), "返回", (function() local __compiler_delegation_437 = (function() return this:OnCancel(); end); setdelegationkey(__compiler_delegation_437, "ClubBossReadyPageUI:OnCancel", this, this.OnCancel); return __compiler_delegation_437; end)(), 5, 0);
					delegationset(false, false, "EightGame.Logic.TipsDialogParam:ondismiss", tipsDialogParam, nil, "ondismiss", (function()
						if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", obj, nil) then
							UnityEngine.Object.Destroy(obj);
						end;
					end));
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, tipsDialogParam, 0.00));
				end)), false);
			end,
			OnReliveBtn = function(this, bossNum, costDiamondPerUnit, freeTime, timeUnit)
				Eight.Framework.EIFrameWork.StartCoroutine(RoleInfoUtil.LoadAsynUIPrefab(this.gameObject, "ClubUI/ClubPageUI/ui_boss_relive_popup_frag", (function(obj)
--Init UI.
					local popup; popup = obj:GetComponent(ClubBossReliveConfirmPageUI);
--Inject to Container.
					local param; param = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__UnityEngine_GameObject__System_String__System_Func_System_Boolean__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "ui_boss_relive_popup_frag", "立即复活", obj, "确定", (function()
						local player; player = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
						if (player.diamond < popup:GetCostDiamond()) then
							EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(EightGame.Component.NetCode.GetDesc(1163), 0.00);
							return false;
						else
							this:SendReliveRequest();
						end;
						return true;
					end), "取消", nil, 5, 0);
					delegationset(false, false, "EightGame.Logic.TipsDialogParam:ondismiss", param, nil, "ondismiss", (function()
						if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", obj, nil) then
							UnityEngine.Object.Destroy(obj);
						end;
					end));
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, param, 0.00));
					popup:Init(bossNum, costDiamondPerUnit, freeTime, timeUnit);
				end)), false);
			end,
			SendReliveRequest = function(this)
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
				local request; request = newexternobject(EightGame.Data.Server.SendDeathRequest, "EightGame.Data.Server.SendDeathRequest", "ctor", nil);
				srv:SendDeathRequest(request, (function(returnCode)
					local msg; msg = "";
					if (returnCode == 200) then
						msg = "复活成功";
					else
						msg = EightGame.Component.NetCode.GetDesc(typecast(returnCode, System.Int32, false));
					end;
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(msg, 0.00);
				end), nil);
			end,
			OnPointTakeBtn = function(this)
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
				local request; request = newexternobject(EightGame.Data.Server.SendGetRewardCreditRequest, "EightGame.Data.Server.SendGetRewardCreditRequest", "ctor", nil);
				srv:SendGetRewardCreditRequest(request, (function(returnCode)
					local msg; msg = "";
					if (returnCode == 200) then
						msg = "积分奖励领取成功";
					else
						msg = EightGame.Component.NetCode.GetDesc(typecast(returnCode, System.Int32, false));
					end;
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(msg, 0.00);
				end), nil);
			end,
			OnPointViewBtn = function(this)
				Eight.Framework.EIFrameWork.StartCoroutine(RoleInfoUtil.LoadAsynUIPrefab(this.gameObject, "ClubUI/ClubPageUI/ui_boss_integral_popup_frag", (function(obj)
--Init UI.
					local popup; popup = obj:GetComponent(ClubIntegralPageUI);
--Inject to Container.
					local param; param = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__UnityEngine_GameObject__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "ClubIntegralPageUI", "个人积分奖励", obj, "返回", nil, 5, 0);
					delegationset(false, false, "EightGame.Logic.TipsDialogParam:ondismiss", param, nil, "ondismiss", (function()
						if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", obj, nil) then
							UnityEngine.Object.Destroy(obj);
						end;
					end));
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, param, 0.00));
					popup:Init();
				end)), false);
			end,
			OnExit = function(this)
				AlarmManager.Instance:cancel("ClubBossEndClock");
			end,
			BuyBossBattleNumMsg = function(this)
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
				local request; request = newexternobject(EightGame.Data.Server.SendBuyBossBattleNumRequest, "EightGame.Data.Server.SendBuyBossBattleNumRequest", "ctor", nil);
				srv:SendBuyBossBattleNumRequest(request, (function(arg1)
					local errorc; errorc = typecast(arg1, System.Int32, false);
					if (errorc ~= 200) then
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(EightGame.Component.NetCode.GetDesc(errorc), 0.00);
						return ;
					end;
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("购买成功", 0.00);
					local pid; pid = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil).id;
					local numdata; numdata = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.GuildNum), pid);
					this.bossnum = getexterninstanceindexer(numdata.bossnum, nil, "get_Item", 0).num;
					this.BattleNumLab.text = System.String.Format("{0}/{1}", this.bossnum, this._stData.battlenum);
				end), nil);
			end,
			GoBossBattleMsg = function(this, _eventIdParam, _battleInfo, fighterids)
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
				local request; request = newexternobject(EightGame.Data.Server.SendBoss, "EightGame.Data.Server.SendBoss", "ctor", nil);
				local _fids; _fids = fighterids:FindAll((function(x) return (x ~= 0); end));
				if ((_fids == nil) or (_fids.Count == 0)) then
					return ;
				end;
				request.fighter:AddRange(_fids);
				srv:SendBoss(request, (function(arg1, response)
					local errorc; errorc = typecast(arg1, System.Int32, false);
					this:BeginClubBossWar(errorc, response, _eventIdParam, _battleInfo);
				end), nil);
			end,
			BeginClubBossWar = function(this, returnCode, setupResponse, _eventIdParam, _battleInfo)
				if (returnCode ~= 200) then
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(EightGame.Component.NetCode.GetDesc(returnCode), 0.00);
					return ;
				end;
--记录进入relick副本战斗
--			EIFrameWork.GetComponent< Statistical >().RecordEnterRelicEvent();
--记录进入relick副本战斗
--			EIFrameWork.GetComponent< Statistical >().RecordEnterRelicEvent();
				local assistPid; assistPid = 0;
--_eventIdParam.eventId = setupResponse.battleGveSetup.eventId;
				local param; param = newobject(EightGame.Logic.BattleStartParam, "ctor", nil, setupResponse.battleGveSetup.battleSetup, _battleInfo, _eventIdParam, assistPid, nil);
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "FIGHT_BATTLE_SETUP", nil, param, 0.00));
			end,
			GetEligibilityFighters = function(this, battleinfo, accordList)
				if ((battleinfo.mustjob.Count == 0) or ( ((battleinfo.mustjob.Count == 1) and (getexterninstanceindexer(battleinfo.mustjob, nil, "get_Item", 0) == se_jobtype.SE_JOBTYPE_NOTHING )) )) then
					return this:GetEligibilityLvFighters(battleinfo.mustlevel, accordList);
				end;
				return this:GetEligibilityJobFighters(battleinfo.mustjob, this:GetEligibilityLvFighters(battleinfo.mustlevel, accordList));
			end,
			GetEligibilityJobFighters = function(this, jobtypes, accordList)
				local result; result = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.FighterSerData, "System.Collections.Generic.List_EightGame.Data.Server.FighterSerData", "ctor", {});
				local index; index = 0;
				while (index < jobtypes.Count) do
					local j; j = 0;
					while (j < accordList.Count) do
						local role; role = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_role_role), getexterninstanceindexer(accordList, nil, "get_Item", j).staticId);
						if ((role ~= nil) and (role.job == getexterninstanceindexer(jobtypes, nil, "get_Item", index))) then
							if (not result:Contains(getexterninstanceindexer(accordList, nil, "get_Item", j))) then
								result:Add(getexterninstanceindexer(accordList, nil, "get_Item", j));
							end;
						end;
					j = invokeintegeroperator(2, "+", j, 1, System.Int32, System.Int32);
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				return result;
			end,
			GetEligibilityLvFighters = function(this, limitLv, accordList)
				local result; result = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.FighterSerData, "System.Collections.Generic.List_EightGame.Data.Server.FighterSerData", "ctor", {});
				local index; index = 0;
				while (index < accordList.Count) do
					if (getexterninstanceindexer(accordList, nil, "get_Item", index).level >= limitLv) then
						result:Add(getexterninstanceindexer(accordList, nil, "get_Item", index));
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				return result;
			end,
			OnCancel = function(this)
				this.isClick = false;
				return true;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				BossTitleLab = __cs2lua_nil_field_value,
				MyRewardLab = __cs2lua_nil_field_value,
				MyRewardBoxTex = __cs2lua_nil_field_value,
				ClubRewardGrid = __cs2lua_nil_field_value,
				ClubRewardValLab = __cs2lua_nil_field_value,
				BossNameLab = __cs2lua_nil_field_value,
				EndTimeLab = __cs2lua_nil_field_value,
				BossTex = __cs2lua_nil_field_value,
				HpSlider = __cs2lua_nil_field_value,
				HpLab = __cs2lua_nil_field_value,
				CountLab = __cs2lua_nil_field_value,
				ShowDescBt = __cs2lua_nil_field_value,
				BattleNumLab = __cs2lua_nil_field_value,
				BattleMoreBt = __cs2lua_nil_field_value,
				BattleReadyBt = __cs2lua_nil_field_value,
				ReliveBt = __cs2lua_nil_field_value,
				ReliveBtTitleLab = __cs2lua_nil_field_value,
				ReliveCDLab = __cs2lua_nil_field_value,
				PointAllTakeLab = __cs2lua_nil_field_value,
				PointRankLab = __cs2lua_nil_field_value,
				PointProgressLab = __cs2lua_nil_field_value,
				PointTakeBtn = __cs2lua_nil_field_value,
				PointViewBtn = __cs2lua_nil_field_value,
				OverObjs = __cs2lua_nil_field_value,
				SuccesObj = __cs2lua_nil_field_value,
				FailObj = __cs2lua_nil_field_value,
				MySimpleRank = __cs2lua_nil_field_value,
				FirstSimpleRank = __cs2lua_nil_field_value,
				SecendSimpleRank = __cs2lua_nil_field_value,
				ThirdSimpleRank = __cs2lua_nil_field_value,
				NowRanks = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.bossRankdata, "System.Collections.Generic.List_EightGame.Data.Server.bossRankdata", "ctor", {}),
				bossnum = 0,
				buytime = 0,
				isClick = false,
				_stData = __cs2lua_nil_field_value,
				_bossData = __cs2lua_nil_field_value,
				_integralList = __cs2lua_nil_field_value,
				_integralMaxId = 0,
				_grBossFreeTime = __cs2lua_nil_field_value,
				_grBossCostTime = __cs2lua_nil_field_value,
				_grBossCostDiamond = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubBossReadyPageUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubBossReadyPageUI.__define_class();
