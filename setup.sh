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
        "Can't run $1 without root permission."
    fi
}

df_git_install () {
    echo "Finishing installation of git submodules"
    git submodule update --init --recursive
    git submodule foreach git checkout master
}

df_git_update () {
    echo "Updating submodules."
    if git stash |& grep -q 'No local changes to save'; then
        stash=1
    else
        stash=0
    fi
    git submodule foreach git pull --recurse-submodules origin master
    if [[ $(git status |& grep -q 'working directory clean') -ne 0 ]]; then
        git commit -a -m "Updated Submodules"
    fi
    if [[ "$stash" -eq 0 ]]; then
        git stash pop
    fi
}

install_haskell () {
	echo "Setting up haskell environment."
	can_sudo curl -sSL https://get.haskellstack.org/ | sh
	stack install hoogle
}

install_neovim () {
	echo "Setting up neovim."
	git clone https://github.com/neovim/neovim
	cd neovim
	git checkout stable
	make CMAKE_BUILD_TYPE=RelWithDebInfo
	can_sudo make install
	can_sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/nvim 100
}

df_install () {
    echo "Installing desired programs."
    can_sudo apt-get update
    can_sudo apt-get install bash-completion ccache gcc git \
                             golang tree nodejs npm cmake unzip \
                             build-essential libbz2-dev libssl-dev libpng-dev \
                             libreadline-dev libsqlite3-dev libfreetype6-dev

	can_sudo install_haskell
	can_sudo install_neovim
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
    if [ "$EUID" -eq 0 ]; then
        echo "Can't source .bashrc as root."
    else
        echo "Sourcing .bashrc."
        # shellcheck disable=SC1090
        source "$HOME/.bashrc"
    fi
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
