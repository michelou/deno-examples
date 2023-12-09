#!/usr/bin/env bash

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [[ -h "$source" ]]; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

# use variable EXITCODE
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

error() {
    local ERROR_LABEL="[91mError:[0m"
    echo "$ERROR_LABEL $1" 1>&2
}

debug() {
    local DEBUG_LABEL="[46m[DEBUG][0m"
    $DEBUG && echo "$DEBUG_LABEL $1" 1>&2
}

warning() {
    local WARNING_LABEL="[46m[WARNING][0m"
    echo "$WARNING_LABEL $1" 1>&2
}

args() {
    [[ $# -eq 0 ]] && HELP=true && return 1

    for arg in "$@"; do
        case "$arg" in
        ## options
        -verbose) VERBOSE=true ;;
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        help)     HELP=true ;;
        stop)     STOP=true ;;
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
}

mixed_path() {
    if [[ -x "$CYGPATH_CMD" ]]; then
        $CYGPATH_CMD -am $1
    elif $mingw || $msys; then
        echo $1 | sed 's|/|\\\\|g'
    else
        echo $1
    fi
}

getPID() {
    if $IS_WIN; then
        ## Windows process
        local pid="$(netstat -aon | grep $SERVER_PORT | grep LISTENING | tr -s ' ' | cut -d ' ' -f 6)"
        [[ -z $pid ]] && echo 0 && return 1
        pid="$(tasklist -nh -fi "PID eq $pid" | grep $DENO_CMD | tr -s ' ' | cut -d ' ' -f 2)"
        [[ -z $pid ]] && pid=0
        echo $pid
    else
        local proc_n=$(ps -f | grep -c "$DENO_CMD")
       echo $proc_n
    fi
}

startServer() {
    if $IS_WIN; then
        ## Windows process
        echo "222222222222222 eval start \"$SERVER_TITLE\" $DENO_CMD run $RUN_OPTS $(mixed_path $SCRIPT_FILE) $SCRIPT_ARGS" 1>&2
        ##eval cmd "/c start \"$SERVER_TITLE\" $DENO_CMD run $RUN_OPTS $(mixed_path $SCRIPT_FILE) $SCRIPT_ARGS"
        eval cmd "dir & exit"
    else
        $DENO_CMD run $RUN_OPTS $(mixed_path $SCRIPT_FILE) $SCRIPT_ARGS
    fi
}

killPID() {
    local pid=$1
    $DEBUG & debug "killPID: pid=$pid"
    if $IS_WIN; then
        ## Windows process
        eval "taskkill //pid $PID 1>NUL"
        [[ $? -eq 0 ]] || ( EXITCODE=1 && return 0 )
    else
        eval "1==1"
    fi
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

ROOT_DIR="$(getHome)"
PROJECT_NAME="$(basename $ROOT_DIR)"

SCRIPT_FILE="$ROOT_DIR/src/${PROJECT_NAME}.ts"
SCRIPT_ARGS=

RUN_OPTS="--allow-env --allow-net"

SERVER_HOST=localhost
SERVER_PORT=8989
SERVER_TITLE="$PROJECT_NAME:$SERVER_PORT"

cygwin=false
mingw=false
msys=false
darwin=false
case "$(uname -s)" in
    CYGWIN*) cygwin=true ;;
    MINGW*)  mingw=true ;;
    MSYS*)   msys=true ;;
    Darwin*) darwin=true
esac
unset CYGPATH_CMD
if $cygwin || $mingw || $msys; then
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
    DENO_CMD="deno.exe"
    IS_WIN=true
else
    DENO_CMD=deno
    IS_WIN=false
fi

HELP=false
STOP=false
VERBOSE=false
args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

PID="$(getPID)"
if [[ $PID == 0 ]]; then
    startServer
elif $STOP; then
    killPID "$PID"
fi
