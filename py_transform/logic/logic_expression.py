
import os,sys
from py_transform.utils import utils
from py_transform.utils import block_utils
from py_transform.utils import bracket_utils
from py_transform.utils import match_utils
from py_transform.utils import common

def handle(line, _debug = False):
    if "newexternlist" in line:
        lmatch = match_utils.get_match(line, "{0} newexternlist({1})", ["\w.*", "\w.*"])
        if lmatch != []:
            largv = utils.dump_argv(lmatch[1])
            if len(largv)>1:
                sname = largv[0]
                slist = sname.split("_")
                name = slist[1]
                line = match_utils.handle_match(line, ["{0} c_list({1})", lmatch[0], name])

    # newexterndictionary({0}) --> c_dictionary({0}, {1})
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
                    mixsub2 = match_utils.handle_match(subline, ["c_dictionary({0}, {1})", key, value])
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
        # def bracket_cb(index, parent, subline):
        #     if "condexp(" in parent:
        #         mixsub2 = subline
        #         full_str = parent.format(subline)
        #         lmatch = match_utils.get_match(full_str, "condexp({0})", ["\w*.*"])
        #         _origin = match_utils.origin()
        #         if lmatch !=[]:
        #             largv = utils.dump_argv(lmatch[0])
        #             if len(largv)>=5:
        #                 head, _1, mid, _2 = largv[0:4]
        #                 reat = " ".join(largv[4:])
        #                 print "head ", head
        #                 print "mid ", mid
        #                 print "reat ", reat
        #                 ok, reat = match_utils.play_match(reat, "(function() return {0} end)", "{0}", ["\w*.*"])
        #                 mixsub2 = match_utils.handle_match_by_origin(full_str, _origin, ["{0} and {1} or {2}", head, mid, reat])
        #         return parent, mixsub2
        #     return parent, subline
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
                    line = match_utils.handle_match_by_origin(line, _origin, ["{0}c_foreach({1}, {2})", chr(common.S)*_offset, _list, _func])
    
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
                        mixsub2 = match_utils.handle_match(subline, ["c_div({0}, {1}) ", _left, _right])
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
                        mixsub2 = match_utils.handle_match(subline, ["c_get({0}, {1})", _obj, _index])
                    elif _type == "set_Item" or _type == "set_Chars":
                        mixsub2 = match_utils.handle_match(subline, ["c_set({0}, {1})", _obj, _index])
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
                        mixsub2 = match_utils.handle_match(subline, ["c_get({0}, {1})", _obj, _index])
                    elif _type == "set_Item" or _type == "set_Chars":
                        mixsub2 = match_utils.handle_match(subline, ["c_set({0}, {1}, {2})", _obj, _index, val])
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
                            mixsub2 = match_utils.handle_match(subline, ["c_isnil({0})", _left, _right])
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
                        mixsub2 = match_utils.handle_match(subline, ["not c_isnil({0})", _obj])
            return mixsub2
        line = bracket_utils.handle_bracket(line, "invokeexternoperator", bracket_cb)

    if "externdelegationcomparewithnil" in line:
        def bracket_cb(subline, debug=False):
            mixsub2 = subline
            lmatch = match_utils.get_match(subline, "externdelegationcomparewithnil({0})", ["\w*.*"])
            if lmatch != []:
                largv = utils.dump_argv(lmatch[0])
                if len(largv)>=6:
                    isevent, isStatic, key, this, null, field, is_equal = largv[0:7]
                    if field == "nil":
                        result = this
                    else:
                        field = field.replace("\"", "")
                        result = this+"."+field
                    if "true" in is_equal:
                        mixsub2 = match_utils.handle_match(subline, ["c_isnil({0})", result])
                    else:
                        mixsub2 = match_utils.handle_match(subline, ["not c_isnil({0})", result])
            return mixsub2
        line = bracket_utils.handle_bracket(line, "externdelegationcomparewithnil", bracket_cb)

    # delegationcomparewithnil ---> c_isnil
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
                        mixsub2 = match_utils.handle_match(subline, ["c_isnil({0})", result])
                    else:
                        mixsub2 = match_utils.handle_match(subline, ["not c_isnil({0})", result])
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

    if "wrapconst" in line:
        def bracket_cb(subline, debug=False):
            lmatch = match_utils.get_match(subline, "wrapconst({0})", ["\w*.*"])
            if lmatch != []:
                largv = utils.dump_argv(lmatch[0])
                if len(largv)>1:
                    enum = "{0}.{1}".format(largv[0], largv[1].replace("\"", ""))
                    mixsub2 = match_utils.handle_match(subline, ["{0}", enum])
            return mixsub2
        line = bracket_utils.handle_bracket(line, "wrapconst", bracket_cb)

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
                    mixsub2 = match_utils.handle_match(subline, ["c_randomRange({0}, {1})", a, b])
            return mixsub2
        line = bracket_utils.handle_bracket(line, "UnityEngine.Random.Range", bracket_cb)

    if ":GetComponent" in line:
        lmatch = match_utils.get_match(line, ":GetComponent({0})", ["[a-zA-Z0-9_\.:\]\[\"]*"])
        if len(lmatch) > 0:
            reps = lmatch[0].split(".")[-1]
            if reps.startswith("typeof"):
                reps = reps.replace("typeof", "").strip().strip("(").strip(")")
            if not "\"" in reps:
                reps = "\"" + reps + "\""
            line = line.replace(lmatch[0], reps)

    if ":AddComponent" in line:
        lmatch = match_utils.get_match(line, ":AddComponent({0})", ["[A-Za-z0-9_\.]*"])
        if len(lmatch) > 0:
            reps = lmatch[0].split(".")[-1]
            if reps.startswith("typeof"):
                reps = reps.replace("typeof", "").strip().strip("(").strip(")")
            reps = "typeof(" + reps + ")"
            line = line.replace(lmatch[0], reps)

    if ":Push" in line:
        lmatch = match_utils.get_match(line, ":Push({0}, {1})", ["[A-Za-z0-9_\.]*", "[A-Za-z0-9_\.]*"])
        if len(lmatch) > 1:
            for match in lmatch:
                reps = match.split(".")[-1]
                if reps.startswith("typeof"):
                    reps = reps.replace("typeof", "").strip().strip("(").strip(")")
                reps = "typeof(" + reps + ")"
                line = line.replace(match, reps)

    if ":_PushView" in line:
        lmatch = match_utils.get_match(line, ":_PushView({0}, nil)", ["[A-Za-z0-9_\.]*"])
        if len(lmatch) > 0:
            reps = lmatch[0].split(".")[-1]
            if reps.startswith("typeof"):
                reps = reps.replace("typeof", "").strip().strip("(").strip(")")
            reps = "typeof(" + reps + ")"
            line = line.replace(lmatch[0], reps)

    match  = match_utils.get_match(line, "{0}[{1}]", ["[a-zA-Z0-9_\.]*", "[a-zA-Z0-9#_\. \-\+:\"]*"])
    if match != []:
        if len(match)>=2 and match[0] != "" and match[1] != "":
            ok, line  = match_utils.play_match(line, "{0}[{1}]", "c_get({0}, {1})", ["[a-zA-Z0-9_\.\"]*", "[a-zA-Z0-9#_\. \-\+:\"]*"], _debug)

    # match  = match_utils.get_match(line, "if ({0} == {1}) then", ["[A-Za-z0-9_\.\[\]]*", "[0-9]*"])
    # if len(match)>1:
    #     line = match_utils.handle_match(line, ["if (CS.System.Convert.ToInt32({0}) == {1}) then", match[0], match[1]])

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

    if "__compiler_invoke" in line:
        lmatch  = match_utils.get_match(line, "(function() local __compiler_invoke{0}()", ["\w*.*"])
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

    if "__" in line:
        tmp = line.split("__")
        if len(tmp) >= 2:
            old_head = tmp[0]
            old_tail = tmp[-1]
            old_tails = old_tail.split("(")
            line = old_head + "(" + "(".join(old_tails[1:])
    return line