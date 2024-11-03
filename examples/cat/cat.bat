@set _BASENAME=%~n0
@set "_ROOT_DIR=%~dp0"

@rem set "_SCRIPT_FILE=https://deno.land/std@0.207.0/examples/%_BASENAME%.ts"
@set "_SCRIPT_FILE=https://jsr.io/@std/examples/%_BASENAME%.ts"
@set _SCRIPT_ARGS="%_ROOT_DIR%%_BASENAME%.bat"

@set _RUN_OPTS=--allow-read

deno run %_RUN_OPTS% "%_SCRIPT_FILE%" %_SCRIPT_ARGS%
