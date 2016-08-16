.Phony all apt dotfiles

all: apt dotfiles


apt:
	apt-get update
	apt-get install vim
	apt-get install gcc
	apt-get install python3
	apt-get install python-pip
	apt-get install bash-completion

dotfiles:
	dotfiles:
		# add aliases for dotfiles
		for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".irssi" -not -name ".gnupg"); do \
			f=$$(basename $$file); \
			ln -sfn $$file $(HOME)/$$f; \
			done; \
			ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
		ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;
