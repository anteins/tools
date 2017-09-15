
SYMBOLS = {')':'('}
SYMBOLS_L, SYMBOLS_R = SYMBOLS.values(), SYMBOLS.keys()
S = 9   #tab
T = 32  #space

import os,sys, re
import utils

def Match(line, origin, char, isExReCompile, debug=False):
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
    return origin_line, ret

def Play(line, origin, dest, tuple_origin, debug=False):
    _origin, lmatch = Match(line, origin, tuple_origin, "", debug)
    bFlag = False
    if len(lmatch)>0 and lmatch != ['']:
        if debug:
            print line.lstrip()
            print "-"*100
            print "[match_group] " , lmatch

        bFlag = True
        line = doMatch(line, _origin, [dest, tuple(lmatch)], debug)
        utils.DebugInfo(debug, ["[dest] " + line.strip()])
    return bFlag, line

def doMatch(line, origin, ldest, debug=False):
        utils.DebugInfo(debug, ["-"*100, line.lstrip()])
        _form = origin
        sDest = ldest[0]
        tMatch = tuple(ldest[1:])
        if len(tMatch) == 1:
            tMatch = tMatch[0]
        lmatch = make_one_match(tMatch)
        for tMatch in lmatch:
            if isinstance(tMatch, str):
                _to = sDest.format(tMatch)
            elif isinstance(tMatch, tuple):
                _to = sDest.format(*tMatch)
            line = line.replace( _form, _to)
            utils.DebugInfo(debug, [_form, "|__", _to, "|__", line.lstrip()])
        return line

def make_one_match(*obj):
    lRet = []
    if len(obj)>1:
        tRet = obj
    else:
        tRet = obj[0]
    lRet.append(tRet)
    return lRet