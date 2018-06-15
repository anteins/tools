@echo off  

set Root=%cd%
set Cs2luaFolder=%Root%\cs2lua\bin
set Cs2luaScriptFolder=%Root%\cs2lua\gen
set Cs2luaOutputFolder=%Root%\lua_script
set UnsignedFolder=%Cs2luaOutputFolder%\unsigned
set SignedFolder=%Cs2luaOutputFolder%\signed
set LuaScriptFolder=%Root%\priv\script
set PythonFolder=%Root%\src
set TempFolder=%Root%\tmp

for /f "tokens=1,2* delims==" %%i in ( config.ini ) do (
	if "%%i" == "project_path" (
		set GameProjectFolder="%%j"
	)else if "%%i" == "push_path" (
		set LuaDataFolder="%%j"
	)
)

echo GameProjectFolder %GameProjectFolder%
echo LuaDataFolder %LuaDataFolder%
if %GameProjectFolder%=="" goto _End_PATH
if %LuaDataFolder%=="" goto _End_PATH

set CSprojFile=%GameProjectFolder%\Assembly-CSharp.csproj
set GameProjectTempFolder=%GameProjectFolder%\Temp
set GameProjectToolsFolder=%GameProjectFolder%\Tools
set GameProjectCs2LuaFolder=%GameProjectFolder%\lua

if "%1" == "-cs2lua" (
	goto _CS2LUA
)

if "%1" == "-xlua" (
	goto _XLUA
)

if "%1" == "-sign" (
	goto _SIGN
)

if "%1" == "-push" (
	goto _PUSH
)

if "%1" == "-zip" (
	goto _ZIP
)

echo ""
echo ""
echo "usage: 	Run.bat [-cs2lua|-xlua|-sign|-push|-zip]"
echo "-cs2lua	transform c# script to lua script."
echo "-xlua 	transform lua script to xlua style."
echo "-sign 	sign lua script"
echo "-push 	push lua script to target folder(unity assets folder)"
echo "-zip 		get a script.zip"

goto _End

:_CS2LUA
if not exist %GameProjectTempFolder% (
	echo md %GameProjectTempFolder%
	md %GameProjectTempFolder%
)

if not exist %GameProjectTempFolder%\bin (
	echo md %GameProjectTempFolder%\bin
	md %GameProjectTempFolder%\bin
)

if not exist %GameProjectTempFolder%\bin\Debug (
	echo md %GameProjectTempFolder%\bin\Debug
	md %GameProjectTempFolder%\bin\Debug
)

echo A|xcopy %GameProjectFolder%\Library\ScriptAssemblies\Assembly-CSharp-firstpass.dll %GameProjectTempFolder%\bin\Debug\
pushd %Cs2luaFolder%
%Cs2luaFolder%\Cs2Lua.exe -ext lua -xlua %CSprojFile%
popd

echo A|xcopy %GameProjectCs2LuaFolder% %Cs2luaScriptFolder%
echo Y|del %GameProjectCs2LuaFolder%\*
echo Y|del %Cs2luaScriptFolder%\cs2lua*
goto _End

:_XLUA
if exist %Cs2luaOutputFolder% (
	rd /s /q %Cs2luaOutputFolder%
)
md %Cs2luaOutputFolder%

python %PythonFolder%/main.py %Cs2luaScriptFolder% %UnsignedFolder%
echo A|xcopy  /E %LuaScriptFolder%\core\* %UnsignedFolder%\core\
goto _End


:_SIGN
if not exist %GameProjectToolsFolder% (
	goto _End
)
if not exist %Cs2luaOutputFolder% (
	md %Cs2luaOutputFolder%
)
if not exist %SignedFolder% (
	md %SignedFolder%
)
python %PythonFolder%/sign.py %GameProjectToolsFolder%\FilesSignature.exe %UnsignedFolder% %SignedFolder%
goto _End

:_PUSH
if not exist %GameProjectToolsFolder% (
	goto _End
)
if not exist %Cs2luaOutputFolder% (
	md %Cs2luaOutputFolder%
)
rem if not exist %SignedFolder% (
rem 	md %SignedFolder%
rem )
rem python %PythonFolder%/sign.py %GameProjectToolsFolder%\FilesSignature.exe %UnsignedFolder% %SignedFolder%

rem rd /s /q %LuaDataFolder%\
if exist %SignedFolder% (
	echo A|xcopy  /E %SignedFolder%\* %LuaDataFolder%\
) else (
	echo A|xcopy  /E %UnsignedFolder%\* %LuaDataFolder%\
)
goto _End

:_ZIP
if exist %Cs2luaOutputFolder% (
	if exist %TempFolder% (
		rd /s /q %TempFolder%
	)
	md %TempFolder%

	if exist %SignedFolder% (
		echo A|xcopy  /E %SignedFolder%\* %TempFolder%\
	) else (
		echo A|xcopy  /E %UnsignedFolder%\* %TempFolder%\
	)
	7z a scripts.zip %TempFolder%\*
	rd /s /q %TempFolder%
)

goto _End

:_End_PATH
echo "path error."

:_End
echo ""
echo ""
echo finish
set /p answer=
