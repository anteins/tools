require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "EIUIBehaviour";
require "AlarmManager";
require "AlarmManagerHelper";
require "Eight__Framework__EIFrameWork";
require "EightGame__Component__NetworkClient";
require "PlayerPrefs_Ex";
require "Eight__Framework__EIEvent";
require "ClubUtility";
require "SingleNpc";

ClubHouseController = {
	__new_object = function(...)
		return newobject(ClubHouseController, nil, nil, ...);
	end,
	__define_class = function()
		local static = ClubHouseController;

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
			get_ClubCameraAni = function(this)
				return this.ClubCamera:GetComponent(typeof(UnityEngine.Animator));
			end,
			Init = function(this)
				this.STNpcs:ForEach((function(x) return x:SetUp(); end));
				this.ClubHeader:SetUp();
				this.ClubBestTeamer:SetUp();
			end,
			OnEnter = function(this)
				this.starttime = -1.00;
				this:ResetCameraStay();
				this:FreshFriendMsg();
				this.CurSencePage = 0;
				this.TstartPos = UnityEngine.Vector2.zero;
				local curMill; curMill = AlarmManager.Instance:currentTimeMillis();
				local time; time = AlarmManagerHelper.UnixTimeToDateTime(curMill);
				local cursky; cursky = invokeintegeroperator(1, "%", typecast(( invokeintegeroperator(0, "/", time.Hour, this.dayHour, System.Int32, System.Int32) ), System.Int32, false), this.SkyObjs.Count, System.Int32, System.Int32);
				local i; i = 0;
				while (i < this.SkyObjs.Count) do
					getexterninstanceindexer(this.SkyObjs, nil, "get_Item", i):SetActive((i == cursky));
				i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
				end;
			end,
			FreshFriendMsg = function(this)
				local action; action = EightGame.Data.Server.ServerService.MyfriendsMethod();
				Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.NetworkClient):NetworkRequest(action, (function(returnCode, response)
				end), true, false);
			end,
			ReloadHeaders = function(this)
				this.ClubHeader:SetUp();
				this.ClubBestTeamer:SetUp();
			end,
			OnCameraLeft = function(this)
				Eight.Framework.EIDebuger.Log(((("starttime :" + this.starttime) + " , nowtime :") + UnityEngine.Time.time));
				local isAni; isAni = this.ClubCameraAni:GetBool("left");
				Eight.Framework.EIDebuger.Log(((("Left isAni :" + isAni) + " , CurSencePage :") + this.CurSencePage));
				if ((this.CurSencePage == 0) and (not isAni)) then
					Eight.Framework.EIDebuger.Log("Left set");
					this.CurSencePage = 1;
					this.ClubCameraAni:SetBool("left", true);
				end;
--		else {
--			ClubCameraAni.SetBool ("left", false);
--		}
			end,
			OnCameraRight = function(this)
				local isAni; isAni = this.ClubCameraAni:GetBool("right");
				if ((this.CurSencePage == 0) and (not isAni)) then
					Eight.Framework.EIDebuger.Log("Right set");
					this.CurSencePage = 2;
					this.ClubCameraAni:SetBool("right", true);
				end;
			end,
			OnCameraBack = function(this)
				local isAni; isAni = this.ClubCameraAni:GetBool("back");
				Eight.Framework.EIDebuger.Log(((("Back isAni :" + isAni) + " , CurSencePage :") + this.CurSencePage));
				if ((this.CurSencePage ~= 0) and (not isAni)) then
					Eight.Framework.EIDebuger.Log("Main set");
					this.CurSencePage = 0;
					this.ClubCameraAni:SetBool("back", true);
				end;
			end,
			TouchFunction = function(this)
				if (invokeexternoperator(CS.UnityEngine.Object, "op_Equality", this.ClubCamera, nil) and (not this:IsCameraStay())) then
					return ;
				end;
--		//buttunfunction 
				if (UnityEngine.Input.GetMouseButtonDown(0) and invokeexternoperator(CS.UnityEngine.Vector2, "op_Equality", this.TstartPos, UnityEngine.Vector2.zero)) then
					this.TstartPos = invokeexternoperator(CS.UnityEngine.Vector2, "op_Implicit", UnityEngine.Input.mousePosition);
				elseif (invokeexternoperator(CS.UnityEngine.Vector2, "op_Inequality", this.TstartPos, UnityEngine.Vector2.zero) and UnityEngine.Input.GetMouseButtonUp(0)) then
					local movepos; movepos = invokeexternoperator(CS.UnityEngine.Vector2, "op_Implicit", UnityEngine.Input.mousePosition);
					this:TouchTurnFunction(movepos);
				end;
			end,
			TouchTurnFunction = function(this, endPos)
				if (not this:IsCameraStay()) then
					this.TstartPos = UnityEngine.Vector2.zero;
--			ResetCameraStay ();
					return ;
				end;
				if ((endPos.x >= (this.TstartPos.x + this.distance)) and this:IsCameraStay()) then
					if ((this.CurSencePage == 0) and (not this.ClubCameraAni:GetBool("left"))) then
						this.CurSencePage = 1;
						this.ClubCameraAni:SetBool("left", true);
					elseif ((this.CurSencePage == 2) and (not this.ClubCameraAni:GetBool("back"))) then
						this.CurSencePage = 0;
						this.ClubCameraAni:SetBool("back", true);
					end;
				elseif ((endPos.x <= (this.TstartPos.x - this.distance)) and this:IsCameraStay()) then
					if (((this.CurSencePage == 0) and (this.CurSencePage ~= 2)) and (not this.ClubCameraAni:GetBool("right"))) then
						this.CurSencePage = 2;
						this.ClubCameraAni:SetBool("right", true);
					elseif ((this.CurSencePage == 1) and (not this.ClubCameraAni:GetBool("back"))) then
						this.CurSencePage = 0;
						this.ClubCameraAni:SetBool("back", true);
					end;
				end;
				this.TstartPos = UnityEngine.Vector2.zero;
--取消初始提示
				if (this.isFirst and (PlayerPrefs_Ex.GetInt__System_String__System_Int32__System_Boolean("ClubFirstTip", 0, false) == 0)) then
					this.isFirst = false;
					Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "SET_CLUB_FIRST_TIP_OVER", nil, nil, 0.00));
				end;
			end,
			IsCameraStay = function(this)
				return (((not this.ClubCameraAni:GetBool("left")) and (not this.ClubCameraAni:GetBool("right"))) and (not this.ClubCameraAni:GetBool("back")));
			end,
			ResetCameraStay = function(this)
				this.ClubCameraAni:SetBool("left", false);
				this.ClubCameraAni:SetBool("right", false);
				this.ClubCameraAni:SetBool("back", false);
			end,
			FixedUpdate = function(this)
				if (not ClubUtility.HaveMask) then
					if this:IsCameraStay() then
						if UnityEngine.Input.GetKey(276) then
							this.starttime = UnityEngine.Time.time;
							this:OnCameraLeft();
--取消初始提示
							if (this.isFirst and (PlayerPrefs_Ex.GetInt__System_String__System_Int32__System_Boolean("ClubFirstTip", 0, false) == 0)) then
								this.isFirst = false;
								Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "SET_CLUB_FIRST_TIP_OVER", nil, nil, 0.00));
							end;
						elseif UnityEngine.Input.GetKey(275) then
							this.starttime = UnityEngine.Time.time;
							this:OnCameraRight();
--取消初始提示
							if (this.isFirst and (PlayerPrefs_Ex.GetInt__System_String__System_Int32__System_Boolean("ClubFirstTip", 0, false) == 0)) then
								this.isFirst = false;
								Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "SET_CLUB_FIRST_TIP_OVER", nil, nil, 0.00));
							end;
						elseif UnityEngine.Input.GetKey(274) then
							this.starttime = UnityEngine.Time.time;
							this:OnCameraBack();
--取消初始提示
							if (this.isFirst and (PlayerPrefs_Ex.GetInt__System_String__System_Int32__System_Boolean("ClubFirstTip", 0, false) == 0)) then
								this.isFirst = false;
								Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "SET_CLUB_FIRST_TIP_OVER", nil, nil, 0.00));
							end;
						end;
						this:TouchFunction();
					end;
					if UnityEngine.Input.GetMouseButtonDown(0) then
						local ray; ray = this.ClubCamera:ScreenPointToRay(UnityEngine.Input.mousePosition);
--从摄像机发出到点击坐标的射线
--从摄像机发出到点击坐标的射线
						local hitInfo;
						if (function() local __compiler_invoke_279; __compiler_invoke_279, hitInfo = UnityEngine.Physics.Raycast(ray, 1000000.00); return __compiler_invoke_279; end)() then
							Eight.Framework.EIDebuger.Log(("hitInfo : " + hitInfo.collider.transform:ToString()));
							local objname; objname = hitInfo.collider.gameObject.name;
							if (((invokeforbasicvalue(objname, false, System.String, "Contains", "mount_npc00") or invokeforbasicvalue(objname, false, System.String, "Contains", "_quest")) or invokeforbasicvalue(objname, false, System.String, "Contains", "_door")) or invokeforbasicvalue(objname, false, System.String, "Contains", "mount_player00")) then
								local typeid; typeid = typecast(hitInfo.collider.gameObject:GetComponent(SingleNpc).Data.PageType, System.Int32, false);
								Eight.Framework.EIFrameWork.Instance:DispatchEvent(newobject(Eight.Framework.EIEvent, "ctor__System_String__Eight_Framework_EIEvent_ReturnCallBack__System_Object__System_Single", nil, "GO_NPC_PAGE", nil, typecast(typeid, System.Object, false), 0.00));
							end;
						end;
					end;
				end;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				STNpcs = newexternlist(System.Collections.Generic.List_SingleNpc, "System.Collections.Generic.List_SingleNpc", "ctor", {}),
				ClubHeader = __cs2lua_nil_field_value,
				ClubBestTeamer = __cs2lua_nil_field_value,
				ClubCamera = __cs2lua_nil_field_value,
				InfoLv = 1,
				ShoLv = 1,
				MRoomLv = 1,
				SkyObjs = newexternlist(System.Collections.Generic.List_UnityEngine.GameObject, "System.Collections.Generic.List_UnityEngine.GameObject", "ctor", {}),
				dayHour = 1,
				CurSencePage = 0,
				distance = (UnityEngine.Screen.width / 3.00),
				TstartPos = newexternobject(UnityEngine.Vector2, "UnityEngine.Vector2", "ctor", nil),
				isFirst = true,
				starttime = -1.00,
			};
			return instance_fields;
		end;

		local instance_props = {
			ClubCameraAni = {
				get = instance_methods.get_ClubCameraAni,
			},
		};

		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(EIUIBehaviour, "ClubHouseController", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};




ClubHouseController.SencePage = {
	["Main"] = 0,
	["Left"] = 1,
	["Right"] = 2,
};

rawset(ClubHouseController.SencePage, "Value2String", {
		[0] = "Main",
		[1] = "Left",
		[2] = "Right",
});
ClubHouseController.__define_class();
