#!/bin/bash

set -e
set -u

export BASH_COMPLETION_DEBUG=true

# Run shellcheck on executables.
find . -maxdepth 1 -type f -executable -not -name ".vimrc" -print0 | \
    xargs -0 -I file shellcheck file
