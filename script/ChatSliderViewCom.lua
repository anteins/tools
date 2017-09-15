require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "Eight__Framework__EIFrameWork";
require "Eight__Framework__EIBoolEvent";
require "ChatMsgManager";
require "ChatMessage";
require "LogicStatic";

ChatSliderViewCom = {
	__new_object = function(...)
		return newobject(ChatSliderViewCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatSliderViewCom;

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
			ChatBtnClick = function(this)
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIBoolEvent, "ctor__System_String__System_Boolean", nil, ChatMsgManager.SHOW_CHAT_VIEW, true));
			end,
			Register = function(this)
--this.entity.AddEventListener(ChatMsgManager.Instance.CHAT_MSG_ADD, ListenerMsgAdd);
--EIFrameWork.Instance.AddEventListener(ChatMsgManager.Instance.CHAT_MSG_ADD, ListenerMsgAdd);
				this._changeChatCheck = true;
				this:InitChatLabel();
			end,
			Unregister = function(this)
--this.entity.RemoveEventListener(ChatMsgManager.Instance.CHAT_MSG_ADD);
				this._changeChatCheck = false;
				this._msgList:Clear();
				this._msg2List:Clear();
				this._tipsMsg:Clear();
			end,
			Update = function(this)
				if this._openCurrent then
					this._currentChatLabel.transform.localPosition = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._currentChatLabel.transform.localPosition, newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 0, (UnityEngine.Time.deltaTime * this._verticalSpeed), 0));
					if (this._currentChatLabel.transform.localPosition.y >= this._toCurrent.y) then
						this._openCurrent = false;
						if externdelegationcomparewithnil(false, false, "ChatSliderViewCom:_currentAction", this, nil, "_currentAction", false) then
							this._currentAction();
						end;
					end;
				end;
				if this._openCurrentLeft then
					this._currentChatLabel.transform.localPosition = invokeexternoperator(CS.UnityEngine.Vector3, "op_Subtraction", this._currentChatLabel.transform.localPosition, newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, (UnityEngine.Time.deltaTime * this._horizontalSpeed), 0, 0));
					if (this._currentChatLabel.transform.localPosition.x <= this._toCurrent.x) then
						this._openCurrentLeft = false;
						if externdelegationcomparewithnil(false, false, "ChatSliderViewCom:_currentActionLeft", this, nil, "_currentActionLeft", false) then
							this._currentActionLeft();
						end;
					end;
				end;
				if this._openNext then
					this._nextChatLabel.transform.localPosition = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._nextChatLabel.transform.localPosition, newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 0, (UnityEngine.Time.deltaTime * this._verticalSpeed), 0));
					if (this._nextChatLabel.transform.localPosition.y >= this._toNext.y) then
						this._openNext = false;
						if externdelegationcomparewithnil(false, false, "ChatSliderViewCom:_nextAction", this, nil, "_nextAction", false) then
							this._nextAction();
						end;
					end;
				end;
			end,
			ListenerMsgAdd = function(this, e)
				local chatmsg; chatmsg = typeas(e.extraInfo, ChatMessage, false);
-- 过滤私聊本玩家消息显示
				if (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATPRIVATE) then
					local player; player = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
					if (player.id == chatmsg.playerid) then
						return ;
					end;
				end;
				local msg; msg = ChatMsgManager.GetRollMsgContent(chatmsg);
				Eight.Framework.EIDebuger.Log(("msg>>:" + msg), UnityEngine.Color.green);
				if (this._msgList.Count >= 100) then
					this._msgList:RemoveAt(0);
				end;
				this._msgList:Add(msg);
-- 根据聊天信息数目改变速度
				if ((this._msgList.Count > 10) and (this._msgList.Count <= 60)) then
					this._oneLineDelayTime = 4;
					this._verticalSpeed = 100.00;
				elseif (this._msgList.Count > 60) then
					this._oneLineDelayTime = 2;
					this._verticalSpeed = 150.00;
				else
					this._oneLineDelayTime = 6;
					this._verticalSpeed = 50.00;
				end;
			end,
			InitChatLabel = function(this)
				this._tipsMsg = LogicStatic.GetList(typeof(EightGame.Data.Server.sd_hometips), nil);
				this._chatLabelOne.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -261, 9, 0);
				this._chatLabelTwo.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -261, -17, 0);
				this._currentChatLabel = this._chatLabelOne;
				this._nextChatLabel = this._chatLabelTwo;
--LogicStatic.Get<sd_hometips>(1001);
--tips.ForEach(T => _msg2List.Add(T.tips));
				if (this._msgList.Count >= 200) then
					this._currentChatLabel.text = getexterninstanceindexer(this._msgList, nil, "get_Item", 0);
				end;
				this._msg2List:Add(("[eee3b5]" + getexterninstanceindexer(this._tipsMsg, nil, "get_Item", UnityEngine.Random.Range(0, invokeintegeroperator(3, "-", this._tipsMsg.Count, 1, System.Int32, System.Int32))).tips));
				this:ChangeChat();
			end,
			ChangeChat = function(this)
				if (not this._changeChatCheck) then
					return ;
				end;
				if ((this._msgList.Count <= 0) or invokeforbasicvalue(this._currentChatLabel.text, false, System.String, "Equals", getexterninstanceindexer(this._msg2List, nil, "get_Item", 0))) then
					if (this._msg2List.Count < 2) then
						this._msg2List:Add(("[eee3b5]" + getexterninstanceindexer(this._tipsMsg, nil, "get_Item", UnityEngine.Random.Range(0, invokeintegeroperator(3, "-", this._tipsMsg.Count, 1, System.Int32, System.Int32))).tips));
					end;
					this._currentChatLabel.text = getexterninstanceindexer(this._msg2List, nil, "get_Item", 0);
					local lineMul; lineMul = condexp(( (this._currentChatLabel.width > this._msgWidth) ), true, true, true, false);
					this._msg2List:RemoveAt(0);
					if (this._msgList.Count > 0) then
						this._nextChatLabel.text = getexterninstanceindexer(this._msgList, nil, "get_Item", 0);
					else
						this._nextChatLabel.text = getexterninstanceindexer(this._msg2List, nil, "get_Item", 0);
					end;
-- 当前label移动
					if lineMul then
						this._toCurrent = invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", ( invokeintegeroperator(3, "-", 264, this._currentChatLabel.width, System.Int32, System.Int32) ), UnityEngine.Vector3.right);
						this:OpenChatCurrentLabelLeftMove(this._mulLineDelayTime, (function()
							this._toCurrent = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._currentChatLabel.transform.localPosition, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.up, this._labelDistance));
							this:OpenChatCurrentLabelMove(this._mulLineDelayTime, nil);
							this._toNext = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._nextChatLabel.transform.localPosition, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.up, this._labelDistance));
							this:OpenChatNextLabelMove(this._mulLineDelayTime, (function()
								this:ResetChatUI();
							end));
						end));
					else
						this._toCurrent = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._currentChatLabel.transform.localPosition, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.up, this._labelDistance));
						this:OpenChatCurrentLabelMove(this._oneLineDelayTime, nil);
						this._toNext = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._nextChatLabel.transform.localPosition, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.up, this._labelDistance));
						this:OpenChatNextLabelMove(this._oneLineDelayTime, (function()
							this:ResetChatUI();
						end));
					end;
				else
					local lineMul; lineMul = condexp(( (this._currentChatLabel.width > this._msgWidth) ), true, true, true, false);
					this._msgList:RemoveAt(0);
					if (this._msgList.Count > 0) then
						this._nextChatLabel.text = getexterninstanceindexer(this._msgList, nil, "get_Item", 0);
					else
						this._nextChatLabel.text = getexterninstanceindexer(this._msg2List, nil, "get_Item", 0);
					end;
-- 当前label移动
					if lineMul then
						this._toCurrent = invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", ( invokeintegeroperator(3, "-", 264, this._currentChatLabel.width, System.Int32, System.Int32) ), UnityEngine.Vector3.right);
						this:OpenChatCurrentLabelLeftMove(this._mulLineDelayTime, (function()
							this._toCurrent = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._currentChatLabel.transform.localPosition, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.up, this._labelDistance));
							this:OpenChatCurrentLabelMove(this._mulLineDelayTime, nil);
							this._toNext = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._nextChatLabel.transform.localPosition, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.up, this._labelDistance));
							this:OpenChatNextLabelMove(this._mulLineDelayTime, (function()
								this._currentChatLabel.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -261, -17, 0);
								this:ResetChatUI();
							end));
						end));
					else
						this._toCurrent = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._currentChatLabel.transform.localPosition, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.up, this._labelDistance));
						this:OpenChatCurrentLabelMove(this._oneLineDelayTime, nil);
						this._toNext = invokeexternoperator(CS.UnityEngine.Vector3, "op_Addition", this._nextChatLabel.transform.localPosition, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.up, this._labelDistance));
						this:OpenChatNextLabelMove(this._oneLineDelayTime, (function()
							this:ResetChatUI();
						end));
					end;
				end;
			end,
			OpenChatCurrentLabelMove = function(this, delay, fallback)
				this:Invoke("OpenChatCurrentLabel", delay);
				delegationset(false, false, "ChatSliderViewCom:_currentAction", this, nil, "_currentAction", fallback);
			end,
			OpenChatCurrentLabel = function(this)
				this._openCurrent = true;
			end,
			OpenChatCurrentLabelLeftMove = function(this, delay, fallback)
				this:Invoke("OpenChatCurrentLabelLeft", delay);
				delegationset(false, false, "ChatSliderViewCom:_currentActionLeft", this, nil, "_currentActionLeft", fallback);
			end,
			OpenChatCurrentLabelLeft = function(this)
				this._openCurrentLeft = true;
			end,
			OpenChatNextLabelMove = function(this, delay, fallback)
				this:Invoke("OpenChatNextLabel", delay);
				delegationset(false, false, "ChatSliderViewCom:_nextAction", this, nil, "_nextAction", fallback);
			end,
			OpenChatNextLabel = function(this)
				this._openNext = true;
			end,
			ResetChatUI = function(this)
				this._currentChatLabel.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -261, -17, 0);
				local tempLabel; tempLabel = this._currentChatLabel;
				this._currentChatLabel = this._nextChatLabel;
				this._nextChatLabel = tempLabel;
				this:ChangeChat();
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_chatLabelOne = __cs2lua_nil_field_value,
				_chatLabelTwo = __cs2lua_nil_field_value,
				_msgList = newexternlist(System.Collections.Generic.List_System.String, "System.Collections.Generic.List_System.String", "ctor", {}),
				_msg2List = newexternlist(System.Collections.Generic.List_System.String, "System.Collections.Generic.List_System.String", "ctor", {}),
				_msgWidth = 520,
				_changeChatCheck = false,
				_tipsMsg = newexternlist(System.Collections.Generic.List_EightGame.Data.Server.sd_hometips, "System.Collections.Generic.List_EightGame.Data.Server.sd_hometips", "ctor", {}),
				_currentChatLabel = __cs2lua_nil_field_value,
				_nextChatLabel = __cs2lua_nil_field_value,
				_openCurrent = false,
				_openCurrentLeft = false,
				_openNext = false,
				_toCurrent = UnityEngine.Vector3.zero,
				_toNext = UnityEngine.Vector3.zero,
				_currentAction = delegationwrap(),
				_currentActionLeft = delegationwrap(),
				_nextAction = delegationwrap(),
				_mulLineDelayTime = 2.00,
				_oneLineDelayTime = 6.00,
				_labelDistance = 26.00,
				_verticalSpeed = 50,
				_horizontalSpeed = 50,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatSliderViewCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatSliderViewCom.__define_class();
