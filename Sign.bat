@echo off

set TARGET="C:\Users\xianbin\AppData\LocalLow\Magic Game\Novenia Fantasy\LuaTxt"
set ROOT=%cd%

python %ROOT%/bin/mix_and_sign.py

echo A|xcopy  /E %ROOT%\LuaTxt\* %TARGET%\
exit