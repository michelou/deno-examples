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

deno run $RUN_OPTS "$SCRIPT_FILE" $SCRIPT_ARGS