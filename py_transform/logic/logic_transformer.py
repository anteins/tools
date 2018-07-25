# coding=utf-8
import os,sys
from py_transform.utils import utils
from py_transform.utils import block_utils
from py_transform.utils import bracket_utils
from py_transform.utils import match_utils
from py_transform.utils import common
from py_transform.config import message

import logic_expression
import logic_method
import logic_field
import logic_style

# model
# "diff" 保留原cs代码文本
def handle (out_block, model="" ):
    newblock = []
    for line in out_block:
        _debug = False
        if model == "diff":
            cs_line = line

        line = logic_expression.handle(line, _debug)
        line = logic_method.handle(line, _debug)
        line = logic_style.handle(line, _debug)
        line = logic_field.handle(line, _debug)
        
        if model == "diff":
            newblock.append("--" + cs_line)
        newblock.append(line)
    return newblock