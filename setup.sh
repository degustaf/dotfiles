#!/bin/bash

set -e
# set -u

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

df_git_install () {
    echo "Finishing installation of git submodules"
    git submodule update --init --recursive
    git submodule foreach checkout master
}

df_git_update () {
    echo "Updating submodules."
    git stash |& grep -q 'No local changes to save'
    stash=$?
    git submodule foreach git pull --recurse-submodules origin master
    set +e
    git status |& grep -q 'working directory clean'
    if [ $? -ne 0 ]; then
        set -e
        git commit -a -m "Updated Submodules"
    else
        set -e
    fi
    if [ "$stash" -ne 0 ]; then
        git pop
    fi
}

df_install () {
    echo "Installing desired programs."
    can_sudo sudo apt-get update
    can_sudo apt-get install bash-completion cabal-install ccache gcc ghc git \
                             golang python-pip python3 python3-pip tree vim 
    can_sudo pip install virtualenvwrapper
    cabal update
    cabal install shellcheck
}

df_link () {
    echo "Linking dotfiles."
    DIR="$(pwd)/$(dirname "$0")"
    sym_link="f=\"\$(basename \"{}\")\";\
              echo \"\$f\";\
              cd $HOME;\
              rm -rf \"$HOME/\$f\";\
              ln -sfn \"{}\" \"$HOME/\$f\""
    find "$DIR" -maxdepth 1 -name ".*" -not -name "." \
                                       -not -name ".*.sw?" \
                                       -not -name ".git" \
                                       -not -name ".gitignore" \
                                       -not -name ".gitmodules" \
                                       -not -name ".travis.yml" -exec bash -c "$sym_link" \;
    echo "Sourcing .bashrc."
    # shellcheck disable=SC1091
    source "$HOME/.bashrc"
}

df_update () {
    echo "Updating installed programs."
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
            set -- update git-install install link git-update "$@"
            ;;
        update)
            shift
            df_update
            ;;
        git-install)
            shift
            df_git_install
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
