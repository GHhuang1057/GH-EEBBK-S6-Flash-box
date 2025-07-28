::�޸�: n

::call reboot system     [system recovery fastboot fastbootd qcedl qcdiag   sprdboot poweroff] [chk rechk](��ѡ)  ���rechk��������(��ѡ)
::            recovery   [system recovery fastboot fastbootd qcedl sideload sprdboot poweroff] [chk rechk](��ѡ)  ���rechk��������(��ѡ)
::            fastboot   [system recovery fastboot fastbootd qcedl poweroff]                   [chk rechk](��ѡ)  ���rechk��������(��ѡ)
::            fastbootd  [system fastboot fastbootd]                                           [chk rechk](��ѡ)  ���rechk��������(��ѡ)
::            qcedl      [system recovery fastbootd qcedl]                                     [chk rechk](��ѡ)  ���rechk��������(��ѡ)



@ECHO OFF

set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
SETLOCAL
set logger=reboot.bat
set frommode=%args1%& set tomode=%args2%& set chkdev=%args3%& set rechkwait=%args4%
call log %logger% I ���ձ���:frommode:%frommode%.tomode:%tomode%.chkdev:%chkdev%.rechkwait:%rechkwait%
find /I ":%frommode%-%tomode%" "%framework_workspace%\reboot.bat" 1>nul 2>nul || goto UNSUPPORT
call log %logger% I ����%frommode%������%tomode%
goto %frommode%-%tomode%

:SYSTEM-SYSTEM
goto COMMON-ADB-SYSTEM

:SYSTEM-RECOVERY
goto COMMON-ADB-RECOVERY

:SYSTEM-FASTBOOT
goto COMMON-ADB-FASTBOOT

:SYSTEM-FASTBOOTD
goto COMMON-ADB-FASTBOOTD

:SYSTEM-QCEDL
goto COMMON-ADB-QCEDL

:SYSTEM-QCDIAG
ECHOC {%c_we%}��������RootȨ��. ��ע���豸��ʾ. ����RootȨ�޹���ҳ���ֶ���ȨShell...{%c_i%}{\n}& call log %logger% I ���RootȨ��
echo.su>%tmpdir%\cmd.txt & echo.whoami>>%tmpdir%\cmd.txt
adb.exe shell < %tmpdir%\cmd.txt 1>%tmpdir%\output.txt 2>&1 || ECHOC {%c_e%}����û�ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type %tmpdir%\output.txt>>%logfile% && call log %logger% E ����û�ʧ��ʧ��&& pause>nul && ECHO.����... && goto SYSTEM-QCDIAG
type %tmpdir%\output.txt>>%logfile%
for /f %%a in (%tmpdir%\output.txt) do (if not "%%a"=="root" ECHOC {%c_e%}���RootȨ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ���RootȨ��ʧ��& pause>nul & ECHO.����... & goto SYSTEM-QCDIAG)
call log %logger% I ������ͨ�������Զ˿�
echo.su>%tmpdir%\cmd.txt & echo.setprop sys.usb.config diag,adb>>%tmpdir%\cmd.txt
adb.exe shell < %tmpdir%\cmd.txt 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:SYSTEM-SPRDBOOT
goto COMMON-ADB-SPRDBOOT

:SYSTEM-POWEROFF
goto COMMON-ADB-POWEROFF

:RECOVERY-SYSTEM
goto COMMON-ADB-SYSTEM

:RECOVERY-RECOVERY
goto COMMON-ADB-RECOVERY

:RECOVERY-FASTBOOT
goto COMMON-ADB-FASTBOOT

:RECOVERY-FASTBOOTD
goto COMMON-ADB-FASTBOOTD

:RECOVERY-QCEDL
goto COMMON-ADB-QCEDL

:RECOVERY-SIDELOAD
adb.exe shell twrp sideload 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:RECOVERY-SPRDBOOT
goto COMMON-ADB-SPRDBOOT

:RECOVERY-POWEROFF
goto COMMON-ADB-POWEROFF

:FASTBOOT-SYSTEM
goto COMMON-FASTBOOT-SYSTEM

:FASTBOOT-RECOVERY
::��ͬ���Ϳ��Բ��ò�ͬ�ķ���,�˴�Ĭ��ʹ��CMD��
goto FASTBOOT-RECOVERY-CMD
:FASTBOOT-RECOVERY-CMD
fastboot.exe oem reboot-recovery 1>>%logfile% 2>&1 && goto FINISH
goto FAILED
:FASTBOOT-RECOVERY-MISC
call write fastboot misc tool\Android\misc_torecovery.img
fastboot.exe reboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:FASTBOOT-FASTBOOT
goto COMMON-FASTBOOT-FASTBOOT

:FASTBOOT-FASTBOOTD
goto COMMON-FASTBOOT-FASTBOOTD

:FASTBOOT-QCEDL
::��ͬ���Ϳ��Բ��ò�ͬ�ķ���,�˴�Ĭ��ʹ��CMD��
goto FASTBOOT-QCEDL-CMD
:FASTBOOT-QCEDL-CMD
fastboot.exe oem edl 1>>%logfile% 2>&1 && goto FINISH
fastboot.exe oem enter-dload 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:FASTBOOT-POWEROFF
fastboot.exe oem poweroff 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:FASTBOOTD-SYSTEM
goto COMMON-FASTBOOT-SYSTEM

:FASTBOOTD-FASTBOOT
goto COMMON-FASTBOOT-FASTBOOT

:FASTBOOTD-FASTBOOTD
goto COMMON-FASTBOOT-FASTBOOTD

:QCEDL-SYSTEM
call chkdev qcedl 1>nul
echo.^<?xml version="1.0" ?^>^<data^>^<power DelayInSeconds="0" value="reset" /^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%chkdev__port% --memoryname=ufs    --sendxml=%tmpdir%\tmp.xml --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 && goto FINISH
fh_loader.exe --port=\\.\COM%chkdev__port% --memoryname=emmc   --sendxml=%tmpdir%\tmp.xml --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 && goto FINISH
fh_loader.exe --port=\\.\COM%chkdev__port% --memoryname=spinor --sendxml=%tmpdir%\tmp.xml --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:QCEDL-RECOVERY
call chkdev qcedl 1>nul
call write qcedl misc tool\Android\misc_torecovery.img %chkdev__port%
call reboot qcedl system
goto FINISH

:QCEDL-FASTBOOTD
call chkdev qcedl 1>nul
call write qcedl misc tool\Android\misc_tofastbootd.img %chkdev__port%
call reboot qcedl system
goto FINISH

:QCEDL-QCEDL
call chkdev qcedl 1>nul
echo.^<?xml version="1.0" ?^>^<data^>^<power value="reset_to_edl" /^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%chkdev__port% --memoryname=ufs    --sendxml=%tmpdir%\tmp.xml --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 && goto FINISH
fh_loader.exe --port=\\.\COM%chkdev__port% --memoryname=emmc   --sendxml=%tmpdir%\tmp.xml --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 && goto FINISH
fh_loader.exe --port=\\.\COM%chkdev__port% --memoryname=spinor --sendxml=%tmpdir%\tmp.xml --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 && goto FINISH
goto FAILED






:COMMON-ADB-SYSTEM
adb.exe reboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-RECOVERY
adb.exe reboot recovery 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-FASTBOOT
adb.exe reboot bootloader 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-FASTBOOTD
adb.exe reboot fastboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-QCEDL
adb.exe reboot edl 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-SPRDBOOT
adb.exe reboot reboot autodloader 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-ADB-POWEROFF
adb.exe reboot -p 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-FASTBOOT-SYSTEM
fastboot.exe reboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-FASTBOOT-FASTBOOT
fastboot.exe reboot bootloader 1>>%logfile% 2>&1 && goto FINISH
goto FAILED

:COMMON-FASTBOOT-FASTBOOTD
fastboot.exe reboot fastboot 1>>%logfile% 2>&1 && goto FINISH
goto FAILED



:FAILED
ECHOC {%c_e%}����%tomode%ģʽʧ��{%c_i%}{\n}& call log %logger% E ����%tomode%ģʽʧ��
ECHO.1.�ٴγ���   2.���ѽ���,���Լ���
call input choice [1][2]
if "%choice%"=="1" ECHO.����... & goto %frommode%-%tomode%
if "%choice%"=="2" goto FINISH
:UNSUPPORT
ECHOC {%c_e%}��֧���Զ���%frommode%������%tomode%. {%c_h%}���ֶ�����%tomode%, ��ɺ����������...{%c_i%}{\n}& call log %logger% E ��֧���Զ���%frommode%������%tomode%.��ʾ�ֶ�����& pause>nul & ECHO.����...
goto FINISH
:FINISH
call log %logger% I �������.��������������
ENDLOCAL & set args1=%chkdev%& set args2=%tomode%& set args3=%rechkwait%
if not "%args2%"=="poweroff" (
    if "%args1%"=="chk" call chkdev %args2%
    if "%args1%"=="rechk" call chkdev %args2% rechk %args3%)
goto :eof






:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
