
import os,sys, re
import match_utils
import bracket_utils
import utils
import common as common
from py_transform.config import message

cur_merge_info = ""

def merge_info():
    global cur_merge_info
    return cur_merge_info

def get_one_block(lines, start_u, style=[""], debug=False):
    global cur_merge_info
    begin_align = 0
    end_align = 0
    has_get_started = False
    has_get_ended = False
    isok = False
    return_list = []
    merge_info = {
        "head"      :   "",
        "begin"     :   0,
        "length"    :   0,
        "root_lnum" :   []
    }
    _start_u = []
    for index, line in enumerate(lines):
        if not has_get_started:
            lmatch = match_utils.get_match(line, start_u[0], start_u[1:])
            if len(lmatch) > 0:
                if isinstance(lmatch, tuple):
                    _start_u = list(lmatch[0])
                else:
                    _start_u = lmatch
                
                if debug:
                    print "> ", line.rstrip()

                begin_align = utils.space_count(line)
                has_get_started = True
                merge_info["head"] = line
                merge_info["begin"] = index
                merge_info["root_lnum"].append(index)
                return_list.append(line)
        elif has_get_started:
            end_align = utils.space_count(line)
            isAlignMatch = end_align == begin_align
            if isAlignMatch:
                has_get_ended = True
                if debug:
                    print "# ", line.rstrip()
                if line.strip() == "end," or line.strip() == "end" or line.strip() == "end)," or line.strip() == "end))":
                    merge_info["length"] = merge_info["length"] + 1
                    merge_info["root_lnum"].append(index)
                    return_list.append(line)
                break
            else:
                midAlign = utils.space_count(line)
                if debug:
                    print "~ ", midAlign, line.rstrip()
                if midAlign > begin_align:
                    merge_info["length"] = merge_info["length"] + 1
                    merge_info["root_lnum"].append(index)
                    return_list.append(line)

    ret_len = len(return_list)
    if not has_get_started:
        isok = False
        if debug:
            print "fck!!!!! no start line."
    elif not has_get_ended:
        isok = False
        if debug:
            print "fck!!!!! no end line.", ret_len
        if ret_len == 1 and bracket_utils.check_bracket(return_list[0]):
            isok = True
    else:
        isok = True
        
    if isok:
        pass
        # if ret_len>1:
        #     if "no_head_and_end" in style:
        #         del(merge_info[0])
        #         del(return_list[0])
        #         del(merge_info[len(merge_info)-1])
        #         del(return_list[ret_len-1])
        #     if "remove_head_and_end" in style:
        #         return_list[0] = ""
        #         return_list[ret_len-1] = ""
    else:
        return_list = []
        # merge_info = []
    match_u = _start_u
    cur_merge_info = merge_info
    return match_u, return_list

def get_mult_block(outblock, start_u, handler=None, debug=None):
    global cur_merge_info
    bList = []
    end_line_number = 0
    root = outblock
    offset_deep = 0
    merge_list = []
    while len(root) > 0:
        lmatch, block = get_one_block(root, start_u)
        merge = merge_info()
        if len(block)==0:
            break
        if handler!= None:
            block2 = []
            for i, line in enumerate(block):
                root_index = merge["root_lnum"][i] + offset_deep
                block2.append([root_index, i, line])
            ret = handler(lmatch, block, block2, merge_list)
            bList.append(block)

        if merge["length"] == 0:
            end_line_number = merge["begin"] + 1
        else:
            end_line_number = merge["begin"] + merge["length"]

        offset_deep = offset_deep + end_line_number

        root = root[end_line_number:]
    return bList

def merge_block(oldblock, newblock, merge_info):
    start = False
    end = False
    if len(merge_info)>1:
        for index, line in enumerate(oldblock):
            if index == merge_info["begin"]:
                start = True
                continue
            elif index > merge_info["length"]:
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
    