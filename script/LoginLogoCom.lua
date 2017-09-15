require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

LoginLogoCom = {
	__new_object = function(...)
		return newobject(LoginLogoCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = LoginLogoCom;

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
			SetAnimaiton01FinishCallBack = function(this, callback01)
				delegationset(false, false, "LoginLogoCom:_callback01", this, nil, "_callback01", callback01);
			end,
			Animation01Finish = function(this)
				if externdelegationcomparewithnil(false, false, "LoginLogoCom:_callback01", this, nil, "_callback01", false) then
					this._callback01();
				end;
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_callback01 = wrapdelegation{},
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "LoginLogoCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



LoginLogoCom.__define_class();
