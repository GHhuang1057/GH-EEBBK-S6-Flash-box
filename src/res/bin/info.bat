::�޸�: n

::call info adb
::          fastboot
::          qcedl     �˿ں�(���ֻ�auto)  firehose����·��(��ѡ,�������)
::          par       ������             [fail back](���Ҳ�������ʱ�Ĳ���.��ѡ.Ĭ��Ϊfail)
::          disk      ����·��

@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
goto %args1%




:QCEDL
SETLOCAL
set logger=info.bat-qcedl
set port=%args2%& set fh=%args3%
call log %logger% I ���ձ���:port:%port%.fh:%fh%
:QCEDL-1
::����˿ں�Ϊauto������Զ����˿�
if "%port%"=="auto" call chkdev qcedl 1>nul
if "%port%"=="auto" set port=%chkdev__port__qcedl%
if "%port%"=="" call chkdev qcedl 1>nul
if "%port%"=="" set port=%chkdev__port__qcedl%
::��������
if not "%fh%"=="" call write qcedlsendfh %port% %fh% auto
::��ȡ�豸��Ϣ
call log %logger% I ��ʼ9008��ȡ�豸��Ϣ
set memtype=& set secsize=& set lunnum=
::  �жϴ洢���ͺ�������С (ע��: �Ȼ�ȡufs, ��Ϊ����ufs�豸��ȡemmc����˿�)
::    ����ufs�ض�
if exist %tmpdir%\tmp.bin del %tmpdir%\tmp.bin 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%tmpdir%\tmp.binʧ��{%c_i%}{\n}&& call log %logger% F ɾ��%tmpdir%\tmp.binʧ��&& goto FATAL
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="4096" filename="tmp.bin" physical_partition_number="0" label="PrimaryGPT" start_sector="0" num_partition_sectors="6" /^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%port% --memoryname=ufs --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 || goto QCEDL-2
if not exist %tmpdir%\tmp.bin goto QCEDL-2
set var=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t %tmpdir%\tmp.bin') do set var=%%a
if not "%var%"=="24576" goto QCEDL-2
set memtype=ufs& set secsize=4096& goto QCEDL-TESTLUNNUM
:QCEDL-2
::    ����emmc�ض�
if exist %tmpdir%\tmp.bin del %tmpdir%\tmp.bin 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%tmpdir%\tmp.binʧ��{%c_i%}{\n}&& call log %logger% F ɾ��%tmpdir%\tmp.binʧ��&& goto FATAL
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="512" filename="tmp.bin" physical_partition_number="0" label="PrimaryGPT" start_sector="0" num_partition_sectors="34"/^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%port% --memoryname=emmc --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 || goto QCEDL-3
if not exist %tmpdir%\tmp.bin goto QCEDL-3
set var=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t %tmpdir%\tmp.bin') do set var=%%a
if not "%var%"=="17408" goto QCEDL-3
set memtype=emmc& set secsize=512& set lunnum=1& goto QCEDL-DONE
:QCEDL-3
::    ����spinor�ض�
if exist %tmpdir%\tmp.bin del %tmpdir%\tmp.bin 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%tmpdir%\tmp.binʧ��{%c_i%}{\n}&& call log %logger% F ɾ��%tmpdir%\tmp.binʧ��&& goto FATAL
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="4096" filename="tmp.bin" physical_partition_number="0" label="PrimaryGPT" start_sector="0"  num_partition_sectors="6" /^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%port% --memoryname=spinor --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 || goto QCEDL-FAILED
if not exist %tmpdir%\tmp.bin goto QCEDL-FAILED
set var=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t %tmpdir%\tmp.bin') do set var=%%a
if not "%var%"=="24576" goto QCEDL-FAILED
set memtype=spinor& set secsize=4096& set lunnum=1& goto QCEDL-DONE
::  ����ufs����lun����
:QCEDL-TESTLUNNUM
call log %logger% I ����ufs����lun����
set num=0
:QCEDL-TESTLUNNUM-1
if %num% GTR 8 ECHOC {%c_w%}��ǰ�豸����lun����Ϊ%num%. ����lun����ӦС�ڵ���8. ���򿪷��߷���.{%c_i%}{\n}& call log %logger% W ��ǰ�豸����lun����Ϊ%num%.����lun����ӦС�ڵ���8
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="4096" filename="gpt_main%num%.bin" physical_partition_number="%num%" label="PrimaryGPT" start_sector="0" num_partition_sectors="6" /^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%port% --memoryname=ufs --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 || goto QCEDL-TESTLUNNUM-2
ptanalyzer.exe -f %tmpdir%\gpt_main%num%.bin -m ufs -t gptmain -o normal_clear 1>>%logfile% 2>&1 || goto QCEDL-TESTLUNNUM-2
set /a num+=1& goto QCEDL-TESTLUNNUM-1
:QCEDL-TESTLUNNUM-2
if %num% EQU 0 ECHOC {%c_e%}��ǰ�豸����lun����Ϊ%num%.{%c_i%}{\n}& call log %logger% E ��ǰ�豸����lun����Ϊ%num%& goto QCEDL-FAILED
if %num% LSS 6 ECHOC {%c_w%}��ǰ�豸����lun����Ϊ%num%. ����lun����Ӧ���ڵ���6. ���򿪷��߷���.{%c_i%}{\n}& call log %logger% W ��ǰ�豸����lun����Ϊ%num%.����lun����Ӧ���ڵ���6
set lunnum=%num%& goto QCEDL-DONE
:QCEDL-DONE
call log %logger% I 9008��ȡ���豸��Ϣ:�洢����:%memtype%.������С:%secsize%.lun����:%lunnum%
ENDLOCAL & set info__qcedl__memtype=%memtype%& set info__qcedl__secsize=%secsize%& set info__qcedl__lunnum=%lunnum%
goto :eof
:QCEDL-FAILED
ECHOC {%c_e%}9008��ȡ�豸��Ϣʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E 9008��ȡ�豸��Ϣʧ��.��ǰ���:�洢����:%memtype%.������С:%secsize%.lun����:%lunnum%& pause>nul & ECHO.����... & goto QCEDL-1


:ADB
SETLOCAL
set logger=info.bat-adb
call log %logger% I ��ʼ��ȡADB�豸��Ϣ
:ADB-1
set product=
for /f %%a in ('adb.exe shell getprop ro.product.device') do set product=%%a
if "%product%"=="" call log %logger% E ro.product.device��ȡʧ��& ECHOC {%c_e%}ro.product.device��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto ADB-1
set androidver=
for /f %%a in ('adb.exe shell getprop ro.build.version.release') do set androidver=%%a
if "%androidver%"=="" call log %logger% E ro.build.version.release��ȡʧ��& ECHOC {%c_e%}ro.build.version.release��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto ADB-1
set sdkver=
for /f %%a in ('adb.exe shell getprop ro.build.version.sdk') do set sdkver=%%a
if "%sdkver%"=="" call log %logger% E ro.build.version.sdk��ȡʧ��& ECHOC {%c_e%}ro.build.version.sdk��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto ADB-1
call log %logger% I ��ȡ��ADB�豸��Ϣ:product:%product%.androidver:%androidver%.sdkver:%sdkver%
ENDLOCAL & set info__adb__product=%product%& set info__adb__androidver=%androidver%& set info__adb__sdkver=%sdkver%
goto :eof


:FASTBOOT
SETLOCAL
set logger=info.bat-fastboot
call log %logger% I ��ʼ��ȡFastboot�豸��Ϣ
:FASTBOOT-1
set product=
for /f "tokens=2 delims=: " %%a in ('fastboot getvar product 2^>^&1^| find "product"') do set product=%%a
if "%product%"=="" call log %logger% E product��ȡʧ��& ECHOC {%c_e%}product��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto FASTBOOT-1
set unlocked=
for /f "tokens=2 delims=: " %%a in ('fastboot getvar unlocked 2^>^&1^| find "unlocked"') do set unlocked=%%a
if "%unlocked%"=="" call log %logger% E unlocked��ȡʧ��& ECHOC {%c_e%}unlocked��ȡʧ��. {%c_h%}�����������...{%c_i%}{\n}& pause>nul & ECHO.����... & goto FASTBOOT-1
call log %logger% I ��ȡ��Fastboot�豸��Ϣ:product:%product%.unlocked:%unlocked%
ENDLOCAL & set info__fastboot__product=%product%& set info__fastboot__unlocked=%unlocked%
goto :eof
::��:Ħ�������豸�жϽ����ķ�������: fastboot getvar securestate 2>&1| find "flashing_unlocked" 1>nul 2>nul && set unlocked=yes


:PAR
SETLOCAL
set logger=info.bat-par
set parname=%args2%& set ifparnotexist=%args3%
if "%ifparnotexist%"=="" set ifparnotexist=fail
call log %logger% I ���ձ���:parname:%parname%.ifparnotexist:%ifparnotexist%
:PAR-1
call chkdev all 1>nul
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" ECHOC {%c_e%}�豸ģʽ����, ֻ֧����ϵͳ��Recovery��ȡ����·��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__mode%.Ӧ����ϵͳ��Recoveryģʽ& pause>nul & ECHO.����... & goto PAR-1)
call log %logger% I ��ʼ��ȡ������Ϣ
::blktool��ȡ����������Ϣ
call framework adbpre blktool
if "%chkdev__mode%"=="system" echo.su>%tmpdir%\cmd.txt& echo../data/local/tmp/blktool -n -N %parname% --print-part -l --print-sector-size>>%tmpdir%\cmd.txt
if "%chkdev__mode%"=="recovery" echo../blktool -n -N %parname% --print-part -l --print-sector-size>%tmpdir%\cmd.txt
echo.exit>>%tmpdir%\cmd.txt & echo.exit>>%tmpdir%\cmd.txt
adb.exe shell < %tmpdir%\cmd.txt 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
    ::�жϷ����Ƿ���� parexist
set parexist=y
find "list failed: no any match block found" "%tmpdir%\output.txt" 1>nul 2>nul && set parexist=n
if "%parexist%"=="n" (
    if "%ifparnotexist%"=="fail" ECHOC {%c_e%}%parname%����������. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E %parname%����������& pause>nul & ECHO.����... & goto PAR-1
    if "%ifparnotexist%"=="back" (
        call log %logger% I %parname%����������.�˳���ȡ������Ϣ
        ENDLOCAL & set info__par__exist=n
        goto :eof))
    ::��������, ��ȡ parnum parpath disksecsize
set parnum=& set parpath=& set disksecsize=
for /f "tokens=1,2,3 delims= " %%a in ('type %tmpdir%\output.txt ^| find /v "blktool" ^| find "/"') do (set parnum=%%a& set parpath=%%b& set disksecsize=%%c)
if "%parnum%"=="" ECHOC {%c_e%}��ȡ�������ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ�������ʧ��& pause>nul & ECHO.����... & goto PAR-1
if "%parpath%"=="" ECHOC {%c_e%}��ȡ����·��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����·��ʧ��& pause>nul & ECHO.����... & goto PAR-1
if "%disksecsize%"=="" ECHOC {%c_e%}��ȡ����������Сʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����������Сʧ��& pause>nul & ECHO.����... & goto PAR-1
    ::��ȡ disktype
set disktype=
if "%disksecsize%"=="512"  set disktype=emmc
if "%disksecsize%"=="4096" set disktype=ufs
if "%disktype%"=="" ECHOC {%c_e%}��֧�ֵĸ�ʽ:������СΪ%disksecsize%{%c_i%}{\n}& call log %logger% F ��֧�ֵĸ�ʽ:������СΪ%disksecsize%& goto FATAL
    ::��ȡ diskpath
set var=
for /f "tokens=1,2,3 delims= " %%a in ('echo.%parpath%# ^| busybox.exe sed "s/%parnum%#//g"') do set var=%%a
if "%disktype%"=="emmc" set diskpath=%var:~0,-1%
if "%disktype%"=="emmc" (if not "%diskpath%"=="/dev/block/mmcblk0" ECHOC {%c_e%}��֧�ֵĸ�ʽ:����·��Ϊ%diskpath%{%c_i%}{\n}& call log %logger% F ��֧�ֵĸ�ʽ:����·��Ϊ%diskpath%& goto FATAL)
if "%disktype%"=="ufs" set diskpath=%var%
if "%disktype%"=="ufs" (if not "%diskpath:~0,13%"=="/dev/block/sd" ECHOC {%c_e%}��֧�ֵĸ�ʽ:����·��Ϊ%diskpath%{%c_i%}{\n}& call log %logger% F ��֧�ֵĸ�ʽ:����·��Ϊ%diskpath%& goto FATAL)
::��ȡ�������ȡ������ֹ��С����
:PAR-GETGPT
call partable %chkdev__mode% sgdiskbakpartable %diskpath% %tmpdir%\tmp.bin noprompt
::if "%disktype%"=="emmc" (set var=34) else (set var=6)
::if "%chkdev__mode%"=="system" (
::    echo.su>%tmpdir%\cmd.txt & echo.dd if=%diskpath% of=./data/local/tmp/bff.tmp bs=%disksecsize% count=%var% >>%tmpdir%\cmd.txt && echo.mv ./data/local/tmp/bff.tmp ./sdcard/bff.tmp>>%tmpdir%\cmd.txt && echo.exit>>%tmpdir%\cmd.txt & echo.exit>>%tmpdir%\cmd.txt
::    adb.exe shell < %tmpdir%\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡ������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ������ʧ��&& pause>nul && ECHO.����... && goto PAR-GETGPT
::    call read adbpull ./sdcard/bff.tmp %tmpdir%\tmp.bin noprompt)
::if "%chkdev__mode%"=="recovery" (
::    adb.exe shell dd if=%diskpath% of=./bff.tmp bs=%disksecsize% count=%var% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡ������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ������ʧ��&& pause>nul && ECHO.����... && goto PAR-GETGPT
::    call read adbpull ./bff.tmp %tmpdir%\tmp.bin noprompt)
:PAR-READGPT
ptanalyzer.exe -f %tmpdir%\tmp.bin -m %disktype% -t sgdiskgptbak -o normal_entire 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "Analysis completed." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}����������ʧ��{%c_i%}{\n}&& call log %logger% F ����������ʧ��&& goto FATAL
set parstart_sec=unknown& set parend_sec=unknown& set parsize_sec=unknown& set partype=unknown
for /f "tokens=3,4,5,6 delims= " %%a in ('type %tmpdir%\output.txt ^| find "[%parnum%]" ^| find " %parname% "') do (set parstart_sec=%%a& set parend_sec=%%b& set parsize_sec=%%c& set partype=%%d)
call calc sec2b parstart nodec %parstart_sec% %disksecsize%
call calc sec2b parend nodec %parend_sec% %disksecsize%
call calc sec2b parsize nodec %parsize_sec% %disksecsize%
call log %logger% I ��ȡ������Ϣ���:parexist:%parexist%.diskpath:%diskpath%.parnum:%parnum%.parpath:%parpath%.partype:%partype%.parstart:%parstart%.parend:%parend%.parsize:%parsize%.disksecsize:%disksecsize%.disktype:%disktype%
ENDLOCAL & set info__par__exist=%parexist%& set info__par__diskpath=%diskpath%& set info__par__num=%parnum%& set info__par__path=%parpath%& set info__par__type=%partype%& set info__par__start=%parstart%& set info__par__end=%parend%& set info__par__size=%parsize%& set info__par__disksecsize=%disksecsize%& set info__par__disktype=%disktype%
goto :eof


:DISK
SETLOCAL
set logger=info.bat-disk
set diskpath=%args2%
call log %logger% I ���ձ���:diskpath:%diskpath%
call framework adbpre blktool
call framework adbpre sgdisk
:DISK-3
call chkdev all 1>nul
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" ECHOC {%c_e%}�豸ģʽ����, ֻ֧����ϵͳ��Recovery��ȡ����·��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ģʽ����:%chkdev__mode%.Ӧ����ϵͳ��Recoveryģʽ& pause>nul & ECHO.����... & goto DISK-3)
::��ȡ�洢����
echo.%diskpath% | find "mmcblk" 1>nul 2>nul && set disktype=emmc&& call log %logger% I ��ȡ�洢�������:emmc&& goto DISK-1
echo.%diskpath% | find "dev/block/sd" 1>nul 2>nul && set disktype=ufs&& call log %logger% I ��ȡ�洢�������:ufs&& goto DISK-1
ECHOC {%c_e%}��֧�ֵĴ洢����{%c_i%}{\n}& call log %logger% F ��֧�ֵĴ洢����& goto FATAL
::��ȡ����������С
:DISK-1
if "%chkdev__mode%"=="system" echo.su>%tmpdir%\cmd.txt& echo../data/local/tmp/blktool -n -p --print-sector-size>>%tmpdir%\cmd.txt
if "%chkdev__mode%"=="recovery" echo../blktool -n -p --print-sector-size>%tmpdir%\cmd.txt
echo.exit>>%tmpdir%\cmd.txt & echo.exit>>%tmpdir%\cmd.txt
set disksecsize=
for /f "tokens=2 delims= " %%a in ('adb.exe shell ^< %tmpdir%\cmd.txt ^| find "%diskpath%" ^| busybox.exe sed "s/\r/\r\n/g"') do set disksecsize=%%a
if "%disksecsize%"=="" (ECHOC {%c_e%}��ȡ����������Сʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ����������Сʧ��& pause>nul & ECHO.����... & goto DISK-1) else (call log %logger% I ��ȡ����������С���:%disksecsize%)
::��ȡ��������
:DISK-2
if "%chkdev__mode%"=="system" echo.su>%tmpdir%\cmd.txt& echo../data/local/tmp/sgdisk -p %diskpath% >>%tmpdir%\cmd.txt
if "%chkdev__mode%"=="recovery" echo../sgdisk -p %diskpath% >%tmpdir%\cmd.txt
echo.exit>>%tmpdir%\cmd.txt & echo.exit>>%tmpdir%\cmd.txt
set maxparnum=
for /f "tokens=6 delims= " %%a in ('adb.exe shell ^< %tmpdir%\cmd.txt ^| find "Partition table holds up to " ^| busybox.exe sed "s/\r/\r\n/g"') do set maxparnum=%%a
if "%maxparnum%"=="" (ECHOC {%c_e%}��ȡ��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡ��������ʧ��& pause>nul & ECHO.����... & goto DISK-2) else (call log %logger% I ��ȡ�����������:%maxparnum%)
call log %logger% I ��ȡ������Ϣ���
ENDLOCAL & set info__disk__type=%disktype%& set info__disk__secsize=%disksecsize%& set info__disk__maxparnum=%maxparnum%
goto :eof















:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
