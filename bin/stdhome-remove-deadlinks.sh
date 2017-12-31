#!/usr/bin/env bash

set -u
export STDHOME_DIRNAME="$(stdhome-dirname.sh)"
find ~ -type l -lname *${STDHOME_DIRNAME}/* -and -not -path "${STDHOME_DIRNAME}/*" -and -not -exec test -e {} \; -print -delete 2>/dev/null
exit 0
