#!/usr/bin/env bash
# Automatically exclude directories to sync from Dropbox
# for faster sync and smaller footprint
set -eu

DROPBOX=~/Dropbox

# List everything currently in ~/Dropbox
ALL=$(ls -1 $DROPBOX)

# List the files/folders to sync
INCLUDE=("Documents Writing")

IFS=$'\n'
for item in $ALL; do
    if ! [[ " ${INCLUDE[@]} " =~ " ${item} " ]]; then
        dropbox exclude add "${DROPBOX}/${item}"
    fi
done
unset IFS
