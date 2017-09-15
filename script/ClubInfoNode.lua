require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EightGame__Logic__BaseSubHeaderEvent";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ClubInfoPageUI";
require "Eight__Framework__EIBoolEvent";
require "EightGame__Logic__SubHeaderNode";
require "LobbyUINode";
require "ClubUtility";
require "EightGame__Logic__UIView";
require "EightGame__Logic__MainWorldNode";
require "Eight__Framework__EIStringEvent";

ClubInfoNode = {
	__new_object = function(...)
		return newobject(ClubInfoNode, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ClubInfoNode;

		local static_methods = {
			cctor = function()
				EightGame.Logic.BaseSubHeaderEvent.cctor(this);
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
			ctor = function(this)
				this.base.ctor(this);
				this._isReady = false;
				this:StartCoroutine(this:CreateView());
				return this;
			end,
			CreateView = function(this)
				local c; c = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(("GameAssets/Prefabs/UI/" + this._prefabPath), "prefab", false);
				wrapyield(c.coroutine, false, true);
				local tempPrefab; tempPrefab = typeas(c.res, UnityEngine.GameObject, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", tempPrefab, nil) then
					Eight.Framework.EIDebuger.LogError("load ui_teamlistui error ");
					return nil;
				end;
				local go; go = GameUtility.InstantiateGameObject(tempPrefab, nil, "ClubInfoPageUI", nil, nil, nil);
				this._clubInfoPageUI = go:GetComponent(ClubInfoPageUI);
				this:BindComponent__EIEntityBehaviour(this._clubInfoPageUI);
--注册事件
				this:AddEventListener("CHANGE_SHOW_CLUB_MEMBERS", (function() local __compiler_delegation_35 = (function(e) this:ChangeCloseLabShow(e); end); setdelegationkey(__compiler_delegation_35, "ClubInfoNode:ChangeCloseLabShow", this, this.ChangeCloseLabShow); return __compiler_delegation_35; end)());
				this:AddEventListener("FRESH_CLUB_MEMBERS", (function() local __compiler_delegation_36 = (function(e) this._clubInfoPageUI:OnAddFresh(e); end); setdelegationkey(__compiler_delegation_36, "ClubInfoPageUI:OnAddFresh", this._clubInfoPageUI, this._clubInfoPageUI.OnAddFresh); return __compiler_delegation_36; end)());
				this:AddEventListener("FRESH_CLUB_INFO", (function() local __compiler_delegation_37 = (function(e) this._clubInfoPageUI:SetInfoData(e); end); setdelegationkey(__compiler_delegation_37, "ClubInfoPageUI:SetInfoData", this._clubInfoPageUI, this._clubInfoPageUI.SetInfoData); return __compiler_delegation_37; end)());
				this:AddEventListener("SELF_EXIT_CLUB_FRESH", (function() local __compiler_delegation_38 = (function(e) this:OnSelfExit(e); end); setdelegationkey(__compiler_delegation_38, "ClubInfoNode:OnSelfExit", this, this.OnSelfExit); return __compiler_delegation_38; end)());
				this._clubInfoPageUI:Init((function(isActive)
					this:SetSubHeaderCloseBtnActive(isActive);
				end));
				this._isReady = true;
			end),
			OnEnter = function(this, data)
				this:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, EightGame.Logic.SubHeaderNode.OPEN_SUBHEADER_BG, true));
				this:SetSubHeaderTitle("冒险团信息");
--	SetSubHeaderCloseBtnActive (true);
				this:SetSubHeaderPopViewWhenClose(false);
				this:SetSubHeaderCloseBtnLbl("筛选: 综合");
				this:SetSubHeaderCloseEvent((function() local __compiler_delegation_55 = (function() this._clubInfoPageUI:OnChangeSort(); end); setdelegationkey(__compiler_delegation_55, "ClubInfoPageUI:OnChangeSort", this._clubInfoPageUI, this._clubInfoPageUI.OnChangeSort); return __compiler_delegation_55; end)());
				this._clubInfoPageUI:OnEnter(1);
				wrapyield(this.base:OnEnter(data), false, false);
			end),
			OnSelfExit = function(this, e)
--清楚公共模块的监听（活动）
--		ClubUtility.RemoveInitListener ();
--清楚公共模块的监听（活动）
--		ClubUtility.RemoveInitListener ();
				local lobby; lobby = ( typeas(this.ViewParent.parent, LobbyUINode, false) );
				if (lobby ~= nil) then
					Eight.Framework.EIFrameWork.StartCoroutine(ClubUtility.WaitDoloading(), false);
					local newInfo; newInfo = newobject(EightGame.Logic.UIView.UIViewInfo, "ctor", nil);
					newInfo.viewType = EightGame.Logic.MainWorldNode;
					newInfo.param = nil;
					local list; list = newexternlist(System.Collections.Generic.List_EightGame.Logic.UIView.UIViewInfo, "System.Collections.Generic.List_EightGame.Logic.UIView.UIViewInfo", "ctor", {});
					list:Add(newInfo);
					lobby:ForceRestStack(list);
					lobby:Push(EightGame.Logic.MainWorldNode, nil);
					ClubUtility.IsInClubPage = false;
				end;
--ViewParent.Push (typeof(MainWorldNode));
			end,
			ChangeCloseLabShow = function(this, e)
				local es; es = typeas(e, Eight.Framework.EIStringEvent, false);
				this:SetSubHeaderCloseBtnLbl(es.stringParam);
			end,
			OnExit = function(this)
				this._clubInfoPageUI:Exit(nil, true, 0.00);
				return this.base:OnExit();
			end,
			Dispose = function(this)
				this._clubInfoPageUI = nil;
				return this.base:Dispose();
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_prefabPath = "ClubUI/ClubPageUI/ClubInfoPanel",
				_clubInfoPageUI = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = {
			"System.Collections.IEnumerable",
		};

		local interface_map = {
			IEnumerable_GetEnumerator = "EINode_GetEnumerator",
		};


		return defineclass(EightGame.Logic.BaseSubHeaderEvent, "ClubInfoNode", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubInfoNode.__define_class();
