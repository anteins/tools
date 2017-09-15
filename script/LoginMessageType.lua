require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

LoginMessageType = {
	__new_object = function(...)
		return newobject(LoginMessageType, nil, nil, ...);
	end,
	__define_class = function()
		local static = LoginMessageType;

		local static_methods = {
			cctor = function()
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				LOGIN_READY = "LOGIN_READY",
				LOGIN_START = "LOGIN_START",
				LOGIN_CONNECTING = "LOGIN_CONNECTING",
				LOGIN_FAILED = "LOGIN_FAILED",
				LOGIN_NEWPLAYER = "LOGIN_NEWPLAYER",
				LOGIN_SUCCESS = "LOGIN_SUCCESS",
				LOGIN_LEAVE = "LOGIN_LEAVE",
				LOGIN_CREATE_PLAYER_SUCCEED = "LOGIN_CREATE_PLAYER_SUCCEED",
				LOGIN_AGAIN = "LOGIN_AGAIN",
				LOGIN_ACCOUNT = "LOGIN_ACCOUNT",
				LOGIN_REGISTER = "LOGIN_REGISTER",
				LOGIN_SDK_ACCOUNT_SUCCESS = "LOGIN_SDK_ACCOUNT_SUCCESS",
				LOGIN_SDK_ACCOUNT_FAILED = "LOGIN_SDK_ACCOUNT_FAILED",
				LOGOUT_SDK_ACCOUNT = "LOGOUT_SDK_ACCOUNT",
				LOGIN_CHOICE_SERVER = "LOGIN_CHOICE_SERVER",
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
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(System.Object, "LoginMessageType", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



LoginMessageType.__define_class();
