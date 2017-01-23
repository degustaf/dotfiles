#!/bin/bash

function tab_completion {
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    # shellcheck disable=SC1091
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    # shellcheck disable=SC1091
    . /etc/bash_completion
  fi
fi
}

#default prompt
YELLOW="\[\033[0;33m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"

#add .local binaries to path
export PATH=~/.local/bin:$PATH

# bash command tab-completion
if [[ $- =~ e ]]; then
    set +e
    tab_completion
    set -e
else
    tab_completion
fi

# Set the umask so that files are owner and group writable by default,
# and read-only for others.
umask 0002

#remove duplicate entries from history
export HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Show current git branch in prompt.
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="$LIGHT_GRAY\$(date +%H:%M) \w$YELLOW \$(parse_git_branch)$LIGHT_GREEN\$ $LIGHT_GRAY"

shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Load virtualenvwrapper
if [[ $- =~ u ]]; then
    set +u
    # shellcheck disable=SC1090
    source "$(which virtualenvwrapper.sh)"
    set -u
else
    # shellcheck disable=SC1090
    source "$(which virtualenvwrapper.sh)"
fi

export GOROOT=$HOME/go
export GOPATH=$HOME/go_work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH=$PATH:$HOME/.cabal/bin

export PATH=$PATH:$HOME/.pyenv/bin
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# shellcheck disable=SC1091
source .alias
