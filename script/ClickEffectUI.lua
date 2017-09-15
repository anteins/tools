require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EightGame__Logic__UINode";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__GameResources";
require "GameUtility";
require "ClickEffectController";

ClickEffectUI = {
	__new_object = function(...)
		return newobject(ClickEffectUI, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ClickEffectUI;

		local static_methods = {
			cctor = function()
				EightGame.Logic.UINode.cctor(this);
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				effectPath = "ClickEffect/Effect",
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			ctor = function(this)
				this.base.ctor(this);
				this._isReady = false;
				this:StartCoroutine(this:CreatUI());
				return this;
			end,
			CreatUI = function(this)
				local coroutine; coroutine = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(("GameAssets/Prefabs/UI/" + ClickEffectUI.effectPath), "prefab", false);
				wrapyield(coroutine.coroutine, false, true);
				local prefab; prefab = typeas(coroutine.res, UnityEngine.GameObject, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", prefab, nil) then
					Eight.Framework.EIDebuger.LogError((("the prefab don\'t found on the path (path=" + ClickEffectUI.effectPath) + ")"));
					return nil;
				end;
				local go; go = GameUtility.InstantiateGameObject(prefab, nil, "EffectUI", nil, nil, nil);
				this._controller = go:GetComponent(ClickEffectController);
				this:BindComponent__EIEntityBehaviour(this._controller);
				this._isReady = true;
			end),
			Dispose = function(this)
--FIMME: DISPOSE 释放引用  by breen dispose
				this._controller = nil;
				return this.base:Dispose();
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_controller = __cs2lua_nil_field_value,
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


		return defineclass(EightGame.Logic.UINode, "ClickEffectUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClickEffectUI.__define_class();
