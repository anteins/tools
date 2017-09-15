require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "BaseChatItemCom";
require "LogicStatic";
require "ChatMsgManager";
require "ChatItemDes";
require "ChatEquipmentDes";
require "ChatFighterDes";
require "Eight__Framework__EIFrameWork";
require "UIWidget";

ChatItemCom = {
	__new_object = function(...)
		return newobject(ChatItemCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatItemCom;

		local static_methods = {
			cctor = function()
				BaseChatItemCom.cctor(this);
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
			SetData = function(this, chatmsg, callbackClickLbl, callbackClickFriend)
				this._chatmsg = chatmsg;
				delegationset(false, false, "ChatItemCom:_callbackClickFriend", this, nil, "_callbackClickFriend", callbackClickFriend);
				local playerserdata; playerserdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
				local content; content = System.Text.Encoding.UTF8:GetString(chatmsg.msgcontent);
				local cmu; cmu = ChatMsgManager.Instance:AnalysisMsgContent(content);
				local des; des = nil;
				if (cmu == nil) then
					this:SetContentLbl(System.String.Empty, nil);
				else
					if (cmu.itemtype == 1) then
--普通物品
						des = newobject(ChatItemDes, "ctor", nil);
						this:SetContentLbl(des:JoinURLStr(cmu), callbackClickLbl);
					elseif (cmu.itemtype == 2) then
--装备
						des = newobject(ChatEquipmentDes, "ctor", nil);
						this:SetContentLbl(des:JoinURLStr(cmu), callbackClickLbl);
					elseif (cmu.itemtype == 3) then
--伙伴
						des = newobject(ChatFighterDes, "ctor", nil);
						this:SetContentLbl(des:JoinURLStr(cmu), callbackClickLbl);
					elseif (cmu.itemtype == 4) then
--表情
						local emoji; emoji = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_chatemoji), cmu.itemstiticid);
						if (emoji == nil) then
							return ;
						end;
						Eight.Framework.EIFrameWork.StartCoroutine(this:LoadEmojiTexture(emoji), false);
					else
						this:SetContentLbl(cmu.characterStr, callbackClickLbl);
					end;
				end;
				if (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATSYSTEM ) then
					local path; path = System.String.Format("{0}{1}", "GameAssets/Textures/Icon/", "icon_npc_item_000_02");
					Eight.Framework.EIFrameWork.StartCoroutine(this.base:LoadParnerTexture(path), false);
					this:SetGenderSprite(false);
					this:SetPlayerNameLbl(System.String.Format("【系统】可妮莉娅"), "[00F4FF]");
					this:SetPlayerLvLbl("N");
					this:SetPlayerVipLbl("0");
					this:SetSendMsgType(chatmsg.chattype);
				elseif (chatmsg.chattype == se_chattype.SE_CHATTYPE_CHATUNION ) then
					if (chatmsg.guildPower == 10500100) then
--团长
						this:ForceSetSendMsgTypeSprite("colonel");
					elseif (chatmsg.guildPower == 10500200) then
--副团
						this:ForceSetSendMsgTypeSprite("colonel2");
					else
						this:SetSendMsgType(this._chatmsg.chattype);
					end;
					local clubdata; clubdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil);
					local path; path = System.String.Empty;
					if ((clubdata ~= nil) and (chatmsg.playerid == -1000)) then
						path = System.String.Format("{0}{1}", "GameAssets/Textures/Icon/", "icon_npc_item_001");
						Eight.Framework.EIFrameWork.StartCoroutine(this.base:LoadParnerTexture(path), false);
						this:ForceSetSendMsgTypeSprite("system");
						this:SetPlayerLvLbl("N");
						this:SetPlayerNameLbl(System.String.Format("{0}{1}", "[00F4FF]", chatmsg.playername), "[ffffff]");
--				sd_guild_lv_info guild_lv = LogicStatic.Get< sd_guild_lv_info >(clubdata.clubLv);
--				if( guild_lv != null )
--				{
--					path = string.Format( "{0}{1}",SystemHelper.ICON_PATH,guild_lv.guildicon );
--					EIFrameWork.StartCoroutine( base.LoadParnerTexture (path));
--					ForceSetSendMsgTypeSprite("system");
--				}
--				else
--				{
--					path = string.Format( "{0}",chatmsg.assistFighterSkinId.ToString()  );
--					EIFrameWork.StartCoroutine( LoadParnerTexture( path ) );
--
--				}
					else
						path = System.String.Format("{0}", invokeforbasicvalue(chatmsg.assistFighterSkinId, false, System.Int32, "ToString"));
						Eight.Framework.EIFrameWork.StartCoroutine(this:LoadParnerTexture(path), false);
						this:SetPlayerLvLbl(invokeforbasicvalue(chatmsg.playerLv, false, System.Int32, "ToString"));
						this:SetPlayerNameLbl(chatmsg.playername, "[ffffff]");
					end;
					this:SetPlayerVipLbl(invokeforbasicvalue(chatmsg.playerVipLv, false, System.Int32, "ToString"));
					this:SetGenderSprite(chatmsg.playergender);
				else
					this:SetPlayerNameLbl(chatmsg.playername, "[ffffff]");
					this:SetPlayerLvLbl(invokeforbasicvalue(chatmsg.playerLv, false, System.Int32, "ToString"));
					this:SetPlayerVipLbl(invokeforbasicvalue(chatmsg.playerVipLv, false, System.Int32, "ToString"));
					this:SetGenderSprite(chatmsg.playergender);
					this:SetSendMsgType(chatmsg.chattype);
					Eight.Framework.EIFrameWork.StartCoroutine(this:LoadParnerTexture(invokeforbasicvalue(chatmsg.assistFighterSkinId, false, System.Int32, "ToString")), false);
				end;
				this:SetSelfStyle((playerserdata.id == chatmsg.playerid));
			end,
			LoadParnerTexture = function(this, skinIdStr)
				local skinId; skinId = System.Int32.Parse(skinIdStr);
				local skin; skin = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_role_skin), skinId);
				if (skin == nil) then
					return nil;
				end;
				local path; path = System.String.Format("{0}{1}", "GameAssets/Textures/Icon/", skin.common);
				wrapyield(Eight.Framework.EIFrameWork.StartCoroutine(this.base:LoadParnerTexture(path), false), false, true);
			end),
			SetSelfStyle = function(this, self)
				if self then
--右边
					this._playerNameLbl:GetComponent(UIWidget).pivot = 5;
					this._contentLbl.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, (210.00 - this._contentLbl.printedSize.x), -21.63, 0);
					this._parnterIcon.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 264.60, 0, 0);
					this._playerNameLbl.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 218.00, 24.70, 0);
					this._emojiTexture.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 164.00, -15.84, 0);
					this._arrowSprite.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, 220.00, -23.00, 0);
					this._arrowSprite.transform.localRotation = newexternobject(UnityEngine.Quaternion, "UnityEngine.Quaternion", "ctor", nil, 0, 180.00, 0, 0);
					this._contentBgSprite.color = newexternobject(UnityEngine.Color, "UnityEngine.Color", "ctor", nil, 1.00, 0.89, 0.69);
					this._arrowSprite.color = newexternobject(UnityEngine.Color, "UnityEngine.Color", "ctor", nil, 1.00, 0.89, 0.69);
				else
--左边
					this._arrowSprite.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -215.00, -23.00, 0);
					this._arrowSprite.transform.localRotation = newexternobject(UnityEngine.Quaternion, "UnityEngine.Quaternion", "ctor", nil, 0, 0, 0, 0);
					this._contentLbl.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -206.00, -21.63, 0);
					this._playerNameLbl:GetComponent(UIWidget).pivot = 3;
					this._parnterIcon.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -266.00, 0, 0);
					this._playerNameLbl.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -158.00, 24.70, 0);
					this._emojiTexture.transform.localPosition = newexternobject(UnityEngine.Vector3, "UnityEngine.Vector3", "ctor", nil, -200.00, 15.84, 0);
					this._contentBgSprite.color = UnityEngine.Color.white;
					this._arrowSprite.color = UnityEngine.Color.white;
				end;
			end,
			ClickIconTextrue = function(this)
				if ((this._chatmsg.playerid == 0) or (this._chatmsg.playerid == -1000)) then
					return ;
				end;
				if externdelegationcomparewithnil(false, false, "ChatItemCom:_callbackClickFriend", this, nil, "_callbackClickFriend", false) then
					this._callbackClickFriend(this);
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_callbackClickFriend = delegationwrap(),
				_chatmsg = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(BaseChatItemCom, "ChatItemCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatItemCom.__define_class();
