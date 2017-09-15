require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "LogicStatic";
require "ChatMsgManager";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";

ChatFriendItemCom = {
	__new_object = function(...)
		return newobject(ChatFriendItemCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatFriendItemCom;

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
			SetData = function(this, friendSerData, callbackSelect)
				this._friendSerData = friendSerData;
				delegationset(false, false, "ChatFriendItemCom:_callbackSelect", this, nil, "_callbackSelect", callbackSelect);
				this:SetPlayerNameLbl(this._friendSerData.name);
				this:SetPlayerVipLbl(this._friendSerData.vipLv);
				this:PlayerLvLbl(this._friendSerData.level);
				this:SetGenderSprite(condexp((invokeintegeroperator(3, "-", this._friendSerData.photoid, 1, System.Int32, System.Int32) == 1), true, "male", true, "female"));
				local skin; skin = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_role_skin), this._friendSerData.assistf.skin);
				if (skin ~= nil) then
					this:SetIcnTexture(System.String.Format("{0}{1}", "GameAssets/Textures/Icon/", skin.common));
				end;
				local unreadlist; unreadlist = ChatMsgManager.Instance:GetUnReadPrivateMsgsBYFid(friendSerData.fid);
				this:SetRedSpriteActive(condexp((unreadlist == nil), true, false, false, (function() return (unreadlist.Count > 0); end)));
			end,
			SetPlayerNameLbl = function(this, playername)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._playerNameLbl, nil) then
					return ;
				end;
				this._playerNameLbl.text = playername;
			end,
			SetPlayerVipLbl = function(this, playerVip)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._playerVipLvLbl, nil) then
					return ;
				end;
				this._playerVipLvLbl.transform.parent.gameObject:SetActive((playerVip ~= 0));
				this._playerVipLvLbl.text = invokeforbasicvalue(playerVip, false, System.Int32, "ToString");
			end,
			PlayerLvLbl = function(this, playerLv)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._playerLvLbl, nil) then
					return ;
				end;
				this._playerLvLbl.text = invokeforbasicvalue(playerLv, false, System.Int32, "ToString");
			end,
			SetOnlineLbl = function(this, online)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._onlineLbl, nil) then
					return ;
				end;
				this._onlineLbl.text = online;
			end,
			SetGenderSprite = function(this, gender)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._genderSprite, nil) then
					return ;
				end;
				this._genderSprite.spriteName = gender;
			end,
			SetIcnTexture = function(this, str)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._iconTexture, nil) then
					return ;
				end;
				Eight.Framework.EIFrameWork.StartCoroutine(this:LoadTexture(str), false);
			end,
			LoadTexture = function(this, path)
				local c; c = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(path, "png", true);
				wrapyield(c.coroutine, false, true);
				this._iconTexture.mainTexture = typeas(c.res, UnityEngine.Texture2D, false);
			end),
			SetRedSpriteActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._redSprite, nil) then
					return ;
				end;
				this._redSprite.gameObject:SetActive(b);
			end,
			OnClick = function(this)
				if externdelegationcomparewithnil(false, false, "ChatFriendItemCom:_callbackSelect", this, nil, "_callbackSelect", false) then
					this._callbackSelect(this._friendSerData);
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_playerNameLbl = __cs2lua_nil_field_value,
				_playerVipLvLbl = __cs2lua_nil_field_value,
				_playerLvLbl = __cs2lua_nil_field_value,
				_iconTexture = __cs2lua_nil_field_value,
				_onlineLbl = __cs2lua_nil_field_value,
				_genderSprite = __cs2lua_nil_field_value,
				_redSprite = __cs2lua_nil_field_value,
				_friendSerData = __cs2lua_nil_field_value,
				_callbackSelect = delegationwrap(),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ChatFriendItemCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatFriendItemCom.__define_class();
