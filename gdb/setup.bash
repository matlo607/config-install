#!/usr/bin/env bash

_files=(".gdbinit")

for _file in ${_files[@]}; do
    cp -i "${_file}" "${HOME}"
done
