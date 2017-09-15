require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "EventDelegate";
require "LogicStatic";
require "FunctionOpenUtility";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__ServiceCenter";
require "EightGame__Component__ClubService";
require "EightGame__Logic__TipStruct";
require "Eight__Framework__EIEvent";
require "PlayerInfoUtil";
require "ClubUtility";

ClubCreatePageUI = {
	__new_object = function(...)
		return newobject(ClubCreatePageUI, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubCreatePageUI;

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
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.CreataBt.onClick, (function() local __compiler_delegation_27 = (function() this:ToCreate(); end); setdelegationkey(__compiler_delegation_27, "ClubCreatePageUI:ToCreate", this, this.ToCreate); return __compiler_delegation_27; end)());
				EventDelegate.Add__System_Collections_Generic_List_EventDelegate__EventDelegate_Callback(this.CancleBt.onClick, (function() local __compiler_delegation_28 = (function() this:ToCancle(); end); setdelegationkey(__compiler_delegation_28, "ClubCreatePageUI:ToCancle", this, this.ToCancle); return __compiler_delegation_28; end)());
			end,
			OnEnter = function(this)
				this:HideErrorMsg();
				this.IsCreat = false;
--加载静态静态配置
				this:SetSourceThings();
			end,
			SetSourceThings = function(this)
				local _sdcreate; _sdcreate = LogicStatic.Get__System_Predicate_T(typeof(EightGame.Data.Server.sd_guild_create), nil);
				this.CostGoldLab.gameObject:SetActive((_sdcreate.costgold > 0));
				this.CostGoldLab.text = System.String.Format("#ICON_GOLD {0}", _sdcreate.costgold);
				this.CostDiamondLab.gameObject:SetActive((_sdcreate.costdiamond > 0));
				this.CostDiamondLab.text = System.String.Format("#ICON_DIAMOND {0}", _sdcreate.costdiamond);
				local _sditem; _sditem = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_item_item), getexterninstanceindexer(_sdcreate.costitems, nil, "get_Item", 0));
				local itemcount; itemcount = getexterninstanceindexer(_sdcreate.costitems, nil, "get_Item", 1);
				local isneeditem; isneeditem = ((_sditem ~= nil) and (itemcount > 0));
				this.CostItemLab.gameObject:SetActive(isneeditem);
				if isneeditem then
					this.CostItemLab.text = System.String.Format("{0} {1}", _sditem.name, itemcount);
				end;
			end,
			ToCreate = function(this)
				if FunctionOpenUtility.JudgeSingleFunctionById(se_functiontype.SE_FUNCTIONTYPE_GUILD_GREAT, true) then
					if this.IsCreat then
						return ;
					end;
					this.IsCreat = true;
					this:HideErrorMsg();
--收集输入名字，触发事件，如果通过则进入公会
					this:OnInputChange();
					if (not this.IsNameCheck) then
						this.IsCreat = false;
						return ;
					end;
					local srv; srv = Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter):GetService(EightGame.Component.ClubService);
					local request; request = newexternobject(EightGame.Data.Server.SendNewGuildRequest, "EightGame.Data.Server.SendNewGuildRequest", "ctor", (function(newobj) newobj.guildname = System.Text.Encoding.UTF8:GetBytes(this.NameInput.value); end));
					srv:SendNewGuildRequest(request, (function(arg1)
						this.IsCreat = false;
						local errorc; errorc = typecast(arg1, System.Int32, false);
						if (errorc ~= 200) then
							local _tipstr; _tipstr = EightGame.Component.NetCode.GetDesc(errorc);
							local param; param = newobject(EightGame.Logic.TipStruct, "ctor", nil, _tipstr, 0.20);
							Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "UI_FLOATING_TIPS", nil, param, 0.00));
						else
--EIFrameWork.Instance.DispatchEvent(new EIEnumEvent(UIMessageType.UI_Ready,  UIModuleType.UI_Module_Club_Sence ));
							Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "GO_CLUB_SENCE", nil, nil, 0.00));
						end;
					end), nil);
				end;
			end,
			OnInputChange = function(this)
				this.IsNameCheck = false;
				local str; str = invokeforbasicvalue(this.NameInput.value, false, System.String, "Trim");
				local charLimit; charLimit = this.NameInput.characterLimit;
				if System.String.IsNullOrEmpty(str) then
					this:ShowErrorMsg("名字不能为空");
					return ;
				end;
--检查特殊字符.
				if PlayerInfoUtil.CheckCharacterSpecial(str) then
					this:ShowErrorMsg("名字不能含有特殊字符");
					return ;
				end;
--检查敏感词.
				if PlayerInfoUtil.CheckBlackList(str) then
					this:ShowErrorMsg("名字不能含有非法词汇");
					return ;
				end;
				if ClubUtility.IsClubRename(str) then
					this:ShowErrorMsg("该名称已被占有");
					return ;
				end;
				this.IsNameCheck = true;
			end,
			ShowErrorMsg = function(this, msg)
				this.ErrorLab.text = msg;
				this.ErrorLab.gameObject:SetActive(true);
			end,
			HideErrorMsg = function(this)
				this.ErrorLab.gameObject:SetActive(false);
			end,
			ToCancle = function(this)
				if this.IsCreat then
					this.IsCreat = false;
					return ;
				end;
				Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "OUT_CLUB_CREAT", nil, nil, 0.00));
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				NameInput = __cs2lua_nil_field_value,
				CreataBt = __cs2lua_nil_field_value,
				CancleBt = __cs2lua_nil_field_value,
				SourceGrid = __cs2lua_nil_field_value,
				CostGoldLab = __cs2lua_nil_field_value,
				CostDiamondLab = __cs2lua_nil_field_value,
				CostItemLab = __cs2lua_nil_field_value,
				ErrorLab = __cs2lua_nil_field_value,
				IsNameCheck = false,
				IsCreat = false,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubCreatePageUI", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ClubCreatePageUI.__define_class();
