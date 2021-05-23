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
    local msg="$1"
    shift

    if [[ -n "$1" ]]; then
        local ec="$1"
        shift
    else
        local ec=1
    fi

    if [[ "${ec}" -eq 2 ]]; then
        msg="Failed while parsing command-line arguments. Try '${SCRIPTNAME} --help' for more information.\n\n${msg}"
    fi

    emsg "${msg}"
    exit "$ec"
}

function emsg() {
    _msg "error" "$@"
}

function dmsg() {
    local msg="$(printf "$@")"

    # shellcheck disable=SC2154
    if [[ "${debug}" = true ]]; then
        _msg "debug" "$@"
    fi
}

function imsg() {
    _msg "info" "$@"
}

function wmsg() {
    _msg "warning" "$@"
}

function _msg() {
    local level="$(echo "${1}" | tr '[:lower:]' '[:upper:]')"
    shift

    local msg="$(printf "$@")"
    local full_msg="$(printf "%s | %s | %s | %s\n" \
        "$(date +"%Y-%m-%d %H:%M:%S")" \
        "${SCRIPTNAME}" \
        "${level}" \
        "${msg}")"

    printf "${full_msg}\n" | \
        tee /dev/stderr | \
        perl -nE 'print s/^[^|]+\|[ ]*(.*)/\1/gr' | \
        logger -t "${SCRIPTNAME}"
}

function notify() {
    notify-send "${SCRIPTNAME}" "$@"
}

function usage() {
    printf "Usage: "

    local hspace=false
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
    rm "${1}" &>/dev/null
    touch "${1}"
}
