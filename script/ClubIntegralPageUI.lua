-- //  **********************************************************************
-- //  Copyright  2014-2017  EIGHT Team . All rights reserved.
-- //  File     : ClubIntegralPageUI.cs
-- //  Author   : wolforce
-- //  Created  : 2017/9/8  12:55 
-- //  Purpose  : 查看积分领取情况的弹窗的UI.
-- //  **********************************************************************
require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "LogicStatic";
require "GameUtility";
require "ClubIntegralModel";

ClubIntegralPageUI = {
	__new_object = function(...)
		return newobject(ClubIntegralPageUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubIntegralPageUI;

		local static_methods = {
			cctor = function()
				EIUIBehaviour.cctor(this);
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
--构造出用以刷新UI的结构体链表.
				local player; player = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.PlayerSerData), nil);
				local m; m = LogicStatic.Get__System_Int64(typeof(EightGame.Data.Server.MemberDataNotify), player.id);
				local sdList; sdList = LogicStatic.GetList(typeof(EightGame.Data.Server.sd_guild_boss_integral), nil);
				local dataList; dataList = newexternlist(System.Collections.Generic.List_ClubIntegralPageUI.Data, "System.Collections.Generic.List_ClubIntegralPageUI.Data", "ctor", {});
				local i; i = 0;
				while (i < sdList.Count) do
					local sd; sd = getexterninstanceindexer(sdList, nil, "get_Item", i);
					dataList:Add(newobject(ClubIntegralPageUI.Data, "ctor", nil, sd, m.buycreditlist:Contains(sd.id)));
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
--排序，已领取过的排下面.
				dataList:Sort((function(x, y)
					if (x.isTaken ~= y.isTaken) then
						return invokeforbasicvalue(x.isTaken, false, System.Boolean, "CompareTo", y.isTaken);
					end;
					return invokeforbasicvalue(x.sd.id, false, System.Int32, "CompareTo", y.sd.id);
				end));
--初始化UI.
				this:SetIntegralLabel(m.credit);
				GameUtility.DestroyChildren(this.grid.transform);
				local i; i = 0;
				while (i < dataList.Count) do
					local d; d = getexterninstanceindexer(dataList, nil, "get_Item", i);
					local go; go = GameUtility.InstantiateGameObject(this.integralModel.gameObject, this.grid.gameObject, ("integralCell_" + i), nil, nil, nil);
					local model; model = go:GetComponent(ClubIntegralModel);
					model:Init(d.isTaken, d.sd);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				this.grid.repositionNow = true;
			end,
			SetIntegralLabel = function(this, point)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this.integralLabel, nil) then
					return ;
				end;
				this.integralLabel.text = System.String.Format("我的积分： {0}", point);
			end,
			Start = function(this)
			end,
			Update = function(this)
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				integralLabel = __cs2lua_nil_field_value,
				integralModel = __cs2lua_nil_field_value,
				grid = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubIntegralPageUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




ClubIntegralPageUI.Data = {
	__new_object = function(...)
		return newobject(ClubIntegralPageUI.Data, "ctor", nil, ...);
	end,
	__define_class = function()
		local static = ClubIntegralPageUI.Data;

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
			ctor = function(this, sd, isTaken)
				this.sd = sd;
				this.isTaken = isTaken;
				return this;
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				sd = __cs2lua_nil_field_value,
				isTaken = false,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(System.Object, "ClubIntegralPageUI.Data", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubIntegralPageUI.Data.__define_class();
ClubIntegralPageUI.__define_class();
