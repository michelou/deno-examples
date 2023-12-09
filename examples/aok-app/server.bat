@echo off
setlocal enabledelayedexpansion

set _DEBUG=0

@rem #########################################################################
@rem ## Environment setup

set _EXITCODE=0

call :env
if not %_EXITCODE%==0 goto end

call :args %*
if not %_EXITCODE%==0 goto end

@rem #########################################################################
@rem ## Main

call :server_pid
if %_SERVER_PID%==0 (
    if %_STOP%==0 (
        if %_DEBUG%==1 ( echo %_DEBUG_LABEL% start "%_SERVER_TITLE%" deno.exe run %_RUN_OPTS% "%_SCRIPT_FILE%" 1>&2
        ) else if %_VERBOSE%==1 ( echo Start process listening on port %_SERVER_PORT% 1>&2
        )
        start "%_SERVER_TITLE%" deno.exe run %_RUN_OPTS% "%_SCRIPT_FILE%"
    )
) else if %_SERVER_PID%==-1 (
    echo %_WARNING_LABEL% Another process is using port %_SERVER_PORT%
) else if %_STOP%==1 (
    if %_DEBUG%==1 ( echo %_DEBUG_LABEL% taskkill /pid %_SERVER_PID% 1>&2
    ) else if %_VERBOSE%==1 ( echo Stop process listening on port %_SERVER_PORT% 1>&2
    )
    taskkill /pid %_SERVER_PID% 1>NUL
)
goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"
for %%i in ("%~dp0\.") do set "_PROJECT_NAME=%%~ni"

set _DEBUG_LABEL=[%_BASENAME%]
set _ERROR_LABEL=Error:

set _SERVER_HOST=localhost
set _SERVER_PORT=8989
set "_SERVER_TITLE=%_PROJECT_NAME%:%_SERVER_PORT%"

if not exist "%GIT_HOME%\mingw64\bin\curl.exe" (
    echo %_ERROR_LABEL% curl command not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CURL_CMD=%GIT_HOME%\mingw64\bin\curl.exe"

set "_SCRIPT_FILE=%_ROOT_DIR%src\%_PROJECT_NAME%.ts"
if not exist "%_SCRIPT_FILE%" (
    echo %_ERROR_LABEL% TypeScript source file "!_SCRIPT_FILE:%_ROOT_DIR%=!" not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set _RUN_OPTS=--allow-env --allow-net
goto :eof

:args
set _HELP=0
set _STOP=0
set _VERBOSE=0
:args_loop
set "__ARG=%~1"
if not defined __ARG (
    if !__N!==0 set _HELP=1
    goto args_done
)
if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else if "%__ARG%"=="stop" ( set _STOP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand "%__ARG%" 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
goto :eof

@rem output parameter: _SERVER_PID (0=server not listening, -1=other process is listening)
:server_pid
set _SERVER_PID=0
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% netstat -aon ^| findstr %_SERVER_PORT% ^| findstr LISTENING 1>&2
) else if %_VERBOSE%==1 ( echo Is there any process listening to port %_SERVER_PORT% ? 1>&2
)
for /f "tokens=1-4,*" %%i in ('netstat -aon ^| findstr %_SERVER_PORT% ^| findstr LISTENING') do (
    set _SERVER_PID=%%m
)
if %_SERVER_PID%==0 goto :eof

set __PID=%_SERVER_PID%
set _SERVER_PID=0
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% tasklist /nh /fi "pid eq %__PID%" ^| findstr deno.exe 1>&2
) else if %_VERBOSE%==1 ( echo Is it a Deno process ? 1>&2
)
for /f "tokens=1,2,*" %%i in ('tasklist /nh /fi "pid eq %__PID%" ^|findstr deno.exe') do (
    set _SERVER_PID=%%j
)
if not defined _SERVER_PID set _SERVER_PID=-1
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
