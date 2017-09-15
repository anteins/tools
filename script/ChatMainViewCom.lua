require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "ChatMsgManager";
require "EventDelegate";
require "Eight__Framework__EIFrameWork";
require "Eight__Framework__EIBoolEvent";
require "UITweener";
require "TweenPosition";
require "NGUITools";
require "ChatItemCom";
require "LogicStatic";
require "EightGame__Logic__FloatingTextTipUIRoot";
require "FunctionOpenUtility";
require "EightGame__Component__ServiceCenter";
require "EightGame__Component__ChatSerice";
require "EightGame__Component__GameResources";
require "UIDragScrollView";
require "GameUtility";
require "EightGame__Component__NetworkClient";
require "ChatMessage";
require "AlarmManager";
require "ListExtension";
require "SpringPanel";
require "UISprite";
require "ChatExplainController";

ChatMainViewCom = {
	__new_object = function(...)
		return newobject(ChatMainViewCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatMainViewCom;

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
			get_showFriend = function(this)
				return this._showFriend;
			end,
			set_showFriend = function(this, value)
				this._showFriend = value;
				this:SetChatFriendActive(this._showFriend);
			end,
			Init = function(this, callbackClickChatBtn)
				this._sendMsgLock = false;
				delegationset(false, false, "ChatMainViewCom:_callbackClickChatBtn", this, nil, "_callbackClickChatBtn", callbackClickChatBtn);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._openChatBtn, nil) then
					this._openChatBtn.gameObject:SetActive(false);
				end;
				this:SetChatViewActive(false);
				this:InitChatItemComList();
				delegationset(false, false, "UIRecycledList:onUpdateItem", this._uiRecycledList, nil, "onUpdateItem", (function() local __compiler_delegation_108 = (function(go, itemIndex, dataindex) this:OnUpdateItem(go, itemIndex, dataindex); end); setdelegationkey(__compiler_delegation_108, "ChatMainViewCom:OnUpdateItem", this, this.OnUpdateItem); return __compiler_delegation_108; end)());
				this:InitChannel();
				this:RegisterEvent();
				this:SetOpenChatBtnActive(false);
				this:SetOpenChatBtnRedActive((ChatMsgManager.Instance:GetUnReadPrivateMsgs().Count > 0));
			end,
			RegisterEvent = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._openChatBtn, nil) then
					EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this._openChatBtn.onClick, (function() local __compiler_delegation_118 = (function() this:ClickOpenChatBtn(); end); setdelegationkey(__compiler_delegation_118, "ChatMainViewCom:ClickOpenChatBtn", this, this.ClickOpenChatBtn); return __compiler_delegation_118; end)());
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._showBtn, nil) then
					EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this._showBtn.onClick, (function() local __compiler_delegation_119 = (function() this:CallbackClickShowBtn(); end); setdelegationkey(__compiler_delegation_119, "ChatMainViewCom:CallbackClickShowBtn", this, this.CallbackClickShowBtn); return __compiler_delegation_119; end)());
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._closeBtn, nil) then
					EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this._closeBtn.onClick, (function() local __compiler_delegation_120 = (function() this:CallbackClickCloseBtn(); end); setdelegationkey(__compiler_delegation_120, "ChatMainViewCom:CallbackClickCloseBtn", this, this.CallbackClickCloseBtn); return __compiler_delegation_120; end)());
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._emonticonBtn, nil) then
					EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this._emonticonBtn.onClick, (function() local __compiler_delegation_121 = (function() this:CallbackClickEmonticonBtn(); end); setdelegationkey(__compiler_delegation_121, "ChatMainViewCom:CallbackClickEmonticonBtn", this, this.CallbackClickEmonticonBtn); return __compiler_delegation_121; end)());
				end;
--if( _uiInput != null )	EventDelegate.Set( _uiInput.onSubmit , OnSubmitBtn );
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._sendBtn, nil) then
					EventDelegate.Set__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this._sendBtn.onClick, (function() local __compiler_delegation_123 = (function() this:OnSubmitBtn(); end); setdelegationkey(__compiler_delegation_123, "ChatMainViewCom:OnSubmitBtn", this, this.OnSubmitBtn); return __compiler_delegation_123; end)());
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._uiInput, nil) then
					this._uiInput.characterLimit = ChatMsgManager.Instance._cachMsgCount;
				end;
			end,
			OnSubmitBtn = function(this)
				if (not ChatMsgManager.Instance:JudgeSendCondition(nil, this._uiInput.value)) then
					return ;
				end;
				this:ClearSendMsg();
				this:UpdateSendMsg(System.String.Empty);
				this:SendMsg();
			end,
			ClickOpenChatBtn = function(this)
--EIFrameWork.Instance.DispatchEvent( new EIBoolEvent ( ChatMsgManager.SHOW_CHAT_VIEW , true));
				if externdelegationcomparewithnil(false, false, "ChatMainViewCom:_callbackClickChatBtn", this, nil, "_callbackClickChatBtn", false) then
					this._callbackClickChatBtn();
				end;
			end,
			SetOpenChatBtnActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._openChatBtn, nil) then
					return ;
				end;
				this._openChatBtn.gameObject:SetActive(b);
			end,
			SetOpenChatBtnRedActive = function(this, b)
--红点
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._openChatBtn, nil) then
					return ;
				end;
				local gotr; gotr = this._openChatBtn.transform:FindChild("PointSprite");
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", gotr, nil) then
					return ;
				end;
				gotr.gameObject:SetActive(b);
			end,
			CloseChat = function(this)
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, "SET_CLUB_CAMERA", false));
				this:SetOpenChatBtnActive(false);
				this:SetChatViewActive(false);
				this:ChatViewMoveInOut(false);
				this:SetChatExplainActive(false);
--UnRegisterEvent();
			end,
			OpenChatView = function(this)
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, "SET_CLUB_CAMERA", true));
				this._sendMsgLock = false;
				this:SetChatViewActive(true);
				this:SetOpenChatBtnActive(false);
				this:ChatViewMoveInOut(true);
				this:SetEmojiBtnState();
				this._getChatSysMessageNotify = ChatMsgManager.Instance:GetChatSysMessageNotifyData();
				if (this._getChatSysMessageNotify ~= nil) then
					if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._latestChanelCom, nil) then
						this._latestChanelCom:SetBgSprite(false);
						this._latestChanelCom = nil;
					end;
					local com; com = this:GetChannelComByEnum(se_chattype.SE_CHATTYPE_CHATWORLD );
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", com, nil) then
						return ;
					end;
					this:CallbackSelectChannel(com);
					com:SetChannelLbl(System.String.Format("世界频道CH.{0}", this._getChatSysMessageNotify.chanelId));
					this:SetCurActionLbl(System.String.Format("[{0}]世界频道-[-][{1}]CH.{2}", "FFD988", "5CF5FF", this._getChatSysMessageNotify.chanelId));
					local priCom; priCom = this:GetChannelComByEnum(se_chattype.SE_CHATTYPE_CHATPRIVATE );
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", priCom, nil) then
						return ;
					end;
					priCom:SetUnreadSpriteActive((ChatMsgManager.Instance:GetUnReadPrivateMsgs().Count > 0));
				end;
--		EIFrameWork.Instance.RemoveEventListener( ChatMsgManager.Instance.CHAT_MSG_ADD );
--		EIFrameWork.Instance.RemoveEventListener  (ChatExplainController.CLICK_CHATEXPLAIN_ACTION);
--		EIFrameWork.Instance.AddEventListener( ChatMsgManager.Instance.CHAT_MSG_ADD , ListenerMsgAdd );
--		EIFrameWork.Instance.AddEventListener(ChatExplainController.CLICK_CHATEXPLAIN_ACTION  , ClickChatExplainAction);
			end,
			ChatViewMoveInOut = function(this, moveIn)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatView, nil) then
					return ;
				end;
				local twp; twp = UITweener.Begin(TweenPosition, this._chatView.gameObject, 0.30);
				if moveIn then
					twp.from = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -678.50, -562.00, 0);
					twp.to = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 0, -562.00, 0);
				else
					twp.from = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 0, -562.00, 0);
					twp.to = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -678.50, -562.00, 0);
				end;
				twp:Play();
			end,
			InitChannel = function(this)
				if (this._cacheChatChannelList.Count > 0) then
					local enumlist; enumlist = ChatMsgManager.Instance:GetAllChatChannels();
					local index; index = 0;
					while (index < this._cacheChatChannelList.Count) do
						if (index < enumlist.Count) then
							getexterninstanceindexer(this._cacheChatChannelList, nil, "get_Item", index).gameObject:SetActive(true);
							getexterninstanceindexer(this._cacheChatChannelList, nil, "get_Item", index):SetData(getexterninstanceindexer(enumlist, nil, "get_Item", index), (function() local __compiler_delegation_243 = (function(channelcom) this:CallbackSelectChannel(channelcom); end); setdelegationkey(__compiler_delegation_243, "ChatMainViewCom:CallbackSelectChannel", this, this.CallbackSelectChannel); return __compiler_delegation_243; end)());
						else
							getexterninstanceindexer(this._cacheChatChannelList, nil, "get_Item", index).gameObject:SetActive(false);
						end;
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				end;
			end,
			InitChatItemComList = function(this)
				if (this._applicationItemDic.Count == 0) then
					local index; index = 0;
					while (index < 10) do
						local go; go = NGUITools.AddChild__UnityEngine_GameObject__UnityEngine_GameObject(NGUITools, this._uiRecycledList.gameObject, this._chatItemPrefab.gameObject);
						local com; com = go:GetComponent(ChatItemCom);
						this._applicationItemDic:Add(go, com);
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				end;
			end,
			CallbackSelectChannel = function(this, channelcom)
				if (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATUNION ) then
					local notify; notify = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil);
					if (notify == nil) then
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("请先加入冒险团", 0.00);
						return ;
					end;
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._latestChanelCom, nil) then
					if (this._latestChanelCom._chatChannelEnum == channelcom._chatChannelEnum) then
						if ((channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATWORLD) or (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATUNION )) then
							local condition; condition = ((not ChatMsgManager.Instance:GetCanChatLock(channelcom._chatChannelEnum)) and this:CheckPreCondition(false));
							if condition then
								this:SetInputDefaultLbl(System.String.Format("请点击输入"));
							else
								local cTips; cTips = System.String.Empty;
								if (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATWORLD ) then
									cTips = FunctionOpenUtility.GetUnopenTip(se_functiontype.SE_FUNCTIONTYPE_CHAT_WORLD_MODULE );
								else
									cTips = FunctionOpenUtility.GetUnopenTip(se_functiontype.SE_FUNCTIONTYPE_CHAT_UNION_MODULE);
								end;
								this:SetInputDefaultLbl(cTips);
							end;
							if (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATWORLD) then
								this._getChatSysMessageNotify = ChatMsgManager.Instance:GetChatSysMessageNotifyData();
								this:SetChatWorldActive(true);
								if (this._getChatSysMessageNotify == nil) then
									return ;
								end;
								this._chatWorldChanelController:SetData(this._getChatSysMessageNotify, (function() local __compiler_delegation_316 = (function(msg) this:CallbackSelectWorldChanel(msg); end); setdelegationkey(__compiler_delegation_316, "ChatMainViewCom:CallbackSelectWorldChanel", this, this.CallbackSelectWorldChanel); return __compiler_delegation_316; end)());
								this:SetInputEnable(condition);
							end;
						elseif (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
							if (this._curFriendSerData ~= nil) then
								this.showFriend = (not this.showFriend);
								if this.showFriend then
									this._chatFriendPanelController:SetData((function() local __compiler_delegation_327 = (function(friendSerdata) this:CallbackFriendItem(friendSerdata); end); setdelegationkey(__compiler_delegation_327, "ChatMainViewCom:CallbackFriendItem", this, this.CallbackFriendItem); return __compiler_delegation_327; end)(), (function() local __compiler_delegation_327 = (function() this:CallbackCloseFriend(); end); setdelegationkey(__compiler_delegation_327, "ChatMainViewCom:CallbackCloseFriend", this, this.CallbackCloseFriend); return __compiler_delegation_327; end)());
								else
									this:CallbackFriendItem(this._curFriendSerData);
								end;
								return ;
							else
								this:SetChatFriendActive(true);
								this._chatFriendPanelController:SetData((function() local __compiler_delegation_338 = (function(friendSerdata) this:CallbackFriendItem(friendSerdata); end); setdelegationkey(__compiler_delegation_338, "ChatMainViewCom:CallbackFriendItem", this, this.CallbackFriendItem); return __compiler_delegation_338; end)(), (function() local __compiler_delegation_338 = (function() this:CallbackCloseFriend(); end); setdelegationkey(__compiler_delegation_338, "ChatMainViewCom:CallbackCloseFriend", this, this.CallbackCloseFriend); return __compiler_delegation_338; end)());
							end;
							local condition; condition = this:CheckPreCondition(false);
							if condition then
								if (this._curFriendSerData ~= nil) then
									this:SetInputDefaultLbl(System.String.Format("请点击输入"));
									this:SetInputEnable(condition);
								else
									this:SetInputDefaultLbl(System.String.Format("请先选择好友"));
									this:SetInputEnable(false);
								end;
							else
								this:SetInputDefaultLbl(System.String.Format(FunctionOpenUtility.GetUnopenTip(se_functiontype.SE_FUNCTIONTYPE_CHAT_FRIEND_MODULE )));
								this:SetInputEnable(condition);
							end;
						elseif (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATSYSTEM ) then
							this:UpdateAllChatMsgs(0);
							this:SetInputDefaultLbl(System.String.Format("[ff6767]该频道不能发言"));
							this:RecycledListMoveTo();
							this:SetInputEnable(false);
						end;
					else
						this._latestChanelCom:SetBgSprite(false);
					end;
				end;
				this._latestChanelCom = channelcom;
				this._currentChanelEnum = channelcom._chatChannelEnum;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._latestChanelCom, nil) then
					this._latestChanelCom:SetBgSprite(true);
				end;
--先清除先前的聊天记录
				this._allChatMessage:Clear();
				this:SetInputEnable(false);
--切换频道时，把当前的私聊好友信息清掉
				if ((this._curFriendSerData ~= nil) and (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATPRIVATE )) then
					ChatMsgManager.Instance:ClearUnReadPrivateChatMsg(this._curFriendSerData.fid);
				end;
				if (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATSYSTEM  ) then
					this:SetShowPanelActive(false);
					this:UpdateAllChatMsgs(0);
					this:RecycledListMoveTo();
					this:SetCurActionLbl(System.String.Format("[{0}]系统频道[-]", "FFD988"));
					this:SetInputDefaultLbl(System.String.Format("[ff6767]该频道不能发言"));
					this:SetInputEnable(false);
				elseif (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					local condition; condition = this:CheckPreCondition(false);
					if condition then
						if (this._curFriendSerData ~= nil) then
							this:SetInputDefaultLbl(System.String.Format("请点击输入"));
							this:SetInputEnable(condition);
						else
							this:SetInputDefaultLbl(System.String.Format("请先选择好友"));
							this:SetInputEnable(false);
						end;
					else
						this:SetInputDefaultLbl(FunctionOpenUtility.GetUnopenTip(se_functiontype.SE_FUNCTIONTYPE_CHAT_FRIEND_MODULE ));
						this:SetInputEnable(condition);
					end;
					if (this._curFriendSerData ~= nil) then
						this:CallbackFriendItem(this._curFriendSerData);
						this:SetCurActionLbl(System.String.Format("[{0}]私聊频道-[-][{1}]{2}[-]", "FFD988", "5CF5FF", this._curFriendSerData.name));
					else
						this.showFriend = true;
						this._chatFriendPanelController:SetData((function() local __compiler_delegation_434 = (function(friendSerdata) this:CallbackFriendItem(friendSerdata); end); setdelegationkey(__compiler_delegation_434, "ChatMainViewCom:CallbackFriendItem", this, this.CallbackFriendItem); return __compiler_delegation_434; end)(), (function() local __compiler_delegation_434 = (function() this:CallbackCloseFriend(); end); setdelegationkey(__compiler_delegation_434, "ChatMainViewCom:CallbackCloseFriend", this, this.CallbackCloseFriend); return __compiler_delegation_434; end)());
						this:RecycledListMoveTo();
						this:SetCurActionLbl(System.String.Format("[{0}]私聊频道-请选择好友[-]", "FFD988"));
					end;
				elseif ((channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATWORLD ) or (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATUNION)) then
					this._getChatSysMessageNotify = ChatMsgManager.Instance:GetChatSysMessageNotifyData();
					this:UpdateAllChatMsgs(0);
					this:RecycledListMoveTo();
					if (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATWORLD ) then
						this:SetCurActionLbl(System.String.Format("[{0}]世界频道-[-][{1}]CH.{2}", "FFD988", "5CF5FF", this._getChatSysMessageNotify.chanelId));
					elseif (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATUNION ) then
						this:SetCurActionLbl(System.String.Format("[{0}]冒险团聊天[-]", "FFD988"));
						ChatMsgManager.CheckGuildNotice();
					end;
					local b; b = ((not ChatMsgManager.Instance:GetCanChatLock(channelcom._chatChannelEnum)) and this:CheckPreCondition(false));
					if b then
						this:SetInputDefaultLbl(System.String.Format("请点击输入"));
					else
						local cTips; cTips = System.String.Empty;
						if (channelcom._chatChannelEnum == se_chattype.SE_CHATTYPE_CHATWORLD ) then
							cTips = FunctionOpenUtility.GetUnopenTip(se_functiontype.SE_FUNCTIONTYPE_CHAT_WORLD_MODULE );
						else
							cTips = FunctionOpenUtility.GetUnopenTip(se_functiontype.SE_FUNCTIONTYPE_CHAT_UNION_MODULE);
						end;
						this:SetInputDefaultLbl(cTips);
					end;
					this:SetInputEnable(b);
				end;
			end,
			GetChatSysMessageByChanid = function(this, chanid)
				local index; index = 0;
				while (index < this._getChatSysMessageNotify.msgList.Count) do
					if (getexterninstanceindexer(this._getChatSysMessageNotify.msgList, nil, "get_Item", index).word_room_id == chanid) then
						return getexterninstanceindexer(this._getChatSysMessageNotify.msgList, nil, "get_Item", index);
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				return nil;
			end,
			UpdateAllChatMsgs = function(this, friendId)
				this._allChatMessage:Clear();
				this._allChatMessage:AddRange(ChatMsgManager.Instance:GetAllChatMessageByChannel(this._currentChanelEnum, friendId));
			end,
			CallbackCloseFriend = function(this)
				this._showFriend = false;
			end,
			CallbackSelectWorldChanel = function(this, msg)
--如果跟当前所在的世界频道不一致，需要重新
				if (msg.word_room_id == this._getChatSysMessageNotify.chanelId) then
					return ;
				end;
--		if( msg.chat_statue == 100 )
--		{
--			FloatingTextTipUIRoot.SetFloattingTip( "该频道已满，请选择另外的频道" );
--			return ;
--		}
				if this._lockChangeWorldChannel then
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("请稍后", 0.00);
					return ;
				end;
				this._lockChangeWorldChannel = true;
				local param; param = newexternobject(EightGame.Data.Server.ChatChangeWorldChanelParam, "EightGame.Data.Server.ChatChangeWorldChanelParam", "ctor", nil);
				param.chanelId = msg.word_room_id;
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ChatSerice);
				srv:ChangeWorldChanel(param, (function(obj)
					this._lockChangeWorldChannel = false;
					if (typecast(obj, System.Int32, false) ~= 200) then
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(EightGame.Component.NetCode.GetDesc(typecast(obj, System.Int32, false)), 0.00);
						return ;
					end;
					ChatMsgManager.Instance:ClearWorldChannelMsg();
					this:UpdateAllChatMsgs(0);
					this:RecycledListMoveTo();
					local com; com = this:GetChannelComByEnum(se_chattype.SE_CHATTYPE_CHATWORLD );
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", com, nil) then
						return ;
					end;
					com:SetChannelLbl(System.String.Format("世界频道CH.{0}", msg.word_room_id));
					this:SetCurActionLbl(System.String.Format("[{0}]世界频道-[-][{1}]CH.{2}", "FFD988", "5CF5FF", msg.word_room_id));
					this:SetChatWorldActive(false);
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(System.String.Format("进入CH.{0}成功", msg.word_room_id), 0.00);
				end), nil);
			end,
			CallbackFriendItem = function(this, friendSerdata)
				local com; com = this:GetChannelComByEnum(se_chattype.SE_CHATTYPE_CHATPRIVATE );
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", com, nil) then
					return ;
				end;
				this._curFriendSerData = friendSerdata;
				com:SetChannelLbl(friendSerdata.name);
				this.showFriend = false;
				this:UpdateAllChatMsgs(friendSerdata.fid);
				this:RecycledListMoveTo();
				this:SetInputEnable(this:CheckPreCondition(false));
				local b; b = (ChatMsgManager.Instance:GetUnReadPrivateMsgs().Count > 0);
				com:SetUnreadSpriteActive(b);
				this:SetOpenChatBtnRedActive(b);
				this:SetInputDefaultLbl("请点击输入");
				this:SetCurActionLbl(System.String.Format("[{0}]私聊频道-[-][{1}]{2}[-]", "FFD988", "5CF5FF", friendSerdata.name));
			end,
			GetChannelComByEnum = function(this, cEnum)
				local com; com = nil;
				local index; index = 0;
				while (index < this._cacheChatChannelList.Count) do
					if (getexterninstanceindexer(this._cacheChatChannelList, nil, "get_Item", index)._chatChannelEnum == cEnum) then
						com = getexterninstanceindexer(this._cacheChatChannelList, nil, "get_Item", index);
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				return com;
			end,
			SetChatFriendActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatFriendPanelController, nil) then
					return ;
				end;
				this._chatFriendPanelController.gameObject:SetActive(b);
			end,
			SetChatWorldActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatWorldChanelController, nil) then
					return ;
				end;
				this._chatWorldChanelController.gameObject:SetActive(b);
			end,
			InitChatData = function(this)
			end,
			LoadPrefab = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatItemPrefab, nil) then
					local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(System.String.Format("{0}{1}", "GameAssets/Prefabs/UI/", this._chatItemPrefabPath), "prefab", false);
					wrapyield(coroutine.coroutine, false, true);
					this._chatItemPrefab = typeas(coroutine.res, UnityEngine.GameObject, false);
				end;
			end),
			OnUpdateItem = function(this, go, itemIndex, dataindex)
				NGUITools.AddMissingComponent(go, UIDragScrollView);
				NGUITools.AddWidgetCollider__UnityEngine_GameObject(go);
				local box; box = NGUITools.AddMissingComponent(go, typeof(UnityEngine.BoxCollider));
				box.size = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 600.00, 100.00, 0);
				local com; com = nil;
				local __compiler_invoke_620; __compiler_invoke_620, com = this._applicationItemDic:TryGetValue(go);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", com, nil) then
					if (dataindex < this._allChatMessage.Count) then
						com:SetData(getexterninstanceindexer(this._allChatMessage, nil, "get_Item", dataindex), (function() local __compiler_delegation_625 = (function(msg) this:CallbackClickLbl(msg); end); setdelegationkey(__compiler_delegation_625, "ChatMainViewCom:CallbackClickLbl", this, this.CallbackClickLbl); return __compiler_delegation_625; end)(), (function() local __compiler_delegation_625 = (function(com) this:CallbackClickChatTextrue(com); end); setdelegationkey(__compiler_delegation_625, "ChatMainViewCom:CallbackClickChatTextrue", this, this.CallbackClickChatTextrue); return __compiler_delegation_625; end)());
					end;
				end;
			end,
			CallbackClickChatTextrue = function(this, com)
				local playerserdata; playerserdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
				if (com._chatmsg.playerid == playerserdata.id) then
					return ;
				end;
				if (com._chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATSYSTEM ) then
					return ;
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._chatSubBtnController, nil) then
					this._chatSubBtnController:SetData(com, (function() local __compiler_delegation_638 = (function(param) this:CallbackSelectSubBtn(param); end); setdelegationkey(__compiler_delegation_638, "ChatMainViewCom:CallbackSelectSubBtn", this, this.CallbackSelectSubBtn); return __compiler_delegation_638; end)());
				end;
			end,
			CallbackSelectSubBtn = function(this, param)
				if (param.chatsubtype == 1) then
					local friendSerData; friendSerData = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.FriendSerData), param._friendId);
					if (friendSerData ~= nil) then
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("已经是好友", 0.00);
						return ;
					end;
					local playerserdata; playerserdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
					GameUtility.ApplyFriendsFromBattleOver(playerserdata.id, param._friendId, param.friendName, nil);
				elseif (param.chatsubtype == 2) then
					local friendSerData; friendSerData = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.FriendSerData), (function(F) return (F.fid == param._friendId); end));
					if (friendSerData == nil) then
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("还不是好友", 0.00);
						return ;
					end;
					this._curFriendSerData = friendSerData;
					local com; com = this:GetChannelComByEnum(se_chattype.SE_CHATTYPE_CHATPRIVATE);
					this:CallbackSelectChannel(com);
				end;
				this:SetChatSubGroupActive(false);
			end,
			CallbackClickLbl = function(this, msg)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatExplainController, nil) then
					return ;
				end;
				if (msg == nil) then
					return ;
				end;
				if (msg.itemtype == 1) then
--普通物品
					this:SetChatExplainActive(true);
					local item; item = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_item_item), msg.itemstiticid);
					local serdata; serdata = newexternobject(EightGame.Data.Server.ItemSerData, "EightGame.Data.Server.ItemSerData", "ctor", nil);
					serdata.id = 0;
					serdata.staticId = item.id;
					serdata.number = 1;
					this._chatExplainController:SetData__EightGame_Data_Server_ItemSerData(serdata);
				elseif (msg.itemtype == 2) then
--装备
--请求服务器获取相应的装备数据，跟在reponse中带回来
--装备
--请求服务器获取相应的装备数据，跟在reponse中带回来
					local action; action = EightGame.Data.Server.ServerService.ChatcheckequipmentMethod(msg.itemGid);
					Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.NetworkClient):NetworkRequest(action, (function(returnCode, response)
						if (returnCode ~= 200) then
							EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(EightGame.Component.NetCode.GetDesc(returnCode), 0.00);
							return ;
						end;
						this:SetChatExplainActive(true);
						local r; r = typeas(response, EightGame.Data.Server.ChatCheckEquipmentReponse, false);
						local serdata; serdata = r.serdata;
						this._chatExplainController:SetData__EightGame_Data_Server_EquipmentSerData(serdata);
					end), true, false);
				elseif (msg.itemtype == 3) then
--角色
				end;
			end,
			CallbackClickEmonticonBtn = function(this)
				this._chatEmojiItemCom = nil;
				if this._chatEmojiPanelController.gameObject.activeSelf then
					this._chatEmojiPanelController.gameObject:SetActive(false);
				else
					this._chatEmojiPanelController.gameObject:SetActive(true);
					this._chatEmojiPanelController:SetData((function() local __compiler_delegation_725 = (function(com) this:CallbackSelectEmoji(com); end); setdelegationkey(__compiler_delegation_725, "ChatMainViewCom:CallbackSelectEmoji", this, this.CallbackSelectEmoji); return __compiler_delegation_725; end)());
				end;
--关闭物品展示
				this:SetShowPanelActive(false);
			end,
			CallbackSelectEmoji = function(this, com)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatEmojiItemCom, com) then
--发送消息
					this:ClearSendMsg();
					local str; str = ChatMsgManager.Instance:JoinItemContent(com._chatemoji);
					this._sendMsg = str;
					this:SendMsg();
					this._chatEmojiItemCom = nil;
					return ;
				end;
				this._chatEmojiItemCom = com;
			end,
			CallbackClickShowBtn = function(this)
				this._selectItem = nil;
				if this._chatShowPanelController.gameObject.activeSelf then
					this:SetShowPanelActive(false);
				else
					this:SetShowPanelActive(true);
					if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._chatShowPanelController, nil) then
						this._chatShowPanelController:SetData((function() local __compiler_delegation_762 = (function(obj) this:CallbackSelectItem(obj); end); setdelegationkey(__compiler_delegation_762, "ChatMainViewCom:CallbackSelectItem", this, this.CallbackSelectItem); return __compiler_delegation_762; end)());
					end;
				end;
				this._chatEmojiPanelController.gameObject:SetActive(false);
			end,
			CallbackClickCloseBtn = function(this)
				if externdelegationcomparewithnil(false, false, "ChatMainViewCom:_callbackClickChatBtn", this, nil, "_callbackClickChatBtn", false) then
					this._callbackClickChatBtn();
				end;
			end,
			SetShowPanelActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatShowPanelController, nil) then
					return ;
				end;
				this._chatShowPanelController.gameObject:SetActive(b);
			end,
			SendMsg = function(this)
				if (not this:CheckPreCondition(true)) then
					this:ResetSendMsg();
					return ;
				end;
				if System.String.IsNullOrEmpty(this._sendMsg) then
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("不能发送空消息", 0.00);
					this:ResetSendMsg();
					return ;
				end;
				local bytes; bytes = System.Text.Encoding.UTF8:GetBytes(this._sendMsg);
				if (bytes.Length == 0) then
					this:ResetSendMsg();
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("不能发送空消息", 0.00);
					return ;
				end;
				local friendId; friendId = 0;
				if (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					if (this._curFriendSerData ~= nil) then
						friendId = this._curFriendSerData.fid;
					end;
				elseif (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATSYSTEM ) then
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("[ff6767]该频道不能发言", 0.00);
					return ;
				end;
				if ChatMsgManager.Instance:GetCanChatLock(this._currentChanelEnum) then
					this:SetInputFocus(false);
					return ;
				end;
--去掉颜色值，替换掉敏感词
				local fifter; fifter = ChatMsgManager.Instance:FifterString(this._sendMsg);
				local sensitiveParam; sensitiveParam = ChatMsgManager.Instance:ReplaceSendMsg(fifter);
				local fifterStr; fifterStr = System.Text.Encoding.UTF8:GetBytes(sensitiveParam.replacedStr);
				if (fifterStr.Length == 0) then
					this:ResetSendMsg();
					EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("不能发送空消息", 0.00);
					return ;
				end;
				local playerserdata; playerserdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
				local guildPower; guildPower = 0;
				if (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATUNION ) then
					local guildData; guildData = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.MemberDataNotify), playerserdata.id);
					if (guildData ~= nil) then
						guildPower = guildData.privilege;
					end;
				end;
				local msg; msg = newobject(ChatMessage, "ctor", nil);
				msg.playerid = playerserdata.id;
				msg.playerLv = playerserdata.level;
				msg.playerVipLv = playerserdata.vipLv;
				msg.chattype = this._currentChanelEnum;
				msg.chatTime = UnityEngine.Mathf.CeilToInt((AlarmManager.Instance:currentTimeMillis() / 1000.00));
				msg.msgcontent = fifterStr;
				msg.playergender = condexp((playerserdata.sex == 1), true, true, true, false);
				msg.playername = System.Text.Encoding.UTF8:GetString(playerserdata.name);
				msg.sensitiveWord = System.Text.Encoding.UTF8:GetBytes(sensitiveParam.sensitiveStr);
				msg.guildPower = guildPower;
				local myassistSerdata; myassistSerdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.MyAssistSerData), nil);
				local skinid; skinid = 0;
				if (myassistSerdata ~= nil) then
					local fighterSerData; fighterSerData = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.FighterSerData), myassistSerdata.Fighteriid);
					if (fighterSerData ~= nil) then
						local skin; skin = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_role_skin), fighterSerData.skin);
						if (skin ~= nil) then
							skinid = skin.id;
						end;
					end;
				end;
				msg.assistFighterSkinId = skinid;
				if (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					if (this._curFriendSerData ~= nil) then
						msg.toplayerid = this._curFriendSerData.fid;
					else
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("请选择好友", 0.00);
						return ;
					end;
				end;
				local request; request = newexternobject(EightGame.Data.Server.SendChatMsgRequest, "EightGame.Data.Server.SendChatMsgRequest", "ctor", nil);
				request.chattype = this._currentChanelEnum;
				request.friendid = friendId;
				request.msgcontent = System.Text.Encoding.UTF8:GetBytes(fifter);
				request.sensitiveord = System.Text.Encoding.UTF8:GetBytes(sensitiveParam.sensitiveStr);
				request.hadkeyword = ChatMsgManager.Instance:FifterKeyWord(fifter, this._currentChanelEnum);
				this:ClearSendMsg();
				this:SetInputLbl(System.String.Empty);
				this:SetInputEnable(false);
				if this._sendMsgLock then
					return ;
				end;
				this._sendMsgLock = true;
--发送消息
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ChatSerice);
				srv:SendMessage(request, (function(obj)
					this._sendMsgLock = false;
					if (typecast(obj, System.Int32, false) ~= 200) then
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip(EightGame.Component.NetCode.GetDesc(typecast(obj, System.Int32, false)), 0.00);
						return ;
					end;
					ChatMsgManager.Instance:BeginCoolDownChatLock(this._currentChanelEnum, (function(callbackChattype, obj1)
						if ((callbackChattype == se_chattype.SE_CHATTYPE_CHATWORLD ) and (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATWORLD)) then
							if ChatMsgManager.Instance:GetCanChatLock(se_chattype.SE_CHATTYPE_CHATWORLD) then
								local remaintime; remaintime = UnityEngine.Mathf.CeilToInt((obj1 / 1000.00));
								this:SetInputDefaultLbl(System.String.Format("[ff6767]{0}秒[-]后可以发言", remaintime));
							end;
						end;
						if ((callbackChattype == se_chattype.SE_CHATTYPE_CHATUNION ) and (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATUNION )) then
							if ChatMsgManager.Instance:GetCanChatLock(se_chattype.SE_CHATTYPE_CHATUNION) then
								local remaintime; remaintime = UnityEngine.Mathf.CeilToInt((obj1 / 1000.00));
								this:SetInputDefaultLbl(System.String.Format("[ff6767]{0}秒[-]后可以发言", remaintime));
							end;
						end;
						if ((callbackChattype == se_chattype.SE_CHATTYPE_CHATPRIVATE ) and (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATPRIVATE )) then
							if ChatMsgManager.Instance:GetCanChatLock(se_chattype.SE_CHATTYPE_CHATPRIVATE) then
								local remaintime; remaintime = UnityEngine.Mathf.CeilToInt((obj1 / 1000.00));
								this:SetInputDefaultLbl(System.String.Format("[ff6767]{0}秒[-]后可以发言", remaintime));
							end;
						end;
					end), (function(finishChattype)
						this:SetInputEnable(this:CheckPreCondition(false));
						if (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATSYSTEM ) then
							return ;
						end;
						this:SetInputDefaultLbl(System.String.Format("请点击输入"));
					end));
--_sendMsg = string.Empty;
					ChatMsgManager.Instance:AddChatMessage(msg);
				end), nil);
			end,
			ResetSendMsg = function(this)
				this:ClearSendMsg();
				this._uiInput.value = System.String.Empty;
				this._uiInput:RemoveFocus();
			end,
			ListenerMsgAdd = function(this, e)
				local chatmsg; chatmsg = typeas(e.extraInfo, ChatMessage, false);
				if (not this._chatView.activeSelf) then
					local b; b = (ChatMsgManager.Instance:GetUnReadPrivateMsgs().Count > 0);
					this:SetOpenChatBtnRedActive(b);
					return ;
				end;
				if (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATWORLD ) then
					if ((chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATWORLD ) or (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATSYSTEM )) then
						ListExtension.Push(this._allChatMessage, ChatMessage, chatmsg);
						if (this._allChatMessage.Count > ChatMsgManager.Instance._cachMsgCount) then
							ListExtension.DequeueHead(this._allChatMessage, ChatMessage);
						end;
						this:UpdateChatList();
					end;
				elseif (chatmsg.chattype == this._currentChanelEnum) then
					if (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
						if (this._curFriendSerData ~= nil) then
							if ((chatmsg.toplayerid == this._curFriendSerData.fid) or (chatmsg.playerid == this._curFriendSerData.fid)) then
								ListExtension.Push(this._allChatMessage, ChatMessage, chatmsg);
								if (this._allChatMessage.Count > ChatMsgManager.Instance._cachMsgCount) then
									ListExtension.DequeueHead(this._allChatMessage, ChatMessage);
								end;
								this:UpdateChatList();
							end;
						end;
					else
						ListExtension.Push(this._allChatMessage, ChatMessage, chatmsg);
						if (this._allChatMessage.Count > ChatMsgManager.Instance._cachMsgCount) then
							ListExtension.DequeueHead(this._allChatMessage, ChatMessage);
						end;
						this:UpdateChatList();
					end;
				end;
				if (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					if (this._currentChanelEnum ~= se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
						local com; com = this:GetChannelComByEnum(se_chattype.SE_CHATTYPE_CHATPRIVATE );
						local b; b = (ChatMsgManager.Instance:GetUnReadPrivateMsgs().Count > 0);
						if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", com, nil) then
							com:SetUnreadSpriteActive(b);
						end;
						this:SetOpenChatBtnRedActive(b);
					else
						if (this._curFriendSerData ~= nil) then
							if ((chatmsg.playerid ~= this._curFriendSerData.fid) and (chatmsg.toplayerid ~= this._curFriendSerData.fid)) then
								local com; com = this:GetChannelComByEnum(se_chattype.SE_CHATTYPE_CHATPRIVATE );
								local b; b = (ChatMsgManager.Instance:GetUnReadPrivateMsgs().Count > 0);
								if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", com, nil) then
									com:SetUnreadSpriteActive(b);
								end;
								this:SetOpenChatBtnRedActive(b);
							else
								ChatMsgManager.Instance:ClearUnReadPrivateChatMsg(this._curFriendSerData.fid);
							end;
						end;
					end;
				end;
			end,
			UpdateChatList = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._uiRecycledList, nil) then
					local needMove; needMove = (this._uiRecycledList.publicdatacount ~= this._allChatMessage.Count);
					this._uiRecycledList:UpdateDataCount(this._allChatMessage.Count, (this._allChatMessage.Count < 7));
					if ((this._allChatMessage.Count > 7) and needMove) then
						local index; index = invokeintegeroperator(3, "-", this._allChatMessage.Count, 7, System.Int32, System.Int32);
						SpringPanel.Begin(this._uiRecycledList.Panel.gameObject, newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 0, (this._uiRecycledList.Panel.transform.localPosition.y + this._uiRecycledList.itemSize), 0), 6.00);
--				if( _chatItemScrollow != null )
--				{
--					_chatItemScrollow.panel.transform.localPosition = new Vector3( 0,_chatItemScrollow.panel.transform.localPosition.y +120f,0 );
--					_chatItemScrollow.panel.clipOffset = new Vector2( _chatItemScrollow.panel.clipOffset.x ,_chatItemScrollow.panel.clipOffset.y -120f );
--				}
					end;
				end;
			end,
			SetInputLbl = function(this, valuestr)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._uiInput, nil) then
					return ;
				end;
				this._uiInput.value = valuestr;
			end,
			SetInputDefaultLbl = function(this, defaultStr)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._uiInput, nil) then
					return ;
				end;
				this:SetInputLbl(System.String.Empty);
				this._uiInput.defaultText = System.String.Format("[B7B3B1]{0}", defaultStr);
				this._uiInput.label.supportEncoding = true;
			end,
			SetInputFocus = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._uiInput, nil) then
					return ;
				end;
				if (not b) then
					this._uiInput:RemoveFocus();
				end;
			end,
			SetInputEnable = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._uiInput, nil) then
					return ;
				end;
				this._uiInput:GetComponent(typeof(UnityEngine.BoxCollider)).enabled = b;
			end,
			CallbackSelectItem = function(this, obj)
				if (this._selectItem ~= nil) then
					if isequal(this._selectItem, obj) then
--发送消息
						if (not ChatMsgManager.Instance:JudgeSendCondition(obj, this._uiInput.value)) then
							return ;
						end;
						this:ClearSendMsg();
						local str; str = ChatMsgManager.Instance:JoinItemContent(obj);
						this:UpdateSendMsg(str);
						this:SendMsg();
						this:SetChatExplainActive(false);
						this:SetSendTipActive(false);
						this._selectItem = nil;
						return ;
					end;
				end;
				this._selectItem = obj;
				this:SetChatExplainActive(true);
				this:SetSendTipActive(true);
				this._chatExplainController:SetData__System_Object(obj);
			end,
			UpdateSendMsg = function(this, str)
				this._sendMsg = System.String.Format("{0}{1}{2}", this._uiInput.value, this._sendMsg, str);
			end,
			SetSendTipActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._sendTipLbl, nil) then
					return ;
				end;
				this._sendTipLbl.gameObject:SetActive(b);
			end,
			ClickChatExplainAction = function(this, e)
				this:SetChatExplainActive(false);
				this:SetSendTipActive(false);
			end,
			SetChatExplainActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatExplainController, nil) then
					return ;
				end;
				this._chatExplainController.gameObject:SetActive(b);
			end,
			SetChatSubGroupActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._chatSubBtnController, nil) then
					this._chatSubBtnController.gameObject:SetActive(b);
				end;
			end,
			ClearSendMsg = function(this)
				this._sendMsg = System.String.Empty;
			end,
			SetEmojiBtnState = function(this)
				local emojis; emojis = LogicStatic.GetList(typeof(EightGame.Data.Server.sd_chatemoji), nil);
				if ((emojis == nil) or (emojis.Count == 0)) then
					this._emonticonBtn.enabled = false;
					if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._emonticonBtn:GetComponentInChildren(UISprite), nil) then
						this._emonticonBtn:GetComponentInChildren(UISprite).color = UnityEngine.Color.grey;
					end;
				else
					this._emonticonBtn.enabled = true;
					if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._emonticonBtn:GetComponentInChildren(UISprite), nil) then
						this._emonticonBtn:GetComponentInChildren(UISprite).color = UnityEngine.Color.white;
					end;
				end;
			end,
			RecycledListMoveTo = function(this)
				local moveto; moveto = condexp((( invokeintegeroperator(3, "-", this._allChatMessage.Count, 7, System.Int32, System.Int32) ) > 0), false, (function() return ( invokeintegeroperator(3, "-", this._allChatMessage.Count, 7, System.Int32, System.Int32) ); end), true, 0);
				local b; b = (moveto == 0);
				this._uiRecycledList.ScrollView:ResetPosition();
				this._uiRecycledList:UpdateDataCount(this._allChatMessage.Count, true);
				if (not b) then
					this._uiRecycledList:MoveTo__System_Int32__System_Boolean(moveto, true);
				end;
			end,
			SetCurActionLbl = function(this, str)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._curActionLbl, nil) then
					return ;
				end;
				this._curActionLbl.text = str;
			end,
			CheckPreCondition = function(this, showtip)
				if (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATWORLD ) then
					return FunctionOpenUtility.JudgeSingleFunctionById(se_functiontype.SE_FUNCTIONTYPE_CHAT_WORLD_MODULE , showtip);
				elseif (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATPRIVATE ) then
					return FunctionOpenUtility.JudgeSingleFunctionById(se_functiontype.SE_FUNCTIONTYPE_CHAT_FRIEND_MODULE , showtip);
				elseif (this._currentChanelEnum == se_chattype.SE_CHATTYPE_CHATUNION ) then
					return FunctionOpenUtility.JudgeSingleFunctionById(se_functiontype.SE_FUNCTIONTYPE_CHAT_UNION_MODULE , showtip);
				end;
				return false;
			end,
			Update = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._uiInput, nil) then
					if this._uiInput.isSelected then
						this._uiInput.defaultText = System.String.Empty;
					end;
				end;
			end,
			UnRegisterEvent = function(this)
				Eight.Framework.EIFrameWork.Instance:RemoveEventListener(ChatMsgManager.Instance.CHAT_MSG_ADD);
				Eight.Framework.EIFrameWork.Instance:RemoveEventListener(ChatExplainController.CLICK_CHATEXPLAIN_ACTION);
			end,
			SetChatViewActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._chatView, nil) then
					return ;
				end;
				this._chatView.transform.parent.gameObject:SetActive(b);
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_openChatBtn = __cs2lua_nil_field_value,
				_chatView = __cs2lua_nil_field_value,
				_closeBtn = __cs2lua_nil_field_value,
				_emonticonBtn = __cs2lua_nil_field_value,
				_showBtn = __cs2lua_nil_field_value,
				_uiInput = __cs2lua_nil_field_value,
				_channelGrid = __cs2lua_nil_field_value,
				_uiRecycledList = __cs2lua_nil_field_value,
				_chatItemScrollow = __cs2lua_nil_field_value,
				_sendBtn = __cs2lua_nil_field_value,
				_chatShowPanelController = __cs2lua_nil_field_value,
				_chatEmojiPanelController = __cs2lua_nil_field_value,
				_chatFriendPanelController = __cs2lua_nil_field_value,
				_chatExplainController = __cs2lua_nil_field_value,
				_chatWorldChanelController = __cs2lua_nil_field_value,
				_chatSubBtnController = __cs2lua_nil_field_value,
				_sendTipLbl = __cs2lua_nil_field_value,
				_chatItemPrefabPath = "ChatUI/ChatItem",
				_chatItemPrefab = __cs2lua_nil_field_value,
				_chatChannelPrefab = __cs2lua_nil_field_value,
				_curActionLbl = __cs2lua_nil_field_value,
				_cacheChatChannelList = newexternlist(System.Collections.Generic.List_ChatChannelCom, "System.Collections.Generic.List_ChatChannelCom", "ctor", {}),
				tempList = newexternlist(System.Collections.Generic.List_System.Boolean, "System.Collections.Generic.List_System.Boolean", "ctor", {}),
				_applicationItemDic = newexterndictionary(System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatItemCom, "System.Collections.Generic.Dictionary_UnityEngine.GameObject_ChatItemCom", "ctor", {}),
				_currentChanelEnum = 1,
				_callbackClickChatBtn = delegationwrap(),
				_allChatMessage = newexternlist(System.Collections.Generic.List_ChatMessage, "System.Collections.Generic.List_ChatMessage", "ctor", {}),
				_sendMsg = System.String.Empty,
				_getChatSysMessageNotify = __cs2lua_nil_field_value,
				_sendMsgLock = false,
				_showFriend = false,
				_latestChanelCom = __cs2lua_nil_field_value,
				_lockChangeWorldChannel = false,
				_curFriendSerData = __cs2lua_nil_field_value,
				_chatEmojiItemCom = __cs2lua_nil_field_value,
				_selectItem = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;

		local instance_props = {
			showFriend = {
				get = instance_methods.get_showFriend,
				set = instance_methods.set_showFriend,
			},
		};

		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatMainViewCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatMainViewCom.__define_class();
