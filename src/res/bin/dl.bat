::�޸�: n

::call dl direct ֱ��               ��������·��(�����ļ���) [retry once] [notice noprompt] ����ַ���(��ѡ)
::        lzlink �����������(-****) ��������·��(�����ļ���) [retry once] [notice noprompt] ����ַ���(��ѡ)

@ECHO OFF

set args1=%1& set args2=%2& set args3=%3& set args4=%4& set args5=%5& set args6=%6& set args7=%7& set args8=%8& set args9=%9
SETLOCAL
set logger=dl.bat
set dlmode=%args1%& set link_orig=%args2%& set filepath=%args3%& set dltimes=%args4%& set fileexistfunc=%args5%& set chkfield=%args6%
call log %logger% I ���ձ���:dlmode:%dlmode%.link_orig:%link_orig%.filepath:%filepath%.dltimes:%dltimes%.fileexistfunc:%fileexistfunc%.chkfield:%chkfield%
goto %dlmode%




:DIRECT
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath% (
        ECHOC {%c_w%}%filepath%�Ѵ���.���������Ǵ��ļ�.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W %filepath%�Ѵ���.���������Ǵ��ļ�&& pause>nul && ECHO.����...
        del /Q %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%filepath%ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��%filepath%ʧ��&& pause>nul && ECHO.����... && goto DIRECT))
set link_direct=%link_orig%
call :startdl
if "%result%"=="y" goto FINISH
::����ʧ��
if "%dltimes%"=="once" (goto FINISH) else (ECHO.�Զ�����... & goto DIRECT)


:LZLINK
for /f "tokens=2 delims=[]" %%a in ('echo.%link_orig%') do (if not "%%a"=="" goto LZLINK-STV)
goto LZLINK-SINGLE

:LZLINK-SINGLE
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath% (
        ECHOC {%c_w%}%filepath%�Ѵ���.���������Ǵ��ļ�.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W %filepath%�Ѵ���.���������Ǵ��ļ�&& pause>nul && ECHO.����...
        del /Q %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%filepath%ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��%filepath%ʧ��&& pause>nul && ECHO.����... && goto LZLINK-SINGLE))
for /f "tokens=1 delims=[]" %%a in ('echo.%link_orig%') do set link_lz=%%a
echo.%link_lz% | find "-" 1>nul 2>nul
if not "%errorlevel%"=="0" (call :getlzdirectlink-nopswd) else (call :getlzdirectlink-pswd)
call :startdl
if "%result%"=="y" goto FINISH
::����ʧ��
if "%dltimes%"=="once" (goto FINISH) else (ECHO.�Զ�����... & goto LZLINK-SINGLE)

:LZLINK-STV
if not "%fileexistfunc%"=="noprompt" (
    if exist %filepath%.??? (
        ECHOC {%c_w%}%filepath%.xxx�Ѵ���.���������Ǵ�^(��^)�ļ�.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% W %filepath%.xxx�Ѵ���.���������Ǵ�^(��^)�ļ�&& pause>nul && ECHO.����...
        del /Q %filepath%.??? 1>>%logfile% 2>&1 || ECHOC {%c_e%}ɾ��%filepath%.xxxʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E ɾ��%filepath%.xxxʧ��&& pause>nul && ECHO.����... && goto LZLINK-STV))
set filepath_orig=%filepath%
set num=1
:LZLINK-STV-1
set link_lz=
for /f "tokens=%num% delims=[]" %%a in ('echo.%link_orig%') do set link_lz=%%a
if "%link_lz%"=="" goto FINISH
echo.%link_lz% | find "-" 1>nul 2>nul
if not "%errorlevel%"=="0" (call :getlzdirectlink-nopswd) else (call :getlzdirectlink-pswd)
if not "%num:~0,1%"=="" set filepath=%filepath_orig%.00%num%
if not "%num:~1,1%"=="" set filepath=%filepath_orig%.0%num%
if not "%num:~2,1%"=="" set filepath=%filepath_orig%.%num%
call :startdl
if "%result%"=="y" set /a num+=1& goto LZLINK-STV-1
::����ʧ��
if "%dltimes%"=="once" (goto FINISH) else (ECHO.�Զ�����... & goto LZLINK-STV-1)


:FINISH
call log %logger% I ���ؽ��Ϊ%result%.�˳�����ģ��
ENDLOCAL & set dl__result=%result%
goto :eof


:getlzdirectlink-nopswd
::��ȡԭʼ���ӵ���������
echo.%link_lz% | find "https" 1>nul 2>nul
if "%errorlevel%"=="0" (set var=2) else (set var=1)
for /f "tokens=%var% delims=/ " %%a in ('echo.%link_lz%') do set link_lz_value1=%%a
echo.%link_lz% | find "/tp/" 1>nul 2>nul
if "%errorlevel%"=="0" (set /a var+=2) else (set /a var+=1)
for /f "tokens=%var% delims=/ " %%a in ('echo.%link_lz%') do set link_lz_value2=%%a
::����ԭʼ����, ���tp����
call log %logger% I ��������ԭʼ����:https://%link_lz_value1%/%link_lz_value2%
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" https://%link_lz_value1%/%link_lz_value2% 1>%tmpdir%\output.txt 2>%tmpdir%\output2.txt || type %tmpdir%\output2.txt>>%logfile%&& type %tmpdir%\output.txt>>%logfile%&& ECHOC {%c_e%}curl����ԭʼ����https://%link_lz_value1%/%link_lz_value2%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����ԭʼ����https://%link_lz_value1%/%link_lz_value2%ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-nopswd
busybox.exe sed -i "s/\"/#/g" %tmpdir%\output.txt
set link_lz_tp_part2=
for /f "tokens=4 delims=#" %%a in ('type %tmpdir%\output.txt ^| find "<div class=#mh#><a href=#/tp/"') do set link_lz_tp_part2=%%a
if "%link_lz_tp_part2%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡtp���ӵ�2����ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡtp���ӵ�2����ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-nopswd
set link_lz_tp=https://%link_lz_value1%%link_lz_tp_part2%
::����tp����, ���developer����
call log %logger% I ��������tp����:%link_lz_tp%
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" %link_lz_tp% 1>%tmpdir%\output.txt 2>%tmpdir%\output2.txt || type %tmpdir%\output2.txt>>%logfile%&& type %tmpdir%\output.txt>>%logfile%&& ECHOC {%c_e%}curl����tp����ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����tp����ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-nopswd
set link_lz_developer_part1=
for /f "tokens=4 delims='; " %%a in ('type %tmpdir%\output.txt ^| find "var vkjxld "') do set link_lz_developer_part1=%%a
if "%link_lz_developer_part1%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡdeveloper���ӵ�1����ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡdeveloper���ӵ�1����ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-nopswd
set link_lz_developer_part2=
for /f "tokens=4 delims='; " %%a in ('type %tmpdir%\output.txt ^| find "var hyggid "') do set link_lz_developer_part2=%%a
if "%link_lz_developer_part2%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡdeveloper���ӵ�2����ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡdeveloper���ӵ�2����ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-nopswd
set link_lz_developer=%link_lz_developer_part1%%link_lz_developer_part2%
::����developer����, ���ֱ��
call log %logger% I ��������developer����:"%link_lz_developer%"
curl.exe -i -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" %link_lz_developer% --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" --header "Accept-Encoding: gzip, deflate" --header "Accept-Language: zh-CN,zh;q=0.9" --header "Cache-Control: no-cache" --header "Connection: keep-alive" --header "Pragma: no-cache" --header "Upgrade-Insecure-Requests: 1" 1>%tmpdir%\output.txt 2>%tmpdir%\output2.txt || type %tmpdir%\output2.txt>>%logfile%&& type %tmpdir%\output.txt>>%logfile%&& ECHOC {%c_e%}curl����developer����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����developer����ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-nopswd
set link_direct=
for /f "tokens=2 delims= " %%a in ('type %tmpdir%\output.txt ^| find "Location: "') do set link_direct=%%a
if "%link_direct%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡֱ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡֱ��ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-nopswd
set link_direct="%link_direct%"
call log %logger% I ���ֱ��:%link_direct%
goto :eof

:getlzdirectlink-pswd
::��ȡԭʼ���ӵ���������
for /f "tokens=1,2 delims=-" %%a in ('echo.%link_lz%') do (set link_lz_withoutpswd=%%a& set link_lz_pswd=%%b)
echo.%link_lz_withoutpswd% | find "https" 1>nul 2>nul
if "%errorlevel%"=="0" (set var=2) else (set var=1)
for /f "tokens=%var% delims=/ " %%a in ('echo.%link_lz_withoutpswd%') do set link_lz_value1=%%a
echo.%link_lz_withoutpswd% | find "/tp/" 1>nul 2>nul
if "%errorlevel%"=="0" (set /a var+=2) else (set /a var+=1)
for /f "tokens=%var% delims=/ " %%a in ('echo.%link_lz_withoutpswd%') do set link_lz_value2=%%a
::����ԭʼ����, ���tp����
call log %logger% I ��������ԭʼ����:https://%link_lz_value1%/%link_lz_value2%.����:%link_lz_pswd%
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" https://%link_lz_value1%/%link_lz_value2% 1>%tmpdir%\output.txt 2>%tmpdir%\output2.txt || type %tmpdir%\output2.txt>>%logfile%&& type %tmpdir%\output.txt>>%logfile%&& ECHOC {%c_e%}curl����ԭʼ����https://%link_lz_value1%/%link_lz_value2%����%link_lz_pswd%ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����ԭʼ����https://%link_lz_value1%/%link_lz_value2%ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-pswd
busybox.exe sed -i "s/\"/#/g" %tmpdir%\output.txt
set link_lz_tp_part2=
for /f "tokens=4 delims=#" %%a in ('type %tmpdir%\output.txt ^| find "<div class=#mh#><a href=#/tp/"') do set link_lz_tp_part2=%%a
if "%link_lz_tp_part2%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡtp���ӵ�2����ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡtp���ӵ�2����ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
set link_lz_tp=https://%link_lz_value1%%link_lz_tp_part2%
::����tp����, ���postsign
call log %logger% I ��������tp����:%link_lz_tp%
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" %link_lz_tp% 1>%tmpdir%\output.txt 2>%tmpdir%\output2.txt || type %tmpdir%\output2.txt>>%logfile%&& type %tmpdir%\output.txt>>%logfile%&& ECHOC {%c_e%}curl����tp����ʧ��.{%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����tp����ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-pswd
set link_lz_postsign=
for /f "tokens=4 delims=' " %%a in ('type %tmpdir%\output.txt ^| find "var vidksek"') do set link_lz_postsign=%%a
if "%link_lz_postsign%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡpostsignʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡpostsignʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
::ʹ��postsign����, ���developer����
call log %logger% I ����ʹ��postsign:%link_lz_postsign%����
curl.exe -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" -e "https://%link_lz_value1%" https://%link_lz_value1%/ajaxm.php --data-raw "action=downprocess&sign=%link_lz_postsign%&p=%link_lz_pswd%" 1>%tmpdir%\output.txt 2>%tmpdir%\output2.txt || type %tmpdir%\output2.txt>>%logfile%&& type %tmpdir%\output.txt>>%logfile%&& ECHOC {%c_e%}curlʹ��postsign����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curlʹ��postsign����ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-pswd
busybox.exe sed -i "s/\"/ /g;s/\\//g" %tmpdir%\output.txt
set link_lz_developer_part1=& set link_lz_developer_part2=
for /f "tokens=6,10 delims= " %%a in ('type %tmpdir%\output.txt ^| find "http"') do (set link_lz_developer_part1=%%a& set link_lz_developer_part2=%%b)
if "%link_lz_developer_part1%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡdeveloper���ӵ�1����ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡdeveloper���ӵ�1����ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
if "%link_lz_developer_part2%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡdeveloper���ӵ�2����ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡdeveloper���ӵ�2����ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
if "%link_lz_developer_part2%"=="inf" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡdeveloper���ӵ�2����ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡdeveloper���ӵ�2����ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
set link_lz_developer=%link_lz_developer_part1%/file/%link_lz_developer_part2%
::����developer����, ���ֱ��
call log %logger% I ��������developer����:"%link_lz_developer%"
curl.exe -i -k -A "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25" %link_lz_developer% --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" --header "Accept-Encoding: gzip, deflate" --header "Accept-Language: zh-CN,zh;q=0.9" --header "Cache-Control: no-cache" --header "Connection: keep-alive" --header "Pragma: no-cache" --header "Upgrade-Insecure-Requests: 1" 1>%tmpdir%\output.txt 2>%tmpdir%\output2.txt || type %tmpdir%\output2.txt>>%logfile%&& type %tmpdir%\output.txt>>%logfile%&& ECHOC {%c_e%}curl����developer����ʧ��. {%c_h%}�����������...{%c_i%}{\n}&& call log %logger% E curl����developer����ʧ��&& pause>nul && ECHO.����... && goto getlzdirectlink-pswd
set link_direct=
for /f "tokens=2 delims= " %%a in ('type %tmpdir%\output.txt ^| find "Location: "') do set link_direct=%%a
if "%link_direct%"=="" type %tmpdir%\output.txt>>%logfile%& ECHOC {%c_e%}��ȡֱ��ʧ��. {%c_h%}�����������...{%c_i%}{\n}& call log %logger% E ��ȡֱ��ʧ��& pause>nul & ECHO.����... & goto getlzdirectlink-pswd
set link_direct="%link_direct%"
call log %logger% I ���ֱ��:%link_direct%
goto :eof


:startdl
call log %logger% I ��������%link_direct%��%tmpdir%\dl\bffdl.tmp
if exist %tmpdir%\dl rd /s /q %tmpdir%\dl 1>nul 2>>%logfile% || ECHOC {%c_e%}ɾ��%tmpdir%\dlʧ��{%c_i%}{\n}&& call log %logger% E ɾ��%tmpdir%\dlʧ��
md %tmpdir%\dl 1>nul 2>>%logfile% || ECHOC {%c_e%}����%tmpdir%\dlʧ��{%c_i%}{\n}&& call log %logger% E ����%tmpdir%\dlʧ��
cd %tmpdir%\dl
aria2c.exe --max-concurrent-downloads=16 --max-connection-per-server=16 --split=16 --file-allocation=none --out=bffdl.tmp %link_direct% 1>>%logfile% 2>&1 || cd %framework_workspace%&& ECHOC {%c_e%}����ʧ��{%c_i%}{\n}&& call log %logger% E ��������ʧ��&& set result=n&& goto :eof
cd %framework_workspace%
if not "%chkfield%"=="" find "%chkfield%" "%tmpdir%\dl\bffdl.tmp" 1>nul 2>nul || ECHOC {%c_e%}����ʧ��,�Ҳ���ָ�����ַ�,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.�Ҳ���ָ�����ַ�:%chkfield%.����ʧ��&& set result=n&& goto :eof
for /f "tokens=3 delims= " %%a in ('dir %tmpdir%\dl /-C /-N /A:-D ^| find "bffdl"') do set var=%%a
if %var% LEQ 10240 (
    find "code" "%tmpdir%\dl\bffdl.tmp" | find ": 400," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,���ֱ���,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.���ֱ���.����ʧ��&& set result=n&& goto :eof
    find "code" "%tmpdir%\dl\bffdl.tmp" | find ": 201," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,���ֱ���,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.���ֱ���.����ʧ��&& set result=n&& goto :eof
    find "path not found" "%tmpdir%\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,�Ҳ����ƶ�·��,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.�Ҳ����ƶ�·��.����ʧ��&& set result=n&& goto :eof
    find "could not be found" "%tmpdir%\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,���ֱ���,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.���ֱ���.����ʧ��&& set result=n&& goto :eof
    find "failed to get file" "%tmpdir%\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,�Ҳ����ƶ��ļ�,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.�Ҳ����ƶ��ļ�.����ʧ��&& set result=n&& goto :eof
    find "Loading storage, please wait" "%tmpdir%\dl\bffdl.tmp" | find ":500," 1>nul 2>nul && ECHOC {%c_e%}����ʧ��,�ƴ洢��δ�������,����ʧ��{%c_i%}{\n}&& call log %logger% E ����ʧ��.�ƴ洢��δ�������.����ʧ��&& set result=n&& goto :eof)
move /Y %tmpdir%\dl\bffdl.tmp %filepath% 1>>%logfile% 2>&1 || ECHOC {%c_e%}�ƶ�ʧ��{%c_i%}{\n}&& call log %logger% E �ƶ�ʧ��&& set result=n&& goto :eof
set result=y& call log %logger% I �������سɹ�
goto :eof






:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}��Ǹ, �ű���������, �޷���������. ��鿴��־. {%c_h%}��������˳�...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.��Ǹ, �ű���������, �޷���������. ��������˳�...& pause>nul & EXIT)
