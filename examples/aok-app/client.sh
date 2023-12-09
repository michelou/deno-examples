#!/usr/bin/env bash

##############################################################################
## Subroutines

# use variable EXITCODE
cleanup() {
    [[ $1 =~ ^[0-1]$ ]] && EXITCODE=$1

    debug "EXITCODE=$EXITCODE"
    exit $EXITCODE
}

error() {
    local ERROR_LABEL="[91mError:[0m"
    echo -e "$ERROR_LABEL $1" 1>&2
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
        -debug)   DEBUG=true ;;
        -verbose) VERBOSE=true ;;
        -*)
            error "Unknown option $arg"
            EXITCODE=1 && return 0
            ;;
        ## subcommands
        help)     HELP=true ;;
        *)
            error "Unknown subcommand $arg"
            EXITCODE=1 && return 0
            ;;
        esac
    done
}

## input paramter: $1=URL
get() {
    local cmd=GET
    local url="$1"
    local curl_opts="-X $cmd"
    if $DEBUG; then 
        debug "\"$CURL_CMD\" $curl_opts \"$url\""
    elif $VERBOSE; then
        echo "Respond to the HTTP request $cmd \"$url\"" 1>&2
    fi
    eval "$CURL_CMD" $curl_opts "$url"
    if [[ $? -ne 0 ]]; then
        echo 1>&2  ## add newline
        error "$cmd command failed for \"$url\""
        cleanup 1
    fi
    echo 1>&2  ## add newline
}

## input paramters: %1=JSON data, %2=URL
post() {
    local cmd=POST
    local data="$1"
    local url="$2"
    local curl_opts="-X $cmd -H \"Content-Type: application/json\" -d \"$data\""
    if $DEBUG; then
        debug "\"$CURL_CMD\" $curl_opts \"$url\""
    elif $VERBOSE; then
        echo "Respond to the HTTP request $cmd \"$url\"" 1>&2
    fi
    eval "$CURL_CMD" $curl_opts "$url"
    if [[ $? -ne 0 ]]; then
        echo 1>&2  ## add newline
        error "$cmd command failed for \"$url\""
        cleanup 1
    fi
    echo 1>&2  ## add newline
}

## input paramters: $1=JSON data, $2=URL
put() {
    local cmd=PUT
    local data="$1"
    local url="$2"
    local curl_opts="-X $cmd -H \"Content-Type: application/json\" -d \"$data\""
    if $DEBUG; then
        debug "\"$CURL_CMD\" $curl_opts \"$url\""
    elif $VERBOSE; then
        echo "Respond to the HTTP request $cmd \"$url\"" 1>&2
    fi
    eval "$CURL_CMD" $curl_opts "$url"
    if [[ $? -ne 0 ]]; then
        echo 1>&2  ## add newline
        error "$cmd command failed for \"$url\""
        cleanup 1
    fi
    echo 1>&2  ## add newline
}

##############################################################################
## Environment setup
## returns the list of all the dogs

BASENAME=$(basename "${BASH_SOURCE[0]}")

EXITCODE=0

SERVER_HOST=localhost
SERVER_PORT=8989

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
    CURL_CMD="$(which curl.exe)"
else
    CURL_CMD=curl
fi

DEBUG=false
HELP=false
VERBOSE=false
args "$@"
[[ $EXITCODE -eq 0 ]] || cleanup 1

##############################################################################
## Main

## returns the list of all the dogs
get "$SERVER_HOST:$SERVER_PORT/dogs"

## retrieves a single dog by name
get "$SERVER_HOST:$SERVER_PORT/dogs/Syd"

## adds a new dog
post "{\"name\":\"Tina\",\"age\":4}" "$SERVER_HOST:$SERVER_PORT/dogs"

## returns the list of all the dogs
get "$SERVER_HOST:$SERVER_PORT/dogs"

## updates a dog’s age
put "{\"name\":\"Roger\",\"age\":2}" "$SERVER_HOST:$SERVER_PORT/dogs/Roger"

## returns the list of all the dogs
get "$SERVER_HOST:$SERVER_PORT/dogs"

exit 0
