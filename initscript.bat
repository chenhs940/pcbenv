@echo off
cd /d %~dp0
set Targetdir=" "
set Workingdir=" "

for /f "tokens=3 delims= " %%i in ('reg query "HKEY_CURRENT_USER\Software\Cadence Design Systems\SPB 17.0" /v "Workingdir"') do ( 
	set "Workingdir=%%i"
	for /f "tokens=3 delims= " %%i in ('reg query "HKEY_CURRENT_USER\Software\Cadence Design Systems\SPB 17.0" /v "Targetdir"') do ( 
		set "Targetdir=%%i"
	)
)
if not %Workingdir%==" " (if not %Workingdir%==" " rem echo 此机器含有SPB 17.0 
	echo Targetdir路径：%Targetdir%
	echo Workingdir路径：%Workingdir%
)
if  %Workingdir%==" " goto B
reg add "HKEY_CLASSES_ROOT\.brd" /v "17.0" /t REG_SZ /f /d "brd17.0"
reg add "HKEY_CLASSES_ROOT\brd17.0\Shell\Open\Command" /v "" /t REG_SZ /f /d "%Targetdir%\tools\bin\Capture.exe """%%1""""
if exist "%Workingdir%\pcbenv\allegro.ilinit" goto A
if not exist "%Workingdir%\pcbenv\allegro.ilinit" (
	echo %Workingdir%\pcbenv\allegro.ilinit文件不存在，正在执行复制
	goto B
)

:A

echo "%Workingdir%\pcbenv\allegro.ilinit文件已存在，正在执行追加"
findstr /l "GTAllegro"  "%Workingdir%\pcbenv\allegro.ilinit"
IF ERRORLEVEL 1 goto StrNoExist170
IF ERRORLEVEL 0 goto StrExist170
:StrNoExist170
echo 指定字符串不存在，正在追加
goto B
:StrExist170
echo 指定字符串已存在，结束追加

:B
set Targetdir=" "
set Workingdir=" "
for /f "tokens=3 delims= " %%i in ('reg query "HKEY_CURRENT_USER\Software\Cadence Design Systems\SPB 17.2" /v "Workingdir"') do ( 
	set "Workingdir=%%i"
	for /f "tokens=3 delims= " %%j in ('reg query "HKEY_CURRENT_USER\Software\Cadence Design Systems\SPB 17.2" /v "Targetdir"') do ( 
	set "Targetdir=%%j"
	)
)
if not %Workingdir%==" " (if not %Workingdir%==" " echo 此机器含有SPB 17.2
	echo Targetdir路径：%Targetdir%
	echo Workingdir路径：%Workingdir%
)
if %Workingdir%==" " goto D
reg add "HKEY_CLASSES_ROOT\.brd" /v "17.2" /t REG_SZ /f /d "brd17.2"
reg add "HKEY_CLASSES_ROOT\brd17.2\Shell\Open\Command" /v "" /t REG_SZ /f /d "%Targetdir%\tools\bin\Capture.exe """%%1""""
if exist "%Workingdir%\pcbenv\allegro.ilinit" goto C
if not exist "%Workingdir%\pcbenv\allegro.ilinit" (
	echo "%Workingdir%\pcbenv\allegro.ilinit"文件不存在，正在执行复制
	goto D
)

:C
echo "%Workingdir%\pcbenv\allegro.ilinit"文件已存在，正在执行追加
findstr /l "GTAllegro"  "%Workingdir%\pcbenv\allegro.ilinit"
IF ERRORLEVEL 1 goto StrNOExist172
IF ERRORLEVEL 0 goto StrExist172
:StrNoExist172
echo 指定字符串不存在，正在追加
echo. >>"%Workingdir%\pcbenv\allegro.ilinit"
goto D

:StrExist172
echo 指定字符串已存在，结束追加
:D
if defined CDSROOT (echo 环境变量CDSROOT存在)
if not defined CDSROOT (
echo 环境变量CDSROOT不存在 
goto E
)
reg add "HKEY_CLASSES_ROOT\.brd" /v "" /t REG_SZ /f /d "brd16"
reg add "HKEY_CLASSES_ROOT\brd16\Shell\Open\Command" /v "" /t REG_SZ /f /d "%CDSROOT%\tools\Capture.exe """%%1""""
if not exist "%HOME%\pcbenv\allegro.ilinit" (
	echo "%HOME%\pcbenv\allegro.ilinit"文件不存在，正在复制
	goto E
)
echo "%HOME%\pcbenv\allegro.ilinit"文件已存在，正在执行追加
findstr /l "GTAllegro"  "%HOME%\pcbenv\allegro.ilinit"
IF ERRORLEVEL 1 goto StrNoExist
IF ERRORLEVEL 0 goto StrExist
:StrNoExist
echo 指定字符串不存在，正在添加
echo. >>"%HOME%\pcbenv\allegro.ilinit"
goto :E
:StrExist
echo 字符串已存在，结束追加

pause