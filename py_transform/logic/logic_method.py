
import os,sys
from py_transform.utils import utils
from py_transform.utils import block_utils
from py_transform.utils import bracket_utils
from py_transform.utils import match_utils
from py_transform.utils import common
from py_transform.config import handle_config

def handle(line, _debug = False):
    if not "System.String.Format" in line:
        ok, line = match_utils.play_match(line, "#{0}", "c_len({0})", ["[a-zA-Z0-9_.:\]\[]*"], _debug)
    ok, line = match_utils.play_match(line, "{0}.Count", "c_len({0})", ["[a-zA-Z0-9_\.:\]\[]*"], _debug)
    ok, line = match_utils.play_match(line, "{0}.Length", "c_len({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)
    # ok, line = match_utils.play_match(line, "{0}:ToString()", "c_tostring({0})", ["[a-zA-Z0-9_.:\]\[\"]*"], _debug)
    ok, line = match_utils.play_match(line, "{0}.Split({1})", "c_split({0}, {1})", ["[a-zA-Z0-9_\.:\]\[]*", "\w*.*"], _debug)
    ok, line = match_utils.play_match(line, "{0}.Substring({1})", "c_substring({0}, {1})", ["[a-zA-Z0-9_\.:\]\[]*", "\w*.*"])
    ok, line = match_utils.play_match(line, "typeof({0})", "{0}", ["[a-zA-Z0-9_\.:\]\[]*"])
    ok, line = match_utils.play_match(line, "delegationwrap({0})", "{0}", ["\w*.*"], _debug)
    ok, line = match_utils.play_match(line, "wrapvaluetype({0})", "{0}", ["\w*.*"], _debug)

    sc = utils.space_count(line)
    line = line.replace("coroutine.yield(coroutine.coroutine);", "if coroutine.coroutine then\n{0}coroutine.yield(coroutine.coroutine)\n{1}end".format(chr(common.S) * (sc + 1), chr(common.S) * (sc)))

    return line