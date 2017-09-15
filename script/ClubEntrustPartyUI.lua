require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EventDelegate";
require "LogicStatic";
require "GameUtility";
require "ItemModelCom";
require "ShowRewardUtil";
require "EightGame__Logic__TipStruct";
require "Eight__Framework__EIFrameWork";
require "Eight__Framework__EIEvent";
require "RoleInfoUtil";
require "ClubPushItemTipsUI";
require "EightGame__Logic__TipsDialogParam";
require "EightGame__Component__ServiceCenter";
require "EightGame__Component__ClubService";
require "EightGame__Logic__FloatingTextTipUIRoot";

ClubEntrustPartyUI = {
	__new_object = function(...)
		return newobject(ClubEntrustPartyUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubEntrustPartyUI;

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
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.UpPushUiBt.onClick, (function() local __compiler_delegation_27 = (function() this:OnSendCollectMaterialFunction(); end); setdelegationkey(__compiler_delegation_27, "ClubEntrustPartyUI:OnSendCollectMaterialFunction", this, this.OnSendCollectMaterialFunction); return __compiler_delegation_27; end)());
			end,
			SetUp = function(this)
				local clv; clv = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubDataNotify), nil).clubLv;
				local guilditem; guilditem = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_guild_item_delivery), (function(x) return (x.guildlv == clv); end));
				this:SetReward(guilditem);
				this:SetRateCount(guilditem);
				this:SetNeedItems();
			end,
			SetNeedItems = function(this)
				local _cparty; _cparty = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ClubPartyData), nil);
				local mstr; mstr = System.Text.Encoding.UTF8:GetString(_cparty.materials.needItems);
				local materials; materials = typeas(MiniJSON.Json.Deserialize(mstr), System.Collections.Generic.Dictionary_System.String_System.Object, false);
				if isequal(this.lastmaterials, materials) then
					return ;
				end;
				this.ModelComList:ForEach((function(x) return x.gameObject:SetActive(false); end));
				local inddx; inddx = 0;
				this.IsEnough = true;
				for kstr in getiterator(materials.Keys) do
					local key; key = System.Int32.Parse(kstr);
					local val; val = typecast(( typecast(( getexterninstanceindexer(materials, nil, "get_Item", kstr) ), System.Int64, false) ), System.Int32, false);
					local _itemCom; _itemCom = nil;
					local _sditem; _sditem = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_item_item), key);
					if (inddx < this.ModelComList.Count) then
						_itemCom = getexterninstanceindexer(this.ModelComList, nil, "get_Item", inddx);
					else
						local _obj; _obj = GameUtility.InstantiateGameObject(this.ItemSample, this.ItemGrid.gameObject, "", nil, nil, nil);
						_obj.transform.localScale = invokeexternoperator(CS.UnityEngine.Vector3, "op_Multiply", UnityEngine.Vector3.one, 0.50);
						_itemCom = _obj:GetComponent(ItemModelCom);
						this.ModelComList:Add(_itemCom);
					end;
					_itemCom:SetValue(typecast(_sditem.type, System.Int32, false), 0, key, val, false, true, false, false);
					local _temp; _temp = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.ItemSerData), (function(x) return (x.staticId == key); end));
					if ((_temp == nil) or (_temp.number < val)) then
						_itemCom.numberLabel.text = System.String.Format("[ff6767]{0}[-]", _itemCom.Number);
						this.IsEnough = false;
					end;
					_itemCom.gameObject:SetActive(true);
					inddx = invokeintegeroperator(2, "+", inddx, 1, System.Int32, System.Int32);
--			NeedItems.Add(key,val);
				end;
				this.lastmaterials = materials;
			end,
			SetRateCount = function(this, guilditem)
				local numdata; numdata = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.GuildNum), nil);
				this.DubleCountValLab.text = System.String.Format("{0}/{1}", UnityEngine.Mathf.Clamp(numdata.material, 0, guilditem.doublenum), guilditem.doublenum);
				this.CountValLab.text = System.String.Format("{0}/{1}", numdata.material, guilditem.totalnum);
			end,
			SetReward = function(this, guilditem)
				local rewardstr; rewardstr = "";
				local numRate; numRate = this:CheckRewardNum();
				this.RewardRateTipLab.text = System.String.Format("[00ff2c]{0}[-]倍奖励次数", numRate);
				if (guilditem.getmoney ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 1);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilditem.getmoney);
				end;
				if (guilditem.getprestige ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 5);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilditem.getprestige);
				end;
				if (guilditem.getprosperity ~= 0) then
					local rstr; rstr = ShowRewardUtil.GetTypeWords(10, 6);
					rewardstr = rewardstr + System.String.Format("{0} {1}    ", rstr, guilditem.getprosperity);
				end;
				this.AllRewardValLab.text = rewardstr;
				if (guilditem.getcontribution ~= 0) then
					this.MyRewardValLab.gameObject:SetActive(true);
					local rstr; rstr = ShowRewardUtil.GetTypeWords(11, 0);
					this.MyRewardValLab.text = System.String.Format("{0} {1}", rstr, guilditem.getcontribution);
				else
					this.MyRewardValLab.gameObject:SetActive(false);
				end;
			end,
			CheckRewardNum = function(this)
				local _r; _r = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_gamerule), 1901);
				return _r.value;
			end,
			OnSendCollectMaterialFunction = function(this)
				if (not this.IsEnough) then
					local _tipstr; _tipstr = "该活动物品不满足";
					local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, _tipstr, 0.20);
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
					return ;
				end;
				local _tippath; _tippath = "ClubUI/ClubTipsUI/UpPushTips";
				Eight.Framework.EIFrameWork.StartCoroutine(RoleInfoUtil.LoadAsynUIPrefab(nil, _tippath, (function(obj)
					local _tipui; _tipui = obj:GetComponent(ClubPushItemTipsUI);
					local title; title = "材料委任";
					_tipui:SetUp(this.ModelComList, 1);
					local tipsDialogParam; tipsDialogParam = newobject(EightGame.Logic.TipsDialogParam, "ctor__System_String__System_String__UnityEngine_GameObject__System_String__System_Func_System_Boolean__System_String__System_Func_System_Boolean__EightGame_Logic_TipsDialogPriority__EightGame_Logic_TipsDialogInfoStyle", nil, "CollectMaterial", title, obj, "确定", (function()
						this:SendMaterialMsg();
						return true;
					end), "返回", (function()
						return true;
					end), 5, 0);
					this.IsRequst = false;
					delegationset(false, false, "EightGame.Logic.TipsDialogParam:ondismiss", tipsDialogParam, nil, "ondismiss", (function()
						if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", obj, nil) then
							UnityEngine.Object.Destroy(obj);
						end;
					end));
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_COMMONT_TIPS_DIALOG", nil, tipsDialogParam, 0.00));
				end)), false);
			end,
			SendMaterialMsg = function(this)
				if this.IsRequst then
					return ;
				end;
				this.IsRequst = true;
				local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
				local request; request = newexternobject(EightGame.Data.Server.SendCollectMaterial, "EightGame.Data.Server.SendCollectMaterial", "ctor", (function(newobj)  end));
				srv:SendCollectMaterial(request, (function(arg1)
					local errorc; errorc = typecast(arg1, System.Int32, false);
					if (errorc ~= 200) then
						local _tipstr; _tipstr = EightGame.Component.NetCode.GetDesc(errorc);
						local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, _tipstr, 0.20);
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
					else
						EightGame.Logic.FloatingTextTipUIRoot.SetFloattingTip("交付成功", 0.00);
						this:SetUp();
						Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "FRESH_CLUB_PARTYINFO", nil, nil, 0.00));
					end;
					this.IsRequst = false;
				end), nil);
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				ItemGrid = __cs2lua_nil_field_value,
				ItemSample = __cs2lua_nil_field_value,
				AllRewardValLab = __cs2lua_nil_field_value,
				MyRewardValLab = __cs2lua_nil_field_value,
				DubleCountValLab = __cs2lua_nil_field_value,
				CountValLab = __cs2lua_nil_field_value,
				RewardRateTipLab = __cs2lua_nil_field_value,
				UpPushUiBt = __cs2lua_nil_field_value,
				lastmaterials = newexterndictionary(System.Collections.Generic.Dictionary_System.String_System.Object, "System.Collections.Generic.Dictionary_System.String_System.Object", "ctor", {}),
				ModelComList = newexternlist(System.Collections.Generic.List_ItemModelCom, "System.Collections.Generic.List_ItemModelCom", "ctor", {}),
				IsRequst = false,
				IsEnough = true,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ClubEntrustPartyUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubEntrustPartyUI.__define_class();
