require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EventDelegate";
require "LogicStatic";
require "ClubApplyerListDialogNode";
require "SingleClubApplyerUI";
require "NGUITools";

ClubApplyerListPageUI = {
	__new_object = function(...)
		return newobject(ClubApplyerListPageUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubApplyerListPageUI;

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
				this:InitObjs();
				delegationadd(false, false, "UIRecycledList:onUpdateItem", this.BrRecyced, nil, "onUpdateItem", (function() local __compiler_delegation_19 = (function(item, itemIndex, dataIndex) this:OnUpdata(item, itemIndex, dataIndex); end); setdelegationkey(__compiler_delegation_19, "ClubApplyerListPageUI:OnUpdata", this, this.OnUpdata); return __compiler_delegation_19; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.CloseBt.onClick, (function() local __compiler_delegation_20 = (function() this:OnClose(); end); setdelegationkey(__compiler_delegation_20, "ClubApplyerListPageUI:OnClose", this, this.OnClose); return __compiler_delegation_20; end)());
			end,
			OnEnter = function(this, e)
				this.ApplyerList = LogicStatic.GetList(typeof(EightGame.Data.Server.ApplyerDataNotify), nil);
				if (this.ApplyerList == nil) then
					this.ApplyerList = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.ApplyerDataNotify, "System.Collections.Generic.List_EightGame.Data.Server.ApplyerDataNotify", "ctor", {});
				end;
				this.BrRecyced.ScrollView:ResetPosition();
				this.BrRecyced:UpdateDataCount(this.ApplyerList.Count, true);
			end,
			OnClose = function(this)
				ClubApplyerListDialogNode.Close();
			end,
			OnUpdata = function(this, item, itemIndex, dataIndex)
				local _Sui; _Sui = nil;
				if (function() local __compiler_invoke_40; __compiler_invoke_40, _Sui = this.dataDic:TryGetValue(item); return __compiler_invoke_40; end)() then
					if ((this.ApplyerList.Count > 0) and (dataIndex < this.ApplyerList.Count)) then
						_Sui = item:GetComponent(SingleClubApplyerUI);
						_Sui:SetUp(getexterninstanceindexer(this.ApplyerList, nil, "get_Item", dataIndex));
					end;
				end;
			end,
			InitObjs = function(this)
				if (this.dataDic.Count == 0) then
					local i; i = 0;
					while (i < 7) do
						local obj; obj = NGUITools.AddChild__UnityEngine_GameObject__UnityEngine_GameObject(NGUITools, this.BrRecyced.gameObject, this.SingleSample);
						local com; com = obj:GetComponent(SingleClubApplyerUI);
						obj.name = System.String.Format("c_appler_{0}", i);
						obj:SetActive(true);
						com:Init();
						this.dataDic:Add(obj, com);
					i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
					end;
				end;
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				SingleSample = __cs2lua_nil_field_value,
				BrRecyced = __cs2lua_nil_field_value,
				CloseBt = __cs2lua_nil_field_value,
				ApplyerList = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.ApplyerDataNotify, "System.Collections.Generic.List_EightGame.Data.Server.ApplyerDataNotify", "ctor", {}),
				dataDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_SingleClubApplyerUI, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_SingleClubApplyerUI", "ctor", {}),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ClubApplyerListPageUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubApplyerListPageUI.__define_class();
