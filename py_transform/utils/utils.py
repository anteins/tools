# coding=utf-8
import os
import re
import glob
import shutil
import common

lchar =[]
lArgv = []
stack = []
lkeyvalue = {
    "signle_bracket":False,
    "bracket":False
}

def get_args(args, tag):
    args_len = len(args)
    for i, val in enumerate(args):
        if i % 2 == 0:
            if args[i] and args[i] == tag:
                if i+1 < args_len:
                    return args[i+1]


def movefile(srcfile,dstfile):
    if not os.path.isfile(srcfile):
        print "%s not exist!"%(srcfile)
    else:
        fpath,fname=os.path.split(dstfile)    #分离文件名和路径
        if not os.path.exists(fpath):
            os.makedirs(fpath)                #创建路径
        shutil.move(srcfile,dstfile)          #移动文件
        print "move %s -> %s"%( srcfile,dstfile)

def copyfile(srcfile,dstfile):
    if not os.path.isfile(srcfile):
        print "%s not exist!"%(srcfile)
    else:
        fpath,fname=os.path.split(dstfile)    #分离文件名和路径
        if not os.path.exists(fpath):
            os.makedirs(fpath)                #创建路径
        shutil.copyfile(srcfile,dstfile)      #复制文件
        print "copy %s -> %s"%( srcfile,dstfile)

def files(curr_dir = '.', ext = '*.exe'):
    """当前目录下的文件"""
    for i in glob.glob(os.path.join(curr_dir, ext)):
        yield i
        
def remove_files(rootdir, ext, show = False):
    """删除rootdir目录下的符合的文件"""
    for i in files(rootdir, ext):
        if show:
            print i
        os.remove(i)

def do_cmd(cmd, islog=False):
        # cmd = cmd.replace("/", "\\")
        if islog:
            print cmd
        else:
            print cmd

        os.system(cmd)
        
def debug_info(debug, lines):
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
            lchar.append(c)
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
        val = "".join(lchar)
        lArgv.append(val)

    for i, val in enumerate(lArgv):
        lArgv[i] = lArgv[i].strip()

    if debug:
        for i in lArgv:
            print "[-]", i.strip()
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

def offsetx(oldline, line):
    offset_x = chr(common.S) * space_count(oldline)
    line = offset_x + line
    return line

def abs_replace(line, origin, dest, debug=False):
    neworigin = r"\b{0}\b".format(origin)
    newline = re.sub(neworigin, dest, line)
    return newline
