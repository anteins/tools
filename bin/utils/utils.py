
import common

lchar =[]
lArgv = []

def DebugInfo(debug, lines):
    if debug:
        sStr = ""
        for line in lines:
            sStr = "{0}\n{1}".format(sStr, line)
        print sStr

def dump_argv(line, debug=False):
    global lchar, lArgv
    if debug:
        print "[---- argvs ----]\n", line
    arr = []
    lchar = []
    lArgv = []
    inbracket = False
    for index, c in enumerate(line):
        if c in '(' or c in '[':
            lchar.append(c)
            arr.append(c)
        elif c in ')' or c in ']':
            lchar.append(c)

            if len(arr) !=0:
                arr.pop()
            if len(arr) == 0:
                if index+1 < len(line) and line[index+1] == "." or inbracket:
                    pass
                else:
                    save_char()
        else:
            if c in ',':
                if len(arr) != 0:
                    lchar.append(c)
                else:
                    save_char()
            elif c in ' ':
                if len(arr) != 0:
                    lchar.append(c)
            elif c in "'":
                lchar.append(c)
                if len(arr) == 0:
                    arr.append(c)
                elif arr[0] == "'":
                    save_char()
            elif c in "\"":
                if inbracket:
                    inbracket = False
                    lchar.append(c)
                    if len(arr) !=0:
                        arr.pop()
                    if len(arr) == 0:
                        save_char()
                else:
                    inbracket = True
                    lchar.append(c)
                    arr.append(c)
            else:
                lchar.append(c)
                
    if lchar !=[]:
        lArgv.append("".join(lchar))
    if debug:
        print "[---- dump ----]"
        for i in lArgv:
            print i
        print "[---- dump ----]"
    return lArgv

def save_char():
    global lchar, lArgv
    if lchar !=[]:
        char = "".join(lchar)
        lArgv.append(char)
    lchar = []

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



def IsTargetExt(filename, ext):
    flag = False
    for target in ext:
        if target in filename:
            flag = True
            break
    return flag

def IsTargetFile(filename, target):
    flag = False
    if target == []:
        return True
    else:
        return filename in target

def IsPassFile(filename, Filter):
    flag = False
    for filter in Filter:
        if filter in filename:
            flag = True
            break
    return flag

def IsPassPath(path, scriptFolder, pathFilter):
    flag = False
    for filt in pathFilter:
        if scriptFolder + "/" + filt == path:
            flag = True
            break
    return flag