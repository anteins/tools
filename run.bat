@echo off  

set Root=%cd%
set ScriptFolder=%Root%\script
set OutputFolder=%Root%\output
set UnsignedFolder=%OutputFolder%\unsigned
set SignedFolder=%OutputFolder%\signed
set BinFolder=%Root%\bin
set PythonFolder=%Root%\bin\python
set Cs2luaFolder=%BinFolder%\cs2lua
set TempFolder=%Root%\tmp

for /f "tokens=1,2* delims==" %%i in ( config.ini ) do (
	if "%%i" == "project_path" (
		set GameFolder="%%j"
	)else if "%%i" == "push_path" (
		set PushFolder="%%j"
	)
)

echo GameFolder %GameFolder%
echo PushFolder %PushFolder%
if %GameFolder%=="" goto _End_PATH
if %PushFolder%=="" goto _End_PATH

set Csproj=%GameFolder%\Assembly-CSharp.csproj
set GameTemp=%GameFolder%\Temp
set GameTools=%GameFolder%\Tools

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
if not exist %GameTemp% (
	echo md %GameTemp%
	md %GameTemp%
)

if not exist %GameTemp%\bin (
	echo md %GameTemp%\bin
	md %GameTemp%\bin
)

if not exist %GameTemp%\bin\Debug (
	echo md %GameTemp%\bin\Debug
	md %GameTemp%\bin\Debug
)

echo A|xcopy %GameFolder%\Library\ScriptAssemblies\Assembly-CSharp-firstpass.dll %GameTemp%\bin\Debug\
pushd %Cs2luaFolder%
%Cs2luaFolder%\Cs2Lua.exe -ext lua -xlua %Csproj%
popd
goto _End

del %ScriptFolder%\cs2lua*

:_XLUA
if exist %OutputFolder% (
	rd /s /q %OutputFolder%
)
md %OutputFolder%

%PythonFolder%/main.py %ScriptFolder% %UnsignedFolder%
echo A|xcopy  /E %BinFolder%\core\* %UnsignedFolder%\core\
goto _End


:_SIGN
if not exist %GameTools% (
	goto _End
)
if not exist %OutputFolder% (
	md %OutputFolder%
)
if not exist %SignedFolder% (
	md %SignedFolder%
)
python %PythonFolder%/sign.py %GameTools%\FilesSignature.exe %UnsignedFolder% %SignedFolder%
goto _End

:_PUSH
if not exist %GameTools% (
	goto _End
)
if not exist %OutputFolder% (
	md %OutputFolder%
)
if not exist %SignedFolder% (
	md %SignedFolder%
)
python %PythonFolder%/sign.py %GameTools%\FilesSignature.exe %UnsignedFolder% %SignedFolder%

rd /s /q %PushFolder%\
if exist %SignedFolder% (
	echo A|xcopy  /E %SignedFolder%\* %PushFolder%\
) else (
	echo A|xcopy  /E %UnsignedFolder%\* %PushFolder%\
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

:_End_PATH
echo "path error."

:_End
