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
require "GameUtility";
require "ItemModelCom";
require "LogicStatic";

ClubIntegralModel = {
	__new_object = function(...)
		return newobject(ClubIntegralModel, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubIntegralModel;

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
			Init = function(this, isTaken, sd)
				this:SetPointLabel(isTaken, sd.targetintegral);
				this:SetInfoLabel(isTaken);
				this:SetItems(GameUtility.GetKeyvalueiiArrayHack(sd.rewardshow));
				this:SetBgSprite(isTaken);
			end,
			SetPointLabel = function(this, isTaken, point)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this.pointLabel, nil) then
					return ;
				end;
				this.pointLabel.text = System.String.Format("[{0}]{1}积分[-]", condexp(isTaken, true, "3b3736", true, "774f2c"), point);
			end,
			SetInfoLabel = function(this, isTaken)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this.infoLabel, nil) then
					return ;
				end;
				this.infoLabel.text = condexp(isTaken, true, "[3b3736]已领取[-]", true, "[c7202c]未达成[-]");
			end,
			SetItems = function(this, rewardShow)
				GameUtility.DestroyChildren(this.grid.transform);
				local i; i = 0;
				while (i < rewardShow.Count) do
					local go; go = GameUtility.InstantiateGameObject(this.itemModelCom.gameObject, this.grid.gameObject, ("item_" + i), nil, nil, invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.one, 0.50));
					local itemCom; itemCom = go:GetComponent(ItemModelCom);
					local item; item = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_item_item), getexterninstanceindexer(rewardShow, nil, "get_Item", i).key);
					itemCom:SetValue(typecast(item.type, System.Int32, false), 0, item.id, getexterninstanceindexer(rewardShow, nil, "get_Item", i).value, false, true, false, false);
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
				this.grid.repositionNow = true;
			end,
			SetBgSprite = function(this, isTaken)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this.bgSprite, nil) then
					return ;
				end;
				this.bgSprite.color = condexp(isTaken, false, (function() return this._greyColor; end), false, (function() return this._whiteColor; end));
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				pointLabel = __cs2lua_nil_field_value,
				infoLabel = __cs2lua_nil_field_value,
				bgSprite = __cs2lua_nil_field_value,
				itemModelCom = __cs2lua_nil_field_value,
				grid = __cs2lua_nil_field_value,
				_greyColor = newexternobject(UnityEngine.Color, "UnityEngine.Color", "ctor", nil, 0.00, 1.00, 1.00),
				_whiteColor = newexternobject(UnityEngine.Color, "UnityEngine.Color", "ctor", nil, 1.00, 1.00, 1.00),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubIntegralModel", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubIntegralModel.__define_class();
