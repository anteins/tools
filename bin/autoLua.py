# -*- coding: cp936 -*-

import os,sys, re
import shutil
import utils.utils as utils
import utils.blockUtils as blockUtils
import utils.bracketUtils as bracketUtils
import utils.matchUtils as matchUtils
import stylebuilder

import utils.common as common

import ply.lex as lex
import ply.yacc as yacc

class AutoLua(object):
    ext = []
    passFilter = []
    pathFilter = []
    ScriptFolder = ""
    OutputFolder = ""
    lines = []
    model = {}
    luatag = "_lua_"
    lNoHotfix = [
        "__init__", 
        "__ctor1__", 
        "__ctor2__", 
        "__staticInit__", 
        "Dispose", 
        "ctor",
        "OnEnter",
        "Start", 
        "OnUpdate",
        "Update",
    ]
    _targets = []

    def __init__(self, argv):
        if argv == None:
            self._root = os.getcwd()
        else:
            self.ScriptFolder = argv[1]
            self.OutputFolder = argv[2]

    def IsTargetExt(self, filename):
        return utils.IsTargetExt(filename, self.ext)

    def IsTargetFile(self, filename):
        return utils.IsTargetFile(filename, self._targets)

    def IsPassFile(self, filename):
        return utils.IsPassFile(filename, self.passFilter)

    def IsPassPath(self, path):
        return utils.IsPassPath(path, self.ScriptFolder, self.pathFilter)

    def space_count(self, line, debug=False):
        return utils.space_count(line, debug)

    def DebugInfo(self, debug, lines):
        utils.DebugInfo(debug, lines)

    def Match(self, line, origin, char, isExReCompile, debug=False):
        return matchUtils.Match(line, origin, char, isExReCompile, debug)

    def Play(self, line, origin, dest, tuple_origin, debug=False):
        return matchUtils.Play(line, origin, dest, tuple_origin, debug)

    def doMatch(self, line, origin, ldest, debug=False):
        return matchUtils.doMatch(line, origin, ldest, debug)

    def merge_block(self, oldblock, newblock, info):
        return blockUtils.merge_block(oldblock, newblock, info)

    def make_one_match(self, *obj):
        return matchUtils.make_one_match(obj)

    def dump_argv(self, line, debug=False):
        return utils.dump_argv(line, debug)

    def check_ok_bracket(self, line, debug=False):
        return bracketUtils.check_ok_bracket(line, debug)

    def get_bracket(self, line, startswith, debug=False):
        return bracketUtils.get_bracket(line, startswith, debug)

    def get_mult_bracket(self, line, startstr, debug=False):
        return bracketUtils.get_mult_bracket(line, startstr, debug)

    def match_mult_bracket(self, line, startstr, handler, debug=False):
        return bracketUtils.match_mult_bracket(line, startstr, handler, debug)

    def merge_mult_bracket(self, line, lbracket, handler, debug):
        return bracketUtils.merge_mult_bracket(line, lbracket, handler, debug)

    def get_block(self, lines, start_u, end_u, style=[""], debug=False):
        return blockUtils.get_block(lines, start_u, end_u, style, debug)

    def get_mult_block(self, block, start_u, end_u, style=[""], debug=False):
        return blockUtils.get_mult_block(block, start_u, end_u, style, debug)

    def argv_l2s(self, lArgv, iType=""):
        return utils.argv_l2s(lArgv, iType)


    def set_filter(self, target, filte, path_filte):
        self.ext = target
        self.passFilter = filte
        self.pathFilter = path_filte

    def cmd(self, cmd, log=False):
        if log:
            print cmd
        else:
            cmd = cmd + " 1>nul"
        os.system(cmd)

    def get_defs_argv(self, name):
        _argv = []
        for func in self.model["hotfix_list_functions"]:
            if func[0] == name:
                _argv = func[1]
                break
        return _argv

    def trans_struct_style(self, block):
        _debug = False
        _match, _merge, _block = self.get_block(
            block, 
            ["for {0} in getiterator({1}) do", "\w.*", "\w.*"], 
            ["end;", []], 
            "",
            _debug
        )
        while _match != []:
            _newblock = []
            _count = 0
            for line in _block:
                _count = _count + 1
                if _count == 1:
                    _origin, lmatch = self.Match(line, "for {0} in getiterator({1}) do", ["\w.*", "\w.*"], "")
                    _space = self.space_count(line)
                    line = chr(common.S)*_space + "foreach({0}, function (item)".format(lmatch[1])
                    for argv in lmatch[0].split(','):
                        if argv != "_":
                            line = line + "\n{0}local {1} = item.current\n".format(chr(common.S)*(_space+1), argv)
                elif _count == len(_block):
                    line = chr(common.S)*(_space) + "end)\n"
                else:
                    if line.strip() == "break" or line.strip() == "break;":
                        _space = self.space_count(line)
                        line = chr(common.S)*_space + "return \"break\";\n"
                _newblock.append(line)

            if len(_newblock) == 0:
                break
            block = self.merge_block(block, _newblock, _merge)
            _match, _merge, _block = self.get_block(
                block, 
                ["for {0} in getiterator({1}) do", "\w.*", "\w.*"], 
                ["end;", []], 
                "",
                _debug
            )

        _newblock = []
        regx = "[A-Za-z0-9\. \"\[\]\(\)]*"
        _match, _merge, _block = self.get_block(block, ["EventDelegate.Add__{0}", "\w*.*"], ["", []], [""])
        if _match != []:
            for i, line in enumerate(_block):
                if i == 0:
                    _s = self.space_count(line)
                    _ori1, _lma1 = self.Match(_match[0], "{0}({1}", ["[A-Za-z0-9_]*", "\w*.*"], "")
                    line = chr(common.S) * _s + "EventDelegate.Add({0}\n".format(_lma1[1]) 
                _newblock.append(line)
        block = self.merge_block(block, _newblock, _merge)
        return block

    def trans_line_style(self, block):
        return stylebuilder.lineBuilder(block)

    def write_init_file(self, lModels):
        initFile = self.OutputFolder + "\\" + "init.lua"
        lCore = [
            "util = require 'xlua.util'\n",
            "xutf8 = require 'xutf8'\n",
            "require 'xstr'\n",
            "require 'JSON'\n",
            "require 'Global'\n",
            "require 'cs_config'\n",
            "require 'XLuaBehaviour'\n",
            "require 'BaseCom'\n",
            "require 'Main'\n",
            "require 'LogicStatic'\n",
        ]

        lGame = []
        for mod in lModels:
            if not mod in "init":
                lGame.append("require '{0}'\n".format(mod))

        if os.path.exists(self.OutputFolder):
            with open(initFile, "w") as f_w:
                f_w.writelines("------------ core require ------------\n")
                f_w.writelines(lCore)
                f_w.writelines("------------ game require ------------\n")
                f_w.writelines(lGame)
                f_w.writelines("\nMain:__init()\n")
                
    def init_module_info(self, filename):
        self.model["name"] = filename.replace(".lua", "")
        self.model["module"] = self.luatag + self.model["name"]
        self.model["defs"] = []
        self.model["hotfix_list_functions"] = []
    
    def dump_head_block(self):
        lblock = []
        if self.lines == None or len(self.lines) == 0:
            print "no lines input."
            return lblock
            
        _match, _info, _block = self.get_block(self.lines, ["require {0}", "\w*.*"], [" = {{", []])
        lblock.append("\n")

        lInput = [
            "local this = nil\n",
            "{0} = BaseCom:New('{0}')\n".format(self.model["module"]),
            "function {0}:Ref(ref)\n".format(self.model["module"]),
            "   if ref then\n",
            "       this = ref\n",
            "   end\n",
            "   return this\n",
            "end\n\n",
        ]
        lblock.append(lInput)

        return lblock

    def dump_method_block(self, block):
        _match, _info, _instance_methods_block = self.get_block(self.lines, ["local instance_methods = {{"], ["}};", []])
        _blocks = self.get_mult_block(_instance_methods_block, ["{0} = function({1})", "\w.*", "\w.*"], ["", []])
        for _block_u in _blocks:
            _match, _info, _block = _block_u[0:3]
            if _match != []:
                _offsetX = 0
                _name = _match[0].strip()
                _argv =  _match[1].split(",")
                if (_name in self.lNoHotfix):
                    continue

                self.model["defs"].append([_name, _argv, _info, _block, _offsetX])

        tmp_block = []
        for defs in self.model["defs"]:
            _sDefname   = defs[0]
            _lDefArgv   = defs[1]
            funcblock  = defs[3]
            _offsetX    = defs[4]
            if funcblock != []:
                def_block = []
                ldefargv = []
                isIEnumerator = False
                offset_x = self.space_count(funcblock[len(funcblock)-1])
                _include_base = False
                for idnex, line in enumerate(funcblock):
                    if idnex == 0:
                        _origin, _match = self.Match(line, "{0} = function({1})", [_sDefname, "\w.*"], "")
                        if len(_match) > 0:
                            ldefargv =  _match[1].split(",")
                        else:
                            ldefargv = []
                        _sDefargv = self.argv_l2s(ldefargv, "no_this")
                        line = "function {0}:{1}({2})\n".format(self.model["module"], _sDefname, _sDefargv)
                    else:
                        if "this.base" in line or "LogicStatic" in line:
                            _include_base = True
                            break

                    if "wrapyield" in line:
                        isIEnumerator = True

                    if idnex == len(funcblock):
                        if "return nil;" in line:
                            isIEnumerator = True

                    def_block.append(line)
                    if idnex == 0:
                        def_block.append(chr(common.S) + "GameLog(\"" + "-"*30 + self.model["module"] + " " + _sDefname + "-"*30 + "\")\n")

                if not _include_base:
                    def_block = self.align_block_lines(def_block)
                    self.model["hotfix_list_functions"].append([_sDefname, ldefargv, isIEnumerator])
                    tmp_block.append([_sDefname, def_block])

        for _tmp in tmp_block:
            _name, _block = _tmp[0:2]
            self.model["cur_function"] = _name
            _block = self.trans_line_style(_block)
            _block = self.trans_struct_style(_block)
            block.append(_block)

        return block
    
    def align_block_lines(self, block):
        offsetX = self.space_count(block[len(block)-1])
        def_block_align = []
        for line in block:
            offset = (self.space_count(line) - offsetX)
            if offset >=0:
                line = chr(common.S)*(offset) + line.lstrip()
            def_block_align.append(line)
        def_block_align.append("\n") 
        return def_block_align  

    def dump_hotfix_block(self, block):
        hotfix_block = []
        hotfix_block.append("function {0}:hotfix()\n".format(self.model["module"]))
        if len(self.model["hotfix_list_functions"]) > 0:
            hotfix_block.append(chr(common.S) + "xlua.hotfix({0}, {{\n".format(self.model["name"])),
            for func in self.model["hotfix_list_functions"]:
                sFName = func[0]
                sArgv = self.argv_l2s(func[1])
                sNoArgv = self.argv_l2s(func[1], "no_this")
                isIEnumerator = func[2]
                if sFName in self.lNoHotfix or "_" in sFName:
                    continue
                if isIEnumerator:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(self.model["module"]),
                        "           return util.cs_generator(function()\n",
                        "               {0}:{1}({2})\n".format(self.model["module"], sFName, sNoArgv),
                        "           end)\n",
                        "       end,\n",
                    ]
                else:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(self.model["module"]),
                        "           return {0}:{1}({2})\n".format(self.model["module"], sFName, sNoArgv),
                        "       end,\n",
                    ]
                for line in lInput:
                    hotfix_block.append(line)
            hotfix_block.append("   })\n")
        hotfix_block.append("end\n\n")
        hotfix_block.append("table.insert(g_tbHotfix, {0})".format(self.model["module"]))
        block.append(hotfix_block)
        return block

    def dump_block(self):
        lBlock = self.dump_head_block()
        lBlock = self.dump_method_block(lBlock)
        lBlock = self.dump_hotfix_block(lBlock)
        return lBlock

    def find(self, target=""):
        mods = [] 
        for parent, dirnames, filenames in os.walk(self.ScriptFolder):
            for filename in filenames:
                if (not self.IsPassFile(filename) and not self.IsPassPath(parent)) and self.IsTargetExt(filename) and self.IsTargetFile(filename):
                    fullname = os.path.join(parent, filename)
                    self.init_module_info(filename)
                    self.Read(parent, filename)
                    mods.append(self.model["name"])
        self.write_init_file(mods)

    def Read(self, parent, filename):
        print "-"*50, filename, "-"*50
        with open(self.ScriptFolder + "\\" + filename, "r") as f:
            self.lines = f.readlines()

        lblock = self.dump_block()

        if not os.path.exists(self.OutputFolder):
            os.makedirs(self.OutputFolder)

        with open(self.OutputFolder + "\\" + filename, "w") as f_w:
            for block in lblock:
                for line in block:
                    f_w.write(line)

if __name__=="__main__":
    finder = AutoLua(sys.argv)
    finder.set_filter(
        [".lua"], 
        #ignore file
        ["manifest.lua", "tmp.lua", "init.lua"],
        #ignore path
        ["core"]
    )
    finder.find()

