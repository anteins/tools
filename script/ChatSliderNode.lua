require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "Eight__Framework__EINode";
require "Eight__Framework__EIFrameWork";
require "ChatMsgManager";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ChatSliderViewCom";

ChatSliderNode = {
	__new_object = function(...)
		return newobject(ChatSliderNode, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ChatSliderNode;

		local static_methods = {
			cctor = function()
				Eight.Framework.EINode.cctor(this);
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
			ctor = function(this)
				this.base.ctor(this);
				return this;
			end,
			ctor__UnityEngine_GameObject = function(this, parent)
				this.base.ctor(this);
				Eight.Framework.EIFrameWork.StartCoroutine(this:CreateChatSliderViewUICom(parent), false);
				return this;
			end,
			ShowChatSlider = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._chatSliderView, nil) then
					this:AddEventListener(ChatMsgManager.Instance.CHAT_MSG_ADD, (function() local __compiler_delegation_21 = (function(e) this:ListenerMsgAdd(e); end); setdelegationkey(__compiler_delegation_21, "ChatSliderNode:ListenerMsgAdd", this, this.ListenerMsgAdd); return __compiler_delegation_21; end)());
					this._chatSliderView:Register();
					this._chatSliderView.gameObject:SetActive(true);
				end;
			end,
			DisposeChatSlider = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._chatSliderView, nil) then
					this:RemoveEventListener(ChatMsgManager.Instance.CHAT_MSG_ADD);
					this._chatSliderView:Unregister();
					this._chatSliderView.gameObject:SetActive(false);
				end;
			end,
			DestroyChatSlider = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._chatSliderView, nil) then
					this:RemoveEventListener(ChatMsgManager.Instance.CHAT_MSG_ADD);
					this._chatSliderView:Unregister();
					this._chatSliderView.gameObject:SetActive(false);
					UnityEngine.Object.Destroy(this._chatSliderView.gameObject);
					this._chatSliderView = nil;
				end;
			end,
			CreateChatSliderViewUICom = function(this, parent)
				local c; c = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(("GameAssets/Prefabs/UI/" + this.chatSliderViewPath), "prefab", false);
				wrapyield(c.coroutine, false, true);
				local chatSliderViewPrefab; chatSliderViewPrefab = typeas(c.res, UnityEngine.GameObject, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", chatSliderViewPrefab, nil) then
					Eight.Framework.EIDebuger.LogError("[ChatSliderViewCom] load ChatSliderView error");
					return nil;
				end;
				local go; go = GameUtility.InstantiateGameObject(chatSliderViewPrefab, parent, "ChatSliderPanel", nil, nil, nil);
				this._chatSliderView = go:GetComponent(ChatSliderViewCom);
				this:BindComponent__EIEntityBehaviour(this._chatSliderView);
				this:ShowChatSlider();
			end),
			ListenerMsgAdd = function(this, e)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._chatSliderView, nil) then
					this._chatSliderView:ListenerMsgAdd(e);
				end;
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_chatSliderView = __cs2lua_nil_field_value,
				chatSliderViewPath = "ChatUI/ChatSliderPanel",
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


		return defineclass(Eight.Framework.EINode, "ChatSliderNode", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatSliderNode.__define_class();
