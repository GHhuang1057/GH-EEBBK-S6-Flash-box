::�޸�: n

::call random �����λ�� ָ���ַ���(��ѡ,Ĭ������Сд��ĸ������)

::abcdefghijklmnopqrstuvwxyz0123456789 (Ĭ��)
::ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
::abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
::abcdef0123456789 (Magisk�޲�)


@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
::goto %args1%


SETLOCAL EnableDelayedExpansion
set length=%args1%& set str=%args2%
call log %logger% I ���ձ���:length:%length%.str:%str%
if "%str%"=="" set str=abcdefghijklmnopqrstuvwxyz0123456789
for /f %%a in ('busybox.exe expr length "%str%"') do set str_length=%%a
for /l %%a in (1,1,%length%) do call :random-generate "%%a"
call log %logger% I ��%str%������%length%λ�����:%random_str%
ENDLOCAL & set random__str=%random_str%
goto :eof
:random-generate
if "%~1"=="" goto :eof
set /a var=%random%%%%str_length%
set random_str=%random_str%!str:~%var%,1!
goto :eof




:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

