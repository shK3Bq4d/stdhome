#!/usr/bin/env bash

set -e
DIR="$( cd -P "$( dirname $(readlink  -f "${BASH_SOURCE[0]}" ) )/.." && pwd )"

cd $DIR
unset GIT_DIR
unset GIT_WORK_TREE
git status
