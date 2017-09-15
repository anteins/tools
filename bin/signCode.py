#coding:utf-8
import os, sys, re
import shutil
import hashlib
import json
from random import Random

class MixTool:
    PassingScript = [
        "GlobalConfig.lua"
    ]
    RootFolder = os.getcwd() + "\\"
    OutputFolder = ""
    SignedFolder = ""
    FilesSignatureEXE = ""
    DiffScriptFolder = RootFolder + "diff" + "\\"
    BinFolder = RootFolder + "bin" + "\\"
    _origin = 0
    mixcode = 0
    platform = ""  #luac.exe
    MixNameKeys = 'MNPQRSTUVY'
    _ld = {}
    nameCache = {}

    def __init__(self):
        pass

    def Run(self, argv=None):
        self.HandleArgv(argv)  
        print "="*20
        print 'platform', self.platform
        print 'mix',   self.mixcode
        print "FilesSignature", self.FilesSignatureEXE
        print "OutputFolder", self.OutputFolder
        print "SignedFolder", self.SignedFolder
        print "="*20

        self.Backup()
        self.Sign()

    def HandleArgv(self, argv):
        if argv:
            try:
                print "argv:", argv
                for i in range(1, len(argv), 2):
                    if argv[i] == "-p":
                        if argv[i+1] == "x64" or argv[i+1] == "x86":
                            self.platform = argv[i+1]
                    elif argv[i] == "-m":
                        if argv[i+1] == "0" or argv[i+1] == "1":
                            self.mixcode = int(argv[i+1])
                    else:
                        # run.bat argvs
                        self.FilesSignatureEXE = argv[1]
                        self.OutputFolder = argv[2]
                        self.SignedFolder = argv[3]
                        
                        break

            except Exception, e: 
                print '\nargs error:', e
                return

    def do_cmd(self, cmd, isLog = False):
        if isLog:
            print cmd
        if cmd:
            os.system(cmd)

    def Backup(self):
        if not os.path.exists(self.SignedFolder):
            os.makedirs(self.SignedFolder)
        if os.path.exists(self.OutputFolder):
            shutil.rmtree(self.SignedFolder)
            shutil.copytree(self.OutputFolder, self.SignedFolder)

    def Sign(self):
        os.chdir(self.BinFolder)
        self.do_cmd("{0} {1} {2}".format(self.FilesSignatureEXE, self.SignedFolder, self.SignedFolder), True)
        os.chdir(self.RootFolder)


    def isStop(self, filename):
        module = filename.replace(".lua", "")
        b1 = not filename in self.PassingScript
        if self.nameCache.has_key(module):
            b1 = not self.nameCache[module]+".lua" in self.PassingScript
        return b1

    def ReplaceAll(self):
        for parent,dirnames,filenames in os.walk(self.SignedFolder):
            for filename in filenames:
                if not ".lua.meta" in filename and ".lua" in filename and self.isStop(filename):
                    fullpath = os.path.join(parent, filename)
                    self.Replace(fullpath)

if __name__=="__main__":
    mix = MixTool()
    mix.Run(sys.argv)







