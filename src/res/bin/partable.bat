::�޸�: n

::call partable recovery mkpar             ����·��            ������                  ����            start         [end:xxx(Ĭ��)��size:xxx]  ���(��ѡ,Ĭ��Ϊ�׸����õ�)
::              recovery rmpar             ����·��            [name:xxx��numb:xx]
::              recovery setmaxparnum      ����·��            Ŀ�������(��ѡ,Ĭ��128)
::              recovery sgdiskbakpartable ����·��            ����·��(�����ļ���)     noprompt(��ѡ)
::              system   sgdiskbakpartable ����·��            ����·��(�����ļ���)     noprompt(��ѡ)
::              recovery sgdiskrecpartable ����·��            �ļ�·��
::              qcedl    readgpt           �˿ں�(���ֻ�auto)  [ufs emmc spinor auto] Ŀ��lun���     [main backup]  �ļ�����·��               [notice noprompt]              firehose·��(��ѡ,�������)
::              qcedl    writegpt          �˿ں�(���ֻ�auto)  [ufs emmc spinor auto] Ŀ��lun���     [main backup]  �ļ�·��                   firehose·��(��ѡ,�������)


@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
goto %args1%-%args2%







:QCEDL-WRITEGPT
SETLOCAL
set logger=partable.bat-qcedl-writegpt
set port=%args3%& set memtype=%args4%& set lun=%args5%& set gpttype=%args6%& set filepath=%args7%& set fh=%args8%
call log %logger% I ���ձ���:port:%port%.memtype:%memtype%.lun:%lun%.gpttype:%gpttype%.filepath:%filepath%.fh:%fh%
:QCEDL-WRITEGPT-1
::����ļ��Ƿ����
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
::��ȡ�ļ���������Ŀ¼
for %%a in ("%filepath%") do set filepath_fullname=%%~nxa
for %%a in ("%filepath%") do set var=%%~dpa
set filepath_folder=%var:~0,-1%
::����˿ں�Ϊauto���Զ����˿�
if "%port%"=="auto" call chkdev qcedl 1>nul
if "%port%"=="auto" set port=%chkdev__port__qcedl%
::��������
if not "%fh%"=="" call write qcedlsendfh %port% %fh% auto
::ȷ���洢���ͺ�������С
set secsize=
if "%memtype%"=="emmc" set secsize=512
if "%memtype%"=="ufs" set secsize=4096
if "%memtype%"=="spinor" set secsize=4096
if "%memtype%"=="auto" call info qcedl %port%
if "%memtype%"=="auto" set memtype=%info__qcedl__memtype%& set secsize=%info__qcedl__secsize%
if "%secsize%"=="" ECHOC {%c_e%}��������{%c_i%}{\n}& call log %logger% F ��������& goto FATAL
::����xml
if not "%gpttype%"=="backup" (
    if "%secsize%"=="4096"     echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="%filepath_fullname%" physical_partition_number="%lun%" label="PrimaryGPT" start_sector="0"                    num_partition_sectors="6" /^>^</data^>>%tmpdir%\tmp.xml
    if not "%secsize%"=="4096" echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="%filepath_fullname%" physical_partition_number="%lun%" label="PrimaryGPT" start_sector="0"                    num_partition_sectors="34"/^>^</data^>>%tmpdir%\tmp.xml)
if "%gpttype%"=="backup" (
    if "%secsize%"=="4096"     echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="%filepath_fullname%" physical_partition_number="%lun%" label="BackupGPT"  start_sector="NUM_DISK_SECTORS-5."  num_partition_sectors="5" /^>^</data^>>%tmpdir%\tmp.xml
    if not "%secsize%"=="4096" echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="%filepath_fullname%" physical_partition_number="%lun%" label="BackupGPT"  start_sector="NUM_DISK_SECTORS-33." num_partition_sectors="33"/^>^</data^>>%tmpdir%\tmp.xml)
::��ʼˢ��
call log %logger% I ����9008ˢ�������%gpttype%%lun%
fh_loader.exe --port=\\.\COM%port% --memoryname=%memtype% --sendxml=%tmpdir%\tmp.xml --search_path=%filepath_folder% --mainoutputdir=%tmpdir% --skip_config --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008ˢ�������%gpttype%%lun%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008ˢ�������%gpttype%%lun%ʧ��&& pause>nul && ECHO.����... && goto QCEDL-WRITEGPT-1
call log %logger% I 9008ˢ�������%gpttype%%lun%���
ENDLOCAL
goto :eof


:QCEDL-READGPT
SETLOCAL
set logger=partable.bat-qcedl-readgpt
set port=%args3%& set memtype=%args4%& set lun=%args5%& set gpttype=%args6%& set filepath=%args7%& set mode=%args8%& set fh=%args9%
call log %logger% I ���ձ���:port:%port%.memtype:%memtype%.lun:%lun%.gpttype:%gpttype%.filepath:%filepath%.mode:%mode%.fh:%fh%
:QCEDL-READGPT-1
::��ȡ�ļ���
for %%a in ("%filepath%") do set filepath_fullname=%%~nxa
::����ļ�����Ŀ¼�Ƿ����
for %%a in ("%filepath%") do set var=%%~dpa
set filepath_folder=%var:~0,-1%
if not exist %filepath_folder% ECHOC {%c_e%}�Ҳ���%filepath_folder%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath_folder%& goto FATAL
::����ļ��Ƿ����
if exist %filepath% (if not "%mode%"=="noprompt" ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::��������
if not "%fh%"=="" call write qcedlsendfh %port% %fh% auto
::ȷ���洢���ͺ�������С
set secsize=
if "%memtype%"=="emmc" set secsize=512
if "%memtype%"=="ufs" set secsize=4096
if "%memtype%"=="spinor" set secsize=4096
if "%memtype%"=="auto" call info qcedl %port%
if "%memtype%"=="auto" set memtype=%info__qcedl__memtype%& set secsize=%info__qcedl__secsize%
if "%secsize%"=="" ECHOC {%c_e%}��������{%c_i%}{\n}& call log %logger% F ��������& goto FATAL
::����xml
if not "%gpttype%"=="backup" (
    if "%secsize%"=="4096"     echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="%filepath_fullname%" physical_partition_number="%lun%" label="PrimaryGPT" start_sector="0"                    num_partition_sectors="6" /^>^</data^>>%tmpdir%\tmp.xml
    if not "%secsize%"=="4096" echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="%filepath_fullname%" physical_partition_number="%lun%" label="PrimaryGPT" start_sector="0"                    num_partition_sectors="34"/^>^</data^>>%tmpdir%\tmp.xml)
if "%gpttype%"=="backup" (
    if "%secsize%"=="4096"     echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="%filepath_fullname%" physical_partition_number="%lun%" label="BackupGPT"  start_sector="NUM_DISK_SECTORS-5."  num_partition_sectors="5" /^>^</data^>>%tmpdir%\tmp.xml
    if not "%secsize%"=="4096" echo.^<?xml version="1.0" ?^>^<data^>^<program SECTOR_SIZE_IN_BYTES="%secsize%" filename="%filepath_fullname%" physical_partition_number="%lun%" label="BackupGPT"  start_sector="NUM_DISK_SECTORS-33." num_partition_sectors="33"/^>^</data^>>%tmpdir%\tmp.xml)
::��ʼˢ��
call log %logger% I ����9008�ض�������%gpttype%%lun%
fh_loader.exe --port=\\.\COM%port% --memoryname=%memtype% --sendxml=%tmpdir%\tmp.xml --convertprogram2read --mainoutputdir=%filepath_folder% --skip_config --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008�ض�������%gpttype%%lun%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008�ض�������%gpttype%%lun%ʧ��&& pause>nul && ECHO.����... && goto QCEDL-READGPT-1
move /Y %filepath_folder%\port_trace.txt %tmpdir% 1>>%logfile% 2>&1
call log %logger% I 9008�ض�������%gpttype%%lun%���
ENDLOCAL
goto :eof


:RECOVERY-SGDISKRECPARTABLE
SETLOCAL
set logger=partable.bat-recovery-sgdiskrecpartable
set diskpath=%args3%& set filepath=%args4%
call log %logger% I ���ձ���:diskpath:%diskpath%.filepath:%filepath%
:RECOVERY-SGDISKRECPARTABLE-1
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
call framework adbpre sgdisk
call write adbpush %filepath% bff_sgdiskpartable.bak common
::adb.exe push %filepath% ./bff_sgdiskpartable.bak 1>>%logfile% 2>&1 || ECHOC {%c_e%}���ͷ�����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���ͷ�����ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-SGDISKRECPARTABLE-1
adb.exe shell ./sgdisk -l %write__adbpush__filepath% %diskpath% 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "The operation has completed successfully." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}�ָ�������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ָ�������ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-SGDISKRECPARTABLE-1
call log %logger% I �ָ����������
ENDLOCAL
goto :eof


:RECOVERY-SGDISKBAKPARTABLE
SETLOCAL
set logger=partable.bat-recovery-sgdiskbakpartable
set diskpath=%args3%& set filepath=%args4%& set mode=%args5%
call log %logger% I ���ձ���:diskpath:%diskpath%.filepath:%filepath%.mode:%mode%
if not "%mode%"=="noprompt" (if exist %filepath% ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
:RECOVERY-SGDISKBAKPARTABLE-1
call framework adbpre sgdisk
adb.exe shell ./sgdisk -b ./bff_sgdiskpartable.bak %diskpath% 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "The operation has completed successfully." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}���ݷ�����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���ݷ�����ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-SGDISKBAKPARTABLE-1
call read adbpull ./bff_sgdiskpartable.bak %filepath% noprompt
call log %logger% I ���ݷ��������
ENDLOCAL
goto :eof


:SYSTEM-SGDISKBAKPARTABLE
SETLOCAL
set logger=partable.bat-system-sgdiskbakpartable
set diskpath=%args3%& set filepath=%args4%& set mode=%args5%
call log %logger% I ���ձ���:diskpath:%diskpath%.filepath:%filepath%.mode:%mode%
if not "%mode%"=="noprompt" (if exist %filepath% ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
:SYSTEM-SGDISKBAKPARTABLE-1
call framework adbpre sgdisk
echo.su>%tmpdir%\cmd.txt
echo../data/local/tmp/sgdisk -b ./data/local/tmp/bff_sgdiskpartable.bak %diskpath% >>%tmpdir%\cmd.txt
echo.mv ./data/local/tmp/bff_sgdiskpartable.bak ./sdcard/bff_sgdiskpartable.bak>>%tmpdir%\cmd.txt
echo.exit>>%tmpdir%\cmd.txt & echo.exit>>%tmpdir%\cmd.txt
adb.exe shell < %tmpdir%\cmd.txt 1>>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "The operation has completed successfully." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}���ݷ�����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���ݷ�����ʧ��&& pause>nul && ECHO.����... && goto SYSTEM-SGDISKBAKPARTABLE-1
call read adbpull ./sdcard/bff_sgdiskpartable.bak %filepath% noprompt
call log %logger% I ���ݷ��������
ENDLOCAL
goto :eof


:RECOVERY-MKPAR
SETLOCAL
set logger=partable.bat-recovery-mkpar
set diskpath=%args3%& set parname=%args4%& set partype=%args5%& set parstart=%args6%& set parenddata=%args7%& set parnum=%args8%
call log %logger% I ���ձ���:parname:%parname%.partype:%partype%.parstart:%parstart%.parenddata:%parenddata%.parnum:%parnum%
call framework adbpre sgdisk
if not "%parnum%"=="" goto RECOVERY-MKPAR-3
:RECOVERY-MKPAR-1
call log %logger% I ��ʼ��ȡ���õķ������
adb.exe shell ./sgdisk -p %diskpath% 1>%tmpdir%\output.txt 2>&1 || ECHOC {%c_e%}��ȡ���õķ������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& type %tmpdir%\output.txt>>%logfile% && call log %logger% E ��ȡ���õķ������ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-MKPAR-1
type %tmpdir%\output.txt>>%logfile%
if exist %tmpdir%\output2.txt del %tmpdir%\output2.txt 1>nul
for /f "tokens=1 delims= " %%a in ('type %tmpdir%\output.txt ^| find "  " ^| find /v "Number"') do echo.[%%a]>>%tmpdir%\output2.txt
set num=1
:RECOVERY-MKPAR-2
find "[%num%]" "%tmpdir%\output2.txt" 1>nul 2>nul || set parnum=%num%&& goto RECOVERY-MKPAR-3
set /a num+=1& goto RECOVERY-MKPAR-2
:RECOVERY-MKPAR-3
call log %logger% I ��ʼ��ȡ����������С& call info disk %diskpath%
call log %logger% I ��ʼ�����������
::����parenddata��ȡparend
set parend=
if "%parenddata:~0,4%"=="end:" set parend=%parenddata:~4,999%
if "%parenddata:~0,5%"=="size:" call calc p var    nodec %parstart% %parenddata:~5,999%
if "%parenddata:~0,5%"=="size:" call calc s parend nodec %var%      %info__disk__secsize%
::if "%parend%"=="" ECHOC {%c_e%}��������{%c_i%}{\n}& call log %logger% F ��������& goto FATAL
if "%parend%"=="" set parend=%parenddata%
call calc b2sec parstart_sec nodec %parstart% %info__disk__secsize%
call calc b2sec parend_sec nodec %parend% %info__disk__secsize%
:RECOVERY-MKPAR-4
call log %logger% I ��ʼ��������.���:%parnum%.start����:%parstart_sec%.end����:%parend_sec%
adb.exe shell ./sgdisk -n %parnum%:%parstart_sec%:%parend_sec% %diskpath% 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "The operation has completed successfully." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-MKPAR-4
:RECOVERY-MKPAR-5
call log %logger% I ��ʼ��������
adb.exe shell ./sgdisk -c %parnum%:%parname% %diskpath% 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "The operation has completed successfully." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}��������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-MKPAR-5
:RECOVERY-MKPAR-6
call log %logger% I ��ʼ���÷�������
adb.exe shell ./sgdisk -t %parnum%:%partype% %diskpath% 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "The operation has completed successfully." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}���÷�������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ���÷�������ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-MKPAR-6
::call reboot recovery recovery rechk 3
call log %logger% I �����������
ENDLOCAL
goto :eof


:RECOVERY-RMPAR
SETLOCAL
set logger=partable.bat-recovery-rmpar
set diskpath=%args3%& set target=%args4%
call log %logger% I ���ձ���:diskpath:%diskpath%.target:%target%
call framework adbpre sgdisk
if "%target:~0,4%"=="numb" set parnum=%target:~5,999%& goto RECOVERY-RMPAR-2
:RECOVERY-RMPAR-1
call log %logger% I ��ʼ��ȡ�������.������Ϊ%target:~5,999%
call info par %target:~5,999%
set parnum=%info__par__num%
goto RECOVERY-RMPAR-2
:RECOVERY-RMPAR-2
call log %logger% I ��ʼɾ������.Ŀ����Ϊ%parnum%
adb.exe shell ./sgdisk -d %parnum% %diskpath% 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "The operation has completed successfully." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}ɾ������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ������ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-RMPAR-2
::call reboot recovery recovery rechk 3
call log %logger% I ɾ���������
ENDLOCAL
goto :eof


:RECOVERY-SETMAXPARNUM
SETLOCAL
set logger=partable.bat-recovery-setmaxparnum
set diskpath=%args3%& set target=%args4%
if "%target%"=="" set target=128
call log %logger% I ���ձ���:diskpath:%diskpath%.target:%target%
call framework adbpre sgdisk
:RECOVERY-SETMAXPARNUM-1
call log %logger% I ��ʼ������������
adb.exe shell ./sgdisk --resize-table=%target% %diskpath% 1>%tmpdir%\output.txt 2>&1
type %tmpdir%\output.txt>>%logfile%
find "The operation has completed successfully." "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}������������ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ������������ʧ��&& pause>nul && ECHO.����... && goto RECOVERY-SETMAXPARNUM-1
call log %logger% I ���������������
ENDLOCAL
goto :eof















:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)


