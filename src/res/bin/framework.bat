::�޸�: n

::call framework  startpre     skiptoolchk(��ѡ)
::                adbpre       [�ļ��� all]
::                theme        ������
::                conf         �����ļ���         ������        ����ֵ
::                logviewer    end
::                loadcsvconf  csv�ļ�·��        [Ҫ���ص���]  [orig full](�����������ʽ)
::                chkdiskspace [�̷� cur]         Ҫ�ȽϵĴ�С

::start framework logviewer start                %logfile%


@ECHO OFF
set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
goto %args1%




:CHKDISKSPACE
SETLOCAL
set logger=framework.bat-chkdiskspace
set letter=%args2%& set sizetocompare=%args3%
call log %logger% I ���ձ���:letter:%letter%.sizetocompare:%sizetocompare%
if not "%letter%"=="cur" goto CHKDISKSPACE-1
set letter=
for %%a in ("%framework_workspace%") do set letter=%%~da
:CHKDISKSPACE-1
if "%letter%"=="" ECHOC {%c_e%}�̷�����ȱʧ���ȡʧ��{%c_i%}{\n}& call log %logger% F �̷�����ȱʧ���ȡʧ��& goto FATAL
call log %logger% I ��������%letter%
busybox.exe df -k 1>%tmpdir%\output.txt 2>&1 || type %tmpdir%\output.txt>>%logfile% && ECHOC {%c_e%}�б����ʧ��{%c_i%}{\n}&& call log %logger% F �б����ʧ��&& goto FATAL
type %tmpdir%\output.txt>>%logfile%
set spaceleft_kb=
for /f "tokens=4 delims= " %%a in ('find "%letter%" "%tmpdir%\output.txt"') do set spaceleft_kb=%%a
if "%spaceleft_kb%"=="" ECHOC {%c_e%}��ȡ���̿��ÿռ�ʧ��{%c_i%}{\n}& call log %logger% F ��ȡ���̿��ÿռ�ʧ��& goto FATAL
call calc m spaceleft nodec %spaceleft_kb% 1024
call calc numcomp %spaceleft% %sizetocompare%
if "%calc__numcomp__result%"=="greater" (set enough=y) else (set enough=n)
call log %logger% I �ռ��Ƿ��㹻:%enough%.���̿��ÿռ�:%spaceleft%.Ŀ���С:%sizetocompare%
ENDLOCAL & set framework__chkdiskspace__enough=%enough%& set framework__chkdiskspace__spaceleft=%spaceleft%
goto :eof


:LOADCSVCONF
SETLOCAL
set logger=framework.bat-loadcsvconf
set filepath=%args2%& set item=%args3%& set mode=%args4%
call log %logger% I ���ձ���:filepath:%filepath%.item:%item%.mode:%mode%
if not exist %filepath% ECHOC {%c_e%}�Ҳ���%filepath%{%c_i%}{\n}& call log %logger% F �Ҳ���%filepath%& goto FATAL
if exist %tmpdir%\loadcsvconf.bat del %tmpdir%\loadcsvconf.bat 1>>%logfile% 2>&1
find "%item%" "%filepath%" 1>nul 2>nul || ECHOC {%c_e%}��%filepath%���Ҳ�����Ŀ%item%{%c_i%}{\n}&& call log %logger% F ��%filepath%���Ҳ�����Ŀ%item%&& goto FATAL
set num=2
:LOADCSVCONF-1
if %num% GTR 31 ECHOC {%c_e%}������Ŀ����, ������������ɷ�Χ. ���򿪷��߷���������{%c_i%}{\n}& call log %logger% F ������Ŀ����:%num%��.������������ɷ�Χ:31��& goto FATAL
set name=
for /f "tokens=%num% delims=[]," %%a in ('type %filepath% ^| find "],["') do set name=%%a
if "%name%"=="" goto LOADCSVCONF-2
for /f "tokens=%num% delims=," %%a in ('type %filepath% ^| find "%item%"') do set value=%%a
if "%mode%"=="orig" echo.set %name%=%value%|find "set" 1>>%tmpdir%\loadcsvconf.bat
if not "%mode%"=="orig" echo.set framework__loadcsvconf__%name%=%value%|find "set" 1>>%tmpdir%\loadcsvconf.bat
set /a num+=1& goto LOADCSVCONF-1
:LOADCSVCONF-2
ENDLOCAL
call %tmpdir%\loadcsvconf.bat
goto :eof


:LOGVIEWER
if "%args2%"=="end" taskkill /f /im busybox-bfflogviewer.exe 1>nul 2>nul & goto :eof
@ECHO OFF
COLOR 0F
TITLE BFF-ʵʱ��־��� [������ֻ�����־, ������ű�����]
ECHO.
ECHO.��ǰ��־�ļ�: %logfile%
ECHO.
call tool\Win\resizecmdwindow.exe -l 0 -r 70 -t 0 -b 20 -w 500 -h 800
tool\Win\busybox-bfflogviewer.exe tail -f %args3%
EXIT


:CONF
SETLOCAL
set logger=framework.bat-conf
call log %logger% I ����conf\%args2%д��%args3%.ֵΪ%args4%
::if not exist conf\%args2% ECHOC {%c_e%}�Ҳ���conf\%args2%{%c_i%}{\n}& call log %logger% F �Ҳ���conf\%args2%& goto FATAL
if not exist conf\%args2% echo.>conf\%args2%
find "set %args3%=" "conf\%args2%" 1>nul 2>nul || echo.set %args3%=%args4%|findstr "set" 1>>conf\%args2%&& goto CONF-DONE
type conf\%args2% | find "set " | find /v "set %args3%=" 1>%tmpdir%\output.txt
echo.set %args3%=%args4%|findstr "set" 1>>%tmpdir%\output.txt
move /Y %tmpdir%\output.txt conf\%args2% 1>nul || ECHOC {%c_e%}�ƶ�%tmpdir%\output.txt��conf\%args2%ʧ��{%c_i%}{\n}&& call log %logger% F �ƶ�%tmpdir%\output.txt��conf\%args2%ʧ��&& goto FATAL
:CONF-DONE
ENDLOCAL
goto :eof


:THEME
set c_i=0F& set c_w=0E& set c_e=0C& set c_s=0A& set c_h=0D
if "%args2%"=="" set args2=%framework_theme%
if "%args2%"=="default" set c_i=0F& set c_w=0E& set c_e=0C& set c_s=0A& set c_h=0D& set c_a=0E& set c_we=07
if "%args2%"=="douyinhacker" set c_i=0A& set c_w=0E& set c_e=0C& set c_s=0F& set c_h=0D& set c_a=0E& set c_we=07
if "%args2%"=="ubuntu" set c_i=5F& set c_w=5E& set c_e=5C& set c_s=5A& set c_h=59& set c_a=5E& set c_we=5F
if "%args2%"=="classic" set c_i=3F& set c_w=3E& set c_e=3C& set c_s=3A& set c_h=3D& set c_a=3E& set c_we=3F
if "%args2%"=="gold" set c_i=8E& set c_w=E0& set c_e=CF& set c_s=A0& set c_h=6F& set c_a=8E& set c_we=8E
if "%args2%"=="dos" set c_i=1F& set c_w=1E& set c_e=1C& set c_s=A0& set c_h=80& set c_a=1E& set c_we=1F
if "%args2%"=="ChineseNewYear" set c_i=CF& set c_w=6F& set c_e=0F& set c_s=C0& set c_h=7C& set c_a=6F& set c_we=CF
goto :eof


:STARTPRE
if exist tool\logo.txt type tool\logo.txt
ECHO.����׼������...
::����path-�������ȷȱ�ٵ�ϵͳ����·��...
set path=%path%||ECHO.ϵͳ����������Path�����д��ڴ����·��. �����������&& goto FATAL
set path=%path%;%windir%\Sysnative
::ECHO.���find, findstr, copy, move, ren, del����...
echo.test>bff_test1.tmp
find "test" "bff_test1.tmp"         1>nul || ECHO.ִ��find����ʧ��. ϵͳ�����л�����������, ��ϵͳȱ�ٱ�Ҫ���&& goto FATAL
findstr "test" "bff_test1.tmp"      1>nul || ECHO.ִ��findstr����ʧ��. ϵͳ�����л�����������, ��ϵͳȱ�ٱ�Ҫ���&& goto FATAL
copy /Y bff_test1.tmp bff_test2.tmp 1>nul || ECHO.ִ��copy����ʧ��. ϵͳ�����л�����������, ��ϵͳȱ�ٱ�Ҫ���&& goto FATAL
move /Y bff_test1.tmp bff_test2.tmp 1>nul || ECHO.ִ��move����ʧ��. ϵͳ�����л�����������, ��ϵͳȱ�ٱ�Ҫ���&& goto FATAL
ren bff_test2.tmp bff_test1.tmp     1>nul || ECHO.ִ��ren����ʧ��. ϵͳ�����л�����������, ��ϵͳȱ�ٱ�Ҫ���&& goto FATAL
del /F /Q bff_test1.tmp             1>nul || ECHO.ִ��del����ʧ��. ϵͳ�����л�����������, ��ϵͳȱ�ٱ�Ҫ���&& goto FATAL
::ECHO.��ȡWindows�汾��...
for /f "tokens=4 delims=[] " %%a in ('ver ^| find " "') do set winver=%%a
::ECHO.���ͱ��湤��Ŀ¼·��...
for /f "tokens=2 delims=() " %%a in ('echo." %cd% "') do (if not "%%a"=="%cd%" ECHO.������·���в������пո��Ӣ������& goto FATAL)
set framework_workspace=%cd%
::ECHO.����path-���빤���价��·��...
set path=%framework_workspace%;%framework_workspace%\tool\Win;%path%
::ECHO.���ECHOC...
ECHOC | find "Usage" 1>nul 2>nul || ECHO.ECHOC.exe�޷�����&& goto FATAL
::ECHO.���gettime...
if not exist tool\Win\gettime.exe ECHOC {%c_e%}�Ҳ���gettime.exe{%c_i%}{\n}& goto FATAL
gettime.exe | find "." 1>nul 2>nul || ECHOC {%c_e%}gettime.exe�޷�����{%c_i%}{\n}&& goto FATAL
::ECHO.׼��tmpĿ¼
if not exist tmp md tmp 1>nul || ECHOC {%c_e%}����tmp�ļ���ʧ��{%c_i%}{\n}&& goto FATAL
if not "%framework_multitmpdir%"=="y" set framework_multitmpdir=n& set tmpdir=%framework_workspace%\tmp
if "%framework_multitmpdir%"=="y" (for /f %%a in ('gettime.exe ^| find "."') do set tmpdir=%framework_workspace%\tmp\%%a)
if not exist %tmpdir% md %tmpdir% 1>nul || ECHOC {%c_e%}����%tmpdir%�ļ���ʧ��{%c_i%}{\n}&& goto FATAL
::ECHO.׼����־ϵͳ...
if not exist log.bat ECHOC {%c_e%}�Ҳ���log.bat{%c_i%}{\n}& goto FATAL
if "%framework_log%"=="n" set logfile=nul& set logger=CLOSED
if "%framework_log%"=="n" SETLOCAL & goto STARTPRE-2
if not exist log md log 1>nul || ECHOC {%c_e%}����log�ļ���ʧ��{%c_i%}{\n}&& goto FATAL
for /f %%a in ('gettime.exe ^| find "."') do set logfile=%framework_workspace%\log\%%a.log
set logger=UNKNOWN
SETLOCAL
set logger=framework.bat-startpre
call log %logger% I ϵͳ��Ϣ:%processor_architecture%.%winver%.����Ŀ¼:%framework_workspace%
::ECHO.������־...
if "%framework_lognum%"=="" set framework_lognum=6
for /f %%a in ('dir /B log ^| find /C ".log"') do (if %%a LEQ %framework_lognum% goto STARTPRE-2)
for /f "tokens=1 delims=[]" %%a in ('dir /B log ^| find /N ".log"') do set /a var=%%a-%framework_lognum%
:STARTPRE-1
dir /B log | find /N ".log" | find "[%var%]" 1>nul 2>nul || goto STARTPRE-2
for /f "tokens=2 delims=[]" %%a in ('dir /B log ^| find /N ".log" ^| find "[%var%]"') do del log\%%a 1>nul
set /a var+=-1& goto STARTPRE-1
:STARTPRE-2
if "%args2%"=="skiptoolchk" call log %logger% I ������鹤��& goto STARTPRE-DONE
::ECHO.���calc.bat...
if not exist calc.bat ECHOC {%c_e%}�Ҳ���calc.bat{%c_i%}{\n}& call log %logger% F �Ҳ���calc.bat& goto FATAL
::ECHO.���chkdev.bat...
if not exist chkdev.bat ECHOC {%c_e%}�Ҳ���chkdev.bat{%c_i%}{\n}& call log %logger% F �Ҳ���chkdev.bat& goto FATAL
::ECHO.���clean.bat...
if not exist clean.bat ECHOC {%c_e%}�Ҳ���clean.bat{%c_i%}{\n}& call log %logger% F �Ҳ���clean.bat& goto FATAL
::ECHO.���dl.bat...
if not exist dl.bat ECHOC {%c_e%}�Ҳ���dl.bat{%c_i%}{\n}& call log %logger% F �Ҳ���dl.bat& goto FATAL
::ECHO.���imgkit.bat...
if not exist imgkit.bat ECHOC {%c_e%}�Ҳ���imgkit.bat{%c_i%}{\n}& call log %logger% F �Ҳ���imgkit.bat& goto FATAL
::ECHO.���info.bat...
if not exist info.bat ECHOC {%c_e%}�Ҳ���info.bat{%c_i%}{\n}& call log %logger% F �Ҳ���info.bat& goto FATAL
::ECHO.���input.bat...
if not exist input.bat ECHOC {%c_e%}�Ҳ���input.bat{%c_i%}{\n}& call log %logger% F �Ҳ���input.bat& goto FATAL
::ECHO.���open.bat...
if not exist open.bat ECHOC {%c_e%}�Ҳ���open.bat{%c_i%}{\n}& call log %logger% F �Ҳ���open.bat& goto FATAL
::ECHO.���partable.bat...
if not exist partable.bat ECHOC {%c_e%}�Ҳ���partable.bat{%c_i%}{\n}& call log %logger% F �Ҳ���partable.bat& goto FATAL
::ECHO.���random.bat...
if not exist random.bat ECHOC {%c_e%}�Ҳ���random.bat{%c_i%}{\n}& call log %logger% F �Ҳ���random.bat& goto FATAL
::ECHO.���read.bat...
if not exist read.bat ECHOC {%c_e%}�Ҳ���read.bat{%c_i%}{\n}& call log %logger% F �Ҳ���read.bat& goto FATAL
::ECHO.���reboot.bat...
if not exist reboot.bat ECHOC {%c_e%}�Ҳ���reboot.bat{%c_i%}{\n}& call log %logger% F �Ҳ���reboot.bat& goto FATAL
::ECHO.���scrcpy.bat...
if not exist scrcpy.bat ECHOC {%c_e%}�Ҳ���scrcpy.bat{%c_i%}{\n}& call log %logger% F �Ҳ���scrcpy.bat& goto FATAL
::ECHO.���sel.bat...
if not exist sel.bat ECHOC {%c_e%}�Ҳ���sel.bat{%c_i%}{\n}& call log %logger% F �Ҳ���sel.bat& goto FATAL
::ECHO.���slot.bat...
if not exist slot.bat ECHOC {%c_e%}�Ҳ���slot.bat{%c_i%}{\n}& call log %logger% F �Ҳ���slot.bat& goto FATAL
::ECHO.���write.bat...
if not exist write.bat ECHOC {%c_e%}�Ҳ���write.bat{%c_i%}{\n}& call log %logger% F �Ҳ���write.bat& goto FATAL
::ECHO.���360AblumViewer...
::if not exist tool\Win\360AblumViewer.exe ECHOC {%c_e%}�Ҳ���360AblumViewer.exe{%c_i%}{\n}& call log %logger% F �Ҳ���360AblumViewer.exe& goto FATAL
::if not exist tool\Win\360AblumViewer.ini ECHOC {%c_e%}�Ҳ���360AblumViewer.ini{%c_i%}{\n}& call log %logger% F �Ҳ���360AblumViewer.ini& goto FATAL
::ECHO.���Notepad3...
if not exist tool\Win\Notepad3\Notepad3.exe ECHOC {%c_e%}�Ҳ���Notepad3.exe{%c_i%}{\n}& call log %logger% F �Ҳ���Notepad3.exe& goto FATAL
::ECHO.���scrcpy...
if not exist tool\Win\scrcpy\scrcpy.exe ECHOC {%c_e%}�Ҳ���scrcpy.exe{%c_i%}{\n}& call log %logger% F �Ҳ���scrcpy.exe& goto FATAL
tool\Win\scrcpy\scrcpy.exe -h | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}scrcpy.exe�޷�����{%c_i%}{\n}&& call log %logger% F scrcpy.exe�޷�����&& goto FATAL
::ECHO.���Vieas...
if not exist tool\Win\Vieas\Vieas.exe ECHOC {%c_e%}�Ҳ���Vieas.exe{%c_i%}{\n}& call log %logger% F �Ҳ���Vieas.exe& goto FATAL
::ECHO.���7z...
if not exist tool\Win\7z.dll ECHOC {%c_e%}�Ҳ���7z.dll{%c_i%}{\n}& call log %logger% F �Ҳ���7z.dll& goto FATAL
if not exist tool\Win\7z.exe ECHOC {%c_e%}�Ҳ���7z.exe{%c_i%}{\n}& call log %logger% F �Ҳ���7z.exe& goto FATAL
7z.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}7z.exe�޷�����{%c_i%}{\n}&& call log %logger% F 7z.exe�޷�����&& goto FATAL
::ECHO.���aapt...
::if not exist tool\Win\aapt.exe ECHOC {%c_e%}�Ҳ���aapt.exe{%c_i%}{\n}& call log %logger% F �Ҳ���aapt.exe& goto FATAL
::tool\Win\aapt.exe v | find "Android" 1>nul 2>nul || ECHOC {%c_e%}aapt.exe�޷�����{%c_i%}{\n}&& call log %logger% F aapt.exe�޷�����&& goto FATAL
::ECHO.���adb...
if not exist tool\Win\adb.exe ECHOC {%c_e%}�Ҳ���adb.exe{%c_i%}{\n}& call log %logger% F �Ҳ���adb.exe& goto FATAL
if not exist tool\Win\AdbWinApi.dll ECHOC {%c_e%}�Ҳ���AdbWinApi.dll{%c_i%}{\n}& call log %logger% F �Ҳ���AdbWinApi.dll& goto FATAL
if not exist tool\Win\AdbWinUsbApi.dll ECHOC {%c_e%}�Ҳ���AdbWinUsbApi.dll{%c_i%}{\n}& call log %logger% F �Ҳ���AdbWinUsbApi.dll& goto FATAL
adb.exe start-server>nul
adb.exe devices | find "List of devices attached" 1>nul 2>nul || ECHOC {%c_e%}adb.exe�޷�����{%c_i%}{\n}&& call log %logger% F adb.exe�޷�����&& goto FATAL
::ECHO.���aria2c...
if not exist tool\Win\aria2c.exe ECHOC {%c_e%}�Ҳ���aria2c.exe{%c_i%}{\n}& call log %logger% F �Ҳ���aria2c.exe& goto FATAL
aria2c.exe -h | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}aria2c.exe�޷�����{%c_i%}{\n}&& call log %logger% F aria2c.exe�޷�����&& goto FATAL
::ECHO.���busybox...
if not exist tool\Win\busybox.exe ECHOC {%c_e%}�Ҳ���busybox.exe{%c_i%}{\n}& call log %logger% F �Ҳ���busybox.exe& goto FATAL
busybox.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}busybox.exe�޷�����{%c_i%}{\n}&& call log %logger% F busybox.exe�޷�����&& goto FATAL
::ECHO.���busybox-bfflogviewer...
if not exist tool\Win\busybox-bfflogviewer.exe ECHOC {%c_e%}�Ҳ���busybox-bfflogviewer.exe{%c_i%}{\n}& call log %logger% F �Ҳ���busybox-bfflogviewer.exe& goto FATAL
busybox-bfflogviewer.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}busybox-bfflogviewer.exe�޷�����{%c_i%}{\n}&& call log %logger% F busybox-bfflogviewer.exe�޷�����&& goto FATAL
::ECHO.���calc...
if not exist tool\Win\calc.exe ECHOC {%c_e%}�Ҳ���calc.exe{%c_i%}{\n}& call log %logger% F �Ҳ���calc.exe& goto FATAL
for /f %%a in ('calc.exe 2199023255552 m 999 6') do (if not "%%a"=="2196824232296448.000000" ECHOC {%c_e%}calc.exe�޷�����{%c_i%}{\n}& call log %logger% F calc.exe�޷�����& goto FATAL)
::ECHO.���curl...
if not exist tool\Win\curl.exe ECHOC {%c_e%}�Ҳ���curl.exe{%c_i%}{\n}& call log %logger% F �Ҳ���curl.exe& goto FATAL
curl.exe --help | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}curl.exe�޷�����{%c_i%}{\n}&& call log %logger% F curl.exe�޷�����&& goto FATAL
::ECHO.���cygwin1.dll...
::if not exist tool\Win\cygwin1.dll ECHOC {%c_e%}�Ҳ���cygwin1.dll{%c_i%}{\n}& call log %logger% F �Ҳ���cygwin1.dll& goto FATAL
::ECHO.���devcon...
if not exist tool\Win\devcon.exe ECHOC {%c_e%}�Ҳ���devcon.exe{%c_i%}{\n}& call log %logger% F �Ҳ���devcon.exe& goto FATAL
devcon.exe help | find "Device" 1>nul 2>nul || ECHOC {%c_e%}devcon.exe�޷�����{%c_i%}{\n}&& call log %logger% F devcon.exe�޷�����&& goto FATAL
::ECHO.���fastboot...
if not exist tool\Win\fastboot.exe ECHOC {%c_e%}�Ҳ���fastboot.exe{%c_i%}{\n}& call log %logger% F �Ҳ���fastboot.exe& goto FATAL
fastboot.exe -h 2>&1 | find "usage" 1>nul 2>nul || ECHOC {%c_e%}fastboot.exe�޷�����{%c_i%}{\n}&& call log %logger% F fastboot.exe�޷�����&& goto FATAL
::ECHO.���fh_loader...
if not exist tool\Win\fh_loader.exe ECHOC {%c_e%}�Ҳ���fh_loader.exe{%c_i%}{\n}& call log %logger% F �Ҳ���fh_loader.exe& goto FATAL
fh_loader.exe -6 2>&1 | find "Base" 1>nul 2>nul || ECHOC {%c_e%}fh_loader.exe�޷�����{%c_i%}{\n}&& call log %logger% F fh_loader.exe�޷�����&& goto FATAL
::ECHO.���filedialog...
if not exist tool\Win\filedialog.exe ECHOC {%c_e%}�Ҳ���filedialog.exe{%c_i%}{\n}& call log %logger% F �Ҳ���filedialog.exe& goto FATAL
filedialog.exe 2>&1 | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}filedialog.exe�޷�����{%c_i%}{\n}&& call log %logger% F filedialog.exe�޷�����&& goto FATAL
::ECHO.���HexTool...
if not exist tool\Win\HexTool.exe ECHOC {%c_e%}�Ҳ���HexTool.exe{%c_i%}{\n}& call log %logger% F �Ҳ���HexTool.exe& goto FATAL
HexTool.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}HexTool.exe�޷�����{%c_i%}{\n}&& call log %logger% F HexTool.exe�޷�����&& goto FATAL
::ECHO.���libcurl.def...
if not exist tool\Win\libcurl.def ECHOC {%c_e%}�Ҳ���libcurl.def{%c_i%}{\n}& call log %logger% F �Ҳ���libcurl.def& goto FATAL
::ECHO.���libcurl.dll...
if not exist tool\Win\libcurl.dll ECHOC {%c_e%}�Ҳ���libcurl.dll{%c_i%}{\n}& call log %logger% F �Ҳ���libcurl.dll& goto FATAL
::ECHO.���magiskboot...
if not exist tool\Win\magiskboot.exe ECHOC {%c_e%}�Ҳ���magiskboot.exe{%c_i%}{\n}& call log %logger% F �Ҳ���magiskboot.exe& goto FATAL
magiskboot.exe 2>&1 | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}magiskboot.exe�޷�����{%c_i%}{\n}&& call log %logger% F magiskboot.exe�޷�����&& goto FATAL
::ECHO.���magiskpatcher...
::if not exist tool\Win\magiskpatcher.exe ECHOC {%c_e%}�Ҳ���magiskpatcher.exe{%c_i%}{\n}& call log %logger% F �Ҳ���magiskpatcher.exe& goto FATAL
::magiskpatcher.exe -h 2>&1 | find "usage" 1>nul 2>nul || ECHOC {%c_e%}magiskpatcher.exe�޷�����{%c_i%}{\n}&& call log %logger% F magiskpatcher.exe�޷�����&& goto FATAL
::ECHO.���numcomp...
if not exist tool\Win\numcomp.exe ECHOC {%c_e%}�Ҳ���numcomp.exe{%c_i%}{\n}& call log %logger% F �Ҳ���numcomp.exe& goto FATAL
numcomp.exe 999 888 | find "greater" 1>nul 2>nul || ECHOC {%c_e%}numcomp.exe�޷�����{%c_i%}{\n}&& call log %logger% F numcomp.exe�޷�����&& goto FATAL
::ECHO.���ptanalyzer...
if not exist tool\Win\ptanalyzer.exe ECHOC {%c_e%}�Ҳ���ptanalyzer.exe{%c_i%}{\n}& call log %logger% F �Ҳ���ptanalyzer.exe& goto FATAL
ptanalyzer.exe 2>&1 | find "ptanalyzer" 1>nul 2>nul || ECHOC {%c_e%}ptanalyzer.exe�޷�����{%c_i%}{\n}&& call log %logger% F ptanalyzer.exe�޷�����&& goto FATAL
::ECHO.���qcedlxmlhelper...
if not exist tool\Win\qcedlxmlhelper.exe ECHOC {%c_e%}�Ҳ���qcedlxmlhelper.exe{%c_i%}{\n}& call log %logger% F �Ҳ���qcedlxmlhelper.exe& goto FATAL
qcedlxmlhelper.exe 2>&1 | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}qcedlxmlhelper.exe�޷�����{%c_i%}{\n}&& call log %logger% F qcedlxmlhelper.exe�޷�����&& goto FATAL
::ECHO.���QCNTool...
if not exist tool\Win\QCNTool.exe ECHOC {%c_e%}�Ҳ���QCNTool.exe{%c_i%}{\n}& call log %logger% F �Ҳ���QCNTool.exe& goto FATAL
QCNTool.exe -h | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}QCNTool.exe�޷�����{%c_i%}{\n}&& call log %logger% F QCNTool.exe�޷�����&& goto FATAL
::ECHO.���QMSL_MSVC10R.dll...
if not exist tool\Win\QMSL_MSVC10R.dll ECHOC {%c_e%}�Ҳ���QMSL_MSVC10R.dll{%c_i%}{\n}& call log %logger% F �Ҳ���QMSL_MSVC10R.dll& goto FATAL
::ECHO.���QSaharaServer...
if not exist tool\Win\QSaharaServer.exe ECHOC {%c_e%}�Ҳ���QSaharaServer.exe{%c_i%}{\n}& call log %logger% F �Ҳ���QSaharaServer.exe& goto FATAL
QSaharaServer.exe | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}QSaharaServer.exe�޷�����{%c_i%}{\n}&& call log %logger% F QSaharaServer.exe�޷�����&& goto FATAL
::ECHO.���resizecmdwindow...
if not exist tool\Win\resizecmdwindow.exe ECHOC {%c_e%}�Ҳ���resizecmdwindow.exe{%c_i%}{\n}& call log %logger% F �Ҳ���resizecmdwindow.exe& goto FATAL
resizecmdwindow.exe | find "usage" 1>nul 2>nul || ECHOC {%c_e%}resizecmdwindow.exe�޷�����{%c_i%}{\n}&& call log %logger% F resizecmdwindow.exe�޷�����&& goto FATAL
::ECHO.���simg_dump...
if not exist tool\Win\simg_dump.exe ECHOC {%c_e%}�Ҳ���simg_dump.exe{%c_i%}{\n}& call log %logger% F �Ҳ���simg_dump.exe& goto FATAL
simg_dump.exe 2>&1 | find "Usage" 1>nul 2>nul || ECHOC {%c_e%}simg_dump.exe�޷�����{%c_i%}{\n}&& call log %logger% F simg_dump.exe�޷�����&& goto FATAL
::ECHO.���strtofile...
if not exist tool\Win\strtofile.exe ECHOC {%c_e%}�Ҳ���strtofile.exe{%c_i%}{\n}& call log %logger% F �Ҳ���strtofile.exe& goto FATAL
if exist %tmpdir%\bff-test.txt del %tmpdir%\bff-test.txt 1>nul
echo.bff-test|strtofile.exe %tmpdir%\bff-test.txt || ECHOC {%c_e%}strtofile.exe�޷�����{%c_i%}{\n}&& call log %logger% F strtofile.exe�޷�����&& goto FATAL
for /f %%a in (%tmpdir%\bff-test.txt) do (if not "%%a"=="bff-test" ECHOC {%c_e%}strtofile.exe�޷�����{%c_i%}{\n}& call log %logger% F strtofile.exe�޷�����& goto FATAL)
del %tmpdir%\bff-test.txt 1>nul
::ECHO.���usbdump...
::if not exist tool\Win\usbdump.exe ECHOC {%c_e%}�Ҳ���usbdump.exe{%c_i%}{\n}& call log %logger% F �Ҳ���usbdump.exe& goto FATAL
::usbdump.exe -v | find "." 1>nul 2>nul || ECHOC {%c_e%}usbdump.exe�޷�����{%c_i%}{\n}&& call log %logger% F usbdump.exe�޷�����&& goto FATAL
::ECHO.���blktool...
if not exist tool\Android\blktool ECHOC {%c_e%}�Ҳ���blktool{%c_i%}{\n}& call log %logger% F �Ҳ���blktool& goto FATAL
::ECHO.���bootctl...
if not exist tool\Android\bootctl ECHOC {%c_e%}�Ҳ���bootctl{%c_i%}{\n}& call log %logger% F �Ҳ���bootctl& goto FATAL
::ECHO.���busybox...
if not exist tool\Android\busybox ECHOC {%c_e%}�Ҳ���busybox{%c_i%}{\n}& call log %logger% F �Ҳ���busybox& goto FATAL
::ECHO.���dmsetup...
if not exist tool\Android\dmsetup ECHOC {%c_e%}�Ҳ���dmsetup{%c_i%}{\n}& call log %logger% F �Ҳ���dmsetup& goto FATAL
::ECHO.���misc_tofastboot.img...
::if not exist tool\Android\misc_tofastboot.img ECHOC {%c_e%}�Ҳ���misc_tofastboot.img{%c_i%}{\n}& call log %logger% F �Ҳ���misc_tofastboot.img& goto FATAL
::ECHO.���misc_torecovery.img...
::if not exist tool\Android\misc_torecovery.img ECHOC {%c_e%}�Ҳ���misc_torecovery.img{%c_i%}{\n}& call log %logger% F �Ҳ���misc_torecovery.img& goto FATAL
::ECHO.���mke2fs...
if not exist tool\Android\mke2fs ECHOC {%c_e%}�Ҳ���mke2fs{%c_i%}{\n}& call log %logger% F �Ҳ���mke2fs& goto FATAL
::ECHO.���mkfs.exfat...
if not exist tool\Android\mkfs.exfat ECHOC {%c_e%}�Ҳ���mkfs.exfat{%c_i%}{\n}& call log %logger% F �Ҳ���mkfs.exfat& goto FATAL
::ECHO.���mkfs.fat...
if not exist tool\Android\mkfs.fat ECHOC {%c_e%}�Ҳ���mkfs.fat{%c_i%}{\n}& call log %logger% F �Ҳ���mkfs.fat& goto FATAL
::ECHO.���mkntfs...
if not exist tool\Android\mkntfs ECHOC {%c_e%}�Ҳ���mkntfs{%c_i%}{\n}& call log %logger% F �Ҳ���mkntfs& goto FATAL
::ECHO.���parted...
if not exist tool\Android\parted ECHOC {%c_e%}�Ҳ���parted{%c_i%}{\n}& call log %logger% F �Ҳ���parted& goto FATAL
::ECHO.���sgdisk...
if not exist tool\Android\sgdisk ECHOC {%c_e%}�Ҳ���sgdisk{%c_i%}{\n}& call log %logger% F �Ҳ���sgdisk& goto FATAL
:STARTPRE-DONE
call log %logger% I ����׼���������
ENDLOCAL
goto :eof


:ADBPRE
call log framework.bat-adbpre I ���ձ���:args2:%args2%
if "%args2%"=="" set args2=all
if "%args2%"=="all" (
    call write adbpush tool\Android\blktool blktool program
    call write adbpush tool\Android\bootctl bootctl program
    call write adbpush tool\Android\busybox busybox program
    call write adbpush tool\Android\dmsetup dmsetup program
    call write adbpush tool\Android\mke2fs mke2fs program
    call write adbpush tool\Android\mkfs.exfat mkfs.exfat program
    call write adbpush tool\Android\mkfs.fat mkfs.fat program
    call write adbpush tool\Android\mkntfs mkntfs program
    call write adbpush tool\Android\parted parted program
    call write adbpush tool\Android\sgdisk sgdisk program)
if not "%args2%"=="all" call write adbpush tool\Android\%args2% %args2% program
goto :eof





:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
