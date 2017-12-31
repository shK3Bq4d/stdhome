#!/usr/bin/env bash                                            
# ex: set filetype=sh :
##
##Usage:  __SCRIPT__ REMOTEHOST [REMOTEPORT]
##configures whatever action with whatever config
##    REMOTEHOST: remote host where to ssh
##    REMOTEPORT: JMX port (default: 12345)
##
## Author: Jeff Malone, 03 Dec 2017
##

set -euo pipefail

STDHOME_DIRNAME="$(stdhome-dirname.sh)"
p=$(pwd)
set -x
for f in "$@"; do
	cd "$p"
	[[ ! -s "$f" ]] && echo "ABORTING: not a symlink $f" && exit 1
	g="$(realpath -s "$f")"
	f="$(readlink -f "$f")"
	cd "$STDHOME_DIRNAME"
	git show "$g" &>/dev/null && echo "ABORTING: symlink in stdhome $g" && exit 1
	! git show "$f" &>/dev/null && echo "ABORTING: not from stdhome $f" && exit 1
done
echo checks done
for f in "$@"; do
	cd "$p"
	g="$(realpath -s "$f")"
	f="$(readlink -f "$f")"
	cd "$STDHOME_DIRNAME"
	t=$(mktemp -u)
	rm "$g"
	mv -f "$f" "$g"
	git rm "$f"
done
exit 0

