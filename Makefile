setup: install-vim-plugins setup-vim setup-zsh setup-terminal setup-git

install-vim-plugins:
	git submodule update --init --recursive

setup-vim:
	rm -rf ~/.vim ~/.vimrc
	ln -s `pwd`/vim ~/.vim
	ln -s ~/.vim/vimrc ~/.vimrc

setup-zsh:
	rm -f ~/.zshrc ~/.zsh-custom
	ln -s `pwd`/zsh/zshrc ~/.zshrc
	ln -s `pwd`/zsh/custom ~/.zsh-custom

setup-terminal:
	dconf reset -f /org/gnome/terminal/
	dconf load /org/gnome/terminal/ < `pwd`/gnome-terminal/terminal_dconf_dump.txt

dump-terminal-settings:
	dconf dump /org/gnome/terminal/ > gnome-terminal/terminal_dconf_dump.txt

setup-git:
	rm -f ~/.gitconfig
	ln -s `pwd`/git/gitconfig ~/.gitconfig

