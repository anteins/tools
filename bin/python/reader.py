# -*- coding: cp936 -*-

import os,sys, re
import shutil

class xreader(object):
    ext = []
    passFilter = []
    pathFilter = []
    ScriptFolder = ""
    OutputFolder = ""
    handler=None
    handlerArgv=None
    lines = []
    targets = []

    def __init__(self, argv):
        if argv != None:
            self.handlerArgv = argv

    def IsTargetExt(self, filename):
        flag = False
        for target in self.ext:
            if target in filename:
                flag = True
                break
        return flag

    def IsTargetFile(self, filename):
        flag = False
        if self.targets == []:
            return True
        else:
            return filename in target

    def IsPassFile(self, filename):
        flag = False
        for filter in self.passFilter:
            if filter in filename:
                flag = True
                break
        return flag

    def IsPassPath(self, path):
        flag = False
        for filt in self.pathFilter:
            if self.ScriptFolder + "/" + filt == path:
                flag = True
                break
        return flag

    def set_filter(self, target, filte, path_filte):
        self.ext = target
        self.passFilter = filte
        self.pathFilter = path_filte

    def set_handler(self, handler):
        self.handler = handler

    def set_handler_data(self):
        if len(self.handlerArgv) <=1:
            self.ScriptFolder = os.getcwd()
        else:
            self.ScriptFolder = self.handlerArgv[1]
            self.OutputFolder = self.handlerArgv[2]
            
        if self.handler != None:
            self.handler.set_data(self.handlerArgv)

    def find(self, target=""):
        self.set_handler_data()
        for parent, dirnames, filenames in os.walk(self.ScriptFolder):
            for filename in filenames:
                if (not self.IsPassFile(filename) and not self.IsPassPath(parent)) and self.IsTargetExt(filename) and self.IsTargetFile(filename):
                    fullname = os.path.join(parent, filename)
                    self.on_excute(parent, filename)
        self.on_finish()

    def on_excute(self, parent, filename):
        # print "-"*50, filename, "-"*50
        with open(self.ScriptFolder + "\\" + filename, "r") as f:
            self.lines = f.readlines()

        if self.handler != None:
            self.handler.on_excute(self.lines, parent, filename)
        else:
            self.__onExcute(self.lines, parent, filename)

    def on_finish(self):
        if self.handler != None:
            self.handler.on_finish()

    def __onExcute(self, lines, parent, filename):
        pass

if __name__=="__main__":
    xrer = xreader(sys.argv)
    xrer.set_filter(
        [".lua"], 
        #ignore file
        ["manifest.lua", "tmp.lua", "init.lua"],
        #ignore path
        ["core"]
    )
    xrer.find()

