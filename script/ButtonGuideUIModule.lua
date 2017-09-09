require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "GuideUIModule";
require "EightGame__Logic__ButtonCommand";
require "LogicStatic";
require "Eight__Framework__Help__EITimer";
require "NGUITools";
require "NGUIMath";
require "GameUtility";
require "UIWidget";
require "UIButton";
require "UIEventListener";
require "UIEventTrigger";
require "UIDragScrollView";
require "EventDelegate";
require "GuideUtil";

ButtonGuideUIModule = {
	__new_object = function(...)
		return newobject(ButtonGuideUIModule, nil, nil, ...);
	end,
	__define_class = function()
		local static = ButtonGuideUIModule;

		local static_methods = {
			GetWorldScale = function(transform)
				local worldScale; worldScale = transform.localScale;
				local parent; parent = transform.parent;
				while invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", parent, nil) do
					worldScale = UnityEngine.Vector3.Scale(worldScale, parent.localScale);
					parent = parent.parent;
				end;
				return worldScale;
			end,
			cctor = function()
				GuideUIModule.cctor(this);
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
			OnInit = function(this, command_)
				if (not ( typeis(command_, EightGame.Logic.ButtonCommand, false) )) then
				end;
--按钮的命令//
				local button; button = typeas(command_, EightGame.Logic.ButtonCommand, false);
--button.Chapter;
				local trigger_data; trigger_data = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_userguide_trigger), (function(x) return (x.chapter == button.Chapter); end));
				if (trigger_data == nil) then
				end;
--取得这个路径//
				this._buttonPath = trigger_data.path;
				this._scenePath = trigger_data.scenepath;
				this._manualSendMessage = false;
--检查参数//
				if System.String.IsNullOrEmpty(this._buttonPath) then
				end;
			end,
			Update = function(this)
				if (not this.showArrow) then
					if (Eight.Framework.Help.EITimer.DeltaTime(this.showArrowTime) > 0.20) then
						this.showArrow = true;
						this.arrowWidget.enabled = true;
					end;
				end;
				if ((invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._originTargetObject, nil) and invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._copyTargetObject, nil)) and (this._originTargetObject.name == this._copyTargetObject.name)) then
					this:AdjustPosition(this._originTargetObject, this._copyTargetObject, this.showArrow);
				end;
			end,
			AdjustPosition = function(this, targetObject, go, ShowArrow)
--父对象的层//
				local _parentCamera; _parentCamera = NGUITools.FindCameraForLayer(this.parent.layer);
--原始对象的层//
				local _originCamera; _originCamera = NGUITools.FindCameraForLayer(targetObject.layer);
				local screenPoint; screenPoint = _originCamera:WorldToScreenPoint(targetObject.transform.position);
				local worldPoint; worldPoint = _parentCamera:ScreenToWorldPoint(screenPoint);
				go.transform.position = worldPoint;
				go.transform.localScale = UnityEngine.Vector3.one;
				local lp; lp = go.transform.localPosition;
				lp.z = 0.00;
				go.transform.localPosition = lp;
				if ShowArrow then
--arrowWidget
					this.arrowWidget.cachedTransform.position = go.transform.position;
					local b; b = NGUIMath.CalculateRelativeWidgetBounds__UnityEngine_Transform(go.transform);
--把它切换到下面//
					lp = this.arrowWidget.cachedTransform.localPosition;
--原始的y//
					local originY; originY = lp.y;
--尝试用上边//
					lp.y = (lp.y + (b.extents.y + invokeintegeroperator(0, "/", this.arrowWidget.height, 2, System.Int32, System.Int32)));
					this.arrowWidget.cachedTransform.localPosition = lp;
					if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this.arrowWidget.panel, nil) then
						if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this.arrowWidget.panel.parentPanel, nil) then
							this.arrowWidget.panel:ParentHasChanged();
						end;
						local globalUIPanel; globalUIPanel = this.arrowWidget.panel;
						if (GameUtility.IsWidgetInsideContainer(globalUIPanel, this.arrowWidget) ~= 1) then
							lp.y = ((originY - b.extents.y) - invokeintegeroperator(0, "/", this.arrowWidget.height, 2, System.Int32, System.Int32));
							this.arrowWidget.cachedTransform.localPosition = lp;
							this.arrowWidget.flip = 2;
						else
							this.arrowWidget.flip = 0;
						end;
					end;
				end;
			end,
			OnPrepare = function(this)
				this._originTargetObject = nil;
				this._copyTargetObject = nil;
--为null 就创建//
				while invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._originTargetObject, nil) do
					this:CheckButton();
					wrapyield(0, false, false);
				end;
			end),
			CheckButton = function(this)
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._originTargetObject, nil) and invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._copyTargetObject, nil)) then
--如果已经创建, 就去检查是否改变//
					local curTotalID; curTotalID = this:GetTotalInstanceID(this._originTargetObject);
					if (curTotalID ~= this._lastTotalID) then
						this:CloneButton(this._originTargetObject);
						this:UpdateTotalInstanceID();
					end;
				else
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._originTargetObject, nil) then
--试图获取原始对象//
						this._originTargetObject = UnityEngine.GameObject.Find(this._buttonPath);
--如果找到了, 就设置Button参数并拷贝//
						if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._originTargetObject, nil) then
							this:CloneButton(this._originTargetObject);
							this:UpdateTotalInstanceID();
						end;
					end;
				end;
			end,
			UpdateTotalInstanceID = function(this)
				this._lastTotalID = this:GetTotalInstanceID(this._originTargetObject);
			end,
			GetTotalInstanceID = function(this, go)
				local totalID; totalID = 0;
				local trans; trans = go.transform;
				if go.activeSelf then
					totalID = trans:GetInstanceID();
					local i; i = 0;
					local imax; imax = trans.childCount;
					while (i < imax) do
					repeat
						local child; child = trans:GetChild(i);
						if (not child.gameObject.activeSelf) then
							break;
						end;
						totalID = invokeintegeroperator(2, "+", totalID, child:GetInstanceID(), System.Int32, System.Int32);
					until true;
					i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
					end;
				end;
				return totalID;
			end,
			CloneButton = function(this, go)
--删除操作//
				this:DestroyChildren(this.parent.transform);
				this._copyTargetObject = GameUtility.InstantiateGameObject(this._originTargetObject, this.parent, this._originTargetObject.name, this._originTargetObject.transform.position, nil, nil);
				local widget; widget = this._copyTargetObject:GetComponent(UIWidget);
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", widget, nil) and widget.isAnchored) then
					widget:SetAnchor__UnityEngine_Transform(nil);
				end;
				this.showArrow = false;
				this.showArrowTime = Eight.Framework.Help.EITimer.GetTime();
				this.arrowWidget.enabled = false;
				local originBtnComp; originBtnComp = go:GetComponent(UIButton);
				local originListener; originListener = go:GetComponent(UIEventListener);
				local originEventTrigger; originEventTrigger = go:GetComponent(UIEventTrigger);
--禁用列表的拖动.
				local dragHandler; dragHandler = go:GetComponent(UIDragScrollView);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", dragHandler, nil) then
					dragHandler.enabled = false;
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", originBtnComp, nil) then
					local newBtn; newBtn = this._copyTargetObject:GetComponent(UIButton);
--保存onclick//
					this._buttonClick = originBtnComp.onClick;
--点击//
					EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(newBtn.onClick, (function() local __compiler_delegation_258 = (function() this:OnButtonClick(); end); setdelegationkey(__compiler_delegation_258, "ButtonGuideUIModule:OnButtonClick", this, this.OnButtonClick); return __compiler_delegation_258; end)());
				elseif invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", originListener, nil) then
					local newListener; newListener = this._copyTargetObject:GetComponent(UIEventListener);
--保存listener//
					this._listener = originListener;
--点击//
					delegationset(false, false, "UIEventListener:onClick", newListener, nil, "onClick", (function() local __compiler_delegation_268 = (function(_) this:OnListenerClick(_); end); setdelegationkey(__compiler_delegation_268, "ButtonGuideUIModule:OnListenerClick", this, this.OnListenerClick); return __compiler_delegation_268; end)());
				elseif invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", originEventTrigger, nil) then
					local newEventTrigger; newEventTrigger = this._copyTargetObject:GetComponent(UIEventTrigger);
					this._eventTrigger = originEventTrigger;
					EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(newEventTrigger.onClick, (function() local __compiler_delegation_276 = (function() this:OnEventTriggerClick(); end); setdelegationkey(__compiler_delegation_276, "ButtonGuideUIModule:OnEventTriggerClick", this, this.OnEventTriggerClick); return __compiler_delegation_276; end)());
				else
					local newListener; newListener = this._copyTargetObject:AddComponent(UIEventListener);
					NGUITools.AddWidgetCollider__UnityEngine_GameObject(this._copyTargetObject);
--保存listener//
					this._listener = nil;
					this._manualSendMessage = true;
--点击//
					delegationset(false, false, "UIEventListener:onClick", newListener, nil, "onClick", (function() local __compiler_delegation_290 = (function(_) this:OnListenerClick(_); end); setdelegationkey(__compiler_delegation_290, "ButtonGuideUIModule:OnListenerClick", this, this.OnListenerClick); return __compiler_delegation_290; end)());
				end;
--这里直接取得路径//
				this._targetPath = GuideUtil.GetPath__UnityEngine_GameObject(go);
			end,
			OnExecute = function(this)
				while (not this._finished) do
					this:CheckButton();
					wrapyield(newexternobject(UnityEngine.WaitForSeconds, "UnityEngine.WaitForSeconds", "ctor", nil, 2.00), false, true);
				end;
			end),
			OnButtonClick = function(this)
				EventDelegate.Execute__System_Collections_Generic_List_EventDelegate(this._buttonClick);
				this._buttonClick = nil;
				this:_Finish();
			end,
			OnListenerClick = function(this, _)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._listener, nil) then
					if delegationcomparewithnil(false, false, "UIEventListener:onClick", this._listener, nil, "onClick", false) then
						this._listener.onClick(_);
					end;
					this._listener = nil;
				elseif this._manualSendMessage then
					if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._originTargetObject, nil) then
						this._originTargetObject:SendMessage("OnClick", nil, 1);
					end;
					this._manualSendMessage = false;
				end;
				this:_Finish();
			end,
			OnEventTriggerClick = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._eventTrigger, nil) then
					if (this._eventTrigger.onClick ~= nil) then
						EventDelegate.Execute__System_Collections_Generic_List_EventDelegate(this._eventTrigger.onClick);
					end;
					this._eventTrigger = nil;
				end;
				this:_Finish();
			end,
			DestroyChildren = function(this, trans)
				local children; children = newexternlist(System.Collections.Generic.List_UnityEngine.GameObject, "System.Collections.Generic.List_UnityEngine.GameObject", "ctor", {});
				for child in getiterator(trans) do
					children:Add(child.gameObject);
				end;
				trans:DetachChildren();
				children:ForEach((function(child) return UnityEngine.Object.Destroy(child); end));
			end,
			_Finish = function(this)
				this._finished = true;
--删除操作//
				this:DestroyChildren(this.parent.transform);
--触发next step//
--		if(IsTarget)
--		{
--			GuideManager.Instance.NextStep(_buttonPath);
--		}
--完成操作//
				this:FinishCommand();
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				parent = __cs2lua_nil_field_value,
				arrowWidget = __cs2lua_nil_field_value,
				_buttonPath = __cs2lua_nil_field_value,
				_scenePath = __cs2lua_nil_field_value,
				_listener = __cs2lua_nil_field_value,
				_buttonClick = __cs2lua_nil_field_value,
				_eventTrigger = __cs2lua_nil_field_value,
				_finished = false,
				_targetPath = __cs2lua_nil_field_value,
				_lastTotalID = 0,
				_originTargetObject = __cs2lua_nil_field_value,
				_copyTargetObject = __cs2lua_nil_field_value,
				_manualSendMessage = false,
				showArrowTime = 0.00,
				showArrow = false,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(GuideUIModule, "ButtonGuideUIModule", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ButtonGuideUIModule.__define_class();
