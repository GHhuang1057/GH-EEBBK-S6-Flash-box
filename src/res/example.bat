::����һ�����ű�ʾ��,�밴�մ�ʾ���е�����������ɽű�������.

::����׼��,����Ķ�
@ECHO OFF
chcp 936>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.�Ҳ���bin. ���鹤���Ƿ���ȫ��ѹ, �ű�λ���Ƿ���ȷ. & goto FATAL)

::���ͻ�ȡ����ԱȨ��,�����漰��Ҫ����ԱȨ�޵ĳ������ȥ��
if not exist tool\Win\gap.exe ECHO.�Ҳ���gap.exe. ���鹤���Ƿ���ȫ��ѹ, �ű�λ���Ƿ���ȷ. & goto FATAL
tool\Win\gap.exe %0 || EXIT

::��������,������Զ���������ļ�Ҳ���Լ�������
if exist conf\fixed.bat (call conf\fixed) else (ECHO.�Ҳ���conf\fixed.bat. ���鹤���Ƿ���ȫ��ѹ, �ű�λ���Ƿ���ȷ. & goto FATAL)
if exist conf\user.bat call conf\user

::��������,����Ķ�
if "%framework_theme%"=="" set framework_theme=default
call framework theme %framework_theme%
COLOR %c_i%

::�Զ��崰�ڴ�С,���԰�����Ҫ�Ķ�
TITLE ����������...
mode con cols=71

::����׼���ͼ��. �������������й��߼���Լӿ������ٶ�, �����skiptoolchk����
call framework startpre
::call framework startpre skiptoolchk

::�������.���������д��Ľű�
TITLE ����ʾ�� ��ܰ汾:%framework_ver% ����:�ᰲ@ĳ��
CLS
goto MENU



:MENU
call log example.bat-menu I �������˵�
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.���˵�
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.�˽ű�������ʾ�Ͳ��Ը�ģ�鹦��
ECHO.
ECHO.1.chkdev.bat ����豸����
ECHO.2.dl.bat ����ģ��
ECHO.3.imgkit.bat ����������
ECHO.4.info.bat ��ȡ�豸��Ϣ
ECHO.5.read.bat ����
ECHO.6.reboot.bat ����
ECHO.7.write.bat д��
ECHO.8.clean.bat ���
ECHO.9.scrcpy.bat Ͷ��
ECHO.10.��������
ECHO.11.��λ����
ECHO.12.������־
ECHO.13.partable.bat ������
ECHO.14.ʵʱ��־���
ECHO.15.sel.bat ѡ���ļ�(��)
ECHO.16.random.bat ���������
ECHO.17.input.bat ѡ��
ECHO.18.calc.bat ����ģ��
ECHO.A.����BFF
ECHO.
call input choice [1][2][3][4][5][6][7][8][9][10][11][12][13][14][15][16][17][18]#[A]
if "%choice%"=="1" goto CHKDEV
if "%choice%"=="2" goto DL
if "%choice%"=="3" goto IMGKIT
if "%choice%"=="4" goto INFO
if "%choice%"=="5" goto READ
if "%choice%"=="6" goto REBOOT
if "%choice%"=="7" goto WRITE
if "%choice%"=="8" goto CLEAN
if "%choice%"=="9" goto SCRCPY
if "%choice%"=="10" goto THEME
if "%choice%"=="11" goto SLOT
if "%choice%"=="12" goto LOG
if "%choice%"=="13" goto PARTABLE
if "%choice%"=="14" goto LOGVIEWER
if "%choice%"=="15" goto SEL
if "%choice%"=="16" goto RANDOM
if "%choice%"=="17" goto INPUT
if "%choice%"=="18" goto CALC
if "%choice%"=="A" call open common https://gitee.com/mouzei/bff & goto MENU




:CALC
SETLOCAL
set logger=example.bat-calc
call log %logger% I ���빦��CALC
:CALC-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.calc.bat ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.2147483647+2147483647 ������С�� ��ȷֵ:4294967294
call calc p calc_result nodec 2147483647 2147483647
ECHO.[%calc_result%]
ECHO.
ECHO.2147483648-1 ����3λС�� ��ȷֵ:2147483647.000
call calc s calc_result dec-3 2147483648 1
ECHO.[%calc_result%]
ECHO.
ECHO.1073741824*10 ������С����С����Ϊ0��1 ��ȷֵ:10737418240
call calc m calc_result nodec-intp1 1073741824 10
ECHO.[%calc_result%]
ECHO.
ECHO.5/3 ������С����С����Ϊ0��1 ��ȷֵ:2
call calc d calc_result nodec-intp1 5 3
ECHO.[%calc_result%]
ECHO.
ECHO.5/3 ����2λС�� ��ȷֵ:1.66
call calc d calc_result dec-2 5 3
ECHO.[%calc_result%]
ECHO.
ECHO.3133461bת���� ������С512 ������С����С����Ϊ0��1 ��ȷֵ:6121
call calc b2sec calc_result nodec-intp1 3133461 512
ECHO.[%calc_result%]
ECHO.
ECHO.6����תb ������С4096 ������С�� ��ȷֵ:24576
call calc sec2b calc_result nodec 6 4096
ECHO.[%calc_result%]
ECHO.
ECHO.2047bתkb ������С�� ��ȷֵ:1
call calc b2kb calc_result nodec 2047
ECHO.[%calc_result%]
ECHO.
ECHO.6kbתb ������С�� ��ȷֵ:6144
call calc kb2b calc_result nodec 6
ECHO.[%calc_result%]
ECHO.
ECHO.6bתmb ������С����С����Ϊ0��1 ��ȷֵ:1
call calc b2mb calc_result nodec-intp1 6
ECHO.[%calc_result%]
ECHO.
ECHO.1bתmb ������С����С����Ϊ0��1 ��ȷֵ:1
call calc b2mb calc_result nodec-intp1 1
ECHO.[%calc_result%]
ECHO.
ECHO.1mbתb ������С����С����Ϊ0��1 ��ȷֵ:1048576
call calc mb2b calc_result nodec-intp1 1
ECHO.[%calc_result%]
ECHO.
ECHO.1bתgb ������С����С����Ϊ0��1 ��ȷֵ:1
call calc b2gb calc_result nodec-intp1 1
ECHO.[%calc_result%]
ECHO.
ECHO.1gbתb ������С����С����Ϊ0��1 ��ȷֵ:1073741824
call calc gb2b calc_result nodec-intp1 1
ECHO.[%calc_result%]
ECHO.
ECHO.�Ƚ�00011258999068426240��00000021258999068426240 ��ȷֵ:less
call calc numcomp 00011258999068426240 00000021258999068426240
ECHO.[%calc__numcomp__result%]
ECHO.
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���CALC& pause>nul & goto MENU


:INPUT
SETLOCAL
set logger=example.bat-input
call log %logger% I ���빦��INPUT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.input.bat ����
ECHO.=--------------------------------------------------------------------=
:INPUT-1
ECHO.
call input choice
ECHO.[%choice%]
goto INPUT-1


:RANDOM
SETLOCAL
set logger=example.bat-random
call log %logger% I ���빦��RANDOM
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.random.bat ���������
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.��Ĭ���ַ���(abcdefghijklmnopqrstuvwxyz0123456789)������5λ�����.
ECHO.
:RANDOM-1
call random 2 3456
ECHO.���: [%random__str%]
ECHOC {%c_h%}���������������...{%c_i%}{\n}& pause>nul & goto RANDOM-1


:SEL
SETLOCAL
set logger=example.bat-sel
call log %logger% I ���빦��SEL
:SEL-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.sel.bat ѡ���ļ�(��)
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.��ѡ�ļ�
ECHO.2.��ѡ�ļ�
ECHO.3.��ѡ�ļ���
ECHO.4.��ѡ�ļ���
ECHO.
call input choice [1][2][3][4]
if "%choice%"=="1" call sel file s %framework_workspace% [bat]
if "%choice%"=="2" call sel file m %framework_workspace% [bat]
if "%choice%"=="3" call sel folder s %framework_workspace%
if "%choice%"=="4" call sel folder m %framework_workspace%
ECHO.
if "%choice%"=="1" ECHO.����·��[%sel__file_path%]& ECHO.�����ļ���[%sel__file_fullname%]& ECHO.�ļ���(��������չ��)[%sel__file_name%]& ECHO.��չ��[%sel__file_ext%]& ECHO.�����ļ�������·��[%sel__file_folder%]
if "%choice%"=="2" ECHO.�����ļ�����·��(��/�ָ�)[%sel__files%]& ECHO.�����ļ�������·��[%sel__files_folder%]& ECHO.�ļ���Ŀ[%sel__files_num%]
if "%choice%"=="3" ECHO.����·��[%sel__folder_path%]& ECHO.�ļ�����[%sel__folder_name%]
if "%choice%"=="4" ECHO.�����ļ�������·��(��/�ָ�)[%sel__folders%]& ECHO.�ļ�����Ŀ[%sel__folders_num%]
ECHO. & ECHOC {%c_s%}���. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & goto SEL


:LOGVIEWER
SETLOCAL
set logger=example.bat-logviewer
call log %logger% I ���빦��LOGVIEWER
:LOGVIEWER-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.framework.bat ʵʱ��־���
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.��ǰ��־�ļ�: %logfile%
ECHO.
ECHO.1.�������
ECHO.2.�رռ��
ECHO.A.�������˵�
ECHO.
call input choice [1][2][A]
if "%choice%"=="1" start framework logviewer start %logfile%
if "%choice%"=="2" call framework logviewer end
if "%choice%"=="A" ENDLOCAL & call log %logger% I ��ɹ���LOGVIEWER& goto MENU
goto LOGVIEWER-1


:CHKDEV
SETLOCAL
set logger=example.bat-chkdev
call log %logger% I ���빦��CHKDEV
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.chkdev.bat ����豸����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.����豸����(ȫ��)
ECHO.2.����豸����(ϵͳ)
ECHO.3.����豸����(Recovery)
ECHO.4.����豸����(sideload)
ECHO.5.����豸����(Fastboot)
ECHO.6.����豸����(9008ģʽ)
ECHO.7.����豸����(��ͨ��������ģʽ)
ECHO.8.����豸����(sprdboot)
ECHO.9.����豸����(mtkbrom)
ECHO.10.����豸����(mtkpreloader)
ECHO.11.����豸����(ȫ��) ����
ECHO.12.����豸����(ϵͳ) 2��󸴲�
call input choice [1][2][3][4][5][6][7][8][9][10][11][12]
if "%choice%"=="1" call chkdev all
if "%choice%"=="2" call chkdev system
if "%choice%"=="3" call chkdev recovery
if "%choice%"=="4" call chkdev sideload
if "%choice%"=="5" call chkdev fastboot
if "%choice%"=="6" call chkdev qcedl
if "%choice%"=="7" call chkdev qcdiag
if "%choice%"=="8" call chkdev sprdboot
if "%choice%"=="9" call chkdev mtkbrom
if "%choice%"=="10" call chkdev mtkpreloader
if "%choice%"=="11" call chkdev all rechk 2
if "%choice%"=="12" call chkdev system rechk 2
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���CHKDEV& pause>nul & goto MENU


:DL
SETLOCAL
set logger=example.bat-dl
call log %logger% I ���빦��DL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.dl.bat ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.����ֱ��
ECHO.2.���������������
call input choice [1][2]
goto DL-C%choice%
:DL-C1
ECHOC {%c_h%}������ֱ��: {%c_i%}& set /p choice=
ECHOC {%c_h%}��ѡ�񱣴��ļ���...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
call dl direct %choice% %sel__folder_path%\dl.test once notice
goto DL-DONE
:DL-C2
ECHOC {%c_h%}�����������������: {%c_i%}& set /p choice=
ECHOC {%c_h%}��ѡ�񱣴��ļ���...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
call dl lzlink %choice% %sel__folder_path%\dl.test once notice
goto DL-DONE
:DL-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���DL& pause>nul & goto MENU


:IMGKIT
SETLOCAL
set logger=example.bat-imgkit
call log %logger% I ���빦��IMGKIT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.imgkit.bat ����������ģ��
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.����޲�boot
ECHO.2.Ϊbootע��recovery
call input choice [1][2]
goto IMGKIT-C%choice%
:IMGKIT-C1
ECHOC {%c_h%}��ѡ��boot�ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [img]
set bootpath=%sel__file_path%
ECHOC {%c_h%}��ѡ��Magisk(������zip��apk)...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [zip][apk]
set zippath=%sel__file_path%
ECHOC {%c_h%}��ѡ����boot����λ��...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
for /f %%a in ('gettime.exe') do set var=%%a
call imgkit magiskpatch %bootpath% %sel__folder_path%\boot_magiskpatched_%var%.img %zippath%
move /Y %sel__folder_path%\boot_magiskpatched_%var%.img %sel__folder_path%\boot_magiskpatched_%imgkit__magiskpatch__vername%_%imgkit__magiskpatch__ver%_%var%.img 1>>%logfile% 2>&1
goto IMGKIT-DONE
:IMGKIT-C2
ECHOC {%c_h%}��ѡ��boot.img...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [img]
set bootpath=%sel__file_path%
ECHOC {%c_h%}��ѡ��recovery(������img��ramdisk.cpio)...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [img][cpio]
set recpath=%sel__file_path%
ECHOC {%c_h%}��ѡ����boot����λ��...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
set outputpath=%sel__folder_path%\boot_new.img
call imgkit recinst %bootpath% %outputpath% %recpath%
goto IMGKIT-DONE
:IMGKIT-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���IMGKIT& pause>nul & goto MENU


:INFO
SETLOCAL
set logger=example.bat-info
call log %logger% I ���빦��INFO
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.info.bat ��ȡ�豸��Ϣ
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.��ȡ������Ϣ
ECHO.2.ADB��Fastboot����Ϣ
ECHO.3.��ȡ������Ϣ(��/dev/block/sda��/dev/block/mmcblk0)
ECHO.4.��ͨ9008����Ϣ
call input choice [1][2][3][4]
goto INFO-C%choice%
:INFO-C1
ECHOC {%c_h%}������: {%c_i%}& set /p parname=
if "%parname%"=="" goto INFO-C1
ECHOC {%c_h%}�뽫�豸����ϵͳ��Recoveryģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" ECHOC {%c_e%}ģʽ����, �����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto INFO-C1)
call info par %parname% back
if "%info__par__exist%"=="y" (ECHO.%info__par__path%) else (ECHO.����������)
goto INFO-DONE
:INFO-C2
ECHOC {%c_h%}�뽫�豸����ϵͳ,Recovery��Fastbootģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" (if not "%chkdev__mode%"=="fastboot" ECHOC {%c_e%}ģʽ����, �����ϵͳ, Recovery��Fastbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto INFO-C2))
if "%chkdev__mode%"=="system" call info adb
if "%chkdev__mode%"=="recovery" call info adb
if "%chkdev__mode%"=="fastboot" call info fastboot
ECHO.ADB��Ϣ: [�豸����:%info__adb__product%] [��׿�汾:%info__adb__androidver%] [SDK�汾:%info__adb__sdkver%]
ECHO.Fastboot��Ϣ: [�豸����:%info__fastboot__product%] [����״̬:%info__fastboot__unlocked%]
goto INFO-DONE
:INFO-C3
ECHOC {%c_h%}����·��: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto INFO-C3
ECHOC {%c_h%}�뽫�豸����ϵͳ��Recoveryģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" ECHOC {%c_e%}ģʽ����, �����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto INFO-C3)
call info disk %diskpath%
ECHO.��������: [%info__disk__type%]& ECHO.������С: [%info__disk__secsize%]& ECHO.��������: [%info__disk__maxparnum%]
goto INFO-DONE
:INFO-C4
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call input choice [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [elf][melf][mbn]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.���ڶ�ȡ��Ϣ... & call info qcedl %chkdev__port__qcedl% %fh%
ECHO.�洢����: [%info__qcedl__memtype%]
ECHO.lun����: [%info__qcedl__lunnum%]
ECHO.������С: [%info__qcedl__secsize%]
goto INFO-DONE
:INFO-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���INFO& pause>nul & goto MENU


:READ
SETLOCAL
set logger=example.bat-read
call log %logger% I ���빦��READ
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.read.bat ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.ϵͳ��Recovery������������
ECHO.2.��ͨ9008������������ (xmlģʽ)
ECHO.3.��ͨ9008������������ (������ģʽ)
ECHO.4.��ͨ��������ģʽ����QCN
call input choice [1][2][3][4]
goto READ-C%choice%
:READ-C1
ECHOC {%c_h%}������Ҫ�����ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto READ-C1
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��img�ļ�����λ��...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
ECHOC {%c_h%}�뽫�豸����ϵͳ��Recoveryģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" ECHOC {%c_e%}ģʽ����, �����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__mode%.Ӧ����ϵͳ��Recoveryģʽ& pause>nul & ECHO.����... & goto READ-C1)
ECHO.���ڽ�%parname%������%sel__folder_path%(%chkdev__mode%)...& call read %chkdev__mode% %parname% %sel__folder_path%\%parname%.img
goto READ-DONE
:READ-C2
ECHOC {%c_h%}��ѡ��img�ļ�����Ŀ¼...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
set searchpath=%sel__folder_path%
ECHOC {%c_h%}��ѡ��rawprogram.xml�ļ�...{%c_i%}{\n}& call sel file m %framework_workspace% [xml]
set xml=%sel__files%
ECHO.�Ƿ�ѡ��patch.xml�ļ�? & ECHO.1.ѡ��   2.����& call input choice [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��patch.xml�ļ�...{%c_i%}{\n}& call sel file m %framework_workspace% [xml]
if "%choice%"=="1" set xml=%xml%/%sel__files%
set fh=
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call input choice [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [elf][melf][mbn]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev qcedl rechk 1
call read qcedlxml %chkdev__port__qcedl% auto %searchpath% %xml% %fh%
goto READ-DONE
:READ-C3
ECHOC {%c_h%}������Ҫ�����ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto READ-C3
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��img�ļ�����Ŀ¼...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call input choice [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [elf][melf][mbn]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev qcedl rechk 1
start framework logviewer start %logfile%
call read qcedl %parname% %sel__folder_path%\%parname%.img notice auto %fh%
call framework logviewer end
goto READ-DONE
:READ-C4
ECHOC {%c_h%}��ѡ��QCN�ļ�����Ŀ¼...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
ECHOC {%c_h%}�뽫�豸����, ����USB���Բ�ͬ��RootȨ������...{%c_i%}{\n}& call chkdev system rechk 1
ECHO.������ͨ��������ģʽ... & call reboot system qcdiag rechk 1
call read qcdiag %chkdev__port__qcdiag% %sel__folder_path%\qcnbak.qcn
goto READ-DONE
:READ-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���READ& pause>nul & goto MENU


:REBOOT
SETLOCAL
set logger=example.bat-reboot
call log %logger% I ���빦��REBOOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.reboot.bat ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.��ѡ��Ҫ�����ģʽ:
ECHO.1.system
ECHO.2.recovery
ECHO.3.sideload
ECHO.4.fastboot
ECHO.5.fastbootd
ECHO.6.qcedl
ECHO.7.qcdiag
call input choice [1][2][3][4][5][6][7]
if "%choice%"=="1" set target=system
if "%choice%"=="2" set target=recovery
if "%choice%"=="3" set target=sideload
if "%choice%"=="4" set target=fastboot
if "%choice%"=="5" set target=fastbootd
if "%choice%"=="6" set target=qcedl
if "%choice%"=="7" set target=qcdiag
call chkdev all rechk 1
ECHO.����%target%ģʽ... & call reboot %chkdev__mode% %target% rechk 1
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���REBOOT& pause>nul & goto MENU


:WRITE
SETLOCAL
set logger=example.bat-write
call log %logger% I ���빦��WRITE
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.write.bat д��
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.ˢ���������: ϵͳ,Recovery��Fastboot
ECHO.2.Fastboot��ʱ����
ECHO.3.��ͨ9008ˢ�� (xmlģʽ)
ECHO.4.��ͨ9008ˢ��������� (������ģʽ)
ECHO.5.adb push
ECHO.6.��ͨ�������Զ˿�д��QCN
ECHO.7.��ͨ9008��������
ECHO.
call input choice [1][2][3][4][5][6][7]
goto WRITE-C%choice%
:WRITE-C1
ECHOC {%c_h%}������Ҫˢ��ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto WRITE-C1
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��Ҫˢ���img�ļ�...{%c_i%}{\n}& call sel file s %framework_workspace% [img]
ECHOC {%c_h%}�뽫�豸����ϵͳ, Recovery��Fastbootģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" (if not "%chkdev__mode%"=="fastboot" ECHOC {%c_e%}ģʽ����, �����ϵͳ, Recovery��Fastbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__mode%.Ӧ����ϵͳ��Recovery��Fastbootģʽ& pause>nul & ECHO.����... & goto WRITE-C1))
ECHO.���ڽ�%sel__file_path%ˢ��%parname%(%chkdev__mode%)...& call write %chkdev__mode% %parname% %sel__file_path%
goto INFO-DONE
:WRITE-C2
ECHOC {%c_h%}��ѡ��Ҫ������img�ļ�...{%c_i%}{\n}& call sel file s %framework_workspace% [img]
ECHOC {%c_h%}�뽫�豸����Fastbootģʽ...{%c_i%}{\n}& call chkdev fastboot
ECHO.������ʱ����%sel__file_path%...& call write fastbootboot %sel__file_path%
goto WRITE-DONE
:WRITE-C3
ECHOC {%c_h%}��ѡ��img�ļ�����Ŀ¼...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
set searchpath=%sel__folder_path%
ECHOC {%c_h%}��ѡ��rawprogram.xml�ļ�...{%c_i%}{\n}& call sel file m %framework_workspace% [xml]
set xml=%sel__files%
ECHO.�Ƿ�ѡ��patch.xml�ļ�? & ECHO.1.ѡ��   2.����& call input choice [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��patch.xml�ļ�...{%c_i%}{\n}& call sel file m %framework_workspace% [xml]
if "%choice%"=="1" set xml=%xml%/%sel__files%
set fh=
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call input choice [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [elf][melf][mbn]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev qcedl rechk 1
start framework logviewer start %logfile%
call write qcedlxml %chkdev__port__qcedl% auto %searchpath% %xml% %fh%
call framework logviewer end
goto WRITE-DONE
:WRITE-C4
ECHOC {%c_h%}������Ҫˢ��ķ�����: {%c_i%}& set /p parname=
if "%parname%"=="" goto WRITE-C4
call log %logger% I ���������:%parname%
ECHOC {%c_h%}��ѡ��Ҫˢ���img�ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [img]
set imgpath=%sel__file_path%
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call input choice [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [elf][melf][mbn]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev qcedl
start framework logviewer start %logfile%
call write qcedl %parname% %imgpath% auto %fh%
call framework logviewer end
goto WRITE-DONE
:WRITE-C5
ECHOC {%c_h%}��ѡ��Ҫ���͵��ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%
ECHO.1.��ͨ   2.����
call input choice [1][2]
if "%choice%"=="1" set type=common
if "%choice%"=="2" set type=program
:WRITE-C5-1
ECHOC {%c_h%}�뽫�豸����ϵͳ��Recoveryģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" ECHOC {%c_e%}ģʽ����, �����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto WRITE-C5-1)
ECHOC {%c_a%}��������...{%c_i%}{\n}& call write adbpush %sel__file_path% bff.test %type%
ECHO.�������. λ��Ϊ: %write__adbpush__filepath%
goto WRITE-DONE
:WRITE-C6
ECHOC {%c_h%}��ѡ��QCN�ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [qcn]
ECHOC {%c_h%}�뽫�豸����, ����USB���Բ�ͬ��RootȨ������...{%c_i%}{\n}& call chkdev system rechk 1
ECHO.������ͨ��������ģʽ... & call reboot system qcdiag rechk 1
call write qcdiag %chkdev__port__qcdiag% %sel__file_path%
goto WRITE-DONE
:WRITE-C7
ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [elf][melf][mbn]
ECHOC {%c_h%}�뽫�豸����9008ģʽ...{%c_i%}{\n}& call chkdev qcedl
call write qcedlsendfh %chkdev__port% %sel__file_path% auto
goto WRITE-DONE
:WRITE-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���WRITE& pause>nul & goto MENU


:SCRCPY
SETLOCAL
set logger=example.bat-scrcpy
call log %logger% I ���빦��SCRCPY
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.scrcpy.bat Ͷ��
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_h%}�뽫�豸����ϵͳ...{%c_i%}{\n}& call chkdev system
call scrcpy ����Ͷ��
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���SCRCPY& pause>nul & goto MENU


:CLEAN
SETLOCAL
set logger=example.bat-clean
call log %logger% I ���빦��CLEAN
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.clean.bat ���
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.TWRP�ָ�����
ECHO.2.TWRP��ʽ��Data
ECHO.3.��ʽ��FAT32,NTFS��EXFAT
ECHO.4.��ͨ9008��������
call input choice [1][2][3][4]
goto CLEAN-C%choice%
:CLEAN-C1
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery rechk 3
call clean twrpfactoryreset
goto CLEAN-DONE
:CLEAN-C2
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery rechk 3
call clean twrpformatdata
goto CLEAN-DONE
:CLEAN-C3
ECHO.1.��ʽ��ΪFAT32
ECHO.2.��ʽ��ΪNTFS
ECHO.3.��ʽ��ΪEXFAT
call input choice [1][2][3]
if "%choice%"=="1" set format=fat32
if "%choice%"=="2" set format=ntfs
if "%choice%"=="3" set format=exfat
ECHO.1.�����������
ECHO.2.�������·��
call input choice [1][2]
goto CLEAN-C3-%choice%
:CLEAN-C3-1
ECHOC {%c_h%}����������ְ�Enter����: {%c_i%}& set /p choice=
if "%choice%"=="" goto CLEAN-C3-1
set var=name:%choice%& goto CLEAN-C3-A
:CLEAN-C3-2
ECHOC {%c_h%}�������·����Enter����: {%c_i%}& set /p choice=
if "%choice%"=="" goto CLEAN-C3-2
set var=path:%choice%& goto CLEAN-C3-A
:CLEAN-C3-A
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery
call clean format%format% %var%
goto CLEAN-DONE
:CLEAN-C4
ECHOC {%c_h%}����������ְ�Enter����: {%c_i%}& set /p parname=
if "%parname%"=="" goto CLEAN-C4
set fh=
ECHO.�Ƿ�ѡ��firehose�����ļ�? ѡ����������, �����򲻷���& ECHO.1.ѡ��   2.����& call input choice [1][2]
if "%choice%"=="1" ECHOC {%c_h%}��ѡ��firehose�����ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [elf][melf][mbn]
if "%choice%"=="1" set fh=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008...{%c_i%}{\n}& call chkdev qcedl
call clean qcedl %parname% %chkdev__port__qcedl% %fh%
goto CLEAN-DONE
:CLEAN-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���CLEAN& pause>nul & goto MENU


:THEME
SETLOCAL
set logger=example.bat-theme
call log %logger% I ���빦��THEME
:THEME-1
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.Ĭ��
ECHO.2.����
ECHO.3.�ڰ�ͼ
ECHO.4.�����ڿ�
ECHO.5.����
ECHO.6.DOS
ECHO.7.�����
ECHO.A.�������˵�
call input choice [1][2][3][4][5][6][7][A]
if "%choice%"=="1" set target=default
if "%choice%"=="2" set target=classic
if "%choice%"=="3" set target=ubuntu
if "%choice%"=="4" set target=douyinhacker
if "%choice%"=="5" set target=gold
if "%choice%"=="6" set target=dos
if "%choice%"=="7" set target=ChineseNewYear
if "%choice%"=="A" ENDLOCAL & call log %logger% I ��ɹ���THEME& goto MENU
::����Ԥ��
call framework theme %target%
echo.@ECHO OFF>%tmpdir%\theme.bat
echo.mode con cols=50 lines=17 >>%tmpdir%\theme.bat
echo.cd ..>>%tmpdir%\theme.bat
echo.set path=%framework_workspace%;%framework_workspace%\tool\Win;%framework_workspace%\tool\Android;%path% >>%tmpdir%\theme.bat
echo.COLOR %c_i% >>%tmpdir%\theme.bat
echo.TITLE ����Ԥ��: %target% >>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_i%}��ͨ��Ϣ{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_w%}������Ϣ{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_e%}������Ϣ{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_s%}�ɹ���Ϣ{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_h%}�ֶ�������ʾ{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_a%}ǿ��ɫ{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_we%}����ɫ{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.pause^>nul>>%tmpdir%\theme.bat
echo.EXIT>>%tmpdir%\theme.bat
call framework theme
start %tmpdir%\theme.bat
::����Ԥ�����
ECHO.
ECHO.�Ѽ���Ԥ��. �Ƿ�ʹ�ø�����
ECHO.1.ʹ��   2.��ʹ��
call input choice #[1][2]
if "%choice%"=="1" call framework conf user.bat framework_theme %target%& ECHOC {%c_i%}�Ѹ�������, ���´򿪽ű���Ч. {%c_h%}��������رսű�...{%c_i%}{\n}& call log %logger% I ��������Ϊ%target%& pause>nul & EXIT
if "%choice%"=="2" goto THEME-1


:SLOT
SETLOCAL
set logger=example.bat-slot
call log %logger% I ���빦��SLOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.slot.bat ��λ����
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.��鵱ǰ��λ
ECHO.2.���ò�λ
call input choice [1][2]
ECHOC {%c_h%}�뽫�豸����ϵͳ, Recovery��Fastbootģʽ...{%c_i%}{\n}& call chkdev all
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" (if not "%chkdev__mode%"=="fastboot" ECHOC {%c_e%}ģʽ����, �����ϵͳ, Recovery��Fastbootģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__mode%.Ӧ����ϵͳ��Recovery��Fastbootģʽ& pause>nul & ECHO.����... & goto SLOT))
goto SLOT-C%choice%
:SLOT-C1
call slot %chkdev__mode% chk
ECHO.[��ǰ��λ:%slot__cur%] [��ǰ��λ����һ��λ:%slot__cur_oth%] [��ǰ��λ�Ƿ񲻿���:%slot__cur_unbootable%] [��ǰ��λ����һ��λ�Ƿ񲻿���:%slot__cur_oth_unbootable%]
goto SLOT-DONE
:SLOT-C2
ECHOC {%c_h%}����Ŀ���λ��Enter����: {%c_i%}& set /p choice=
call slot %chkdev__mode% set %choice%
goto SLOT-DONE
:SLOT-DONE
ECHO. & ECHOC {%c_s%}���. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���SLOT& pause>nul & goto MENU


:LOG
SETLOCAL
set logger=example.bat-log
call log %logger% I ���빦��LOG
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.������־
ECHO.=--------------------------------------------------------------------=
ECHO.
if "%framework_log%"=="y" (ECHO.1.[��ǰ]������־) else (ECHO.1.      ������־)
if "%framework_log%"=="n" (ECHO.2.[��ǰ]�ر���־) else (ECHO.2.      �ر���־)
call input choice [1][2]
if "%choice%"=="1" call framework conf user.bat framework_log y
if "%choice%"=="2" call framework conf user.bat framework_log n
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}��������������˵�...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���SLOT& pause>nul & goto MENU


:PARTABLE
SETLOCAL
set logger=example.bat-partable
call log %logger% I ���빦��PARTABLE
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.partable.bat ������
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.1.Recovery-ɾ���ͽ���userdata����
ECHO.2.Recovery-������������
ECHO.3.Recovery-sgdisk���ݷ�����
ECHO.4.Recovery-sgdisk�ָ�������
ECHO.5.9008-�ض�GPT������
ECHO.6.9008-ˢ��GPT������
ECHO.A.�������˵�
call input choice [1][2][3][4][5][6][A]
if "%choice%"=="A" ENDLOCAL & call log %logger% I ��ɹ���PARTABLE& goto MENU
goto PARTABLE-C%choice%
:PARTABLE-C1
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery
ECHO.���ڶ�ȡ������Ϣ... & call info par userdata
set diskpath_userdata=%info__par__diskpath%& set partype_userdata=%info__par__type%& set parstart_userdata=%info__par__start%& set parend_userdata=%info__par__end%& set parnum_userdata=%info__par__num%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%& ECHO.
ECHO.���������ʼɾ��... & pause>nul & ECHO.ɾ������... & call partable recovery rmpar %diskpath_userdata% numb:%parnum_userdata%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%& ECHO.
ECHO.���������ʼ����... & pause>nul & ECHO.��������... & call partable recovery mkpar %diskpath_userdata% userdata %partype_userdata% %parstart_userdata% %parend_userdata% %parnum_userdata%
ECHO. & adb.exe shell ./sgdisk -p %diskpath_userdata%
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PARTABLE& pause>nul & goto MENU
:PARTABLE-C2
ECHOC {%c_h%}����Ŀ�����·����Enter����: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PARTABLE-C2
ECHOC {%c_h%}��������������Enter����(Ĭ��128): {%c_i%}& set /p maxparnum=
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery
ECHO.����������������... & call partable recovery setmaxparnum %diskpath% %maxparnum%
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PARTABLE& pause>nul & goto MENU
:PARTABLE-C3
ECHOC {%c_h%}����Ŀ�����·����Enter����: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PARTABLE-C3
ECHOC {%c_h%}��ѡ�񱣴��ļ���...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery
ECHO.���ڱ��ݷ�����%diskpath% %sel__folder_path%\partable.bak... & call partable recovery sgdiskbakpartable %diskpath% %sel__file_path%\partable.bak
ECHO. & ECHOC {%c_s%}���. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PARTABLE& pause>nul & goto MENU
:PARTABLE-C4
ECHOC {%c_h%}����Ŀ�����·����Enter����: {%c_i%}& set /p diskpath=
if "%diskpath%"=="" goto PARTABLE-C4
ECHOC {%c_h%}��ѡ��������ļ�...{%c_i%}{\n}& call sel file s %framework_workspace%\..
ECHOC {%c_h%}�뽫�豸����Recovery...{%c_i%}{\n}& call chkdev recovery
ECHO.���ڻָ�������... & call partable recovery sgdiskrecpartable %diskpath% %sel__file_path%
ECHO. & ECHOC {%c_s%}���. {%c_i%}���Ľ����´�����ʱ��Ч. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PARTABLE& pause>nul & goto MENU
:PARTABLE-C5
ECHO.��ѡ��ض���GPT������:
ECHO.0 1 2 3 4 5 6 7
call input choice [0][1][2][3][4][5][6][7]
set lunnum=%choice%
ECHO.1.main   2.backup
call input choice [1][2]
if "%choice%"=="1" set target=main
if "%choice%"=="2" set target=backup
ECHO.��ѡ���ļ�����λ��... & call sel folder s %framework_workspace%\..
ECHO.��ѡ��firehose... & call sel file s %framework_workspace%\.. [mbn][elf][melf]
ECHOC {%c_h%}�뽫�豸����9008...{%c_i%}{\n}& call chkdev qcedl
ECHO.���ڻض�GPT������... & call partable qcedl readgpt %chkdev__port% auto %lunnum% %target% %sel__folder_path%\gpt_%target%.bin notice %sel__file_path%
ECHO. & ECHOC {%c_s%}���. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PARTABLE& pause>nul & goto MENU
:PARTABLE-C6
ECHO.��ѡ��ˢ���GPT������:
ECHO.0 1 2 3 4 5 6 7
call input choice [0][1][2][3][4][5][6][7]
set lunnum=%choice%
ECHO.1.main   2.backup
call input choice [1][2]
if "%choice%"=="1" set target=main
if "%choice%"=="2" set target=backup
ECHO.��ѡ��GPT�������ļ�... & call sel file s %framework_workspace%\.. [bin]
set gptpath=%sel__file_path%
ECHO.��ѡ��firehose... & call sel file s %framework_workspace%\.. [mbn][elf][melf]
set fhpath=%sel__file_path%
ECHOC {%c_h%}�뽫�豸����9008...{%c_i%}{\n}& call chkdev qcedl
ECHO.����ˢ��GPT������... & call partable qcedl writegpt %chkdev__port% auto %lunnum% %target% %gptpath% %fhpath%
ECHO. & ECHOC {%c_s%}���. {%c_h%}�����������...{%c_i%}{\n}& ENDLOCAL & call log %logger% I ��ɹ���PARTABLE& pause>nul & goto MENU




:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
