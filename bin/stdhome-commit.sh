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
branch=stdhome
if git commit -m "auto commit from $HOSTNAME" .; then
	for remote in $(git remote show); do
		git fetch $remote $branch
	done
	git remote show | grep -q . && \
		git merge $(git remote show | sed -r -e "s/$/\\/$branch/")
	for remote in $(git remote show); do
		git push -u $remote $branch
	done
fi
$DIR/bin/stdothers.sh -e | while read repo; do
	set -x
	cd $repo
	branch=$(basename $repo)
	if git commit -am "auto commit from $HOSTNAME"; then
		for remote in $(git remote show); do
			git fetch $remote $branch 
		done
		git remote show | grep -q . && \
			git merge $(git remote show | sed -r -e "s/$/\\/$branch/")
		for remote in $(git remote show); do
			git push -u $remote $branch
		done
	fi
	set +x
done
