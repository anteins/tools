
apply_files = [
    "EightGame__Logic__",
    "eightgame__logic"
]

ban_methods = [
    "__init__", 
    "__ctor1__", 
    "__ctor2__", 
    "__staticInit__", 
    "Dispose", 
    "ctor",
    "OnEnter",
    "Start", 
    "OnUpdate",
    "Update",
]

ban_lines = [
    "this.base"
    "AddMissingComponent",
    "UITweener.Begin",
    "CheckAndAddComponet",
    "GetComponentInChildren",
    "NGUITools", 
    "PadLeft",
    "this.entity"
]

key_value = {
    # api
    "obj_list" : "LuaUtil.new_List",
    "obj_dict" : "LuaUtil.new_Dictionary",
    "obj_array" : "LuaUtil.new_Array",
    "obj_getValue" : "c_get",
    "obj_setValue" : "c_set",
    "obj_len" : "c_len",
    "obj_isnil" : "c_isnil",
    "obj_tostring" : "c_tostring",
    "obj_div" : "c_div",
    "obj_fromCharCode" : "c_fromCharCode",
    "obj_toCharArray" : "c_toCharArray",
    "obj_contains" : "c_contains",
    "obj_trim" : "c_trim",
    "obj_split" : "c_split",
    # "CS.System.String.Concat" : "StringUtil.Concat",
    "EightFramework" : "CS.Eight.Framework",
    "EightGameComponent" : "CS.EightGame.Component",
    "EightGameLogic" : "CS.EightGame.Logic",
    "EightGame.Component." : "CS.EightGame.Component.",
    "EightGame.Logic." : "CS.EightGame.Logic.",
    "EightGame.Data.Server" : "CS.EightGame.Data.Server",
    "UnityEngine" : "CS.UnityEngine",
    "MiniJSON" : "CS.MiniJSON",
    "UIEventListener" : "CS.UIEventListener",
    "System" : "CS.System",
    # NGUI
    "UIEventListener" : "CS.UIEventListener",
    # others
    "M.i18n" : "CS.M.i18n",
    "BindComponent__EIEntityBehaviour" : "BindComponent",
    "GetDataByCls__CS_System_Predicate_T" : "GetDataByCls",
    "Get__CS_System_Int32" : "Get",
    "Get__CS_System_Predicate_T" : "Get",
}