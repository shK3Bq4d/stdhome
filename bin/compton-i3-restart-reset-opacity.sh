#!/usr/bin/env bash
# ex: set filetype=sh :
##
##Usage:  __SCRIPT__ REMOTEHOST [REMOTEPORT]
##configures whatever action with whatever config
##    REMOTEHOST: remote host where to ssh
##    REMOTEPORT: JMX port (default: 12345)
##
## Author: Jeff Malone, 11 Apr 2018
##

set -euo pipefail

# the use is to prevent windows that are stacked (and hidden) when doing i3 restart
# to no longer being able to be displayed

# inspired from https://github.com/chjj/compton/blob/master/bin/compton-trans
# from which I edited the leading white space sed to not have a fixed number of spaces
xwininfo -root -tree \
  | sed -n 's/^ *    \(0x[[:xdigit:]]*\).*/\1/p' \
  | while IFS=$'\n' read wid; do
    xprop -id "$wid" -remove _NET_WM_WINDOW_OPACITY
  done

echo EOF
exit 0

