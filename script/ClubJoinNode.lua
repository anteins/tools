require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EightGame__Logic__BaseSubHeaderEvent";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ClubJoinPageUI";
require "Eight__Framework__EIBoolEvent";
require "EightGame__Logic__SubHeaderNode";

ClubJoinNode = {
	__new_object = function(...)
		return newobject(ClubJoinNode, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ClubJoinNode;

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
				local go; go = GameUtility.InstantiateGameObject(tempPrefab, nil, "ClubJoinPageUI", nil, nil, nil);
				this._clubJoinPageUI = go:GetComponent(ClubJoinPageUI);
				this:BindComponent__EIEntityBehaviour(this._clubJoinPageUI);
--注册事件
--
				this:AddEventListener("FRESH_CLUB_JOIN_PAGE", (function() local __compiler_delegation_35 = (function(e) this._clubJoinPageUI:OnFreshCall(e); end); setdelegationkey(__compiler_delegation_35, "ClubJoinPageUI:OnFreshCall", this._clubJoinPageUI, this._clubJoinPageUI.OnFreshCall); return __compiler_delegation_35; end)());
				this._clubJoinPageUI:Init();
				this._isReady = true;
			end),
			OnEnter = function(this, data)
				this:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, EightGame.Logic.SubHeaderNode.OPEN_SUBHEADER_BG, true));
				this:SetSubHeaderTitle("冒险团列表");
				this._clubJoinPageUI:OnEnter();
				wrapyield(this.base:OnEnter(data), false, false);
			end),
			OnExit = function(this)
				this._clubJoinPageUI:Exit(nil, true, 0.00);
				return this.base:OnExit();
			end,
			Dispose = function(this)
				this._clubJoinPageUI = nil;
				return this.base:Dispose();
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_prefabPath = "ClubUI/ClubPageUI/ClubJoinPanel",
				_clubJoinPageUI = __cs2lua_nil_field_value,
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


		return defineclass(EightGame.Logic.BaseSubHeaderEvent, "ClubJoinNode", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubJoinNode.__define_class();
