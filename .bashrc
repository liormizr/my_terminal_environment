# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
export LC_TIME=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\[\033[31;1m\]"
GREEN="\[\033[32;1m\]"
YELLOW="\[\033[33;1m\]"
WHITE="\[\033[37;1m\]"
BLUE="\[\033[01;34m\]"
SMILEY="${WHITE}:)${NORMAL}"
FROWNY="${RED}:(${NORMAL}"
SUCCESS_PS1="${GREEN}\u:${BLUE}\w\$${NORMAL} "
FAILER_PS1="${RED}\u:${BLUE}\w\$${NORMAL} "
SELECT="if [ \$? = 0 ]; then echo \"${SUCCESS_PS1}\"; else echo \"${FAILER_PS1}\"; fi"
# Throw it all together 
PS1="\`${SELECT}\`"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFG'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

. /usr/local/etc/bash_completion.d/git-completion.bash

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

stagingVPN () {
  startVPN Staging
}


productionVPN () {
  startVPN Production
}


startVPN() {
  VPN_ENV=$1
  VPN_STATUS=$(osascript -e 'tell application "Tunnelblick"' -e 'get state of configurations' -e 'end tell')
  if [[ $VPN_STATUS == *"CONNECTED"* ]]; then
    VPN_ON=$(osascript -e 'tell application "Tunnelblick"' -e 'get name of configuration 1 where state = "CONNECTED"' -e 'end tell')
    if [[ "$VPN_ON" != "$VPN_ENV" ]] ; then
      echo "* Switching VPN connections"
      osascript -e 'tell application "Tunnelblick"' -e "disconnect \"${VPN_ON}\"" -e 'end tell' &>/dev/null
      # Wait for disconnect to finish before connecting a new one
      sleep 3
    fi
  fi
  osascript -e 'tell application "Tunnelblick"' -e "connect \"${VPN_ENV}\"" -e 'end tell' &>/dev/null
  # Wait thread for the connection to come up before trying any new commands.
  if [[ "$EXECUTED" = "1" ]] ; then
    while ! osascript -e 'tell application "Tunnelblick"' -e 'get name of configuration 1 where state = "CONNECTED"' -e 'end tell' > /dev/null 2>&1
      do sleep 1 ; done &
  fi
  unset VPN_ON VPN_STATUS VPN_ENV
}

export PROJECT_HOME=$HOME
export WORKSPACE=$PROJECT_HOME/sources
eval "$(_RUNNER_COMPLETE=source runner)"
eval "$(_DEV_RUNNER_COMPLETE=source dev-runner)"
eval "$(_QA_COMPLETE=source qa)"
eval "$(_QA_RUNNER_COMPLETE=source qa-runner)"

export EDITOR=vim

_pipenv_completion() {
    local IFS=$'\t'
    COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                                COMP_CWORD=$COMP_CWORD \
                                _PIPENV_COMPLETE=complete-bash $1 ) )
    return 0
}

complete -F _pipenv_completion -o default pipenv
eval "$(register-python-argcomplete r2d2)"
