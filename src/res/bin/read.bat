::�޸�: n

::call read system        ������             �ļ�����·��(�����ļ���)                 noprompt(��ѡ)
::          recovery      ������             �ļ�����·��(�����ļ���)                 noprompt(��ѡ)
::          qcedl         ������             �ļ�����·��(�����ļ���)                 noprompt��notice   �˿ں�(���ֻ�auto)  firehose����·��(��ѡ,�������)
::          qcedlxml      �˿ں�(���ֻ�auto)  �洢����(ָ����auto)                    img����ļ���       xml·��            firehose����·��(��ѡ,�������)
::          qcdiag        �˿ں�(���ֻ�auto)  �ļ�����·��(�����ļ���)                 noprompt(��ѡ)
::          adbpull       Դ�ļ�·��          �ļ�����·��(�����ļ���)                 noprompt(��ѡ)

@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
goto %args1%





:ADBPULL
SETLOCAL
set logger=read.bat-adbpull
::���ձ���
set filepath=%args2%& set outputpath=%args3%& set mode=%args4%
call log %logger% I ���ձ���:filepath:%filepath%.outputpath:%outputpath%.mode:%mode%
:ADBPULL-1
::��鱣��·���Ƿ����
if exist %outputpath% (if not "%mode%"=="noprompt" ECHOC {%c_w%}�Ѵ���%outputpath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%outputpath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::��ȡ�����ļ���
for %%a in ("%outputpath%") do set outputpath_fullname=%%~nxa
::��ȡ����Ŀ¼
for %%a in ("%outputpath%") do set var=%%~dpa
set outputpath_folder=%var:~0,-1%
::��ȡ�ļ�
call log %logger% I ������ȡ%filepath%��%outputpath%
cd /d %outputpath_folder% || ECHOC {%c_e%}����Ŀ¼%outputpath_folder%ʧ��{%c_i%}{\n}&& call log %logger% F ����Ŀ¼%outputpath_folder%ʧ��&& goto FATAL
adb.exe pull %filepath% %outputpath_fullname% 1>>%logfile% 2>&1 || cd /d %framework_workspace%&& ECHOC {%c_e%}��ȡ%filepath%��%outputpath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡ%filepath%��%outputpath%ʧ��&& pause>nul && ECHO.����... && goto ADBPULL-1
cd /d %framework_workspace% || ECHOC {%c_e%}����Ŀ¼%framework_workspace%ʧ��{%c_i%}{\n}&& goto FATAL
::���
call log %logger% I ��ȡ%filepath%��%outputpath%���
ENDLOCAL
goto :eof


:QCDIAG
SETLOCAL
set logger=read.bat-qcdiag
::���ձ���
set port=%args2%& set filepath=%args3%& set mode=%args4%
call log %logger% I ���ձ���:port:%port%.filepath:%filepath%.mode:%mode%
:QCDIAG-1
::��ȡ�ļ���
for %%a in ("%filepath%") do set filepath_fullname=%%~nxa
::���qcn����Ŀ¼, qcn�Ƿ����
for %%a in ("%filepath%") do set var=%%~dpa
set filepath_folder=%var:~0,-1%
if not exist %filepath_folder% ECHOC {%c_e%}�Ҳ���%filepath_folder%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath_folder%& goto FATAL
if exist %filepath% (if not "%mode%"=="noprompt" ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::����˿ں�Ϊauto���Զ����˿�
if "%port%"=="auto" call chkdev qcdiag 1>nul
if "%port%"=="auto" set port=%chkdev__port__qcdiag%
::��ʼ����qcn
call log %logger% I ��ʼ�ض�QCN��%filepath%
QCNTool.exe -r -p %port% -f %filepath_folder% -n %filepath_fullname% 1>%tmpdir%\output.txt 2>&1
::ע��: ԭʼ����а����豸IMEI, �粻ϣ����ԭʼ������浽��־, �뽫����һ��type����ע�͵�
type %tmpdir%\output.txt>>%logfile%
find "Reading QCN from phone... OK" "%tmpdir%\output.txt" 1>nul 2>nul || ECHOC {%c_e%}�ض�QCN��%filepath%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E �ض�QCN��%filepath%ʧ��&& pause>nul && ECHO.����... && goto QCDIAG-1
call log %logger% I �ض�QCN��%filepath%���
ENDLOCAL
goto :eof


:QCEDL
SETLOCAL
set logger=read.bat-qcedl
::���ձ���
set parname=%args2%& set filepath=%args3%& set mode=%args4%& set port=%args5%& set fh=%args6%
call log %logger% I ���ձ���:parname:%parname%.filepath:%filepath%.mode:%mode%.port:%port%.fh:%fh%
:QCEDL-1
::��ȡ�ļ���
for %%a in ("%filepath%") do set filepath_fullname=%%~nxa
::���img����Ŀ¼��img�Ƿ����
for %%a in ("%filepath%") do set var=%%~dpa
set filepath_folder=%var:~0,-1%
if not exist %filepath_folder% ECHOC {%c_e%}�Ҳ���%filepath_folder%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath_folder%& goto FATAL
if exist %filepath% (if not "%mode%"=="noprompt" ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::����˿ں�Ϊauto������Զ����˿�
if "%port%"=="auto" call chkdev qcedl 1>nul
if "%port%"=="auto" set port=%chkdev__port__qcedl%
if "%port%"=="" call chkdev qcedl 1>nul
if "%port%"=="" set port=%chkdev__port__qcedl%
::��������
if not "%fh%"=="" call write qcedlsendfh %port% %fh% auto
::��ȡ�豸��Ϣ
call info qcedl %port%
::�ض�, �����������ļ�
if exist %tmpdir%\ptanalyse rd /s /q %tmpdir%\ptanalyse 1>>%logfile% 2>&1
md %tmpdir%\ptanalyse 1>>%logfile% 2>&1
set num=0
:QCEDL-2
if "%num%"=="%info__qcedl__lunnum%" ECHOC {%c_e%}�Ҳ�������%parname%{%c_e%}& call log %logger% F �Ҳ�������%parname%& goto FATAL
call log %logger% I �ض�����������%num%
call partable qcedl readgpt %port% %info__qcedl__memtype% %num% main %tmpdir%\ptanalyse\gpt_main%num%.bin noprompt
ptanalyzer.exe -f %tmpdir%\ptanalyse\gpt_main%num%.bin -m %info__qcedl__memtype% -t gptmain -o normal_clear 1>%tmpdir%\output.txt 2>&1 || type %tmpdir%\output.txt>>%logfile% && ECHOC {%c_e%}����������%num%ʧ��{%c_e%}&& call log %logger% F ����������%num%ʧ��&& goto FATAL
type %tmpdir%\output.txt>>%logfile%
set parsizesec=
for /f "tokens=3,5 delims=[] " %%a in ('type %tmpdir%\output.txt ^| find "] %parname% "') do set parstartsec=%%a& set parsizesec=%%b
if "%parsizesec%"=="" set /a num+=1& goto QCEDL-2
::�ҵ�Ŀ�����, ��ʼ�ض�
call log %logger% I ����9008�ض�%filepath%.lun:%num%.��ʼ����:%parstartsec%.������Ŀ:%parsizesec%
::���ڲ����豸ֻ��ʹ��xml�ض�, ������xml
echo.^<?xml version="1.0" ?^>^<data^>^<program filename="%filepath_fullname%" physical_partition_number="%num%" label="%parname%" start_sector="%parstartsec%" num_partition_sectors="%parsizesec%" SECTOR_SIZE_IN_BYTES="%info__qcedl__secsize%" sparse="false"/^>^</data^>>%tmpdir%\tmp.xml
call read qcedlxml %port% %info__qcedl__memtype% %filepath_folder% %tmpdir%\tmp.xml
call log %logger% I 9008�ض����
ENDLOCAL
goto :eof


:QCEDLXML
SETLOCAL
set logger=read.bat-qcedlxml
::���ձ���
set port=%args2%& set memory=%args3%& set folderpath=%args4%& set xml=%args5%& set fh=%args6%
call log %logger% I ���ձ���:port:%port%.memory:%memory%.folderpath:%folderpath%.xml:%xml%.fh:%fh%
:QCEDLXML-1
::��鱣��Ŀ¼�Ƿ����
if not exist %folderpath% ECHOC {%c_e%}�Ҳ���%folderpath%{%c_i%}{\n}& call log %logger% F �Ҳ���%folderpath%& goto FATAL
::����xml
echo.%xml%>%tmpdir%\output.txt
for /f %%a in ('busybox.exe sed "s/\//,/g" %tmpdir%\output.txt') do set xml=%%a
call log %logger% I xml��������Ϊ:
echo.%xml%>>%logfile%
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
::��ʼ�ض�
call log %logger% I ����9008�ض�
fh_loader.exe --port=\\.\COM%port% --memoryname=%memory% --sendxml=%xml% --convertprogram2read --mainoutputdir=%folderpath% --skip_config --showpercentagecomplete --noprompt 1>>%logfile% 2>&1 || ECHOC {%c_e%}9008�ض�ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E 9008�ض�ʧ��&& pause>nul && ECHO.����... && goto QCEDLXML-1
move /Y %folderpath%\port_trace.txt %tmpdir% 1>>%logfile% 2>&1
call log %logger% I 9008�ض����
ENDLOCAL
goto :eof


:SYSTEM
SETLOCAL
set logger=read.bat-system
set target=./sdcard
goto ADBDD


:RECOVERY
SETLOCAL
set logger=read.bat-recovery
set target=./tmp
goto ADBDD


:ADBDD
::���ձ���
set parname=%args2%& set filepath=%args3%& set mode=%args4%
call log %logger% I ���ձ���:parname:%parname%.filepath:%filepath%.mode:%mode%
:ADBDD-1
::���Ŀ¼
::if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
if exist %filepath% (if not "%mode%"=="noprompt" ECHOC {%c_w%}�Ѵ���%filepath%, ���������Ǵ��ļ�. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% W �Ѵ���%filepath%.���������Ǵ��ļ�& pause>nul & ECHO.����...)
::ϵͳ��Ҫ���Root
if "%target%"=="./sdcard" (
    call log %logger% I ��ʼ���Root
    echo.su>%tmpdir%\cmd.txt& echo.exit>>%tmpdir%\cmd.txt& echo.exit>>%tmpdir%\cmd.txt
    adb.exe shell < %tmpdir%\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}��ȡRootʧ��. �����Ƿ���ΪShell��ȨRootȨ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ��ȡRootʧ��&& pause>nul && ECHO.����... && goto ADBDD-1)
::��ȡ����·��
call info par %parname%
::����
if "%target%"=="./sdcard" echo.su>%tmpdir%\cmd.txt& echo.dd if=%info__par__path% of=%target%/%parname%.img >>%tmpdir%\cmd.txt
if "%target%"=="./tmp" echo.dd if=%info__par__path% of=%target%/%parname%.img >%tmpdir%\cmd.txt
echo.exit>>%tmpdir%\cmd.txt& echo.exit>>%tmpdir%\cmd.txt
call log %logger% I ��ʼ����%parname%��%target%/%parname%.img
adb.exe shell < %tmpdir%\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}����%parname%��%target%/%parname%.imgʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ����%parname%��%target%/%parname%.imgʧ��&& pause>nul && ECHO.����... && goto ADBDD-1
::��ȡ
call log %logger% I ��ʼ��ȡ%target%/%parname%.img��%filepath%
call read adbpull %target%/%parname%.img %filepath% noprompt
::����
call log %logger% I ��ʼɾ��%target%/%parname%.img
if "%target%"=="./sdcard" echo.su>%tmpdir%\cmd.txt& echo.rm %target%/%parname%.img>>%tmpdir%\cmd.txt
if "%target%"=="./tmp" echo.rm %target%/%parname%.img>%tmpdir%\cmd.txt
echo.exit>>%tmpdir%\cmd.txt& echo.exit>>%tmpdir%\cmd.txt
adb.exe shell < %tmpdir%\cmd.txt 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%target%/%parname%.imgʧ��.{%c_i%}{\n}&& call log %logger% E ɾ��%target%/%parname%.imgʧ��
ENDLOCAL
goto :eof









:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)

