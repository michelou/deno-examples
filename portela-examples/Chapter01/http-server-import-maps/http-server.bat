@echo off
set _BASENAME=%~n0
set "_ROOT_DIR=%~dp0"

set "_DEPS_FILE=%_ROOT_DIR%deps.ts"
set "_LOCK_FILE=%_ROOT_DIR%lock.json"

if not exist "%_LOCK_FILE%" (
    echo [INFO] Generate lock file 1>&2
    deno cache --lock="%_LOCK_FILE%" --lock-write "%_DEPS_FILE%"
)
set "_IMPORT_FILE=%_ROOT_DIR%import_map.json"
set _RUN_OPTS="--lock=%_LOCK_FILE%" "--import-map=%_IMPORT_FILE%" --allow-net

set _SERVER_PORT=8081
for %%i in ("%_ROOT_DIR%.") do set "_SERVER_TITLE=%%~ni.%_SERVER_PORT%"
set _SERVER_PID=
for /f "tokens=1,2,*" %%i in ('tasklist /nh /fi "windowtitle eq %_SERVER_TITLE%" /fi "imagename eq deno.exe"^|findstr deno.exe') do (
    set _SERVER_PID=%%j
)
set "_SCRIPT_FILE=%_ROOT_DIR%%_BASENAME%.ts"
set _SCRIPT_ARGS=%_SERVER_PORT%

if not defined _SERVER_PID (
    echo [INFO] Start process "%_SERVER_TITLE%" listening on port %_SERVER_PORT% 1>&2
    start "%_SERVER_TITLE%" deno run %_RUN_OPTS% "%_SCRIPT_FILE%" %_SCRIPT_ARGS%
)
@rem client request
set "_CURL_CMD=%GIT_HOME%\mingw64\bin\curl.exe"

echo [INFO] Respond to the cURL request on port %_SERVER_PORT% 1>&2
"%_CURL_CMD%" localhost:%_SERVER_PORT%
