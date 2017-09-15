require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "ChatBaseDes";
require "LogicStatic";
require "ChatMsgURLContent";
require "ChatMsgManager";

ChatEquipmentDes = {
	__new_object = function(...)
		return newobject(ChatEquipmentDes, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatEquipmentDes;

		local static_methods = {
			cctor = function()
				ChatBaseDes.cctor(this);
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
			JoinSendStr = function(this, obj)
				local str; str = System.String.Empty;
				local serdata; serdata = typeas(obj, EightGame.Data.Server.EquipmentSerData, false);
				local equip; equip = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_equipment_equip), serdata.staticid);
				if (equip == nil) then
					return str;
				end;
				local extraStr; extraStr = System.String.Format("id={1},breakskill={0},randattr={2},rankuplv={3},staticid={4},wearfighter={5},staticid={6}", serdata.breakskill, serdata.id, serdata.randattr, serdata.rankuplv, serdata.staticid, serdata.wearfighter, serdata.staticid);
				str = System.String.Format("itemtype=equipment,itemstaticid={0},itemgid={1}", equip.id, serdata.id);
				return str;
			end,
			AnalysSendStr = function(this, obj)
				local itemContent; itemContent = typecast(obj, System.String, false);
				local contentArray; contentArray = invokeforbasicvalue(itemContent, false, System.String, "Split", wraparray{"itemtype=", ",itemstaticid=", ",itemgid="}, 1);
				local itemtype; itemtype = System.String.Empty;
				local itemstiticid; itemstiticid = 0;
				local itemGid; itemGid = 0;
				local extraObj; extraObj = System.String.Empty;
				if (contentArray.Length > 2) then
					itemtype = contentArray[1];
					itemstiticid = System.Int32.Parse(contentArray[2]);
					itemGid = System.Int64.Parse(contentArray[3]);
				end;
				local t; t = newobject(ChatMsgURLContent, "ctor__System_String__System_Int32__System_Int64__System_String__System_String__System_String", nil, itemtype, itemstiticid, itemGid, "", itemContent, "");
				return t;
			end,
			JoinURLStr = function(this, obj)
				local t; t = typeas(obj, ChatMsgURLContent, false);
				local itemstiticid; itemstiticid = t.itemstiticid;
				local itemName; itemName = System.String.Empty;
				local itemColor; itemColor = System.String.Empty;
				local characterStr; characterStr = t.characterStr;
				local itemContent; itemContent = t.itemcontent;
				local str; str = System.String.Empty;
				local equip; equip = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_equipment_equip), itemstiticid);
				if (equip ~= nil) then
					itemName = equip.name;
					itemColor = ChatMsgManager.Instance:GetColorByRank(equip.rank);
				end;
				str = System.String.Format("{0}[url={1}][{2}][[u]{3}[/u]][/url]", characterStr, itemContent, itemColor, itemName);
				return str;
			end,
			AnalysisExtraStr = function(this, str)
				if System.String.IsNullOrEmpty(str) then
					return nil;
				end;
				local id; id = 0;
				local breakskill; breakskill = System.String.Empty;
				local randattr; randattr = System.String.Empty;
				local rankuplv; rankuplv = 0;
				local wearfighter; wearfighter = 0;
				local staticId; staticId = 0;
				local contentArray; contentArray = invokeforbasicvalue(str, false, System.String, "Split", wraparray{"id=", ",breakskill=", ",randattr=", ",rankuplv=", ",wearfighter=", ",staticid="}, 1);
				if (contentArray.Length > 5) then
					id = System.Int64.Parse(contentArray[1]);
					breakskill = contentArray[2];
					randattr = contentArray[3];
					rankuplv = System.Int32.Parse(contentArray[4]);
					wearfighter = System.Int64.Parse(contentArray[5]);
					staticId = System.Int32.Parse(contentArray[6]);
				end;
				local serdata; serdata = newexternobject(EightGame.Data.Server.EquipmentSerData, "EightGame.Data.Server.EquipmentSerData", "ctor", nil);
				serdata.id = id;
				serdata.breakskill = breakskill;
				serdata.randattr = randattr;
				serdata.rankuplv = rankuplv;
				serdata.wearfighter = wearfighter;
				serdata.staticid = staticId;
				return serdata;
			end,
			ctor = function(this)
				this.base.ctor(this);
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(ChatBaseDes, "ChatEquipmentDes", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatEquipmentDes.__define_class();
