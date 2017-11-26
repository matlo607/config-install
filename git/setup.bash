#!/usr/bin/env bash

_files=(".gitattributes" ".gitconfig" ".gitignore")

for _file in ${_files[@]}; do
    cp -i "${_file}" "${HOME}"
done
