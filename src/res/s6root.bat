@ECHO OFF
chcp 936>nul
cd /d %~dp0
set "currentDir=%~dp0"
if exist bin (cd bin) else (ECHO.�Ҳ���bin. ���鹤���Ƿ���ȫ��ѹ, �ű�λ���Ƿ���ȷ. & goto FATAL)

if not exist tool\Win\gap.exe ECHO.�Ҳ���gap.exe. ���鹤���Ƿ���ȫ��ѹ, �ű�λ���Ƿ���ȷ. & goto FATAL
tool\Win\gap.exe %0 || EXIT

if exist conf\fixed.bat (call conf\fixed) else (ECHO.�Ҳ���conf\fixed.bat. ���鹤���Ƿ���ȫ��ѹ, �ű�λ���Ƿ���ȷ. & goto FATAL)
if exist conf\user.bat call conf\user

::��������,����Ķ�
if "%framework_theme%"=="" set framework_theme=default
call framework theme %framework_theme%
COLOR %c_i%

TITLE BBK S6һ��ROOT QQ@huang1057 ������https://ghteam.pages.dev
mode con cols=71

::����׼���ͼ��. �������������й��߼���Լӿ������ٶ�, �����skiptoolchk����
call framework startpre
::call framework startpre skiptoolchk

TITLE S6һ��ROOT ����:QQ@huang1057///��ȫ��ѣ��Ͻ�����
CLS
goto MENU

set "currentDir=%~dp0"

:MENU
ECHO.===============================================================
ECHO.=======================BBK S6һ��ROOT===========================
ECHO.===============================================================
ECHO.���ߣ�huang1057----GH������
ECHO.GH�����ҹ�����https://ghteam.pages.dev
ECHO.===============================================================
ECHO.
ECHO.========================��ʼRoot================================
ECHO. 
call chkdev qcedl rechk 3
ECHO.��������
call write qcedlsendfh auto %currentDir%s6superroot\firehose.elf auto
ECHO.�޲�boot����
call read qcedl boot %currentDir%s6superroot\boot.img noprompt auto
ECHO.�����޲�
call imgkit magiskpatch %currentDir%s6superroot\boot.img %currentDir%s6superroot\boot_out.img %currentDir%s6superroot\magisk.zip noprompt
ECHO.�޲���ɣ�����ˢ��
call write qcedl boot %currentDir%s6superroot\boot_out.img auto
ECHO.ROOT�ɹ�������������
call reboot qcedl system
ECHO.��ǰ����������magisk��Ӧ�ý��к�������
ECHO.����������magisk
ECHO.
ECHO.===========================================================
ECHO.  ____  _   _  ____  ____  _____  ____  ____ 
ECHO. / ___|| | | |/ ___|/ ___|| ____|/ ___|/ ___|
ECHO. \___ \| | | | |  _| |  _ |  _|  \___ \\___ \ 
ECHO.  ___) | |_| | |_| | |_| | |___  ___) |___) |
ECHO. |____/ \___/ \____|\____||_____||____/|____/
ECHO.===========================================================
ECHO.------------------��ɣ�����-------------------------------
ECHO.=========================================================== 
echo.
echo ��������˳�...
pause >nul
exit /b 0