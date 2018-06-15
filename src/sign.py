#coding:utf-8
import os, sys, re
import shutil
import hashlib
import json
from random import Random
from utils import utils

class MixTool:
    ban_scripts = [
        "GlobalConfig.lua"
    ]
    root_path = os.getcwd() + "\\"
    output_path = ""
    signed_path = ""
    files_signature_exe = ""
    diff_script_path = root_path + "diff" + "\\"
    bin_path = root_path + "bin" + "\\"
    origin = 0
    mix_code = 0
    platform = ""  #luac.exe
    mix_name_keys = 'MNPQRSTUVY'
    _ld = {}
    name_cache = {}

    def __init__(self):
        pass

    def Run(self, argv=None):
        self.HandleArgv(argv)  
        print "="*20
        print 'platform', self.platform
        print 'mix',   self.mix_code
        print "FilesSignature", self.files_signature_exe
        print "output_path", self.output_path
        print "signed_path", self.signed_path
        print "="*20

        self.Backup()
        self.Sign()

    def HandleArgv(self, argv):
        if argv:
            try:
                # print "argv:", argv
                
                for i in range(1, len(argv), 2):
                    if argv[i] == "-p":
                        if argv[i+1] == "x64" or argv[i+1] == "x86":
                            self.platform = argv[i+1]
                    elif argv[i] == "-m":
                        if argv[i+1] == "0" or argv[i+1] == "1":
                            self.mix_code = int(argv[i+1])
                    else:
                        # run.bat argvs
                        self.files_signature_exe = argv[1]
                        self.output_path = argv[2]
                        self.signed_path = argv[3]
                        
                        break

            except Exception, e: 
                print '\nargs error:', e
                return

    def Backup(self):
        if not os.path.exists(self.signed_path):
            os.makedirs(self.signed_path)
        if os.path.exists(self.output_path):
            shutil.rmtree(self.signed_path)
            shutil.copytree(self.output_path, self.signed_path)

    def Sign(self):
        os.chdir(self.bin_path)
        utils.do_cmd("{0} {1} {2}".format(self.files_signature_exe, self.signed_path, self.signed_path), True)
        os.chdir(self.root_path)


    def isStop(self, filename):
        module = filename.replace(".lua", "")
        b1 = not filename in self.ban_scripts
        if self.name_cache.has_key(module):
            b1 = not self.name_cache[module]+".lua" in self.ban_scripts
        return b1

    def ReplaceAll(self):
        for parent,dirnames,filenames in os.walk(self.signed_path):
            for filename in filenames:
                if not ".lua.meta" in filename and ".lua" in filename and self.isStop(filename):
                    fullpath = os.path.join(parent, filename)
                    self.Replace(fullpath)

if __name__=="__main__":
    mix = MixTool()
    mix.Run(sys.argv)







