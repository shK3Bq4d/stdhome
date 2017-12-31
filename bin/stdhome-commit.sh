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
if git commit -m "auto commit from $HOSTNAME" .; then
	for remote in $(git remote show); do
		git pull $remote stdhome --no-rebase
		git push -u $remote stdhome
	done
fi
$DIR/bin/stdothers.sh | while read repo; do
	set -x
	export GIT_DIR="$repo/.git"
	export GIT_WORK_TREE="$HOME"
	git config status.showuntrackedfiles no
	git config core.worktree "$GIT_WORK_TREE"
	branch=$(basename $repo)
	if git commit -m "auto commit from $HOSTNAME" "$GIT_WORK_TREE"; then
		for remote in $(git remote show); do
			git pull $remote $branch --no-rebase
			git push -u $remote $branch
		done
	fi
	set +x
done
unset GIT_DIR
unset GIT_WORK_TREE
$DIR/bin/stdhome-push.sh
