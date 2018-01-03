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
	git push $remote $branch
done
$DIR/bin/stdothers.sh -e | while read repo; do
	set -x
	#export GIT_DIR="$repo/.git"
	#export GIT_WORK_TREE="$HOME"
	#git config status.showuntrackedfiles no
	#git config core.worktree "$GIT_WORK_TREE"
	cd $repo
	branch=$(basename $repo noexternalcheckout)
	if [[ "$repo" != *noexternalcheckout ]]; then
		find "$repo" -mindepth 1 -not -path '*/.git*' -print -delete
	fi
	for remote in $(git remote show); do
		if [[ "$remote" == ksgitlab ]] && [[ -f ~/.ssh/id_rsa_ks ]] && ! ssh-add -L | grep -q id_rsa_ks; then
			ssh-add ~/.ssh/id_rsa_ks
		fi
		git push $remote $branch
	done
	set +x
done
