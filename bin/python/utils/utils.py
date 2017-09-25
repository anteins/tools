
import common

lchar =[]
lArgv = []
stack = []
lkeyvalue = {
    "signle_bracket":False,
    "bracket":False
}

def DebugInfo(debug, lines):
    if debug:
        sStr = ""
        for line in lines:
            sStr = "{0}\n{1}".format(sStr, line)
        print sStr

def dump_argv(line, debug=False):
    global lchar, lArgv, stack, lkeyvalue
    if debug:
        print "-"*100
        print line.strip()
    
    stack = []
    lchar = []
    lArgv = []

    left = ['(', '[', '{']
    right = [')', ']', '}']
    for index, c in enumerate(line):
        if c in ' ' and len(stack) ==0:
            continue
        elif c in ',':
            check_and_save(c)
            continue

        if c in left:
            stack.append(c)
        elif c in right:
            if len(stack) !=0:
                stack.pop()
        elif c in "'":
            if lkeyvalue["signle_bracket"]:
                lkeyvalue["signle_bracket"] = False
            else:
                lkeyvalue["signle_bracket"] = True
        elif c in "\"":
            if lkeyvalue["bracket"]:
                lkeyvalue["bracket"] = False
            else:
                lkeyvalue["bracket"] = True

        lchar.append(c)
            
                
    if lchar !=[]:
        lArgv.append("".join(lchar))

    if debug:
        for i in lArgv:
            print "[-]", i
    return lArgv

def check_and_save(c):
    global lchar, lArgv, stack, lkeyvalue
    if not including():
        if lchar !=[]:
            char = "".join(lchar)
            lArgv.append(char)
        lchar = []
        stack = []
        lkeyvalue["bracket"] = False
        lkeyvalue["signle_bracket"] = False
    else:
        lchar.append(c)

def including():
    global stack, lkeyvalue
    ret = False
    if len(stack) != 0 or lkeyvalue["bracket"] or lkeyvalue["signle_bracket"]:
        ret = True
    else:
        ret = False
    return ret

def argv_l2s(lArgv, iType=""):
    _lArgv = []
    _i = 0
    for argv in lArgv:
        _i = _i + 1
        if iType == "no_this" and _i == 1:
            if argv == "this":
                continue
        _lArgv.append(argv)
    return ','.join(_lArgv)

def space_count(line, debug=False):
    _hc=0
    _end_match = False
    _start_match = False
    _count = -1
    for i in line:
        _count = _count + 1
        #finding
        if _start_match == False and _end_match == False:
            if ord(i) == common.S:
                _start_match = True
                _hc=_hc+1
            elif ord(i) == common.T:
                _lline = list(line)
                _lline[_count] = chr(common.S)
                line = "".join(_lline)
                _hc=_hc+1
            elif ord(i) == 47:
                if ord(line[_count + 1]) == 47:
                    pass
            else:
                break
        #matching
        elif _start_match == True and _end_match == False:
            if ord(i) == common.S:
                _hc=_hc+1
            else:
                _end_match = True
        #end
        elif _start_match == True and _end_match == True:
            break
    return _hc
