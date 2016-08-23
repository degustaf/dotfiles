#!/bin/bash

set -e
set -u

export BASH_COMPLETION_DEBUG=true

# Run shellcheck on executables.
result=$(find . -maxdepth 1 -type f -executable -not -name ".vimrc" \
    -exec bash -v -c "shellcheck \$0 || kill $PPID" {} \;)
if [ -n "$result" ]; then
    echo "$result"
    exit 1
fi
