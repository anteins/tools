require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

ChatMessage = {
	__new_object = function(...)
		return newobject(ChatMessage, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatMessage;

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
				playerid = 0,
				playername = __cs2lua_nil_field_value,
				playerLv = 0,
				playerVipLv = 0,
				playergender = false,
				assistFighterSkinId = 0,
				msgcontent = __cs2lua_nil_field_value,
				chattype = 0,
				chatTime = 0,
				sensitiveWord = __cs2lua_nil_field_value,
				toplayerid = 0,
				guildPower = 9,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(System.Object, "ChatMessage", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatMessage.__define_class();
