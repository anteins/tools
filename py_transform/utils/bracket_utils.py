# coding=utf-8
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

def handle_bracket2(line, handler):
    # 把所有括号内容匹配进栈里面
    stack = []
    new_str = _findall(line, stack)

    # 出栈，合并所有括号内容，文本内容由handler更新
    index = -1
    end_str = ""
    while len(stack) > 1:
        index = index + 1
        val = stack.pop()
        parent = stack.pop()
        parent, val = handler(index, parent, val)
        new_str = parent.format(val)
        if len(stack) <= 0:
            end_str = new_str
            break
        else:
            stack.append(new_str)

    return end_str

def _findall(str, stack):
    p2 = re.compile(r'[(](.*)[)]', re.S)
    find_list = re.findall(p2, str)
    if len(find_list) >=1:
        parent = str.replace(find_list[0], "{0}")
        stack.append(parent)
        _findall(find_list[0], stack)
    else:
        print "find nothing."
        stack.append(str)

# -*- coding: utf8 -*-
# 符号表
_SYMBOLS = {'}': '{', ']': '[', ')': '(', '>': '<'}
_SYMBOLS_L, _SYMBOLS_R = _SYMBOLS.values(), _SYMBOLS.keys()

def check(s):
    arr = []
    count = 0
    for c in s:
        if c in _SYMBOLS_L:
            # 左符号入栈
            arr.append(c)
        elif c in _SYMBOLS_R:
            # 右符号要么出栈，要么匹配失败
            if arr and arr[-1] == _SYMBOLS[c]:
                arr.pop()
                count = count + 1
            else:
                return False

    return True, count