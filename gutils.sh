################################################
#  Global Utility Functions for Shell Scripts  #
################################################

if [[ "${GUTILS_HAS_BEEN_SOURCED}" != true ]]; then
    GUTILS_HAS_BEEN_SOURCED=true

    # ---------- Global Variables ----------
    SCRIPTNAME="$(basename "$0")"
    # shellcheck disable=SC2034
    USAGE="usage: ${SCRIPTNAME}"
    
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
        XDG_CONFIG=/home/"${USER}"
    fi
    
    # shellcheck disable=SC2034
    if [[ -n "${XDG_DATA_HOME}" ]]; then
        XDG_DATA="${XDG_DATA_HOME}"
    else
        XDG_DATA=/home/"${USER}"/.local/share
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
    MSG="$1"; shift

    if [[ -n "$1" ]]; then
        EC="$1"
    else
        EC=1
    fi

    if [[ "${EC}" -eq 2 ]]; then
        MSG="Failed while parsing command-line arguments. Try '${SCRIPTNAME} --help' for more information.\n\n${MSG}"
    fi

    emsg "${MSG}"
    exit "$EC"
}

function emsg() {
    MSG="$1"; shift
    FULL_MSG="[ERROR] $MSG\n"
    >&2 printf "${FULL_MSG}"
    logger -t "${SCRIPTNAME}" "${FULL_MSG}"
}

function dmsg() {
    MSG="$1"; shift

    # shellcheck disable=SC2154
    if [[ "${debug}" = true ]]; then
        printf "[DEBUG] ${MSG}\n"
    fi
}

function imsg() {
    MSG="$1"; shift
    printf ">>> $MSG\n"
}

function notify() {
    notify-send "$(basename "$0")" "$@"
}

function usage() {
    printf "Usage: "
    hspace=false
    for P in "${USAGE_GRAMMAR[@]}"; do
        if [[ "${hspace}" = true ]]; then
            printf "       "
        fi
        printf "${SCRIPTNAME} %s\n" "${P}"
        hspace=true
    done
}

function truncate() {
    rm "${1}" &> /dev/null
    touch "${1}"
}
