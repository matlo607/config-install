#!/usr/bin/env bash

echo "load .bash_profile"

#export TERM="xterm-256color"

if [ -f "${HOME}/.bashrc" ]; then
    . "${HOME}/.bashrc"
fi

if [ -f "${HOME}/.cargo/bin" ]; then
    export PATH="${HOME}/.cargo/bin:${PATH}"
fi
