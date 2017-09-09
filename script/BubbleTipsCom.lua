require "cs2lua__utility";
require "cs2lua__attributes";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

BubbleTipsCom = {
	__new_object = function(...)
		return newobject(BubbleTipsCom, nil, nil, ...);
	end,
	__define_class = function()
		local static = BubbleTipsCom;

		local static_methods = {
			cctor = function()
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				__attributes = BubbleTipsCom__Attrs,
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			get_text = function(this)
				return this._label.text;
			end,
			set_text = function(this, value)
				this._label.text = value;
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_label = __cs2lua_nil_field_value,
				__attributes = BubbleTipsCom__Attrs,
			};
			return instance_fields;
		end;

		local instance_props = {
			text = {
				get = instance_methods.get_text,
				set = instance_methods.set_text,
			},
		};

		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "BubbleTipsCom", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



BubbleTipsCom.__define_class();
