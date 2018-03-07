#!/bin/bash

sourced=0

if [ -n "$LANG" ]; then
    saved_lang="$LANG"
    [ -f "$HOME/.i18n" ] && . "$HOME/.i18n" && sourced=1
    LANG="$saved_lang"
    unset saved_lang
else
    for langfile in /etc/locale.conf "$HOME/.i18n" ; do
        [ -f $langfile ] && . $langfile && sourced=1
    done
fi
