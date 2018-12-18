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
if not %Workingdir%==" " (if not %Workingdir%==" " rem echo �˻�������SPB 17.0 
	echo Targetdir·����%Targetdir%
	echo Workingdir·����%Workingdir%
)
if  %Workingdir%==" " goto B
reg add "HKEY_CLASSES_ROOT\.brd" /v "17.0" /t REG_SZ /f /d "brd17.0"
reg add "HKEY_CLASSES_ROOT\brd17.0\Shell\Open\Command" /v "" /t REG_SZ /f /d "%Targetdir%\tools\bin\Capture.exe """%%1""""
if exist "%Workingdir%\pcbenv\allegro.ilinit" goto A
if not exist "%Workingdir%\pcbenv\allegro.ilinit" (
	echo %Workingdir%\pcbenv\allegro.ilinit�ļ������ڣ�����ִ�и���
	goto B
)

:A

echo "%Workingdir%\pcbenv\allegro.ilinit�ļ��Ѵ��ڣ�����ִ��׷��"
findstr /l "GTAllegro"  "%Workingdir%\pcbenv\allegro.ilinit"
IF ERRORLEVEL 1 goto StrNoExist170
IF ERRORLEVEL 0 goto StrExist170
:StrNoExist170
echo ָ���ַ��������ڣ�����׷��
goto B
:StrExist170
echo ָ���ַ����Ѵ��ڣ�����׷��

:B
set Targetdir=" "
set Workingdir=" "
for /f "tokens=3 delims= " %%i in ('reg query "HKEY_CURRENT_USER\Software\Cadence Design Systems\SPB 17.2" /v "Workingdir"') do ( 
	set "Workingdir=%%i"
	for /f "tokens=3 delims= " %%j in ('reg query "HKEY_CURRENT_USER\Software\Cadence Design Systems\SPB 17.2" /v "Targetdir"') do ( 
	set "Targetdir=%%j"
	)
)
if not %Workingdir%==" " (if not %Workingdir%==" " echo �˻�������SPB 17.2
	echo Targetdir·����%Targetdir%
	echo Workingdir·����%Workingdir%
)
if %Workingdir%==" " goto D
reg add "HKEY_CLASSES_ROOT\.brd" /v "17.2" /t REG_SZ /f /d "brd17.2"
reg add "HKEY_CLASSES_ROOT\brd17.2\Shell\Open\Command" /v "" /t REG_SZ /f /d "%Targetdir%\tools\bin\Capture.exe """%%1""""
if exist "%Workingdir%\pcbenv\allegro.ilinit" goto C
if not exist "%Workingdir%\pcbenv\allegro.ilinit" (
	echo "%Workingdir%\pcbenv\allegro.ilinit"�ļ������ڣ�����ִ�и���
	goto D
)

:C
echo "%Workingdir%\pcbenv\allegro.ilinit"�ļ��Ѵ��ڣ�����ִ��׷��
findstr /l "GTAllegro"  "%Workingdir%\pcbenv\allegro.ilinit"
IF ERRORLEVEL 1 goto StrNOExist172
IF ERRORLEVEL 0 goto StrExist172
:StrNoExist172
echo ָ���ַ��������ڣ�����׷��
echo. >>"%Workingdir%\pcbenv\allegro.ilinit"
goto D

:StrExist172
echo ָ���ַ����Ѵ��ڣ�����׷��
:D
if defined CDSROOT (echo ��������CDSROOT����)
if not defined CDSROOT (
echo ��������CDSROOT������ 
goto E
)
reg add "HKEY_CLASSES_ROOT\.brd" /v "" /t REG_SZ /f /d "brd16"
reg add "HKEY_CLASSES_ROOT\brd16\Shell\Open\Command" /v "" /t REG_SZ /f /d "%CDSROOT%\tools\Capture.exe """%%1""""
if not exist "%HOME%\pcbenv\allegro.ilinit" (
	echo "%HOME%\pcbenv\allegro.ilinit"�ļ������ڣ����ڸ���
	goto E
)
echo "%HOME%\pcbenv\allegro.ilinit"�ļ��Ѵ��ڣ�����ִ��׷��
findstr /l "GTAllegro"  "%HOME%\pcbenv\allegro.ilinit"
IF ERRORLEVEL 1 goto StrNoExist
IF ERRORLEVEL 0 goto StrExist
:StrNoExist
echo ָ���ַ��������ڣ��������
echo. >>"%HOME%\pcbenv\allegro.ilinit"
goto :E
:StrExist
echo �ַ����Ѵ��ڣ�����׷��

pause