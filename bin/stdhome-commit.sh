#!/usr/bin/env bash

set -e
unset GIT_DIR
unset GIT_WORK_TREE
DIR="$( cd -P "$( dirname $(readlink  -f "${BASH_SOURCE[0]}" ) )/.." && pwd )"

if [[ ! -f ~/.gitconfig ]]; then
	echo -n "Enter your name and press [ENTER]: "
	read name
	echo -n "Enter your email and press [ENTER]: "
	read email
	echo "
[user]
    name = $name
	email = $email
	" > ~/.gitconfig
fi


cd $DIR
$DIR/bin/stdhome-remove-deadlinks.sh
git commit -am "auto commit $(date)" || true
$DIR/bin/stdothers.sh -e | while read repo; do
	cd $repo
	git commit -am "auto commit $(date)" || true
done
$DIR/bin/stdhome-pull.sh
$DIR/bin/stdhome-push.sh
