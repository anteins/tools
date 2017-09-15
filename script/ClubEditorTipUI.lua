require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "LogicStatic";

ClubEditorTipUI = {
	__new_object = function(...)
		return newobject(ClubEditorTipUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubEditorTipUI;

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
			Init = function(this)
				local signstr; signstr = "";
				local _sbt; _sbt = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil).signature;
				if ((_sbt == nil) or (_sbt.Length == 0)) then
					signstr = "点击此处编辑公告！（最多70个字）";
				else
					signstr = System.Text.Encoding.UTF8:GetString(_sbt);
				end;
				this.EInput.value = signstr;
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				EInput = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ClubEditorTipUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubEditorTipUI.__define_class();
