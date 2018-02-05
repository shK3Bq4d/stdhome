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
DIR="$( cd -P "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )"
cd $($DIR/stdhome-dirname.sh)
cd ..
excludepattern='noexternalcheckout|stdhome' 
[[ $# -eq 1 && $1 == '-e' ]] && excludepattern='stdhome' 
ls -1d std*/ |\
	grep -vE "$excludepattern" |\
	xargs -r realpath

