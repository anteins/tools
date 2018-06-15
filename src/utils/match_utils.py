
SYMBOLS = {')':'('}
SYMBOLS_L, SYMBOLS_R = SYMBOLS.values(), SYMBOLS.keys()
S = 9   #tab
T = 32  #space

import os,sys, re
import utils

pri_origin_line = ""

def origin():
    global pri_origin_line
    return pri_origin_line

def get_match(line, origin, char, isExReCompile="", debug=False):
    global pri_origin_line
    lrep = [
        "(",
        ")",
        ".",
        "[",
        "]"
    ]
    matchP = origin
    for rep in lrep:
        matchP = matchP.replace(rep, "\\" + rep)
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

    pri_origin_line = origin_line
    return ret

def play_match(line, origin, dest, tuple_origin, debug=False):
    global pri_origin_line
    old_origin = pri_origin_line
    lmatch = get_match(line, origin, tuple_origin)
    cur_origin = pri_origin_line
    pri_origin_line = old_origin
    bFlag = False
    if len(lmatch)>0 and lmatch != ['']:
        if debug:
            print "-"*100
            print "[match]line:" , line.lstrip()
            print "[match]group:" , lmatch
        bFlag = True
        line = handle_match_by_origin(line, cur_origin, [dest, tuple(lmatch)], debug)
        if debug:
            print "[match]result:", line.strip()
    return bFlag, line

def handle_match_by_origin(line, origin, ldest, debug=False):
    global pri_origin_line
    pri_origin_line = origin
    return handle_match(line, ldest, debug)

def handle_match(line, ldest, debug=False):
    global pri_origin_line
    utils.debug_info(debug, ["-"*100, line.lstrip()])
    _form = pri_origin_line
    sDest = ldest[0]
    tMatch = tuple(ldest[1:])
    if len(tMatch) == 1:
        tMatch = tMatch[0]
    if debug:
        print "tMatch ", tMatch
    lmatch = make_one_match(tMatch)
    for tMatch in lmatch:
        if isinstance(tMatch, str):
            _to = sDest.format(tMatch)
        elif isinstance(tMatch, tuple):
            _to = sDest.format(*tMatch)
        line = line.replace( _form, _to)
        utils.debug_info(debug, [_form, "|__", _to, "|__", line.lstrip()])
    return line

def make_one_match(*obj):
    lRet = []
    if len(obj)>1:
        tRet = obj
    else:
        tRet = obj[0]
    lRet.append(tRet)
    return lRet