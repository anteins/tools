require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

ChatMsgURLContent = {
	__new_object = function(...)
		return newobject(ChatMsgURLContent, "ctor__System_String__System_Int32__System_Int64__System_String__System_String__System_String", nil, ...);
	end,
	__define_class = function()
		local static = ChatMsgURLContent;

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
			ctor__System_String__System_Int32__System_Int64__System_String__System_String__System_String = function(this, itemtype, itemstiticid, itemGid, characterStr, itemcontent, extraData)
				local __compiler_switch_957 = itemtype;
				if __compiler_switch_957 == "item" then
					this.itemtype = 1;
				elseif __compiler_switch_957 == "equipment" then
					this.itemtype = 2;
				elseif __compiler_switch_957 == "role" then
					this.itemtype = 3;
				elseif __compiler_switch_957 == "emoji" then
					this.itemtype = 4;
				else
					this.itemtype = 0;
				end;
				this.itemstiticid = itemstiticid;
				this.itemGid = itemGid;
				this.extraData = extraData;
				this.characterStr = characterStr;
				this.itemcontent = itemcontent;
				return this;
			end,
			ctor = function(this)
				this.itemtype = 0;
				return this;
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				itemtype = 0,
				itemstiticid = 0,
				itemGid = 0,
				characterStr = System.String.Empty,
				extraData = __cs2lua_nil_field_value,
				itemcontent = System.String.Empty,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(System.Object, "ChatMsgURLContent", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




ChatMsgURLContent.ItemType = {
	["NOTHING"] = 0,
	["ITEM"] = 1,
	["EQUIPMENT"] = 2,
	["FIGHTER"] = 3,
	["EMOJI"] = 4,
};

rawset(ChatMsgURLContent.ItemType, "Value2String", {
		[0] = "NOTHING",
		[1] = "ITEM",
		[2] = "EQUIPMENT",
		[3] = "FIGHTER",
		[4] = "EMOJI",
});
ChatMsgURLContent.__define_class();
