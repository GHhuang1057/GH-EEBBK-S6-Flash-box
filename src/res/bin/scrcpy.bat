::�޸�: n

::call scrcpy ���� wait(��ѡ)
::            

@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9

SETLOCAL
set logger=scrcpy.bat
set title=%args1%
if "%title%"=="" set title=BFF-ADBͶ��
set wait=%args2%
call log %logger% I ���ձ���:title:%title%.wait:%wait%
goto START

:START
call log %logger% I ��ʼADBͶ��
taskkill /f /im scrcpy.exe 1>>%logfile% 2>&1
::taskkill /f /im adb.exe 1>>%logfile% 2>&1
if "%wait%"=="wait" (
    %framework_workspace%\tool\Win\scrcpy\scrcpy.exe --show-touches --stay-awake --no-audio --no-audio-playback --window-title=%title% 1>>%logfile% 2>&1 || ECHOC {%c_e%}����scrcpyʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����scrcpyʧ��&& pause>nul && ECHO.����... && goto START
    taskkill /f /im scrcpy.exe 1>>%logfile% 2>&1)
if not "%wait%"=="wait" (
    echo.%framework_workspace%\tool\Win\scrcpy\scrcpy.exe --show-touches --stay-awake --no-audio --no-audio-playback --window-title=%title% 1^>^>%framework_workspace%\log\scrcpy.log 2^>^&1 >%tmpdir%\cmd.bat
    echo.taskkill /f /im scrcpy.exe 1^>^>%framework_workspace%\log\scrcpy.log 2^>^&1 >>%tmpdir%\cmd.bat
    echo.Set ws = CreateObject^("Wscript.Shell"^)>%tmpdir%\hide.vbs
    echo.ws.run "cmd /c %tmpdir%\cmd.bat",vbhide>>%tmpdir%\hide.vbs
    start %tmpdir%\hide.vbs)
call log %logger% I �˳�scrcpy.bat
ENDLOCAL
goto :eof





:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
