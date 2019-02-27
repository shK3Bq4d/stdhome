#!/usr/bin/env bash

set -e
set -u
shopt -s expand_aliases
#exec 2> >(tee /tmp/stdhome-stderr.txt)
#exec 2>&1

usage() {
	echo "$(basename $0) [-s] [-h] [-a o|s|ask]
-s initialize/update submodules (think vim plugins)
-h display this help
-a automatic action on file: Overwrite, Skip or Ask
		"
}

#export PATH="$(readlink -f "$(dirname "$0")"):$PATH"
export PATH="$(dirname "$(readlink -f "$0")"):$PATH"
export STDHOME_DIRNAME="$(stdhome-dirname.sh)"
unset GIT_DIR
unset GIT_WORK_TREE

cd $STDHOME_DIRNAME
if hash stdhome-pull.sh; then
	stdhome-pull.sh
else
	git pull --no-rebase
fi
type mrbasename 2>/dev/null || source "$STDHOME_DIRNAME/bin/dot.bashfunctions"
ACTION=ask
while getopts "sha:d" o; do
    case "${o}" in
		d)
			set -x
			;;
        s)
			git submodule update --init --recursive
            ;;
        h|help)
            usage
			exit 0
            ;;
		a)
			ACTION=${OPTARG}
			case $ACTION in o|overwrite|s|skip|a|ask)
				true
				;;
				*)
					echo "illegal action $ACTION"
					exit 1
			esac
            ;;
        *)
            usage
			exit 1
            ;;
    esac
done
shift $((OPTIND-1))


#find $DIR -type f -regextype posix-extended -path $PWD/.git -prune -o -print
find $STDHOME_DIRNAME -xdev -name .git -prune -o \( -type f -or -type l \) -print0 | sort -rz |
    while read -r -d '' f; do
		case $(mrbasename $f) in .gitmodules|.gitignore)
			continue
			;;
		esac
        # substring the first characters of f corresponding to the length of $PWD
		echo "iterating over f $f"
		# < /dev/tty removed to allow run in docker container
		#< /dev/tty stdhome-install-onefile.sh -a "$ACTION" "$f"
		echo '' | stdhome-install-onefile.sh -a "$ACTION" "$f"
    done
find $STDHOME_DIRNAME/bin/githooks -maxdepth 1 -mindepth 1 -type f -print0 | sort -z |
    while read -r -d '' f; do

	bf=$(mrbasename "$f")
	[[ "$bf" == *.sample ]] && continue
	h="$STDHOME_DIRNAME/.git/hooks/$bf"
	#if [[ ! -L "$h" ]] && [[ "$h" -ef "$f" ]]; then
	if [[ "$h" -ef "$f" ]]; then
		echo "skipping $f as $h refers to the same location/inode"
		continue
	fi
	ln -is "$f" "$h"
done
[[ -e ~/bin/githooks/post-merge ]] && ~/bin/githooks/post-merge

# creating directories
mkdir -p ~/.tmp/tmpp ~/.tmp/tmp ~/.tmp/touch ~/.tmp/vim/{directory,backupdir,undodir,output} ~/.ssh/c &>/dev/null

# removing previous broken symlinks
stdhome-remove-deadlinks.sh

git diff
echo "do 'git checkout .' to revert local changes"
