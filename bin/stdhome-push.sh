#!/usr/bin/env bash

set -ex
DIR="$( cd -P "$( dirname $(readlink  -f "${BASH_SOURCE[0]}" ) )/.." && pwd )"
unset GIT_DIR
unset GIT_WORK_TREE

cd $DIR
[[ ! -d ~/.ssh/c ]] && mkdir ~/.ssh/c
[[ -f ~/.ssh/config ]] && chmod g-rwx,o-rwx ~/.ssh/config
branch=stdhome
for remote in $(git remote show); do
	if [[ "$remote" == ksgitlab ]] && [[ -f ~/.ssh/id_rsa_ks ]] && ! ssh-add -L | grep -q id_rsa_ks; then
		ssh-add ~/.ssh/id_rsa_ks
	fi
	if git diff --stat --cached $remote/$branch | grep -q .; then
		git push $remote $branch
	fi
done
$DIR/bin/stdothers.sh | while read repo; do
	set -x
	#export GIT_DIR="$repo/.git"
	#export GIT_WORK_TREE="$HOME"
	#git config status.showuntrackedfiles no
	#git config core.worktree "$GIT_WORK_TREE"
	cd $repo
	branch=$(basename $repo noexternalcheckout)
	test $branch == stdswift && branch=$(git rev-parse --abbrev-ref HEAD)
	if [[ "$repo" != *noexternalcheckout ]]; then
		find "$repo" -mindepth 1 -not -path '*/.git*' -print -delete
	fi
	for remote in $(git remote show); do
		if [[ "$remote" == ksgitlab ]] && [[ -f ~/.ssh/id_rsa_ks ]] && ! ssh-add -L | grep -q id_rsa_ks; then
			ssh-add ~/.ssh/id_rsa_ks
		fi
		if git diff --stat --cached $remote/$branch | grep -q .; then
			git push $remote $branch
		fi
	done
	set +x
done
