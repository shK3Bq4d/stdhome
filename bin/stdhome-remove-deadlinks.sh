#!/usr/bin/env bash

set -u
DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export STDHOME_DIRNAME="$($DIR/stdhome-dirname.sh)"
find ~ -type l -lname *${STDHOME_DIRNAME}/* -and -not -path "${STDHOME_DIRNAME}/*" -and -not -exec test -e {} \; -print -delete 2>/dev/null
exit 0
