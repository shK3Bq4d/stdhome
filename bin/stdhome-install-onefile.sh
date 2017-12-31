#!/usr/bin/env bash

set -u
shopt -s expand_aliases
#exec 2>&1

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
ACTION=ask
while getopts "a:" o; do
    case "${o}" in
        a)
			ACTION=${OPTARG}
			case $ACTION in o|overwrite|s|skip|a|ask)
				true
				;;
				*)
					echo "illegal default action $ACTION"
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
if [[ $# -lt 1 ]]; then 
	echo "FATAL nb args"
	exit 1
fi
STDHOME_DIRNAME="$(stdhome-dirname.sh)"
type mrbasename 2>/dev/null || source "$STDHOME_DIRNAME/bin/dot.bashfunctions"

for f in "$@"; do 
	f2="$f"
	#f=$(readlink -f "$f")
	#if [[ -z "$f" ]]; then
	#	echo "FATAL can't readlink -f $f2"
	#	exit 1
	#fi
	f="$(abspath "$f")"
	if [[ "$f" != $STDHOME_DIRNAME/* ]]; then
		f="${STDHOME_DIRNAME}${f:${#HOME}}"
		echo "f is $f"
	fi
	h="${HOME}${f:${#STDHOME_DIRNAME}}"
	echo "h is $h"
	if [[ ! -L "$f" ]] && [[ "$h" -ef "$f" ]]; then
		echo "skipping $f as $h refers to the same location/inode"
		continue
	fi
	dh="$(mrdirname "$h")"
	if [[ ! -d "$dh" ]]; then
		if [[ -e "$dh" ]]; then
			echo "SKIPPING $f as $dh exists and is not a directory"
			continue
		fi
		mkdir -p "$dh"
	fi
	if [[ ! -e "$h" ]]; then
		case $ACTION in \
		a|ask)
			ln -is "$f" "$h"
			;;
		*)
			ln -fs "$f" "$h"
			;;
		esac
		continue
	fi
	if diff "$f" "$h" &>/dev/null; then
		echo "SAME content for $h and $f, forcing link"
		ln -fs "$f" "$h"
		continue
	fi
	case $ACTION in \
		a|ask)
			read -n1 -p "Overwrite, Merge, Skip existing or Exit $h with symbolic link to $f [o,m,S,e]? " doit <&0
			;;
		*)
			doit=$ACTION
			;;
	esac
	case $doit in  
		o|O|overwrite)
			hb="$(nonexisting_backup_filename "$h")"
			mv "$h" "$hb"
			ln -is "$f" "$h"
			;; 
		m|M|merge)
			hb="$(nonexisting_backup_filename "$h")"
			cp "$h" "$hb"
			#t=$(mktemp)
			#if < /dev/tty sdiff -o $t $f $h; then
			if vimdiff "$f" "$h"; then
				read -n1 -p "Happy with your merge? Yes, No, Exit [Y,n,e]? " doit2 <&0
				case $doit2 in  
					e|E)
						exit 1
						;;
					n|N)
						true
						;;
					*)
						mv "$h" "$hb"
						ln -is "$f" "$h"
						;;
				esac
			else
				#rm $hb $t
				true
			fi
			;;
		e|E|exit)
			exit 1
			;;
		s|skip|*)
			true
			;;
	esac
done
