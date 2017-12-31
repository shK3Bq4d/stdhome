#!/usr/bin/env bash

set -e

if [[ -n "$STDHOME_DIRNAME" ]]; then
	echo "$STDHOME_DIRNAME"
else
	if ! type mrdirname 2>/dev/null; then
		function mrdirname() {
			dirname "$@"
		}
	fi
	cd -P "$(mrdirname "$(mrdirname "$( readlink -f "${BASH_SOURCE[0]}" )")")" &>/dev/null && pwd
fi
