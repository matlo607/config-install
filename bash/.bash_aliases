#!/usr/bin/env bash

echo "load .bash_aliases"

# enable color support of ls and also add handy aliases
if [[ -x "$(which dircolors)" || -x "$(which gdircolors)" ]]; then
    if [[ "$(uname)" = "SunOS" && -x "$(which gdircolors)" ]]; then
        alias dircolors='gdircolors'
    fi
    _color_flags="--color=auto"

    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    if [[ "$(uname)" = "SunOS" ]] ; then
        if [ -x "$(which gls)" ]; then
            alias ls="gls ${_color_flags}"
        fi
        if [ -x "$(which ggrep)" ]; then
            alias grep="ggrep ${_color_flags}"
        fi
        if [ -x "$(which gfgrep)" ]; then
            alias fgrep="gfgrep ${_color_flags}"
        fi
        if [ -x "$(which gegrep)" ]; then
            alias egrep="gegrep ${_color_flags}"
        fi
    else
        alias ls="ls ${_color_flags}"
        alias grep="grep ${_color_flags}"
        alias fgrep="fgrep ${_color_flags}"
        alias egrep="egrep ${_color_flags}"
    fi
fi

if [[ "$(uname)" = "SunOS" ]] ; then
    gnu_cmds=("awk" "diff" "echo" "make" "mv" "ranlib" "sed" "tar")
    for cmd in ${gnu_cmds[@]}; do
        if [ -x "$(which "g${cmd}")" ]; then
            alias ${cmd}="g${cmd}"
        fi
    done

    # some more ls aliases
    if [ -x "$(which gls)" ]; then
        alias ll="gls ${_color_flags} -alF"
        alias la="gls ${_color_flags} -A"
        alias l="gls ${_color_flags} -CF"
    fi
else
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

