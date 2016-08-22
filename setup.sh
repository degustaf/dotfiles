#!/bin/bash

set -e
set -u

can_sudo () {
    if [ "$#" -eq 0 ]; then
        exit 0
    fi
    if [ "$EUID" -eq 0 ]; then
        "$@"
    else
    	echo "Can't run $1 to without root permission."
    fi
}

df_git_update () {
    git stash |& grep -q 'No local changes to save'
    stash=$?
    git submodule foreach git pull --recurse-submodules origin master
    git status |& grep -q 'working directory clean'
    if [ $? -ne 0 ]; then
        git commit -a -m "Updated Submodules"
    fi
    if [ "$stash" -ne 0 ]; then
        git pop
    fi
}

df_install () {
    can_sudo apt-get install vim gcc python3 python3-pip python-pip bash-completion golang
}

df_link () {
    DIR="$(pwd)/$(dirname "$0")"
    sym_link="f=\"\$(basename \"{}\")\"; cd $HOME; ln -sfn \"{}\" \"$HOME/\$f\""
    find "$DIR" -maxdepth 1 -name ".*" -not -name "." \
                                       -not -name ".*.sw?" \
                                       -not -name ".git" \
                                       -not -name ".gitignore" \
                                       -not -name ".gitmodules" \
                                       -not -name ".travis.yml" -exec bash -c "$sym_link" \;
}

df_update () {
    can_sudo apt-get update
}


# Main body of script

if [ "$#" -eq 0 ]; then
    set -- all "$@"
fi

while [[ $# -gt 0 ]]; do
    target=$1

    case $target in
        all)
            shift
            set -- update link git-update install "$@"
            ;;
        update)
            shift
            df_update
            ;;
        link)
            shift
            df_link
            ;;
        git-update)
            shift
            df_git_update
            ;;
        install)
            shift
            df_install
            ;;
        *)
            echo "$target is an unknown target."
            exit 1
            ;;
    esac
done
