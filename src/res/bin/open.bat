::�޸�: n

::call open [common folder txt pic] Ŀ��·��

@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
SETLOCAL
set logger=open.bat
if "%args1%"=="common" start %args2%
if "%args1%"=="folder" (
    if not exist %args2% ECHOC {%c_e%}�Ҳ���%args2%, �޷���. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �Ҳ���%args2%& pause>nul & ECHO.����... & goto DONE
    start "" "%args2%")
if "%args1%"=="txt" (
    if not exist %args2% ECHOC {%c_e%}�Ҳ���%args2%, �޷���. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �Ҳ���%args2%& pause>nul & ECHO.����... & goto DONE
    start tool\Win\Notepad3\Notepad3.exe %args2%)
if "%args1%"=="pic" (
    if not exist %args2% ECHOC {%c_e%}�Ҳ���%args2%, �޷���. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �Ҳ���%args2%& pause>nul & ECHO.����... & goto DONE
    for %%i in ("%args2%") do start tool\Win\Vieas\Vieas.exe /v %%~dpnxi)
goto DONE
:DONE
ENDLOCAL
goto :eof


:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
