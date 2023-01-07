@set "_ROOT_DIR=%~dp0"
@set "_SCRIPT_FILE=%_ROOT_DIR%file_search.ts"
@set _SCRIPT_ARGS=%*

@set _RUN_OPTS=--allow-read

deno run %_RUN_OPTS% "%_SCRIPT_FILE%" %_SCRIPT_ARGS%
