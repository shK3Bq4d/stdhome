#!/usr/bin/env bash

set -x
set -e
#exec 2>&1
unset GIT_DIR
unset GIT_WORK_TREE

nonexisting_backup_filename() {
	local i hb h
	h="$1"
	if [[ ! -e "$h" ]]; then
		echo "FATAL: nonexisting_backup_filename($h) not a file"
		return 1
	fi

	i=1
	while :; do
		hb="${h}.backup${i}"
		[[ ! -f "$hb" ]] && break
		i=$(( $i + 1 ))
	done
	echo "$hb"
}
if [[ $# -lt 1 ]]; then 
	echo "FATAL nb args"
	exit 1
fi
export PATH="$(dirname "$0"):$PATH"
DIR="$(stdhome-dirname.sh)"
CDIR=$PWD
for f in "$@"; do 
	f="$(readlink -f "$f")"
	if [[ -d "$f" ]]; then
		echo "FATAL: $f is a directory"
		exit 1
	fi
	if [[ "$f" == ${DIR}/* ]]; then
		echo "FATAL: $f as it already is inside stdhome git repo directory"
		exit 1
	fi
	if [[ -d "$(dirname "$f")/.git" ]]; then 
		echo "FATAL: $f as it already exists in a dir with another git repo"
		exit 1
	fi
	if stdidentify.sh -s "$f" &>/dev/null; then
		echo "FATAL: $f as it belongs to $(stdidentify.sh -s "$f")"
		exit 1
	fi
done

for f in "$@"; do 
	cd $CDIR

	f="$(readlink -f "$f")"
	h="${DIR}${f:${#HOME}}"
	echo "h is $h"
	if [[ "$h" -ef "$f" ]]; then
		echo "skipping $f as $h refers to the same location/inode"
		continue
	fi
	dh="$(dirname "$h")"
	if [[ ! -d "$dh" ]]; then
		if [[ -e "$dh" ]]; then
			echo "SKIPPING $f as $dh exists and is not a directory"
			continue
		fi
		mkdir -p "$dh"
	fi
	if [[ ! -e "$h" ]]; then
		mv "$f" "$h"
		ln -is "$h" "$f"
		{ cd "$DIR" && git add "$h"; }
		continue
	fi
	read -n1 -p "Merge, or Skip existing $h with symbolic link to $f [m,S]? " doit <&0
	case $doit in  
		m|M)
			fb="$(nonexisting_backup_filename "$f")"
			cp "$f" "$fb"
			#t=$(mktemp)
			#if < /dev/tty sdiff -o $t $f $h; then
			if vimdiff "$f" "$h"; then
				#rm -f $f $h
				#mv $t $f
				#ln -is $f $h
				cp -p "$f" "$fb"
				mv "$f" "$h"
				ln -is "$h" "$f"
				{ cd "$DIR" && git add "$h"; }
				#git commit -m auto $f
			else
				#rm $hb $t
				true
			fi
			;;
		*)
			true
			;;
	esac
done
cd $DIR
git diff
read -n1 -p "Commit? [y,N]" doit <&0
case $doit in  \
	y|Y)
		stdhome-commit.sh
		;;
esac
