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
[[ ! -d ~/.ssh/c ]] && mkdir -p ~/.ssh/c
[[ -f ~/.ssh/config ]] && chmod g-rwx,o-rwx ~/.ssh/config
branch=stdhome

f=$DIR/bin/dot.bashfunctions
if [[ -f $f && -f ~/.ssh/id_rsa ]] && ! git config --list | grep -qE '^remote\.[^.]*\.url=http'; then
    source $f
       start_agent_if_not_started
    mr_ssh_add
fi
test -x ~/bin/container-ip.sh && ~/bin/container-ip.sh &>/dev/null
for remote in $(git remote show); do
    #if [[ "$remote" == ksgitlab ]] && [[ -f ~/.ssh/id_rsa_ks ]] && ! ssh-add -L | grep -q id_rsa_ks; then
    #    ssh-add ~/.ssh/id_rsa_ks
    #fi
    git fetch $remote $branch
done
git remote show | grep -q . && \
    git merge -m automerge $(git remote show | sed -r -e "s/$/\\/$branch/")
set -x
bash -x $DIR/bin/stdhome-remove-deadlinks.sh
$DIR/bin/stdothers.sh | grep -vE 'stdks' | while read repo; do
    set -x
    cd $repo
    branch=$(basename $repo noexternalcheckout)
    test $branch == stdtsys && branch=$(git rev-parse --abbrev-ref HEAD)
    for remote in $(git remote show); do
        #if [[ "$remote" == ksgitlab ]] && [[ -f ~/.ssh/id_rsa_ks ]] && ! ssh-add -L | grep -q id_rsa_ks; then
        #    ssh-add ~/.ssh/id_rsa_ks
        #fi
        curbranch=$(git rev-parse --abbrev-ref HEAD)
        if [[ "$branch" != "$curbranch" ]]; then
            git checkout -b "$branch" &>/dev/null || git checkout "$branch"
            git branch -D master || true
        fi
        git fetch $remote $branch
    done
    git remote show | grep -q . && \
        git merge -m automerge $(git remote show | sed -r -e "s/$/\\/$branch/")
    set +x
done
[[ -d ~/.tmp/touch ]] && touch ~/.tmp/touch/stdhome-pull
exit 0
