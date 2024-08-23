@echo off

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
@rem returns the list of all the dogs
call :get "%_SERVER_HOST%:%_SERVER_PORT%/dogs"
if not %_EXITCODE%==0 goto end

@rem retrieves a single dog by name
call :get "%_SERVER_HOST%:%_SERVER_PORT%/dogs/Syd"
if not %_EXITCODE%==0 goto end

@rem adds a new dog
call :post "{\"name\":\"Tina\",\"age\":4}" "%_SERVER_HOST%:%_SERVER_PORT%/dogs"
if not %_EXITCODE%==0 goto end

@rem returns the list of all the dogs
call :get "%_SERVER_HOST%:%_SERVER_PORT%/dogs"
if not %_EXITCODE%==0 goto end

@rem updates a dog’s age
call :put "{\"name\":\"Roger\",\"age\":2}" "%_SERVER_HOST%:%_SERVER_PORT%/dogs/Roger"

@rem removes a dog from the list
@rem call :delete "%_SERVER_HOST%:%_SERVER_PORT%/dogs/Syd"

@rem returns the list of all the dogs
call :get "%_SERVER_HOST%:%_SERVER_PORT%/dogs"
if not %_EXITCODE%==0 goto end

goto end

@rem #########################################################################
@rem ## Subroutines

:env
set _BASENAME=%~n0

set _DEBUG_LABEL=[%_BASENAME%]
set _ERROR_LABEL=Error:

set _SERVER_HOST=localhost
set _SERVER_PORT=8989

if not exist "%GIT_HOME%\mingw64\bin\curl.exe" (
    echo %_ERROR_LABEL% curl command not found 1>&2
    set _EXITCODE=1
    goto :eof
)
set "_CURL_CMD=%GIT_HOME%\mingw64\bin\curl.exe"
goto :eof

:args
set _HELP=0
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

:help
echo Usage: %_BASENAME% { ^<option^> ^| ^<subcommand^> }
echo.
echo   Options:
echo     -debug      print commands executed by this script
echo     -verbose    print progress messages
echo.
echo   Subcommands:
echo     help        print this help message
goto :eof

@rem input paramter: %1=URL
:get
set "__CMD=GET"
set "__URL=%~1"
set "__CURL_OPTS=-X %__CMD%"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CURL_CMD%" %__CURL_OPTS% "%__URL%" 1>&2
) else if %_VERBOSE%==1 ( echo Respond to the HTTP request %__CMD% "%__URL%" 1>&2)
call "%_CURL_CMD%" %__CURL_OPTS% "%__URL%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% %__CMD% command failed for "%__URL%" 1>&2
    set _EXITCODE=1
    goto :eof
)
echo.
goto :eof

@rem input paramters: %1=JSON data, %2=URL
:post
set "__CMD=POST"
set "__DATA=%~1"
set "__URL=%~2"
set __CURL_OPTS=-X %__CMD% -H "Content-Type: application/json" -d "%__DATA%"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CURL_CMD%" %__CURL_OPTS% "%__URL%" 1>&2
) else if %_VERBOSE%==1 ( echo Respond to the HTTP request %__CMD% "%__URL%" 1>&2
)
call "%_CURL_CMD%" %__CURL_OPTS% "%__URL%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% %__CMD% command failed for "%__URL%" 1>&2
    set _EXITCODE=1
    goto :eof
)
echo.
goto :eof

@rem input paramters: %1=JSON data, %2=URL
:put
set "__CMD=PUT"
set "__DATA=%~1"
set "__URL=%~2"
set __CURL_OPTS=-X %__CMD% -H "Content-Type: application/json" -d "%__DATA%"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CURL_CMD%" %__CURL_OPTS% "%__URL%" 1>&2
) else if %_VERBOSE%==1 ( echo Respond to the HTTP request %__CMD% "%_URL%" 1>&2
)
call "%_CURL_CMD%" %__CURL_OPTS% "%__URL%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% %__CMD% command failed for "%__URL%" 1>&2
    set _EXITCODE=1
    goto :eof
)
echo.
goto :eof

@rem input paramter: %1=URL
:delete
set "__CMD=DELETE"
set "__URL=%~1"
set "__CURL_OPTS=-X %__CMD%"
if %_DEBUG%==1 ( echo %_DEBUG_LABEL% "%_CURL_CMD%" %__CURL_OPTS% "%__URL%" 1>&2
) else if %_VERBOSE%==1 ( echo Respond to the HTTP request %__CMD% "%__URL%" 1>&2
)
call "%_CURL_CMD%" %__CURL_OPTS% "%__URL%"
if not %ERRORLEVEL%==0 (
    echo %_ERROR_LABEL% %__CMD% command failed for "%__URL%" 1>&2
    set _EXITCODE=1
    goto :eof
)
echo.
goto :eof

@rem #########################################################################
@rem ## Cleanups

:end
if %_DEBUG%==1 echo %_DEBUG_LABEL% _EXITCODE=%_EXITCODE% 1>&2
exit /b %_EXITCODE%
endlocal
