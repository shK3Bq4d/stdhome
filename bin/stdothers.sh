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
cd $(stdhome-dirname.sh)
cd ..
ls -1d std*/ |\
	grep -vE 'noexternalcheckout|stdhome' |\
	xargs -r realpath

