

@echo off


IF EXIST C:\WORK\listato.txt del C:\WORK\listato.txt


set DJGPP=C:\amb_GAS\GAS\DJGPP.ENV
set PATH=C:\amb_GAS\GAS\BIN;%PATH%

copy %1 a51n9kHH48FgtT.s >nul
gcc -o %1 -Wa,-a >>C:\WORK\listato.txt -g %1
copy a51n9kHH48FgtT.s  %1 >nul
del a51n9kHH48FgtT.s >nul


pause









