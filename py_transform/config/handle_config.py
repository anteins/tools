
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
    "get",
    "set",
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

static_name = {
    # api
    "System.Int32.Parse" : "tonumber",
    "Eight.Framework.EIDebuger.Log" : "GameLog",
    "ToCharArray" : "c_toCharArray",
    "fromCharCode" : "c_fromCharCode",
    "Contains" : "c_contains",
    "Trim" : "c_trim",
    "EndsWith" : "c_endsWith",
    "System.String.Empty" : "\"\"",
    "Ms +" : "Ms ..",
    "+ System.String.Format" : ".. System.String.Format",

    "c_list" : "LuaUtil.new_List",
    "c_dict" : "LuaUtil.new_Dictionary",
    "c_array" : "LuaUtil.new_Array",
    "CS.System.String.IsNullOrEmpty" : "c_isnil",
    "CS.System.Convert.ToInt32":"tonumber",
    # LuaUtil
    "LogicStatic.GetList" : "LuaUtil.LogicStatic.GetList",
    "LogicStatic.Get" : "LuaUtil.LogicStatic.Get",
    "Eight.Framework.EIFrameWork.GetComponent" : "LuaUtil.EIFrameWork.GetComponent",
    "LuaUtil.LuaUtil." : "LuaUtil.", 
    # CS
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
    "CS.Eight.Framework.EIDebuger.LogError" : "LogError",
    # NGUI
    "UIEventListener" : "CS.UIEventListener",
    # others
    "M.i18n" : "CS.M.i18n",
}