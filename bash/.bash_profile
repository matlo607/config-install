#!/usr/bin/env bash

echo "load .bash_profile"

TERM="xterm-256color"
export TERM

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
