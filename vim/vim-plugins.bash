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

prefix="${HOME}/.vim"

repositories=( "https://github.com/tpope/vim-pathogen.git"
               "https://github.com/scrooloose/nerdtree.git"
               "https://github.com/Xuyuanp/nerdtree-git-plugin.git"
               "https://github.com/majutsushi/tagbar.git"
               "https://github.com/scrooloose/syntastic.git"
               "https://github.com/sjl/gundo.vim.git"
               "https://github.com/elzr/vim-json.git"
               "https://github.com/vim-airline/vim-airline.git"
               "https://github.com/vim-airline/vim-airline-themes.git"
               "https://github.com/suan/vim-instant-markdown.git")

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
        -i|--install: Install vim's plugins in the current directory
        -u|--uninstall: Uninstall vim's plugins in the current directory
        -p|--prefix: Location for vim's configuration files
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
    if [[ ! -d "${plugin_dir}" ]]; then
        git clone "${git_url}" "${plugin_dir}"
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

function __check_pathogen () {
    if [[ ! -d "${plugin_manager_dir}" ]]; then
        local repo_pathogen="${repositories[0]}"
        __install_plugin ${repo_pathogen}
    fi

    if [[ ! -d "autoload" ]]; then
        ln -fs ${plugin_manager_dir}/autoload autoload
    fi
}

function __plugins_install_all () {
    mkdir -p "${prefix}/bundle"
    pushd .
    cd "${prefix}"

    __check_pathogen

    cd "${prefix}/bundle"

    local repo_pathogen="${repositories[0]}"
    for repo in "${repositories[@]}"; do
        if [[ "${repo}" != "${repo_pathogen}" ]]; then
            __install_plugin ${repo}
        fi
    done

    popd
}

function __plugins_uninstall_all ()
{
    if [ \( -d "${prefix}/${plugin_manager_dir}" \) -o \( -d "${prefix}/autoload" \) ]; then
        echo "removing plugin manager ${plugin_manager_dir}"
        rm -rf "${prefix}/${plugin_manager_dir}" "${prefix}/autoload"
    else
        echo "plugin manager not found"
    fi

    if [[ -d "${prefix}/bundle" ]]; then
        rm -rf "${prefix}/bundle"
        echo "all plugins were removed"
    fi
}

__main $@
