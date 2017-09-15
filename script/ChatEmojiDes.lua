require "cs2lua__utility";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "ChatBaseDes";
require "ChatMsgURLContent";
require "LogicStatic";

ChatEmojiDes = {
	__new_object = function(...)
		return newobject(ChatEmojiDes, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatEmojiDes;

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
				local chatemoji; chatemoji = typeas(obj, EightGame.Data.Server.sd_chatemoji, false);
				if (chatemoji == nil) then
					return str;
				end;
				str = System.String.Format("itemtype=emoji,itemstaticid={0},itemgid={1}", chatemoji.id, 0);
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
				local str; str = System.String.Empty;
				local t; t = typeas(obj, ChatMsgURLContent, false);
				local emoji; emoji = LogicStatic.Get__System_Int32(typeof(EightGame.Data.Server.sd_chatemoji), t.itemstiticid);
				if (emoji == nil) then
					str = System.String.Empty;
				else
					str = System.String.Format("表情");
				end;
				return str;
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

		return defineclass(ChatBaseDes, "ChatEmojiDes", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatEmojiDes.__define_class();
