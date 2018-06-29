
import os,sys
from py_transform.utils import utils
from py_transform.utils import block_utils
from py_transform.utils import bracket_utils
from py_transform.utils import match_utils
from py_transform.utils import common
from py_transform.config import handle_config

def handle(line, _debug = False):
    line = line.replace("\" + ", "\" .. ")
    line = line.replace(" + \" ", " .. \" ")

    for key in handle_config.key_value:
        line = utils.abs_replace(line, key, handle_config.key_value[key])

    # SOMETHING ERROR
	line = utils.abs_replace(line, "CS.CS.", "CS.")
	line = utils.abs_replace(line, "CS.\"\"", "\"\"")
	

    return line