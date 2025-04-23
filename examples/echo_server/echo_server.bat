@set "_ROOT_DIR=%~dp0"
@rem @set "_SCRIPT_FILE=https://deno.land/std@0.105.0/examples/echo_server.ts"
@set "_SCRIPT_FILE=%_ROOT_DIR%echo_server.ts"
@set _SCRIPT_ARGS=

@rem deno run --allow-net 
deno run --allow-net "%_SCRIPT_FILE%" %_SCRIPT_ARGS%
 