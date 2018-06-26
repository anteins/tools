# -*- coding: cp936 -*-

import os,sys, re
import shutil
import utils.utils as utils
import utils.block_utils as block_utils
import utils.bracket_utils as bracket_utils
import utils.match_utils as match_utils
import utils.common as common
import utils.message as message
import transformer

class Autolua(object):
    master = None
    all_mods = []
    script_path = ""
    output_path = ""
    lua_prefix = "hotfix_"

    apply_files = [
        "EightGame__Logic__"
    ]

    ban_methods = [
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

    ban_lines = [
        "this.base"
        # "LogicStatic", 
        "AddMissingComponent",
        "UITweener.Begin",
        "GetDataByCls",
        "CheckAndAddComponet",
        "GetComponentInChildren",
        "NGUITools", 
        "PadLeft",
        "this.entity"
    ]

    def __init__(self):
        pass

    def space_count(self, line, debug=False):
        return utils.space_count(line, debug)

    def get_match(self, line, origin, char, isExReCompile="", debug=False):
        return match_utils.get_match(line, origin, char, isExReCompile, debug)

    def argv_l2s(self, lArgv, iType=""):
        return utils.argv_l2s(lArgv, iType)

    def get_defs_argv(self, name):
        argv = []
        for function in message.model["hotfixs"]:
            if function[0] == name:
                argv = function[1]
                break
        return argv

    def trans_blocks_style(self, outblock):
        _debug = False
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
                    line = offsetX + "obj_foreach({0}, function (item)".format(lmatch[1])
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
   
        lists = block_utils.get_mult_block(outblock, ["for {0} in getiterator({1}) do", "\w.*", "\w.*"], _handler1)
        outblock = self.merge_ex(outblock, merge_out)

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

        lists = block_utils.get_mult_block(outblock, ["delegationset({0})", "\w*.*"], _handler2)
        lists = block_utils.get_mult_block(outblock, ["delegationadd({0})", "\w*.*"], _handler2)
        outblock = self.merge_ex(outblock, merge_out2, True)
        return outblock

    def merge_ex(self, rootblock, merge_out, debug=False):
        start = False
        start_count = 0
        outer = None
        for root_index, line in enumerate(rootblock):
            for item in merge_out:
                if root_index == item[0] and line == item[1]:
                    rootblock[root_index] = rootblock[root_index].replace(item[1], item[2])
                    break
        return rootblock

    def get_init_lua_block(self):
        block = self.dump_init_lua_block(self.all_mods)
        return block
        
    def init_info(self, filename, lines):
        message.model["lines"] = lines
        message.model["mod"] = filename.replace(".lua", "")
        message.model["cur_method"] = ""
        message.model["cur_chunk"] = self.lua_prefix + filename.replace(".lua", "")
        message.model["methods"] = []
        message.model["hotfixs"] = []
        message.model["changed_method_name"] = {}

    def dump_init_lua_block(self, mods):
        lcc = [
            ["XUtf8", "XUtf8"],
            ["XStr", "XStr"],
            ["XJson", "XJson"],
            ["", "Global"],
            ["", "cs_config"],
            ["", "BaseCom"],
            ["", "Main"],
        ]

        lCoreRequire = []
        for item in lcc:
            line = ""
            if item[0] != "":
                line = "{0} = require '{1}'\n".format(item[0], item[1])
            else:
                line = "require '{0}'\n".format(item[1])
            lCoreRequire.append(line)

        lGameRequire = []
        for mod in mods:
            if "Init" == mod:
                continue
            lGameRequire.append("require '{0}'\n".format(mod))

        block = []
        block.append("------------ core require ------------\n")
        block.append(lCoreRequire)
        block.append("------------ game require ------------\n")
        block.append(lGameRequire)
        block.append("\nMain:Enter\n")
        return block
    
    def dump_head_block(self):
        lblock = []
        if message.model["lines"] == "":
            return lblock
            
        _match, _block = block_utils.get_one_block(message.model["lines"], ["require {0}", "\w*.*"])
        lblock.append("\n")

        lInput = [
            "local this = nil\n",
            "local {0} = BaseCom:New('{0}')\n\n".format(message.model["cur_chunk"]),
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
        lmatch, methodsblock = block_utils.get_one_block(message.model["lines"], ["local instance_methods = {{"])
        def _handler2(lmatch, block, block_ln, mergeList):
            if lmatch != []:
                name = lmatch[0].strip()
                argv =  lmatch[1].split(",")
                if not name in self.ban_methods:
                    message.model["methods"].append([name, argv, block, lmatch])

        lists = block_utils.get_mult_block(methodsblock, ["{0} = function({1})", "\w.*", "\w.*"], _handler2)
        lists = block_utils.get_mult_block(methodsblock, ["{0} = wrapenumerable(function({1})", "\w.*", "\w.*"], _handler2)
        
        tmp_block = []
        for method in message.model["methods"]:
            method_name, argv, content, lmatch = method[0:4]
            if content != []:
                def_block = []
                largv = []
                isIEnumerator = False
                offset_x = self.space_count(content[len(content)-1])
                is_ban_line = False
                for idnex, line in enumerate(content):
                    if idnex == 0:
                        # lmatch = self.get_match(line, "{0} = function({1})", [method_name, "\w.*"])
                        if len(lmatch) > 0:
                            largv =  lmatch[1].split(",")
                        argvstr = self.argv_l2s(largv, "no_this")
                        line = "function {0}:{1}({2})\n".format(message.model["cur_chunk"], method_name, argvstr)
                    else:
                        for ban in self.ban_lines:
                            if ban in line:
                                is_ban_line = True
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
                
                if not is_ban_line:
                    def_block = self.align_block_lines(def_block)
                    message.model["hotfixs"].append([method_name, largv, isIEnumerator])
                    message.model["cur_method"] = method_name
                    tmp_block.append([method_name, def_block])

        for item in tmp_block:
            name, _block = item[0:2]
            _block = transformer.lineBuilder(_block)
            _block = self.trans_blocks_style(_block)
            outblock.append(_block)
        return outblock
    
    def tag(self, chunk, method=""):
        ret = False
        if chunk != "":
            ret = message.model["cur_chunk"] == chunk

        if method != "":
            ret = message.model["cur_method"] == method
        return ret

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

    def check_changed_name(self, name):
        for key in message.model["changed_method_name"]:
            if name in key:
                return message.model["changed_method_name"][key]
        return name

    def dump_hotfix_block(self, block):
        hotfix_block = []
        hotfix_block.append("function {0}:hotfix()\n".format(message.model["cur_chunk"]))
        if len(message.model["hotfixs"]) > 0:
            headstr = "{0}xlua.hotfix({1}, {{\n".format(chr(common.S), message.model["mod"])
            hotfix_block.append(headstr),
            for func in message.model["hotfixs"]:
                sFName = func[0]
                # sFName = self.check_changed_name(sFName)
                sArgv = self.argv_l2s(func[1])
                sNoArgv = self.argv_l2s(func[1], "no_this")
                isIEnumerator = func[2]
                if sFName in self.ban_methods or "_" in sFName:
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
        hotfix_block.append("table.insert(g_tbHotfix, {0})\n".format(message.model["cur_chunk"]))
        hotfix_block.append("return {0}".format(message.model["cur_chunk"]))
        block.append(hotfix_block)
        return block

    def dump_block(self):
        lBlock = self.dump_head_block()
        lBlock = self.dump_method_block(lBlock)
        lBlock = self.dump_hotfix_block(lBlock)
        self.all_mods.append(message.model["mod"])
        return lBlock

    def set_data(self, argv):
        self.script_path = argv[1]
        self.output_path = argv[2]
    
    def handle_data(self, lines, filename):
        is_apply_file = False
        for apply in self.apply_files:
            if apply in filename:
                is_apply_file = True

        if is_apply_file:
            print "-"*50, filename, "-"*50
            self.init_info(filename, lines)
            lblock = self.dump_block()

            if not os.path.exists(self.output_path + "\\hotfix\\"):
                os.makedirs(self.output_path + "\\hotfix\\")
            filepath = self.output_path + "\\hotfix\\" + filename
            self.master.savefile(filepath, lblock)

   