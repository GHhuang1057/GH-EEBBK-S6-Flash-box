::�޸�: n

::call log %logger% I ����
::                  W
::                  E
::                  F

@ECHO OFF
if "%framework_log%"=="n" goto :eof
SETLOCAL
for /f %%a in ('gettime.exe') do set logtext=%%a [%2] %1 %3
if not "%logfile%"=="" (if not "%logfile%"=="nul" echo.%logtext% >>%logfile% & ENDLOCAL & goto :eof)
ECHO.%logtext% & ENDLOCAL & goto :eof


:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
