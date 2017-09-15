require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EightGame__Logic__BaseSubHeaderEvent";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ClubNewTipsUIWindow";
require "ClubJoinNode";
require "LobbyUINode";
require "EightGame__Logic__UIView";
require "ClubHouseNode";
require "ClubUtility";
require "Eight__Framework__EIBoolEvent";
require "EightGame__Logic__SubHeaderNode";

ClubCreateNode = {
	__new_object = function(...)
		return newobject(ClubCreateNode, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ClubCreateNode;

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
					Eight.Framework.EIDebuger.LogError("load CreateTipsPanel error ");
					return nil;
				end;
				local go; go = GameUtility.InstantiateGameObject(tempPrefab, nil, "ClubNewTipsUIWindow", nil, nil, nil);
				this._clubNewTipsBehaviour = go:GetComponent(ClubNewTipsUIWindow);
				this:BindComponent__EIEntityBehaviour(this._clubNewTipsBehaviour);
				this:AddEventListener("OUT_CLUB_CREAT", (function() local __compiler_delegation_35 = (function(e) this:OnExitCreate(e); end); setdelegationkey(__compiler_delegation_35, "ClubCreateNode:OnExitCreate", this, this.OnExitCreate); return __compiler_delegation_35; end)());
				this:AddEventListener("GO_CLUB_SENCE", (function() local __compiler_delegation_36 = (function(e) this:GoClubSence(e); end); setdelegationkey(__compiler_delegation_36, "ClubCreateNode:GoClubSence", this, this.GoClubSence); return __compiler_delegation_36; end)());
				this:AddEventListener("GO_CLUB_APPLY_PAGE", (function() local __compiler_delegation_37 = (function(e) this:GoJoinList(e); end); setdelegationkey(__compiler_delegation_37, "ClubCreateNode:GoJoinList", this, this.GoJoinList); return __compiler_delegation_37; end)());
--注册事件
--
				this._clubNewTipsBehaviour:Init();
				this._isReady = true;
			end),
			GoJoinList = function(this, e)
				this.ViewParent:Push(ClubJoinNode, nil);
			end,
			GoClubSence = function(this, e)
				local lobby; lobby = ( typeas(this.ViewParent.parent, LobbyUINode, false) );
				if (lobby ~= nil) then
					local newInfo; newInfo = newobject(EightGame.Logic.UIView.UIViewInfo, "ctor", nil);
					newInfo.viewType = ClubHouseNode;
					newInfo.param = nil;
					local list; list = newexternlist(System.Collections.Generic.List_EightGame.Logic.UIView.UIViewInfo, "System.Collections.Generic.List_EightGame.Logic.UIView.UIViewInfo", "ctor", {});
					list:Add(newInfo);
					lobby:ForceRestStack(list);
					lobby:Push(ClubHouseNode, nil);
					ClubUtility.IsOut = false;
					ClubUtility.HaveMask = false;
					Eight.Framework.EIFrameWork.StartCoroutine(ClubUtility.WaitDoloading(), false);
				end;
			end,
			OnExitCreate = function(this, e)
				this._clubNewTipsBehaviour:ReturnTipsPage();
			end,
			OnEnter = function(this, data)
				this:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, EightGame.Logic.SubHeaderNode.OPEN_SUBHEADER_BG, true));
				this:SetSubHeaderTitle("创建冒险团");
				this._clubNewTipsBehaviour:OnEnter();
				wrapyield(this.base:OnEnter(data), false, false);
			end),
			OnExit = function(this)
--		ShowOrHideSubHeader (false);
				this._clubNewTipsBehaviour:Exit(nil, true, 0.00);
				return this.base:OnExit();
			end,
			Dispose = function(this)
				this._clubNewTipsBehaviour = nil;
				return this.base:Dispose();
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_prefabPath = "ClubUI/ClubPageUI/CreateTipsPanel",
				_clubNewTipsBehaviour = __cs2lua_nil_field_value,
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


		return defineclass(EightGame.Logic.BaseSubHeaderEvent, "ClubCreateNode", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubCreateNode.__define_class();
