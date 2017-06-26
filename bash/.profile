#!/usr/bin/env bash

echo "load .profile"

if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi
