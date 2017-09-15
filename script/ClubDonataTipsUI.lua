require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";

ClubDonataTipsUI = {
	__new_object = function(...)
		return newobject(ClubDonataTipsUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubDonataTipsUI;

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
			SetUp = function(this, teamReawardStr, myReawardStr, diamondCost)
				this.DanataValLab.text = System.String.Format("[4ddbff]#ICON_DIAMOND  {0}[-]", diamondCost);
				this.TeamRewardLab.text = ("冒险团获得:  " + teamReawardStr);
				this.MyRewardLab.text = ("个人获得:  " + myReawardStr);
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				DanataValLab = __cs2lua_nil_field_value,
				TeamRewardLab = __cs2lua_nil_field_value,
				MyRewardLab = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ClubDonataTipsUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubDonataTipsUI.__define_class();
