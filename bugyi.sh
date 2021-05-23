#!/bin/bash

################################################
#  Global Utility Functions for Shell Scripts  #
################################################

if [[ "${BUGYI_HAS_BEEN_SOURCED}" != true ]]; then
    BUGYI_HAS_BEEN_SOURCED=true

    # ---------- Global Variables ----------
    SCRIPTNAME="$(basename "$0")"

    # ---------- XDG User Directories ----------
    # shellcheck disable=SC2034
    if [[ -n "${XDG_RUNTIME_DIR}" ]]; then
        XDG_RUNTIME="${XDG_RUNTIME_DIR}"
    else
        XDG_RUNTIME=/tmp
    fi
    
    # shellcheck disable=SC2034
    if [[ -n "${XDG_CONFIG_HOME}" ]]; then
        XDG_CONFIG="${XDG_CONFIG_HOME}"
    else
        XDG_CONFIG="${HOME}"/.config
    fi
    
    # shellcheck disable=SC2034
    if [[ -n "${XDG_DATA_HOME}" ]]; then
        XDG_DATA="${XDG_DATA_HOME}"
    else
        XDG_DATA="${HOME}"/.local/share
    fi
    
    # shellcheck disable=SC2034
    MY_XDG_RUNTIME="${XDG_RUNTIME}"/"${SCRIPTNAME}"
    # shellcheck disable=SC2034
    MY_XDG_CONFIG="${XDG_CONFIG}"/"${SCRIPTNAME}"
    # shellcheck disable=SC2034
    MY_XDG_DATA="${XDG_DATA}"/"${SCRIPTNAME}"
fi

# ---------- Function Definitions ----------
function die() {
    local msg="$1"; shift

    if [[ -n "$1" ]]; then
        EC="$1"; shift
    else
        EC=1
    fi

    if [[ "${EC}" -eq 2 ]]; then
        msg="Failed while parsing command-line arguments. Try '${SCRIPTNAME} --help' for more information.\n\n${msg}"
    fi

    emsg "${msg}"
    exit "$EC"
}

function emsg() {
    local msg="$(printf "$@")"; shift
    local full_msg="[ERROR] $msg\n"
    >&2 printf "${full_msg}"
    logger -t "${SCRIPTNAME}" "${full_msg}"
}

function dmsg() {
    local msg="$(printf "$@")"; shift

    # shellcheck disable=SC2154
    if [[ "${debug}" = true ]]; then
        local full_msg="[DEBUG] ${msg}\n"
        printf "${full_msg}"
        logger -t "${SCRIPTNAME}" "${full_msg}"
    fi
}

function imsg() {
    local msg="$(printf "$@")"; shift
    printf "%s: $msg\n" "${SCRIPTNAME}"
}

function wmsg() {
    local msg="$(printf "$@")"; shift
    printf "[WARNING] $msg\n"
}

function notify() {
    notify-send "${SCRIPTNAME}" "$@"
}

function usage() {
    printf "Usage: "

    hspace=false
    for P in "${USAGE_GRAMMAR[@]}"; do
        if [[ "${hspace}" = true ]]; then
            printf "       "
        else
            hspace=true
        fi

        printf "${SCRIPTNAME} %s\n" "${P}"
    done
}

function truncate() {
    rm "${1}" &> /dev/null
    touch "${1}"
}
