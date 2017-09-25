
import os,sys, re
import matchUtils
import bracketUtils
import utils
import common

cur_merge_info = ""

def merge_info():
    global cur_merge_info
    return cur_merge_info

def get_block(lines, start_u, style=[""], debug=False):
    global cur_merge_info
    iStartAlign = 0
    iEndAlign = 0
    bGetStart = False
    bGetEnd = False
    isOK = False
    _rBlock = []
    _mergeInfo = []
    _start_u = []
    for index, line in enumerate(lines):
        if not bGetStart:
            tmp = start_u[1:]
            lmatch = matchUtils.get_match(line, start_u[0], start_u[1:], "")
            if debug:
                print "~: ", utils.space_count(line), line, lmatch
            if len(lmatch)>0:
                if isinstance(lmatch, tuple):
                    _start_u = list(lmatch[0])
                else:
                    _start_u = lmatch
                iStartAlign = utils.space_count(line)
                bGetStart = True
                _mergeInfo.append(index)
                _rBlock.append(line)
        elif bGetStart:
            iEndAlign = utils.space_count(line)
            isAlignMatch = iEndAlign == iStartAlign
            if isAlignMatch:
                bGetEnd = True
                if debug:
                    print "#: ", iEndAlign, line
                _mergeInfo.append(index)
                _rBlock.append(line)
                break
            else:
                iMidAlign = utils.space_count(line)
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
        if len(_rBlock) == 1 and bracketUtils.check_bracket(_rBlock[0]):
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

    _match_u = _start_u
    cur_merge_info = _mergeInfo
    return _match_u, _rBlock

def get_mult_block(block, start_u, style=[""], debug=False):
    target_block = block
    lret = []
    while len(target_block) > 0:
        _match1, _block = get_block(target_block, start_u, style, debug)
        merge = cur_merge_info
        lret.append([_match1, merge, _block])
        if len(_match1) == [] or len(merge) == 0:
            break
        _start1 = merge[0]
        _end1 = merge[len(merge)-1]+1
        target_block = target_block[_end1:]
    return lret

def merge_block(oldblock, newblock, info):
    if info and info != []:
        count = 0
        for lnum in info:
            oldblock[lnum] = newblock[count]
            count = count + 1
    return oldblock