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

    def get_match(self, line, origin, char, isExReCompile="", debug=False):
        return matchUtils.get_match(line, origin, char, isExReCompile, debug)

    def merge_block(self, oldblock, newblock, info):
        return blockUtils.merge_block(oldblock, newblock, info)

    def dump_argv(self, line, debug=False):
        return utils.dump_argv(line, debug)

    def get_block(self, lines, start_u, style=[""], debug=False):
        return blockUtils.get_block(lines, start_u, style, debug)

    def get_mult_block(self, block, start_u, style=[""], debug=False):
        return blockUtils.get_mult_block(block, start_u, style, debug)

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
        for func in self.model["hotfixs"]:
            if func[0] == name:
                _argv = func[1]
                break
        return _argv

    def trans_blocks_style(self, block):
        _debug = False
        _match, _block = self.get_block(block, ["for {0} in getiterator({1}) do", "\w.*", "\w.*"])
        _merge = blockUtils.merge_info()
        while _match != []:
            _newblock = []
            _count = 0
            for line in _block:
                _count = _count + 1
                if _count == 1:
                    lmatch = self.get_match(line, "for {0} in getiterator({1}) do", ["\w.*", "\w.*"])
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
            _match, _block = self.get_block(block, ["for {0} in getiterator({1}) do", "\w.*", "\w.*"])
            _merge = blockUtils.merge_info()

        _newblock = []
        regx = "[A-Za-z0-9\. \"\[\]\(\)]*"
        _match, sub_block = self.get_block(block, ["EventDelegate.Add__{0}", "\w*.*"])
        merge = blockUtils.merge_info()
        if _match != []:
            for i, line in enumerate(sub_block):
                if i == 0:
                    _s = self.space_count(line)
                    _lmatch = self.get_match(_match[0], "{0}({1}", ["[A-Za-z0-9_]*", "\w*.*"])
                    line = chr(common.S) * _s + "EventDelegate.Add({0}\n".format(_lmatch[1]) 
                _newblock.append(line)
        block = self.merge_block(block, _newblock, merge)
        return block

    def trans_lines_style(self, block):
        return stylebuilder.lineBuilder(block)

    def dump_initlua(self, lModels):
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
                
    def init_info(self, filename):
        self.model["name"] = filename.replace(".lua", "")
        self.model["luamod"] = self.luatag + self.model["name"]
        self.model["methods"] = []
        self.model["hotfixs"] = []
    
    def dump_head_block(self):
        lblock = []
        if self.lines == None or len(self.lines) == 0:
            print "no lines input."
            return lblock
            
        _match, _block = self.get_block(self.lines, ["require {0}", "\w*.*"])
        lblock.append("\n")

        lInput = [
            "local this = nil\n",
            "{0} = BaseCom:New('{0}')\n".format(self.model["luamod"]),
            "function {0}:Ref(ref)\n".format(self.model["luamod"]),
            "   if ref then\n",
            "       this = ref\n",
            "   end\n",
            "   return this\n",
            "end\n\n",
        ]
        lblock.append(lInput)
        return lblock

    def dump_method_block(self, outblock):
        _match, methods_block = self.get_block(self.lines, ["local instance_methods = {{"])
        methods = self.get_mult_block(methods_block, ["{0} = function({1})", "\w.*", "\w.*"])
        for method in methods:
            _match, _info, _block = method[0:3]
            if _match != []:
                offx = 0
                _name = _match[0].strip()
                _argv =  _match[1].split(",")
                if (_name in self.lNoHotfix):
                    continue
                self.model["methods"].append([_name, _argv, _info, _block, offx])

        lban = [
            "this.base", 
            "LogicStatic", 
            "AddMissingComponent", 
            "UITweener.Begin"
        ]
        tmp_block = []
        for method in self.model["methods"]:
            name, argv, _tmp_, content = method[0:4]
            if content != []:
                def_block = []
                largv = []
                isIEnumerator = False
                offset_x = self.space_count(content[len(content)-1])
                isban = False
                for idnex, line in enumerate(content):
                    if idnex == 0:
                        lmatch = self.get_match(line, "{0} = function({1})", [name, "\w.*"])
                        if len(lmatch) > 0:
                            largv =  lmatch[1].split(",")
                        else:
                            largv = []
                        argvstr = self.argv_l2s(largv, "no_this")
                        line = "function {0}:{1}({2})\n".format(self.model["luamod"], name, argvstr)
                    else:
                        for ban in lban:
                            if ban in line:
                                isban = True
                                break

                    if "wrapyield" in line:
                        isIEnumerator = True

                    if idnex == len(content):
                        if "return nil;" in line:
                            isIEnumerator = True

                    def_block.append(line)
                    if idnex == 0:
                        log = "{0}GameLog(\"{1}{2} {3}{4}\")\n".format(chr(common.S), "-"*30, self.model["luamod"], name, "-"*30)
                        def_block.append(log)

                if not isban:
                    def_block = self.align_block_lines(def_block)
                    self.model["hotfixs"].append([name, largv, isIEnumerator])
                    tmp_block.append([name, def_block])

        for tmp in tmp_block:
            name, _block = tmp[0:2]
            self.model["cur_method"] = name
            _block = self.trans_lines_style(_block)
            _block = self.trans_blocks_style(_block)
            outblock.append(_block)

        return outblock
    
    def align_block_lines(self, block):
        offsetX = self.space_count(block[len(block)-1])
        lret = []
        for line in block:
            offset = (self.space_count(line) - offsetX)
            if offset >=0:
                line = chr(common.S)*(offset) + line.lstrip()
            lret.append(line)
        lret.append("\n") 
        return lret  

    def dump_hotfix_block(self, block):
        hotfix_block = []
        hotfix_block.append("function {0}:hotfix()\n".format(self.model["luamod"]))
        if len(self.model["hotfixs"]) > 0:
            hotfix_block.append(chr(common.S) + "xlua.hotfix({0}, {{\n".format(self.model["name"])),
            for func in self.model["hotfixs"]:
                sFName = func[0]
                sArgv = self.argv_l2s(func[1])
                sNoArgv = self.argv_l2s(func[1], "no_this")
                isIEnumerator = func[2]
                if sFName in self.lNoHotfix or "_" in sFName:
                    continue
                if isIEnumerator:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(self.model["luamod"]),
                        "           return util.cs_generator(function()\n",
                        "               {0}:{1}({2})\n".format(self.model["luamod"], sFName, sNoArgv),
                        "           end)\n",
                        "       end,\n",
                    ]
                else:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(self.model["luamod"]),
                        "           return {0}:{1}({2})\n".format(self.model["luamod"], sFName, sNoArgv),
                        "       end,\n",
                    ]
                for line in lInput:
                    hotfix_block.append(line)
            hotfix_block.append("   })\n")
        hotfix_block.append("end\n\n")
        hotfix_block.append("table.insert(g_tbHotfix, {0})".format(self.model["luamod"]))
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
                    self.init_info(filename)
                    self.Read(parent, filename)
                    mods.append(self.model["name"])
        self.dump_initlua(mods)

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

