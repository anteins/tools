require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "LogicStatic";
require "NGUITools";
require "SingleRankUI";

ClubBossRankPageUI = {
	__new_object = function(...)
		return newobject(ClubBossRankPageUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubBossRankPageUI;

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
				this:CreataDicObjs();
				delegationadd(false, false, "UIRecycledList:onUpdateItem", this.BrRecyced, nil, "onUpdateItem", (function() local __compiler_delegation_28 = (function(item, itemIndex, dataIndex) this:OnUpdateItem(item, itemIndex, dataIndex); end); setdelegationkey(__compiler_delegation_28, "ClubBossRankPageUI:OnUpdateItem", this, this.OnUpdateItem); return __compiler_delegation_28; end)());
			end,
			OnEnter = function(this, data)
				this.curData = typecast(data, System.Collections.Generic.List_EightGame.Data.Server.bossRankdata, false);
				this.BrRecyced.ScrollView:ResetPosition();
				this.BrRecyced:UpdateDataCount(this.curData.Count, true);
				this.CurNullTipLab.gameObject:SetActive((this.curData.Count == 0));
				this:SetMyData(this.curData.Count);
			end,
			SetMyData = function(this, count)
				local pid; pid = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil).id;
				local _mydata; _mydata = this.curData:Find((function(x) return (x.id == pid); end));
				this.MyRankUI:MySelfFreshData(_mydata);
--		MyRankUI.gameObject.SetActive (count>0);
			end,
			CreataDicObjs = function(this)
				if (this.dataDic.Count == 0) then
					local i; i = 0;
					while (i < 8) do
						local obj; obj = NGUITools.AddChild__UnityEngine_GameObject__UnityEngine_GameObject(NGUITools, this.BrRecyced.gameObject, this.MyRankUI.gameObject);
						local com; com = obj:GetComponent(SingleRankUI);
						com:Init();
						obj.name = System.String.Format("ranks_{0}", i);
						obj:SetActive(true);
						this.dataDic:Add(obj, com);
					i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
					end;
				end;
			end,
			OnUpdateItem = function(this, item, itemIndex, dataIndex)
				local _Rui; _Rui = nil;
				if (function() local __compiler_invoke_68; __compiler_invoke_68, _Rui = this.dataDic:TryGetValue(item); return __compiler_invoke_68; end)() then
--			EIDebuger.Log(" OnUpdateItem   itemIndex : " +itemIndex  + " , dataIndex : " +dataIndex);
					if ((this.dataDic.Count > 0) and (dataIndex < this.curData.Count)) then
						local _rdata; _rdata = getexterninstanceindexer(this.curData, nil, "get_Item", dataIndex);
						_Rui = item:GetComponent(SingleRankUI);
						_Rui:FreshData__EightGame_Data_Server_bossRankdata(_rdata);
					end;
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				MyRankUI = __cs2lua_nil_field_value,
				BrRecyced = __cs2lua_nil_field_value,
				FreshTipLab = __cs2lua_nil_field_value,
				ComfirmBt = __cs2lua_nil_field_value,
				CurNullTipLab = __cs2lua_nil_field_value,
				curData = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.bossRankdata, "System.Collections.Generic.List_EightGame.Data.Server.bossRankdata", "ctor", {}),
				dataDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_SingleRankUI, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_SingleRankUI", "ctor", {}),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubBossRankPageUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubBossRankPageUI.__define_class();
