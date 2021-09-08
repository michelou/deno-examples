#!/usr/bin/env bash
#
# Copyright (c) 2018-2021 Stéphane Micheloud
#
# Licensed under the MIT License.
#

##############################################################################
## Subroutines

getHome() {
    local source="${BASH_SOURCE[0]}"
    while [ -h "$source" ] ; do
        local linked="$(readlink "$source")"
        local dir="$( cd -P $(dirname "$source") && cd -P $(dirname "$linked") && pwd )"
        source="$dir/$(basename "$linked")"
    done
    ( cd -P "$(dirname "$source")" && pwd )
}

##############################################################################
## Environment setup

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

ROOT_DIR="$(getHome)"

RUN_OPTS=--allow-net

SCRIPT_FILE=$ROOT_DIR/${BASENAME/.sh/.ts}
SCRIPT_ARGS=

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
GREP_PAT=deno
unset CYGPATH_CMD
if $cygwin || $mingw || $msys; then
    CYGPATH_CMD="$(which cygpath 2>/dev/null)"
    GREP_PAT="$($CYGPATH_CMD $(which deno))"
fi
if [[ ! $(ps -eaf | grep "$GREP_PAT") ]]; then
    echo "[INFO] Start process listening on port 8080" 1>&2
    deno run $RUN_OPTS "$SCRIPT_FILE" $SCRIPT_ARGS &
fi
## client request
echo "[INFO] Respond to the cURL request on port 8080" 1>&2
curl localhost:8080
