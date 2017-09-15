require "cs2lua__utility";
require "cs2lua__attributes";
require "cs2lua__namespaces";
require "cs2lua__externenums";
require "cs2lua__interfaces";
require "UIInput";
require "NGUIText";

ChatInput = {
	__new_object = function(...)
		return newobject(ChatInput, nil, nil, ...);
	end,
	__define_class = function()
		local static = ChatInput;

		local static_methods = {
			cctor = function()
			end,
		};

		local static_fields_build = function()
			local static_fields = {
				__attributes = ChatInput__Attrs,
			};
			return static_fields;
		end;
		local static_props = nil;
		local static_events = nil;

		local instance_methods = {
			Start = function(this)
				this.mInput = this:GetComponent(UIInput);
				this.mInput.label.maxLineCount = 1;
				if (this.fillWithDummyData and invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this.textList, nil)) then
					local i; i = 0;
					while (i < 30) do
						this.textList:Add__System_String((((( condexp(( (invokeintegeroperator(1, "%", i, 2, System.Int32, System.Int32) == 0) ), true, "[FFFFFF]", true, "[AAAAAA]") ) + "This is an example paragraph for the text list, testing line ") + i) + "[-]"));
					i = invokeintegeroperator(2, "+", i, 1, System.Int32, System.Int32);
					end;
				end;
			end,
			OnSubmit = function(this)
				if invokeexternoperator(CS.UnityEngine.Object, "op_Inequality", this.textList, nil) then
-- It's a good idea to strip out all symbols as we don't want user input to alter colors, add new lines, etc
					local text; text = NGUIText.StripSymbols(this.mInput.value);
					if (not System.String.IsNullOrEmpty(text)) then
						this.textList:Add__System_String(text);
						this.mInput.value = "";
						this.mInput.isSelected = false;
					end;
				end;
			end,
			ctor = function(this)
			end,
		};

		local instance_fields_build = function()
			local instance_fields = {
				textList = __cs2lua_nil_field_value,
				fillWithDummyData = false,
				mInput = __cs2lua_nil_field_value,
				__attributes = ChatInput__Attrs,
			};
			return instance_fields;
		end;
		local instance_props = nil;
		local instance_events = nil;
		local interfaces = nil;
		local interface_map = nil;

		return defineclass(UnityEngine.MonoBehaviour, "ChatInput", static, static_methods, static_fields_build, static_props, static_events, instance_methods, instance_fields_build, instance_props, instance_events, interfaces, interface_map, false);
	end,
};



ChatInput.__define_class();
