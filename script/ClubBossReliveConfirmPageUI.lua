-- //  **********************************************************************
-- //  Copyright  2014-2017  EIGHT Team . All rights reserved.
-- //  File     : ClubBossReliveConfirmPageUI.cs
-- //  Author   : wolforce
-- //  Created  : 2017/9/9  10:38 
-- //  Purpose  : BOSS复活确认窗口.
-- //  **********************************************************************
require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "AlarmManager";

ClubBossReliveConfirmPageUI = {
	__new_object = function(...)
		return newobject(ClubBossReliveConfirmPageUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubBossReliveConfirmPageUI;

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
			Init = function(this, bossNum, costDiamondPerUnit, freeTime, timeUnit)
				this._bossNum = bossNum;
				this._costDiamondPerUnit = costDiamondPerUnit;
				this._freeTime = freeTime;
				this._timeUnit = timeUnit;
			end,
			GetCostDiamond = function(this)
				return this._costDiamond;
			end,
			Update = function(this)
				this:UpdateUI();
			end,
			UpdateUI = function(this)
				local curTime; curTime = AlarmManager.Instance:currentTimeMillis();
				if ((this._bossNum == nil) or (curTime < 0)) then
					return ;
				end;
				this._costDiamond = invokeintegeroperator(4, "*", UnityEngine.Mathf.CeilToInt((( invokeintegeroperator(3, "-", invokeintegeroperator(3, "-", invokeintegeroperator(0, "/", this._bossNum.endtime, 1000, System.Int64, System.Int64), invokeintegeroperator(0, "/", curTime, 1000, System.Int64, System.Int64), System.Int64, System.Int64), this._freeTime, System.Int64, System.Int64) ) / typecast(this._timeUnit, System.Single, false))), this._costDiamondPerUnit, System.Int32, System.Int32);
				this:SetCostLabel(this._costDiamond);
			end,
			SetCostLabel = function(this, costDiamond)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this.costLabel, nil) then
					return ;
				end;
				this.costLabel.text = condexp((costDiamond <= 0), true, "免费复活", false, (function() return System.String.Format("花费 #ICON_DIAMOND [56e5e7]{0}[-] 立刻复活", costDiamond); end));
			end,
			Start = function(this)
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				costLabel = __cs2lua_nil_field_value,
				_bossNum = __cs2lua_nil_field_value,
				_costDiamondPerUnit = 0,
				_freeTime = 0,
				_timeUnit = 0,
				_costDiamond = 0,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubBossReliveConfirmPageUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubBossReliveConfirmPageUI.__define_class();
