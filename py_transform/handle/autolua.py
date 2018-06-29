# coding=utf-8
import os,sys, re
import shutil
from py_transform.utils import utils
from py_transform.utils import block_utils
from py_transform.utils import bracket_utils
from py_transform.utils import match_utils
from py_transform.utils import common
from py_transform.config import message
from py_transform.config import handle_config
from py_transform.logic import logic_transformer

class AutoLuaHandler(object):
    master = None
    script_path = ""
    output_path = ""
    lua_prefix = ""

    def __init__(self):
        pass

    def get_defs_argv(self, name):
        argv = []
        for function in message.model["hotfixs"]:
            if function[0] == name:
                argv = function[1]
                break
        return argv

    def transform_blocks_style(self, outblock, model = ""):
        # merge_out = []
        # def _handler1(match, block, block_ln, mergeList):
        #     newblock = []
        #     for item in block_ln:
        #         linenum, index, line = item[0:3]
        #         oldline = line
        #         _space = utils.space_count(line)
        #         offsetX = chr(common.S)*(_space)
        #         offsetX_1 = chr(common.S)*(_space + 1)
        #         if index == 0:
        #             lmatch = match_utils.get_match(line, "for {0} in getiterator({1}) do", ["\w.*", "\w.*"])
        #             line = offsetX + "obj_foreach({0}, function (item)".format(lmatch[1])
        #             for argv in lmatch[0].split(','):
        #                 if argv != "_":
        #                     line = line + "\n{0}local {1} = item.current\n".format(offsetX_1, argv)
        #         elif index == len(block)-1:
        #             line = offsetX + "end)\n"
        #         else:
        #             if line.strip() == "break" or line.strip() == "break;":
        #                 line = offsetX + "return \"break\";\n"

        #         if oldline != line:
        #             merge_out.append([linenum, oldline, line])
   
        # lists = block_utils.get_mult_block(outblock, ["for {0} in getiterator({1}) do", "\w.*", "\w.*"], _handler1)
        # outblock = self.merge_ex(outblock, merge_out)

        merge_out2 = []
        def _handler2(match, block, block_ln, mergeList):
            largv = []
            if match != []:
                largv = utils.dump_argv(match[0])
                if len(largv)>=7:
                    obj, nil, mfunc, delegate = largv[3:7]

                    mfunc = mfunc.replace('"', '')
                    delegate_l = delegate.split(";")
                    if len(delegate_l)>1:
                        delegate = delegate_l[0].split("=")
                    if isinstance(delegate_l, list):
                        delegate = delegate_l[0]

            for item in block_ln:
                linenum, i, line = item[0:3]
                oldline = line
                if len(block) == 1:
                    line = "{0}.{1} = {2}\n".format( obj, mfunc, delegate)
                elif len(block) > 1:
                    if i == 0:
                        line = "{0}.{1} = {2}\n".format( obj, mfunc, delegate)
                        line = line.rstrip() + ")\n"
                    elif i == len(block) -1:
                        if line.strip() == "end))":
                            line = "end)\n"

                line = utils.offsetx(oldline, line)
                if oldline != line:
                    merge_out2.append([linenum, oldline, line])

        block_utils.get_mult_block(outblock, ["delegationset({0})", "\w*.*"], _handler2)
        block_utils.get_mult_block(outblock, ["delegationadd({0})", "\w*.*"], _handler2)
        outblock = self.merge_ex(outblock, merge_out2, True)
        return outblock

    def merge_ex(self, block, merge_out, debug=False):
        start = False
        start_count = 0
        outer = None
        for i, line in enumerate(block):
            for item in merge_out:
                linenum = item[0]
                rep_line = item[1]
                to_line = item[2]
                if i == linenum and line == rep_line:
                    block[i] = block[i].replace(rep_line, to_line)
                    break

        return block
        
    def init_info(self, filename, lines):
        # 当前转译中的lua文本
        message.model["lines"] = lines
        # 当前转译中的lua模块
        message.model["lua_file_name"] = filename.replace(".lua", "")
        # 当前lua函数
        message.model["lua_method"] = ""
        # 当前lua模块名
        # message.model["lua_mod_name"] = message.model["lua_file_name"].split("__")[-1]
        message.model["lua_mod_name"] = "_M"
        # 当前CS模块名
        cs_clazz = "CS." + message.model["lua_file_name"].replace("__", ".")
        message.model["cs_mod_name"] = cs_clazz
        # 当前模块的函数列表
        message.model["methods"] = []
        # 当前模块的热更函数列表
        message.model["hotfixs"] = []
        # 当前需要替换的函数名
        message.model["changed_method_name"] = {}

    # 生成Init.lua
    # def get_init_lua_block(self):
    #     lCoreRequire = [
    #         "require('core.Class')\n",
    #         "xlua_util = require('3rd.xlua.util')\n",
    #         "require('3rd.utf8')\n",
    #         "require('3rd.xstr')\n",
    #         "require('3rd.json')\n",
    #         "require('3rd.list')\n",
    #         "require('3rd.event')\n",
    #         "require('3rd.ltn12')\n",
    #         "require('3rd.unity.Mathf')\n",
    #         "require('3rd.unity.Vector3')\n",
    #         "require('core.Global')\n",
    #         "require('core.CsClassName')\n",
    #         "require('core.utils.LuaUtil')\n",
    #         "require('core.Main')\n",
    #     ]

    #     block = []
    #     block.append("------------ core require ------------\n")
    #     block.append(lCoreRequire)
    #     block.append("------------ game require ------------\n")
    #     block.append("\nMain:HotfixMain()\n")
    #     return block
    
    # 生成头信息
    def dump_head_block(self):
        if message.model["lines"] == "":
            return []

        lblock = []
        match, block = block_utils.get_one_block(message.model["lines"], ["require {0}", "\w*.*"])
        lblock.append("\n")

        lInput = [
            "local PlatformUtil = require('core.utils.PlatformUtil')\n",
            "local LuaUtil = require('core.utils.LuaUtil')\n\n",
            "local this = nil\n",
            "local cs_clazz = {0}\n".format(message.model["cs_mod_name"]),
            "local {0} = class('{1}')\n\n".format(message.model["lua_mod_name"], message.model["lua_file_name"]),
            "function {0}:Ref(ref)\n".format(message.model["lua_mod_name"]),
            "   if ref then\n",
            "       this = ref\n",
            "   end\n",
            "   return this\n",
            "end\n\n",
        ]
        lblock.append(lInput)
        return lblock

    def dump_method_block(self, outblock):
        lines = message.model["lines"]

        # get "instance_methods" block
        lmatch, methodsblock = block_utils.get_one_block(lines, ["local instance_methods = {{"])
        def _handler2(lmatch, block, block_ln, mergeList):
            if lmatch != []:
                name = lmatch[0].strip()
                argv =  lmatch[1].split(",")
                if not name in handle_config.ban_methods:
                    message.model["methods"].append([name, argv, block, lmatch])

        block_utils.get_mult_block(methodsblock, ["{0} = function({1})", "\w.*", "\w.*"], _handler2)
        block_utils.get_mult_block(methodsblock, ["{0} = wrapenumerable(function({1})", "\w.*", "\w.*"], _handler2)
        
        better_block = self.check_ban_method_block()

        for item in better_block:
            name, block = item[0:2]
            block = logic_transformer.handle(block)
            block = self.transform_blocks_style(block)
            outblock.append(block)
        return outblock

    def check_ban_method_block(self):
        tmp_block = []
        for method in message.model["methods"]:
            method_name, argv, content, lmatch = method[0:4]
            if content != []:
                def_block = []
                largv = []
                isIEnumerator = False
                offset_x = utils.space_count(content[len(content)-1])
                is_ban_line = False
                for idnex, line in enumerate(content):
                    if idnex == 0:
                        # lmatch = match_utils.get_match(line, "{0} = function({1})", [method_name, "\w.*"])
                        if len(lmatch) > 0:
                            largv =  lmatch[1].split(",")
                        argvstr = utils.argv_l2s(largv, "no_this")
                        line = "function {0}:{1}({2})\n".format(message.model["lua_mod_name"], method_name, argvstr)
                    else:
                        for ban in handle_config.ban_lines:
                            if ban in line:
                                is_ban_line = True
                                break

                    if "wrapyield" in line:
                        isIEnumerator = True

                    if idnex == len(content):
                        if "return nil;" in line:
                            isIEnumerator = True

                    def_block.append(line)

                if not is_ban_line:
                    def_block = self.align_block_lines(def_block)
                    message.model["hotfixs"].append([method_name, largv, isIEnumerator])
                    message.model["lua_method"] = method_name
                    tmp_block.append([method_name, def_block])

        return tmp_block
    
    def tag(self, chunk, method=""):
        ret = False
        if chunk != "":
            ret = message.model["lua_mod_name"] == chunk

        if method != "":
            ret = message.model["lua_method"] == method
        return ret

    def align_block_lines(self, block):
        offsetX = utils.space_count(block[len(block)-1])
        lret = []
        for line in block:
            offset = (utils.space_count(line) - offsetX)
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
        hotfix_block.append("function {0}:hotfix()\n".format(message.model["lua_mod_name"]))
        if len(message.model["hotfixs"]) > 0:
            headstr = "{0}xlua.hotfix({1}, {{\n".format(chr(common.S), message.model["lua_file_name"])
            hotfix_block.append(headstr),
            for func in message.model["hotfixs"]:
                sFName = func[0]
                # sFName = self.check_changed_name(sFName)
                sArgv = utils.argv_l2s(func[1])
                sNoArgv = utils.argv_l2s(func[1], "no_this")
                isIEnumerator = func[2]
                if sFName in handle_config.ban_methods or "_" in sFName:
                    continue
                if isIEnumerator:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(message.model["lua_mod_name"]),
                        "           return util.cs_generator(function()\n",
                        "               {0}:{1}({2})\n".format(message.model["lua_mod_name"], sFName, sNoArgv),
                        "           end)\n",
                        "       end,\n",
                    ]
                else:
                    lInput = [
                        "       ['{0}'] = function({1})\n".format(sFName, sArgv),
                        "           {0}:Ref(this)\n".format(message.model["lua_mod_name"]),
                        "           return {0}:{1}({2})\n".format(message.model["lua_mod_name"], sFName, sNoArgv),
                        "       end,\n",
                    ]
                for line in lInput:
                    hotfix_block.append(line)
            hotfix_block.append("   })\n")
        hotfix_block.append("end\n\n")
        # hotfix_block.append("table.insert(g_tbHotfix, {0})\n".format(message.model["lua_mod_name"]))
        hotfix_block.append("return {0}".format(message.model["lua_mod_name"]))
        block.append(hotfix_block)
        return block

    def dump_block(self):
        lBlock = self.dump_head_block()
        lBlock = self.dump_method_block(lBlock)
        lBlock = self.dump_hotfix_block(lBlock)
        return lBlock

    def set_data(self, argv):
        self.script_path = argv[1]
        self.output_path = argv[2]
    
    def handle_data(self, lines, filename):
        is_apply_file = False
        for apply in handle_config.apply_files:
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

   
