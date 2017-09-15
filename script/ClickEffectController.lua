require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIEntityBehaviour";

ClickEffectController = {
	__new_object = function(...)
		return newobject(ClickEffectController, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClickEffectController;

		local static_methods = {
			cctor = function()
				EIEntityBehaviour.cctor(this);
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
			GetLayerFromMask = function(this, mask)
				if (mask == 0) then
					return 0;
				end;
				local times; times = 0;
				repeat
					mask = invokeintegeroperator(6, ">>", mask, 1, System.Int32, System.Int32);
				until not (((mask ~= 0) and (( (function() times = invokeintegeroperator(2, "+", times, 1, System.Int32, System.Int32); return times; end)() ) > 0)));
				return times;
			end,
			Start = function(this)
				this._cameraLayer = this:GetLayerFromMask(this.topCamera.cullingMask);
				this:StopParticleSystem();
			end,
			OnEnable = function(this)
--UICamera.onCustomInput = OnCustomInput;
			end,
			OnDisable = function(this)
--UICamera.onCustomInput = null;
				this:CancelHideTimer();
				this:StopParticleSystem();
			end,
			UpdateTouch = function(this)
				this._touch.touchValid = UnityEngine.Input.GetMouseButton(0);
				if this._touch.touchValid then
					this._touch.pos = invokeexternoperator(CS.UnityEngine.Vector2, "op_Implicit", UnityEngine.Input.mousePosition);
				end;
			end,
			WaitingForHideWhenTouchUp = function(this)
				wrapyield(newexternobject(UnityEngine.WaitForSeconds, "UnityEngine.WaitForSeconds", "ctor", nil, 1.00), false, true);
				this.effect:SetActive(false);
				this:StopParticleSystem();
				this._hideTimer = nil;
			end),
			CancelHideTimer = function(this)
				if (this._hideTimer ~= nil) then
					this:StopCoroutine(this._hideTimer);
					this._hideTimer = nil;
				end;
			end,
			StartHideTimer = function(this)
				if (this._hideTimer == nil) then
					this._hideTimer = this:WaitingForHideWhenTouchUp();
					this:StartCoroutine(this._hideTimer);
				end;
			end,
			PlayerParticleSystem = function(this)
				if (not this.effect.activeSelf) then
					this.effect:SetActive(true);
				end;
				local ps; ps = nil;
				local i; i = 0;
				local imax; imax = this.particleSystems.Length;
				while (i < imax) do
					ps = this.particleSystems[i + 1];
					ps:Clear(true);
					ps:Play(true);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
			end,
			StopParticleSystem = function(this)
				local ps; ps = nil;
				local i; i = 0;
				local imax; imax = this.particleSystems.Length;
				while (i < imax) do
					ps = this.particleSystems[i + 1];
					ps:Clear(true);
					ps:Stop(true);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				if this.effect.activeSelf then
					this.effect:SetActive(false);
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				effect = __cs2lua_nil_field_value,
				particleSystems = __cs2lua_nil_field_value,
				topCamera = __cs2lua_nil_field_value,
				_hideTimer = __cs2lua_nil_field_value,
				_cameraLayer = 0,
				_touch = newobject(ClickEffectController.InnerTouch, "ctor", nil),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIEntityBehaviour, "ClickEffectController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




ClickEffectController.InnerTouch = {
	__new_object = function(...)
		return newobject(ClickEffectController.InnerTouch, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClickEffectController.InnerTouch;

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
			ctor = function(this)
				this:__ctor();
			end,
			__ctor = function(this)
				if this.__ctor_called then
					return;
				else
					this.__ctor_called = true;
				end
				this.pos = newexternobject(UnityEngine.Vector2, "UnityEngine.Vector2", nil, nil);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				pos = defaultvalue(UnityEngine.Vector2, "UnityEngine.Vector2", true),
				touchValid = false,
				__ctor_called = false,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(System.ValueType, "ClickEffectController.InnerTouch", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, true);
	end,
};



ClickEffectController.InnerTouch.__define_class();
ClickEffectController.__define_class();
