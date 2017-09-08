#coding:utf-8
import os, sys, re
import shutil
import hashlib
import json
from random import Random

class MixTool:
    _toPath = r"C:\Users\xianbin\AppData\LocalLow\Magic Game\Novenia Fantasy\LuaTxt"
    _lstop = ["GlobalConfig.lua"]
    root_path = os.getcwd() + "\\"
    signedpath = "signed"
    signed_path = root_path + signedpath + "\\"
    out_path = root_path + "output\\"
    diff_path = root_path + "diff\\"
    bin_path = root_path + "bin\\"
    _origin = 0
    _mix = 0
    _platform = ""  #luac
    _chars = 'MNPQRSTUVY'
    _ld = {}
    _namecache = {}

    def __init__(self):
        pass

    def Run(self, argv=None):
        self.HandArgv(argv)    
        print 'platform:{0}, mix:{1}'.format(self._platform, self._mix)
        def _Mix():
            self.Backup()
            self.Mix()
            self.CopyToPath()
         
        def _Sign():
            self.Backup()
            self.Sign()
            self.CopyToPath()
         
        def _Diff():
            self.Diff()

        def _Replace():
            self.Backup()
            self.ReplaceAll()
         
        operator = {
            '1':_Mix,
            '2':_Sign,
            '3':_Diff
        }

        def f(t):
            operator.get(t)()

        if self._platform == "" and self._mix == 0:
            _Mix()
            return
            
        t = raw_input("1.Mix 2.Sign 3.Diff\n")
        if not t in ["1", "2", "3"]:
            print 'input error.'
            return
        f(t)

    def HandArgv(self, argv):
        if argv:
            try:
                print "argv:", argv
                for i in range(1, len(argv), 2):
                    if argv[i] == "-p":
                        if argv[i+1] == "x64" or argv[i+1] == "x86":
                            self._platform = argv[i+1]
                    elif argv[i] == "-m":
                        if argv[i+1] == "0" or argv[i+1] == "1":
                            self._mix = int(argv[i+1])

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
            lua = self.bin_path+self._platform+"\\origin\\lua"
            luac = self.bin_path+self._platform+"\\origin\\luac"
        else:
            lua = self.bin_path+self._platform+"\\lua"
            luac = self.bin_path+self._platform+"\\luac"
        self.do_cmd(lua +" -v")
        self.do_cmd(luac +" -v")
        return lua, luac

    def lua_compile(self):
        if self._platform != "":
            lua, luac = self.Api()
            for parent,dirnames,filenames in os.walk(self.signed_path):
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
                tt = self._chars[ord(tmp[i])-48]
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
        if self._mix == 1:
            _randomKey = {}
            for parent,dirnames,filenames in os.walk(self.signed_path):
                for filename in filenames:
                    if not ".lua.meta" in filename and ".lua" in filename:
                        fullpath = os.path.join(parent, filename)
                        module = filename.replace(".lua", "")
                        key = self.GetNameKey(fullpath)
                        #_randomKey[module] = self.RandomStr()
                        _randomKey[module] = key
                        self._ld[module] = key
                        self._namecache[key] = module
                        if not filename in "init.lua":
                            self.do_cmd("rename " + fullpath + " " + key + ".lua")

            # fw = open(self.signed_path+"tmp.lua", 'w')
            # f = open(self.signed_path + "init.lua", 'r')
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
            # self.do_cmd("del /f /s /q " + self.signed_path + "init.lua", True)
            # self.do_cmd("rename " + self.signed_path + "tmp.lua " + "init.lua", True)

    ## 递归创建            
    def CreatePath(self, path):
        (filepath, tempfilename) = os.path.split(path)
        lpath = filepath.replace(self.root_path, "").split('\\')
        curpath = self.root_path
        for p in lpath:
            curpath = curpath  + p + "\\"
            if os.path.exists(curpath):
                continue
            os.makedirs(curpath)

    def CheckVersion(self, module, mstr, fullname):
        if not os.path.isfile(self.bin_path + "version.json"):
            return
        ver = file(self.bin_path + "version.json")
        dData = json.load(ver)
        if dData.has_key(module) == True:
            print "{0} {1} ===> {2}".format(module, mstr, dData[module])
            #u2s = dData[module].encode('utf-8')
            if cmp(dData[module], mstr) != 0:
                print "diff!"
                target = fullname.replace(self.signedpath, "diff")
                self.CreatePath(target)
                shutil.copyfile(fullname, target)
        ver.close()

    def UpdateVersion(self):
        f = open(self.bin_path+"md5.json", 'w')
        f.write("{\n")
        for parent,dirnames,filenames in os.walk(self.signed_path):
            for filename in filenames:
                if not ".lua.meta" in filename and ".lua" in filename:
                    fullpath = os.path.join(parent, filename)
                    module = filename.replace(".lua", "")
                    md5 = self.GetBigFileMd5(fullpath)
                    #print "MD5: " , module,  md5
                    f.write("\t\"{0}\" : \"{1}\",\n".format(module, md5))
        f.write("}\n")
        f.close()       

    def CopyToPath(self):
        if os.path.exists(self._toPath):
            shutil.rmtree(self._toPath)
        
        shutil.copytree(self.root_path + self.signedpath, self._toPath)

    def Backup(self):
        if not os.path.exists(self.signed_path):
            os.makedirs(self.signed_path)
        if os.path.exists(self.out_path):
            shutil.rmtree(self.signed_path)
            shutil.copytree(self.out_path, self.signed_path)

    def Sign(self):
        os.chdir(self.bin_path)
        self.do_cmd("FilesSignature.exe {0} {1}".format(self.signed_path, self.signed_path), True)
        os.chdir(self.root_path)

    def Mix(self):
        os.chdir(self.signed_path)
        self.MixFileName()
        self.ReplaceAll()
        self.lua_compile()
        os.chdir(self.root_path)
        self.Sign()
        self.UpdateVersion()

    def Diff(self):
        if os.path.exists(self.diff_path):
            shutil.rmtree(self.diff_path)
        os.makedirs(self.diff_path)
        for parent,dirnames,filenames in os.walk(self.signed_path):
            for filename in filenames:
                if not ".lua.meta" in filename and ".lua" in filename:
                    fullpath = os.path.join(parent, filename)
                    module = filename.replace(".lua", "")
                    md5 = self.GetBigFileMd5(fullpath)
                    self.CheckVersion(module, md5, fullpath)

    def isStop(self, filename):
        module = filename.replace(".lua", "")
        b1 = not filename in self._lstop
        if self._namecache.has_key(module):
            b1 = not self._namecache[module]+".lua" in self._lstop
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







