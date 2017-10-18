
import os,sys, re
import matchUtils
import bracketUtils
import utils
import common as common
import message as message

cur_merge_info = ""

def merge_info():
    global cur_merge_info
    return cur_merge_info

def get_one_block(lines, start_u, style=[""], debug=False):
    global cur_merge_info
    beginAlign = 0
    endAlign = 0
    bGetStart = False
    bGetEnd = False
    isok = False
    retList = []
    mergeinfo = {
        "head":"",
        "begin":0,
        "length":0,
        "root_lnum":[]
    }
    _start_u = []
    for index, line in enumerate(lines):
        if not bGetStart:
            lmatch = matchUtils.get_match(line, start_u[0], start_u[1:])
            if len(lmatch)>0:
                if isinstance(lmatch, tuple):
                    _start_u = list(lmatch[0])
                else:
                    _start_u = lmatch
                
                if debug:
                    print "> ", line.rstrip()

                beginAlign = utils.space_count(line)
                bGetStart = True
                mergeinfo["head"] = line
                mergeinfo["begin"] = index
                mergeinfo["root_lnum"].append(index)
                retList.append(line)
        elif bGetStart:
            endAlign = utils.space_count(line)
            isAlignMatch = endAlign == beginAlign
            if isAlignMatch:
                bGetEnd = True
                if debug:
                    print "# ", line.rstrip()
                if line.strip() == "end," or line.strip() == "end" or line.strip() == "end)," or line.strip() == "end))":
                    mergeinfo["length"] = mergeinfo["length"] + 1
                    mergeinfo["root_lnum"].append(index)
                    retList.append(line)
                break
            else:
                midAlign = utils.space_count(line)
                if debug:
                    print "~ ", midAlign, line.rstrip()
                if midAlign > beginAlign:
                    mergeinfo["length"] = mergeinfo["length"] + 1
                    mergeinfo["root_lnum"].append(index)
                    retList.append(line)

    ret_len = len(retList)
    if not bGetStart:
        isok = False
        if debug:
            print "fck!!!!! no start line."
    elif not bGetEnd:
        isok = False
        if debug:
            print "fck!!!!! no end line.", ret_len
        if ret_len == 1 and bracketUtils.check_bracket(retList[0]):
            isok = True
    else:
        isok = True
        
    if isok:
        pass
        # if ret_len>1:
        #     if "no_head_and_end" in style:
        #         del(mergeInfo[0])
        #         del(retList[0])
        #         del(mergeInfo[len(mergeInfo)-1])
        #         del(retList[ret_len-1])
        #     if "remove_head_and_end" in style:
        #         retList[0] = ""
        #         retList[ret_len-1] = ""
    else:
        retList = []
        # mergeInfo = []
    match_u = _start_u
    cur_merge_info = mergeinfo
    return match_u, retList

def get_mult_block(outblock, start_u, handler=None, debug=None):
    global cur_merge_info
    bList = []
    endlinenum = 0
    root = outblock
    offsetDeep = 0
    mergeList = []
    while len(root) > 0:
        lmatch, block = get_one_block(root, start_u)
        merge = merge_info()
        if len(block)==0:
            break
        if handler!= None:
            block2 = []
            for index, line in enumerate(block):
                root_index = merge["root_lnum"][index] + offsetDeep
                block2.append([root_index, index, line])
            ret = handler(lmatch, block, block2, mergeList)
            bList.append(block)

        if merge["length"] == 0:
            endlinenum = merge["begin"] + 1
        else:
            endlinenum = merge["begin"] + merge["length"]

        offsetDeep = offsetDeep + endlinenum

        root = root[endlinenum:]
    return bList

def merge_block(oldblock, newblock, mergeinfo):
    start = False
    end = False
    if len(mergeinfo)>1:
        for index, line in enumerate(oldblock):
            if index == mergeinfo["begin"]:
                start = True
                continue
            elif index > mergeinfo["length"]:
                start = False
                end = True
            if start and not end:
                oldblock[index] = newblock[index]
            elif end:
                break
    return oldblock

def merge(rootblock, blockList):
    for obj in blockList:
        rootblock = merge_block(rootblock, obj.getblock(), obj.getmerge())
    return rootblock

def find_the_align_line(line):
    sc = utils.space_count(line)
    