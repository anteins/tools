@echo off  

set PushFolder="C:/Users/xianbin/AppData/LocalLow/Magic Game/Novenia Fantasy/LuaTxt"
set GameFolder=E:\Project\mywork1\client
set Root=%cd%
set ScriptFolder=%Root%\script
set OutputFolder=%Root%\output\unsigned
set SignedFolder=%Root%\output\signed
set BinFolder=%Root%\bin
set Cs2luaFolder=%bin%\cs2lua
set CsprojFolder=%GameFolder%\Assembly-CSharp.csproj
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
echo "-cs2lua	use cs2lua.exe transform c# script to lua script."
echo "-xlua format lua script to xlua script style."
echo "-sign xlua signed script"
echo "-push push script to target unity folder"
echo "-zip get a script.zip"
goto _End

:_CS2LUA
pushd %Cs2luaFolder%\bin
%Cs2luaFolder%\bin\Cs2Lua.exe -ext lua -xlua %CsprojFolder%
popd
goto _End

del %ScriptFolder%\cs2lua*

:_XLUA
if exist %OutputFolder% (
	echo "ok."
) else (
	md %OutputFolder%
)

del %OutputFolder%\*.lua
%BinFolder%/cs2lua_format_xlua.py %ScriptFolder% %OutputFolder%
goto _End

:_SIGN
if exist %SignedFolder% (
	echo "ok."
) else (
	md %SignedFolder%
)
python %BinFolder%/mix_and_sign.py %PushFolder% %OutputFolder% %SignedFolder%
goto _End

:_PUSH
rd /s /q %PushFolder%\
echo A|xcopy  /E %BinFolder%\core\* %PushFolder%\core\
echo A|xcopy  /E %SignedFolder%\* %PushFolder%\
goto _End

:_ZIP
if exist %TempFolder% (
	rd /s /q %TempFolder%
)
md %TempFolder%
echo A|xcopy  /E %BinFolder%\core\* %TempFolder%\core\
echo A|xcopy  /E %SignedFolder%\* %TempFolder%\
7z a scripts.zip %TempFolder%\*
rd /s /q %TempFolder%
goto _End

:_End