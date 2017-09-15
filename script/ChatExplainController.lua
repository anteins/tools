require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "LogicStatic";
require "ColorScheme";
require "GameUtility";
require "Eight__Framework__EIFrameWork";
require "KnapsackUtility";
require "EightGame__Component__GameResources";
require "EquipmentModelCom";
require "ItemModelCom";
require "EightGame__Data__Server__EquipmentSerDataEx";
require "RankupUtil";
require "UILabel";
require "Eight__Framework__EIEvent";
require "NGUIMath";

ChatExplainController = {
	__new_object = function(...)
		return newobject(ChatExplainController, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatExplainController;

		local static_methods = {
			cctor = function()
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				CLICK_CHATEXPLAIN_ACTION = "CLICK_CHATEXPLAIN_ACTION",
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			SetData__System_Object = function(this, obj)
				if typeis(obj, EightGame.Data.Server.ItemSerData, false) then
					this:SetData__EightGame_Data_Server_ItemSerData(typeas(obj, EightGame.Data.Server.ItemSerData, false));
				elseif typeis(obj, EightGame.Data.Server.EquipmentSerData, false) then
					this:SetData__EightGame_Data_Server_EquipmentSerData(typeas(obj, EightGame.Data.Server.EquipmentSerData, false));
				elseif typeis(obj, EightGame.Data.Server.FighterSerData, false) then
					this:SetData__System_Object(typeas(obj, EightGame.Data.Server.FighterSerData, false));
				end;
			end,
			SetData__EightGame_Data_Server_EquipmentSerData = function(this, serdata)
--装备
				local namestr; namestr = System.String.Empty;
				local uselv; uselv = System.String.Empty;
				local equip; equip = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_equipment_equip), serdata.staticid);
				if (equip == nil) then
					return ;
				end;
				namestr = System.String.Format("[{0}]{1}", ColorScheme.GetRankHexColor(equip.rank), equip.name);
				uselv = uselv + System.String.Format("使用等级: {0}       ", equip.uselv);
				uselv = uselv + System.String.Format("[ffbe9e]使用职业: {0}", GameUtility.GetJobName(equip.job));
				Eight.Framework.EIFrameWork.StartCoroutine(this:InitEuipment(equip, serdata.rankuplv), false);
				this:SetProperty__EightGame_Data_Server_EquipmentSerData(serdata);
				this:SetNameLbl(namestr);
				this:SetUseLvLbl(uselv);
				Eight.Framework.EIFrameWork.StartCoroutine(this:SetBgSpriteHeight(), false);
			end,
			SetData__EightGame_Data_Server_ItemSerData = function(this, serdata)
				local namestr; namestr = System.String.Empty;
				local uselv; uselv = System.String.Empty;
				if (serdata == nil) then
					return ;
				end;
				local item; item = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_item_item), serdata.staticId);
				namestr = System.String.Format("{0}{1}({2})", KnapsackUtility.GetColorStrByRank(item.rank), item.name, item.cardname);
--uselv += string.Format("");
				uselv = uselv + System.String.Format("[ffbe9e]使用等级: {0}", item.lv);
				Eight.Framework.EIFrameWork.StartCoroutine(this:InitItem(item), false);
				this:SetProperty__EightGame_Data_Server_sd_item_item(item);
				this:SetNameLbl(namestr);
				this:SetUseLvLbl(uselv);
				Eight.Framework.EIFrameWork.StartCoroutine(this:SetBgSpriteHeight(), false);
			end,
			InitEuipment = function(this, equip, rankuplv)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._equipmentCom, nil) then
					local c; c = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(("GameAssets/Prefabs/UI/" + this._equipmentItemPath), "prefab", false);
					wrapyield(c.coroutine, false, true);
					local prefab; prefab = typeas(c.res, UnityEngine.GameObject, false);
					local go; go = GameUtility.InstantiateGameObject(prefab, this._equipmentAchor.gameObject, "equipmentitem", nil, nil, nil);
					this._equipmentCom = go:GetComponent(EquipmentModelCom);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._equipmentCom, nil) then
					this._equipmentCom.gameObject:SetActive(true);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._itemmodelCom, nil) then
					this._itemmodelCom.gameObject:SetActive(false);
				end;
				this._equipmentCom:ResetIcon();
				this._equipmentCom:SetValue(equip.id, equip.rank, equip.icon, equip.uselv, rankuplv, 99999);
			end),
			InitItem = function(this, item)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._itemmodelCom, nil) then
					local c; c = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources):LoadAsyn(("GameAssets/Prefabs/UI/" + this._itemPath), "prefab", false);
					wrapyield(c.coroutine, false, true);
					local prefab; prefab = typeas(c.res, UnityEngine.GameObject, false);
					local go; go = GameUtility.InstantiateGameObject(prefab, this._equipmentAchor.gameObject, "item", nil, nil, nil);
					this._itemmodelCom = go:GetComponent(ItemModelCom);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._equipmentCom, nil) then
					this._equipmentCom.gameObject:SetActive(false);
				end;
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._itemmodelCom, nil) then
					this._itemmodelCom.gameObject:SetActive(true);
				end;
				this._itemmodelCom:SetValue(typecast(item.type, System.Int32, false), 0, item.id, 1, false, false, false, false);
			end),
			SetNameLbl = function(this, namestr)
				if (this._equipmentNameLbl.text == nil) then
					return ;
				end;
				this._equipmentNameLbl.text = namestr;
			end,
			SetUseLvLbl = function(this, uselv)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._equipmentUseLvLbl, nil) then
					return ;
				end;
				this._equipmentUseLvLbl.text = uselv;
			end,
			SetProperty__EightGame_Data_Server_EquipmentSerData = function(this, serdata)
				local ex; ex = EightGame.Data.Server.EquipmentSerDataEx.CreateFakeSerData(serdata.staticid, serdata.id, serdata.randattr, serdata.rankuplv, serdata.breakskill, serdata.wearfighter);
				local datas; datas = newexternlist(System.Collections.Generic.List_ChatExplainController.PropertyData, "System.Collections.Generic.List_ChatExplainController.PropertyData", "ctor", {});
--设置基础属性.
				local curAttr; curAttr = EightGame.Data.Server.EquipmentSerDataEx.CombineAttrs(ex.baseAttrs, ex.rankupAttrs);
				local data; data = newobject(ChatExplainController.PropertyData, "ctor", nil);
				data = wrapvaluetype(data);
				data.des = "基础:";
				data.propertydata = this:GetPropertyStr(curAttr, "ffffff");
				datas:Add(data);
--附加属性
				local data_1; data_1 = newobject(ChatExplainController.PropertyData, "ctor", nil);
				data_1 = wrapvaluetype(data_1);
				data_1.des = "附加:";
				local str_1; str_1 = System.String.Empty;
				for keyvalue in getiterator(ex.randAttrs) do
					str_1 = str_1 + this:GetPropertyStr(keyvalue.Value, "77F3FB");
				end;
				data_1.propertydata = str_1;
				datas:Add(data_1);
				this:InitProperty(datas);
				this:SetCombatwworthyActive(true);
				this:SetCombatwworthyLbl(ex.battleForce);
			end,
			GetPropertyStr = function(this, curAttr, colorstr)
				local str; str = System.String.Empty;
				if (curAttr.hp > 0) then
					str = str + System.String.Format("{0}[{1}]{2} {3}", condexp(System.String.IsNullOrEmpty(str), true, "", true, "\n"), colorstr, RankupUtil.GetShortNameRoleAttr(1), curAttr.hp);
				end;
				if (curAttr.atk > 0) then
					str = str + System.String.Format("{0}[{1}]{2} {3}", condexp(System.String.IsNullOrEmpty(str), true, "", true, "\n"), colorstr, RankupUtil.GetShortNameRoleAttr(2), curAttr.atk);
				end;
				if (curAttr.crt > 0) then
					str = str + System.String.Format("{0}[{1}]{2} {3}", condexp(System.String.IsNullOrEmpty(str), true, "", true, "\n"), colorstr, RankupUtil.GetShortNameRoleAttr(5), curAttr.crt);
				end;
				if (curAttr.defense > 0) then
					str = str + System.String.Format("{0}[{1}]{2} {3}", condexp(System.String.IsNullOrEmpty(str), true, "", true, "\n"), colorstr, RankupUtil.GetShortNameRoleAttr(4), curAttr.defense);
				end;
				if (curAttr.reply > 0) then
					str = str + System.String.Format("{0}[{1}]{2} {3}", condexp(System.String.IsNullOrEmpty(str), true, "", true, "\n"), colorstr, RankupUtil.GetShortNameRoleAttr(3), curAttr.reply);
				end;
				return str;
			end,
			SetProperty__EightGame_Data_Server_sd_equipment_equip = function(this, equip)
				local datas; datas = newexternlist(System.Collections.Generic.List_ChatExplainController.PropertyData, "System.Collections.Generic.List_ChatExplainController.PropertyData", "ctor", {});
				local kevalues; kevalues = equip.baseattr;
				local str_1; str_1 = System.String.Empty;
				local index; index = 0;
				while (index < kevalues.Count) do
					if (index == 0) then
						str_1 = System.String.Format("{0} {1}", RankupUtil.GetShortNameRoleAttr(getexterninstanceindexer(kevalues, nil, "get_Item", index).key), getexterninstanceindexer(kevalues, nil, "get_Item", index).value);
					else
						str_1 = str_1 + System.String.Format("\n{0} {1}", RankupUtil.GetShortNameRoleAttr(getexterninstanceindexer(kevalues, nil, "get_Item", index).key), getexterninstanceindexer(kevalues, nil, "get_Item", index).value);
					end;
				index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
				end;
				local data; data = newobject(ChatExplainController.PropertyData, "ctor", nil);
				data = wrapvaluetype(data);
				data.des = System.String.Format("基础:");
				data.propertydata = str_1;
				local data_1; data_1 = newobject(ChatExplainController.PropertyData, "ctor", nil);
				data_1 = wrapvaluetype(data_1);
				data_1.des = System.String.Format("附加:");
				data_1.propertydata = "[56e5e7]????";
				local data_2; data_2 = newobject(ChatExplainController.PropertyData, "ctor", nil);
				data_2 = wrapvaluetype(data_2);
				data_2.des = System.String.Format("描述:");
				data_2.propertydata = System.String.Format("{0}", equip.desc);
				datas:Add(data);
				datas:Add(data_1);
				datas:Add(data_2);
				this:InitProperty(datas);
			end,
			SetProperty__EightGame_Data_Server_sd_item_item = function(this, item)
				local data; data = newobject(ChatExplainController.PropertyData, "ctor", nil);
				data = wrapvaluetype(data);
				data.des = System.String.Format("描述:");
				data.propertydata = System.String.Format("{0}", item.desc);
				local datas; datas = newexternlist(System.Collections.Generic.List_ChatExplainController.PropertyData, "System.Collections.Generic.List_ChatExplainController.PropertyData", "ctor", {});
				datas:Add(data);
				this:InitProperty(datas);
				this:SetCombatwworthyActive(false);
			end,
			InitProperty = function(this, datas)
				if (this._cachPropertyItems.Count < datas.Count) then
					local index; index = 0;
					while (index < datas.Count) do
					repeat
						local go; go = nil;
						if (index < this._cachPropertyItems.Count) then
							getexterninstanceindexer(this._cachPropertyItems, nil, "get_Item", index).gameObject:SetActive(true);
							go = getexterninstanceindexer(this._cachPropertyItems, nil, "get_Item", index);
						else
							go = GameUtility.InstantiateGameObject(this._propertyPrefab, this._powerTable.gameObject, "PropertyItem", nil, nil, nil);
							this._cachPropertyItems:Add(go);
						end;
						if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", go, nil) then
							break;
						end;
						local lbl_1; lbl_1 = go:GetComponent(UILabel);
						local lbl_2; lbl_2 = go.transform:GetChild(0):GetComponent(UILabel);
						if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", lbl_1, nil) or invokeexternoperator(CS.UnityEngine.Object, "op_Equality", lbl_2, nil)) then
							return ;
						end;
						lbl_1.text = getexterninstanceindexer(datas, nil, "get_Item", index).des;
						lbl_2.text = getexterninstanceindexer(datas, nil, "get_Item", index).propertydata;
					until true;
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				else
					local index; index = 0;
					while (index < this._cachPropertyItems.Count) do
					repeat
						local go; go = nil;
						if (index < datas.Count) then
							getexterninstanceindexer(this._cachPropertyItems, nil, "get_Item", index).gameObject:SetActive(true);
							go = getexterninstanceindexer(this._cachPropertyItems, nil, "get_Item", index);
						else
							getexterninstanceindexer(this._cachPropertyItems, nil, "get_Item", index).gameObject:SetActive(false);
						end;
						if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", go, nil) then
							break;
						end;
						local lbl_1; lbl_1 = go:GetComponent(UILabel);
						local lbl_2; lbl_2 = go.transform:GetChild(0):GetComponent(UILabel);
						if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", lbl_1, nil) or invokeexternoperator(CS.UnityEngine.Object, "op_Equality", lbl_2, nil)) then
							return ;
						end;
						lbl_1.text = getexterninstanceindexer(datas, nil, "get_Item", index).des;
						lbl_2.text = getexterninstanceindexer(datas, nil, "get_Item", index).propertydata;
					until true;
					index = invokeintegeroperator(2, "+", index, 1, System.Int32, System.Int32);
					end;
				end;
				this._powerTable.repositionNow = true;
			end,
			OnClickClose = function(this)
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, ChatExplainController.CLICK_CHATEXPLAIN_ACTION, nil, nil, 0.00));
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this, nil) then
					this.gameObject:SetActive(false);
				end;
			end,
			SetBgSpriteHeight = function(this)
				wrapyield(nil, false, false);
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this._powerTable, nil) then
					local bounds; bounds = NGUIMath.CalculateRelativeWidgetBounds__UnityEngine_Transform(this._powerTable.transform);
					if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._bgSprite, nil) then
						return nil;
					end;
					this._bgSprite:SetDimensions(this._bgSprite.width, invokeintegeroperator(2, "+", UnityEngine.Mathf.CeilToInt(bounds.size.y), 180, System.Int32, System.Int32));
				end;
			end),
			SetCombatwworthyActive = function(this, b)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._combatworthyLbl, nil) then
					return ;
				end;
				this._combatworthyLbl.gameObject:SetActive(b);
			end,
			SetCombatwworthyLbl = function(this, power)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this._combatworthyLbl, nil) then
					return ;
				end;
				this._combatworthyLbl.text = System.String.Format("{0}", typecast(power, System.Int32, false));
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				_equipmentAchor = __cs2lua_nil_field_value,
				_equipmentNameLbl = __cs2lua_nil_field_value,
				_equipmentUseLvLbl = __cs2lua_nil_field_value,
				_powerTable = __cs2lua_nil_field_value,
				_propertyPrefab = __cs2lua_nil_field_value,
				_bgSprite = __cs2lua_nil_field_value,
				_combatworthyLbl = __cs2lua_nil_field_value,
				_equipmentCom = __cs2lua_nil_field_value,
				_equipmentItemPath = "Common/ui_model_equipment",
				_itemmodelCom = __cs2lua_nil_field_value,
				_itemPath = "Common/ui_model_item",
				_cachPropertyItems = newexternlist(System.Collections.Generic.List_UnityEngine.GameObject, "System.Collections.Generic.List_UnityEngine.GameObject", "ctor", {}),
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ChatExplainController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




ChatExplainController.PropertyData = {
	__new_object = function(...)
		return newobject(ChatExplainController.PropertyData, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatExplainController.PropertyData;

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
				des = __cs2lua_nil_field_value,
				propertydata = __cs2lua_nil_field_value,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(System.ValueType, "ChatExplainController.PropertyData", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, true);
	end,
};



ChatExplainController.PropertyData.__define_class();
ChatExplainController.__define_class();
