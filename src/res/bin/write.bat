::�޸�: n

::call write system        ������               img·��
::           recovery      ������               img·��
::           fastboot      ������               img·��
::           fastbootd     ������               img·��
::           fastbootboot  img·��
::           qcedl         ������               img·��                      �˿ں�(���ֻ�auto)                                    firehose·��(��ѡ,�������)
::           qcedlxml      �˿ں�(���ֻ�auto)    �洢����(ָ����auto)          img�����ļ���                                         xml·��                         firehose·��(��ѡ,�������)
::           qcedlsendfh   �˿ں�(���ֻ�auto)    firehose·��                [auto emmc ufs spinor skip](���ö˿ڷ�ʽ,��ѡ,Ĭ��auto)
::           qcdiag        �˿ں�(���ֻ�auto)    qcn·��
::           twrpinst      zip·��
::           sideload      zip·��
::           adbpush       Դ�ļ�·��           ���ͺ��ļ���                  [common program](�ļ�����,��ѡ,Ĭ��common)


@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
goto %args1%



:QCEDLSENDFH
SETLOCAL
set logger=write.bat-qcedlsendfh
::���ձ���
set port=%args2%& set filepath=%args3%& set configuremode=%args4%
call log %logger% I ���ձ���:port:%port%.filepath:%filepath%.configuremode:%configuremode%
::���firehose�Ƿ����
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
::��������·��
for %%a in ("%filepath%") do set filepath=%%~fa
::����˿ں�Ϊauto���Զ����˿�
if "%port%"=="auto" call chkdev qcedl 1>nul
if "%port%"=="auto" set port=%chkdev__port__qcedl%
call log %logger% I ���ڷ�������
::�˴�����ͨ�÷���. ����Ҫ���������ӷ���.
goto QCEDLSENDFH-COMMON
:QCEDLSENDFH-COMMON
QSaharaServer.exe -p \\.\COM%port% -s 13:%filepath% 1>%tmpdir%\output.txt 2>&1 || type %tmpdir%\output.txt>>%logfile% && ECHOC {%c_e%}��������ʧ��. �뽫�豸���½���9008. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto QCEDLSENDFH-COMMON
type %tmpdir%\output.txt>>%logfile%
find "File transferred successfully" "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}��������ʧ��. �뽫�豸���½���9008. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto QCEDLSENDFH-COMMON
goto QCEDLSENDFH-DONE
:QCEDLSENDFH-DONE
call log %logger% I �����������
::���ö˿�
if "%configuremode%"=="skip" ECHOC {%c_w%}���������ö˿�. �豸��д���ܳ����쳣& call log %logger% W �������ö˿�& goto QCEDLSENDFH-CONFIGURE-DONE
if "%configuremode%"=="ufs" goto QCEDLSENDFH-CONFIGURE-%configuremode%
if "%configuremode%"=="emmc" goto QCEDLSENDFH-CONFIGURE-%configuremode%
if "%configuremode%"=="spinor" goto QCEDLSENDFH-CONFIGURE-%configuremode%
goto QCEDLSENDFH-CONFIGURE-AUTO
:QCEDLSENDFH-CONFIGURE-UFS
call log %logger% I ����%configuremode%ģʽ���ö˿�
call :qcedlsendfh-configure-tryufs
if "%result%"=="y" call log %logger% I %configuremode%ģʽ���ö˿ڳɹ�
if "%result%"=="n" ECHOC {%c_w%}%configuremode%ģʽ���ö˿�ʧ��. �豸�����޷�������д{%c_i%}{\n}& ECHO.����... & call log %logger% W %configuremode%ģʽ���ö˿�ʧ��
goto QCEDLSENDFH-CONFIGURE-DONE
:QCEDLSENDFH-CONFIGURE-EMMC
call log %logger% I ����%configuremode%ģʽ���ö˿�
call :qcedlsendfh-configure-tryemmc
if "%result%"=="y" call log %logger% I %configuremode%ģʽ���ö˿ڳɹ�
if "%result%"=="n" ECHOC {%c_w%}%configuremode%ģʽ���ö˿�ʧ��. �豸�����޷�������д{%c_i%}{\n}& ECHO.����... & call log %logger% W %configuremode%ģʽ���ö˿�ʧ��
goto QCEDLSENDFH-CONFIGURE-DONE
:QCEDLSENDFH-CONFIGURE-SPINOR
call log %logger% I ����%configuremode%ģʽ���ö˿�
call :qcedlsendfh-configure-tryspinor
if "%result%"=="y" call log %logger% I %configuremode%ģʽ���ö˿ڳɹ�
if "%result%"=="n" ECHOC {%c_w%}%configuremode%ģʽ���ö˿�ʧ��. �豸�����޷�������д{%c_i%}{\n}& ECHO.����... & call log %logger% W %configuremode%ģʽ���ö˿�ʧ��
goto QCEDLSENDFH-CONFIGURE-DONE
:QCEDLSENDFH-CONFIGURE-AUTO
call log %logger% I ����ufsģʽ���ö˿�
call :qcedlsendfh-configure-tryufs
if "%result%"=="y" call log %logger% I ufsģʽ���ö˿ڳɹ�& goto QCEDLSENDFH-CONFIGURE-DONE
if "%result%"=="n" call log %logger% I ufsģʽ���ö˿�ʧ��
call log %logger% I ����emmcģʽ���ö˿�
call :qcedlsendfh-configure-tryemmc
if "%result%"=="y" call log %logger% I emmcģʽ���ö˿ڳɹ�& goto QCEDLSENDFH-CONFIGURE-DONE
if "%result%"=="n" call log %logger% I emmcģʽ���ö˿�ʧ��
call log %logger% I ����spinorģʽ���ö˿�
call :qcedlsendfh-configure-tryspinor
if "%result%"=="y" call log %logger% I spinorģʽ���ö˿ڳɹ�& goto QCEDLSENDFH-CONFIGURE-DONE
if "%result%"=="n" call log %logger% I spinorģʽ���ö˿�ʧ��
ECHOC {%c_w%}�Զ����ö˿�ʧ��. �豸�����޷�������д{%c_i%}{\n}& ECHO.����... & call log %logger% W �Զ����ö˿�ʧ��
goto QCEDLSENDFH-CONFIGURE-DONE
:qcedlsendfh-configure-tryufs
set result=n
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="4096" filename="tmp.bin" physical_partition_number="0" label="PrimaryGPT" start_sector="0" num_partition_sectors="6"/^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%port% --memoryname=ufs --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --noprompt 1>>%logfile% 2>&1 || call log %logger% I Ĭ�ϲ������ö˿�ʧ��.����ȥ��MaxDigestTableSizeInBytes������������&& fh_loader.exe --port=\\.\COM%port% --memoryname=ufs --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --fix_config --noprompt 1>>%logfile% 2>&1
find "Got the ACK for the <configure>" "%tmpdir%\port_trace.txt" 1>nul 2>nul && set result=y
find "Target returned NAK for your <configure> but it does not seem to be an error" "%tmpdir%\port_trace.txt" 1>nul 2>nul && set result=y
goto :eof
:qcedlsendfh-configure-tryemmc
set result=n
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="512" filename="tmp.bin" physical_partition_number="0" label="PrimaryGPT" start_sector="0" num_partition_sectors="34"/^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%port% --memoryname=emmc --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --noprompt 1>>%logfile% 2>&1 || call log %logger% I Ĭ�ϲ������ö˿�ʧ��.����ȥ��MaxDigestTableSizeInBytes������������&& fh_loader.exe --port=\\.\COM%port% --memoryname=emmc --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --fix_config --noprompt 1>>%logfile% 2>&1
find "Got the ACK for the <configure>" "%tmpdir%\port_trace.txt" 1>nul 2>nul && set result=y
find "Target returned NAK for your <configure> but it does not seem to be an error" "%tmpdir%\port_trace.txt" 1>nul 2>nul && set result=y
goto :eof
:qcedlsendfh-configure-tryspinor
set result=n
echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="4096" filename="tmp.bin" physical_partition_number="0" label="PrimaryGPT" start_sector="0" num_partition_sectors="6"/^>^</data^>>%tmpdir%\tmp.xml
fh_loader.exe --port=\\.\COM%port% --memoryname=spinor --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% --noprompt 1>>%logfile% 2>&1 || call log %logger% I Ĭ�ϲ������ö˿�ʧ��.����ȥ��MaxDigestTableSizeInBytes������������&& fh_loader.exe --port=\\.\COM%port% --memoryname=spinor --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%tmpdir% fix_config --noprompt 1>>%logfile% 2>&1
find "Got the ACK for the <configure>" "%tmpdir%\port_trace.txt" 1>nul 2>nul && set result=y
find "Target returned NAK for your <configure> but it does not seem to be an error" "%tmpdir%\port_trace.txt" 1>nul 2>nul && set result=y
goto :eof
:QCEDLSENDFH-CONFIGURE-DONE
ENDLOCAL
goto :eof


:QCDIAG
SETLOCAL
set logger=write.bat-qcdiag
::���ձ���
set port=%args2%& set filepath=%args3%
call log %logger% I ���ձ���:port:%port%.filepath:%filepath%
:QCDIAG-1
::���qcn�Ƿ����
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
::����˿ں�Ϊauto���Զ����˿�
if "%port%"=="auto" call chkdev qcdiag 1>nul
if "%port%"=="auto" set port=%chkdev__port__qcdiag%
::��ʼд��qcn
call log %logger% I ��ʼд��QCN:%filepath%
QCNTool.exe -w -p %port% -f %filepath% 1>%tmpdir%\output.txt 2>&1
::ע��: ԭʼ����а����豸IMEI, �粻ϣ����ԭʼ������浽��־, �뽫����һ��type����ע�͵�
type %tmpdir%\output.txt>>%logfile%
find "Writing Data File to phone... OK" "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}д��QCN:%filepath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E д��QCN:%filepath%ʧ��&& pause>nul && ECHO.����... && goto QCDIAG-1
call log %logger% I д��QCN:%filepath%���
ENDLOCAL
goto :eof


:ADBPUSH
SETLOCAL
set logger=write.bat-adbpush
::���ձ���
set filepath=%args2%& set pushname_full=%args3%& set mode=%args4%
call log %logger% I ���ձ���:filepath:%filepath%.pushname_full:%pushname_full%.mode:%mode%
:ADBPUSH-1
::����Ƿ����
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
::��ȡ�ļ���(��������չ��)
for %%a in ("%pushname_full%") do set pushname=%%~na
::��ȡ�ļ���չ��
for %%a in ("%pushname_full%") do set var=%%~xa
if not "%var%"=="" (set pushname_ext=%var:~1,999%) else (set pushname_ext=)
::����豸ģʽ
call chkdev all 1>nul
if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" ECHOC {%c_e%}�豸ģʽ����. {%c_i%}�뽫�豸����ϵͳ��Recoveryģʽ. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �豸ģʽ����& pause>nul & ECHO.����... & goto ADBPUSH-1)
::����ģʽ
if "%mode:~0,7%"=="program" goto ADBPUSH-PROGRAM-%chkdev__mode%
goto ADBPUSH-COMMON
::���ͳ���ģʽ-ϵͳ
:ADBPUSH-PROGRAM-SYSTEM
set pushfolder=./data/local/tmp
adb.exe push %filepath% ./sdcard/bff.tmp 1>%tmpdir%\output.txt 2>&1 || type %tmpdir%\output.txt>>%logfile% && ECHOC {%c_e%}����%filepath%��./sdcard/bff.tmpʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��./sdcard/bff.tmpʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-PROGRAM-%chkdev__mode%
type %tmpdir%\output.txt>>%logfile%
find " 1 file pushed, 0 skipped." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}����%filepath%��./sdcard/bff.tmpʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��./sdcard/bff.tmpʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-PROGRAM-%chkdev__mode%
adb.exe shell mv -f ./sdcard/bff.tmp %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�./sdcard/bff.tmp��%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�./sdcard/bff.tmp��%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-PROGRAM-%chkdev__mode%
adb.exe shell chmod 777 %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��Ȩ%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��Ȩ%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-PROGRAM-%chkdev__mode%
goto ADBPUSH-DONE
::���ͳ���ģʽ-Recovery
:ADBPUSH-PROGRAM-RECOVERY
set pushfolder=.
adb.exe push %filepath% %pushfolder%/bff.tmp 1>%tmpdir%\output.txt 2>&1 || type %tmpdir%\output.txt>>%logfile% && ECHOC {%c_e%}����%filepath%��%pushfolder%/bff.tmpʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/bff.tmpʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-PROGRAM-%chkdev__mode%
type %tmpdir%\output.txt>>%logfile%
find " 1 file pushed, 0 skipped." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}����%filepath%��%pushfolder%/bff.tmpʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/bff.tmpʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-PROGRAM-%chkdev__mode%
adb.exe shell mv -f %pushfolder%/bff.tmp %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�%pushfolder%/bff.tmp��%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�%pushfolder%/bff.tmp��%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-PROGRAM-%chkdev__mode%
adb.exe shell chmod 777 %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��Ȩ%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��Ȩ%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-PROGRAM-%chkdev__mode%
goto ADBPUSH-DONE
::ͨ������ģʽ
:ADBPUSH-COMMON
set pushfolder=./sdcard
    ::�����ļ���С(b)
set filesize=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t %filepath%') do set filesize=%%a
if "%filesize%"=="" ECHC {%c_e%}��ȡ%filepath%��Сʧ��{%c_i%}{\n}& call log %logger% F ��ȡ%filepath%��Сʧ��& goto FATAL
    ::��ȡʣ��ռ���Ϣ(b)
call framework adbpre busybox
set busyboxpath=%write__adbpush__filepath%
adb.exe shell %busyboxpath% df -B 1 2>&1 | find /v "Permission denied" 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "Filesystem" "%tmpdir%\output.txt" 1>nul 2>nul || type %tmpdir%\output.txt>>%logfile% && ECHOC {%c_e%}��ȡʣ��ռ�ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡʣ��ռ�ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-COMMON
type %tmpdir%\output.txt | busybox.exe tr "\r" "\n" | busybox.exe sed "s/$/\r/g" 1>%tmpdir%\output2.txt 2>&1 || ECHOC {%c_e%}ת��%tmpdir%\output.txt���з�ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ת��%tmpdir%\output.txt���з�ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-COMMON
del %tmpdir%\output.txt 1>>%logfile% 2>&1
for /f "tokens=4,6 delims= " %%a in ('type %tmpdir%\output2.txt') do echo.[%%a][%%b]>>%tmpdir%\output.txt
        ::df�Զ����е����⴦��
for /f "tokens=3,5 delims= " %%a in ('type %tmpdir%\output2.txt') do echo.[%%a][%%b]>>%tmpdir%\output.txt
    ::�Ƚ�ʣ��ռ�, ���pushfolder
if "%chkdev__mode%"=="system" (goto ADBPUSH-COMMON-CHKSPACE-SYSTEM) else (goto ADBPUSH-COMMON-CHKSPACE-RECOVERY)
        ::����״̬(sdcard��data����һ�����þ�����sdcard����)
:ADBPUSH-COMMON-CHKSPACE-SYSTEM
call :adbpush-common-chkspace sdcard
if "%result%"=="y" set pushfolder=./sdcard& goto ADBPUSH-COMMON-PUSH
call :adbpush-common-chkspace data
if "%result%"=="y" set pushfolder=./sdcard& goto ADBPUSH-COMMON-PUSH
ECHOC {%c_e%}�豸û�п��õ�����·����ռ䲻��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �豸û�п��õ�����·����ռ䲻��& pause>nul & ECHO.����... & goto ADBPUSH-COMMON
        ::����״̬
:ADBPUSH-COMMON-CHKSPACE-RECOVERY
call :adbpush-common-chkspace tmp
if "%result%"=="y" set pushfolder=./tmp& goto ADBPUSH-COMMON-PUSH
call :adbpush-common-chkspace data
if "%result%"=="y" set pushfolder=./data& goto ADBPUSH-COMMON-PUSH
call :adbpush-common-chkspace sdcard
if "%result%"=="y" set pushfolder=./sdcard& goto ADBPUSH-COMMON-PUSH
ECHOC {%c_e%}�豸û�п��õ�����·����ռ䲻��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E �豸û�п��õ�����·����ռ䲻��& pause>nul & ECHO.����... & goto ADBPUSH-COMMON
        ::call :adbpush-common-chkspace �ؼ���(��sdcard)
:adbpush-common-chkspace
set keyword=%1
set var=
for /f "tokens=1 delims=[] " %%a in ('type %tmpdir%\output.txt ^| find "[/%keyword%]"') do set var=%%a
            ::ʧ��
if "%var%"=="" set result=n& goto :eof
            ::�������bff.tmp��Ŀ��ͬ���ļ����ų����С
set var2=
for /f "tokens=2 delims= " %%a in ('adb.exe shell %busyboxpath% stat -t ./%keyword%/bff.tmp 2^>^&1 ^| find /v "No such file or directory" ^| find "bff.tmp"') do set var2=%%a
if not "%var2%"=="" call calc s var nodec %var% %var2%
set var2=
for /f "tokens=2 delims= " %%a in ('adb.exe shell %busyboxpath% stat -t ./%keyword%/%pushname_full% 2^>^&1 ^| find /v "No such file or directory" ^| find "%pushname_full%"') do set var2=%%a
if not "%var2%"=="" call calc s var nodec %var% %var2%
            ::�ų����
if not "%var%"=="" call calc numcomp %var% %filesize%
if not "%var%"=="" (if "%calc__numcomp__result%"=="greater" set result=y& goto :eof)
            ::ʧ��
set result=n& goto :eof
:ADBPUSH-COMMON-PUSH
    ::�����ļ�
adb.exe push %filepath% %pushfolder%/bff.tmp 1>%tmpdir%\output.txt 2>&1 || type %tmpdir%\output.txt>>%logfile% && ECHOC {%c_e%}����%filepath%��%pushfolder%/bff.tmpʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/bff.tmpʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-COMMON
type %tmpdir%\output.txt>>%logfile%
find " 1 file pushed, 0 skipped." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}����%filepath%��%pushfolder%/bff.tmpʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/bff.tmpʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-COMMON
adb.exe shell mv -f %pushfolder%/bff.tmp %pushfolder%/%pushname_full% 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�%pushfolder%/bff.tmp��%pushfolder%/%pushname_full%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ƶ�%pushfolder%/bff.tmp��%pushfolder%/%pushname_full%ʧ��&& pause>nul && ECHO.����... && goto ADBPUSH-COMMON
    ::����С�Ƿ����
set var=unknown
for /f "tokens=2 delims= " %%a in ('adb.exe shell %busyboxpath% stat -t %pushfolder%/%pushname_full% 2^>^&1 ^| find /v "No such file or directory" ^| find "%pushname_full%"') do set var=%%a
if not "%var%"=="%filesize%" ECHOC {%c_e%}����%filepath%��%pushfolder%/%pushname_full%ʧ��. ԭ�ļ���С%filesize%�����ͺ��ļ���С%var%�����. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%filepath%��%pushfolder%/%pushname_full%ʧ��.ԭ�ļ���С%filesize%�����ͺ��ļ���С%var%�����&& pause>nul && ECHO.����... && goto ADBPUSH-COMMON
goto ADBPUSH-DONE
:ADBPUSH-DONE
call log %logger% I adb�������.�ļ�·��:%pushfolder%/%pushname_full%.�����ļ���:%pushname_full%.�ļ���:%pushname%.�ļ���չ��:%pushname_ext%.����Ŀ¼:%pushfolder%
ENDLOCAL & set write__adbpush__filepath=%pushfolder%/%pushname_full%& set write__adbpush__filename_full=%pushname_full%& set write__adbpush__filename=%pushname%& set write__adbpush__folder=%pushfolder%& set write__adbpush__ext=%pushname_ext%
goto :eof


:SIDELOAD
SETLOCAL
set logger=write.bat-sideload
::���ձ���
set zippath=%args2%
call log %logger% I ���ձ���:zippath:%zippath%
:SIDELOAD-1
::����Ƿ����
if not exist %zippath% ECHOC {%c_e%}�Ҳ���%zippath%{%c_i%}{\n}& call log %logger% F �Ҳ���%zippath%& goto FATAL
::��װ
call reboot recovery sideload rechk 3
call log %logger% I ��װ%zippath%
adb.exe sideload %zippath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}��װ%zippath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��װ%zippath%ʧ��&& pause>nul && ECHO.����... && goto SIDELOAD-1
ENDLOCAL
goto :eof


:TWRPINST
SETLOCAL
set logger=write.bat-twrpinst
::���ձ���
set zippath=%args2%
call log %logger% I ���ձ���:zippath:%zippath%
:TWRPINST-1
::����Ƿ����
if not exist %zippath% ECHOC {%c_e%}�Ҳ���%zippath%{%c_i%}{\n}& call log %logger% F �Ҳ���%zippath%& goto FATAL
::����
call log %logger% I ����%zippath%
call write adbpush %zippath% bff.zip common
::adb.exe push %zippath% ./tmp/bff.zip 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%zippath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%zippath%ʧ��&& pause>nul && ECHO.����... && goto TWRPINST-1
::��װ
call log %logger% I ��װ%write__adbpush__filepath%
adb.exe shell twrp install %write__adbpush__filepath% 1>%tmpdir%\output.txt 2>&1 || type %tmpdir%\output.txt>>%logfile% && call log %logger% E ��װ%zippath%ʧ��&& ECHOC {%c_e%}��װ%zippath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& pause>nul && ECHO.����... && goto TWRPINST-1
type %tmpdir%\output.txt>>%logfile%
find "zip" "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}��װ%zippath%ʧ��, TWRPδִ������. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��װ%zippath%ʧ��,TWRPδִ������&& pause>nul && ECHO.����... && goto TWRPINST-1
adb.exe shell rm %write__adbpush__filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%write__adbpush__filepath%ʧ��{%c_i%}{\n}&& call log %logger% E ɾ��%write__adbpush__filepath%ʧ��
ENDLOCAL
goto :eof


:QCEDLXML
SETLOCAL
set logger=write.bat-qcedlxml
::���ձ���
set port=%args2%& set memory=%args3%& set searchpath=%args4%& set xml=%args5%& set fh=%args6%
call log %logger% I ���ձ���:port:%port%.memory:%memory%.searchpath:%searchpath%.xml:%xml%.fh:%fh%
:QCEDLXML-1
::���searchpath�Ƿ����
if not exist %searchpath% ECHOC {%c_e%}�Ҳ���%searchpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%searchpath%& goto FATAL
::�������xml
call log %logger% I ��ʼ����xml
    ::���%tmpdir%\qcedlxml
if exist %tmpdir%\qcedlxml rd /s /q %tmpdir%\qcedlxml 1>>%logfile% 2>&1
md %tmpdir%\qcedlxml 1>>%logfile% 2>&1
    ::��ʼѭ��
set xml_new=& set num=1
:QCEDLXML-PROCESSXML
set var=
for /f "tokens=%num% delims=/" %%a in ('echo.%xml%') do set var=%%a
if "%var%"=="" (
    ::if "%xml_new%"=="" ECHOC {%c_e%}ȱ��xml����{%c_i%}{\n}& call log %logger% F ȱ��xml����& goto FATAL
    set xml=%xml_new%& goto QCEDLXML-FLASH-START)
if exist %searchpath%\%var% set var=%searchpath%\%var%& goto QCEDLXML-PROCESSXML-1
if exist %var% goto QCEDLXML-PROCESSXML-1
ECHOC {%c_e%}�Ҳ���%var%{%c_i%}{\n}& call log %logger% F �Ҳ���%var%& goto FATAL
:QCEDLXML-PROCESSXML-1
    ::����xml��%tmpdir%\qcedlxml\%num%.xml
copy /Y %var% %tmpdir%\qcedlxml\%num%.xml 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%var%��%tmpdir%\qcedlxml\%num%.xmlʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%var%��%tmpdir%\qcedlxml\%num%.xmlʧ��&& pause>nul && ECHO.����... && goto QCEDLXML-PROCESSXML-1
    ::���Ը�ʽ��xml. ��ʽ��ʧ����˵����rawprogram, ������������, ֱ��ʹ��ԭxml
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\%num%.xml -m formatxml -o %tmpdir%\qcedlxml\%num%.xml 1>>%logfile% 2>&1 || goto QCEDLXML-PROCESSXML-NEXT
    ::����xml-�Զ���
call :qcedlxml-xmlcustomprocessing %tmpdir%\qcedlxml\%num%.xml
    ::����xml-ת��sparse��Ŀ. dellineʧ��˵��ԭxml���Ϊsparse, ��ֱ��ɾ��xml����
type %tmpdir%\qcedlxml\%num%.xml | find /v "filename=""""" | find "sparse=""true""" 1>>%tmpdir%\qcedlxml\sparseimg_pre.xml 2>>%logfile% || goto QCEDLXML-PROCESSXML-NEXT
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\%num%.xml -m editxml/delline/sparse/true -o %tmpdir%\qcedlxml\%num%.xml 1>>%logfile% 2>&1 || del %tmpdir%\qcedlxml\%num%.xml 1>>%logfile% 2>&1
:QCEDLXML-PROCESSXML-NEXT
    ::ֻ�д���xml�ŷ���
if exist %tmpdir%\qcedlxml\%num%.xml set xml_new=%xml_new%,%tmpdir%\qcedlxml\%num%.xml
set /a num+=1& goto QCEDLXML-PROCESSXML
    ::����ѭ��
:QCEDLXML-FLASH-START
::��ʼˢ��
    ::����˿ں�Ϊauto���Զ����˿�
if "%port%"=="auto" call chkdev qcedl 1>nul
if "%port%"=="auto" set port=%chkdev__port__qcedl%
    ::��������
if not "%fh%"=="" call write qcedlsendfh %port% %fh% %memory%
    ::����洢����Ϊauto���Զ�ʶ��
if "%memory%"=="auto" (
    call log %logger% I �Զ�ʶ��洢����
    call info qcedl %port%)
if "%memory%"=="auto" (
    set memory=%info__qcedl__memtype%
    call log %logger% I �洢����ʶ��Ϊ%info__qcedl__memtype%)
:QCEDLXML-FLASH-RAW
if "%xml%"=="" call log %logger% I xml����Ϊ��.����ˢ��raw����& goto QCEDLXML-FLASH-SPARSE
::ˢ��raw����
call log %logger% I ˢ��raw����
call :qcedlxml-flash-run %searchpath%
if "%result%"=="n" ECHOC {%c_e%}9008ˢ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E 9008ˢ��ʧ��& pause>nul & ECHO.����... & goto QCEDLXML-FLASH-RAW
:QCEDLXML-FLASH-SPARSE
::ˢ��sparse����
call log %logger% I ˢ��sparse����
    ::��ʽ����ȷ��xml��Ч. ��Ч��ֱ������sparse����
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\sparseimg_pre.xml -m formatxml -o %tmpdir%\qcedlxml\sparseimg_pre.xml 1>>%logfile% 2>&1 || call log %logger% I ����ˢ��sparse����&& goto QCEDLXML-DONE
    ::��ȡsparse��������
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\sparseimg_pre.xml -m readxml/readlinecount 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
set simgcount=
for /f "tokens=2 delims=/ " %%a in ('type %tmpdir%\output.txt ^| find "/result/"') do set simgcount=%%a
if "%simgcount%"=="" ECHOC {%c_e%}��ȡsparse��������ʧ��{%c_i%}{\n}& call log %logger% F ��ȡsparse��������ʧ��& goto FATAL
    ::ѭ�����ˢ��sparse����
set simgnum=1
:QCEDLXML-FLASH-SPARSE-1
        ::���ȳ���fh_loaderֱ��ˢ��
call log %logger% I ˢ��sparse����-����fh_loaderֱ��ˢ�뾵��%simgnum%
            ::׼��xml
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\sparseimg_pre.xml -m readxml/readline/#/%simgnum% 1>%tmpdir%\qcedlxml\sparseimg.xml 2>&1
type %tmpdir%\qcedlxml\sparseimg.xml>>%logfile%
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\sparseimg.xml -m formatxml -o %tmpdir%\qcedlxml\sparseimg.xml 1>>%logfile% 2>&1 || ECHOC {%c_w%}��ʽ��sparse����%simgnum%xmlʧ��. ����ˢ��...{%c_i%}{\n}&& call log %logger% W ��ʽ��sparse����%simgnum%xmlʧ��.����ˢ��&& goto QCEDLXML-FLASH-SPARSE-NEXT
                ::����xml-�Զ���
call :qcedlxml-xmlcustomprocessing %tmpdir%\qcedlxml\sparseimg.xml
set xml=%tmpdir%\qcedlxml\sparseimg.xml
            ::ˢ��
call :qcedlxml-flash-run %searchpath%
if "%result%"=="y" goto QCEDLXML-FLASH-SPARSE-NEXT
        ::fh_loaderֱ��ˢ��ʧ��, ����ˢ��
ECHOC {%c_w%}fh_loaderֱ��ˢ��sparse����%simgnum%ʧ��. ���򿪷��߷���������{%c_i%}{\n}& call log %logger% W fh_loaderֱ��ˢ��sparse����%simgnum%ʧ��.���򿪷��߷���������
call log %logger% I ˢ��sparse����-���Խ���ˢ�뾵��%simgnum%
            ::��ȡ��������
                ::start_sector
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\sparseimg_pre.xml -m readxml/readvalue/#/%simgnum%/start_sector 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
set parstartsec=
for /f "tokens=2 delims=/ " %%a in ('type %tmpdir%\output.txt ^| find "/result/"') do set parstartsec=%%a
if "%parstartsec%"=="" ECHOC {%c_e%}��ȡsparse����%simgnum%start_sectorʧ��. ����ˢ��...{%c_i%}{\n}& call log %logger% E ��ȡsparse����%simgnum%start_sectorʧ��.����ˢ��& goto QCEDLXML-FLASH-SPARSE-NEXT
                ::physical_partition_number
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\sparseimg_pre.xml -m readxml/readvalue/#/%simgnum%/physical_partition_number 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
set parlun=
for /f "tokens=2 delims=/ " %%a in ('type %tmpdir%\output.txt ^| find "/result/"') do set parlun=%%a
if "%parlun%"=="" ECHOC {%c_e%}��ȡsparse����%simgnum%physical_partition_numberʧ��. ����ˢ��...{%c_i%}{\n}& call log %logger% E ��ȡsparse����%simgnum%physical_partition_numberʧ��.����ˢ��& goto QCEDLXML-FLASH-SPARSE-NEXT
                ::filename
qcedlxmlhelper.exe -f %tmpdir%\qcedlxml\sparseimg_pre.xml -m readxml/readvalue/#/%simgnum%/filename 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
set parfilename=
for /f "tokens=2 delims=/ " %%a in ('type %tmpdir%\output.txt ^| find "/result/"') do set parfilename=%%a
if "%parfilename%"=="" ECHOC {%c_e%}��ȡsparse����%simgnum%filenameʧ��. ����ˢ��...{%c_i%}{\n}& call log %logger% E ��ȡsparse����%simgnum%filenameʧ��.����ˢ��& goto QCEDLXML-FLASH-SPARSE-NEXT
            ::�������ļ��Ƿ����
set parfilepath=
if exist %parfilename% set parfilepath=%parfilename%
if exist %searchpath%\%parfilename% set parfilepath=%searchpath%\%parfilename%
if "%parfilepath%"=="" ECHOC {%c_w%}�Ҳ���%parfilename%. ����ˢ��...{%c_i%}{\n}& call log %logger% W �Ҳ���%parfilename%.����ˢ��& goto QCEDLXML-FLASH-SPARSE-NEXT
            ::�������ļ���С�Ƿ�Ϊ0, ��������. ĳЩ���������˹ٷ������0��С�ļ�, ���±���
set var=
for /f "tokens=2 delims= " %%a in ('busybox.exe stat -t %parfilepath%') do set var=%%a
if "%var%"=="0" ECHOC {%c_w%}%parfilename%�ļ���СΪ0. ����ˢ��...{%c_i%}{\n}& call log %logger% W %parfilename%�ļ���СΪ0.����ˢ��& goto QCEDLXML-FLASH-SPARSE-NEXT
            ::���������ļ�(����������sparseimg, �����Զ�����֮ǰ���ɵ�ͬ���ļ�, ��Լ�ռ�)
call log %logger% I ���ڽ���%parfilepath%
simg_dump.exe -f %parfilepath% -m qcedlrawprogram/%parlun%/sparseimg/%parstartsec% -o %tmpdir%\qcedlxml 1>>%logfile% 2>&1 || ECHOC {%c_w%}����%parfilepath%ʧ��. �����˷���...{%c_i%}{\n}&& call log %logger% W ����%parfilepath%ʧ��.�����˷���&& goto QCEDLXML-FLASH-SPARSE-NEXT
            ::����xml-�Զ���
call :qcedlxml-xmlcustomprocessing %tmpdir%\qcedlxml\sparseimg.xml
            ::ˢ������ļ�
set xml=%tmpdir%\qcedlxml\sparseimg.xml
call :qcedlxml-flash-run %tmpdir%\qcedlxml
if "%result%"=="n" ECHOC {%c_w%}ˢ��%parfilename%ʧ��. �����˷���...{%c_i%}{\n}& call log %logger% W ˢ��%parfilename%ʧ��.�����˷���& goto QCEDLXML-FLASH-SPARSE-NEXT
goto QCEDLXML-FLASH-SPARSE-NEXT
:QCEDLXML-FLASH-SPARSE-NEXT
if "%simgnum%"=="%simgcount%" (
    call log %logger% I ˢ��sparse�������
    goto QCEDLXML-DONE)
set /a simgnum+=1& goto QCEDLXML-FLASH-SPARSE-1
:QCEDLXML-DONE
if exist %tmpdir%\qcedlxml rd /s /q %tmpdir%\qcedlxml 1>>%logfile% 2>&1
call log %logger% I 9008ˢ��ȫ�����
ENDLOCAL
goto :eof
::9008ˢ��
:qcedlxml-flash-run
set result=y
call log %logger% I ����9008ˢ��.search_path��sendxml��������:
echo.%1 >>%logfile%
echo.%xml% >>%logfile%
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --search_path=%1 --sendxml=%xml% --mainoutputdir=%tmpdir% --skip_config --showpercentagecomplete --noprompt 1>>%logfile% 2>&1 || call log %logger% E 9008ˢ��ʧ��&& set result=n& goto :eof
::--testvipimpact   --zlpawarehost=1
call log %logger% I 9008ˢ�����
goto :eof
::�Զ��崦��xml
:qcedlxml-xmlcustomprocessing
::���ڴ˴���Ӷ�rawprogram xml���Զ��崦��. ��Ҫ�����xml·���ı���Ϊ%1. ע��: ������xmlҪ����ԭ�ļ�.
goto :eof


:QCEDL
SETLOCAL
set logger=write.bat-qcedl
::���ձ���
set parname=%args2%& set filepath=%args3%& set port=%args4%& set fh=%args5%
call log %logger% I ���ձ���:parname:%parname%.filepath:%filepath%.port:%port%.fh:%fh%
::���img�Ƿ����, ��ȡ�ļ����������ļ���·��
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
for %%a in ("%filepath%") do set filepath_fullname=%%~nxa
for %%a in ("%filepath%") do set var=%%~dpa
set filepath_folder=%var:~0,-1%
::���img�Ƿ�sparse
set sparse=false
simg_dump.exe -f %filepath% -m basicinfo 1>>%logfile% 2>&1 && set sparse=true
::����˿ں�Ϊauto������Զ����˿�
if not "%port%"=="auto" (if not "%port%"=="" goto QCEDL-2)
call chkdev qcedl 1>nul
set port=%chkdev__port__qcedl%
:QCEDL-2
::��������
if not "%fh%"=="" call write qcedlsendfh %port% %fh% auto
::��ȡ�豸��Ϣ
call info qcedl %port%
::�ض�, �����������ļ�
if exist %tmpdir%\ptanalyse rd /s /q %tmpdir%\ptanalyse 1>>%logfile% 2>&1
md %tmpdir%\ptanalyse 1>>%logfile% 2>&1
set num=0
:QCEDL-3
if "%num%"=="%info__qcedl__lunnum%" ECHOC {%c_e%}�Ҳ�������%parname%{%c_e%}& call log %logger% F �Ҳ�������%parname%& goto FATAL
call log %logger% I �ض�����������%num%
call partable qcedl readgpt %port% %info__qcedl__memtype% %num% main %tmpdir%\ptanalyse\gpt_main%num%.bin noprompt
ptanalyzer.exe -f %tmpdir%\ptanalyse\gpt_main%num%.bin -m %info__qcedl__memtype% -t gptmain -o normal_clear 1>%tmpdir%\output.txt 2>&1 || type %tmpdir%\output.txt>>%logfile% && ECHOC {%c_e%}����������%num%ʧ��{%c_e%}&& call log %logger% F ����������%num%ʧ��&& goto FATAL
type %tmpdir%\output.txt>>%logfile%
set parsizesec=
for /f "tokens=3,5 delims=[] " %%a in ('type %tmpdir%\output.txt ^| find "] %parname% "') do set parstartsec=%%a& set parsizesec=%%b
if "%parsizesec%"=="" set /a num+=1& goto QCEDL-3
::�ҵ�Ŀ�����, ��ʼˢ��
call log %logger% I ����9008ˢ��%filepath%.lun:%num%.��ʼ����:%parstartsec%.������Ŀ:%parsizesec%
::���ڲ����豸ֻ��ʹ��xmlˢ��, ������xml
echo.^<?xml version="1.0" ?^>^<data^>^<program filename="%filepath_fullname%" physical_partition_number="%num%" label="%parname%" start_sector="%parstartsec%" num_partition_sectors="%parsizesec%" SECTOR_SIZE_IN_BYTES="%info__qcedl__secsize%" sparse="%sparse%"/^>^</data^>>%tmpdir%\tmp.xml
call write qcedlxml %port% %info__qcedl__memtype% %filepath_folder% %tmpdir%\tmp.xml
call log %logger% I 9008ˢ�����
ENDLOCAL
goto :eof


:SYSTEM
SETLOCAL
set logger=write.bat-system
set target=system
goto ADBDD


:RECOVERY
SETLOCAL
set logger=write.bat-recovery
set target=recovery
goto ADBDD


:ADBDD
::���ձ���
set parname=%args2%& set imgpath=%args3%
call log %logger% I ���ձ���:parname:%parname%.imgpath:%imgpath%
:ADBDD-1
::����ļ�
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
::ϵͳ��Ҫ���Root
if "%target%"=="system" (
    call log %logger% I ��ʼ���Root
    echo.su>%tmpdir%\cmd.txt& echo.exit>>%tmpdir%\cmd.txt& echo.exit>>%tmpdir%\cmd.txt
    adb.exe shell < %tmpdir%\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡRootʧ��. �����Ƿ���ΪShell��ȨRootȨ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡRootʧ��&& pause>nul && ECHO.����... && goto ADBDD-1)
::����
call log %logger% I ��ʼ����%imgpath%
call write adbpush %imgpath% %parname%.img common
::adb.exe push %imgpath% %target%/%parname%.img 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%imgpath%��%target%/%parname%.imgʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%imgpath%��%target%/%parname%.imgʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
::��ȡ����·��
call info par %parname%
::ˢ�������
if "%target%"=="system" echo.su>%tmpdir%\cmd.txt& echo.dd if=%write__adbpush__filepath% of=%info__par__path% >>%tmpdir%\cmd.txt& echo.rm %write__adbpush__filepath%>>%tmpdir%\cmd.txt
if "%target%"=="recovery" echo.dd if=%write__adbpush__filepath% of=%info__par__path% >%tmpdir%\cmd.txt& echo.rm %write__adbpush__filepath%>>%tmpdir%\cmd.txt
echo.exit>>%tmpdir%\cmd.txt & echo.exit>>%tmpdir%\cmd.txt
call log %logger% I ��ʼˢ��%write__adbpush__filepath%��%info__par__path%
adb.exe shell < %tmpdir%\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}ˢ��%write__adbpush__filepath%��%info__par__path%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ˢ��%write__adbpush__filepath%��%info__par__path%ʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
ENDLOCAL
goto :eof


:FASTBOOT
SETLOCAL
set logger=write.bat-fastboot
::���ձ���
set parname=%args2%& set imgpath=%args3%
call log %logger% I ���ձ���:parname:%parname%.imgpath:%imgpath%
:FASTBOOT-1
::����ļ�
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
::ˢ��
call log %logger% I ��ʼˢ��%imgpath%��%parname%
fastboot.exe flash %parname% %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ˢ��%imgpath%��%parname%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ˢ��%imgpath%��%parname%ʧ��&& pause>nul && ECHO.����... && goto FASTBOOT-1
ENDLOCAL
goto :eof


:FASTBOOTD
SETLOCAL
set logger=write.bat-fastbootd
::���ձ���
set parname=%args2%& set imgpath=%args3%
call log %logger% I ���ձ���:parname:%parname%.imgpath:%imgpath%
:FASTBOOTD-1
::����ļ�
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
::ˢ��
call log %logger% I ��ʼˢ��%imgpath%��%parname%
fastboot.exe flash %parname% %imgpath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ˢ��%imgpath%��%parname%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ˢ��%imgpath%��%parname%ʧ��&& pause>nul && ECHO.����... && goto FASTBOOTD-1
ENDLOCAL
goto :eof


:FASTBOOTBOOT
SETLOCAL
set logger=write.bat-fastbootboot
::���ձ���
set imgpath=%args2%
call log %logger% I ���ձ���:imgpath:%imgpath%
:FASTBOOTBOOT-1
::����ļ�
if not exist %imgpath% ECHOC {%c_e%}�Ҳ���%imgpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%imgpath%& goto FATAL
::��ʱ����
call log %logger% I ����%imgpath%
fastboot.exe boot %imgpath% 1>>%logfile% 2>&1 && goto FASTBOOTBOOT-DONE
ECHOC {%c_e%}����%imgpath%ʧ��{%c_i%}{\n}& call log %logger% E ����%imgpath%ʧ��
ECHO.1.�豸û�н���Ŀ��ģʽ, ���³�����ʱ����
ECHO.2.�ű��ж�����, �豸�ѽ���Ŀ��ģʽ, ���Լ���
call input choice [1][2]
if "%choice%"=="2" goto FASTBOOTBOOT-DONE
call chkdev fastboot
ECHO.���³�����ʱ����...
goto FASTBOOTBOOT-1
:FASTBOOTBOOT-DONE
ENDLOCAL
goto :eof








:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

