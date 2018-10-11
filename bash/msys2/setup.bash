#!/usr/bin/env bash

_files=(".bash_profile" ".bashrc" ".bash_aliases")

for _file in ${_files[@]}; do
    cp -i "${_file}" "${HOME}"
done
