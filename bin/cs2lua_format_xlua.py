# -*- coding: cp936 -*-

import os,sys, re
import shutil

class FindType(object):
    ext = []
    Filter = []
    pathFilter = []
    ScriptFolder = ""
    OutputFolder = ""
    lines = []
    limit = False
    luaModel = {}
    S = 9   #tab
    T = 32  #space
    LUA_MODEL_TAG = "_lua_"
    lNoHotfix = [
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
    _targets = []

    lGetFunc = [
        {"BaseChatItemCom" : 
            [
                "SetContentBgSpriteWidth", 
                "ClickLbl"
            ]
        }
    ]

    def __init__(self, argv):
        if argv == None:
            self._root = os.getcwd()
        else:
            self.ScriptFolder = argv[1]
            self.OutputFolder = argv[2]
        print "="*20
        print "self.ScriptFolder:" + self.ScriptFolder
        print "self.OutputFolder:" + self.OutputFolder
        print "="*20

    def IsTargetExt(self, filename):
        flag = False
        for target in self.ext:
            if target in filename:
                flag = True
                break
        return flag

    def IsTargetFile(self, filename):
        flag = False
        if self._targets == []:
            return True
        else:
            return filename in self._targets

    def IsPassFile(self, filename):
        flag = False
        for filter in self.Filter:
            if filter in filename:
                flag = True
                break
        return flag

    def IsPassPath(self, path):
        flag = False
        for filt in self.pathFilter:
            if self.ScriptFolder + "/" + filt == path:
                flag = True
                break
        return flag

    def setFilter(self, target, filte, path_filte):
        self.ext = target
        self.Filter = filte
        self.pathFilter = path_filte
    
    def ReplaceEx(self, line, origin, dest, debug=False):
        neworigin = r"\b{0}\b".format(origin)
        newline = re.sub(neworigin, dest, line)
        return newline

    def space_count(self, line, debug=False):
        _hc=0
        _end_match = False
        _start_match = False
        _count = -1
        for i in line:
            _count = _count + 1
            #before match
            if _start_match == False and _end_match == False:
                if ord(i) ==self.S:
                    _start_match = True
                    _hc=_hc+1
                elif ord(i) ==self.T:#Tab
                    _lline = list(line)
                    _lline[_count] = chr(self.S)
                    line = "".join(_lline)
                    _hc=_hc+1
                elif ord(i) == 47:#/
                    if ord(line[_count+1]) == 47:#//
                        pass
                else:
                    break
            #matching
            elif _start_match == True and _end_match == False:
                if ord(i)==self.S:
                    _hc=_hc+1
                else:
                    _end_match = True
            #end match 
            elif _start_match == True and _end_match == True:
                break
        return _hc

    def GetFunctions(self):
        for _dict in self.lGetFunc:
            if _dict.has_key(self.luaModel["module"]):
                return _dict[self.luaModel["module"]]
        return []

    def DebugInfo(self, debug, lines):
        if debug:
            sStr = ""
            for line in lines:
                sStr = "{0}\n{1}".format(sStr, line)
            print sStr

    def Match(self, line, origin, char, isExReCompile, debug=False):
        matchP = origin.replace("(", "\(").replace(")", "\)")
        matchP = matchP.replace(".", "\.")
        matchP = matchP.replace("[", "\[").replace("]", "\]")
        iParam = len(re.compile(r"\{\w\}*").findall(matchP))
        for i in xrange(0, iParam):
            matchP = matchP.replace("{"+str(i)+"}", "({"+str(i)+"})")
        lMatch = matchP.format(*char)
        ret = re.compile(lMatch).findall(line)
        origin_line = ""
        
        for _match in ret:
            if isinstance(_match, str):
                origin_line = origin.format(_match)
            elif isinstance(_match, tuple):
                origin_line = origin.format(*_match)

        if isExReCompile == "":
            if len(ret)>0:
                if isinstance(ret, tuple):
                    ret = list(ret)
                elif isinstance(ret[0], tuple):
                    ret = list(ret[0])
        if debug:
            if ret != []:
                print "###:", ret
        return origin_line, ret

    def Play(self, line, origin, dest, tuple_origin, debug=False):
        _origin, lmatch = self.Match(line, origin, tuple_origin, "", debug)
        bFlag = False
        if len(lmatch)>0:
            bFlag = True
            self.DebugInfo(debug, ["-"*100, line.lstrip()])
            self.DebugInfo(debug, [_origin, lmatch])
            line = self.doMatch(line, _origin, [dest, tuple(lmatch)], debug)
            self.DebugInfo(debug, ["line:", line])
        return bFlag, line

    def doMatch(self, line, origin, ldest, debug=False):
        self.DebugInfo(debug, ["-"*100, line.lstrip()])
        _form = origin
        sDest = ldest[0]
        tMatch = tuple(ldest[1:])
        if len(tMatch) == 1:
            tMatch = tMatch[0]
        lmatch = self.make_one_match(tMatch)
        for tMatch in lmatch:
            if isinstance(tMatch, str):
                _to = sDest.format(tMatch)
            elif isinstance(tMatch, tuple):
                _to = sDest.format(*tMatch)
            line = line.replace( _form, _to)
            self.DebugInfo(debug, [_form, "|__", _to, "|__", line.lstrip()])
        return line

    def cmd(self, cmd, log=False):
        if log:
            print cmd
        else:
            cmd = cmd + " 1>nul"
        os.system(cmd)

    def merge_block(self, oldblock, newblock, info):
        if info and info != []:
            _count = 0
            for lnum in info:
                oldblock[lnum] = newblock[_count]
                _count = _count + 1
        return oldblock

    def get_defs_argv(self, def_name):
        _argv = []
        for func in self.luaModel["functions"]:
            if func[0] == def_name:
                _argv = func[1]
                break
        return _argv

    def make_one_match(self, *obj):
        lRet = []
        if len(obj)>1:
            tRet = obj
        else:
            tRet = obj[0]
        lRet.append(tRet)
        return lRet

    #for mult line struct obj
    def to_xlua_method_block(self, block):
        _match, _merge, _block = self.get_block(block, ["for {0} in getiterator({1}) do", "\w.*", "\w.*"], ["end;", []])
        while _match != []:
            _newblock = []
            _count = 0
            for line in _block:
                _count = _count + 1
                if _count == 1:
                    space = self.space_count(line)
                    _origin, lmatch = self.Match(line, "for {0} in getiterator({1}) do", ["\w.*", "\w.*"], "")
                    _space = self.space_count(line)
                    line = chr(self.S)*_space + "foreach({0}, function (item)".format(lmatch[1])
                    for argv in lmatch[0].split(','):
                        if argv != "_":
                            line = line + "\n{0}local {1} = item.current\n".format(chr(self.S)*(_space+1), argv)
                elif _count == len(_block):
                    line = chr(self.S)*(_space) + "end)\n"
                else:
                    if line.strip() == "break;":
                        _space = self.space_count(line)
                        line = chr(self.S)*_space + "return \"break\";\n"
                _newblock.append(line)

            block = self.merge_block(block, _newblock, _merge)
            _match, _merge, _block = self.get_block(block, ["for {0} in getiterator({1}) do", "\w.*", "\w.*"], ["end;", []])

        _newblock = []
        regx = "[A-Za-z0-9\. \"\[\]\(\)]*"
        _match, _merge, _block = self.get_block(block, ["EventDelegate.Add__{0}", "\w*.*"], ["", []], [""])
        if _match != []:
            for i, line in enumerate(_block):
                if i == 0:
                    _s = self.space_count(line)
                    _ori1, _lma1 = self.Match(_match[0], "{0}({1}", ["[A-Za-z0-9_]*", "\w*.*"], "")
                    line = chr(self.S)*_s + "EventDelegate.Add({0}\n".format(_lma1[1]) 
                    print line
                if i == len(_block)-1:
                    print line
                _newblock.append(line)
        block = self.merge_block(block, _newblock, _merge)

        return block

    SYMBOLS = {')':'('}
    SYMBOLS_L, SYMBOLS_R = SYMBOLS.values(), SYMBOLS.keys()
    SYMBOLS_B, SYMBOLS_S = ',', ' '
    SYMBOLS_CHAR = "'"
    def dump_argv(self, line, debug=False):
        if debug:
            print line
        arr = []
        lchar = []
        lArgv = []
        _inBracket = False
        _i = 0
        for c in line:
            if debug:
                print "c:", c
            if c in '(' or c in '[':
                lchar.append(c)
                arr.append(c)
            elif c in ')' or c in ']':
                lchar.append(c)
                if len(arr) !=0:
                    arr.pop()
                if debug:
                    print ">", "".join(lchar)
                if len(arr) == 0:
                    if _i+1 < len(line) and line[_i+1] == ".":
                        pass
                    else:
                        if lchar !=[]:
                            lArgv.append("".join(lchar))
                        lchar = []
            else:
                if c in ',':
                    if len(arr) != 0:
                        lchar.append(c)
                    else:
                        if lchar !=[]:
                            lArgv.append("".join(lchar))
                        lchar = []
                elif c in ' ':
                    if len(arr) != 0:
                        lchar.append(c)
                elif c in self.SYMBOLS_CHAR:
                    if len(arr) == 0:
                        lchar.append(c)
                        arr.append(c)
                    elif arr[0] == self.SYMBOLS_CHAR:
                        lchar.append(c)
                        lArgv.append("".join(lchar))
                        lchar = []
                    else:
                        lchar.append(c)
                else:
                    lchar.append(c)
            _i = _i + 1
        if lchar !=[]:
            lArgv.append("".join(lchar))
        if debug:
            print "lArgv:", lArgv
        return lArgv

    def check_ok_bracket(self, line, debug=False):
        arr = []
        largv = []
        lchar = []
        for c in line:
            if c in self.SYMBOLS_L:
                arr.append(c)
                lchar.append(c)
            elif c in self.SYMBOLS_R:
                lchar.append(c)
                if len(arr)!=0:
                    arr.pop()
                if len(arr)==0:
                    largv.append("".join(lchar))
                    break
            else:
                lchar.append(c)
        return len(arr)==0

    def get_bracket(self, line, startswith, debug=False):
        _head = ""
        if line == "" or line.lstrip().startswith("--"):
            return _head

        _slen = len(startswith)
        _head = line
        bAtLeastOne = False
        _offset = 0
        try:
            _index = _head.index(startswith)
            _head = _head[_index:]
            while _head != None:
                bAtLeastOne = True
                _tmp = _head[_slen:]
                _index = _tmp.index(startswith)
                _head = _tmp[_index:]
        except:
            if not bAtLeastOne:
                _head = ""
        arr = []
        lchar = []
        for c in _head:
            if c in self.SYMBOLS_L:
                arr.append(c)
                lchar.append(c)
            elif c in self.SYMBOLS_R:
                lchar.append(c)
                if len(arr)!=0:
                    arr.pop()
                if len(arr)==0:
                    _head = "".join(lchar)
                    break
            else:
                lchar.append(c)

        return _head

    def get_mult_bracket(self, line, startstr, debug=False):
        lbracket = []
        _count = 0
        while True:
            subline = self.get_bracket(line, startstr)
            if subline != "":
                regx = "%" + str(_count) + "%"
                line = line.replace(subline, regx)
                lbracket.append([_count, subline, line])
                _count = _count + 1
            else:
                break
        return lbracket

    def match_mult_bracket(self, line, startstr, handler, debug=False):
        if debug:
            print "="*100
            print line.lstrip()

        lbracket = self.get_mult_bracket(line, startstr, debug)
        for back in lbracket:
            if debug:
                print ">", back
        output = self.merge_mult_bracket(line, lbracket, handler, debug)
        if debug:
            print "output:", output
        return output

    def merge_mult_bracket(self, line, lbracket, handler, debug):
        index = len(lbracket)-1
        output = line
        if index >=0:
            ret = lbracket[index]
            output = ret[2]
            for x in range(index, -1, -1):
                regx = "%" + str(x) + "%"
                _reps = lbracket[x][1]
                _reps = handler(lbracket[x][1])
                output = output.replace(regx, _reps)
        return output

    def get_block(self, lines, start_u, end_u, style=[""], debug=False):
        bAlign = True
        if "no_align" in style:
            bAlign = False
        iStartAlign = 0
        iEndAlign = 0
        bGetStart = False
        bGetEnd = False
        isOK = False
        _rBlock = []
        _mergeInfo = []
        _start_u = []
        _end_u = []
        if debug:
            print "-"*50, start_u
        for index, line in enumerate(lines):
            if not bGetStart:
                tmp = start_u[1:]
                _origin, lmatch = self.Match(line, start_u[0], start_u[1:], "")
                if len(lmatch)>0:
                    if isinstance(lmatch, tuple):
                        _start_u = list(lmatch[0])
                    else:
                        _start_u = lmatch
                    iStartAlign = self.space_count(line)
                    bGetStart = True
                    if debug:
                        print "@: ", iStartAlign, line
                    _mergeInfo.append(index)
                    _rBlock.append(line)
            elif bGetStart:
                _origin, _endMatch = self.Match(line, end_u[0], end_u[1], "")
                if bAlign:
                    iEndAlign = self.space_count(line)
                    isAlignMatch = iEndAlign == iStartAlign
                    isMatch = isAlignMatch and len(_endMatch) > 0
                else:
                    isMatch = len(_endMatch) > 0

                if isMatch:
                    bGetEnd = True
                    if isinstance(_endMatch, tuple):
                        _end_u = list(_endMatch)
                    else:
                        _end_u = _endMatch
                    if debug:
                        print "#: ", iEndAlign, line
                    _mergeInfo.append(index)
                    _rBlock.append(line)
                    break
                else:
                    iMidAlign = self.space_count(line)
                    if debug:
                        print "~: ", iMidAlign, line
                    if iMidAlign > iStartAlign:
                        _mergeInfo.append(index)
                        _rBlock.append(line)

        if not bGetStart:
            isOK = False
            if debug:
                print "fck!!!!! no start line."
        elif not bGetEnd:
            isOK = False
            if debug:
                print "fck!!!!! no end line.", len(_rBlock)
            if len(_rBlock) == 1 and self.check_ok_bracket(_rBlock[0]):
                if debug:
                    print "but is ok."
                isOK = True
        else:
            isOK = True
            
        if isOK:
            if len(_rBlock)>1:
                if "no_head_and_end" in style:
                    del(_mergeInfo[0])
                    del(_rBlock[0])
                    del(_mergeInfo[len(_mergeInfo)-1])
                    del(_rBlock[len(_rBlock)-1])
                if "remove_head_and_end" in style:
                    _rBlock[0] = ""
                    _rBlock[len(_rBlock)-1] = ""
        else:
            _rBlock = []
            _mergeInfo = []

        for _end in _end_u:
            _start_u.append(_end)
        _match_u = _start_u
        return _match_u, _mergeInfo, _rBlock

    def get_mult_block(self, block, start_u, end_u, style=[""], debug=False):
        target_block = block
        rList = []
        while len(target_block) > 0:
            _match1, _info1, _block = self.get_block(target_block, start_u, end_u, style, debug)
            if debug:
                print "-"*100
            rList.append([_match1, _info1, _block])
            if len(_match1) == [] or len(_info1) == 0:
                break
            _start1 = _info1[0]
            _end1 = _info1[len(_info1)-1]+1
            if debug:
                print _match1, _end1, len(target_block)
            target_block = target_block[_end1:]
        return rList

    def argv_l2s(self, lArgv, iType=""):
        _lArgv = []
        _i = 0
        for argv in lArgv:
            _i = _i + 1
            if iType == "no_this" and _i == 1:
                if argv == "this":
                    continue
            _lArgv.append(argv)
        return ','.join(_lArgv)

    def tp_xlua_style_block(self, block):
        lNewBlock = []
        for line in block:
            _debug = False
            line = self.ReplaceEx(line, "EightFramework", "CS.Eight.Framework")
            line = self.ReplaceEx(line, "EightGameLogic", "CS.EightGame.Logic")
            line = self.ReplaceEx(line, "EightGameComponent", "CS.EightGame.Component")
            line = line.replace("\" + ", "\" .. ")
            line = line.replace("end,", "end")
            
            _origin, lmatch = self.Match(line, "{0} newexternlist({1})", ["\w.*", "\w.*"], "")
            if lmatch != []:
                _argv1 = lmatch[1].split(",")[0]
                _argv1 = _argv1.split("_")
                if len(_argv1)>1:
                    _argv1 = _argv1[1]
                    line = self.doMatch(line, _origin, ["{0} GameLuaApi.new_List_1(typeof({1}))", lmatch[0], _argv1])

            if "newexterndictionary" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "newexterndictionary({0})", ["\w*.*"], "")
                    if lmatch !=[]:
                        largv = lmatch[0].split(",")[0].split("_")
                        if len(largv)>=2:
                            _key = "typeof({0})".format(largv[1])
                            _value = "typeof({0})".format(largv[2])
                            mixsub2 = self.doMatch(subline, _origin, ["GameLuaApi.new_Dictionary_2({0}, {1})", _key, _value])
                    return mixsub2
                line = self.match_mult_bracket(line, "newexterndictionary", __handler2)

            if "newobject" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "newobject({0})", ["\w*.*"], "")
                    if lmatch !=[]:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=3:
                            _obj = largv[0]
                            _lobjArgv = largv[3:]
                            mixsub2 = self.doMatch(subline, _origin, ["{0}({1}) ", _obj, ",".join(_lobjArgv)])
                    return mixsub2
                line = self.match_mult_bracket(line, "newobject", __handler2)

            if "condexp" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "condexp({0})", ["\w*.*"], "")
                    if lmatch !=[]:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=5:
                            _head, _1, _mid, _2 = largv[0:4]
                            reat = " ".join(largv[4:])
                            ok, reat = self.Play(reat, "(function() return {0} end)", "{0}", ["\w*.*"])
                            mixsub2 = self.doMatch(subline, _origin, ["{0} and {1} or {2}", _head, _mid, reat])
                    return mixsub2
                line = self.match_mult_bracket(line, "condexp", __handler2)

            _origin, lmatch = self.Match(line, "wrapyield({0})", ["\w*.*"], "")
            if lmatch != []:
                largv = self.dump_argv(lmatch[0])
                if len(largv)>=2:
                    _head = largv[0]
                    line = self.doMatch(line, _origin, ["coroutine.yield({0})", _head])

            _origin, lmatch = self.Match(line, "{0}:ForEach({1})", ["\w*.*", "\w*.*"], "")
            if len(lmatch)>=1:
                _offset = self.space_count(line)
                _list = lmatch[0].lstrip()
                largv = self.dump_argv(lmatch[1])
                if len(largv)>0:
                    _func = largv[0]
                    _func = _func.strip().strip("(").strip(")")
                    _ori, _func2 = self.Match(_func, "function({0}){1}end", ["[A-Za-z0-9_\.\[\]]", "\w*.*"], "")
                    if len(_func2) > 0:
                        _add = "{0} = {0}.current".format(_func2[0])
                        _func = self.doMatch(_func, _ori, ["function({0}) {1}; {2}end", _func2[0], _add, _func2[1]])
                        line = self.doMatch(line, _origin, ["{0}foreach({1}, {2})", chr(self.S)*_offset, _list, _func])
            
            if "typeas" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "typeas({0})", ["\w*.*"], "")
                    if lmatch !=[]:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=2:
                            _op  = largv[0]
                            mixsub2 = self.doMatch(subline, _origin, ["{0}", _op])
                    return mixsub2
                line = self.match_mult_bracket(line, "typeas", __handler2)

            if "invokeintegeroperator" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "invokeintegeroperator({0})", ["\w*.*"], "")
                    if lmatch !=[]:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=5:
                            _op, _left, _right,  = largv[1:4]
                            _op = _op.replace("\"", "")
                            if _op == "/":
                                mixsub2 = self.doMatch(subline, _origin, ["div({0}, {1}) ", _left, _right])
                            else:
                                mixsub2 = self.doMatch(subline, _origin, ["{0}{1}{2} ", _left, _op, _right])    
                    return mixsub2
                line = self.match_mult_bracket(line, "invokeintegeroperator", __handler2)

            if "newexternobject" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "newexternobject({0})", ["\w*.*"], "")
                    if lmatch != []:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=3:
                            _head, nil1, nil2, nil3 = largv[0:4]
                            _argv = largv[4:]
                            _argv = ",".join(_argv)
                            mixsub2 = self.doMatch(subline, _origin, ["{0}({1})", _head, _argv])
                    return mixsub2
                line = self.match_mult_bracket(line, "newexternobject", __handler2)

            if "getexterninstanceindexer" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "getexterninstanceindexer({0})", ["\w*.*"], "")
                    if lmatch != []:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=3:
                            _obj, _nil, _type, _index = largv[0:4]
                            _type = _type.replace("\"", "").strip()
                            if _type == "get_Item" or _type == "get_Chars":
                                mixsub2 = self.doMatch(subline, _origin, ["DictGetValue({0}, {1})", _obj, _index])
                            elif _type == "set_Item" or _type == "set_Chars":
                                mixsub2 = self.doMatch(subline, _origin, ["DictSetValue({0}, {1})", _obj, _index])
                    return mixsub2
                line = self.match_mult_bracket(line, "getexterninstanceindexer", __handler2)

            if "delegationset" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    if self.check_ok_bracket(subline):
                        _origin, lmatch = self.Match(subline, "delegationset({0})", ["\w*.*"], "")
                        if lmatch != []:
                            largv = self.dump_argv(lmatch[0])
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
                                mixsub2 = self.doMatch(subline, _origin, ["{0}.{1} = {2}", _obj, _f, _fdes])
                    return mixsub2
                line = self.match_mult_bracket(line, "delegationset", __handler2)

            if "typecast" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "typecast({0})", ["\w*.*"], "")
                    if lmatch != []:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=2:
                            _obj = largv[0]
                            _obj = _obj.lstrip("(").rstrip(")")
                            mixsub2 = self.doMatch(subline, _origin, ["{0}", _obj])
                    return mixsub2
                line = self.match_mult_bracket(line, "typecast", __handler2)
            
            if "getforbasicvalue" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "getforbasicvalue({0})", ["\w*.*"], "")
                    if lmatch != []:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=3:
                            _obj = largv[0]
                            _type = largv[-1].replace("\"", "")
                            mixsub2 = self.doMatch(subline, _origin, ["{0}.{1}", _obj, _type])

                    return mixsub2
                line = self.match_mult_bracket(line, "getforbasicvalue", __handler2)

            if "invokeforbasicvalue" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "invokeforbasicvalue({0})", ["\w*.*"], "")
                    if lmatch != []:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=3:
                            _obj, _bool, _type, _f = largv[0:4]
                            _argv = largv[4:]
                            _f = _f.replace("\"", "")
                            _argv = ",".join(_argv)
                            if _argv == "":
                                mixsub2 = self.doMatch(subline, _origin, ["{0}({1})", _f, _obj])
                            else:
                                mixsub2 = self.doMatch(subline, _origin, ["{0}({1}, {2})", _f, _obj, _argv])
                    return mixsub2
                line = self.match_mult_bracket(line, "invokeforbasicvalue", __handler2)

            if "invokeexternoperator" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "invokeexternoperator({0})", ["\w*.*"], "")
                    if lmatch != []:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=3:
                            _op = largv[1]
                            _reat = largv[2:]
                            if "op_Equality" in _op:
                                _left, _right = _reat[0:2]
                                if "nil" in _right:
                                    mixsub2 = self.doMatch(subline, _origin, ["isnil({0})", _left, _right])
                                else:
                                    mixsub2 = self.doMatch(subline, _origin, ["{0} == {1}", _left, _right])
                            elif "op_Addition" in _op:
                                _left, _right = _reat[0:2]
                                mixsub2 = self.doMatch(subline, _origin, ["{0} + {1}", _left, _right])
                            elif "op_Subtraction" in _op:
                                _left, _right = _reat[0:2]
                                mixsub2 = self.doMatch(subline, _origin, ["{0} - {1}", _left, _right])
                            elif "op_Implicit" in _op or "op_Inequality" in _op:
                                _obj= _reat[0]
                                mixsub2 = self.doMatch(subline, _origin, ["not isnil({0})", _obj])
                    return mixsub2
                line = self.match_mult_bracket(line, "invokeexternoperator", __handler2)

            if "externdelegationcomparewithnil" in line:
                def __handler2(subline, debug=False):
                    mixsub2 = subline
                    _origin, lmatch = self.Match(subline, "externdelegationcomparewithnil({0})", ["\w*.*"], "")
                    if lmatch != []:
                        largv = self.dump_argv(lmatch[0])
                        if len(largv)>=6:
                            isevent, isStatic, key, t, inf, k, isequal = largv[0:7]
                            print isevent, isStatic, key, t, inf, k, isequal
                            if "true" in isequal:
                                mixsub2 = self.doMatch(subline, _origin, ["{0} == {1}", t, k])
                            else:
                                mixsub2 = self.doMatch(subline, _origin, ["{0} ~= {1}", t, k])
                    return mixsub2
                line = self.match_mult_bracket(line, "externdelegationcomparewithnil", __handler2)

            def __handler2(subline, debug=False):
                mixsub2 = subline
                _origin, lmatch = self.Match(subline, "System.Text.Encoding.UTF8:GetString({0})", ["\w*.*"], "")
                if lmatch != []:
                    largv = self.dump_argv(lmatch[0])
                    if len(largv)>0:
                        _obj = largv[0]
                        mixsub2 = self.doMatch(subline, _origin, ["{0}", _obj])
                return mixsub2
            line = self.match_mult_bracket(line, "System.Text.Encoding.UTF8:GetString", __handler2)

            # def __handler2(subline, debug=False):
            #     _origin, lmatch = self.Match(subline, "wrapconst({0})", ["\w*.*"], "")
            #     if lmatch != []:
            #         largv = self.dump_argv(lmatch[0])
            #         if len(largv)>1:
            #             _obj = "{0}.{1}".format(largv[0], largv[1].replace("\"", ""))
            #             mixsub2 = self.doMatch(subline, _origin, ["{0}", self.make_one_match(_obj)])
            #             line = line.replace(subline, mixsub2)
            #     return line
            # line = self.match_mult_bracket(line, "wrapconst", __handler2)

            def __handler2(subline, debug=False):
                mixsub2 = subline
                _origin, lmatch = self.Match(subline, "wrapchar({0})", ["\w*.*"], "")
                if lmatch != []:
                    largv = self.dump_argv(lmatch[0])
                    if len(largv)>=2:
                        _obj = largv[0]
                        mixsub2 = self.doMatch(subline, _origin, ["{0}", _obj])
                return mixsub2
            line = self.match_mult_bracket(line, "wrapchar", __handler2)
            
            _o, lmatch  = self.Match(line, "{0}[{1}]", ["[a-zA-Z0-9_\.]*", "[a-zA-Z0-9#_\. \-\+:\"]*"], "")
            if lmatch != []:
                if len(lmatch)>=2 and lmatch[0] != "" and lmatch[1] != "":
                    ok, line  = self.Play(line, "{0}[{1}]", "DictGetValue({0}, {1})", ["[a-zA-Z0-9_\.\"]*", "[a-zA-Z0-9#_\. \-\+:\"]*"], _debug)
            ok, line = self.Play(line, "#{0}", "obj_len({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)
            ok, line = self.Play(line, "{0}.Count", "obj_len({0})", ["[a-zA-Z0-9_\.:\]\[\"]*"], _debug)
            ok, line = self.Play(line, "{0}.Length", "obj_len({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)

            _origin, lmatch  = self.Match(line, "if ({0} == {1}) then", ["[A-Za-z0-9_\.\[\]]*", "[0-9]*"], "")
            if len(lmatch)>1:
                line = self.doMatch(line, _origin, ["if (CS.System.Convert.ToInt32({0}) == {1}) then", lmatch[0], lmatch[1]])

            _reps, lmatch  = self.Match(line, "(function() local __compiler_delegation{0}()", ["\w*.*"], "")
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
                _origin, lmatch  = self.Match(line, "{0}__{1}({2}", [_regx, _regx, "\w*.*"], "")
                if len(lmatch) > 2:
                    _Head = lmatch[0].split(".")
                    _Argv = lmatch[2].strip().strip("(").strip(")")
                    largv = self.dump_argv(_Argv)
                    if largv[0]==_Head[0]:
                        del(largv[0])
                    if largv[-1] == ";":
                        del(largv[-1])

                    if len(_Head)>1:
                        _reps = "{0}.{1}({2}".format(_Head[0], _Head[1], ",".join(largv))
                    else:
                        _reps = "{0}({1}".format(_Head[0], ",".join(largv))
                    line = line.replace(_origin, _reps)

            line = self.ReplaceEx(line, "System.Int32.Parse", "tonumber")
            line = self.ReplaceEx(line, "Eight.Framework.EIDebuger.Log", "GameLog")
            line = self.ReplaceEx(line, "ToString", "tostring")
            line = self.ReplaceEx(line, "Ms +", "Ms ..")
            line = self.ReplaceEx(line, "System.String.Empty", "\"\"")

            if line.strip() == "end),":
                line = line.replace("end),", "end")

            if ".Invoke();" in line:
                print line
                line = line.replace(".Invoke();", "();")

            line = line.replace("Ms +", "Ms ..")
            line = line.replace(", nil, nil, nil);", ");")
            if line.strip().startswith("this.base"):
                line = line.replace("this.base", "--this.base")
            line = line.replace("Eight.Framework.EIFrameWork.GetComponent(EightGame.Component.GameResources)", "GameLuaApi.GameResources()")
            line = line.replace("coroutine.yield(coroutine.coroutine);", "if coroutine.coroutine then\ncoroutine.yield(coroutine.coroutine)\nend")
            

            line = line.replace("LogicStatic.Get__System_Predicate_T", "LogicStatic:Get")
            line = line.replace("LogicStatic.Get__System_Int32", "LogicStatic:Get")
            line = line.replace("LogicStatic.Get__System_Int64", "LogicStatic:Get")
            line = line.replace("LogicStatic.Get", "LogicStatic:Get")
            line = line.replace("CS.System.String.IsNullOrEmpty", "isnil")

            _origin, lmatch = self.Match(line, ":GetComponent({0})", ["\w.*"], "")
            if len(lmatch) > 0:
                reps = lmatch[0].split(".")[-1]
                if reps.startswith("typeof"):
                    reps = reps.replace("typeof", "").strip().strip("(").strip(")")
                if not "\"" in reps:
                    reps = "\"" + reps + "\""
                line = line.replace(lmatch[0], reps)

            _origin, lmatch = self.Match(line, ":AddComponent({0})", ["[A-Za-z0-9_\.]*"], "")
            if len(lmatch) > 0:
                reps = lmatch[0].split(".")[-1]
                if reps.startswith("typeof"):
                    reps = reps.replace("typeof", "").strip().strip("(").strip(")")
                reps = "typeof(" + reps + ")"
                line = line.replace(lmatch[0], reps)

            _origin, lmatch = self.Match(line, ":Push({0}, {1})", ["[A-Za-z0-9_\.]*", "[A-Za-z0-9_\.]*"], "")
            if len(lmatch) > 1:
                for match in lmatch:
                    reps = match.split(".")[-1]
                    if reps.startswith("typeof"):
                        reps = reps.replace("typeof", "").strip().strip("(").strip(")")
                    reps = "typeof(" + reps + ")"
                    line = line.replace(match, reps)

            _origin, lmatch = self.Match(line, ":_PushView({0}, nil)", ["[A-Za-z0-9_\.]*"], "")
            if len(lmatch) > 0:
                reps = lmatch[0].split(".")[-1]
                if reps.startswith("typeof"):
                    reps = reps.replace("typeof", "").strip().strip("(").strip(")")
                reps = "typeof(" + reps + ")"
                line = line.replace(lmatch[0], reps)

            lcstype = [
                "Eight.Framework",
                "EightGame.Component",
                "EightGame.Logic",
                "EightGame.Data.Server",
                "UnityEngine",
                "MiniJSON",
                "UIEventListener",
                "System"
            ]
            for _t in lcstype:
                line = self.ReplaceEx(line, _t, "CS.{0}".format(_t))
            line = self.ReplaceEx(line, "CS.CS.", "CS.")

            lNewBlock.append(line)
        return lNewBlock

    def make_init_module(self, lModels):
        path = self.OutputFolder + "\init.lua"
        lInput = [
            "util = require 'xlua.util'\n",
            "xutf8 = require 'xutf8'\n",
            "require 'xstr'\n",
            "require 'JSON'\n",
            "require 'Global'\n",
            "require 'cs_config'\n",
            "require 'XLuaBehaviour'\n",
            "require 'BaseCom'\n",
            "require 'Main'\n",
            "require 'LogicStatic'\n",
        ]
        for mod in lModels:
            if not mod in "init":
                lInput.append("require '{0}'\n".format(mod))

        lInput.append("\nMain:__init()\n")
        with open(path, "w") as f_w:
            f_w.writelines(lInput)

    
    def init_module_info(self, filename):
        self.luaModel["name"] = filename.replace(".lua", "")
        self.luaModel["module"] = self.LUA_MODEL_TAG + self.luaModel["name"]
        self.luaModel["defs"] = []
        self.luaModel["functions"] = []

    _noimport = ["LogicStatic"]
    def init_head_block(self, mult_block):
        lRequire = []
        _limport = []
        _match, _info, _require_block = self.get_block(self.lines, ["require {0}", "\w*.*"], [" = {{", []])
        for line in _require_block:
            if "require" in line:
                _import = line.replace("\n", "").replace(";", "").replace("\"", "").split(" ")[1]
                if not "_" in _import and not _import in self._noimport:
                   # lRequire.append("local {0} = nil\n".format(_import))
                   _limport.append(_import)

        lRequire.append("\n")
        mult_block.append(lRequire)

        lInput = [
            "local this = nil\n",
            "{0} = BaseCom:New('{0}')\n".format(self.luaModel["module"]),
            "function {0}:Ref(ref)\n".format(self.luaModel["module"]),
            "   if ref then\n",
            "       this = ref\n",
            "   end\n",
            "   return this\n",
            "end\n\n",
        ]
        mult_block.append(lInput)

        l_InitTb = []
        l_InitTb.append("function {0}:Init_Tb(ref)\n".format(self.luaModel["module"]))
        # for _import in _limport:
        #     l_InitTb.append(chr(self.S) + "{0} = {1}\n".format(_import, _import))
        l_InitTb.append("end\n\n")
        mult_block.append(l_InitTb)
        return mult_block

    def init_method_block(self, block):
        _match, _info, _instance_methods_block = self.get_block(self.lines, ["local instance_methods = {{"], ["}};", []])
        _blocks = self.get_mult_block(_instance_methods_block, ["{0} = function({1})", "\w.*", "\w.*"], ["", []])
        for _block_u in _blocks:
            _match, _info, _block = _block_u[0:3]
            if _match != []:
                _offsetX = 0
                _name = _match[0].strip()
                _argv =  _match[1].split(",")
                if (_name in self.lNoHotfix):
                    continue
                self.luaModel["defs"].append([_name, _argv, _info, _block, _offsetX])

        tmp_block = []
        for _def in self.luaModel["defs"]:
            _sDefname   = _def[0]
            _lDefArgv   = _def[1]
            _FuncBlock  = _def[3]
            _offsetX    = _def[4]
            if _FuncBlock != []:
                def_block = []
                _lDefargv = []
                _isIEnumerator = False
                offset_x = self.space_count(_FuncBlock[len(_FuncBlock)-1])
                for idnex, line in enumerate(_FuncBlock):
                    idnex = idnex + 1
                    if idnex == 1:
                        _origin, _match = self.Match(line, "{0} = function({1})", [_sDefname, "\w.*"], "")
                        if len(_match)>0:
                            _lDefargv =  _match[1].split(",")
                        else:
                            _lDefargv = []
                        _sDefargv = self.argv_l2s(_lDefargv, "no_this")
                        line = "function {0}:{1}({2})\n".format(self.luaModel["module"], _sDefname, _sDefargv)
                    if "wrapyield" in line:
                        _isIEnumerator = True
                    if idnex == len(_FuncBlock)-1:
                        if "return nil;" in line:
                            _isIEnumerator = True
                    def_block.append(line)
                    if idnex == 1:
                        def_block.append(chr(self.S) + "GameLog(\"" + "-"*30 + self.luaModel["module"] + " " + _sDefname + "-"*30 + "\")\n")

                def_block_align = []
                for line in def_block:
                    offset = (self.space_count(line) - offset_x)
                    if offset >=0:
                        line = chr(self.S)*(offset) + line.lstrip()
                    def_block_align.append(line)
                def_block_align.append("\n")                
                self.luaModel["functions"].append([_sDefname, _lDefargv, _isIEnumerator])
                tmp_block.append([_sDefname, def_block_align])

        for _tmp in tmp_block:
            _name, _block = _tmp[0:2]
            self.luaModel["cur_function"] = _name
            _block = self.tp_xlua_style_block(_block)
            _block = self.to_xlua_method_block(_block)
            block.append(_block)
        return block
    
    def init_hotfix_block(self, block):
        hotfix_block = []
        hotfix_block.append("function {0}:hotfix()\n".format(self.luaModel["module"]))
        hotfix_block.append(chr(self.S) + "{0}:Init_Tb()\n".format(self.luaModel["module"]))
        if len(self.luaModel["functions"]) > 0:
            hotfix_block.append(chr(self.S) + "xlua.hotfix({0}, {{\n".format(self.luaModel["name"])),
            for func in self.luaModel["functions"]:
                sFName = func[0]
                sArgv = self.argv_l2s(func[1])
                sNoArgv = self.argv_l2s(func[1], "no_this")
                isIEnumerator = func[2]
                if sFName in self.lNoHotfix or "_" in sFName:
                    continue
                if isIEnumerator:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(self.luaModel["module"]),
                        "           return util.cs_generator(function()\n",
                        "               {0}:{1}({2})\n".format(self.luaModel["module"], sFName, sNoArgv),
                        "           end)\n",
                        "       end,\n",
                    ]
                else:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(self.luaModel["module"]),
                        "           return {0}:{1}({2})\n".format(self.luaModel["module"], sFName, sNoArgv),
                        "       end,\n",
                    ]
                for line in lInput:
                    hotfix_block.append(line)
            hotfix_block.append("   })\n")
        hotfix_block.append("end\n\n")
        hotfix_block.append("table.insert(g_tbHotfix, {0})".format(self.luaModel["module"]))
        block.append(hotfix_block)
        return block

    def init_block(self):
        lBlock = []
        lBlock = self.init_head_block(lBlock)
        lBlock = self.init_method_block(lBlock)
        lBlock = self.init_hotfix_block(lBlock)
        return lBlock

    def find(self, target=""):
        lModels = [] 
        for parent, dirnames, filenames in os.walk(self.ScriptFolder):
            for filename in filenames:
                if (not self.IsPassFile(filename) and not self.IsPassPath(parent)) and self.IsTargetExt(filename) and self.IsTargetFile(filename):
                    fullname = os.path.join(parent, filename)
                    self.init_module_info(filename)
                    self.limit = False
                    self.Read(parent, filename)
                    lModels.append(self.luaModel["name"])
        self.make_init_module(lModels)

    def Read(self, parent, filename):
        print "-"*50, filename, "-"*50
        with open(self.ScriptFolder + "\\" + filename, "r") as f:
            self.lines = f.readlines()
        lBlock = self.init_block()
        if not os.path.exists(self.OutputFolder):
            os.makedirs(self.OutputFolder)
        with open(self.OutputFolder + "\\" + filename, "w") as f_w:
            for block in lBlock:
                for line in block:
                    f_w.write(line)

if __name__=="__main__":
    finder = FindType(sys.argv)
    finder.setFilter(
        [".lua"], 
        #ignore file
        ["manifest.lua", "tmp.lua", "init.lua"],
        #ignore path
        ["core"]
    )
    finder.find()

