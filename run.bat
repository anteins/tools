@echo off

set TARGET="C:/Users/xianbin/AppData/LocalLow/Magic Game/Novenia Fantasy/LuaTxt"
set GAME_PATH=E:\Project\mywork1\client

set ROOT=%cd%
set SCRIPT=%ROOT%\script
set OUTPUT_SCRIPT=%ROOT%\output
set SIGNED_SCRIPT=%ROOT%\signed
set BIN=%ROOT%\bin
set CS2LUA=%bin%\cs2lua
set CSPROJ=%GAME_PATH%\Assembly-CSharp.csproj

if "%1" == "-cs2lua" (
	echo "cs2lua"
	goto _CS2LUA
)

if "%1" == "-xlua" (
	echo "xlua"
	goto _XLUA
)

if "%1" == "-copy" (
	echo "copy"
	goto _COPY
)

if "%1" == "-sign" (
	echo "sign"
	goto _SIGN
)

echo "usage: Run.bat [-gen|-xlua|-copy|-sign]"
goto _End

:_CS2LUA
pushd %CS2LUA%\bin
%CS2LUA%\bin\Cs2Lua.exe -ext lua -xlua %CSPROJ%
popd
goto _End

pushd %SCRIPT%
del cs2lua*
popd

:_XLUA
pushd %OUTPUT_SCRIPT%\game
del *.lua
popd
%BIN%/cs2lua_format_xlua.py %SCRIPT% %OUTPUT_SCRIPT%\game\
goto _End

:_COPY
::python %BIN%/Mix.pyc %*
python %BIN%/Mix.py
echo A|xcopy  /E %SIGNED_SCRIPT%\* %TARGET%\

:_SIGN
python %BIN%/mix_and_sign.py
echo A|xcopy  /E %ROOT%\LuaTxt\* %TARGET%\

:_End