#!/usr/bin/env bash

echo "load .bash_aliases"

if [[ "$(uname)" = "Darwin" ]] ; then
    if [[ -x "$(which gdircolors)" ]]; then
        alias dircolors='gdircolors'
        export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"
        export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:${MANPATH}"
    else
        echo "Please install coreutils package:  brew install coreutils"
    fi
    if [[ -x "$(which gfind)" ]]; then
        export PATH="${HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin:${PATH}"
        export MANPATH="${HOMEBREW_PREFIX}/opt/findutils/libexec/gnuman:${MANPATH}"
    else
        echo "Please install findutils package:  brew install findutils"
    fi

    if [[ -x "$(which gsed)" ]]; then
        export PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:${PATH}"
        export MANPATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuman:${MANPATH}"
    else
        echo "Please install gnu-sed package:  brew install gnu-sed"
    fi

    if [ -f "/Applications/Firefox.app/Contents//MacOS/firefox" ]; then
        alias firefox="/Applications/Firefox.app/Contents//MacOS/firefox --new-tab"
    fi
    if [ -f "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
        alias vscode="/Applications/Visual\\ Studio\\ Code.app/Contents/Resources/app/bin/code"
    fi
fi

# enable color support of ls and also add handy aliases
if [[ -x "$(which dircolors)" || -x "$(which gdircolors)" ]]; then
    _color_flags="--color=auto"

    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls="ls ${_color_flags}"
    alias grep="grep ${_color_flags}"
    alias fgrep="fgrep ${_color_flags}"
    alias egrep="egrep ${_color_flags}"

    # some more ls aliases
    alias ll="ls ${_color_flags} -alF"
    alias la="ls ${_color_flags} -A"
    alias l="ls ${_color_flags} -CF"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
