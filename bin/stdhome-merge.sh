#!/usr/bin/env bash

set -e
DIR="$( cd -P "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )"
source $DIR/dot.lockfunctions
exlock_now || { echo "Couldn't aquire exclusive lock" && exit 1; }
DIR="$( cd -P "$( dirname $(readlink  -f "${BASH_SOURCE[0]}" ) )/.." && pwd )"
$DIR/bin/stdhome-remove-deadlinks.sh
unset GIT_DIR
unset GIT_WORK_TREE

cd $DIR
branch=stdhome
git remote show | grep -q . && \
	git merge -m automerge $(git remote show | sed -r -e "s/$/\\/$branch/")
set -x
bash -x $DIR/bin/stdhome-remove-deadlinks.sh
$DIR/bin/stdothers.sh | while read repo; do
	git remote show | grep -q . && \
		git merge -m automerge $(git remote show | sed -r -e "s/$/\\/$branch/")
	set +x
done
exit 0
