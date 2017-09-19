
import os,sys, re
import utils.utils as utils
import utils.blockUtils as blockUtils
import utils.bracketUtils as bracketUtils
import utils.matchUtils as matchUtils
import utils.common as common

def abs_replace(line, origin, dest, debug=False):
    neworigin = r"\b{0}\b".format(origin)
    newline = re.sub(neworigin, dest, line)
    return newline
        
def lineBuilder(outblock):
    newblock = []
    for line in outblock:
        _debug = False
        line = abs_replace(line, "EightFramework", "CS.Eight.Framework")
        line = abs_replace(line, "EightGameLogic", "CS.EightGame.Logic")
        line = abs_replace(line, "EightGameComponent", "CS.EightGame.Component")
        line = line.replace("\" + ", "\" .. ")
        if line.strip() == "end,":
            line = line.replace("end,", "end")
        
        lmatch = matchUtils.get_match(line, "{0} newexternlist({1})", ["\w.*", "\w.*"])
        if lmatch != []:
            _argv1 = lmatch[1].split(",")[0]
            _argv1 = _argv1.split("_")
            if len(_argv1)>1:
                _argv1 = _argv1[1]
                line = matchUtils.handle_match(line, ["{0} XLuaScriptUtils.new_List_1(typeof({1}))", lmatch[0], _argv1])

        if "newexterndictionary" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "newexterndictionary({0})", ["\w*.*"])
                if lmatch !=[]:
                    largv = lmatch[0].split(",")[0].split("_")
                    if len(largv)>=2:
                        _key = "typeof({0})".format(largv[1])
                        _value = "typeof({0})".format(largv[2])
                        mixsub2 = matchUtils.handle_match(subline, ["XLuaScriptUtils.new_Dictionary_2({0}, {1})", _key, _value])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "newexterndictionary", bracket_cb)

        if "newobject" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "newobject({0})", ["\w*.*"])
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _obj = largv[0]
                        _lobjArgv = largv[3:]
                        mixsub2 = matchUtils.handle_match(subline, ["{0}({1}) ", _obj, ",".join(_lobjArgv)])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "newobject", bracket_cb)

        if "condexp" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "condexp({0})", ["\w*.*"])
                _origin = matchUtils.origin()
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=5:
                        _head, _1, _mid, _2 = largv[0:4]
                        reat = " ".join(largv[4:])
                        ok, reat = matchUtils.play_match(reat, "(function() return {0} end)", "{0}", ["\w*.*"])
                        mixsub2 = matchUtils.handle_match_by_origin(subline, _origin, ["{0} and {1} or {2}", _head, _mid, reat])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "condexp", bracket_cb)

        if "wrapyield" in line:
            lmatch = matchUtils.get_match(line, "wrapyield({0})", ["\w*.*"])
            if lmatch != []:
                largv = utils.dump_argv(lmatch[0])
                if len(largv)>=2:
                    _head = largv[0]
                    line = matchUtils.handle_match(line, ["coroutine.yield({0})", _head])

        if "ForEach" in line:
            lmatch = matchUtils.get_match(line, "{0}:ForEach({1})", ["\w*.*", "\w*.*"])
            _origin = matchUtils.origin()
            if len(lmatch)>=1:
                _offset = utils.space_count(line)
                _list = lmatch[0].lstrip()
                largv = utils.dump_argv(lmatch[1])
                if len(largv)>0:
                    _func = largv[0].strip().strip("(").strip(")")
                    _func2 = matchUtils.get_match(_func, "function({0}){1}end", ["[A-Za-z0-9_\.\[\]]", "\w*.*"])
                    _ori = matchUtils.origin()
                    if len(_func2) > 0:
                        _add = "{0} = {0}.current".format(_func2[0])
                        _func = matchUtils.handle_match_by_origin(_func, _ori, ["function({0}) {1}; {2}end", _func2[0], _add, _func2[1]])
                        line = matchUtils.handle_match_by_origin(line, _origin, ["{0}foreach({1}, {2})", chr(common.S)*_offset, _list, _func])
        
        if "typeas" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "typeas({0})", ["\w*.*"])
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=2:
                        _op  = largv[0]
                        mixsub2 = matchUtils.handle_match(subline, ["{0}", _op])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "typeas", bracket_cb)

        if "invokeintegeroperator" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "invokeintegeroperator({0})", ["\w*.*"])
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=5:
                        _op, _left, _right,  = largv[1:4]
                        _op = _op.replace("\"", "")
                        if _op == "/":
                            mixsub2 = matchUtils.handle_match(subline, ["div({0}, {1}) ", _left, _right])
                        else:
                            mixsub2 = matchUtils.handle_match(subline, ["{0}{1}{2} ", _left, _op, _right])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "invokeintegeroperator", bracket_cb)

        if "newexternobject" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "newexternobject({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _head, nil1, nil2, nil3 = largv[0:4]
                        _argv = largv[4:]
                        _argv = ",".join(_argv)
                        mixsub2 = matchUtils.handle_match(subline, ["{0}({1})", _head, _argv])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "newexternobject", bracket_cb)

        if "getexterninstanceindexer" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "getexterninstanceindexer({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _obj, _nil, _type, _index = largv[0:4]
                        _type = _type.replace("\"", "").strip()
                        if _type == "get_Item" or _type == "get_Chars":
                            mixsub2 = matchUtils.handle_match(subline, ["DictGetValue({0}, {1})", _obj, _index])
                        elif _type == "set_Item" or _type == "set_Chars":
                            mixsub2 = matchUtils.handle_match(subline, ["DictSetValue({0}, {1})", _obj, _index])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "getexterninstanceindexer", bracket_cb)

        if "delegationset" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                if bracketUtils.check_bracket(subline):
                    lmatch = matchUtils.get_match(subline, "delegationset({0})", ["\w*.*"])
                    if lmatch != []:
                        largv = utils.dump_argv(lmatch[0])
                        if len(largv)>=7:
                            _obj, _nil, _f, _fdes = largv[3:7]
                            _fdes = _fdes.split(";")
                            if len(_fdes)>1:
                                _fdes = _fdes[0].split("=")
                                if len(_fdes)>1:
                                    _fdes = _fdes[1] + " end)"
                            if isinstance(_fdes, list):
                                _fdes = _fdes[0]
                            _f = _f.replace("\"", "")
                            mixsub2 = matchUtils.handle_match(subline, ["{0}.{1} = {2}", _obj, _f, _fdes])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "delegationset", bracket_cb)

        if "typecast" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "typecast({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=2:
                        _obj = largv[0]
                        _obj = _obj.lstrip("(").rstrip(")")
                        mixsub2 = matchUtils.handle_match(subline, ["{0}", _obj])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "typecast", bracket_cb)
        
        if "getforbasicvalue" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "getforbasicvalue({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _obj = largv[0]
                        _type = largv[-1].replace("\"", "")
                        mixsub2 = matchUtils.handle_match(subline, ["{0}.{1}", _obj, _type])

                return mixsub2
            line = bracketUtils.handle_bracket(line, "getforbasicvalue", bracket_cb)

        if "invokeforbasicvalue" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "invokeforbasicvalue({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _obj, _bool, _type, _f = largv[0:4]
                        _argv = largv[4:]
                        _f = _f.replace("\"", "")
                        _argv = ",".join(_argv)
                        if _argv == "":
                            mixsub2 = matchUtils.handle_match(subline, ["{0}({1})", _f, _obj])
                        else:
                            mixsub2 = matchUtils.handle_match(subline, ["{0}({1}, {2})", _f, _obj, _argv])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "invokeforbasicvalue", bracket_cb)

        if "invokeexternoperator" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "invokeexternoperator({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _op = largv[1]
                        _reat = largv[2:]
                        if "op_Equality" in _op:
                            _left, _right = _reat[0:2]
                            if "nil" in _right:
                                mixsub2 = matchUtils.handle_match(subline, ["isnil({0})", _left, _right])
                            else:
                                mixsub2 = matchUtils.handle_match(subline, ["{0} == {1}", _left, _right])
                        elif "op_Addition" in _op:
                            _left, _right = _reat[0:2]
                            mixsub2 = matchUtils.handle_match(subline, ["{0} + {1}", _left, _right])
                        elif "op_Subtraction" in _op:
                            _left, _right = _reat[0:2]
                            mixsub2 = matchUtils.handle_match(subline, ["{0} - {1}", _left, _right])
                        elif "op_Implicit" in _op or "op_Inequality" in _op:
                            _obj= _reat[0]
                            mixsub2 = matchUtils.handle_match(subline, ["not isnil({0})", _obj])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "invokeexternoperator", bracket_cb)

        if "externdelegationcomparewithnil" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "externdelegationcomparewithnil({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=6:
                        isevent, isStatic, key, t, inf, k, isequal = largv[0:7]
                        if "true" in isequal:
                            mixsub2 = matchUtils.handle_match(subline, ["{0} == {1}", t, k])
                        else:
                            mixsub2 = matchUtils.handle_match(subline, ["{0} ~= {1}", t, k])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "externdelegationcomparewithnil", bracket_cb)

        if "System.Text.Encoding.UTF8:GetString" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "System.Text.Encoding.UTF8:GetString({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>0:
                        _obj = largv[0]
                        mixsub2 = matchUtils.handle_match(subline, ["{0}", _obj])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "System.Text.Encoding.UTF8:GetString", bracket_cb)

        # def bracket_cb(subline, debug=False):
        #     lmatch = matchUtils.get_match(subline, "wrapconst({0})", ["\w*.*"])
        #     if lmatch != []:
        #         largv = utils.dump_argv(lmatch[0])
        #         if len(largv)>1:
        #             _obj = "{0}.{1}".format(largv[0], largv[1].replace("\"", ""))
        #             mixsub2 = matchUtils.handle_match(subline, ["{0}", matchUtils.make_one_match(_obj)])
        #             line = line.replace(subline, mixsub2)
        #     return line
        # line = bracketUtils.handle_bracket(line, "wrapconst", bracket_cb)

        if "wrapchar" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "wrapchar({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=2:
                        _obj = largv[0]
                        mixsub2 = matchUtils.handle_match(subline, ["{0}", _obj])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "wrapchar", bracket_cb)

        if "GetService" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "GetService({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=1:
                        _obj = largv[0]
                        mixsub2 = matchUtils.handle_match(subline, ["GetService(typeof({0}))", _obj])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "GetService", bracket_cb)

        if "UnityEngine.Random.Range" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = matchUtils.get_match(subline, "CS.UnityEngine.Random.Range({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=1:
                        _obj = largv[0]
                        mixsub2 = matchUtils.handle_match(subline, ["math.ceil(CS.UnityEngine.Random.Range({0}))", _obj])
                return mixsub2
            line = bracketUtils.handle_bracket(line, "CS.UnityEngine.Random.Range", bracket_cb)
        
        lmatch  = matchUtils.get_match(line, "{0}[{1}]", ["[a-zA-Z0-9_\.]*", "[a-zA-Z0-9#_\. \-\+:\"]*"])
        if lmatch != []:
            if len(lmatch)>=2 and lmatch[0] != "" and lmatch[1] != "":
                ok, line  = matchUtils.play_match(line, "{0}[{1}]", "DictGetValue({0}, {1})", ["[a-zA-Z0-9_\.\"]*", "[a-zA-Z0-9#_\. \-\+:\"]*"], _debug)

        if not "System.String.Format" in line:
            ok, line = matchUtils.play_match(line, "#{0}", "obj_len({0})", ["[a-zA-Z0-9_.:\]\[]*"], _debug)

        ok, line = matchUtils.play_match(line, "{0}.Count", "obj_len({0})", ["[a-zA-Z0-9_\.:\]\[\"]*"], _debug)
        ok, line = matchUtils.play_match(line, "{0}.Length", "obj_len({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)
        
        lmatch  = matchUtils.get_match(line, "if ({0} == {1}) then", ["[A-Za-z0-9_\.\[\]]*", "[0-9]*"])
        if len(lmatch)>1:
            line = matchUtils.handle_match(line, ["if (CS.System.Convert.ToInt32({0}) == {1}) then", lmatch[0], lmatch[1]])

        lmatch  = matchUtils.get_match(line, "(function() local __compiler_delegation{0}()", ["\w*.*"])
        _reps = matchUtils.origin()
        if len(lmatch)>0:
            _fdes = lmatch[0].split(";")
            if len(_fdes)>1:
                _fdes = _fdes[0].split("=")
                if len(_fdes)>1:
                    _fdes = _fdes[1] + " end"
            if isinstance(_fdes, list):
                _fdes = _fdes[0]
            _fdes = _fdes.strip().strip("(").strip(")")
            line = line.replace(_reps, _fdes)

        if "__" in line and not line.startswith("function "):
            _regx = "[A-Za-z0-9\. \"\[\]\(\)]*"
            lmatch  = matchUtils.get_match(line, "{0}__{1}({2}", [_regx, _regx, "\w*.*"])
            _origin = matchUtils.origin()
            if len(lmatch) > 2:
                _Head = lmatch[0].split(".")
                _Argv = lmatch[2].strip().strip("(").strip(")")
                largv = utils.dump_argv(_Argv)
                if largv[0]==_Head[0]:
                    del(largv[0])
                if largv[-1] == ";":
                    del(largv[-1])

                if len(_Head)>1:
                    _reps = "{0}.{1}({2}".format(_Head[0], _Head[1], ",".join(largv))
                else:
                    _reps = "{0}({1}".format(_Head[0], ",".join(largv))
                line = line.replace(_origin, _reps)

        line = abs_replace(line, "System.Int32.Parse", "tonumber")
        line = abs_replace(line, "Eight.Framework.EIDebuger.Log", "GameLog")
        line = abs_replace(line, "ToString", "tostring")
        line = abs_replace(line, "Ms +", "Ms ..")
        line = abs_replace(line, "System.String.Empty", "\"\"")

        if line.strip() == "end),":
            line = line.replace("end),", "end")

        if ".Invoke();" in line:
            line = line.replace(".Invoke();", "();")

        line = line.replace("Ms +", "Ms ..")
        line = line.replace(", nil, nil, nil);", ");")
        line = line.replace("Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources)", "XLuaScriptUtils.GameResources()")
        line = line.replace("Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.ServiceCenter)", "XLuaScriptUtils.ServiceCenter()")
        line = line.replace("Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameRandom)", "XLuaScriptUtils.GameRandom()")
        line = line.replace("coroutine.yield(coroutine.coroutine);", "if coroutine.coroutine then\ncoroutine.yield(coroutine.coroutine)\nend")
        line = line.replace("LogicStatic.Get__System_Predicate_T", "mylua.LogicStatic:Get")
        line = line.replace("LogicStatic.Get__System_Int32", "mylua.LogicStatic:Get")
        line = line.replace("LogicStatic.Get__System_Int64", "mylua.LogicStatic:Get")
        line = line.replace("LogicStatic.Get", "mylua.LogicStatic:Get")
        line = line.replace("CS.System.String.IsNullOrEmpty", "isnil")

        lmatch = matchUtils.get_match(line, ":GetComponent({0})", ["[a-zA-Z0-9_\.:\]\[\"]*"])
        if len(lmatch) > 0:
            reps = lmatch[0].split(".")[-1]
            if reps.startswith("typeof"):
                reps = reps.replace("typeof", "").strip().strip("(").strip(")")
            if not "\"" in reps:
                reps = "\"" + reps + "\""
            line = line.replace(lmatch[0], reps)

        lmatch = matchUtils.get_match(line, ":AddComponent({0})", ["[A-Za-z0-9_\.]*"])
        if len(lmatch) > 0:
            reps = lmatch[0].split(".")[-1]
            if reps.startswith("typeof"):
                reps = reps.replace("typeof", "").strip().strip("(").strip(")")
            reps = "typeof(" + reps + ")"
            line = line.replace(lmatch[0], reps)

        lmatch = matchUtils.get_match(line, ":Push({0}, {1})", ["[A-Za-z0-9_\.]*", "[A-Za-z0-9_\.]*"])
        if len(lmatch) > 1:
            for match in lmatch:
                reps = match.split(".")[-1]
                if reps.startswith("typeof"):
                    reps = reps.replace("typeof", "").strip().strip("(").strip(")")
                reps = "typeof(" + reps + ")"
                line = line.replace(match, reps)

        lmatch = matchUtils.get_match(line, ":_PushView({0}, nil)", ["[A-Za-z0-9_\.]*"])
        if len(lmatch) > 0:
            reps = lmatch[0].split(".")[-1]
            if reps.startswith("typeof"):
                reps = reps.replace("typeof", "").strip().strip("(").strip(")")
            reps = "typeof(" + reps + ")"
            line = line.replace(lmatch[0], reps)

        cstype = [
            "Eight.Framework",
            "EightGame.Component",
            "EightGame.Logic",
            "EightGame.Data.Server",
            "UnityEngine",
            "MiniJSON",
            "UIEventListener",
            "System"
        ]
        for _t in cstype:
            line = abs_replace(line, _t, "CS.{0}".format(_t))

        line = abs_replace(line, "CS.CS.", "CS.")
        if not line.strip().startswith("local"):
            line = line.replace(";", " ")

        newblock.append(line)
    return newblock