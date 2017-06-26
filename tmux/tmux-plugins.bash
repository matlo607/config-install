#!/usr/bin/env bash
#shopt -s extglob

#set -o nounset
set -o errexit
set -o pipefail

export PS4="+${BASH_SOURCE[0]}:${LINENO}:${FUNCNAME}: "
set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .bash)"
#__root="$(cd "$(dirname "${__dir}")" && pwd)"
verbose=0

prefix="~/.tmux"

repositories=("https://github.com/tmux-plugins/tpm.git"
              "https://github.com/tmux-plugins/tmux-resurrect.git")

plugin_manager_dir="$( sed -r 's/.*\/(.*)\.git/\1/' <<< "${repositories[0]}" )"
echo "plugin_manager_dir : ${plugin_manager_dir}"

function __parse_args() {
    if [[ $# -eq 0 ]]; then
        __usage
        exit 1
    fi

    while true; do
        case ${1} in
            -h|-\?|--help)
                __usage
                exit 0
                ;;
            -p|--prefix)
                if [ -n "$2" ]; then
                    prefix=$2
                    shift
                else
                    printf 'ERROR: "--prefix" requires a non-empty option argument.\n' >&2
                    exit 1
                fi
                ;;
            --prefix=?*)
                prefix=${1#*=} # Delete everything up to "=" and assign the remainder.
                ;;
            --prefix=)         # Handle the case of an empty --prefix=
                printf 'ERROR: "--prefix" requires a non-empty option argument.\n' >&2
                exit 1
                ;;
            -i|--install)
                install=true
                ;;
            -u|--uninstall)
                install=false
                ;;
            -v|--verbose)
                verbose=$((verbose + 1)) # Each -v argument adds 1 to verbosity.
                ;;
            --)              # End of all options.
                shift
                break
                ;;
            -?*)
                printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
                ;;
            *)               # Default case: If no more options then break out of the loop.
                break
        esac

        shift
    done

    if [[ -z ${install+1} ]]; then
        __usage
        exit 1
    fi

    echo "install = $install"
    echo "verbose = $verbose"
    echo "prefix = $prefix"
}

function __usage ()
{
    cat <<-USAGE_HELP
Usage: ${__base} [flags]
    Options:
        -h|--help: Display this help
        -i|--install: Install tmux's plugins in the current directory
        -u|--uninstall: Uninstall tmux's plugins in the current directory
        -p|--prefix: Location for tmux's configuration files
USAGE_HELP
}

function __main () {

    __parse_args $@

    if ${install}; then
        echo "install mode"
        __plugins_install_all
    else
        echo "uninstall mode"
        __plugins_uninstall_all
    fi

    exit 0
}

function __install_plugin () {
    if [[ -z ${1+x} ]]; then
        echo "missing argument : plugin's repository address"
        exit 1
    fi

    local git_url="$1"
    local plugin_dir=$( echo "${git_url}" | sed -r 's/.*\/(.*)\.git/\1/' )

    #check if the plugin has already been installed
    if [[ ! -d "${prefix}/plugins/${plugin_dir}" ]]; then
        git clone "${git_url}" "${prefix}/plugins/${plugin_dir}"
        if [[ $? -ne 0 ]]; then
            echo "cloning of ${git_url} failed"
            exit 1
        else
            echo "install plugin ${plugin_dir} [OK]"
        fi
    else
        echo "${plugin_dir} has already been installed, nothing to do"
    fi
}

function __plugins_install_all () {
    mkdir -p "${prefix}/plugins"
    pushd .
    cd "${prefix}/plugins"

    for repo in "${repositories[@]}"; do
        __install_plugin ${repo}
    done

    popd
}

function __plugins_uninstall_all ()
{
    if [[ -d "${prefix}/plugins" ]]; then
        rm -rf "${prefix}/plugins"
        echo "all plugins were removed"
    fi
}

__main $@
