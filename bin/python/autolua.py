# -*- coding: cp936 -*-

import os,sys, re
import shutil
import utils.utils as utils
import utils.blockUtils as blockUtils
import utils.bracketUtils as bracketUtils
import utils.matchUtils as matchUtils
import utils.common as common
import utils.message as message
import transfer

import ply.lex as lex
import ply.yacc as yacc

class Autolua(object):
    ext = []
    passFilter = []
    pathFilter = []
    ScriptFolder = ""
    OutputFolder = ""
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

    def __init__(self):
        pass

    def space_count(self, line, debug=False):
        return utils.space_count(line, debug)

    def get_match(self, line, origin, char, isExReCompile="", debug=False):
        return matchUtils.get_match(line, origin, char, isExReCompile, debug)

    def get_block(self, root, start_u, style=[""], debug=False):
        return blockUtils.get_block(root, start_u, style, debug)

    def argv_l2s(self, lArgv, iType=""):
        return utils.argv_l2s(lArgv, iType)

    def cmd(self, cmd, log=False):
        if log:
            print cmd
        else:
            cmd = cmd + " 1>nul"
        os.system(cmd)

    def get_defs_argv(self, name):
        _argv = []
        for func in message.model["hotfixs"]:
            if func[0] == name:
                _argv = func[1]
                break
        return _argv

    def trans_blocks_style(self, outblock):
        _debug = False
        #--------------------------------- for {0} in getiterator ---------------------------------
        merge_out = []
        def _handler1(match, block, block_ln, mergeList):
            newblock = []
            for item in block_ln:
                root_index, index, line = item[0:3]
                oldline = line
                _space = self.space_count(line)
                offsetX = chr(common.S)*(_space)
                offsetX_1 = chr(common.S)*(_space + 1)
                if index == 0:
                    lmatch = self.get_match(line, "for {0} in getiterator({1}) do", ["\w.*", "\w.*"])
                    line = offsetX + "foreach({0}, function (item)".format(lmatch[1])
                    for argv in lmatch[0].split(','):
                        if argv != "_":
                            line = line + "\n{0}local {1} = item.current\n".format(offsetX_1, argv)
                elif index == len(block)-1:
                    line = offsetX + "end)\n"
                else:
                    if line.strip() == "break" or line.strip() == "break;":
                        line = offsetX + "return \"break\";\n"

                if oldline != line:
                    merge_out.append([root_index, oldline, line])
   
        lists = blockUtils.get_mult_block(outblock, ["for {0} in getiterator({1}) do", "\w.*", "\w.*"], _handler1)
        outblock = self.mergeEx(outblock, merge_out)

        # #--------------------------------- EventDelegate.Add ---------------------------------
        # merge_out3 = []
        # def _handler3(root, match, outblock):
        #     largv = []
        #     if len(outblock) > 1: 
        #         no_match_bracket = False
        #         for index, line in enumerate(outblock):
                    
        #             oldline = line
        #             if index == 0:
        #                 if bracketUtils.check_bracket(line) == False:
        #                     no_match_bracket = True

        #             if index == len(outblock) -1:
        #                 if no_match_bracket:
        #                     if line.strip() == "end)":
        #                         line = line.replace("end)", "end))")

        #             if oldline != line:
        #                 
        #                 merge_out3.append([index, oldline, line])

        # lists = blockUtils.get_mult_block(outblock, ["EventDelegate.Set({0})", "\w*.*"], _handler3)
        # outblock = self.mergeEx(outblock, merge_out3, True)

        #--------------------------------- delegationset\delegationadd ---------------------------------
        merge_out2 = []
        def _handler2(match, block, block_ln, mergeList):
            largv = []
            if match != []:
                largv = utils.dump_argv(match[0])
                if len(largv)>=7:
                    _obj, _nil, _f, function = largv[3:7]
                    function = function.split(";")
                    if len(function)>1:
                        function = function[0].split("=")
                    if isinstance(function, list):
                        function = function[0]
                    _f = _f.replace("\"", "")

            for item in block_ln:
                root_index, index, line = item[0:3]
                oldline = line
                offsetX = chr(common.S) * utils.space_count(line)
                if len(block) == 1:
                    if len(largv)>=7:
                        line = offsetX + "{0}.{1} = {2}\n".format( _obj, _f, function)
                elif len(block) > 1:
                    if index == 0:
                        if len(largv)>=7:
                            line = offsetX + "{0}.{1} = {2}\n".format( _obj, _f, function)
                        line = line.rstrip() + ")\n"
                    elif index == len(block) -1:
                        if line.strip() == "end))":
                            line = offsetX + "end)\n"

                if oldline != line:
                    merge_out2.append([root_index, oldline, line])

        lists = blockUtils.get_mult_block(outblock, ["delegationset({0})", "\w*.*"], _handler2)
        lists = blockUtils.get_mult_block(outblock, ["delegationadd({0})", "\w*.*"], _handler2)
        outblock = self.mergeEx(outblock, merge_out2, True)
        return outblock

    def mergeEx(self, rootblock, merge_out, debug=False):
        start = False
        start_count = 0
        outer = None
        for root_index, line in enumerate(rootblock):
            for item in merge_out:
                if root_index == item[0] and line == item[1]:
                    rootblock[root_index] = rootblock[root_index].replace(item[1], item[2])
                    break
            # if start == False and outer == None:
            #     for key in merge_out:
            #         if line == key:
            #             outer = merge_out[key]
            #             start = True
            #             start_count = 0
            #             break
            # if outer != None and start:
            #     item = outer["lines"]
            #     merge = outer["merge"]
            #     if debug:
            #         print "\n"
            #         print line.strip()
            #     # for ii in item:
            #     #     if debug:
            #     #         print "#", ii["new"].strip()
            #     #     if ii["old"] == line:
            #     #         before = block[index]
            #     #         block[index] = block[index].replace(ii["old"], ii["new"])
            #     #         fail = before == block[index]
            #     #         start_count = start_count + 1
            #     #         break
            #     for ii in ext:
            #         if block[index] == item[0]:
            #             block[index] = block[index].replace(item[0], item[1])
            #             break
            #     else:
            #         start = False
            #         outer = None
        return rootblock

    def init_info(self, filename, lines):
        message.model["lines"] = lines
        message.model["mod"] = filename.replace(".lua", "")
        message.model["cur_method"] = ""
        message.model["cur_chunk"] = self.luatag + filename.replace(".lua", "")
        message.model["methods"] = []
        message.model["hotfixs"] = []

    def dump_init_block(self, mods):
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
        for mod in mods:
            if not mod in "init":
                lGame.append("require '{0}'\n".format(mod))

        block = []
        block.append("------------ core require ------------\n")
        block.append(lCore)
        block.append("------------ game require ------------\n")
        block.append(lGame)
        block.append("\nMain:__init()\n")
        return block
    
    def dump_head_block(self):
        lblock = []
        if message.model["lines"] == "":
            return lblock
            
        _match, _block = self.get_block(message.model["lines"], ["require {0}", "\w*.*"])
        lblock.append("\n")

        lInput = [
            "local this = nil\n",
            "{0} = BaseCom:New('{0}')\n".format(message.model["cur_chunk"]),
            "function {0}:Ref(ref)\n".format(message.model["cur_chunk"]),
            "   if ref then\n",
            "       this = ref\n",
            "   end\n",
            "   return this\n",
            "end\n\n",
        ]
        lblock.append(lInput)
        return lblock

    def dump_method_block(self, outblock):
        lmatch, methodsblock = self.get_block(message.model["lines"], ["local instance_methods = {{"])
        def _handler2(lmatch, block, block_ln, mergeList):
            if lmatch != []:
                name = lmatch[0].strip()
                argv =  lmatch[1].split(",")
                if not name in self.lNoHotfix:
                    message.model["methods"].append([name, argv, block])

        lists = blockUtils.get_mult_block(methodsblock, ["{0} = function({1})", "\w.*", "\w.*"], _handler2)
        lban = [
            "this.base", 
            "LogicStatic", 
            "AddMissingComponent", 
            "UITweener.Begin",
            "GetDataByCls",
            "CheckAndAddComponet",
            "GetComponentInChildren",
            "NGUITools"
        ]
        tmp_block = []
        for method in message.model["methods"]:
            methodname, argv, content = method[0:3]
            if content != []:
                def_block = []
                largv = []
                isIEnumerator = False
                offset_x = self.space_count(content[len(content)-1])
                isban = False
                for idnex, line in enumerate(content):
                    if idnex == 0:
                        lmatch = self.get_match(line, "{0} = function({1})", [methodname, "\w.*"])
                        if len(lmatch) > 0:
                            largv =  lmatch[1].split(",")
                        else:
                            largv = []
                        argvstr = self.argv_l2s(largv, "no_this")
                        line = "function {0}:{1}({2})\n".format(message.model["cur_chunk"], methodname, argvstr)
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
                    # if idnex == 0:
                    #     log = "{0}GameLog(\"{1}{2} {3}{4}\")\n".format(chr(common.S), "-"*30, message.model["cur_chunk"], methodname, "-"*30)
                    #     def_block.append(log)

                if not isban:
                    def_block = self.align_block_lines(def_block)
                    message.model["hotfixs"].append([methodname, largv, isIEnumerator])
                    tmp_block.append([methodname, def_block])

        for tmp in tmp_block:
            name, _block = tmp[0:2]
            message.model["cur_method"] = name
            _block = transfer.lineBuilder(_block)
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
        hotfix_block.append("function {0}:hotfix()\n".format(message.model["cur_chunk"]))
        if len(message.model["hotfixs"]) > 0:
            headstr = "{0}xlua.hotfix({1}, {{\n".format(chr(common.S), message.model["mod"])
            hotfix_block.append(headstr),
            for func in message.model["hotfixs"]:
                sFName = func[0]
                sArgv = self.argv_l2s(func[1])
                sNoArgv = self.argv_l2s(func[1], "no_this")
                isIEnumerator = func[2]
                if sFName in self.lNoHotfix or "_" in sFName:
                    continue
                if isIEnumerator:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(message.model["cur_chunk"]),
                        "           return util.cs_generator(function()\n",
                        "               {0}:{1}({2})\n".format(message.model["cur_chunk"], sFName, sNoArgv),
                        "           end)\n",
                        "       end,\n",
                    ]
                else:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(message.model["cur_chunk"]),
                        "           return {0}:{1}({2})\n".format(message.model["cur_chunk"], sFName, sNoArgv),
                        "       end,\n",
                    ]
                for line in lInput:
                    hotfix_block.append(line)
            hotfix_block.append("   })\n")
        hotfix_block.append("end\n\n")
        hotfix_block.append("table.insert(g_tbHotfix, {0})".format(message.model["cur_chunk"]))
        block.append(hotfix_block)
        return block

    def dump_block(self):
        lBlock = self.dump_head_block()
        lBlock = self.dump_method_block(lBlock)
        lBlock = self.dump_hotfix_block(lBlock)
        self.allmods.append(message.model["mod"])
        return lBlock

    def set_data(self, argv):
        self.ScriptFolder = argv[1]
        self.OutputFolder = argv[2]

    allmods = []
    def on_excute(self, lines, parent, filename):
        self.init_info(filename, lines)
        lblock = self.dump_block()
        self.savefile(filename, lblock)

    def on_finish(self):
        block = self.dump_init_block(self.allmods)
        self.savefile("init.lua", block)

    def savefile(self, filename, lblock):
        if not os.path.exists(self.OutputFolder):
            os.makedirs(self.OutputFolder)

        with open(self.OutputFolder + "\\" + filename, "w") as f_w:
            for block in lblock:
                for line in block:
                    f_w.write(line)


