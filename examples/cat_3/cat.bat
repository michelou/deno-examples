@set _BASENAME=%~n0
@set "_ROOT_DIR=%~dp0"

@set "_IMPORT_FILE=%_ROOT_DIR%import_map.json"
@set "_SCRIPT_FILE=%_ROOT_DIR%%_BASENAME%.ts"
@set _SCRIPT_ARGS="%_ROOT_DIR%%_BASENAME%.bat"

@set _RUN_OPTS=--allow-read "--importmap=%_IMPORT_FILE%"

deno run %_RUN_OPTS% "%_SCRIPT_FILE%" %_SCRIPT_ARGS%
