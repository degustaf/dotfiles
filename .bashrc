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

export GOROOT=$HOME/go
export GOPATH=$HOME/go_work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH=$PATH:$HOME/.cabal/bin

if [ -d "$HOME/.pyenv/bin" ]; then
	export PATH=$PATH:$HOME/.pyenv/bin
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# shellcheck disable=SC1090,SC1091
source "$HOME/.alias"

if [ -d "$HOME/.cargo" ]; then
	# shellcheck disable=SC1090,SC1091
	source "$HOME/.cargo/env"
fi

if [ -d "/usr/lib/linux-tools" ]; then
	# There's a smarter way to do this that doesn't include hard coding the version number.
	export PERF="/usr/lib/linux-tools/5.4.0-146-generic/perf"
	# System perf is broken for WSL, and installing linux-tools doesn't replace the
	# broken one, so we need the new one first in our path.
	export PATH="$PERF:$PATH"
fi
