@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Choose_This_Day
call :resize 170 28

rem =========================================
rem Created by Cerafin C F | Converted Optimization 
rem =========================================

set "day_count=0"
set "good_total=0"
set "bad_total=0"
set "memory_file=%appdata%\ctd_memory.txt"

cls
taskkill /f /im wscript.exe >nul 2>&1
call :play "Windows Proximity Connection.wav" 1

echo [Loading System Environment Parameters]
timeout /t 2 >nul

if exist "!memory_file!" (
    errorlevel 0
    < "!memory_file!" (
        set /p "name="
        set /p "day_count="
        set /p "good_total="
        set /p "bad_total="
        set /p "current_phase="
    )
    cls
    call :say "Saved footprint detected. Restoring narrative paths." 1
    timeout /t 2 >nul
    goto :intro
)

:intro
cls
call :say "Every day starts with tiny, almost imperceptible vectors." 1
set /p "name=Register your profile identity: "
set "current_phase=intro"
(
    echo !name!
    echo !day_count!
    echo !good_total!
    echo !bad_total!
    echo !current_phase!
) > "!memory_file!"

call :say "System path registered successfully, !name!." 1
timeout /t 3 >nul
exit /b

:say
set "msg=%~1"
set /a i=0
:loop
set "ch=!msg:~%i%,1!"
if "!ch!"=="" goto :done
<nul set /p "=!ch!"
rem Highly consistent low overhead tick interval engine delay mapping
>nul ping -n 1 -w 50 127.0.0.1
set /a i+=1
goto :loop
:done
echo(
exit /b

:resize
powershell -command "&{$H=Get-Host;$W=$H.UI.RawUI;$B=$W.BufferSize;$B.Width=%~1;$B.Height=9999;$W.BufferSize=$B;$S=$W.WindowSize;$S.Width=%~1;$S.Height=%~2;$W.WindowSize=$S}" >nul 2>&1
exit /b

:play
if not exist "%SystemRoot%\Media\%~1" exit /b
echo Set P = CreateObject("WMPlayer.OCX"):P.URL="%SystemRoot%\Media\%~1":P.Controls.Play:Do While P.PlayState^<>1:WScript.Sleep 100:Loop > "%temp%\p.vbs"
start /b wscript.exe "%temp%\p.vbs"
exit /b
