
import common

import os, sys, re, math

def find_all_bracket(line, startstr, debug=False):
    lbracket = []
    _count = 0
    while True:
        subline = one_bracket(line, startstr)
        if subline != "":
            regx = "%" + str(_count) + "%"
            line = line.replace(subline, regx)
            lbracket.append([_count, subline, line])
            _count = _count + 1
        else:
            break
    return lbracket

def one_bracket(line, startswith, debug=False):
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
        if c in common.SYMBOLS_L:
            arr.append(c)
            lchar.append(c)
        elif c in common.SYMBOLS_R:
            lchar.append(c)
            if len(arr)!=0:
                arr.pop()
            if len(arr)==0:
                _head = "".join(lchar)
                break
        else:
            lchar.append(c)
    return _head

def handle_bracket(line, startstr, handler, debug=False):
    lbracket = find_all_bracket(line, startstr, debug)
    output = merge_bracket(line, lbracket, handler, debug)
    return output

def merge_bracket(line, lbracket, handler, debug):
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

def check_bracket(line, debug=False):
    left = []
    right = []

    def _handle(_line):
        for c in _line:
            if c in common.SYMBOLS_L:
                left.append(c)
            elif c in common.SYMBOLS_R:
                right.append(c)

    if isinstance(line, list):
        for ll in line:
           _handle(ll)
    else:
        _handle(line)

    ret = len(left) == len(right)
    if debug:
        print len(left), len(right), ret
    return ret