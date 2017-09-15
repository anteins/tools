require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "NGUITools";

ChatEmojiItemCom = {
	__new_object = function(...)
		return newobject(ChatEmojiItemCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatEmojiItemCom;

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
			SetData = function(this, chatemoji, callbackSelect)
				if isequal(this._chatemoji, chatemoji) then
					return ;
				end;
				this._chatemoji = chatemoji;
				delegationset(false, false, "ChatEmojiItemCom:_callbackSelect", this, nil, "_callbackSelect", callbackSelect);
				Eight.Framework.EIFrameWork.StartCoroutine(this:LoadEmojiTexture(), false);
			end,
			LoadEmojiTexture = function(this)
				local c; c = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(("GameAssets/Textures/Icon/" + this._chatemoji.image), "png", true);
				wrapyield(c.coroutine, false, true);
				local tex; tex = typeas(c.res, UnityEngine.Texture2D, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", tex, nil) then
					this._emojiTexture.mainTexture = tex;
				end;
				NGUITools.AddWidgetCollider__UnityEngine_GameObject(this.gameObject);
			end),
			OnClick = function(this)
				if externdelegationcomparewithnil(false, false, "ChatEmojiItemCom:_callbackSelect", this, nil, "_callbackSelect", false) then
					this._callbackSelect(this);
				end;
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_emojiTexture = __cs2lua_nil_field_value,
				_chatemoji = __cs2lua_nil_field_value,
				_callbackSelect = delegationwrap(),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ChatEmojiItemCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatEmojiItemCom.__define_class();
