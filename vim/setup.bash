#!/usr/bin/env bash

_files=("vimrc")

VIMCFG_ROOT="${HOME}/.vim"
mkdir -p "${VIMCFG_ROOT}"

for _file in ${_files[@]}; do
    cp -i "${_file}" "${VIMCFG_ROOT}"
done

./vim-plugins.bash -i
