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

TITLE BBK S6һ��ˢ��TWRP QQ@huang1057 ������https://ghteam.pages.dev
mode con cols=71

::����׼���ͼ��. �������������й��߼���Լӿ������ٶ�, �����skiptoolchk����
call framework startpre
::call framework startpre skiptoolchk

TITLE S6һ��ˢ��TWRP ����:QQ@huang1057///��ȫ��ѣ��Ͻ�����
CLS
goto MENU

set "currentDir=%~dp0"
:MENU
CLS
ECHO.
ECHO.=========================================================
ECHO.=======================BBK S6һ��ˢ��TWRP================
ECHO.=========================================================
ECHO.���ߣ�huang1057----GH������
ECHO.=======================������https��//ghteam.pages.dev====
ECHO.=========================================================
ECHO.
ECHO.������ѣ��Ͻ�����������
ECHO.TWRP����EEBBK BOOM
ECHO.
ECHO.==========================================================
ECHO.
ECHO.��ʼˢдTWRP
ECHO.����豸���ӣ�9008
ECHO.�뽫�豸����9008ģʽ
ECHO.
call chkdev qcedl rechk 2
ECHO.��������
call write qcedlsendfh auto %currentDir%s6superroot\firehose.elf auto
ECHO.����ˢдTWRP
call write qcedl recovery %currentDir%s6superroot\recovery.img auto
ECHO.ˢд��ɣ�����
call reboot qcedl recovery
ECHO.
ECHO.=============================================================
ECHO.--------------------��ɣ�����--------------------------------
ECHO.=============================================================