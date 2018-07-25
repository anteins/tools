# coding=utf-8
import os
import sys
import shutil
import ConfigParser
from py_transform import reader
from py_transform.handle import autolua
from py_transform.utils import utils

Root = os.getcwd() + "/"
Root = Root.replace("\\", "/")
Cs2luaFolder = Root + "cs2lua/bin/"
Cs2luaScriptFolder = Root + "cs2lua/gen/"
Cs2luaOutputFolder = Root + "lua_script/"
UnsignedFolder = Cs2luaOutputFolder + "unsigned/"
SignedFolder = Cs2luaOutputFolder + "signed/"
LuaScriptFolder = Root + "priv/script/"
PythonFolder = Root + "src/"
TempFolder = Root + "tmp/"
config = ConfigParser.ConfigParser()
config.read("config.ini")
GameProjectFolder = config.get("path", "project_path").replace("\\", "/")
LuaDataFolder = config.get("path", "push_path").replace("\\", "/")
Cs2luaTarget = GameProjectFolder + "/hotfix_update/"
Cs2luaTargetFile = GameProjectFolder + "/Assembly-CSharp.csproj"
GameProjectTempFolder = GameProjectFolder + "/Temp/"
GameProjectToolsFolder = GameProjectFolder + "/Tools/"

def cs2lua_execute(parent, target):
	global Cs2luaFolder, Cs2luaScriptFolder
	if os.path.isfile(target):
		print "cs2lua_execute is file......"
		utils.do_cmd("{0}Cs2Lua.exe -ext lua -xlua -src {1}".format(Cs2luaFolder, target), True)
		_source = parent + "/lua"
		utils.copy_path_win(parent + "/lua", Cs2luaScriptFolder)
		shutil.rmtree(parent + "/lua/", True)
		shutil.rmtree(parent + "/log/", True)
	else:
		print "cs2lua_execute is path......"
		for parent, dirnames, filenames in os.walk(target):
			for filename in filenames:
				if ".cs" in filename and not ".meta" in filename:
					fullname = os.path.join(parent, filename)
					utils.do_cmd("{0}Cs2Lua.exe -ext lua -xlua -src {1}".format(Cs2luaFolder, fullname), True)
					utils.copy_path_win(parent + "/lua", Cs2luaScriptFolder)
					shutil.rmtree(parent + "/lua/", True)
					shutil.rmtree(parent + "/log/", True)

# cs2lua生成C#  -->  lua脚本
def cs2lua_handle():
	global Cs2luaFolder, GameProjectTempFolder, GameProjectFolder
	global Cs2luaScriptFolder

	if os.path.exists(Cs2luaScriptFolder):
		shutil.rmtree(Cs2luaScriptFolder, True)

	if not os.path.exists(GameProjectTempFolder):
		os.mkdir(GameProjectTempFolder)

	if not os.path.exists(GameProjectTempFolder + "bin/"):
		os.mkdir(GameProjectTempFolder + "bin/")

	if not os.path.exists(GameProjectTempFolder + "bin/Debug/"):
		os.mkdir(GameProjectTempFolder + "bin/Debug/")

	# utils.copyfile("{0}/Library/ScriptAssemblies/Assembly-CSharp-firstpass.dll".format(GameProjectFolder), "{0}/bin/Debug/Assembly-CSharp-firstpass.dll".format(GameProjectTempFolder))
	# 拷贝游戏工程dll
	lists = {
		"Assembly-CSharp.dll",
		"Assembly-CSharp-Editor.dll",
		"Assembly-CSharp-firstpass.dll",
		"Assembly-UnityScript-Editor.dll",
	}

	for i in lists:
		utils.copy_file_win(GameProjectFolder + "/Library/ScriptAssemblies/" + i, GameProjectTempFolder + "/bin/Debug/" + i)

	# 运行cs2lua.exe, 指定csproj文件
	cs2lua_execute(GameProjectFolder, Cs2luaTargetFile)
	# 运行cs2lua.exe, 指定逻辑代码目录(不要用，生成的代码不完整)
	# cs2lua_execute(GameProjectFolder, GameProjectFolder + "/Assets/Script/UnityComponent/Module/MainWorldUIModule/PartyWindowModule/Part/CommonParty")

	# 删除cs2lua框架的相关lua脚本,不需要用到
	utils.remove_files(Cs2luaScriptFolder, "cs2lua_*", True)

# 转译xlua格式脚本
def xlua_handle(args):
	global Cs2luaOutputFolder
	Cs2luaOutputFolder = Cs2luaOutputFolder.replace("/", "/")
	if os.path.exists(Cs2luaOutputFolder):
		_Cs2luaOutputFolder = Cs2luaOutputFolder.replace("/", "\\")
		utils.do_cmd("del /s/q {0}".format(_Cs2luaOutputFolder))

	if not os.path.exists(Cs2luaOutputFolder):
		os.mkdir(Cs2luaOutputFolder)
	if not os.path.exists(UnsignedFolder):
		os.mkdir(UnsignedFolder)

	lArgs = ["", Cs2luaScriptFolder, UnsignedFolder]
	xrer = reader.xreader(lArgs)

	target_files = []
	target_f = utils.get_args(args, "-s")
	if target_f:
		target_files.append(target_f)

	xrer.set_filter(
		# target files
		target_files,
		# target file_ext
		[".lua"], 
		# ignore file
		["manifest.lua", "tmp.lua", "Init.lua"],
		# ignore path
		["core"]
	)
	# 开始转译
	xrer.start(autolua.AutoLuaHandler())
	# 拷贝lua基础库
	lists = {
		"3rd/*",
		"core/*",
		"Hotfix.lua",
		"Init.lua",
	}

	for i in lists:
		if os.path.isfile("{0}{1}".format(LuaScriptFolder, i)):
			utils.copy_file_win("{0}{1}".format(LuaScriptFolder, i), "{0}{1}".format(UnsignedFolder, i))
		else:
			utils.copy_path_win("{0}{1}".format(LuaScriptFolder, i), "{0}{1}".format(UnsignedFolder, i))

def Start():
	while(True):
		print "usage:\t\tRun.bat [-cs2lua|-xlua|-sign|-push|-zip]"
		print "-cs2lua\t\ttransform c# script to lua script."
		print "-xlua\t\ttransform lua script to xlua style."
		print "-sign\t\tsign lua script"
		print "-push\t\tpush lua script to target folder(unity assets folder)"
		print "-zip\t\tget a script.zip"

		input_s = raw_input("please input:\n")
		input_list = input_s.split(" ")
		if len(input_list) > 0:
			input_val = input_list[0]
			input_args = input_list[1:]

			if input_val == "-cs2lua":
				cs2lua_handle()
				break
			elif input_val == "-xlua":
				xlua_handle(input_args)
				break
			elif input_val == "-sign":
				break
				# sign_handle()
			elif input_val == "-push":
				break
				# push_handle()
			elif input_val == "-zip":
				break
				# zip_handle()
		else:
			print "error input!"
			pass

if __name__ == '__main__':
    Start()

