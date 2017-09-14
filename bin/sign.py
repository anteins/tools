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
        def MixScript():
            self.Backup()
            self.Mix()
         
        def SignScript():
            self.Backup()
            self.Sign()
         
        def DumpDiffVersion():
            self.Diff()

        def _Replace():
            # self.Backup()
            self.ReplaceAll()
         
        operator = {
            '1':MixScript,
            '2':SignScript,
            '3':DumpDiffVersion
        }

        def f(oper):
            operator.get(oper)()

        if self.platform == "" and self.mixcode == 0:
            #defalut 
            MixScript()
            return
            
        oper = raw_input("1.Mix 2.Sign 3.Diff\n")
        if not t in ["1", "2", "3"]:
            print 'input error.'
            return
        f(oper)

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

    def Api(self):
        if self._origin == 1:
            lua = self.BinFolder+self.platform+"\\origin\\lua"
            luac = self.BinFolder+self.platform+"\\origin\\luac"
        else:
            lua = self.BinFolder+self.platform+"\\lua"
            luac = self.BinFolder+self.platform+"\\luac"
        self.do_cmd(lua +" -v")
        self.do_cmd(luac +" -v")
        return lua, luac

    def lua_compile(self):
        if self.platform != "":
            lua, luac = self.Api()
            for parent,dirnames,filenames in os.walk(self.SignedFolder):
                for filename in filenames:
                    fullpath = os.path.join(parent, filename)
                    self.do_cmd(luac+" -o "+ fullpath + " " + fullpath, True)


    #一个小文件的MD5值
    def GetNameKey(self, filename):
        (filepath, tempfilename) = os.path.split(filename)
        m1 = hashlib.md5()
        m1.update(tempfilename)
        mstr =  m1.hexdigest().upper()
        tmp = mstr[8:24]

        mstr1 = ""
        for i in range(0, len(tmp)):
            tt = tmp[i]
            if 48 <= ord(tmp[i]) <= 57:
                tt = self.MixNameKeys[ord(tmp[i])-48]
            mstr1 = mstr1 + tt
        print tempfilename, mstr1
        return mstr1

    #一个小文件的MD5值
    def GetFileMd5(self, filename):
        f = file(filename,'rb')
        m1 = hashlib.md5()
        m1.update(f.read(8096))
        mstr =  m1.hexdigest().upper()
        f.close()
        return mstr

    #大文件的MD5值
    def GetBigFileMd5(self, filename):
        if not os.path.isfile(filename):
            return
        myhash = hashlib.md5()
        f = file(filename,'rb')
        while True:
            b = f.read(8096)
            if not b :
                break
            myhash.update(b)
        f.close()
        return myhash.hexdigest().upper()

    #混淆字符
    def RandomStr(self, randomlength=8):
        str = ''
        chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789'
        length = len(chars) - 1
        random = Random()
        for i in range(randomlength):
            str+=chars[random.randint(0, length)]
        return str

    def Replace(self, filename):
        (filepath, tempfilename) = os.path.split(filename)
        f = open(filename, "r")
        f1 =open(filepath + "\\tmp.lua", 'w')
        for line in f:
            for key in self._ld:
                p = r'\b' + key + r'\b'
                ret = re.search(r'(\.)\b' + key + r'\b', line)
                
                if ret == None:
                    p = re.compile(p)
                    line = re.sub( p, self._ld[key], line)
            #print line
            f1.write(line)

        f.close()
        f1.close()
        self.do_cmd("del /f /s /q " + filename)
        self.do_cmd("rename " + filepath + "\\tmp.lua " + tempfilename)

    def MixFileName(self):
        if self.mixcode == 1:
            _randomKey = {}
            for parent,dirnames,filenames in os.walk(self.SignedFolder):
                for filename in filenames:
                    if not ".lua.meta" in filename and ".lua" in filename:
                        fullpath = os.path.join(parent, filename)
                        module = filename.replace(".lua", "")
                        key = self.GetNameKey(fullpath)
                        #_randomKey[module] = self.RandomStr()
                        _randomKey[module] = key
                        self._ld[module] = key
                        self.nameCache[key] = module
                        if not filename in "init.lua":
                            self.do_cmd("rename " + fullpath + " " + key + ".lua")

            # fw = open(self.SignedFolder+"tmp.lua", 'w')
            # f = open(self.SignedFolder + "init.lua", 'r')
            # for line in f:
            #     if "xlua.util" in line:
            #         fw.write(line)
            #         continue
            #     requireMod = re.findall(r'require \'(.*)\'', line)
            #     requireMod =  "".join(list(requireMod))
            #     if _randomKey.has_key(requireMod):
            #         line = line.replace(requireMod, _randomKey[requireMod])
            #         fw.write(line)
            # f.close()
            # fw.close()
            # self.do_cmd("del /f /s /q " + self.SignedFolder + "init.lua", True)
            # self.do_cmd("rename " + self.SignedFolder + "tmp.lua " + "init.lua", True)

    ## 递归创建         
    def CreatePath(self, path):
        (filepath, tempfilename) = os.path.split(path)
        lpath = filepath.replace(self.RootFolder, "").split('\\')
        curpath = self.RootFolder
        for p in lpath:
            curpath = curpath  + p + "\\"
            if os.path.exists(curpath):
                continue
            os.makedirs(curpath)

    def CheckVersion(self, module, mstr, fullname):
        if not os.path.isfile(self.BinFolder + "version.json"):
            return
        ver = file(self.BinFolder + "version.json")
        dData = json.load(ver)
        if dData.has_key(module) == True:
            print "{0} {1} ===> {2}".format(module, mstr, dData[module])
            #u2s = dData[module].encode('utf-8')
            if cmp(dData[module], mstr) != 0:
                print "diff!"
                target = fullname.replace("signed", "diff")
                self.CreatePath(target)
                shutil.copyfile(fullname, target)
        ver.close()

    def UpdateVersion(self):
        f = open(self.BinFolder+"md5.json", 'w')
        f.write("{\n")
        for parent,dirnames,filenames in os.walk(self.SignedFolder):
            for filename in filenames:
                if not ".lua.meta" in filename and ".lua" in filename:
                    fullpath = os.path.join(parent, filename)
                    module = filename.replace(".lua", "")
                    md5 = self.GetBigFileMd5(fullpath)
                    #print "MD5: " , module,  md5
                    f.write("\t\"{0}\" : \"{1}\",\n".format(module, md5))
        f.write("}\n")
        f.close()       

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

    def Mix(self):
        os.chdir(self.SignedFolder)
        self.MixFileName()
        self.ReplaceAll()
        self.lua_compile()
        os.chdir(self.RootFolder)
        self.Sign()
        self.UpdateVersion()

    def Diff(self):
        if os.path.exists(self.DiffScriptFolder):
            shutil.rmtree(self.DiffScriptFolder)
        os.makedirs(self.DiffScriptFolder)
        for parent,dirnames,filenames in os.walk(self.SignedFolder):
            for filename in filenames:
                if not ".lua.meta" in filename and ".lua" in filename:
                    fullpath = os.path.join(parent, filename)
                    module = filename.replace(".lua", "")
                    md5 = self.GetBigFileMd5(fullpath)
                    self.CheckVersion(module, md5, fullpath)

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







