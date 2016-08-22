#!/bin/bash

set -e
set -u

# Run shellcheck on executables.
find . -maxdepth 1 -type f -executable -not -name ".vimrc" -exec shellcheck {} \;
