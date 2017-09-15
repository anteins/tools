-- **********************************************************************
-- Copyright   2015  EIGHT Team . All rights reserved.
-- File     :  LoginServerCom.cs
-- Author   : qbkira
-- Created  : 2015/1/21  下2:23 
-- Purpose  : 
-- **********************************************************************
require "cs2lua__utility";
require "cs2lua__attributes";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIBehaviour";
require "ServerButtonCom";
require "GameUtility";
require "UIEventListener";
require "UILabel";
require "UIDragScrollView";

LoginServerCom = {
	__new_object = function(...)
		return newobject(LoginServerCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = LoginServerCom;

		local static_methods = {
			cctor = function()
				EIBehaviour.cctor(this);
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				__attributes = LoginServerCom__Attrs,
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			SetupData = function(this, serverList, defaultServer)
				local filterServerList; filterServerList = newexternlist(System.Collections.Generic.List_EightGame.Logic.LoginServerParam, "System.Collections.Generic.List_EightGame.Logic.LoginServerParam", "ctor", {});
				this._serverDict = newexterndictionary(System.Collections.Generic.Dictionary_System.String_EightGame.Logic.LoginServerParam, "System.Collections.Generic.Dictionary_System.String_EightGame.Logic.LoginServerParam", "ctor", {});
				for server in getiterator(serverList) do
--FIXME : 这里过滤掉Close 状态服务器 (by breen )
-- if( server.BaseState == (int)ServerButtonCom.BaseState.Close) continue;
					if this._serverDict:ContainsKey(server.ServerName) then
						Eight.Framework.EIDebuger.LogError(System.String.Format("the server name of <{0}> is repeat , please check gateway message ", server.ServerName));
					else
						filterServerList:Add(server);
						this._serverDict:Add(server.ServerName, server);
					end;
--PopupListServer.items.Add(server.ServerName);
				end;
				Eight.Framework.EIDebuger.Log(("推荐服务器 :  " + defaultServer.ServerUIState));
				this._currentServer = condexp((defaultServer.ServerUIState == 1), true, nil, false, (function() return defaultServer; end));
				if (this._currentServer ~= nil) then
					this:OnSelectServer(this._currentServer);
				end;
				filterServerList:Sort((function(x, y) return System.String.Compare(x.Uid, y.Uid); end));
				Eight.Framework.EIDebuger.Log((" filterServerList :" + filterServerList.Count));
				this.AllServerList:AddRange(filterServerList:FindAll((function(x) return ((x.BaseState ~= 0) and (x.ServerUIState == 2)); end)));
				this.AllServerList:AddRange(filterServerList:FindAll((function(x) return ((x.BaseState ~= 0) and (x.ServerUIState == 0)); end)));
				this.AllServerList:AddRange(filterServerList:FindAll((function(x) return ((x.BaseState ~= 0) and (x.ServerUIState == 5)); end)));
				this.AllServerList:AddRange(filterServerList:FindAll((function(x) return ((x.BaseState ~= 0) and (x.ServerUIState == 3)); end)));
				this.AllServerList:AddRange(filterServerList:FindAll((function(x) return (x.ServerUIState == 1); end)));
				this.AllServerList:AddRange(filterServerList:FindAll((function(x) return ((x.BaseState == 0) and (x.ServerUIState ~= 4)); end)));
				Eight.Framework.EIDebuger.Log((" AllServerList :" + this.AllServerList.Count));
				this.HideServerList:AddRange(filterServerList:FindAll((function(x) return (x.ServerUIState == 4); end)));
-- AllServerList.AddRange(filterServerList.FindAll(x => (!AllServerList.Contains(x) && x.ServerUIState != (int)ServerButtonCom.ServerState.Normal && !HideServerList.Contains(x))));
				this.AllServerList:AddRange(filterServerList:FindAll((function(x) return ( ((not this.AllServerList:Contains(x)) and (not this.HideServerList:Contains(x))) ); end)));
-- AllServerList = filterServerList;
				this:AllServerInit();
--推荐服务器
--EIDebuger.Log ("推荐服务器 :  未完成 :" +_currentServer.ServerName);
			end,
			GetSelectServer = function(this)
				return this._currentServer;
			end,
			InitRecommendServers = function(this, Re1, Re2)
				local sbcd1; sbcd1 = newobject(ServerButtonCom.ServerButtonData, "ctor", nil, 0, Re1.Uid, Re1.ServerName, Re1.ServerUIState, Re1.ServerPort, Re1.ServerIP, Re1.BaseState);
				this.RecommendServer1.MyButtonData = sbcd1;
				this.RecommendServer1.SVName.text = System.String.Format("{0}", Re1.ServerName);
				local sbcd2; sbcd2 = newobject(ServerButtonCom.ServerButtonData, "ctor", nil, 0, Re2.Uid, Re2.ServerName, Re2.ServerUIState, Re2.ServerPort, Re2.ServerIP, Re2.BaseState);
				this.RecommendServer2.MyButtonData = sbcd2;
				this.RecommendServer2.SVName.text = System.String.Format("{0}", Re2.ServerName);
			end,
			OnSelectServer = function(this, sbc)
				local sbcd; sbcd = newobject(ServerButtonCom.ServerButtonData, "ctor", nil, 0, sbc.Uid, sbc.ServerName, sbc.ServerUIState, sbc.ServerPort, sbc.ServerIP, sbc.BaseState);
				local serverName; serverName = sbc.ServerName;
				this.CurrentServer.text = System.String.Format("[{0}]{1}[-]", ServerButtonCom.BaseStColor(sbcd.MyBaseSt), serverName);
				Eight.Framework.EIDebuger.Log((" OnSelectServer  " + this.CurrentServer.text));
				this.CurrentServerInAll.MyButtonData = sbcd;
				this.CurrentServerInAll.SVName.text = System.String.Format("{0}", serverName);
				if (not this._serverDict:ContainsKey(serverName)) then
					Eight.Framework.EIDebuger.LogError("[Login] Server error");
--EIFrameWork.Instance.DispatchEvent (new EIBoolEvent(LoginMessageType.LOGIN_AGAIN,false));
--ServerObj.SetActive(false);
--_isAgain=false;
					return ;
				end;
--_isAgain = true;
--ServerObj.SetActive(true);
--EIFrameWork.Instance.DispatchEvent (new EIBoolEvent(LoginMessageType.LOGIN_AGAIN,true));
				this._currentServer = getexterninstanceindexer(this._serverDict, nil, "get_Item", serverName);
			end,
			OpenAllServerPage = function(this)
				GameUtility.TweenScaleOpen(this.AllServerPage);
				GameUtility.TweenAlphaClose(this.ServerObj, nil);
			end,
			CloseAllServerPage = function(this)
--		StartCoroutine (GameUtility.TweenScaleClose (AllServerPage));
				GameUtility.TweenScaleClose(this.AllServerPage);
				GameUtility.TweenAlphaOpen(this.ServerObj);
			end,
			BackPage = function(this)
				GameUtility.TweenAlphaClose(this.ServerObj, this.AccountPage);
--BackObj.SetActive (false);
			end,
			ClickAllServerButton = function(this)
				local i; i = 0;
				while (i < this.AllServerButton.Count) do
					getexterninstanceindexer(this.AllServerButton, nil, "get_Item", i).gameObject:SetActive(true);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				this.ServersGrid:Reposition();
				this.ServerSCBar.value = 0;
				this:SetToggle(invokeintegeroperator(3, "-", this.EffectBgList.Count, 1, System.Int32, System.Int32));
			end,
			ClickMyServerButton = function(this)
				local i; i = 0;
				while (i < this.AllServerButton.Count) do
					getexterninstanceindexer(this.AllServerButton, nil, "get_Item", i).gameObject:SetActive(false);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				this:SetToggle(invokeintegeroperator(3, "-", this.EffectBgList.Count, 2, System.Int32, System.Int32));
				local _MyHistory; _MyHistory = UnityEngine.PlayerPrefs.GetString("MyServerHistory", "");
				Eight.Framework.EIDebuger.Log(("_MyHistory  :" + _MyHistory));
				if (_MyHistory == "") then
					return ;
				end;
				local _allMy; _allMy = invokeforbasicvalue(_MyHistory, false, System.String, "Split", wrapchar(',', 0x02C));
				local i; i = 0;
				while (i < this.AllServerButton.Count) do
					local _sname; _sname = getexterninstanceindexer(this.AllServerButton, nil, "get_Item", i).SVName.text;
					invokeforbasicvalue(_sname, false, System.String, "Trim");
					for _name in getiterator(_allMy) do
						if invokeforbasicvalue(_sname, false, System.String, "Contains", _name) then
							getexterninstanceindexer(this.AllServerButton, nil, "get_Item", i).gameObject:SetActive(true);
						end;
					end;
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				this.ServersGrid:Reposition();
				this.ServerSCBar.value = 0;
			end,
			AllServerInit = function(this)
				delegationset(false, false, "UIEventListener:onClick", UIEventListener.Get(this.CurrentServerInAll.gameObject), nil, "onClick", (function() local __compiler_delegation_206 = (function(SignleServer) this:ChoiceServer(SignleServer); end); setdelegationkey(__compiler_delegation_206, "LoginServerCom:ChoiceServer", this, this.ChoiceServer); return __compiler_delegation_206; end)());
				delegationset(false, false, "UIEventListener:onClick", UIEventListener.Get(this.RecommendServer1.gameObject), nil, "onClick", (function() local __compiler_delegation_207 = (function(SignleServer) this:ChoiceServer(SignleServer); end); setdelegationkey(__compiler_delegation_207, "LoginServerCom:ChoiceServer", this, this.ChoiceServer); return __compiler_delegation_207; end)());
				delegationset(false, false, "UIEventListener:onClick", UIEventListener.Get(this.RecommendServer2.gameObject), nil, "onClick", (function() local __compiler_delegation_208 = (function(SignleServer) this:ChoiceServer(SignleServer); end); setdelegationkey(__compiler_delegation_208, "LoginServerCom:ChoiceServer", this, this.ChoiceServer); return __compiler_delegation_208; end)());
				local i; i = 0;
				while (i < this.ServerCategories.Count) do
					delegationset(false, false, "UIEventListener:onClick", UIEventListener.Get(getexterninstanceindexer(this.ServerCategories, nil, "get_Item", i).transform.parent.gameObject), nil, "onClick", (function() local __compiler_delegation_211 = (function(ChanelBt) this:ClickCategoriesButton(ChanelBt); end); setdelegationkey(__compiler_delegation_211, "LoginServerCom:ClickCategoriesButton", this, this.ClickCategoriesButton); return __compiler_delegation_211; end)());
					getexterninstanceindexer(this.ServerCategories, nil, "get_Item", i).transform.parent.gameObject:SetActive(false);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				this:ShowServer(this.AllServerList.Count);
				this:SetToggle(invokeintegeroperator(3, "-", this.EffectBgList.Count, 1, System.Int32, System.Int32));
				local GetRecList; GetRecList = this:GetRecommendList();
				if (GetRecList.Count > 0) then
					this:InitRecommendServers(getexterninstanceindexer(GetRecList, nil, "get_Item", 0), getexterninstanceindexer(GetRecList, nil, "get_Item", 1));
				end;
			end,
			GetRecommendList = function(this)
				local _recomlist; _recomlist = newexternlist(System.Collections.Generic.List_EightGame.Logic.LoginServerParam, "System.Collections.Generic.List_EightGame.Logic.LoginServerParam", "ctor", {});
				local i; i = invokeintegeroperator(3, "-", this.AllServerList.Count, 1, System.Int32, System.Int32);
				while (i >= 0) do
					if (getexterninstanceindexer(this.AllServerList, nil, "get_Item", i).ServerUIState == 2) then
						_recomlist:Add(getexterninstanceindexer(this.AllServerList, nil, "get_Item", i));
						if (_recomlist.Count >= 2) then
							break;
						end;
					end;
				i = invokeintegeroperator(3, "-", i, 1, System.Int32, System.Int32);
				end;
				if (_recomlist.Count == 0) then
					if (this.AllServerList.Count >= 2) then
						_recomlist:Add(getexterninstanceindexer(this.AllServerList, nil, "get_Item", invokeintegeroperator(3, "-", this.AllServerList.Count, 1, System.Int32, System.Int32)));
						_recomlist:Add(getexterninstanceindexer(this.AllServerList, nil, "get_Item", invokeintegeroperator(3, "-", this.AllServerList.Count, 2, System.Int32, System.Int32)));
					else
						_recomlist:Add(getexterninstanceindexer(this.AllServerList, nil, "get_Item", 0));
					end;
				end;
				if (_recomlist.Count == 1) then
					_recomlist:Add(getexterninstanceindexer(_recomlist, nil, "get_Item", 0));
				end;
				return _recomlist;
			end,
			ShowServer = function(this, serverCount)
				local initnum; initnum = 20;
				local listCount; listCount = this.ServerCategories.Count;
				local rootCount; rootCount = invokeintegeroperator(0, "/", typecast(serverCount, System.Int32, false), initnum, System.Int32, System.Int32);
				local remendN; remendN = invokeintegeroperator(1, "%", serverCount, initnum, System.Int32, System.Int32);
				local rootC; rootC = invokeintegeroperator(2, "+", typecast(( invokeintegeroperator(0, "/", rootCount, ( invokeintegeroperator(3, "-", listCount, 1, System.Int32, System.Int32) ), System.Int32, System.Int32) ), System.Int32, false), 1, System.Int32, System.Int32);
--次数
--次数
				local rootNum; rootNum = invokeintegeroperator(1, "%", rootCount, ( invokeintegeroperator(3, "-", listCount, 1, System.Int32, System.Int32) ), System.Int32, System.Int32);
				local min; min = 1;
				local max; max = 0;
				local IsEnough; IsEnough = ( (serverCount > invokeintegeroperator(4, "*", listCount, initnum, System.Int32, System.Int32)) );
				local i; i = 0;
				while (i < listCount) do
					if (i == invokeintegeroperator(3, "-", listCount, 1, System.Int32, System.Int32)) then
						if IsEnough then
							max = invokeintegeroperator(2, "+", max, remendN, System.Int32, System.Int32);
						else
							max = invokeintegeroperator(2, "+", max, 20, System.Int32, System.Int32);
						end;
					else
						if (i < rootNum) then
							max = invokeintegeroperator(2, "+", max, invokeintegeroperator(4, "*", rootC, 20, System.Int32, System.Int32), System.Int32, System.Int32);
						elseif IsEnough then
							max = invokeintegeroperator(2, "+", max, invokeintegeroperator(4, "*", ( invokeintegeroperator(3, "-", rootC, 1, System.Int32, System.Int32) ), 20, System.Int32, System.Int32), System.Int32, System.Int32);
						else
							max = invokeintegeroperator(2, "+", max, 20, System.Int32, System.Int32);
						end;
						if (i == 0) then
							this:ShowServersByChoice(min, max);
						end;
					end;
					getexterninstanceindexer(this.ServerCategories, nil, "get_Item", i).text = System.String.Format("S{0}-{1}", min, max);
					this:InitAllServerButton(min, max);
					min = invokeintegeroperator(2, "+", max, 1, System.Int32, System.Int32);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				if (not IsEnough) then
					this:OpenCategoriesButton(serverCount);
				end;
			end,
			OpenCategoriesButton = function(this, svcount)
				local i; i = 0;
				while (i < this.ServerCategories.Count) do
					local chanelS; chanelS = getexterninstanceindexer(this.ServerCategories, nil, "get_Item", i):GetComponent(UILabel).text;
					local min; min = 0;
					local max; max = 0;
					min, max = this:SplitDo(chanelS, min, max);
					if (svcount >= min) then
						getexterninstanceindexer(this.ServerCategories, nil, "get_Item", i).transform.parent.gameObject:SetActive(true);
					end;
					if (svcount <= max) then
						break;
					end;
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
			end,
			ClickCategoriesButton = function(this, ChanelBt)
				for sbc in getiterator(this.HideServerButton) do
					sbc.gameObject:SetActive(false);
				end;
				local lab; lab = ChanelBt:GetComponent(UILabel);
				local chanelS; chanelS = lab.text;
				local min; min = 0;
				local max; max = 0;
				min, max = this:SplitDo(chanelS, min, max);
				this:ShowServersByChoice(min, max);
				local i; i = 0;
				while (i < this.ServerCategories.Count) do
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", lab, getexterninstanceindexer(this.ServerCategories, nil, "get_Item", i)) then
						this:SetToggle(i);
						break;
					end;
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
			end,
			ShowHideServers = function(this)
				for sbc in getiterator(this.AllServerButton) do
					sbc.gameObject:SetActive(false);
				end;
				if (this.HideServerButton.Count == 0) then
					for sbc in getiterator(this.HideServerList) do
						this:CreatServerButton(99, sbc, this.HideServerButton);
					end;
				else
					for sbc in getiterator(this.HideServerButton) do
						sbc.gameObject:SetActive(true);
					end;
				end;
				this.ServersGrid:Reposition();
				this.ServerSCBar.value = 0;
			end,
			ClickShowHideServers = function(this)
				if (this.ClickHideNum >= 10) then
					this.ClickHideNum = 0;
					this:ShowHideServers();
				else
					this.ClickHideNum = invokeintegeroperator(2, "+", this.ClickHideNum, 1, System.Int32, System.Int32);
				end;
			end,
			SplitDo = function(this, chanelS, _min, _max)
				local _num; _num = invokeforbasicvalue(chanelS, false, System.String, "Split", wrapchar('-', 0x02D));
				_max = System.Int32.Parse(_num[2]);
				local mins; mins = invokeforbasicvalue(_num[1], false, System.String, "ToCharArray");
				local Ms; Ms = "";
				local i; i = 1;
				while (i < mins.Length) do
					Ms = (Ms + mins[i + 1]);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				_min = System.Int32.Parse(invokeforbasicvalue(Ms, false, System.String, "ToString"));
--Debug.Log (" _min : "+_min + " _max : " +_max);
				return _min, _max;
			end,
			ChoiceServer = function(this, SignleServer)
				local sbc; sbc = newobject(ServerButtonCom, "ctor", nil);
				if invokeforbasicvalue(SignleServer.name, false, System.String, "Contains", "ServerName") then
					sbc = SignleServer.transform:GetComponent(ServerButtonCom);
				else
					sbc = SignleServer.transform.parent:GetComponent(ServerButtonCom);
				end;
--if (sbc.MyButtonData.MyState != ServerButtonCom.ServerState.Maintenanc) {
				this:OnSelectServer(sbc.MyButtonData);
				this:CloseAllServerPage();
--}
			end,
			InitAllServerButton = function(this, min, max)
--Debug.Log ("min : " + min +"max : " +max);
				local i; i = min;
				while (i < max) do
					if (i > this.AllServerList.Count) then
						break;
					end;
					this:CreatServerButton(i, getexterninstanceindexer(this.AllServerList, nil, "get_Item", invokeintegeroperator(3, "-", i, 1, System.Int32, System.Int32)), this.AllServerButton);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				this.ServersGrid:Reposition();
				this.ServerSCBar.value = 0;
			end,
			ShowServersByChoice = function(this, min, max)
				local i; i = 0;
				while (i < this.AllServerButton.Count) do
					if ((i >= invokeintegeroperator(3, "-", min, 1, System.Int32, System.Int32)) and (i <= invokeintegeroperator(3, "-", max, 1, System.Int32, System.Int32))) then
						if (invokeintegeroperator(2, "+", min, i, System.Int32, System.Int32) > this.AllServerButton.Count) then
							Eight.Framework.EIDebuger.Log(" 服务器少于显示数量 ");
							break;
						end;
						getexterninstanceindexer(this.AllServerButton, nil, "get_Item", i).gameObject:SetActive(true);
						Eight.Framework.EIDebuger.Log(" 更新服务器状态 ");
					else
						getexterninstanceindexer(this.AllServerButton, nil, "get_Item", i).gameObject:SetActive(false);
					end;
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				this.ServersGrid:Reposition();
			end,
			CreatServerButton = function(this, Id, SParam, _all)
				local ServerTemp; ServerTemp = GameUtility.InstantiateGameObject(this.ServerSample, this.ServersGrid.gameObject, invokeforbasicvalue(Id, false, System.Int32, "ToString"), nil, nil, nil);
				local sbc; sbc = ServerTemp:GetComponent(ServerButtonCom);
				local sbcd; sbcd = newobject(ServerButtonCom.ServerButtonData, "ctor", nil, Id, SParam.Uid, SParam.ServerName, SParam.ServerUIState, SParam.ServerPort, SParam.ServerIP, SParam.BaseState);
-- 测试 2？
-- 测试 2？
				sbc.MyButtonData = sbcd;
				sbc:Init();
				sbc.MyBt:GetComponent(UIDragScrollView).scrollView = this.ServerScView;
				_all:Add(sbc);
				delegationset(false, false, "UIEventListener:onClick", UIEventListener.Get(sbc.MyBt.gameObject), nil, "onClick", (function() local __compiler_delegation_449 = (function(SignleServer) this:ChoiceServer(SignleServer); end); setdelegationkey(__compiler_delegation_449, "LoginServerCom:ChoiceServer", this, this.ChoiceServer); return __compiler_delegation_449; end)());
			end,
			SetToggle = function(this, _index)
				for ef in getiterator(this.EffectBgList) do
					ef.gameObject:SetActive(false);
				end;
				getexterninstanceindexer(this.EffectBgList, nil, "get_Item", _index).gameObject:SetActive(true);
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				ServerObj = __cs2lua_nil_field_value,
				CurrentServer = __cs2lua_nil_field_value,
				CurrentServerInAll = __cs2lua_nil_field_value,
				RecommendServer1 = __cs2lua_nil_field_value,
				RecommendServer2 = __cs2lua_nil_field_value,
				ServerCategories = newexternlist(System.Collections.Generic.List_UILabel, "System.Collections.Generic.List_UILabel", "ctor", {}),
				ServersGrid = __cs2lua_nil_field_value,
				ServerSCBar = __cs2lua_nil_field_value,
				AccountPage = __cs2lua_nil_field_value,
				AllServerPage = __cs2lua_nil_field_value,
				BackObj = __cs2lua_nil_field_value,
				ServerScView = __cs2lua_nil_field_value,
				_serverDict = __cs2lua_nil_field_value,
				_currentServer = __cs2lua_nil_field_value,
				AllServerList = newexternlist(System.Collections.Generic.List_EightGame.Logic.LoginServerParam, "System.Collections.Generic.List_EightGame.Logic.LoginServerParam", "ctor", {}),
				AllServerButton = newexternlist(System.Collections.Generic.List_ServerButtonCom, "System.Collections.Generic.List_ServerButtonCom", "ctor", {}),
				HideServerList = newexternlist(System.Collections.Generic.List_EightGame.Logic.LoginServerParam, "System.Collections.Generic.List_EightGame.Logic.LoginServerParam", "ctor", {}),
				HideServerButton = newexternlist(System.Collections.Generic.List_ServerButtonCom, "System.Collections.Generic.List_ServerButtonCom", "ctor", {}),
				ServerSample = __cs2lua_nil_field_value,
				EffectBgList = newexternlist(System.Collections.Generic.List_UISprite, "System.Collections.Generic.List_UISprite", "ctor", {}),
				ClickHideNum = 0,
				__attributes = LoginServerCom__Attrs,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIBehaviour, "LoginServerCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



LoginServerCom.__define_class();
