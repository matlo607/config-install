#!/usr/bin/env bash

test -f ~/.bash_aliases && . ~/.bash_aliases

function __normalize_path()
{
    p="${1}"
    if [[("$(uname -s)" =~ MINGW64_NT* || "$(uname -s)" =~ MINGW32_NT* || "$(uname -s)" =~ MSYS_NT*)]]; then
        p="$(cygpath --dos "${p}")"
        p="$(cygpath --unix "${p}")"
    fi
    echo "${p}"
}

function path_append()
{
    p=$(__normalize_path "${1}")
    if [ -d "${p}" ] && [[ ":${PATH}:" != *":${p}:"* ]]; then
        PATH="${PATH:+"${PATH}:"}${p}"
    fi
}

function path_prepend()
{
    p=$(__normalize_path ${1})
    if [ -d "${p}" ] && [[ ":${PATH}:" != *":${p}:"* ]]; then
        PATH="${PATH:+"${p}:${PATH}"}"
    fi
}

# LLVM
#path_append "c:\Program Files\LLVM\bin"

# cygwin64 (not compatible with msys2)
#path_append "c:\cygwin64\bin"

# Cmd.exe
path_append "c:\Windows\System32"
# Powershell
path_append "c:\Windows\System32\WindowsPowerShell\v1.0"

# Chocolatey
path_append "c:\ProgramData\chocolatey\bin"

# Sublime 3
path_append "c:\Program Files\Sublime Text 3"

# Perforce
#path_append "c:\Program Files\Perforce"

# Packer
#path_append "c:\HashiCorp"
# Vagrant
#path_append "c:\HashiCorp\bin"
# CMake
#path_append "c:\Program Files\CMake\bin"
# Notepad++
path_append "c:\Program Files\Notepad++"

export PATH

# launch ssh-agent
eval $(ssh-agent -s)
ssh-add ${HOME}/.ssh/*_rsa
