::�޸�: n

::call chkdev system       rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            recovery     rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            sideload     rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            fastboot     rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            fastbootd    rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            qcedl        rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            qcdiag       rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            sprdboot     rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            mtkbrom      rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            mtkpreloader rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)
::            all          rechk(��ѡ)  ����ǰ�ȴ�����(Ĭ��3)

@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9


SETLOCAL
set mode=%args1%
if "%args2%"=="rechk" (set rechk=y) else (set rechk=n)
if not "%args3%"=="" (set rechk_wait=%args3%) else (set rechk_wait=3)
::���û�м�⵽�豸, ÿ�μ����ȴ�1���ٽ�����һ�μ��. �˴�����ÿ�ּ����������, ������������ͣ (�˿ڼ�ⲻ�ȴ�������ѭ��, ���ܴ�����).
set trytimes_max=30
set logger=chkdev.bat-%mode%
if not "%mode%"=="all" (goto CHKDEV-1) else (goto CHKDEV-2)
:CHKDEV-1
set keyword=
if "%mode%"=="system" set chktype=adb& set modename=ϵͳ& set keyword=device
if "%mode%"=="recovery" set chktype=adb& set modename=Recoveryģʽ& set keyword=recovery
if "%mode%"=="sideload" set chktype=adb& set modename=ADB Sideloadģʽ& set keyword=sideload
if "%mode%"=="fastboot" set chktype=fastboot& set modename=Fastbootģʽ& set keyword=fastboot
if "%mode%"=="fastbootd" set chktype=fastboot& set modename=FastbootDģʽ& set keyword=fastboot
if "%mode%"=="qcedl" set chktype=port& set modename=9008ģʽ
if "%mode%"=="qcdiag" set chktype=port& set modename=��ͨ��������ģʽ
if "%mode%"=="sprdboot" set chktype=port& set modename=չѶbootģʽ& set keyword=SPRD U2S Diag
if "%mode%"=="mtkbrom" set chktype=port& set modename=������bromģʽ& set keyword=MediaTek USB Port 
if "%mode%"=="mtkpreloader" set chktype=port& set modename=������preloaderģʽ& set keyword= PreLoader USB VCOM 
if "%chktype%"=="" ECHOC {%c_e%}��������{%c_i%}{\n}& call log %logger% F ��������& goto FATAL
call :chk%chktype%
if "%rechk%"=="n" goto DONE
ECHO.%rechk_wait%����ٴμ��, ���Ժ�...& TIMEOUT /T %rechk_wait% /NOBREAK>nul & call :chk%chktype%
goto DONE
:CHKDEV-2
call :chkall
if "%rechk%"=="n" goto DONE
ECHO.%rechk_wait%����ٴμ��, ���Ժ�...& TIMEOUT /T %rechk_wait% /NOBREAK>nul & call :chkall
goto DONE


:chkport
ECHOC {%c_i%}���ڼ���豸����: %modename%... {%c_i%}& call log %logger% I ���ڼ���豸����:%mode%
set trytimes=1
::��ʼ���
:chkport-1
::������ָ����Ϊδ����
::if %trytimes% GTR %trytimes_max% ECHOC {%c_e%}δ����{%c_i%}{\n}& ECHOC {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �豸δ����:%mode%& pause>nul & goto chkport
::�б��豸
if "%mode%"=="qcedl"  devcon.exe listclass Ports 2>&1 | busybox egrep -n "Qualcomm HS-USB QDLoader 9008|Quectel QDLoader 9008" | find /n ":" 1>%tmpdir%\output.txt 2>&1
if "%mode%"=="qcdiag" devcon.exe listclass Ports 2>&1 | busybox egrep -n "Qualcomm HS-USB Android DIAG 901D|Qualcomm HS-USB Diagnostics|Qualcomm HS-USB MDM Diagnostics|ZTE Handset Diagnostic Interface|LGE Mobile USB Diagnostic Port|USB Diagnostics Port" | find /n ":" 1>%tmpdir%\output.txt 2>&1
if not "%mode%"=="qcedl" (
    if not "%mode%"=="qcdiag" (
        devcon.exe listclass Ports 2>&1 | busybox egrep -n "%keyword%" | find /n ":" 1>%tmpdir%\output.txt 2>&1))
::����Ƿ�ֻ��һ���豸
find "[1]" "%tmpdir%\output.txt" 1>nul 2>nul || set /a trytimes+=1&& goto chkport-1
find "[2]" "%tmpdir%\output.txt" 1>nul 2>nul && ECHOC {%c_we%} {%c_we%}{\n}&& type %tmpdir%\output.txt && ECHOC {%c_e%}�ж��Ŀ���豸����. ��Ͽ������豸. {%c_h%}�����������...{%c_i%}{\n}&& type %tmpdir%\output.txt>>%logfile%&& call log %logger% E �ж��Ŀ���豸����&& pause>nul && ECHOC {%c_i%}����...{%c_i%}&& goto chkport-1
::��ȡ�˿ں�
busybox.exe sed -i "s/ /\r\n/g" %tmpdir%\output.txt
set port=
for /f "tokens=1 delims=(COM) " %%a in ('type %tmpdir%\output.txt ^| find "(COM"') do set port=%%a
if "%port%"=="" call log %logger% E ��ȡĿ���豸�˿ں�ʧ��& goto chkport-1
::������
ECHOC {%c_s%}������ (COM%port%){%c_i%}{\n}& call log %logger% I �豸������:%mode%.�˿ں�:%port%
goto :eof


:chkadb
ECHOC {%c_i%}���ڼ���豸����: %modename%... {%c_i%}& call log %logger% I ���ڼ���豸����:%mode%
adb.exe start-server 1>>%logfile% 2>&1 || ECHO. && ECHOC {%c_e%}����adb����ʧ��. ���˳�����ռ��adb�����. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����adb����ʧ��&& pause>nul && goto chkadb
set trytimes=1
::��ʼ���
:chkadb-1
::������ָ����Ϊδ����
if %trytimes% GTR %trytimes_max% ECHOC {%c_e%}δ����{%c_i%}{\n}& ECHOC {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �豸δ����:%mode%& pause>nul & goto chkadb
::�б��豸
adb.exe devices -l 2>&1 | find /v "List of devices attached" | find "%keyword%" | find /n "%keyword%" 1>%tmpdir%\output.txt 2>&1
::����Ƿ�ֻ��һ���豸
set num=
for /f "tokens=1 delims=[]" %%a in (%tmpdir%\output.txt) do set num=%%a
if "%num%"=="" set /a trytimes+=1& TIMEOUT /T 1 /NOBREAK>nul & goto chkadb-1
if not "%num%"=="1" ECHOC {%c_we%} {%c_we%}{\n}& type %tmpdir%\output.txt & ECHOC {%c_e%}�ж��ADB�豸����. ��Ͽ������豸. {%c_h%}�����������...{%c_i%}{\n}& type %tmpdir%\output.txt>>%logfile%& call log %logger% E �ж��ADB�豸����& pause>nul & ECHOC {%c_i%}����...{%c_i%}& goto chkadb-1
::������
ECHOC {%c_s%}������{%c_i%}{\n}& call log %logger% I �豸������:%mode%
goto :eof


:chkfastboot
ECHOC {%c_i%}���ڼ���豸����: %modename%... {%c_i%}& call log %logger% I ���ڼ���豸����:%mode%
set trytimes=1
::��ʼ���
:chkfastboot-1
::������ָ����Ϊδ����
if %trytimes% GTR %trytimes_max% ECHOC {%c_e%}δ����{%c_i%}{\n}& ECHOC {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �豸δ����:%mode%& pause>nul & goto chkfastboot
::�б��豸
fastboot.exe devices -l 2>&1 | find "%keyword%" | find /n "%keyword%" 1>%tmpdir%\output.txt 2>&1
::����Ƿ�ֻ��һ���豸
set num=
for /f "tokens=1 delims=[]" %%a in (%tmpdir%\output.txt) do set num=%%a
if "%num%"=="" set /a trytimes+=1& TIMEOUT /T 1 /NOBREAK>nul & goto chkfastboot-1
if not "%num%"=="1" ECHOC {%c_we%} {%c_we%}{\n}& type %tmpdir%\output.txt & ECHOC {%c_e%}�ж��Fastboot�豸����. ��Ͽ������豸. {%c_h%}�����������...{%c_i%}{\n}& type %tmpdir%\output.txt>>%logfile%& call log %logger% E �ж��Fastboot�豸����& pause>nul & ECHOC {%c_i%}����...{%c_i%}& goto chkfastboot-1
::����fastboot��fastbootd
set var=n
fastboot.exe getvar is-userspace 2>&1 | find /v "Finished." | find "is-userspace: yes" 1>nul 2>nul && set var=y
if "%mode%"=="fastboot" (if "%var%"=="y" set /a trytimes+=1& TIMEOUT /T 1 /NOBREAK>nul & goto chkfastboot-1)
if "%mode%"=="fastbootd" (if "%var%"=="n" set /a trytimes+=1& TIMEOUT /T 1 /NOBREAK>nul & goto chkfastboot-1)
::������
ECHOC {%c_s%}������{%c_i%}{\n}& call log %logger% I �豸������:%mode%
goto :eof


:chkall
ECHOC {%c_i%}���ڼ���豸����: ȫ��... {%c_i%}& call log %logger% I ���ڼ���豸����:ȫ��
adb.exe start-server 1>>%logfile% 2>&1 || ECHO. && ECHOC {%c_e%}����adb����ʧ��. ���˳�����ռ��adb�����. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����adb����ʧ��&& pause>nul && goto chkall
set trytimes=1
::��ʼ���
:chkall-1
set devnum=0
::������ָ����Ϊδ����
if %trytimes% GTR %trytimes_max% ECHOC {%c_e%}δ����{%c_i%}{\n}& ECHOC {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �豸δ����:ȫ��& pause>nul & goto chkall
::�б�˿��豸
devcon.exe listclass Ports 2>&1 | busybox.exe grep -E "Qualcomm HS-USB QDLoader 9008|Quectel QDLoader 9008|SPRD U2S Diag|MediaTek USB Port | PreLoader USB VCOM " 2>>%logfile% | find /N "COM" 1>%tmpdir%\output.txt 2>nul
::���˿��豸���Ƿ����1
set num=
for /f "tokens=1 delims=[] " %%a in (%tmpdir%\output.txt) do set num=%%a
if "%num%"=="" goto chkall-3
if not "%num%"=="1" ECHOC {%c_we%} {%c_we%}{\n}& ECHOC {%c_e%}�ж���豸����. ��Ͽ������豸. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �ж���豸����& pause>nul & ECHOC {%c_i%}����...{%c_i%}& goto chkall-1
::�ж϶˿��豸ģʽ
find "MediaTek USB Port " "%tmpdir%\output.txt" 1>nul 2>nul && set /a devnum+=1&& set mode=mtkbrom&& set modename=������bromģʽ&& set chktype=port&& goto chkall-2
find " PreLoader USB VCOM " "%tmpdir%\output.txt" 1>nul 2>nul && set /a devnum+=1&& set mode=mtkpreloader&& set modename=������preloaderģʽ&& set chktype=port&& goto chkall-2
find "Qualcomm HS-USB QDLoader 9008" "%tmpdir%\output.txt" 1>nul 2>nul && set /a devnum+=1&& set mode=qcedl&& set modename=9008ģʽ&& set chktype=port&& goto chkall-2
find "Quectel QDLoader 9008" "%tmpdir%\output.txt" 1>nul 2>nul && set /a devnum+=1&& set mode=qcedl&& set modename=9008ģʽ&& set chktype=port&& goto chkall-2
find "SPRD U2S Diag" "%tmpdir%\output.txt" 1>nul 2>nul && set /a devnum+=1&& set mode=sprdboot&& set modename=չѶbootģʽ&& set chktype=port&& goto chkall-2
goto chkall-3
:chkall-2
::��ȡ�˿ں�
busybox.exe sed -i "s/ /\r\n/g" %tmpdir%\output.txt
set port=
for /f "tokens=1 delims=(COM) " %%a in ('type %tmpdir%\output.txt ^| find "(COM"') do set port=%%a
if "%port%"=="" ECHOC {%c_e%}��ȡ�豸�˿ں�ʧ��{%c_i%}{\n}& call log %logger% F ��ȡ�豸�˿ں�ʧ��& goto FATAL
:chkall-3
::�б�fastboot�豸
fastboot.exe devices -l 2>&1 | find " fastboot" | find /n " fastboot" 1>%tmpdir%\output.txt 2>&1
::���fastboot�豸���Ƿ����1
set num=
for /f "tokens=1 delims=[] " %%a in (%tmpdir%\output.txt) do set num=%%a
if "%num%"=="" goto chkall-4
if not "%num%"=="1" ECHOC {%c_we%} {%c_we%}{\n}& ECHOC {%c_e%}�ж���豸����. ��Ͽ������豸. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �ж���豸����& pause>nul & ECHOC {%c_i%}����...{%c_i%}& goto chkall-1
set /a devnum+=1
::�ж�fastboot�豸ģʽ
set mode=fastboot& set modename=Fastbootģʽ& set chktype=fastboot
fastboot.exe getvar is-userspace 2>&1 | find /v "Finished." | find "is-userspace: yes" 1>nul 2>nul && set mode=fastbootd&& set modename=Fastbootd ģʽ&& set chktype=fastboot
:chkall-4
::�б�adb�豸
adb.exe devices -l 2>&1 | find /v "List of devices attached" | find " " | find /n " " 1>%tmpdir%\output.txt 2>&1
::���adb�豸���Ƿ����1
set num=
for /f "tokens=1,3 delims=[] " %%a in (%tmpdir%\output.txt) do set num=%%a& set var=%%b
if "%num%"=="" goto chkall-5
if not "%num%"=="1" ECHOC {%c_we%} {%c_we%}{\n}& ECHOC {%c_e%}�ж���豸����. ��Ͽ������豸. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �ж���豸����& pause>nul & ECHOC {%c_i%}����...{%c_i%}& goto chkall-1
::�ж�adb�豸ģʽ
if "%var%"=="device" set /a devnum+=1& set mode=system& set modename=ϵͳ& set chktype=adb
if "%var%"=="recovery" set /a devnum+=1& set mode=recovery& set modename=Recoveryģʽ& set chktype=adb
if "%var%"=="sideload" set /a devnum+=1& set mode=sideload& set modename=ADB Sideloadģʽ& set chktype=adb
:chkall-5
::�������ģʽ�豸�����Ƿ����1
if "%devnum%"=="0" set /a trytimes+=1& TIMEOUT /T 1 /NOBREAK>nul & goto chkall-1
if not "%devnum%"=="1" ECHOC {%c_we%} {%c_we%}{\n}& ECHOC {%c_e%}�ж���豸����. ��Ͽ������豸. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �ж���豸����& pause>nul & ECHOC {%c_i%}����...{%c_i%}& goto chkall-1
::������
if not "%chktype%"=="port" (ECHOC {%c_s%}������: %modename%{%c_i%}{\n}& call log %logger% I �豸������:%mode%) else (ECHOC {%c_s%}������: %modename% ^(COM%port%^){%c_i%}{\n}& call log %logger% I �豸������:%mode%.�˿ں�:%port%)
goto :eof


:DONE
ENDLOCAL & set chkdev__mode=%mode%& set chkdev__port=%port%& set chkdev__port__%mode%=%port%
goto :eof








:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

