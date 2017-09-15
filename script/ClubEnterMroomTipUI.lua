require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "LogicStatic";

ClubEnterMroomTipUI = {
	__new_object = function(...)
		return newobject(ClubEnterMroomTipUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubEnterMroomTipUI;

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
			SetUp = function(this, mroomlv, count)
				local _sdroom; _sdroom = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_guild_meditation), mroomlv);
				this.CostValLab.text = System.String.Format("#ICON_CLUB_CONTRIBUTION {0}", _sdroom.entercost);
				local span; span = System.TimeSpan.FromMilliseconds(invokeintegeroperator(4, "*", _sdroom.time, 1000, System.Int32, System.Int32));
--		EIDebuger.LogWarning(string.Format("{0}:{1}:{2}", span.Hours, span.Minutes, span.Seconds));
				this.CostTimeValLab.text = System.String.Format("{0}:{1}:{2}", span.Hours, span.Minutes, span.Seconds);
				this.GetValLab.text = System.String.Format("#ICON_EMBLEM_POWER {0}", _sdroom.emblemnum);
				this.NumLab.text = invokeforbasicvalue(count, false, System.Int32, "ToString");
				local pid; pid = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil).id;
				local _m; _m = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.MemberDataNotify), pid);
				local contr; contr = 0;
				if (_m ~= nil) then
					contr = _m.ownPrestige;
				end;
				this.MyContrLab.text = System.String.Format("#ICON_CLUB_CONTRIBUTION {0}", contr);
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				CostValLab = __cs2lua_nil_field_value,
				CostTimeValLab = __cs2lua_nil_field_value,
				GetValLab = __cs2lua_nil_field_value,
				NumLab = __cs2lua_nil_field_value,
				MyContrLab = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ClubEnterMroomTipUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubEnterMroomTipUI.__define_class();
