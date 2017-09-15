require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "Eight__Framework__EINode";
require "ChatItemDes";
require "ChatEquipmentDes";
require "ChatFighterDes";
require "ChatBaseDes";
require "LogicStatic";
require "AlarmManagerHelper";
require "ChatMessage";
require "AlarmManager";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "GlobalCamera";
require "NGUITools";
require "ChatMainViewController";
require "ChatMainViewCom";
require "ChatExplainController";
require "Eight__Framework__EIBoolEvent";
require "ListExtension";
require "Eight__Framework__EIEvent";
require "CoolDownManager";
require "ChatEmojiDes";
require "SensitiveParam";
require "EightGame__Logic__FloatingTextTipUIRoot";
require "ChatMsgURLContent";

ChatMsgManager = {
	__new_object = function(...)
		return newobject(ChatMsgManager, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatMsgManager;

		local static_methods = {
			get_Instance = function()
				if (ChatMsgManager._instance == nil) then
					ChatMsgManager._instance = newobject(ChatMsgManager, "ctor", nil);
				end;
				return ChatMsgManager._instance;
			end,
			GetMsgContent = function(chatmsg)
				local contentStr; contentStr = System.Text.Encoding.UTF8:GetString(chatmsg.msgcontent);
				local str; str = System.String.Empty;
				local cmu; cmu = ChatMsgManager.Instance:AnalysisMsgContent(contentStr);
				local des; des = nil;
				if (cmu == nil) then
					str = System.String.Empty;
				else
					if (cmu.itemtype == 1) then
--普通物品
						des = newobject(ChatItemDes, "ctor", nil);
						str = des:JoinURLStr(cmu);
					elseif (cmu.itemtype == 2) then
--装备
						des = newobject(ChatEquipmentDes, "ctor", nil);
						str = des:JoinURLStr(cmu);
					elseif (cmu.itemtype == 3) then
--伙伴
						des = newobject(ChatFighterDes, "ctor", nil);
						str = des:JoinURLStr(cmu);
					elseif (cmu.itemtype == 4) then
--表情
						des = newobject(ChatBaseDes, "ctor", nil);
						str = des:JoinURLStr(cmu);
					else
						str = cmu.characterStr;
					end;
				end;
				return str;
			end,
			GetRollMsgContent = function(chatmsg)
				local fixStr; fixStr = System.String.Empty;
				local fixColor; fixColor = "[ffffff]";
				local playerName; playerName = "";
				if (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					fixColor = "[eb7fff]";
					playerName = (chatmsg.playername + "[-]");
					fixStr = System.String.Format("{0}[私聊]", fixColor);
				elseif (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATSYSTEM ) then
					fixColor = "[4aa8ff]";
					fixStr = System.String.Format("{0}[系统]", fixColor);
				elseif (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATTEAM ) then
					playerName = chatmsg.playername;
					fixStr = System.String.Format("{0}[队伍][-]", fixColor);
				elseif (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATUNION ) then
					local power; power = System.String.Empty;
					local permissions; permissions = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.sd_guild_permissions), chatmsg.guildPower);
					if (permissions ~= nil) then
						power = permissions.desc;
					end;
					fixColor = "[7fffa9]";
					playerName = System.String.Format("{0} {1}", power, (chatmsg.playername + "[-]"));
					fixStr = System.String.Format("{0}[冒险团]", fixColor);
				elseif (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATWORLD ) then
					fixColor = "[ffc34f]";
					playerName = chatmsg.playername;
					fixStr = System.String.Format("{0}[世界][-]", fixColor);
				end;
				local str; str = ChatMsgManager.GetMsgContent(chatmsg);
				str = System.String.Format("{0}{1}:{2}", fixStr, condexp(System.String.IsNullOrEmpty(chatmsg.playername), true, "", false, (function() return playerName; end)), str);
				return str;
			end,
			CheckGuildNotice = function()
				local show; show = false;
				local playerserdata; playerserdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
				local latestUnixTime; latestUnixTime = System.Int64.Parse(UnityEngine.PlayerPrefs.GetString(System.String.Format("{0}_{1}", "chat_guild_notice_show", playerserdata.id), "0"));
				if (latestUnixTime == 0) then
					show = true;
				else
					local curUnixTime; curUnixTime = AlarmManagerHelper.DateTimeToUnixTime(System.DateTime.Now);
					local latestDateTime; latestDateTime = AlarmManagerHelper.UnixTimeToDateTime(latestUnixTime);
					if (System.DateTime.Now.DayOfYear > latestDateTime.DayOfYear) then
--需要展示
						show = true;
					end;
				end;
				if show then
					UnityEngine.PlayerPrefs.SetString(System.String.Format("{0}_{1}", "chat_guild_notice_show", playerserdata.id), invokeforbasicvalue(AlarmManagerHelper.DateTimeToUnixTime(System.DateTime.Now), false, System.Int64, "ToString"));
					local clubdata; clubdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil);
					if (clubdata == nil) then
						return ;
					end;
					local temp; temp = System.Text.Encoding.UTF8:GetString(clubdata.signature);
					temp = condexp((getforbasicvalue(temp, false, System.String, "Length") > 41), false, (function() return System.String.Format("{0}...", invokeforbasicvalue(temp, false, System.String, "Substring", 0, 40)); end), false, (function() return temp; end));
					local content; content = System.Text.Encoding.UTF8:GetBytes(temp);
					local msg; msg = newobject(ChatMessage, "ctor", nil);
					msg.playerid = -1000;
					msg.playerLv = clubdata.clubLv;
					msg.playerVipLv = 0;
					msg.chattype = se_chattype.SE_CHATTYPE_CHATUNION;
					msg.chatTime = UnityEngine.Mathf.CeilToInt((AlarmManager.Instance:currentTimeMillis() / 1000.00));
					msg.msgcontent = content;
					msg.playergender = false;
					msg.playername = "冒险团公告";
					msg.sensitiveWord = System.Text.Encoding.UTF8:GetBytes(System.String.Empty);
					msg.guildPower = 0;
					ChatMsgManager.Instance:AddChatMessage(msg);
				end;
			end,
			cctor = function()
				Eight.Framework.EINode.cctor(this);
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				_instance = __cs2lua_nil_field_value,
				SHOW_CHAT_VIEW = "SHOW_CHAT_VIEW",
			};
			return static_fields;
		end;

		local static_props = {
			Instance = {
				get = static_methods.get_Instance,
			},
		};

		local static_events = nil;

		local instance_methods = {
			OpenChat = function(this)
				local gamerule; gamerule = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_gamerule), (function(S) return (typecast(S.paramtype, System.Int32, false) == 802); end));
				if (gamerule == nil) then
					return ;
				end;
-- 0：不显示 ， 1：显示
				if (gamerule.value == 1) then
					Eight.Framework.EIFrameWork.StartCoroutine(this:InitChatView(), false);
				end;
			end,
			CloseChat = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._viewController, nil) then
					this._viewController:CloseChat();
				end;
			end,
			InitChatView = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._viewController, nil) then
					local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(System.String.Format("{0}{1}", "GameAssets/Prefabs/UI/", this._viewPrefabPath), "prefab", false);
					wrapyield(coroutine.coroutine, false, true);
					local prefab; prefab = typeas(coroutine.res, UnityEngine.GameObject, false);
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", prefab, nil) then
						Eight.Framework.EIDebuger.Log(System.String.Format(" load { 0 } error , please check", this._viewPrefabPath));
						return nil;
					end;
					local go; go = GameUtility.InstantiateGameObject(prefab, GlobalCamera.globalUICamera.gameObject, "ChatView", nil, nil, nil);
					this._viewController = NGUITools.AddMissingComponent(go, ChatMainViewController);
					this._viewController._com = go:GetComponent(ChatMainViewCom);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._viewController, nil) then
					this:BindComponent__EIEntityBehaviour(this._viewController);
					this:RemoveAllEventListener();
					this:AddEventListener(ChatMsgManager.SHOW_CHAT_VIEW, (function() local __compiler_delegation_124 = (function(e) this:ShowChatView(e); end); setdelegationkey(__compiler_delegation_124, "ChatMsgManager:ShowChatView", this, this.ShowChatView); return __compiler_delegation_124; end)());
					this._viewController:InitChat();
					this:AddEventListener(ChatMsgManager.Instance.CHAT_MSG_ADD, (function() local __compiler_delegation_127 = (function(e) this:ListenerMsgAdd(e); end); setdelegationkey(__compiler_delegation_127, "ChatMsgManager:ListenerMsgAdd", this, this.ListenerMsgAdd); return __compiler_delegation_127; end)());
					this:AddEventListener(ChatExplainController.CLICK_CHATEXPLAIN_ACTION, (function() local __compiler_delegation_128 = (function(e) this:ClickChatExplainAction(e); end); setdelegationkey(__compiler_delegation_128, "ChatMsgManager:ClickChatExplainAction", this, this.ClickChatExplainAction); return __compiler_delegation_128; end)());
--			EIFrameWork.Instance.RemoveEventListener( SHOW_CHAT_VIEW );
--			EIFrameWork.Instance.AddEventListener( SHOW_CHAT_VIEW , ShowChatView );
				end;
			end),
			ListenerMsgAdd = function(this, e)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._viewController, nil) then
					this._viewController._com:ListenerMsgAdd(e);
				end;
			end,
			ClickChatExplainAction = function(this, e)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._viewController, nil) then
					this._viewController._com:ClickChatExplainAction(e);
				end;
			end,
			ShowChatView = function(this, e)
				local eb; eb = typeas(e, Eight.Framework.EIBoolEvent, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._viewController, nil) then
					this._viewController:ForceSetChatViewState(eb.boolParam);
				end;
			end,
			GetAllChatChannels = function(this)
				local enumlist; enumlist = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.se_chattype, "System.Collections.Generic.List_EightGame.Data.Server.se_chattype", "ctor", {});
				enumlist:Add(se_chattype.SE_CHATTYPE_CHATWORLD );
				enumlist:Add(se_chattype.SE_CHATTYPE_CHATUNION );
				enumlist:Add(se_chattype.SE_CHATTYPE_CHATPRIVATE);
				enumlist:Add(se_chattype.SE_CHATTYPE_CHATSYSTEM);
				return enumlist;
			end,
			AddChatMessage = function(this, msg)
				if (msg.chattype == se_chattype.SE_CHATTYPE_CHATSYSTEM) then
--系统消息
					ListExtension.Push(this._allSystemChatmsgs, ChatMessage, msg);
					if (this._allSystemChatmsgs.Count > this._cachMsgCount) then
						ListExtension.DequeueHead(this._allSystemChatmsgs, ChatMessage);
					end;
					ListExtension.Push(this._allChatMsgs, ChatMessage, msg);
					if (this._allChatMsgs.Count > this._cachMsgCount) then
						ListExtension.DequeueHead(this._allChatMsgs, ChatMessage);
					end;
				elseif (msg.chattype == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
--私人
					local checkplayerid; checkplayerid = condexp((msg.toplayerid == 0), false, (function() return msg.playerid; end), false, (function() return msg.toplayerid; end));
					if this._allPrivateChatMsgDic:ContainsKey(checkplayerid) then
						ListExtension.Push(getexterninstanceindexer(this._allPrivateChatMsgDic, nil, "get_Item", checkplayerid), ChatMessage, msg);
						if (getexterninstanceindexer(this._allPrivateChatMsgDic, nil, "get_Item", checkplayerid).Count > this._cachMsgCount) then
							ListExtension.DequeueHead(getexterninstanceindexer(this._allPrivateChatMsgDic, nil, "get_Item", checkplayerid), ChatMessage);
						end;
					else
						local ls; ls = newexternlist(System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.List_ChatMessage", "ctor", {});
						ls:Add(msg);
						this._allPrivateChatMsgDic:Add(checkplayerid, ls);
					end;
					if this._allUnReadPrivateChatMsgDic:ContainsKey(checkplayerid) then
						ListExtension.Push(getexterninstanceindexer(this._allUnReadPrivateChatMsgDic, nil, "get_Item", checkplayerid), ChatMessage, msg);
						if (getexterninstanceindexer(this._allUnReadPrivateChatMsgDic, nil, "get_Item", checkplayerid).Count > this._cachMsgCount) then
							ListExtension.DequeueHead(getexterninstanceindexer(this._allUnReadPrivateChatMsgDic, nil, "get_Item", checkplayerid), ChatMessage);
						end;
					else
						local ls; ls = newexternlist(System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.List_ChatMessage", "ctor", {});
						ls:Add(msg);
						this._allUnReadPrivateChatMsgDic:Add(checkplayerid, ls);
					end;
				elseif (msg.chattype == se_chattype.SE_CHATTYPE_CHATUNION ) then
--帮派
					ListExtension.Push(this._allUnionChatmsgs, ChatMessage, msg);
					if (this._allUnionChatmsgs.Count > this._cachMsgCount) then
						ListExtension.DequeueHead(this._allUnionChatmsgs, ChatMessage);
					end;
				elseif (msg.chattype == se_chattype.SE_CHATTYPE_CHATWORLD ) then
					ListExtension.Push(this._allChatMsgs, ChatMessage, msg);
					if (this._allChatMsgs.Count > this._cachMsgCount) then
						ListExtension.DequeueHead(this._allChatMsgs, ChatMessage);
					end;
				end;
--广播新的聊天信息进入
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, this.CHAT_MSG_ADD, nil, msg, 0.00));
			end,
			ClearWorldChannelMsg = function(this)
				this._allChatMsgs:Clear();
			end,
			GetAllChatMessageByChannel = function(this, chattype, playerid)
				if (chattype == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					this:ClearUnReadPrivateChatMsg(playerid);
					if this._allPrivateChatMsgDic:ContainsKey(playerid) then
						return getexterninstanceindexer(this._allPrivateChatMsgDic, nil, "get_Item", playerid);
					end;
				elseif (chattype == se_chattype.SE_CHATTYPE_CHATSYSTEM  ) then
					return this._allSystemChatmsgs;
				elseif (chattype == se_chattype.SE_CHATTYPE_CHATUNION ) then
					return this._allUnionChatmsgs;
				elseif (chattype == se_chattype.SE_CHATTYPE_CHATWORLD ) then
					return this._allChatMsgs;
				end;
				return newexternlist(System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.List_ChatMessage", "ctor", {});
			end,
			SortByTime = function(this, list)
				list:Sort((function(x, y)
					if (x.chatTime > y.chatTime) then
						return 1;
					elseif (x.chatTime < y.chatTime) then
						return -1;
					else
						return 0;
					end;
				end));
				return list;
			end,
			GetUnReadPrivateMsgs = function(this)
				return this._allUnReadPrivateChatMsgDic;
			end,
			GetUnReadPrivateMsgsBYFid = function(this, friendId)
				if this._allUnReadPrivateChatMsgDic:ContainsKey(friendId) then
					return getexterninstanceindexer(this._allUnReadPrivateChatMsgDic, nil, "get_Item", friendId);
				end;
				return nil;
			end,
			ClearUnReadPrivateChatMsg = function(this, playerid)
				if this._allUnReadPrivateChatMsgDic:ContainsKey(playerid) then
					this._allUnReadPrivateChatMsgDic:Remove(playerid);
				end;
			end,
			BeginCoolDownChatLock = function(this, chattype, updateCallback, finishCallback)
				if (((chattype ~= se_chattype.SE_CHATTYPE_CHATWORLD ) and (chattype ~= se_chattype.SE_CHATTYPE_CHATUNION  )) and (chattype ~= se_chattype.SE_CHATTYPE_CHATPRIVATE  )) then
					if externdelegationcomparewithnil(false, false, "ChatMsgManager:finishCallback", finishCallback, nil, nil, false) then
						finishCallback(chattype);
					end;
					return ;
				end;
				local intervaltime; intervaltime = this._msgIntervalTime;
				local gamerule; gamerule = nil;
				local cooldownLock; cooldownLock = this._beginCoolDownChatLock;
				if (chattype == se_chattype.SE_CHATTYPE_CHATWORLD ) then
					gamerule = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_gamerule), (function(S) return (typecast(S.paramtype, System.Int32, false) == 801); end));
					if (gamerule ~= nil) then
						intervaltime = (gamerule.value * 1000.00);
					end;
					cooldownLock = System.String.Format("{0}_{1}", this._beginCoolDownChatLock, se_chattype.SE_CHATTYPE_CHATWORLD:ToString());
				elseif (chattype == se_chattype.SE_CHATTYPE_CHATUNION ) then
					gamerule = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_gamerule), (function(S) return (typecast(S.paramtype, System.Int32, false) == 804); end));
					if (gamerule ~= nil) then
						intervaltime = (gamerule.value * 1000.00);
					end;
--gamerule = LogicStatic.Get< sd_gamerule >( S=>(int)S.paramtype == (int)se_overall.secha );
					cooldownLock = System.String.Format("{0}_{1}", this._beginCoolDownChatLock, se_chattype.SE_CHATTYPE_CHATUNION:ToString());
				elseif (chattype == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					gamerule = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_gamerule), (function(S) return (typecast(S.paramtype, System.Int32, false) == 803); end));
					if (gamerule ~= nil) then
						intervaltime = (gamerule.value * 1000.00);
					end;
--gamerule = LogicStatic.Get< sd_gamerule >( S=>(int)S.paramtype == (int)se_overall.secha );
					cooldownLock = System.String.Format("{0}_{1}", this._beginCoolDownChatLock, se_chattype.SE_CHATTYPE_CHATPRIVATE:ToString());
				end;
				if this:CheckChatLock(cooldownLock) then
					return ;
				end;
				delegationset(false, false, "ChatMsgManager:_updateLockTimeCallback", this, nil, "_updateLockTimeCallback", updateCallback);
				this._chatLockList:Add(cooldownLock);
				if (chattype == se_chattype.SE_CHATTYPE_CHATWORLD ) then
					if (not CoolDownManager.Instance:IsCoolDownExist(cooldownLock)) then
						CoolDownManager.Instance:SetupCoolDown(cooldownLock, intervaltime, (function(remainTime)
							if externdelegationcomparewithnil(false, false, "ChatMsgManager:_updateLockTimeCallback", this, nil, "_updateLockTimeCallback", false) then
								this._updateLockTimeCallback(se_chattype.SE_CHATTYPE_CHATWORLD, remainTime);
							end;
						end), (function()
							if externdelegationcomparewithnil(false, false, "ChatMsgManager:finishCallback", finishCallback, nil, nil, false) then
								this:RemoveChatLock(System.String.Format("{0}_{1}", this._beginCoolDownChatLock, se_chattype.SE_CHATTYPE_CHATWORLD:ToString()));
								finishCallback(se_chattype.SE_CHATTYPE_CHATWORLD );
							end;
						end));
					end;
				elseif (chattype == se_chattype.SE_CHATTYPE_CHATUNION ) then
					if (not CoolDownManager.Instance:IsCoolDownExist(cooldownLock)) then
						CoolDownManager.Instance:SetupCoolDown(cooldownLock, intervaltime, (function(remainTime)
							if externdelegationcomparewithnil(false, false, "ChatMsgManager:_updateLockTimeCallback", this, nil, "_updateLockTimeCallback", false) then
								this._updateLockTimeCallback(se_chattype.SE_CHATTYPE_CHATUNION, remainTime);
							end;
						end), (function()
							if externdelegationcomparewithnil(false, false, "ChatMsgManager:finishCallback", finishCallback, nil, nil, false) then
								this:RemoveChatLock(System.String.Format("{0}_{1}", this._beginCoolDownChatLock, se_chattype.SE_CHATTYPE_CHATUNION:ToString()));
								finishCallback(se_chattype.SE_CHATTYPE_CHATUNION );
							end;
						end));
					end;
				elseif (chattype == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					if (not CoolDownManager.Instance:IsCoolDownExist(cooldownLock)) then
						CoolDownManager.Instance:SetupCoolDown(cooldownLock, intervaltime, (function(remainTime)
							if externdelegationcomparewithnil(false, false, "ChatMsgManager:_updateLockTimeCallback", this, nil, "_updateLockTimeCallback", false) then
								this._updateLockTimeCallback(se_chattype.SE_CHATTYPE_CHATPRIVATE, remainTime);
							end;
						end), (function()
							if externdelegationcomparewithnil(false, false, "ChatMsgManager:finishCallback", finishCallback, nil, nil, false) then
								this:RemoveChatLock(System.String.Format("{0}_{1}", this._beginCoolDownChatLock, se_chattype.SE_CHATTYPE_CHATPRIVATE:ToString()));
								finishCallback(se_chattype.SE_CHATTYPE_CHATPRIVATE );
							end;
						end));
					end;
				end;
			end,
			CheckChatLock = function(this, str)
				return this._chatLockList:Contains(str);
			end,
			RemoveChatLock = function(this, str)
				if this._chatLockList:Contains(str) then
					this._chatLockList:Remove(str);
				end;
			end,
			GetCanChatLock = function(this, chattype)
				local cooldownLock; cooldownLock = System.String.Empty;
				if (chattype == se_chattype.SE_CHATTYPE_CHATWORLD ) then
					cooldownLock = cooldownLock + System.String.Format("{0}_{1}", this._beginCoolDownChatLock, se_chattype.SE_CHATTYPE_CHATWORLD:ToString());
				elseif (chattype == se_chattype.SE_CHATTYPE_CHATUNION ) then
					cooldownLock = cooldownLock + System.String.Format("{0}_{1}", this._beginCoolDownChatLock, se_chattype.SE_CHATTYPE_CHATUNION:ToString());
				end;
				return this:CheckChatLock(cooldownLock);
			end,
			ClearAllData = function(this)
				this._allChatMsgs:Clear();
				this._allPrivateChatMsgDic:Clear();
				this._allSystemChatmsgs:Clear();
				this._allPrivateChatMsgDic:Clear();
				this._allUnReadPrivateChatMsgDic:Clear();
				CoolDownManager.Instance:CancelCoolDown(this._beginCoolDownChatLock);
				this._chatLockList:Clear();
			end,
			Decolor = function(this, str)
				local pureStr; pureStr = System.Text.RegularExpressions.Regex.Replace(invokeforbasicvalue(str, false, System.String, "Trim"), "\\[\\w{6}\\]", "");
--pureStr = ReplaceSendMsg( pureStr );
				pureStr = invokeforbasicvalue(pureStr, false, System.String, "Replace", "\n", "");
				pureStr = invokeforbasicvalue(pureStr, false, System.String, "Replace", "\t", "");
				pureStr = invokeforbasicvalue(pureStr, false, System.String, "Replace", "\f", "");
				return pureStr;
			end,
			FifterString = function(this, scontent)
				if System.String.IsNullOrEmpty(scontent) then
					return System.String.Empty;
				end;
				scontent = this:Decolor(scontent);
				return scontent;
			end,
			FifterKeyWord = function(this, scontent, chattype)
				if System.String.IsNullOrEmpty(scontent) then
					return false;
				end;
				if (this._chatKeyWordNotify == nil) then
					return false;
				end;
				if (not this._chatKeyWordNotify.chattyps:Contains(chattype)) then
					return false;
				end;
				return this:CheckKeyWord(scontent);
			end,
			CheckKeyWord = function(this, str)
				if ((this._keyWordArray == nil) or (this._keyWordArray.Length == 0)) then
					return false;
				end;
				local index; index = 0;
				local imax; imax = this._keyWordArray.Length;
				while (index < imax) do
					local match; match = System.Text.RegularExpressions.Regex.Match(invokeforbasicvalue(str, false, System.String, "Trim"), this._keyWordArray[index + 1]);
					if match.Success then
						return true;
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				return false;
			end,
			JoinItemContent = function(this, obj)
				local str; str = System.String.Empty;
				local des; des = nil;
				if typeis(obj, EightGame.Data.Server.ItemSerData, false) then
					des = newobject(ChatItemDes, "ctor", nil);
				elseif typeis(obj, EightGame.Data.Server.EquipmentSerData, false) then
					des = newobject(ChatEquipmentDes, "ctor", nil);
				elseif typeis(obj, EightGame.Data.Server.FighterSerData, false) then
					des = newobject(ChatFighterDes, "ctor", nil);
				elseif typeis(obj, EightGame.Data.Server.sd_chatemoji, false) then
					des = newobject(ChatEmojiDes, "ctor", nil);
				end;
				if (des ~= nil) then
					str = des:JoinSendStr(obj);
				end;
				str = System.String.Format("#c_begin{0}#c_end", str);
				return str;
			end,
			JudgeSendCondition = function(this, obj, inputvalue)
				return this:JudgeSendWorldLenght(obj, inputvalue);
			end,
			ReplaceSendMsg = function(this, str)
				local param; param = newobject(SensitiveParam, "ctor", nil);
				param.replacedStr = str;
				local blackList; blackList = LogicStatic.GetList(typeof(EightGame.Data.Server.sd_name_blacklist), nil);
				if (blackList == nil) then
					blackList = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.sd_name_blacklist, "System.Collections.Generic.List_EightGame.Data.Server.sd_name_blacklist", "ctor", {});
				end;
				local i; i = 0;
				while (i < blackList.Count) do
				local __compiler_continue_550 = false
				repeat
					local strname; strname = getexterninstanceindexer(blackList, nil, "get_Item", i).name;
					if (getforbasicvalue(strname, false, System.String, "Length") == 0) then
						__compiler_continue_550 = false;
						break;
					end;
					if invokeforbasicvalue(str, false, System.String, "Contains", strname) then
						str = invokeforbasicvalue(str, false, System.String, "Replace", strname, "***");
						param.replacedStr = str;
						param.sensitiveStr = strname;
						__compiler_continue_550 = true;
						break;
					end;
				until true;
				if __compiler_continue_550 then break; end;
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				return param;
			end,
			JudgeSendWorldLenght = function(this, obj, inputvalue)
				local b; b = false;
				if (obj ~= nil) then
					local itemName; itemName = System.String.Empty;
					if typeis(obj, EightGame.Data.Server.ItemSerData, false) then
						local serdata; serdata = typeas(obj, EightGame.Data.Server.ItemSerData, false);
						local item; item = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_item_item), serdata.staticId);
						if (item ~= nil) then
							itemName = item.name;
						end;
					elseif typeis(obj, EightGame.Data.Server.EquipmentSerData, false) then
						local serdata; serdata = typeas(obj, EightGame.Data.Server.EquipmentSerData, false);
						local equip; equip = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_equipment_equip), serdata.staticid);
						if (equip ~= nil) then
							itemName = equip.name;
						end;
					elseif typeis(obj, EightGame.Data.Server.FighterSerData, false) then
						local serdata; serdata = typeas(obj, EightGame.Data.Server.FighterSerData, false);
						local role; role = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_role_role), serdata.staticId);
						if (role ~= nil) then
							itemName = role.rolename;
						end;
					end;
					b = (( invokeintegeroperator(2, "+", getforbasicvalue(itemName, false, System.String, "Length"), getforbasicvalue(inputvalue, false, System.String, "Length"), System.Int32, System.Int32) ) <= this._fontCountLimit);
					if (not b) then
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(System.String.Format("输入的内容超过{0}个字符", this._fontCountLimit), 0.00);
					end;
				else
					b = (getforbasicvalue(inputvalue, false, System.String, "Length") <= this._fontCountLimit);
					if (not b) then
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(System.String.Format("输入的内容超过{0}个字符", this._fontCountLimit), 0.00);
					end;
				end;
				return b;
			end,
			AnalysisMsgContent = function(this, str)
				if System.String.IsNullOrEmpty(str) then
					return nil;
				end;
				local characterStr; characterStr = System.String.Empty;
				local itemContent; itemContent = System.String.Empty;
				local match; match = System.Text.RegularExpressions.Regex.Match(invokeforbasicvalue(str, false, System.String, "Trim"), "(.*)#c_begin(.+)#c_end(.*)");
				if (match.Groups.Count > 1) then
					characterStr = getexterninstanceindexer(match.Groups, nil, "get_Item", 1).Value;
					itemContent = getexterninstanceindexer(match.Groups, nil, "get_Item", 2).Value;
				else
					characterStr = str;
				end;
				local t; t = this:AnalysisURLContent(itemContent);
				if (t == nil) then
					t = newobject(ChatMsgURLContent, "ctor", nil);
				end;
				t.characterStr = characterStr;
				return t;
			end,
			AnalysisURLContent = function(this, str)
				if System.String.IsNullOrEmpty(str) then
					return nil;
				end;
				local contentArray; contentArray = invokeforbasicvalue(str, false, System.String, "Split", wraparray{"itemtype=", ","}, 1);
				local itemtype; itemtype = System.String.Empty;
				if (contentArray.Length > 0) then
					itemtype = contentArray[1];
				end;
				local t; t = newobject(ChatMsgURLContent, "ctor__System_String__System_Int32__System_Int64__System_String__System_String__System_String", nil, itemtype, 0, 0, System.String.Empty, System.String.Empty, "");
				local des; des = nil;
				if (t.itemtype == 1) then
					des = newobject(ChatItemDes, "ctor", nil);
				elseif (t.itemtype == 2) then
					des = newobject(ChatEquipmentDes, "ctor", nil);
				elseif (t.itemtype == 3) then
					des = newobject(ChatFighterDes, "ctor", nil);
				elseif (t.itemtype == 4) then
					des = newobject(ChatEmojiDes, "ctor", nil);
				end;
				if (des ~= nil) then
					t = des:AnalysSendStr(str);
				end;
				return t;
			end,
			ClearAllCachData = function(this)
				this._allChatMsgs:Clear();
				this._allPrivateChatMsgDic:Clear();
				this._allUnionChatmsgs:Clear();
				this._allSystemChatmsgs:Clear();
			end,
			GetColorByRank = function(this, rank)
				local colorStr; colorStr = "ffffff";
				local __compiler_switch_688 = rank;
				if __compiler_switch_688 == 1 then
					colorStr = "919191";
				elseif __compiler_switch_688 == 2 then
					colorStr = "5ac036";
				elseif __compiler_switch_688 == 3 then
					colorStr = "4c8cd3";
				elseif __compiler_switch_688 == 4 then
					colorStr = "d34c85";
				elseif __compiler_switch_688 == 5 then
					colorStr = "d34c4c";
				elseif __compiler_switch_688 == 6 then
					colorStr = "e2990c";
				end;
				return colorStr;
			end,
			ReceiveMessage = function(this, notify)
				local serdata; serdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
				if (serdata ~= nil) then
--自己发送的消息，由客户端模拟
					if (serdata.id == notify.playerid) then
						return ;
					end;
				end;
				if (notify.msgcontent.Length == 0) then
					return ;
				end;
--在入口处，过滤特殊字符操作
				local str; str = this:FifterString(System.Text.Encoding.UTF8:GetString(notify.msgcontent));
--过滤敏感字
				local param; param = this:ReplaceSendMsg(str);
				notify.msgcontent = System.Text.Encoding.UTF8:GetBytes(param.replacedStr);
				local msg; msg = newobject(ChatMessage, "ctor", nil);
				msg.playerid = notify.playerid;
				msg.chatTime = notify.chatTime;
				msg.chattype = notify.chattype;
				msg.assistFighterSkinId = notify.assistfighterskin;
				msg.msgcontent = notify.msgcontent;
				msg.playergender = notify.playergender;
				msg.playerLv = notify.playerlv;
				msg.playername = System.Text.Encoding.UTF8:GetString(notify.playername);
				msg.playerVipLv = notify.playerviplv;
				msg.guildPower = notify.power;
				this:AddChatMessage(msg);
			end,
			ReceiveSysMessage = function(this, notify)
				this._getChatSysMessageNotify = notify;
			end,
			GetChatSysMessageNotifyData = function(this)
				return this._getChatSysMessageNotify;
			end,
			ReceiveKeyWordMessage = function(this, notify)
				this._chatKeyWordNotify = notify;
				local str; str = System.Text.Encoding.UTF8:GetString(notify.keyword);
				this._keyWordArray = invokeforbasicvalue(str, false, System.String, "Split", wrapchar(',', 0x02C));
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_beginCoolDownChatLock = "Begin_CoolDown_ChatLock",
				_chatLockList = newexternlist(System.Collections.Generic.List_System.String, "System.Collections.Generic.List_System.String", "ctor", {}),
				CHAT_MSG_ADD = "CHAT_MSG_ADD",
				_allUnionChatmsgs = newexternlist(System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.List_ChatMessage", "ctor", {}),
				_allPrivateChatMsgDic = newexterndictionary(System.Collections.Generic.Dictionary_System.Int64_System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.Dictionary_System.Int64_System.Collections.Generic.List_ChatMessage", "ctor", {}),
				_allUnReadPrivateChatMsgDic = newexterndictionary(System.Collections.Generic.Dictionary_System.Int64_System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.Dictionary_System.Int64_System.Collections.Generic.List_ChatMessage", "ctor", {}),
				_allSystemChatmsgs = newexternlist(System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.List_ChatMessage", "ctor", {}),
				_allChatMsgs = newexternlist(System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.List_ChatMessage", "ctor", {}),
				_msgIntervalTime = 10000.00,
				_friendIntervalTime = 2000.00,
				_unionIntervalTime = 3000.00,
				_cachMsgCount = 100,
				_fontCountLimit = 40,
				_chatKeyWordNotify = __cs2lua_nil_field_value,
				_keyWordArray = __cs2lua_nil_field_value,
				_viewController = __cs2lua_nil_field_value,
				_viewPrefabPath = "ChatUI/MainChatViewPrefab",
				_updateLockTimeCallback = delegationwrap(),
				_getChatSysMessageNotify = __cs2lua_nil_field_value,
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


		return defineclass(Eight.Framework.EINode, "ChatMsgManager", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatMsgManager.__define_class();
