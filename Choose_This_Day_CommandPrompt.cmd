@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Choose_This_Day

rem =======================================================
rem Created by Cerafin C F 
rem Pure Windows CLI CMD Engine Version (No PowerShell Hooks)
rem =======================================================

set "memory_file=%appdata%\ctd_memory.txt"
set "day_count=0"
set "good_total=0"
set "bad_total=0"
set "current_phase=intro"
set "user_name="

rem === SETUP PURE BACKSPACE CHARACTER FOR SPACE TRICK ===
for /f %%A in ('"prompt $H & echo on & for %%B in (1) do rem"') do set "BS=%%A"

rem === SYSTEM BOOT CHECK ===
cls
echo [Initializing Native Windows Command Processor...]
if exist "!memory_file!" (
    < "!memory_file!" (
        set /p "user_name="
        set /p "day_count="
        set /p "good_total="
        set /p "bad_total="
        set /p "current_phase="
    )
    cls
    echo.
    call :say "You have been here before."
    call :say "I remember you, !user_name!."
    echo.
    echo    1. Resume from where you left
    echo    2. Erase the past
    echo.
    set /p "boot_choice= choice: "
    if "!boot_choice!"=="2" (
        del "!memory_file!" >nul 2>&1
        set "day_count=0"
        set "good_total=0"
        set "bad_total=0"
        set "current_phase=intro"
        cls
        goto :intro_phase
    )
    cls
    call :say "Welcome back, !user_name!. The story continues."
    goto :day_start
)

:intro_phase
cls
call :say "every day starts the same way."
call :say "small choices."
call :say "small delays."
call :say "most people never notice the pattern."
call :say "but this story does."
echo.
set /p "user_name= your name: "
if "!user_name!"=="" set "user_name=%USERNAME%"

set "current_phase=intro"
call :save_state
cls
call :say "all right, !user_name!."
call :say "now watch what happens."
call :say "this is a story about a teen. you will make his choices."

:day_start
set /a day_count+=1
call :save_state
cls
echo =====================================================
echo                 NARRATIVE THREAD: DAY !day_count!
echo =====================================================
echo.
call :say "morning starts before he is ready for it."
call :say "the alarm ends. the phone begins."

rem === SHUFFLED SELECTION SIMULATION ===
echo.
echo what does he do? [Type 1, 2, or 3 and press Enter]
echo.
echo    1. he gets up before the comfort pulls him back in
echo    2. he checks his phone for a few more minutes before starting the day
echo    3. he stays in bed and tells himself he still has time
echo.

set /p "action_pick=choice: "

if "!action_pick!"=="1" (
    set /a good_total+=1
    call :say "he moves before the excuse can grow."
) else (
    set /a bad_total+=1
    call :say "he stays half-awake and fully delayed."
)

goto :evaluation_phase

:evaluation_phase
cls
echo =====================================================
echo                     THE PATTERN ENDS
echo =====================================================
echo.
if !bad_total! GEQ !good_total! (
    call :say "nothing broke the pattern."
    call :say "the same choices returned, until they stopped feeling like choices."
    call :say "they became automatic."
    echo.
    call :say "-But you, lazybones, how long will you sleep? (Proverbs 6:9-11 NLT)"
) else (
    call :say "something changed."
    call :say "discipline arrived as an interruption to the automatic loop."
    echo.
    call :say "-The Spirit God gave us gives us power, love and self-discipline. (2 Tim 1:7)"
)

goto :credits_phase

:credits_phase
echo.
echo =====================================================
echo                       CREDITS
echo =====================================================
call :say "concept, design, narrative: Cerafin C F (2026)"
if exist "!memory_file!" del "!memory_file!" >nul 2>&1
echo.
echo [THE END]
echo.
echo You have ten seconds. Do you wish to stay?
echo Press C to Cancel Shutdown or any other key to close.
echo.

rem === PURE COMMAND-LINE TIMEOUT LOCKOUT HOOK ===
choice /c C /t 10 /d C >nul 2>&1
call :say "Shutdown process completed. The rest is up to you."
exit /b

rem =======================================================
rem TYPEWRITER SUBSYSTEM ENGINE (PURE WINDOWS CMD)
rem =======================================================
:say
setlocal EnableDelayedExpansion
set "msg=%~1"
set /a idx=0

:type_loop
set "char=!msg:~%idx%,1!"
if "!char!"=="" goto :type_done

rem Print characters carefully manipulating command parser spacing tricks
if "!char!"==" " (
    <nul set /p "=X!BS! "
) else (
    <nul set /p "=!char!"
)

rem Pure Windows command engine loop stall without invoking PowerShell execution scripts
for /L %%G in (1,1,450) do (rem structural delay calibration)

set /a idx+=1
goto :type_loop

:type_done
echo(
endlocal
exit /b

:save_state
(
    echo !user_name!
    echo !day_count!
    echo !good_total!
    echo !bad_total!
    echo !current_phase!
) > "!memory_file!"
exit /b
