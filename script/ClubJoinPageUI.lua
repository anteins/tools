require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "EventDelegate";
require "LogicStatic";
require "GameUtility";
require "EightGame__Logic__TipStruct";
require "Eight__Framework__EIFrameWork";
require "Eight__Framework__EIEvent";
require "NGUITools";
require "SingleClubUI";
require "UITweener";
require "TweenPosition";

ClubJoinPageUI = {
	__new_object = function(...)
		return newobject(ClubJoinPageUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubJoinPageUI;

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
--		privateMaxCout = 5;
				this:InitRecyObjs();
				delegationadd(false, false, "UIRecycledList:onUpdateItem", this.BrRecyced, nil, "onUpdateItem", (function() local __compiler_delegation_31 = (function(item, itemIndex, dataIndex) this:OnUpdateItem(item, itemIndex, dataIndex); end); setdelegationkey(__compiler_delegation_31, "ClubJoinPageUI:OnUpdateItem", this, this.OnUpdateItem); return __compiler_delegation_31; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.SerchBt.onClick, (function() local __compiler_delegation_32 = (function() this:OnSerchClub(); end); setdelegationkey(__compiler_delegation_32, "ClubJoinPageUI:OnSerchClub", this, this.OnSerchClub); return __compiler_delegation_32; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.FreshBt.onClick, (function() local __compiler_delegation_33 = (function() this:OnFresh(); end); setdelegationkey(__compiler_delegation_33, "ClubJoinPageUI:OnFresh", this, this.OnFresh); return __compiler_delegation_33; end)());
			end,
			OnEnter = function(this)
				this.FreshBt.gameObject:SetActive(false);
				local pdata; pdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PostGuildlistData), nil);
				if (pdata ~= nil) then
					if (pdata.playeraddguildlist ~= nil) then
						this.clubids = pdata.playeraddguildlist;
					end;
					this:SortDataList(pdata);
				end;
			end,
			OnFreshCall = function(this, e)
				local pdata; pdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PostGuildlistData), nil);
				this.clubids = pdata.playeraddguildlist;
				Eight.Framework.EIDebuger.Log(("pdata.guildlist :" + pdata.guildlist));
				if (this.clubids.Count >= this.privateMaxCout) then
					this.BrRecyced:UpdateDataCount(pdata.guildlist.Count, true);
					this.BrRecyced.ScrollView:ResetPosition();
				end;
			end,
			OnFresh = function(this)
				this:OnEnter();
			end,
			OnSerchClub = function(this)
				local _inputStr; _inputStr = this.SerchInput.value;
				local _ishaswrong; _ishaswrong = GameUtility.IsHasWrongNumCode(_inputStr);
				GameUtility.ColorDebuger("yellow", (" _ischinese :" + _ishaswrong));
				if (_ishaswrong or System.String.IsNullOrEmpty(_inputStr)) then
					local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, "请输入正确的ID", 0.50);
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
					return ;
				end;
				local clubid; clubid = System.Convert.ToInt64(_inputStr);
				local _guildlist; _guildlist = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PostGuildlistData), nil);
				this.JoinList = _guildlist.guildlist:FindAll((function(x) return (x.id == clubid); end));
				if ((this.JoinList == nil) or (this.JoinList.Count == 0)) then
					this.BrRecyced.ScrollView:ResetPosition();
					this.BrRecyced:UpdateDataCount(0, true);
				end;
				this.FreshBt.gameObject:SetActive(true);
				this.BrRecyced.ScrollView:ResetPosition();
				this.BrRecyced:UpdateDataCount(this.JoinList.Count, true);
			end,
			SortDataList = function(this, pdata)
				if (pdata.guildlist == nil) then
					return ;
				end;
				this.JoinList = pdata.guildlist:FindAll((function(x) return (x.memberCount > 0); end));
				if (this.JoinList == nil) then
					this.JoinList = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.SimpleClubDataNotify, "System.Collections.Generic.List_EightGame.Data.Server.SimpleClubDataNotify", "ctor", {});
				end;
				if (this.JoinList.Count < 2) then
					this.BrRecyced:UpdateDataCount(this.JoinList.Count, true);
					this.BrRecyced.ScrollView:ResetPosition();
					return ;
				end;
--		JoinList.Sort ((x,y)=> -x.clubLv.CompareTo(y.clubLv));
				this.JoinList:Sort((function(x, y)
					if (invokeforbasicvalue(x.clubLv, false, System.Int32, "CompareTo", y.clubLv) == 0) then
						if (invokeforbasicvalue(x.clubPrestige, false, System.Int64, "CompareTo", y.clubPrestige) == 0) then
							return invokeintegeroperator(3, "-", nil, invokeforbasicvalue(x.id, false, System.Int64, "CompareTo", y.id), nil, System.Int32);
						else
							return invokeintegeroperator(3, "-", nil, invokeforbasicvalue(x.clubPrestige, false, System.Int64, "CompareTo", y.clubPrestige), nil, System.Int32);
						end;
					else
						return invokeintegeroperator(3, "-", nil, invokeforbasicvalue(x.clubLv, false, System.Int32, "CompareTo", y.clubLv), nil, System.Int32);
					end;
				end));
				this.BrRecyced.ScrollView:ResetPosition();
				this.BrRecyced:UpdateDataCount(this.JoinList.Count, true);
			end,
			InitRecyObjs = function(this)
				if (this.dataDic.Count == 0) then
					local i; i = 0;
					while (i < 7) do
						local obj; obj = NGUITools.AddChild__UnityEngine_GameObject__UnityEngine_GameObject(NGUITools, this.BrRecyced.gameObject, this.ClubSample);
						local com; com = obj:GetComponent(SingleClubUI);
						com:Init();
						obj.name = System.String.Format("clubs_{0}", i);
						obj:SetActive(true);
						this.dataDic:Add(obj, com);
					i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
					end;
				end;
			end,
			OnUpdateItem = function(this, item, itemIndex, dataIndex)
				local tweenposition; tweenposition = UITweener.Begin(TweenPosition, item, 0.20);
				tweenposition.from = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 600, item.transform.localPosition.y, 0);
				tweenposition.to = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 0, item.transform.localPosition.y, 0);
				tweenposition:PlayForward();
				local _Sui; _Sui = nil;
				if (function() local __compiler_invoke_160; __compiler_invoke_160, _Sui = this.dataDic:TryGetValue(item); return __compiler_invoke_160; end)() then
					if ((this.JoinList.Count > 0) and (dataIndex < this.JoinList.Count)) then
						_Sui = item:GetComponent(SingleClubUI);
						local _clubid; _clubid = getexterninstanceindexer(this.JoinList, nil, "get_Item", dataIndex).id;
						local IsApplyed; IsApplyed = this:IsInApplyList(_clubid);
						Eight.Framework.EIDebuger.Log(((("_clubid :  " + _clubid) + " , IsApplyed :") + IsApplyed));
						_Sui:SetUp(getexterninstanceindexer(this.JoinList, nil, "get_Item", dataIndex), IsApplyed);
					end;
				end;
			end,
			IsInApplyList = function(this, clubid)
--		List<long> clubids =  LogicStatic.Get<PostGuildlistData>().playeraddguildlist;
				local _inlist; _inlist = (this.clubids:Contains(clubid) or (this.clubids.Count >= this.privateMaxCout));
				return _inlist;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				SerchBt = __cs2lua_nil_field_value,
				FreshBt = __cs2lua_nil_field_value,
				SerchInput = __cs2lua_nil_field_value,
				BrRecyced = __cs2lua_nil_field_value,
				ClubSample = __cs2lua_nil_field_value,
				JoinList = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.SimpleClubDataNotify, "System.Collections.Generic.List_EightGame.Data.Server.SimpleClubDataNotify", "ctor", {}),
				dataDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_SingleClubUI, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_SingleClubUI", "ctor", {}),
				clubids = newexternlist(System.Collections.Generic.List_System.Int64, "System.Collections.Generic.List_System.Int64", "ctor", {}),
				privateMaxCout = 20,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubJoinPageUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubJoinPageUI.__define_class();
