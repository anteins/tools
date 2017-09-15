require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EightGame__Logic__UIDialogNode";
require "EightGame__Logic__DialogUI";
require "Eight__Framework__EIFrameWork";
require "Eight__Framework__EIEvent";
require "EightGame__Component__GameResources";
require "NGUITools";
require "ClubApplyerListPageUI";

ClubApplyerListDialogNode = {
	__new_object = function(...)
		return newobject(ClubApplyerListDialogNode, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ClubApplyerListDialogNode;

		local static_methods = {
			Open = function()
				if (ClubApplyerListDialogNode._lastDialogID == -1) then
					EightGame.Logic.UIDialogNode.OpenIt(ClubApplyerListDialogNode, nil, (function() local __compiler_delegation_17 = (function(data) ClubApplyerListDialogNode._Private_OnOpen(data); end); setdelegationkey(__compiler_delegation_17, "ClubApplyerListDialogNode:_Private_OnOpen", ClubApplyerListDialogNode, ClubApplyerListDialogNode._Private_OnOpen); return __compiler_delegation_17; end)());
				end;
			end,
			Hide = function()
				if (ClubApplyerListDialogNode._lastDialogID ~= -1) then
					EightGame.Logic.UIDialogNode.HideIt(ClubApplyerListDialogNode, ClubApplyerListDialogNode._lastDialogID, (function() local __compiler_delegation_26 = (function(data) ClubApplyerListDialogNode._Private_OnHide(data); end); setdelegationkey(__compiler_delegation_26, "ClubApplyerListDialogNode:_Private_OnHide", ClubApplyerListDialogNode, ClubApplyerListDialogNode._Private_OnHide); return __compiler_delegation_26; end)());
				end;
			end,
			Close = function()
				if ((ClubApplyerListDialogNode._lastDialogID ~= -1) and (not EightGame.Logic.DialogUI.currentDialogUI.IsLock)) then
					EightGame.Logic.UIDialogNode.CloseIt(ClubApplyerListDialogNode, ClubApplyerListDialogNode._lastDialogID, (function() local __compiler_delegation_34 = (function(data) ClubApplyerListDialogNode._Private_OnClose(data); end); setdelegationkey(__compiler_delegation_34, "ClubApplyerListDialogNode:_Private_OnClose", ClubApplyerListDialogNode, ClubApplyerListDialogNode._Private_OnClose); return __compiler_delegation_34; end)());
					ClubApplyerListDialogNode._lastDialogID = -1;
				end;
--this.DispatchEvent( new EIEvent( BaseSceneCom.CameraTriggerToIdle ) );
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "CameraTriggerToIdle", nil, nil, 0.00));
			end,
			_Private_OnOpen = function(data)
				ClubApplyerListDialogNode._lastDialogID = typecast(data, System.Int32, false);
			end,
			_Private_OnHide = function(data)
			end,
			_Private_OnClose = function(data)
			end,
			cctor = function()
				EightGame.Logic.UIDialogNode.cctor(this);
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				_lastDialogID = -1,
				_uiPath = "ClubUI/ClubTipsUI/ClubApplyerListPage",
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			ctor = function(this)
				this.base.ctor(this);
				this._isReady = false;
				this:StartCoroutine(this:CreateAssets());
				return this;
			end,
			CreateAssets = function(this)
				local c; c = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(("GameAssets/Prefabs/UI/" + ClubApplyerListDialogNode._uiPath), "prefab", false);
				wrapyield(c.coroutine, false, true);
				local prefab; prefab = typeas(c.res, UnityEngine.GameObject, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", prefab, nil) then
					Eight.Framework.EIDebuger.LogError("[ClubApplyerListPageUI] load ClubTipsUI error");
					return nil;
				end;
				local obj; obj = NGUITools.AddChild__UnityEngine_GameObject__UnityEngine_GameObject(NGUITools, this.dialogParent.gameObject, prefab);
				this._applyerListCom = obj:GetComponent(ClubApplyerListPageUI);
				this._applyerListCom:Init();
				this:AddEventListener("FRESH_CLUB_APPLYER_PAGE", (function() local __compiler_delegation_88 = (function(e) this._applyerListCom:OnEnter(e); end); setdelegationkey(__compiler_delegation_88, "ClubApplyerListPageUI:OnEnter", this._applyerListCom, this._applyerListCom.OnEnter); return __compiler_delegation_88; end)());
--这里可以你自己的逻辑//
				this._isReady = true;
				return nil;
			end),
			OnEnter = function(this, data)
--在这里初始化你的gameobject脚本//
				this._applyerListCom:OnEnter(nil);
				return nil;
			end),
			OnExit = function(this)
				return nil;
			end),
			Dispose = function(this)
				ClubApplyerListDialogNode._lastDialogID = -1;
				UnityEngine.Object.Destroy(this._applyerListCom.gameObject);
				this._applyerListCom = nil;
				return this.base:Dispose();
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_applyerListCom = __cs2lua_nil_field_value,
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


		return defineclass(EightGame.Logic.UIDialogNode, "ClubApplyerListDialogNode", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubApplyerListDialogNode.__define_class();
