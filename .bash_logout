# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

echo ".bash_logout $SHLVL"
if [ "$SHLVL" -ge 1 ]; then
    if [[ -x /usr/bin/clear_console ]]
	then
		/usr/bin/clear_console -q
	elif [[ -x /usr/bin/clear ]]
	then
		/usr/bin/clear -q
	fi
fi
[[ -d ~/.tmp ]] && echo "$(date +'%Y.%m.%d %H:%M:%S') out $SSH_CLIENT" >> ~/.tmp/bashrc-events
echo ./bash_logout
