# -*- coding: cp936 -*-

import os,sys, re
import shutil

class xreader(object):
    ext = []
    pass_filter = []
    path_filter = []
    script_path = ""
    output_path = ""
    handler=None
    handler_argv=None
    targets = []

    def __init__(self, argv):
        if argv != None:
            self.handler_argv = argv

    def is_target_file_ext(self, filename):
        flag = False
        for target in self.ext:
            if target in filename:
                flag = True
                break
        return flag

    def is_target_file(self, filename):
        flag = False
        if self.targets == []:
            return True
        else:
            return filename in target

    def is_ban_file(self, filename):
        flag = False
        for filter in self.pass_filter:
            if filter in filename:
                flag = True
                break
        return flag

    def is_ban_path(self, path):
        flag = False
        for filt in self.path_filter:
            if self.script_path + "/" + filt == path:
                flag = True
                break
        return flag

    def set_filter(self, target, filte, path_filte):
        self.ext = target
        self.pass_filter = filte
        self.path_filter = path_filte

    def set_handler_data(self, handler):
        self.handler = handler

        self.handler.master = self

        if len(self.handler_argv) <=1:
            self.script_path = os.getcwd()
        else:
            self.script_path = self.handler_argv[1]
            self.output_path = self.handler_argv[2]
            
        self.handler.set_data(self.handler_argv)

    def start(self, handler=None):
        ## 设置worker
        self.set_handler_data(handler)

        for parent, dirnames, filenames in os.walk(self.script_path):
            for filename in filenames:
                if (not self.is_ban_file(filename) and not self.is_ban_path(parent)) and self.is_target_file_ext(filename) and self.is_target_file(filename):
                    fullname = os.path.join(parent, filename)
                    self.handle_file(filename)

        self.all_finish()

    def handle_file(self, filename):
        with open(self.script_path + "\\" + filename, "r") as f:
            lines = f.readlines()

        self.handler.handle_data(lines, filename)

    def all_finish(self):
        block = self.handler.get_init_lua_block()
        self.savefile(self.output_path + "\\" + "Init.lua", block)

    def savefile(self, filepath, lblock):
        with open(filepath, "w") as f_w:
            for block in lblock:
                for line in block:
                    f_w.write(line)


if __name__=="__main__":
    xrer = xreader(sys.argv)
    xrer.set_filter(
        [".lua"], 
        #ignore file
        ["manifest.lua", "tmp.lua", "Init.lua"],
        #ignore path
        ["core"]
    )
    xrer.start()

