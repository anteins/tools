
SYMBOLS = {')':'('}
SYMBOLS_L, SYMBOLS_R = SYMBOLS.values(), SYMBOLS.keys()
S = 9   #tab
T = 32  #space

import os,sys, re
import matchUtils
import bracketUtils
import utils

def get_block(lines, start_u, end_u, style=[""], debug=False):
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
            _origin, lmatch = matchUtils.Match(line, start_u[0], start_u[1:], "")
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
            _origin, _endMatch = matchUtils.Match(line, end_u[0], end_u[1], "")
            if bAlign:
                iEndAlign = utils.space_count(line)
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
        if len(_rBlock) == 1 and bracketUtils.check_ok_bracket(_rBlock[0]):
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

def get_mult_block(block, start_u, end_u, style=[""], debug=False):
    target_block = block
    rList = []
    while len(target_block) > 0:
        _match1, _info1, _block = get_block(target_block, start_u, end_u, style, debug)
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

def merge_block(oldblock, newblock, info):
    if info and info != []:
        _count = 0
        for lnum in info:
            oldblock[lnum] = newblock[_count]
            _count = _count + 1
    return oldblock