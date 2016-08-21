#default prompt
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"
PS1="$LIGHT_GRAY\$(date +%H:%M) \w$LIGHT_GREEN\$ $LIGHT_GRAY"

#needed for emacs to work
export LOGNAME=`whoami`
export USER=`whoami`
export USERNAME=`whoami`

#add .local binaries to path
export PATH=~/.local/bin:$PATH

# bash command tab-completion
source /etc/bash_completion

# Set the umask so that files are owner and group writable by default,
# and read-only for others.
umask 0002

#remove duplicate entries from history
export HISTCONTROL=ignoreboth

# Show current git branch in prompt.
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
LIGHT_GRAY="\[\033[0;37m\]"

PS1="$LIGHT_GRAY\$(date +%H:%M) \w$YELLOW \$(parse_git_branch)$LIGHT_GREEN\$ $LIGHT_GRAY"

# Load virtualenvwrapper
source virtualenvwrapper.sh

export GOROOT=$HOME/go
export GOPATH=$HOME/go_work
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH=$PATH:$HOME/.cabal/bin
