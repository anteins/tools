require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EightGame__Logic__BaseSubHeaderEvent";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ClubBossReadyPageUI";
require "Eight__Framework__EIBoolEvent";
require "EightGame__Logic__SubHeaderNode";
require "LogicStatic";

ClubBossReadyWindowNode = {
	__new_object = function(...)
		return newobject(ClubBossReadyWindowNode, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ClubBossReadyWindowNode;

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
				local go; go = GameUtility.InstantiateGameObject(tempPrefab, nil, "ClubBossReadyPageUI", nil, nil, nil);
				this._pagecom = go:GetComponent(ClubBossReadyPageUI);
				this:BindComponent__EIEntityBehaviour(this._pagecom);
				this._pagecom:Init();
				this._isReady = true;
			end),
			OnEnter = function(this, data)
				this:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, EightGame.Logic.SubHeaderNode.OPEN_SUBHEADER_BG, true));
				this:SetSubHeaderTitle("冒险团讨伐任务");
				this:SetSubHeaderCloseBtnActive(false);
				local _bossData; _bossData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.CrusadeBoss), nil);
				if (_bossData ~= nil) then
					this._pagecom:OnEnter(_bossData);
				end;
				wrapyield(this.base:OnEnter(data), false, false);
			end),
			OnExit = function(this)
				this._pagecom:OnExit();
				return this.base:OnExit();
			end,
			Dispose = function(this)
				this._pagecom = nil;
				return this.base:Dispose();
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_prefabPath = "ClubUI/ClubPageUI/ClubBossPanel",
				_pagecom = __cs2lua_nil_field_value,
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


		return defineclass(EightGame.Logic.BaseSubHeaderEvent, "ClubBossReadyWindowNode", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubBossReadyWindowNode.__define_class();
