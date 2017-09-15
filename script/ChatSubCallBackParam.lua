require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

ChatSubCallBackParam = {
	__new_object = function(...)
		return newobject(ChatSubCallBackParam, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatSubCallBackParam;

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
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				chatsubtype = 0,
				_friendId = 0,
				friendName = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(System.Object, "ChatSubCallBackParam", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatSubCallBackParam.__define_class();
