.Phony: all apt dotfiles update

all: update apt dotfiles

update:
ifeq ($(USER),ROOT)
	apt-get update
else
	# echo "Can't run apt-get without root permission."
endif
# git submodule foreach git pull origin master

apt:
ifeq ($(USER),ROOT)
	apt-get install vim
	apt-get install gcc
	apt-get install python3
	apt-get install python-pip
	apt-get install bash-completion
	apt-get install golang
endif

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".irssi" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln --symbolic --no-dereference --force $$file $(HOME)/$$f; \
		done;
