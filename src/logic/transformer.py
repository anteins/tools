
import os,sys, re
import utils.utils as utils
import utils.block_utils as block_utils
import utils.bracket_utils as bracket_utils
import utils.match_utils as match_utils
import utils.common as common
import utils.message as message

def abs_replace(line, origin, dest, debug=False):
    neworigin = r"\b{0}\b".format(origin)
    newline = re.sub(neworigin, dest, line)
    return newline
        
def lineBuilder(outblock):
    newblock = []
    for line in outblock:
        _debug = False
        line = line.replace("\" + ", "\" .. ")
        line = line.replace(" + \" ", " .. \" ")

        if line.strip() == "end,":
            line = line.replace("end,", "end")
        
        if "newexternlist" in line:
            lmatch = match_utils.get_match(line, "{0} newexternlist({1})", ["\w.*", "\w.*"])
            if lmatch != []:
                largv = utils.dump_argv(lmatch[1])
                if len(largv)>1:
                    sname = largv[0]
                    slist = sname.split("_")
                    name = slist[1]
                    line = match_utils.handle_match(line, ["{0} obj_list({1})", lmatch[0], name])

        if "newexterndictionary" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "newexterndictionary({0})", ["\w*.*"])
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=2:
                        sname = largv[0]
                        slist = sname.split("_")
                        key = slist[1]
                        value = slist[2]
                        mixsub2 = match_utils.handle_match(subline, ["obj_dictionary({0}, {1})", key, value])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "newexterndictionary", bracket_cb)

        if "newobject" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "newobject({0})", ["\w*.*"])
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        obj = largv[0]
                        llargv = largv[3:]
                        mixsub2 = match_utils.handle_match(subline, ["{0}({1}) ", obj, ",".join(llargv)])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "newobject", bracket_cb)

        if "condexp" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "condexp({0})", ["\w*.*"])
                _origin = match_utils.origin()
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=5:
                        head, _1, mid, _2 = largv[0:4]
                        reat = " ".join(largv[4:])
                        ok, reat = match_utils.play_match(reat, "(function() return {0} end)", "{0}", ["\w*.*"])
                        mixsub2 = match_utils.handle_match_by_origin(subline, _origin, ["{0} and {1} or {2}", head, mid, reat])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "condexp", bracket_cb)

        if "wrapyield" in line:
            lmatch = match_utils.get_match(line, "wrapyield({0})", ["\w*.*"])
            if lmatch != []:
                largv = utils.dump_argv(lmatch[0])
                if len(largv)>=2:
                    head = largv[0]
                    line = match_utils.handle_match(line, ["coroutine.yield({0})", head])

        if "ForEach" in line:
            lmatch = match_utils.get_match(line, "{0}:ForEach({1})", ["\w*.*", "\w*.*"])
            _origin = match_utils.origin()
            if len(lmatch)>=1:
                _offset = utils.space_count(line)
                _list = lmatch[0].lstrip()
                largv = utils.dump_argv(lmatch[1])
                if len(largv)>0:
                    _func = largv[0].strip().strip("(").strip(")")
                    _func2 = match_utils.get_match(_func, "function({0}){1}end", ["[A-Za-z0-9_\.\[\]]", "\w*.*"])
                    _ori = match_utils.origin()
                    if len(_func2) > 0:
                        _add = "{0} = {0}.current".format(_func2[0])
                        _func = match_utils.handle_match_by_origin(_func, _ori, ["function({0}) {1}; {2}end", _func2[0], _add, _func2[1]])
                        line = match_utils.handle_match_by_origin(line, _origin, ["{0}obj_foreach({1}, {2})", chr(common.S)*_offset, _list, _func])
        
        if "typeas" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "typeas({0})", ["\w*.*"])
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=2:
                        oper  = largv[0]
                        mixsub2 = match_utils.handle_match(subline, ["{0}", oper])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "typeas", bracket_cb)

        if "invokeintegeroperator" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "invokeintegeroperator({0})", ["\w*.*"])
                if lmatch !=[]:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=5:
                        oper, _left, _right,  = largv[1:4]
                        oper = oper.replace("\"", "")
                        if oper == "/":
                            mixsub2 = match_utils.handle_match(subline, ["obj_div({0}, {1}) ", _left, _right])
                        else:
                            mixsub2 = match_utils.handle_match(subline, ["{0}{1}{2} ", _left, oper, _right])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "invokeintegeroperator", bracket_cb)

        if "newexternobject" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "newexternobject({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        head, nil1, nil2, nil3 = largv[0:4]
                        argv = ",".join(largv[4:])
                        mixsub2 = match_utils.handle_match(subline, ["{0}({1})", head, argv])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "newexternobject", bracket_cb)

        if "getexterninstanceindexer" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "getexterninstanceindexer({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _obj, _nil, _type, _index = largv[0:4]
                        _type = _type.replace("\"", "").strip()
                        if _type == "get_Item" or _type == "get_Chars":
                            mixsub2 = match_utils.handle_match(subline, ["obj_getValue({0}, {1})", _obj, _index])
                        elif _type == "set_Item" or _type == "set_Chars":
                            mixsub2 = match_utils.handle_match(subline, ["obj_setValue({0}, {1})", _obj, _index])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "getexterninstanceindexer", bracket_cb)

        if "setexterninstanceindexer" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "setexterninstanceindexer({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _obj, _nil, _type, _index, val = largv[0:5]
                        _type = _type.replace("\"", "").strip()
                        if _type == "get_Item" or _type == "get_Chars":
                            mixsub2 = match_utils.handle_match(subline, ["obj_getValue({0}, {1})", _obj, _index])
                        elif _type == "set_Item" or _type == "set_Chars":
                            mixsub2 = match_utils.handle_match(subline, ["obj_setValue({0}, {1}, {2})", _obj, _index, val])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "setexterninstanceindexer", bracket_cb)

        if "typecast" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "typecast({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=2:
                        _obj = largv[0]
                        # _obj = _obj.lstrip("(").rstrip(")")
                        mixsub2 = match_utils.handle_match(subline, ["{0}", _obj])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "typecast", bracket_cb)
            
        if "getforbasicvalue" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "getforbasicvalue({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _obj = largv[0]
                        _type = largv[-1].replace("\"", "")
                        mixsub2 = match_utils.handle_match(subline, ["{0}.{1}", _obj, _type])

                return mixsub2
            line = bracket_utils.handle_bracket(line, "getforbasicvalue", bracket_cb)

        if "invokeforbasicvalue" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "invokeforbasicvalue({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        _obj, _bool, _type, _f = largv[0:4]
                        _argv = largv[4:]
                        _f = _f.replace("\"", "")
                        _argv = ",".join(_argv)
                        if _argv == "":
                            mixsub2 = match_utils.handle_match(subline, ["{0}({1})", _f, _obj])
                        else:
                            mixsub2 = match_utils.handle_match(subline, ["{0}.{1}({2})", _obj, _f, _argv])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "invokeforbasicvalue", bracket_cb)

        if "invokeexternoperator" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "invokeexternoperator({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=3:
                        op = largv[1]
                        reat = largv[2:]
                        if "op_Equality" in op:
                            _left, _right = reat[0:2]
                            if "nil" in _right:
                                mixsub2 = match_utils.handle_match(subline, ["obj_isnil({0})", _left, _right])
                            else:
                                mixsub2 = match_utils.handle_match(subline, ["{0} == {1}", _left, _right])
                        elif "op_Addition" in op or "op_UnaryPlus" in op:
                            if len(reat) > 1:
                                _left, _right = reat[0:2]
                                mixsub2 = match_utils.handle_match(subline, ["{0} + {1}", _left, _right])
                        elif "op_Subtraction" in op or "op_UnaryNegation" in op:
                            if len(reat) > 1:
                                _left, _right = reat[0:2]
                                mixsub2 = match_utils.handle_match(subline, ["{0} - {1}", _left, _right])
                        elif "op_Multiply" in op:
                            if len(reat) > 1:
                                _left, _right = reat[0:2]
                                mixsub2 = match_utils.handle_match(subline, ["{0} * {1}", _left, _right])
                        elif "op_Division" in op:
                            if len(reat) > 1:
                                _left, _right = reat[0:2]
                                mixsub2 = match_utils.handle_match(subline, ["{0} / {1}", _left, _right])
                        elif "op_LessThan" in op:
                            if len(reat) > 1:
                                _left, _right = reat[0:2]
                                mixsub2 = match_utils.handle_match(subline, ["{0} < {1}", _left, _right])
                        elif "op_GreaterThan" in op:
                            if len(reat) > 1:
                                _left, _right = reat[0:2]
                                mixsub2 = match_utils.handle_match(subline, ["{0} > {1}", _left, _right])
                        elif "op_LessThanOrEqual" in op:
                            if len(reat) > 1:
                                _left, _right = reat[0:2]
                                mixsub2 = match_utils.handle_match(subline, ["{0} <= {1}", _left, _right])
                        elif "op_GreaterThanOrEqual" in op:
                            if len(reat) > 1:
                                _left, _right = reat[0:2]
                                mixsub2 = match_utils.handle_match(subline, ["{0} >= {1}", _left, _right])
                        elif "op_Implicit" in op or "op_Inequality" in op:
                            _obj= reat[0]
                            mixsub2 = match_utils.handle_match(subline, ["not obj_isnil({0})", _obj])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "invokeexternoperator", bracket_cb)

        if "externdelegationcomparewithnil" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "externdelegationcomparewithnil({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=6:
                        isevent, isStatic, key, this, null, field, isequal = largv[0:7]
                        if field == "nil":
                            result = this
                        else:
                            field = field.replace("\"", "")
                            result = this+"."+field
                        if "true" in isequal:
                            mixsub2 = match_utils.handle_match(subline, ["obj_isnil({0})", result])
                        else:
                            mixsub2 = match_utils.handle_match(subline, ["not obj_isnil({0})", result])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "externdelegationcomparewithnil", bracket_cb)

        if "delegationcomparewithnil" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "delegationcomparewithnil({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=6:
                        isevent, isStatic, key, this, null, field, isequal = largv[0:7]
                        if field == "nil":
                            result = this
                        else:
                            field = field.replace("\"", "")
                            result = this+"."+field
                        if "true" in isequal:
                            mixsub2 = match_utils.handle_match(subline, ["obj_isnil({0})", result])
                        else:
                            mixsub2 = match_utils.handle_match(subline, ["not obj_isnil({0})", result])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "delegationcomparewithnil", bracket_cb)

        if "System.Text.Encoding.UTF8:GetString" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "System.Text.Encoding.UTF8:GetString({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>0:
                        _obj = largv[0]
                        mixsub2 = match_utils.handle_match(subline, ["{0}", _obj])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "System.Text.Encoding.UTF8:GetString", bracket_cb)

        # def bracket_cb(subline, debug=False):
        #     lmatch = match_utils.get_match(subline, "wrapconst({0})", ["\w*.*"])
        #     if lmatch != []:
        #         largv = utils.dump_argv(lmatch[0])
        #         if len(largv)>1:
        #             _obj = "{0}.{1}".format(largv[0], largv[1].replace("\"", ""))
        #             mixsub2 = match_utils.handle_match(subline, ["{0}", match_utils.make_one_match(_obj)])
        #             line = line.replace(subline, mixsub2)
        #     return line
        # line = bracket_utils.handle_bracket(line, "wrapconst", bracket_cb)

        if "wrapchar" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "wrapchar({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=2:
                        _obj = largv[0]
                        mixsub2 = match_utils.handle_match(subline, ["{0}", _obj])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "wrapchar", bracket_cb)

        if "GetService" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "GetService({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=1:
                        _obj = largv[0]
                        mixsub2 = match_utils.handle_match(subline, ["GetService(typeof({0}))", _obj])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "GetService", bracket_cb)

        if "UnityEngine.Random.Range" in line:
            def bracket_cb(subline, debug=False):
                mixsub2 = subline
                lmatch = match_utils.get_match(subline, "UnityEngine.Random.Range({0})", ["\w*.*"])
                if lmatch != []:
                    largv = utils.dump_argv(lmatch[0])
                    if len(largv)>=1:
                        a, b = largv[0:2]
                        mixsub2 = match_utils.handle_match(subline, ["obj_randomRange({0}, {1})", a, b])
                return mixsub2
            line = bracket_utils.handle_bracket(line, "UnityEngine.Random.Range", bracket_cb)

        ltmp = [
            "(1)",
            "(2)",
            "(3)",
            "(4)",
            "(5)",
            "(6)",
            "(7)",
            "(8)",
            "(9)",
        ]
        for ii in ltmp:
            if ii in line:
                lmatch  = match_utils.get_match(line, "{0}({1})", ["[a-zA-Z0-9_\.]*", "[0-9]*"])
                if lmatch != []:
                    line = match_utils.handle_match(line, ["{0}()", lmatch[0]])
                break

        lmatch  = match_utils.get_match(line, "{0}[{1}]", ["[a-zA-Z0-9_\.]*", "[a-zA-Z0-9#_\. \-\+:\"]*"])
        if lmatch != []:
            if len(lmatch)>=2 and lmatch[0] != "" and lmatch[1] != "":
                ok, line  = match_utils.play_match(line, "{0}[{1}]", "obj_getValue({0}, {1})", ["[a-zA-Z0-9_\.\"]*", "[a-zA-Z0-9#_\. \-\+:\"]*"], _debug)

        if not "System.String.Format" in line:
            ok, line = match_utils.play_match(line, "#{0}", "obj_len({0})", ["[a-zA-Z0-9_.:\]\[]*"], _debug)

        ok, line = match_utils.play_match(line, "{0}.Count", "obj_len({0})", ["[a-zA-Z0-9_\.:\]\[]*"], _debug)
        ok, line = match_utils.play_match(line, "{0}.Length", "obj_len({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)
        ok, line = match_utils.play_match(line, "{0}:ToString()", "obj_tostring({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)
        ok, line = match_utils.play_match(line, "{0}.Split({1})", "obj_split({0}, {1})", ["[a-zA-Z0-9_\.:\]\[]*", "\w*.*"], _debug)
        ok, line = match_utils.play_match(line, "delegationwrap({0})", "{0}", ["\w*.*"], _debug)
        
        lmatch  = match_utils.get_match(line, "if ({0} == {1}) then", ["[A-Za-z0-9_\.\[\]]*", "[0-9]*"])
        if len(lmatch)>1:
            line = match_utils.handle_match(line, ["if (CS.System.Convert.ToInt32({0}) == {1}) then", lmatch[0], lmatch[1]])

        if "__compiler_delegation" in line:
            lmatch  = match_utils.get_match(line, "(function() local __compiler_delegation{0}()", ["\w*.*"])
            origin = match_utils.origin()
            if len(lmatch)>0:
                fdes = lmatch[0].split(";")
                if len(fdes)>1:
                    fdes = fdes[0].split("=")
                    if len(fdes)>1:
                        fdes = fdes[1] + " end"
                if isinstance(fdes, list):
                    fdes = fdes[0]
                fdes = fdes.strip().strip("(").strip(")")
                line = line.replace(origin, fdes)

        line = abs_replace(line, "System.Int32.Parse", "tonumber")
        line = abs_replace(line, "Eight.Framework.EIDebuger.Log", "GameLog")
        line = abs_replace(line, "ToString", "obj_tostring")
        line = abs_replace(line, "Ms +", "Ms ..")
        line = abs_replace(line, "ToCharArray", "obj_toCharArray")
        line = abs_replace(line, "fromCharCode", "obj_fromCharCode")
        # line = abs_replace(line, "Contains", "obj_contains")
        # line = abs_replace(line, "Trim", "obj_trim")
        # line = abs_replace(line, "EndsWith", "obj_endsWith")
        line = line.replace("+ System.String.Format", ".. System.String.Format")
        line = abs_replace(line, "System.String.Empty", "\"\"")

        if line.strip() == "end),":
            line = line.replace("end),", "end")

        if ".Invoke();" in line:
            line = line.replace(".Invoke();", "();")

        line = line.replace("Ms +", "Ms ..")
        line = line.replace(", nil, nil, nil);", ");")
      
        sc = utils.space_count(line)
        line = line.replace("coroutine.yield(coroutine.coroutine);", "if coroutine.coroutine then\n{0}coroutine.yield(coroutine.coroutine)\n{1}end".format(chr(common.S) * (sc + 1), chr(common.S) * (sc)))
        line = line.replace("CS.System.String.IsNullOrEmpty", "obj_isnil")
        
        cstype = [
            "UnityEngine",
            "MiniJSON",
            "System"
        ]
        for _t in cstype:
            line = abs_replace(line, _t, "CS.{0}".format(_t))

        line = abs_replace(line, "CS.CS.", "CS.")
        if not line.strip().startswith("local"):
            line = line.replace(";", " ")

        newblock.append(line)
    return newblock