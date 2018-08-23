# ex: set expandtab ts=4 sw=4:
[ -z "$PS1" ] && return
[ -z "$RCD" ] && export RCD=$HOME

# handles urxvt resize bug
# https://superuser.com/questions/442589/xmonad-urxvt-issue-text-disappears-after-resizing and,
# better explained https://superuser.com/questions/442589/xmonad-urxvt-issue-text-disappears-after-resizing
#[[ -z $SSH_CLIENT && -f ~/.config/i3/config ]] && for (( i=1; i<=$LINES; i++ )); do echo; done && clear;
# this one is a perf optimisation try
#[[ -z $SSH_CLIENT && -f ~/.config/i3/config ]] && tail -n $(( $LINES + 5 )) ~/.config/urxvt-resize-bug
# 2018.05.02 trying with a bigger, hardcoded number of lines since bug still there. I suspect it's the number
#            of full screen lines that need to be written
#[[ -z $SSH_CLIENT && -f ~/.config/i3/config ]] && echo 'welcome?' && tail -n 85 ~/.config/urxvt-resize-bug && echo ✇
[[ -z $SSH_CLIENT && -f ~/.config/i3/config ]] && echo -n "$(<~/.config/urxvt-resize-bug)"
is_zsh() {
    test -n "${ZSH_VERSION:-}"
}
export UNAME="$(uname)"
if is_zsh; then
    UNAME="$UNAME:l"
else
    UNAME="${UNAME,,}"
    shopt -s histappend
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        # on ubuntu /etc/bash_completion is /usr/share/bash-completion/bash_completion
        # which sources ~/.bash_completion
        source /etc/bash_completion
    fi
    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # If set, the pattern "**" used in a pathname expansion context will
    # match all files and zero or more directories and subdirectories.
    shopt -s globstar 2>/dev/null # not supported in bash3
    shopt -u mailwarn

    alias env='env $* | sort'
    bind -f $RCD/.inputrc
    trap_exit() {
        f="$HOME/.bash_logout"
        [[ -f $f ]] && source $f
    }
    trap trap_exit EXIT

    source $RCD/.bashrc_mrprompt
fi


for i in $RCD ~$SUDO_USER; do
    i=$(eval echo $i)
    f=$i/bin/dot.bashfunctions # needs UNAME
    if [[ -f $f ]]; then
        export RCD=$i
        source $f
        break
    fi
done
pathprepend $RCD/bin # needs dot.bashfunctions
# cygwin, being started from mintty.exe scratch, doesn't any good PATH
if ! hash chmod &>/dev/null; then
    pathprepend /usr/sbin
    pathprepend /usr/bin
    pathprepend /sbin
    pathprepend /bin
    cd $HOME
fi
if [[ -z $HOSTNAMEF ]]; then
    if [[ -L /usr/bin/timeout ]] && [[ $(readlink -f /usr/bin/timeout) == *busybox ]]; then
        export HOSTNAMEF=$(timeout -t 3 hostname -f)
    else
        export HOSTNAMEF=$(timeout 3 hostname -f)
    fi
fi
[[ -z $HOSTNAME ]] && export HOSTNAME=${HOSTNAMEF//\.*/}
export PYTHONIOENCODING="UTF-8"
export PYTHONDONTWRITEBYTECODE="True"
if [[ -d /usr/share/terminfo ]]; then
    function _termok() {
        local _TERM=$1
        is_zsh && setopt null_glob
        if test -f /usr/share/terminfo/${_TERM:0:1}/$_TERM; then
            return 0
        fi
        if test -f /usr/share/terminfo/*/$_TERM; then
            return 0
        fi
        # one may to do the find thing, but this speeds up, not to do it
        #find /usr/share/terminfo -name $_TERM -print -quit | grep -qE '.'
        return 1
    }
    if ! _termok $TERM; then
        for t in xterm-256color xterm; do
            if _termok $t; then
                export TERM=$t
                break
            fi
        done
    fi
fi

# append to the history file, don't overwrite it
HISTSIZE=200000
HISTFILESIZE=400000
HISTCONTROL=ignorespace
HISTTIMEFORMAT="%Y.%m.%d %H:%M:%S "
[[ -n "$SUDO_USER" && "$HISTFILE" != *_${SUDO_USER} && -w "${HISTFILE}_$SUDO_USER" ]] && HISTFILE="${HISTFILE}_$SUDO_USER"
[[ -n "$HISTFILE" && -f "$HISTFILE" && ! -w "$HISTFILE" ]] && echo "non-writable HISTFILE $HISTFILE disabled" && unset HISTFILE


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# disable mail notification
unset MAILCHECK

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r $RCD/.dircolors && eval "$(dircolors -b $RCD/.dircolors)" || eval "$(dircolors -b)"
    case $UNAME in \
    freebsd)
        alias ls='ls --color=auto'
        ;;
    *)
        alias ls='ls -h --color=auto'
        ;;
    esac
fi


# some more ls aliases
alias mplayer='mplayer -zoom -fs -vo x11'
#alias ll='ls -lhFa --group-directories-first'
function lr() {
    if [[ -z "$1" ]]; then
        ls -lhAFtr
    else
        ls -lhAFtr | grep -i $*
    fi
}
function lss() {
    if [[ -z "$1" ]]; then
        ls -lhFarS --group-directories-first
    else
        ls -lhFarS --group-directories-first | grep -i $*
    fi
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if hash stdhome-dirname.sh 2>/dev/null || which stdhome-dirname.sh &>/dev/null; then
    export STDHOME_DIRNAME=$(stdhome-dirname.sh)
    alias cdstdhome='cd $STDHOME_DIRNAME'
    alias githome="git --git-dir=$STDHOME_DIRNAME/.git --work-tree=$STDHOME_DIRNAME"
    alias githomeworkon="export GIT_DIR=$STDHOME_DIRNAME/.git; export GIT_WORK_TREE=$STDHOME_DIRNAME"
fi
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

export WORK_PC1F=workstation00451.muc.com
export WORK_PC1=workstation00451
export WORK_PC2F=laptop00615.muc.com
export WORK_PC2=laptop00615
export WORK_PC3F=vmhabon.muc.com
export WORK_PC3=vmhabon

alias ssh-no-host-checking='ssh -o ControlMaster=No -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=No $@'
alias ssh-password-auth='ssh -o ControlMaster=No -o NumberOfPasswordPrompts=1000 -o PubkeyAuthentication=no -o HostbasedAuthentication=no -o KbdInteractiveAuthentication=no -o RhostsRSAAuthentication=no -o RSAAuthentication=no -o ChallengeResponseAuthentication=no $@'
alias scp='scp -p'
alias rsync='rsync -vh --progress'
#alias githome='git --git-dir=$STDHOME_DIRNAME/.git'
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
HISTFILESIZE=1000000000
HISTSIZE=1000000
HISTCONTROL=ignorespace
set -o vi
set -o noclobber
[[ -z "$EDITOR" ]] && export EDITOR=vi
if hash vim  &>/dev/null; then
    export EDITOR=vim
    if [[ $EUID -eq 0 ]]; then # vim readonly for root
        alias vi='vim -R'
        function vim() {
            if [[ $# -eq 1 ]] && [[ $1 == /tmp/bash-fc-* ]]; then
                # bash vi mode:
                # 1) shouldn't have read-only mode
                # 2) can work OK with vi only I guess
                command vi "$@"
            else
                command vim -R "$@"
            fi
        }
    else
        alias vi='vim'; # vim instead of vi
    fi
elif hash vi  &>/dev/null; then
    export EDITOR=vi
    if [[ $EUID -eq 0 ]]; then # vim readonly for root
        alias vi='vi -R'
    fi
fi
#export PATH=~/bin:$PATH
export VAGRANT_SERVER_URL=https://app.vagrantup.com
#pathprepend ~/bin/$HOSTNAME
#export LC_TIME=fr_CH
hash tabs &>/dev/null && tabs 4
#export PROMPT_DIRTRIM=2
case $UNAME in \
freebsd)
    unset LC_ALL
    export LANG=en_US.UTF-8
    export LC_MESSAGES=C
    alias watch='gnu-watch'
    ! hash md5sum 2>/dev/null && hash md5deep 2>/dev/null && alias md5sum=md5deep
    alias netstat='echo use sockcat -l or command netstat'
    #alias locate='locate -i'
    #export LC_TIME=en_DK.UTF-8
    alias ll='ls -lhFa'
    alias ,='ls -lhFa'
    alias updatedb='/usr/libexec/locate.updatedb'
    ;;
cygwin)
    alias pkill='taskkill.exe /f /im $*'
    alias ps='tasklist.exe'
    alias xargs='xargs -r'
    ;;
*)
    #mrbg() { nohup "$@" &>/dev/null &; disown; }
    alias xargs='xargs -r'
    function ll() {
        if [[ -z "$1" ]]; then
            ls -lhFa --group-directories-first
        else
            ls -lhFa --group-directories-first | grep -i $*
        fi
    }
    alias ,=ll
    #alias locate='locate -i --regex'
    if [[ -z "${SUDO_USER+1}" ]]; then
        if [[ -d /usr/share/X11/locale/en_US.UTF-8 ]]; then
            export LC_ALL="en_US.UTF-8"
            export LC_CTYPE="en_US.UTF-8"
        fi
        export LC_TIME="en_DK.utf8"
    fi
    alias dmesg="dmesg -HL auto"
    ;;
esac
export CDPATH=$CDPATH:$RCD/.cdpath

if hash javac &>/dev/null; then
    export JAVA_HOME=$(mrdirname $(mrdirname $(which javac)))
fi

alias ........='cd ../../../../../../../..'
alias .......='cd ../../../../../../..'
alias ......='cd ../../../../../..'
alias .....='cd ../../../../..'
alias ....='cd ../../../..'
alias ...='cd ../../..'
alias ..='cd ../..'
alias .='cd ..'
alias vi-='vi -'

if hash ack-grep &>/dev/null; then
    alias ack='ack-grep --follow $*'
    alias ackf='ack-grep -f'
elif hash ack &>/dev/null; then
    alias ackf='ack -f'
fi
alias ducks='du -cksh -- * | sort -rh | head -11'
alias mdkir=mkdir
alias feh='feh -p --auto-zoom -. -B black'
alias finda='find /{bin,etc,home,lib,opt,sbin,tmp,var,usr}'
alias lynx='lynx -vikeys -cfg=$RCD/lynx.cfg $*'
alias mrclear='clear; echo -e "\e[3J"'
alias tmp='cd $RCD/tmp'
alias tmpp='$RCD/bin/tmpp && cd $RCD/tmp'

alias mv='mv -i'
alias cp='cp -ip'
alias ln='ln -i'
alias rm='rm -i'

alias igrep='grep -i'
alias cgrep='grep --color=always'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias venv="workon"
alias venv.exit="deactivate"
alias venv.ls="lsvirtualenv"
alias venv.show="showvirtualenv"
alias venv.init="mkvirtualenv"
alias venv.rm="rmvirtualenv"
alias venv.switch="workon"
alias venv.add="add2virtualenv"
alias venv.cd="cdproject"
alias venv.cdsp="cdsitepackages"
alias venv.cdenv="cdvirtualenv"
alias venv.lssp="lssitepackages"
alias venv.proj="mkproject"
alias venv.setproj="setvirtualenvproject"
alias venv.wipe="wipeenv"

for d in $RCD/py \
    \#$RCD/git/mr/mrpy/src \
    ; do
    [[ -d $d ]] && \
        for i in $(find $d -maxdepth 1 -type d ); do export PYTHONPATH=$PYTHONPATH:$i; done
done


if hash less &>/dev/null; then
    export MANPAGER="less -sR"
    alias less='less --raw-control-chars --quit-if-one-screen --ignore-case --status-column --no-init'
fi
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

if [[ $UID -ne 0 ]]; then
    # Source SSH settings, if applicable

    if [[ -z ${SSH_CLIENT+1} ]]; then # only start agent if not running inside SSH session
        start_agent_if_not_started
        mr_ssh_add
    else
        if [ -f "${SSH_ENV}" ]; then
             source ${SSH_ENV} > /dev/null
             # /usr/bin/ssh-add -l &>/dev/null || /usr/bin/ssh-add -t 43200
             mr_ssh_add
        fi
    fi
fi


export PYTHONSTARTUP=$RCD/.pythonrc

NPM_PACKAGES="$HOME/.npm-packages"
MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"


# virtualenv https://gist.github.com/bbengfort/246bc820e76b48f71df7
export WORKON_HOME=$HOME/.virtualenvs
#export PROJECT_HOME=$HOME/Repos/git/
case "$TERM" in
xterm*|rxvt*)
    #PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

    if ! is_zsh; then
        pre_cmd()
        {
            local MR_LAST=$?
            local cmd="$BASH_COMMAND"
            case "$cmd" in
                *\033]0*)
                    # The command is trying to set the title bar as well;
                    # this is most likely the execution of $PROMPT_COMMAND.
                    # In any case nested escapes confuse the terminal, so don't
                    # output them.
                    return
                    ;;
                mr_prompt)
                    ;;
                *)
                    [[ $MR_RUNNING == "1" ]] && return
                    ;;
            esac

            echo -ne "\033]0;"
            case "$cmd" in
                mr_prompt)
                    if [[ $MR_LAST -eq 0 ]]; then
                        echo -ne '\u2713 '
                    else
                        echo -ne '\u2718 '
                    fi
                    ;;
                source*SSHOME*sshrc)
                    ;;
                *)
                    echo -ne '\u2608 '
                    ;;
            esac
            if [[ -n "$MR_TERM" ]]; then
                echo -ne "$MR_TERM"
            elif [[ -n "$SSH_CLIENT" ]]; then
                echo -ne "ssh"
            else
                echo -ne "$TERM"
            fi
            echo -ne " - ${USER}@${HOSTNAME}:$PWD "
            case "$cmd" in
                mr_prompt)
                    MR_RUNNING=0
                    echo -ne "${MR_PREV_COMMAND}"
                    ;;
                source*SSHOME*sshrc)
                    ;;
                *)
                    [[ $MR_RUNNING == "0" ]] && MR_PREV_COMMAND="$cmd"
                    MR_RUNNING=1
                    MR_LAST_START=$SECONDS
                    [[ -n "${COLUMNS+1}" ]] && export MR_COLUMNS=$COLUMNS
                    echo -ne "${cmd}"
                    ;;
            esac
            echo -ne "\007"
        }
        [[ ! -f /.dockerenv ]] && trap pre_cmd DEBUG # I've got a bug in docker containers
    fi
    ;;
*)
    ;;
esac
! hash apt 2>/dev/null && hash apt-get 2>/dev/null &&  alias apt=apt-get # for older debian-based, sometimes used in docker containers
hash thunar 2>/dev/null &&  alias explorer=thunar #
if hash pip 2>/dev/null; then
   if is_zsh; then
       eval "$(pip completion --zsh --disable-pip-version-check &>/dev/null)" #&>/dev/null
    else
       eval "$(pip completion --bash --disable-pip-version-check &>/dev/null)" #&>/dev/null
   fi
fi
#[[ -z $SSH_CLIENT && $EUID -ne 0 && -d ~/.tmp ]] && echo "$(date +'%Y.%m.%d %H:%M:%S') in" >> ~/.tmp/bashrc-events
[[ $EUID -ne 0 && -d ~/.tmp ]] && echo "$(date +'%Y.%m.%d %H:%M:%S') in  $SSH_CLIENT" >> ~/.tmp/bashrc-events
#[[ -n $SSH_TTY ]] && [[ $- == *i* ]] && command last | head
#echo "$-"
[[ -n "$MR_EXTERNAL_RC" ]] && source $MR_EXTERNAL_RC # so as to be called to execute further scripts in docker where sourcing from {HOSTNAME}_aliases doesn't work
[[ -z $SSH_CLIENT && -z $SUDO_USER ]] && stty -ixon # disable control-S if not running in a SSH session

alias tailf1="tail -f -n +1"
alias tailf2="tail -f -n +2"
alias tail1="tail -n 1"
alias tail2="tail -n 2"
alias tail3="tail -n 3"
alias tail4="tail -n 4"
alias tail5="tail -n 5"
alias tail6="tail -n 6"
alias tail7="tail -n 7"
alias tail8="tail -n 8"
alias tail9="tail -n 9"
alias tail10="tail -n 10"
alias tail11="tail -n 11"
alias tail12="tail -n 12"
alias tail13="tail -n 13"
alias tail14="tail -n 14"
alias tail15="tail -n 15"
alias tail16="tail -n 16"
alias tail17="tail -n 17"
alias tail18="tail -n 18"
alias tail19="tail -n 19"
alias tail20="tail -n 20"
alias tail30="tail -n 30"
alias tail40="tail -n 40"
alias tail50="tail -n 50"
alias tail60="tail -n 60"
alias tail70="tail -n 70"
alias tail80="tail -n 80"
alias tail90="tail -n 90"
alias tail100="tail -n 100"

alias head1="head -n 1"
alias head2="head -n 2"
alias head3="head -n 3"
alias head4="head -n 4"
alias head5="head -n 5"
alias head6="head -n 6"
alias head7="head -n 7"
alias head8="head -n 8"
alias head9="head -n 9"
alias head10="head -n 10"
alias head11="head -n 11"
alias head12="head -n 12"
alias head13="head -n 13"
alias head14="head -n 14"
alias head15="head -n 15"
alias head16="head -n 16"
alias head17="head -n 17"
alias head18="head -n 18"
alias head19="head -n 19"
alias head20="head -n 20"
alias head30="head -n 30"
alias head40="head -n 40"
alias head50="head -n 50"
alias head60="head -n 60"
alias head70="head -n 70"
alias head80="head -n 80"
alias head90="head -n 90"
alias head100="head -n 100"


is_zsh && setopt null_glob
for f in \
    $RCD/.bash_aliases \
    $RCD/.${HOSTNAMEF}_aliases  \
     /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh \
    /usr/bin/virtualenvwrapper_lazy.sh \
    $RCD/.std*_aliases \
    ; do
        [[ -f $f ]] && source $f
done
is_zsh && unsetopt null_glob
# needs  to be done after local aliases
[[ -n "$GIT_AUTHOR_NAME" && -z "$GIT_COMMITTER_NAME" ]] && export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
[[ -n "$GIT_AUTHOR_EMAIL" && -z "$GIT_COMMITTER_EMAIL" ]] && export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

# to be run very last so a control-C due to non-connectivity doesn't prevent all the other stuff to run
if [[ -f ~/.tmp/touch/stdhome-pull ]]; then
    if find ~/.tmp/touch/stdhome-pull -mtime +1 | grep -qE . && hash stdhome-pull.sh 2>/dev/null; then
        #stdhome-merge.sh
        #stdhome-fetch.sh &
        stdhome-pull.sh
    fi
fi

true # so prompt is green
