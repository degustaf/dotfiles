# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
		# shellcheck disable=SC1090
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Nodejs
VERSION=v16.14.0
DISTRO=linux-x64
export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH

if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
	# shellcheck disable=SC1090
	. "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

GPG_TTY=$(tty)
export GPG_TTY

# Rust: set PATH so it includes user's private cargo bin if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -e "$HOME/.cargo/bin" ] ; then
	# shellcheck disable=SC1090
	. "$HOME/.cargo/env"
fi
