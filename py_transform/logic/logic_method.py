
import os,sys
from py_transform.utils import utils
from py_transform.utils import block_utils
from py_transform.utils import bracket_utils
from py_transform.utils import match_utils
from py_transform.utils import common

def handle(line, _debug = False):
    if not "System.String.Format" in line:
        ok, line = match_utils.play_match(line, "#{0}", "obj_len({0})", ["[a-zA-Z0-9_.:\]\[]*"], _debug)
    ok, line = match_utils.play_match(line, "{0}.Count", "obj_len({0})", ["[a-zA-Z0-9_\.:\]\[]*"], _debug)
    ok, line = match_utils.play_match(line, "{0}.Length", "obj_len({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)
    ok, line = match_utils.play_match(line, "{0}:ToString()", "obj_tostring({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)
    ok, line = match_utils.play_match(line, "{0}.Split({1})", "obj_split({0}, {1})", ["[a-zA-Z0-9_\.:\]\[]*", "\w*.*"], _debug)
    ok, line = match_utils.play_match(line, "delegationwrap({0})", "{0}", ["\w*.*"], _debug)

    line = utils.abs_replace(line, "System.Int32.Parse", "tonumber")
    line = utils.abs_replace(line, "Eight.Framework.EIDebuger.Log", "GameLog")
    line = utils.abs_replace(line, "ToString", "obj_tostring")
    line = utils.abs_replace(line, "Ms +", "Ms ..")
    line = utils.abs_replace(line, "ToCharArray", "obj_toCharArray")
    line = utils.abs_replace(line, "fromCharCode", "obj_fromCharCode")
    # line = utils.abs_replace(line, "Contains", "obj_contains")
    # line = utils.abs_replace(line, "Trim", "obj_trim")
    # line = utils.abs_replace(line, "EndsWith", "obj_endsWith")
    line = line.replace("+ System.String.Format", ".. System.String.Format")
    line = utils.abs_replace(line, "System.String.Empty", "\"\"")

    if "Eight.Framework.EIFrameWork.GetComponent" in line:
        line = line.replace("Eight.Framework.EIFrameWork.GetComponent", "LuaUtil.EIFrameWork.GetEIComponent")
        # line = line.replace("Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter)", "XLuaScriptUtils.ServiceCenter()")
        # line = line.replace("Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameRandom)", "XLuaScriptUtils.GameRandom()")
        # line = line.replace("Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.NetworkClient)", "XLuaScriptUtils.NetworkClient()")

    sc = utils.space_count(line)
    line = line.replace("coroutine.yield(coroutine.coroutine);", "if coroutine.coroutine then\n{0}coroutine.yield(coroutine.coroutine)\n{1}end".format(chr(common.S) * (sc + 1), chr(common.S) * (sc)))
    line = line.replace("LogicStatic.Get", "LuaUtil.LogicStatic.Get")
    line = line.replace("CS.System.String.IsNullOrEmpty", "obj_isnil")

    return line