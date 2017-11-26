#!/usr/bin/env bash

_files=(".tmux.conf")

for _file in ${_files[@]}; do
    cp -i "${_file}" "${HOME}"
done

./tmux-plugins.bash -i
