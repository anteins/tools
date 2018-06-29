
import os,sys
from py_transform.utils import utils
from py_transform.utils import block_utils
from py_transform.utils import bracket_utils
from py_transform.utils import match_utils
from py_transform.utils import common

def handle(line, _debug = False):
    if line.strip() == "end,":
        line = line.replace("end,", "end")

    if line.strip() == "end),":
        line = line.replace("end),", "end")

    if ".Invoke();" in line:
        line = line.replace(".Invoke();", "();")

    line = line.replace("Ms +", "Ms ..")
    line = line.replace(", nil, nil, nil);", ");")

    if not line.strip().startswith("local"):
        line = line.replace(";", " ")
        
    return line