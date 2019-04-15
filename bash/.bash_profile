#!/usr/bin/env bash

echo "load .bash_profile"

#export TERM="xterm-256color"

if [[ "$(uname)" = "Darwin" ]] ; then
    export SHELL=$(which bash)
fi

if [ -f "${HOME}/.bashrc" ]; then
    . "${HOME}/.bashrc"
fi
