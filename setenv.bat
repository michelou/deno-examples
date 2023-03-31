@echo off
setlocal enabledelayedexpansion

@rem only for interactive debugging
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

if %_HELP%==1 (
    call :help
    exit /b !_EXITCODE!
)

set _CARGO_PATH=
set _DENO_PATH=
set _GIT_PATH=

call :deno
if not %_EXITCODE%==0 goto end

call :nmap
if not %_EXITCODE%==0 (
    @rem optional installation
    set _EXITCODE=0
)
call :node 18
if not %_EXITCODE%==0 goto end

call :rust
if not %_EXITCODE%==0 (
    @rem optional installation
    set _EXITCODE=0
)
call :git
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

@rem output parameters: _BASENAME, _DEBUG_LABEL, _ERROR_LABEL, _WARNING_LABEL
:env
set _BASENAME=%~n0
set _DRIVE_NAME=O
set "_ROOT_DIR=%~dp0"

call :env_colors
set _DEBUG_LABEL=%_NORMAL_BG_CYAN%[%_BASENAME%]%_RESET%
set _ERROR_LABEL=%_STRONG_FG_RED%Error%_RESET%:
set _WARNING_LABEL=%_STRONG_FG_YELLOW%Warning%_RESET%:
goto :eof

:env_colors
@rem ANSI colors in standard Windows 10 shell
@rem see https://gist.github.com/mlocati/#file-win10colors-cmd
set _RESET=[0m
set _BOLD=[1m
set _UNDERSCORE=[4m
set _INVERSE=[7m

@rem normal foreground colors
set _NORMAL_FG_BLACK=[30m
set _NORMAL_FG_RED=[31m
set _NORMAL_FG_GREEN=[32m
set _NORMAL_FG_YELLOW=[33m
set _NORMAL_FG_BLUE=[34m
set _NORMAL_FG_MAGENTA=[35m
set _NORMAL_FG_CYAN=[36m
set _NORMAL_FG_WHITE=[37m

@rem normal background colors
set _NORMAL_BG_BLACK=[40m
set _NORMAL_BG_RED=[41m
set _NORMAL_BG_GREEN=[42m
set _NORMAL_BG_YELLOW=[43m
set _NORMAL_BG_BLUE=[44m
set _NORMAL_BG_MAGENTA=[45m
set _NORMAL_BG_CYAN=[46m
set _NORMAL_BG_WHITE=[47m

@rem strong foreground colors
set _STRONG_FG_BLACK=[90m
set _STRONG_FG_RED=[91m
set _STRONG_FG_GREEN=[92m
set _STRONG_FG_YELLOW=[93m
set _STRONG_FG_BLUE=[94m
set _STRONG_FG_MAGENTA=[95m
set _STRONG_FG_CYAN=[96m
set _STRONG_FG_WHITE=[97m

@rem strong background colors
set _STRONG_BG_BLACK=[100m
set _STRONG_BG_RED=[101m
set _STRONG_BG_GREEN=[102m
set _STRONG_BG_YELLOW=[103m
set _STRONG_BG_BLUE=[104m
goto :eof

@rem input parameter: %*
@rem output parameter: _HELP, _VERBOSE
:args
set _BASH=0
set _HELP=0
set _VERBOSE=0
set __N=0
:args_loop
set "__ARG=%~1"
if not defined __ARG goto args_done

if "%__ARG:~0,1%"=="-" (
    @rem option
    if "%__ARG%"=="-bash" ( set _BASH=1
    ) else if "%__ARG%"=="-debug" ( set _DEBUG=1
    ) else if "%__ARG%"=="-verbose" ( set _VERBOSE=1
    ) else (
        echo %_ERROR_LABEL% Unknown option %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
) else (
    @rem subcommand
    if "%__ARG%"=="help" ( set _HELP=1
    ) else (
        echo %_ERROR_LABEL% Unknown subcommand %__ARG% 1>&2
        set _EXITCODE=1
        goto args_done
    )
    set /a __N+=1
)
shift
goto args_loop
:args_done
call :subst %_DRIVE_NAME% "%_ROOT_DIR%"
if not %_EXITCODE%==0 goto :eof
if %_DEBUG%==1 (
    echo %_DEBUG_LABEL% Options    : _BASH=%_BASH% _HELP=%_HELP% _VERBOSE=%_VERBOSE% 1>&2
    echo %_DEBUG_LABEL% Subcommands: _HELP=%_HELP% 1>&2
    echo %_DEBUG_LABEL% Variables  : _DRIVE_NAME=%_DRIVE_NAME% 1>&2
)
goto :eof

@rem input parameter(s): %1: drive letter, %2: path to be substituted
:subst
set __DRIVE_NAME=%~1
set "__GIVEN_PATH=%~2"

if not "%__DRIVE_NAME:~-1%"==":" set __DRIVE_NAME=%__DRIVE_NAME%:
if /i "%__DRIVE_NAME%"=="%__GIVEN_PATH:~0,2%" goto :eof

if "%__GIVEN_PATH:~-1%"=="\" set "__GIVEN_PATH=%__GIVEN_PATH:~0,-1%"
if not exist "%__GIVEN_PATH%" (
    echo %_ERROR_LABEL% Provided path does not exist ^(%__GIVEN_PATH%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
for /f "tokens=1,2,*" %%f in ('subst ^| findstr /b "%__DRIVE_NAME%" 2^>NUL') do (
    set "__SUBST_PATH=%%h"
    if "!__SUBST_PATH!"=="!__GIVEN_PATH!" (
        set __MESSAGE=
        for /f %%i in ('subst ^| findstr /b "%__DRIVE_NAME%\"') do "set __MESSAGE=%%i"
        if defined __MESSAGE (
            if %_DEBUG%==1 ( echo %_DEBUG_LABEL% !__MESSAGE! 1>&2
            ) else if %_VERBOSE%==1 ( echo !__MESSAGE! 1>&2
            )
        )
        goto :eof
    )
)
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% subst "%__DRIVE_NAME%" "%__GIVEN_PATH%" 1>&2
) else if %_VERBOSE%==1 ( echo Assign path %__GIVEN_PATH% to drive %__DRIVE_NAME% 1>&2
)
subst "%__DRIVE_NAME%" "%__GIVEN_PATH%"
if not errorlevel 0 (
    echo %_ERROR_LABEL% Failed to assigned drive %__DRIVE_NAME% to path 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

:help
if %_VERBOSE%==1 (
    set __BEG_P=%_STRONG_FG_CYAN%
    set __BEG_O=%_STRONG_FG_GREEN%
    set __BEG_N=%_NORMAL_FG_YELLOW%
    set __END=%_RESET%
) else (
    set __BEG_P=
    set __BEG_O=
    set __BEG_N=
    set __END=
)
echo Usage: %__BEG_O%%_BASENAME% { ^<option^> ^| ^<subcommand^> }%__END%
echo.
echo   %__BEG_P%Options:%__END%
echo     %__BEG_O%-debug%__END%      display commands executed by this script
echo     %__BEG_O%-verbose%__END%    display progress messages
echo.
echo   %__BEG_P%Subcommands:%__END%
echo     %__BEG_O%help%__END%        display this help message
goto :eof

@rem output parameters: _DENO_HOME, _DENO_PATH
:deno
set _DENO_HOME=
set _DENO_PATH=

set __DENO_CMD=
for /f %%f in ('where deno.exe 2^>NUL') do set "__DENO_CMD=%%f"
if defined __DENO_CMD (
    for %%i in ("%__DENO_CMD%") do set "_DENO_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Deno executable found in PATH 1>&2
    goto :eof
) else if defined DENO_HOME (
    set "_DENO_HOME=%DENO_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable DENO_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\deno\" ( set "_DENO_HOME=!__PATH!\deno"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\deno-1*" 2^>NUL') do set "_DENO_HOME=!__PATH!\%%f"
        if not defined _DENO_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\deno-1*" 2^>NUL') do set "_DENO_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_DENO_HOME%\deno.exe" (
    echo %_ERROR_LABEL% Deno executable not found ^(%_DENO_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_DENO_PATH=;%_DENO_HOME%"
if exist "%USERPROFILE%\.deno\bin\" (
    set "_DENO_PATH=%_DENO_PATH%;%USERPROFILE%\.deno\bin\"
)
goto :eof

@rem output parameter: _NMAP_HOME
:nmap
set _NMAP_HOME=

set __NCAT_CMD=
for /f %%f in ('where ncat.exe 2^>NUL') do set "__NCAT_CMD=%%f"
if defined __NCAT_CMD (
    for %%i in ("%__NCAT_CMD%") do set "_NMAP_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Ncat executable found in PATH 1>&2
    goto :eof
) else if defined NMAP_HOME (
    set "_NMAP_HOME=%NMAP_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable NMAP_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\nmap\" ( set "_NMAP_HOME=!__PATH!\nmap"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\nmap-7*" 2^>NUL') do set "_NMAP_HOME=!__PATH!\%%f"
        if not defined _NMAP_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\nmap-7*" 2^>NUL') do set "_NMAP_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_NMAP_HOME%\ncat.exe" (
    echo %_WARNING_LABEL% Ncat executable not found 1>&2
    set _EXITCODE=1
    goto :eof
)
goto :eof

@rem input parameter: %1=major version
@rem output parameter: _NODE18_HOME (resp. _NODE16_HOME)
:node
set __NODE_MAJOR=%~1
set "_NODE!__NODE_MAJOR!_HOME="

set __NODE_CMD=
for /f %%f in ('where node.exe 2^>NUL') do set "__NODE_CMD=%%f"
if defined __NODE_CMD (
    for /f "delims=. tokens=1,*" %%i in ('"%__NODE_CMD%" --version') do (
        if not "%%i"=="v%__NODE_MAJOR%" set __NODE_CMD=
    )
)
set "__NODE_HOME=%NODE_HOME%"
if defined __NODE_HOME (
    for /f "delims=. tokens=1,*" %%i in ('"%__NODE_HOME%\node.exe" --version') do (
        if not "%%i"=="v%__NODE_MAJOR%" set __NODE_HOME=
    )
)
if defined __NODE_CMD (
    for /f "delims=" %%i in ("%__NODE_CMD%") do set "_NODE!__NODE_MAJOR!_HOME=%%~dpi"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of npm executable found in PATH 1>&2
    goto :eof
) else if defined __NODE_HOME (
    set "_NODE_HOME=%__NODE_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable NODE_HOME 1>&2
) else (
    set __PATH=C:\opt
    for /f %%f in ('dir /ad /b "!__PATH!\node-v%__NODE_MAJOR%*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    if not defined _NODE_HOME (
        set "__PATH=%ProgramFiles%"
        for /f %%f in ('dir /ad /b "!__PATH!\node-v%__NODE_MAJOR%*" 2^>NUL') do set "_NODE_HOME=!__PATH!\%%f"
    )
)
if not exist "%_NODE_HOME%\nodevars.bat" (
    echo %_ERROR_LABEL% Node installation directory not found ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
if not exist "%_NODE_HOME%\node.exe" (
    echo %_ERROR_LABEL% Node executable not found ^(%_NODE_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_NODE!__NODE_MAJOR!_HOME=%_NODE_HOME%"
@rem call "%NODE_HOME%\nodevars.bat"
goto :eof

@rem output parameters: _CARGO_HOME, _CARGO_PATH
:rust
set _CARGO_HOME=
set _CARGO_PATH=

set __CARGO_CMD=
for /f %%f in ('where cargo.exe 2^>NUL') do set "__CARGO_CMD=%%f"
if defined __CARGO_CMD (
    for %%i in ("%__CARGO_CMD%") do set "__CARGO_BIN_DIR=%%~dpi"
    for %%f in ("!__CARGO_BIN_DIR!\.") do set "_CARGO_HOME=%%~dpf"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Rust executable found in PATH 1>&2
    goto :eof
) else if defined CARGO_HOME (
    set "_CARGO_HOME=%CARGO_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable CARGO_HOME 1>&2
) else if exist "%USERPROFILE%\.cargo\bin\cargo.exe" (
    set "_CARGO_HOME=%USERPROFILE%\.cargo"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using default Rust installation directory "!_CARGO_HOME!" 1>&2
)
if not exist "%_CARGO_HOME%\bin\cargo.exe" (
    echo %_WARNING_LABEL% Cargo executable not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CARGO_PATH=;%_CARGO_HOME%\bin"
goto :eof

@rem output parameters: _GIT_HOME, _GIT_PATH
:git
set _GIT_HOME=
set _GIT_PATH=

set __GIT_CMD=
for /f %%f in ('where git.exe 2^>NUL') do set "__GIT_CMD=%%f"
if defined __GIT_CMD (
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using path of Git executable found in PATH 1>&2
    @rem keep _GIT_PATH undefined since executable already in path
    goto :eof
) else if defined GIT_HOME (
    set "_GIT_HOME=%GIT_HOME%"
    if %_DEBUG%==1 echo %_DEBUG_LABEL% Using environment variable GIT_HOME 1>&2
) else (
    set __PATH=C:\opt
    if exist "!__PATH!\Git\" ( set "_GIT_HOME=!__PATH!\Git"
    ) else (
        for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        if not defined _GIT_HOME (
            set "__PATH=%ProgramFiles%"
            for /f %%f in ('dir /ad /b "!__PATH!\Git*" 2^>NUL') do set "_GIT_HOME=!__PATH!\%%f"
        )
    )
)
if not exist "%_GIT_HOME%\bin\git.exe" (
    echo %_ERROR_LABEL% Git executable not found ^(%_GIT_HOME%^) 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_GIT_PATH=;%_GIT_HOME%\bin;%_GIT_HOME%\usr\bin;%_GIT_HOME%\mingw64\bin"
goto :eof

:print_env
set __VERBOSE=%1
set "__VERSIONS_LINE1=  "
set "__VERSIONS_LINE2=  "
set __WHERE_ARGS=
where /q "%DENO_HOME%:deno.exe"
if errorlevel 0 (
    for /f "tokens=1,2,*" %%i in ('"%DENO_HOME%\deno.exe" --version ^| findstr deno') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% deno %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%DENO_HOME%:deno.exe"
)
where /q "%USERPROFILE%\.deno\bin:deployctl.cmd"
if errorlevel 0 (
    for /f "tokens=1,*" %%i in ('"%USERPROFILE%\.deno\bin\deployctl.cmd" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% deployctl %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%USERPROFILE%\.deno\bin:deployctl.cmd"
)
where /q "%NODE_HOME%:node.exe"
if errorlevel 0 (
    for /f %%i in ('"%NODE_HOME%\node.exe" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% node %%i,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%NODE_HOME%:node.exe"
)
where /q "%NMAP_HOME%:ncat.exe"
if errorlevel 0 (
    for /f "tokens=1,2,3,*" %%i in ('"%NMAP_HOME%\ncat.exe" --version 2^>^&1') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% ncat %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%NMAP_HOME%:ncat.exe"
)
where /q "%CARGO_HOME%\bin:rustc.exe"
if errorlevel 0 (
    for /f "tokens=1,2,*" %%i in ('"%CARGO_HOME%\bin\rustc.exe" --version') do set "__VERSIONS_LINE1=%__VERSIONS_LINE1% rustc %%j,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%CARGO_HOME%\bin:rustc.exe"
)
where /q "%GIT_HOME%\bin:git.exe"
if errorlevel 0 (
    for /f "tokens=1,2,*" %%i in ('"%GIT_HOME%\bin\git.exe" --version') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% git %%k,"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\bin:git.exe"
)
where /q "%GIT_HOME%\usr\bin:diff.exe"
if errorlevel 0 (
   for /f "tokens=1-3,*" %%i in ('"%GIT_HOME%\usr\bin\diff.exe" --version ^| findstr diff') do set "__VERSIONS_LINE2=%__VERSIONS_LINE2% diff %%l"
    set __WHERE_ARGS=%__WHERE_ARGS% "%GIT_HOME%\usr\bin:diff.exe"
)
echo Tool versions:
echo %__VERSIONS_LINE1%
echo %__VERSIONS_LINE2%
if %__VERBOSE%==1 if defined __WHERE_ARGS (
    echo Tool paths: 1>&2
    for /f "tokens=*" %%p in ('where %__WHERE_ARGS%') do echo    %%p 1>&2
    echo Environment variables: 1>&2
    if defined CARGO_HOME echo    "CARGO_HOME=%CARGO_HOME%" 1>&2
    if defined DENO_HOME echo    "DENO_HOME=%DENO_HOME%" 1>&2
    if defined GIT_HOME echo    "GIT_HOME=%GIT_HOME%" 1>&2
    if defined NMAP_HOME echo    "NMAP_HOME=%NMAP_HOME%" 1>&2
    if defined NODE_HOME echo    "NODE_HOME=%NODE_HOME%" 1>&2
    echo Path associations: 1>&2
    for /f "delims=" %%i in ('subst') do echo    %%i 1>&2
)
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
endlocal & (
    if %_EXITCODE%==0 (
        if not defined CARGO_HOME set "CARGO_HOME=%_CARGO_HOME%"
        if not defined DENO_HOME set "DENO_HOME=%_DENO_HOME%"
        if not defined GIT_HOME set "GIT_HOME=%_GIT_HOME%"
        if not defined NMAP_HOME set "NMAP_HOME=%_NMAP_HOME%"
        if not defined NODE_HOME set "NODE_HOME=%_NODE18_HOME%"
        @rem We prepend %_GIT_HOME%\bin to hide C:\Windows\System32\bash.exe
        set "PATH=%_GIT_HOME%\bin;%PATH%%_DENO_PATH%;%_NODE14_HOME%;%_NMAP_HOME%;%_CARGO_PATH%%_GIT_PATH%;%~dp0bin"
        call :print_env %_VERBOSE%
        if %_BASH%==1 (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% %_GIT_HOME%\usr\bin\bash.exe --login 1>&2
            cmd.exe /c "%_GIT_HOME%\usr\bin\bash.exe --login"
        ) else if not "%CD:~0,2%"=="%_DRIVE_NAME%:" (
            if %_DEBUG%==1 echo %_DEBUG_LABEL% cd /d %_DRIVE_NAME%: 1>&2
            cd /d %_DRIVE_NAME%:
        )
    )
    if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
    for /f "delims==" %%i in ('set ^| findstr /b "_"') do set %%i=
)
