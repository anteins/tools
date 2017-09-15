--uiview
require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EightGame__Logic__UIViewNode";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ClubHouseController";
require "ClubMainWindow";
require "RedTipManager";
require "EightGame__Component__NetworkUtils";
require "LogicStatic";
require "ClubUtility";
require "Eight__Framework__EIBoolEvent";
require "AdMapUti";
require "AdMapDialogNode";
require "Eight__Framework__EIEvent";
require "AlarmManager";
require "SubTypeAndParam";
require "CommonMainPartyNode";
require "EightGame__Logic__SubHeaderNode";
require "MainUserPartyNode";
require "Eight__Framework__EIIntEvent";
require "EightGame__Logic__MainTopBaseButton";
require "ShareDetailNode";
require "EightGame__Logic__VipPrivilegNode";
require "SingleNpc";
require "ClubInfoNode";
require "ClubShopNode";
require "ClubPartyNode";
require "EightGame__Logic__SigninEnterNode";
require "AssignmentsWindowNode";
require "EightGame__Logic__TipStruct";
require "EightGame__Logic__TipsDialogParam";
require "LobbyUINode";
require "EightGame__Logic__UIView";
require "EightGame__Logic__MainWorldNode";
require "Eight__Framework__EIStringEvent";
require "UpstarCheckAvailable";
require "RankupCheckAvailable";
require "RecruitCheckAvailable";
require "FunctionOpenUtility";
require "EightGame__Logic__RechargeViewNode";
require "EightGame__Logic__ExploreViewNode";
require "LotteryCheckAvailable";
require "EventDelegate";
require "ChatMsgManager";
require "UIButton";
require "PlayerInfoDialogNode";
require "EmailWindowNode";
require "LabelChangeAni";
require "LotteryUtil";
require "EightGame__Component__NetworkClient";
require "PlayerTimerUpdateData";

ClubHouseNode = {
	__new_object = function(...)
		return newobject(ClubHouseNode, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ClubHouseNode;

		local static_methods = {
			get_ClubCamera = function()
				return ClubHouseNode._clubCamera;
			end,
			cctor = function()
				EightGame.Logic.UIViewNode.cctor(this);
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				_clubCamera = __cs2lua_nil_field_value,
				MAIN_UI_LABEL_ANI_CHANGE_PHYSICAL = "MAIN_UI_LABEL_ANI_CHANGE_PHYSICAL",
				MAIN_UI_LABEL_ANI_CHANGE_GOLD = "MAIN_UI_LABEL_ANI_CHANGE_GOLD",
				MAIN_UI_LABEL_ANI_CHANGE_DIAMOND = "MAIN_UI_LABEL_ANI_CHANGE_DIAMOND",
			};
			return static_fields;
		end;

		local static_props = {
			ClubCamera = {
				get = static_methods.get_ClubCamera,
			},
		};

		local static_events = nil;

		local instance_methods = {
			ctor = function(this)
				this.base.ctor__System_String(this, "ClubSenceView");
				this._isReady = false;
				this:StartCoroutine(this:CreateView());
				return this;
			end,
			CreateView = function(this)
				local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(System.String.Format("{0}{1}", "BaseAssets/Prefabs/Scenes/", this._3dprefabPath), "prefab", false);
				wrapyield(coroutine.coroutine, false, true);
				local prefab; prefab = typeas(coroutine.res, UnityEngine.GameObject, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", prefab, nil) then
					Eight.Framework.EIDebuger.Log(System.String.Format(" load { 0 } error , please check", this._3dprefabPath));
					return nil;
				end;
				local go; go = GameUtility.InstantiateGameObject(prefab, nil, "ClubSence", nil, nil, nil);
				this._viewController = go:GetComponent(ClubHouseController);
				this._viewController:Init();
				ClubHouseNode._clubCamera = this._viewController.ClubCamera;
				local uicoroutine; uicoroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(System.String.Format("{0}{1}", "GameAssets/Prefabs/UI/", this._uiprefabPath), "prefab", false);
				wrapyield(uicoroutine.coroutine, false, true);
				local uiprefab; uiprefab = typeas(uicoroutine.res, UnityEngine.GameObject, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", uiprefab, nil) then
					Eight.Framework.EIDebuger.Log(System.String.Format(" load { 0 } error , please check", this._uiprefabPath));
					return nil;
				end;
				local uigo; uigo = GameUtility.InstantiateGameObject(uiprefab, nil, "ClubMainPanel", nil, nil, nil);
				this._clubMainWindow = uigo:GetComponent(ClubMainWindow);
				this._clubMainWindow:Init();
				this:BindComponent__EIEntityBehaviour(this._clubMainWindow);
--更新一下公会各个红点的状态.
				local redTipMgr; redTipMgr = Eight.Framework.EIFrameWork.GetComponent(RedTipManager);
				if (redTipMgr ~= nil) then
					redTipMgr:UpdateGuildInfoFlags();
				end;
				this:InitFunciton();
				this._isReady = true;
			end),
			InitFunciton = function(this)
				this:AddEventListener("GO_NPC_PAGE", (function() local __compiler_delegation_80 = (function(e) this:GoEnterOtherPage(e); end); setdelegationkey(__compiler_delegation_80, "ClubHouseNode:GoEnterOtherPage", this, this.GoEnterOtherPage); return __compiler_delegation_80; end)());
				this:AddEventListener("SET_CLUB_FIRST_TIP_OVER", (function() local __compiler_delegation_82 = (function(e) this._clubMainWindow:CloseFirstTip(e); end); setdelegationkey(__compiler_delegation_82, "ClubMainWindow:CloseFirstTip", this._clubMainWindow, this._clubMainWindow.CloseFirstTip); return __compiler_delegation_82; end)());
				this:AddEventListener("CHECKOUT_CLUB_MAINMSG", (function() local __compiler_delegation_84 = (function(e) this._clubMainWindow.BoxPageUI:OnRemove(e); end); setdelegationkey(__compiler_delegation_84, "ClubMainMsgBoxPageUI:OnRemove", this._clubMainWindow.BoxPageUI, this._clubMainWindow.BoxPageUI.OnRemove); return __compiler_delegation_84; end)());
				this:AddEventListener("ADD_CLUB_MAIN_MSG", (function() local __compiler_delegation_85 = (function(e) this._clubMainWindow.BoxPageUI:OnAddMsg(e); end); setdelegationkey(__compiler_delegation_85, "ClubMainMsgBoxPageUI:OnAddMsg", this._clubMainWindow.BoxPageUI, this._clubMainWindow.BoxPageUI.OnAddMsg); return __compiler_delegation_85; end)());
				this:AddEventListener("SET_CLUB_CAMERA", (function() local __compiler_delegation_86 = (function(e) this:SetClubCamera(e); end); setdelegationkey(__compiler_delegation_86, "ClubHouseNode:SetClubCamera", this, this.SetClubCamera); return __compiler_delegation_86; end)());
--设置更新数据
				this:AddEventListener(EightGame.Component.NetworkUtils.GetSerDataUpdateEventType(typeof(EightGame.Data.Server.GuildProsperity)), (function() local __compiler_delegation_89 = (function(e) this:check_prosperity_guild_play(e); end); setdelegationkey(__compiler_delegation_89, "ClubHouseNode:check_prosperity_guild_play", this, this.check_prosperity_guild_play); return __compiler_delegation_89; end)());
				this:AddEventListener(EightGame.Component.NetworkUtils.GetSerDataUpdateEventType(typeof(EightGame.Data.Server.ClubDataNotify)), (function() local __compiler_delegation_90 = (function(e) this:check_info_data(e); end); setdelegationkey(__compiler_delegation_90, "ClubHouseNode:check_info_data", this, this.check_info_data); return __compiler_delegation_90; end)());
				this:AddEventListener(EightGame.Component.NetworkUtils.GetSerDataUpdateEventType(typeof(EightGame.Data.Server.BussinessNpc)), (function() local __compiler_delegation_91 = (function(e) this:check_shop_data(e); end); setdelegationkey(__compiler_delegation_91, "ClubHouseNode:check_shop_data", this, this.check_shop_data); return __compiler_delegation_91; end)());
				this:AddEventListener(EightGame.Component.NetworkUtils.GetSerDataUpdateEventType(typeof(EightGame.Data.Server.PostInitMeditationRoom)), (function() local __compiler_delegation_92 = (function(e) this:check_meditationroom_data(e); end); setdelegationkey(__compiler_delegation_92, "ClubHouseNode:check_meditationroom_data", this, this.check_meditationroom_data); return __compiler_delegation_92; end)());
				this:AddEventListener(EightGame.Component.NetworkUtils.GetSerDataUpdateEventType(typeof(EightGame.Data.Server.GuildNum)), (function() local __compiler_delegation_93 = (function(e) this:chekc_guild_num_play(e); end); setdelegationkey(__compiler_delegation_93, "ClubHouseNode:chekc_guild_num_play", this, this.chekc_guild_num_play); return __compiler_delegation_93; end)());
				this:AddEventListener(EightGame.Component.NetworkUtils.GetSerDataUpdateEventType(typeof(EightGame.Data.Server.CrusadeBoss)), (function() local __compiler_delegation_94 = (function(e) this:check_boss_guild_play(e); end); setdelegationkey(__compiler_delegation_94, "ClubHouseNode:check_boss_guild_play", this, this.check_boss_guild_play); return __compiler_delegation_94; end)());
--		this.AddEventListener( NetworkUtils.GetSerDataUpdateEventType( typeof( ClubDataNotify )), CheckOutOfClub);
				this:AddEventListener("SET_OFF_SINGIN_TIPS", (function() local __compiler_delegation_97 = (function(e) this:SetOffSinginTip(e); end); setdelegationkey(__compiler_delegation_97, "ClubHouseNode:SetOffSinginTip", this, this.SetOffSinginTip); return __compiler_delegation_97; end)());
				this:AddEventListener("CLUB_GET_FOOD", (function() local __compiler_delegation_99 = (function(e) this:OnCallGetFoodMsg(e); end); setdelegationkey(__compiler_delegation_99, "ClubHouseNode:OnCallGetFoodMsg", this, this.OnCallGetFoodMsg); return __compiler_delegation_99; end)());
			end,
			CheckOutOfClub = function(this, e)
				local nowData; nowData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildInfoDataUpdate), nil);
				if (nowData == nil) then
					ClubUtility.HaveMask = true;
					ClubUtility.IsOut = true;
				end;
			end,
			SetClubCamera = function(this, e)
				local isActive; isActive = ( typeas(e, Eight.Framework.EIBoolEvent, false) ).boolParam;
				ClubUtility.HaveMask = isActive;
--		_viewController.isHaveMask = isActive;
--		if (!isActive)
--		{
--			_clubCamera = null;
--		} else {
--			_clubCamera = _viewController.ClubCamera;		
--		}
			end,
			OnNodeCompleteReady = function(this)
--			EIDebuger.Log("OnNodeCompleteReady ",Color.red);
				if AdMapUti.CheckAdMapShow() then
					AdMapDialogNode.Open();
					AdMapUti._hadShowToday = true;
				end;
				this.base:OnNodeCompleteReady();
			end,
			check_meditationroom_data = function(this, e)
				local hisData; hisData = LogicStatic.History.Get__System_Predicate_T(typeof(EightGame.Data.Server.PostInitMeditationRoom), nil);
				local nowData; nowData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PostInitMeditationRoom), nil);
				if ((((hisData == nil) or (hisData.level == nil)) or (nowData == nil)) or (nowData.level == nil)) then
					return ;
				end;
				if ((nowData.level > hisData.level) and (nowData.level > this._viewController.MRoomLv)) then
					this._viewController.MRoomLv = nowData.level;
					this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_MEDITATION_GUILD_PLAY, System.Object, false), 0.00));
				end;
			end,
			check_shop_data = function(this, e)
				local hisData; hisData = LogicStatic.History.Get__System_Predicate_T(typeof(EightGame.Data.Server.BussinessNpc), nil);
				local nowData; nowData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.BussinessNpc), nil);
				if ((((hisData == nil) or (hisData.level == nil)) or (nowData == nil)) or (nowData.level == nil)) then
					return ;
				end;
				if ((nowData.level > hisData.level) and (nowData.level > this._viewController.ShoLv)) then
					this._viewController.ShoLv = nowData.level;
					this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_SHOP_GUILD_PLAY, System.Object, false), 0.00));
				end;
			end,
			check_info_data = function(this, e)
				local hisData; hisData = LogicStatic.History.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil);
				local nowData; nowData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil);
				if (nowData == nil) then
					ClubUtility.IsOut = true;
				end;
				if ((hisData == nil) or (nowData == nil)) then
					return ;
				end;
				if ((((hisData.clubLv ~= nil) and (nowData.clubLv ~= nil)) and (nowData.clubLv > hisData.clubLv)) and (nowData.clubLv > this._viewController.InfoLv)) then
					this._viewController.InfoLv = nowData.clubLv;
					this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_LV_GUILD_PLAY, System.Object, false), 0.00));
				end;
--如果没有旧数据
--如果旧数据满足而新数据不满足
				if (( ((hisData.money ~= nil) and (hisData.money >= ClubUtility.GetAllDailyMoney(hisData.clubLv))) ) and (nowData.money < ClubUtility.GetAllDailyMoney(nowData.clubLv))) then
					this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_MONEY_GUILD_PLAY, System.Object, false), 0.00));
				end;
			end,
			check_prosperity_guild_play = function(this, e)
				local hisData; hisData = LogicStatic.History.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildProsperity), nil);
				local nowData; nowData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildProsperity), nil);
				if (nowData == nil) then
					return ;
				end;
				if (hisData == nil) then
					if (nowData.todaypros < 0) then
						this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_PROSPERITY_GUILD_PLAY, System.Object, false), 0.00));
					end;
				else
					if (((hisData.prosperity ~= nil) and (nowData.prosperity ~= nil)) and (nowData.lv > hisData.lv)) then
						this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_LV_PROSPERITY_GUILD_PLAY, System.Object, false), 0.00));
					end;
				end;
--因为起始就是负数，往正数增长
			end,
			chekc_guild_num_play = function(this, e)
				local hisData; hisData = LogicStatic.History.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildNum), nil);
				local nowData; nowData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildNum), nil);
				if ((hisData == nil) and (nowData ~= nil)) then
					local clv; clv = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil).clubLv;
					if (nowData.ore > 0) then
						local guildprodution; guildprodution = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_guild_production), (function(x) return ((x.guildlv == clv) and (x.battletype == se_battletype.SE_BATTLETYPE_GUILD_STONE)); end));
						if (invokeintegeroperator(3, "-", guildprodution.innum, nowData.wood, System.Int32, System.Int32) > 0) then
							this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_STONE_GUILD_PLAY, System.Object, false), 0.00));
						end;
					end;
					if (nowData.wood > 0) then
						local guildprodution; guildprodution = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_guild_production), (function(x) return ((x.guildlv == clv) and (x.battletype == se_battletype.SE_BATTLETYPE_GUILD_WOOD)); end));
						if (invokeintegeroperator(3, "-", guildprodution.innum, nowData.wood, System.Int32, System.Int32) > 0) then
							this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_WOOD_GUILD_PLAY, System.Object, false), 0.00));
						end;
					end;
				end;
			end,
			check_boss_guild_play = function(this, e)
				local hisData; hisData = LogicStatic.History.Get__System_Predicate_T(typeof(EightGame.Data.Server.CrusadeBoss), nil);
				local nowData; nowData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.CrusadeBoss), nil);
--没有旧数据
--旧数据先不做判断
				if ((hisData == nil) and (nowData ~= nil)) then
					local _nowtime; _nowtime = AlarmManager.Instance:currentTimeMillis();
					if (((nowData.opentime <= _nowtime) and (_nowtime <= nowData.closetime)) and (nowData.bosshp > 0)) then
						this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "ADD_CLUB_MAIN_MSG", nil, typecast(se_playtipstype.SE_PLAYTIPSTYPE_BOSS_GUILD_PLAY, System.Object, false), 0.00));
					end;
				end;
			end,
			GoPartyPartyPage = function(this, e)
				if ClubUtility.HaveMask then
					return ;
				end;
				local paid; paid = typecast(e.extraInfo, System.Int64, false);
				local param; param = newobject(SubTypeAndParam, "ctor", nil);
				param._needOpenNode = CommonMainPartyNode;
				param._paramObj = typecast(paid, System.Object, false);
				this.ViewParent:Push(EightGame.Logic.SubHeaderNode, param);
			end,
			GoUserPartyPartyPage = function(this, e)
				if ClubUtility.HaveMask then
					return ;
				end;
				local paid; paid = typecast(e.extraInfo, System.Int32, false);
				local param; param = newobject(SubTypeAndParam, "ctor", nil);
				param._needOpenNode = MainUserPartyNode;
				param._paramObj = typecast(paid, System.Object, false);
--		LobbyUINode lobby = (ViewParent as LobbyUINode);
--		if( lobby != null )
--		{
--			lobby.Push(typeof(SubHeaderNode), param);
--		}
				this.ViewParent:Push(EightGame.Logic.SubHeaderNode, param);
			end,
			OnEnterDetailPage = function(this, e)
				local id; id = 0;
				local _parm; _parm = newobject(SubTypeAndParam, "ctor", nil);
				_parm._needOpenNode = CommonMainPartyNode;
				_parm._paramObj = typecast(id, System.Object, false);
				this.ViewParent:Push(EightGame.Logic.SubHeaderNode, _parm);
--yield return StartCoroutine(_PushView(typeof(SubHeaderNode), typeof(LotteryUINode)));
			end,
			TopUIGoOtherPage = function(this, e)
				if ClubUtility.HaveMask then
					return ;
				end;
				local _otherid; _otherid = ( typeas(e, Eight.Framework.EIIntEvent, false) ).intParam;
				local __compiler_switch_324 = typecast(_otherid, EightGame.Logic.MainTopBaseButton.SpecialPartyType, true);
				if __compiler_switch_324 == 1 then
					this.ViewParent:Push(EightGame.Logic.SubHeaderNode, ShareDetailNode);
				elseif __compiler_switch_324 == 2 then
					local _pa; _pa = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PartyActiveSerData), (function(x) return (x.detailtype == 9); end));
					if (_pa == nil) then
						return ;
					end;
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "MAIN_GO_PARTYPAGE", nil, _pa.id, 0.00));
				elseif __compiler_switch_324 == 4 then
					this.ViewParent:Push(EightGame.Logic.SubHeaderNode, EightGame.Logic.VipPrivilegNode);
				elseif __compiler_switch_324 == 5 then
					ClubUtility.HaveMask = false;
				else
					Eight.Framework.EIDebuger.Log(("TopUIGoOtherPage :  _otherid " + _otherid));
				end;
			end,
			InitNpcsUI = function(this, e)
				if ((this._clubMainWindow.NpcsUI ~= nil) and (this._clubMainWindow.NpcsUI.Count > 0)) then
					return ;
				end;
				local npcs; npcs = this._viewController.STNpcs;
				npcs:Add(this._viewController.ClubHeader);
				npcs:Add(this._viewController.ClubBestTeamer);
				this._clubMainWindow:InitNpcsUI(npcs);
			end,
			GoEnterOtherPage = function(this, e)
				if this.isGolock then
					return ;
				end;
				if ClubUtility.HaveMask then
					return ;
				end;
				if ClubUtility.IsOut then
					this:OnCheckData();
					return ;
				end;
				local type; type = typecast(e.extraInfo, System.Int32, false);
				local pagetype; pagetype = typecast(type, SingleNpc.ClubPageType, true);
				local strtip; strtip = System.String.Empty;
				this.isGolock = true;
--缺少 加入检测限制提示
				if (pagetype == 1) then
					this:STNpcShowCall(pagetype, (function()
						this.ViewParent:Push(EightGame.Logic.SubHeaderNode, ClubInfoNode);
					end));
				elseif (pagetype == 2) then
--			strtip = "NPC尚未开启";
--			ViewParent.Push(typeof(ClubInfoNode));
					this.isGolock = false;
				elseif (pagetype == 3) then
					this:STNpcShowCall(pagetype, (function()
						this.ViewParent:Push(EightGame.Logic.SubHeaderNode, ClubShopNode);
					end));
				elseif (pagetype == 4) then
--			strtip = "NPC尚未开启";
--			ViewParent.Push(typeof(ClubInfoNode));
					this.isGolock = false;
				elseif (pagetype == 81) then
--			strtip = "NPC尚未开启";
					this:STNpcShowCall(pagetype, (function()
						this.ViewParent:Push(EightGame.Logic.SubHeaderNode, ClubPartyNode);
					end));
				elseif (pagetype == 82) then
--			ViewParent.Push(typeof(SubHeaderNode),typeof(ClubMeditationRoomsNode));
					this._clubMainWindow:OnGoMroomFuntion();
					this.isGolock = false;
				elseif (pagetype == 101) then
					this.ViewParent:Push(EightGame.Logic.SubHeaderNode, EightGame.Logic.SigninEnterNode);
				elseif (pagetype == 102) then
					this.ViewParent:Push(EightGame.Logic.SubHeaderNode, AssignmentsWindowNode);
				end;
				if (not System.String.IsNullOrEmpty(strtip)) then
					local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, strtip, 0.20);
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
				end;
			end,
			STNpcShowCall = function(this, type, _call)
				local _npc; _npc = this._viewController.STNpcs:Find((function(x) return (x.Data.PageType == type); end));
				local _temp; _temp = nil;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", _npc, nil) then
					_temp = _npc.myAnimator;
				end;
				this:StartCoroutine(this:ShowAnimatorCall(typecast(type, System.Int32, false), _temp, _call));
			end,
			ShowAnimatorCall = function(this, type, myAnimator, _call)
				this._viewController.ClubCamera:GetComponent(typeof(UnityEngine.Animator)):SetInteger("npcpage", type);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", myAnimator, nil) then
					myAnimator:SetBool("idleshow", true);
				end;
				wrapyield(newexternobject(UnityEngine.WaitForSeconds, "UnityEngine.WaitForSeconds", "ctor", nil, 1.00), false, true);
--		while(!myAnimator.GetCurrentAnimatorStateInfo(0).IsName("idle") )
--		{
--			yield return null;
--		}
				_call();
				return nil;
			end),
			OnCheckData = function(this)
				if ClubUtility.IsOut then
					ClubUtility.HaveMask = true;
					local tipsDialogParam; tipsDialogParam = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__System_String__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "ClubKickTips", "退团提示", "您已被踢出冒险团", "确认", (function()
						local lobby; lobby = ( typeas(this.ViewParent, LobbyUINode, false) );
						if (lobby ~= nil) then
							ClubUtility.IsInClubPage = false;
							Eight.Framework.EIFrameWork.StartCoroutine(ClubUtility.WaitDoloading(), false);
							local newInfo; newInfo = newobject(EightGame.Logic.UIView.UIViewInfo, "ctor", nil);
							newInfo.viewType = EightGame.Logic.MainWorldNode;
							newInfo.param = nil;
							local list; list = newexternlist(System.Collections.Generic.List_EightGame.Logic.UIView.UIViewInfo, "System.Collections.Generic.List_EightGame.Logic.UIView.UIViewInfo", "ctor", {});
							list:Add(newInfo);
							lobby:ForceRestStack(list);
							lobby:Push(EightGame.Logic.MainWorldNode, nil);
						end;
						return true;
					end), 5, 0);
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, tipsDialogParam, 0.00));
				end;
			end,
			OnEnter = function(this, data)
				this:OnCheckData();
				this:OnEnterRegister();
				this._viewController:OnEnter();
				this._clubMainWindow:OnEnter();
				this:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, "SET_BRANCH_BUTTONS_ACTIVE", false));
				this:InitNpcsUI(nil);
--播放主界面音乐  -- 要改
				local nowHour; nowHour = System.DateTime.Now.Hour;
				local musicStr; musicStr = "";
				if ((8 < nowHour) and (nowHour < 20)) then
					musicStr = "music_home_day";
				else
					musicStr = "music_home_night";
				end;
				this:DispatchEvent(newobject(Eight.Framework.EIStringEvent, "ctor__System_String__System_String", nil, "AUDIO_PLAY_MUSIC", musicStr));
--更新提示小红点的状态.
				UpstarCheckAvailable.UpdateAvailableUpstarFighter();
				RankupCheckAvailable.UpdateAvailableRankupAbility();
				RecruitCheckAvailable.UpdateAvailableRecruitRole();
				this:UpdateTeamTipsSprite();
				this:UpdatePartnerTipsSprite();
				this:UpdateLotteryTipsSprite();
--_worldBehaviour._partyUIBehaviour.CheckPartyTips ();
--检查主界面的功能锁
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._clubMainWindow.HeaderUICom, nil) then
					this._clubMainWindow.HeaderUICom:SetDataInfo((function() local __compiler_delegation_524 = (function() this:CallbackClickRecharge(); end); setdelegationkey(__compiler_delegation_524, "ClubHouseNode:CallbackClickRecharge", this, this.CallbackClickRecharge); return __compiler_delegation_524; end)(), (function() local __compiler_delegation_524 = (function() this:OnExploreBtn(); end); setdelegationkey(__compiler_delegation_524, "ClubHouseNode:OnExploreBtn", this, this.OnExploreBtn); return __compiler_delegation_524; end)());
					this._clubMainWindow.HeaderUICom:SetInviteGridActive(true);
				end;
				this._viewController.gameObject:SetActive(true);
				this._clubMainWindow.gameObject:SetActive(true);
				this:CheckWelcomTip();
				ClubUtility.IsInClubPage = true;
				wrapyield(this.base:OnEnter(data), false, false);
			end),
			CheckWelcomTip = function(this)
				ClubUtility.IsInClub = false;
				if (ClubUtility.IsInClub and (LogicStatic.GetList(typeof(EightGame.Data.Server.MemberDataNotify), nil).Count > 2)) then
					local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, System.String.Format("欢迎加入[ff643a]{0}[-]冒险团", ClubUtility.GetClubName()), 0.50);
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
				end;
			end,
			CallbackClickRecharge = function(this)
				if FunctionOpenUtility.JudgeSingleFunctionById(se_functiontype.SE_FUNCTIONTYPE_PAY_MODULE , true) then
					this.ViewParent:Push(EightGame.Logic.SubHeaderNode, EightGame.Logic.RechargeViewNode);
				end;
			end,
			OnExploreBtn = function(this)
				if (not FunctionOpenUtility.JudgeSingleFunctionById(se_functiontype.SE_FUNCTIONTYPE_EXPLORE_MODULE, true)) then
					return ;
				end;
				this.ViewParent:Push(EightGame.Logic.SubHeaderNode, EightGame.Logic.ExploreViewNode);
			end,
			UpdateTeamTipsSprite = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._clubMainWindow.HeaderUICom, nil) then
					return ;
				end;
--把所有条件判断包装到回调里，逐个判断，提升性能.
				local funList; funList = newexternlist(System.Collections.Generic.List_System.Func_System.Boolean, "System.Collections.Generic.List_System.Func_System.Boolean", "ctor", {});
				funList:Add((function()
					return (RankupCheckAvailable.GetDic().Count > 0);
				end));
--是否有任意可激活或升级的能力.
				funList:Add((function()
					return UpstarCheckAvailable.ContainsUpstar();
				end));
--是否有任意可升星的角色.
				funList:Add((function()
					return LotteryCheckAvailable.IsHaveAvailable();
				end));
--是否任意可提示的抽奖项目.
				funList:Add((function()
					return RecruitCheckAvailable.ContainsRecruit();
				end));
--是否有可招募的角色.
--逐个判断.
				local flag; flag = false;
				for act in getiterator(funList) do
					if act() then
						flag = true;
						break;
					end;
				end;
--_worldBehaviour.TeamTipsSprite.gameObject.SetActive(flag);
			end,
			UpdatePartnerTipsSprite = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._clubMainWindow.HeaderUICom, nil) then
					return ;
				end;
				local funList; funList = newexternlist(System.Collections.Generic.List_System.Func_System.Boolean, "System.Collections.Generic.List_System.Func_System.Boolean", "ctor", {});
				funList:Add((function()
					return (RankupCheckAvailable.GetDic().Count > 0);
				end));
--是否有任意可激活或升级的能力.
				funList:Add((function()
					return UpstarCheckAvailable.ContainsUpstar();
				end));
--是否有任意可升星的角色.
				funList:Add((function()
					return RecruitCheckAvailable.ContainsRecruit();
				end));
--是否有可招募的角色.
				local flag; flag = false;
				for act in getiterator(funList) do
					if act() then
						flag = true;
						break;
					end;
				end;
--_worldBehaviour.PartnerTipsSprite.gameObject.SetActive(flag);
			end,
			UpdateLotteryTipsSprite = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._clubMainWindow.HeaderUICom, nil) then
					return ;
				end;
				local flagList; flagList = newexternlist(System.Collections.Generic.List_System.Boolean, "System.Collections.Generic.List_System.Boolean", "ctor", {});
				flagList:Add(LotteryCheckAvailable.IsHaveAvailable());
--是否有任意可提示的抽奖项目.
--_worldBehaviour.LotteryTipsSprite.gameObject.SetActive(flagList.Contains(true));
			end,
			OnEnterRegister = function(this)
				this:UpdateUI(true);
				this:AddEventListener(EightGame.Logic.RechargeViewNode.Open_Recharge_View, (function() local __compiler_delegation_625 = (function(e) this:OpenRechargeView(e); end); setdelegationkey(__compiler_delegation_625, "ClubHouseNode:OpenRechargeView", this, this.OpenRechargeView); return __compiler_delegation_625; end)());
--监听玩家数据更新事件
				this:AddEventListener(EightGame.Component.NetworkUtils.GetSerDataUpdateEventType(typeof(EightGame.Data.Server.PlayerSerData)), (function() local __compiler_delegation_627 = (function(response) this:OnPlayerDataUpdate(response); end); setdelegationkey(__compiler_delegation_627, "ClubHouseNode:OnPlayerDataUpdate", this, this.OnPlayerDataUpdate); return __compiler_delegation_627; end)());
				this:AddEventListener(EightGame.Component.NetworkUtils.GetSerDataUpdateEventType(typeof(EightGame.Data.Server.LotterySerData)), (function() local __compiler_delegation_628 = (function(response) this:OnLotteryDataUpdate(response); end); setdelegationkey(__compiler_delegation_628, "ClubHouseNode:OnLotteryDataUpdate", this, this.OnLotteryDataUpdate); return __compiler_delegation_628; end)());
				this:AddEventListener("UI_XMB_INVITE_GRID", (function() local __compiler_delegation_629 = (function(e) this:OnUpdateXMBInvitePanel(e); end); setdelegationkey(__compiler_delegation_629, "ClubHouseNode:OnUpdateXMBInvitePanel", this, this.OnUpdateXMBInvitePanel); return __compiler_delegation_629; end)());
				this:AddEventListener("UI_HEARTBEAT_MESSAGE", (function() local __compiler_delegation_630 = (function(e) this:OnUpdateHeartbeat(e); end); setdelegationkey(__compiler_delegation_630, "ClubHouseNode:OnUpdateHeartbeat", this, this.OnUpdateHeartbeat); return __compiler_delegation_630; end)());
--关闭表情表情
				this:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, "UI_EXPRESSION_ENABLE", false));
--顶部，点击监听
				this._clubMainWindow.HeaderUICom._baseMode.clickBG.onClick:Clear();
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this._clubMainWindow.HeaderUICom._baseMode.clickBG.onClick, (function() local __compiler_delegation_637 = (function() this:OnClickHeader(); end); setdelegationkey(__compiler_delegation_637, "ClubHouseNode:OnClickHeader", this, this.OnClickHeader); return __compiler_delegation_637; end)());
				--活动方法
				this:AddEventListener("GET_DETAIL_OVER", (function() local __compiler_delegation_641 = (function(e) GameUtility.OverDetailCast(e); end); setdelegationkey(__compiler_delegation_641, "GameUtility:OverDetailCast", GameUtility, GameUtility.OverDetailCast); return __compiler_delegation_641; end)());
				this:AddEventListener("ENTER_DETAILPAGE", (function() local __compiler_delegation_642 = (function(e) this:OnEnterDetailPage(e); end); setdelegationkey(__compiler_delegation_642, "ClubHouseNode:OnEnterDetailPage", this, this.OnEnterDetailPage); return __compiler_delegation_642; end)());
				this:AddEventListener("ENTER_OTHER_PAGE", (function() local __compiler_delegation_643 = (function(e) this:TopUIGoOtherPage(e); end); setdelegationkey(__compiler_delegation_643, "ClubHouseNode:TopUIGoOtherPage", this, this.TopUIGoOtherPage); return __compiler_delegation_643; end)());
				this:AddEventListener("FRESH_MAIN_TOP", (function() local __compiler_delegation_644 = (function(e) this._clubMainWindow.HeaderUICom._mainTopContr:WhenEnterFresh(e); end); setdelegationkey(__compiler_delegation_644, "MianTopUIController:WhenEnterFresh", this._clubMainWindow.HeaderUICom._mainTopContr, this._clubMainWindow.HeaderUICom._mainTopContr.WhenEnterFresh); return __compiler_delegation_644; end)());
				this:AddEventListener("FRESH_MAINPAGE_PARTY", (function() local __compiler_delegation_645 = (function(e) this._clubMainWindow.HeaderUICom._mainTopContr:OnMainPartyFresh(e); end); setdelegationkey(__compiler_delegation_645, "MianTopUIController:OnMainPartyFresh", this._clubMainWindow.HeaderUICom._mainTopContr, this._clubMainWindow.HeaderUICom._mainTopContr.OnMainPartyFresh); return __compiler_delegation_645; end)());
				this:AddEventListener("OVER_MAINPAGE_PARTY", (function() local __compiler_delegation_646 = (function(e) this._clubMainWindow.HeaderUICom._mainTopContr:OnMainPartyOver(e); end); setdelegationkey(__compiler_delegation_646, "MianTopUIController:OnMainPartyOver", this._clubMainWindow.HeaderUICom._mainTopContr, this._clubMainWindow.HeaderUICom._mainTopContr.OnMainPartyOver); return __compiler_delegation_646; end)());
				this:AddEventListener("MAIN_GO_PARTYPAGE", (function() local __compiler_delegation_647 = (function(e) this:GoPartyPartyPage(e); end); setdelegationkey(__compiler_delegation_647, "ClubHouseNode:GoPartyPartyPage", this, this.GoPartyPartyPage); return __compiler_delegation_647; end)());
				this:AddEventListener("MAIN_GO_USER_PARTYPAGE", (function() local __compiler_delegation_648 = (function(e) this:GoUserPartyPartyPage(e); end); setdelegationkey(__compiler_delegation_648, "ClubHouseNode:GoUserPartyPartyPage", this, this.GoUserPartyPartyPage); return __compiler_delegation_648; end)());
--进入主界面，打开聊天
				ChatMsgManager.Instance:OpenChat();
--邮件
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._clubMainWindow.HeaderUICom._emailCom, nil) then
					local emaiBt; emaiBt = this._clubMainWindow.HeaderUICom._emailCom.transform:GetComponent(UIButton);
					EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(emaiBt.onClick, (function() local __compiler_delegation_658 = (function() this:OnEmailButton(); end); setdelegationkey(__compiler_delegation_658, "ClubHouseNode:OnEmailButton", this, this.OnEmailButton); return __compiler_delegation_658; end)());
				end;
			end,
			SetOffSinginTip = function(this, e)
				this._clubMainWindow.SignTipObj:SetActive(false);
			end,
			OnClickHeader = function(this)
				PlayerInfoDialogNode.Open();
			end,
			OnEmailButton = function(this)
				this.ViewParent:Push(EightGame.Logic.SubHeaderNode, EmailWindowNode);
			end,
			RemoverRegister = function(this)
				LabelChangeAni.StopToEnd(ClubHouseNode.MAIN_UI_LABEL_ANI_CHANGE_PHYSICAL);
				LabelChangeAni.StopToEnd(ClubHouseNode.MAIN_UI_LABEL_ANI_CHANGE_GOLD);
				LabelChangeAni.StopToEnd(ClubHouseNode.MAIN_UI_LABEL_ANI_CHANGE_DIAMOND);
				this:RemoveEventListener("GET_DETAIL_OVER");
				this:RemoveEventListener("UI_UPDATE_PLAYER_INFO");
				this:RemoveEventListener(EightGame.Logic.RechargeViewNode.Open_Recharge_View);
				this:RemoveEventListener("UI_XMB_INVITE_GRID");
				this:RemoveEventListener("UI_HEARTBEAT_MESSAGE");
				this:SetBaseSceneActive(false);
				this._clubMainWindow.HeaderUICom:OnExit();
				ChatMsgManager.Instance:CloseChat();
			end,
			SetBaseSceneActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._viewController, nil) then
					this:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, "ChangeTtileActive", b));
					this._viewController.gameObject:SetActive(b);
				end;
			end,
			OpenRechargeView = function(this, e)
				if FunctionOpenUtility.JudgeSingleFunctionById(se_functiontype.SE_FUNCTIONTYPE_PAY_MODULE , true) then
					this.ViewParent:Push(EightGame.Logic.SubHeaderNode, EightGame.Logic.RechargeViewNode);
				end;
			end,
			OnLotteryDataUpdate = function(this, response)
				local lotteryList; lotteryList = LogicStatic.GetList(typeof(EightGame.Data.Server.LotterySerData), nil);
				if (lotteryList == nil) then
					return ;
				end;
				local autoActive; autoActive = delegationwrap((function()
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._clubMainWindow.HeaderUICom, nil) then
						return ;
					end;
--_worldBehaviour.LotteryTipsSprite.gameObject.SetActive(true);
--_worldBehaviour.TeamTipsSprite.gameObject.SetActive(true);
				end));
				local updateActive; updateActive = delegationwrap((function(start, cur, __compiler_lua_end)
					local span; span = System.TimeSpan.FromMilliseconds(invokeintegeroperator(3, "-", __compiler_lua_end, cur, System.Int64, System.Int64));
					Eight.Framework.EIDebuger.LogWarning(System.String.Format("gold:{0}:{1}:{2}", span.Hours, span.Minutes, span.Seconds));
				end));
				local i; i = 0;
				while (i < lotteryList.Count) do
					local dy; dy = getexterninstanceindexer(lotteryList, nil, "get_Item", i);
					local sd; sd = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_conscribe), dy.luckid);
					local countdown; countdown = LotteryUtil.GetCountDown(dy.destunixtime);
					local isHaveFree; isHaveFree = sd.free;
					local isDailyReset; isDailyReset = (isHaveFree and (sd.max > -1));
					local isHaveFreeChance; isHaveFreeChance = (isHaveFree and ( ((dy == nil) or (dy.todayfreecount < sd.max)) ));
					local isCD; isCD = (isHaveFree and ( ((dy == nil) or (countdown <= 0)) ));
					if (( ((isHaveFree and isDailyReset) and isHaveFreeChance) ) or ( (isHaveFree and (not isDailyReset)) )) then
						local alarmName; alarmName = System.String.Format("LOTTERY_TIPS_COUNTDOWN_LUCKID_{0}", dy.luckid);
						if (countdown > 0) then
							AlarmManager.Instance:set(alarmName, invokeintegeroperator(2, "+", AlarmManager.Instance:currentTimeMillis(), invokeintegeroperator(4, "*", countdown, 1000, System.Int32, System.Int32), System.Int64, System.Int64), nil, autoActive);
						else
							AlarmManager.Instance:cancel(alarmName);
						end;
					end;
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
			end,
			OnPlayerDataUpdate = function(this, response)
				this:UpdateUI(false);
			end,
			UpdateUI = function(this, isInit)
				local player; player = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.NetworkClient):GetDataByCls__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
				if (player == nil) then
					return ;
				end;
--刷新UI.
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._clubMainWindow.HeaderUICom, nil) or invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._clubMainWindow.HeaderUICom._baseMode, nil)) then
					return ;
				end;
				if (player.vipLv ~= nil) then
					this._clubMainWindow.HeaderUICom._baseMode.vipLbl.text = System.String.Format("会员{0}", player.vipLv);
				end;
				if (player.level ~= nil) then
					this._clubMainWindow.HeaderUICom._baseMode.levelLbl.text = System.String.Format("Lv{0}", player.level);
				end;
				if (player.name ~= nil) then
					this._clubMainWindow.HeaderUICom._baseMode.nameLbl.text = System.Text.Encoding.UTF8:GetString(player.name);
				end;
--yearLbl.text = ;
--monthLbl.text = ;
--dayLbl.text = ;
				if ((player.physical ~= nil) and (player.level ~= nil)) then
					local maxPhysical; maxPhysical = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_player_info), player.level).food;
					if isInit then
						this._clubMainWindow.HeaderUICom._baseMode.apLbl.text = System.String.Format("{0}", player.physical);
					else
						LabelChangeAni.Play(ClubHouseNode.MAIN_UI_LABEL_ANI_CHANGE_PHYSICAL, this._clubMainWindow.HeaderUICom._baseMode.apLbl, player.physical, 0.60);
					end;
					this._clubMainWindow.HeaderUICom._baseMode.apMaxLbl.text = System.String.Format("{0}", maxPhysical);
				end;
				if isInit then
					if (player.gold ~= nil) then
						this._clubMainWindow.HeaderUICom._baseMode.goldLbl.text = invokeforbasicvalue(player.gold, false, System.Int32, "ToString");
					end;
					if (player.diamond ~= nil) then
						this._clubMainWindow.HeaderUICom._baseMode.diamondLbl.text = invokeforbasicvalue(player.diamond, false, System.Int32, "ToString");
					end;
				else
					LabelChangeAni.Play(ClubHouseNode.MAIN_UI_LABEL_ANI_CHANGE_GOLD, this._clubMainWindow.HeaderUICom._baseMode.goldLbl, player.gold, 0.60);
					LabelChangeAni.Play(ClubHouseNode.MAIN_UI_LABEL_ANI_CHANGE_DIAMOND, this._clubMainWindow.HeaderUICom._baseMode.diamondLbl, player.diamond, 0.60);
				end;
--到点刷新金币购买次数、体力购买次数.
				local recharge; recharge = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.RechargeSerData), nil);
				PlayerTimerUpdateData.UpdateBuyGoldTimes(recharge, this);
				PlayerTimerUpdateData.UpdateBuyPhysicalTimes(recharge, this);
			end,
			OnCallGetFoodMsg = function(this, e)
				local action; action = EightGame.Data.Server.ServerService.SignphysicalMethod();
				Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.NetworkClient):NetworkRequest(action, (function(returnCode, response)
					local res; res = typeas(response, EightGame.Data.Server.SignPhysicalResponse, false);
					if (returnCode < 1000) then
--弹出获得体力的提示.
						local temp; temp = newobject(EightGame.Logic.TipStruct, "ctor", nil, System.String.Format("获得 #ICON_PHYSICAL {0}  ", res.amount), 0.20);
						this:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, temp, 0.00));
					else
						local msg; msg = EightGame.Component.NetCode.GetDesc(returnCode);
						local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, msg, 0.20);
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
					end;
				end), true, false);
			end,
			OnUpdateXMBInvitePanel = function(this, e)
				local be; be = typeas(e, Eight.Framework.EIBoolEvent, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._clubMainWindow.HeaderUICom, nil) then
					this._clubMainWindow.HeaderUICom:SetInviteGridActive(be.boolParam);
				end;
			end,
			OnUpdateHeartbeat = function(this, e)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._clubMainWindow.HeaderUICom, nil) then
					local serdata; serdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GveRoomInviteSerData), nil);
					if (serdata ~= nil) then
						this._clubMainWindow.HeaderUICom:SetGveInviteBtnActive((serdata.teamcount > 0));
					end;
				end;
			end,
			get_hasNavigationOnEnter = function(this)
				return true;
			end,
			OnExit = function(this)
				this.isGolock = false;
				this:RemovePartyFunction();
				this._viewController.gameObject:SetActive(false);
				this._clubMainWindow.gameObject:SetActive(false);
				this:RemoverRegister();
				this:RemovePartyFunction();
				this._viewController:Exit(nil, true, 0.00);
				this._clubMainWindow:OnExit();
				return this.base:OnExit();
			end,
			Dispose = function(this)
				UnityEngine.Object.Destroy(this._viewController.gameObject);
				UnityEngine.Object.Destroy(this._clubMainWindow.gameObject);
				this._viewController = nil;
				this._clubMainWindow = nil;
				return this.base:Dispose();
			end,
			RemovePartyFunction = function(this)
				this:RemoveEventListener("ENTER_DETAILPAGE");
				this:RemoveEventListener("ENTER_OTHER_PAGE");
				this:RemoveEventListener("FRESH_MAIN_TOP");
				this:RemoveEventListener("FRESH_MAINPAGE_PARTY");
				this:RemoveEventListener("OVER_MAINPAGE_PARTY");
				this:RemoveEventListener("MAIN_GO_PARTYPAGE");
				this:RemoveEventListener("MAIN_GO_USER_PARTYPAGE");
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_3dprefabPath = "scene_guild_001/scene_guild_001",
				_uiprefabPath = "ClubUI/ClubMainPanel",
				_viewController = __cs2lua_nil_field_value,
				_clubMainWindow = __cs2lua_nil_field_value,
				isGolock = false,
			};
			return instance_fields;
		end;

		local instance_props = {
			hasNavigationOnEnter = {
				get = instance_methods.get_hasNavigationOnEnter,
			},
		};

		local instance_events = nil;
		local interfaces = {
			"System.Collections.IEnumerable",
		};

		local interface_map = {
			IEnumerable_GetEnumerator = "EINode_GetEnumerator",
		};


		return defineclass(EightGame.Logic.UIViewNode, "ClubHouseNode", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubHouseNode.__define_class();
