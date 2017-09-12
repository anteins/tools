@echo off  

set PushFolder="C:/Users/xianbin/AppData/LocalLow/Magic Game/Novenia Fantasy/LuaTxt"
set GameFolder=E:\Project\android_platfrom\client
set Root=%cd%
set ScriptFolder=%Root%\script
set OutputFolder=%Root%\output
set UnsignedFolder=%OutputFolder%\unsigned
set SignedFolder=%OutputFolder%\signed
set BinFolder=%Root%\bin
set Cs2luaFolder=%BinFolder%\cs2lua
set CsprojFolder=%GameFolder%\Assembly-CSharp.csproj
set GameTempFolder=%GameFolder%\Temp
set TempFolder=%Root%\tmp

if "%1" == "-cs2lua" (
	echo "cs2lua"
	goto _CS2LUA
)

if "%1" == "-xlua" (
	echo "xlua"
	goto _XLUA
)

if "%1" == "-sign" (
	echo "sign"
	goto _SIGN
)

if "%1" == "-push" (
	echo "push"
	goto _PUSH
)

if "%1" == "-zip" (
	echo "zip"
	goto _ZIP
)

echo "usage: Run.bat [-cs2lua|-xlua|-sign|-push|-zip]"
echo "-cs2lua	transform c# script to lua script."
echo "-xlua 	format lua script to xluaStyle."
echo "-sign 	signed lua script"
echo "-push 	push lua script to target folder(unity assets folder)"
echo "-zip 		get a script.zip"
goto _End

:_CS2LUA
if not exist %GameTempFolder% (
	md %GameTempFolder%
)

if not exist %GameTempFolder%\bin (
	md %GameTempFolder%\bin
)

if not exist %GameTempFolder%\bin\Debug (
	md %GameTempFolder%\bin\Debug
	
)

echo A|xcopy %GameFolder%\Library\ScriptAssemblies\Assembly-CSharp-firstpass.dll %GameTempFolder%\bin\Debug\

pushd %Cs2luaFolder%
%Cs2luaFolder%\Cs2Lua.exe -ext lua -xlua %CsprojFolder%
popd
goto _End

del %ScriptFolder%\cs2lua*

:_XLUA
if exist %OutputFolder% (
	echo "ok."
	rd /s /q %OutputFolder%
)
md %OutputFolder%

%BinFolder%/cs2lua_format_xlua.py %ScriptFolder% %UnsignedFolder%
echo A|xcopy  /E %BinFolder%\core\* %UnsignedFolder%\core\
goto _End

:_SIGN
if exist %OutputFolder% (
	if exist %SignedFolder% (
		echo "ok."
	) else (
		md %SignedFolder%
	)
	python %BinFolder%/mix_and_sign.py %PushFolder% %UnsignedFolder% %SignedFolder%
)
goto _End

:_PUSH
if exist %OutputFolder% (
	rd /s /q %PushFolder%\
	if exist %SignedFolder% (
		echo A|xcopy  /E %SignedFolder%\* %PushFolder%\
	) else (
		echo A|xcopy  /E %UnsignedFolder%\* %PushFolder%\
	)
)
goto _End

:_ZIP
if exist %OutputFolder% (
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

:_End