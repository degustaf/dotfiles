#!/bin/bash
#default prompt
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"
PS1="$LIGHT_GRAY\$(date +%H:%M) \w$LIGHT_GREEN\$ $LIGHT_GRAY"

#add .local binaries to path
export PATH=~/.local/bin:$PATH

# bash command tab-completion
# shellcheck source=/dev/null
# source /etc/bash_completion

# Set the umask so that files are owner and group writable by default,
# and read-only for others.
umask 0002

#remove duplicate entries from history
export HISTCONTROL=ignoreboth

# Show current git branch in prompt.
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
# RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
# GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"

PS1="$LIGHT_GRAY\$(date +%H:%M) \w$YELLOW \$(parse_git_branch)$LIGHT_GREEN\$ $LIGHT_GRAY"

# Load virtualenvwrapper
if [[ $- =~ u ]]; then
    set +u
    # shellcheck source=/dev/null
    source "$(which virtualenvwrapper.sh)"
    set -u
else
    # shellcheck source=/dev/null
    source "$(which virtualenvwrapper.sh)"
fi

export GOROOT=$HOME/go
export GOPATH=$HOME/go_work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH=$PATH:$HOME/.cabal/bin
