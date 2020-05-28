install: install-packages \
	install-ohmyzsh \
	install-vim-plugins \
	install-fzf \
	install-albert \
	install-insync \
	setup
	
setup: 
	setup-terminal \
	setup-zsh-as-default-sh \
	setup-zsh \
	setup-vim \
	setup-git \
	setup-gnome-keybindings \
	remider-for-optionals

#--------------------------------------------------

install-packages:
	sudo apt install curl wget
	sudo apt install vim git
	sudo apt install tree htop ppa-purge
	sudo apt install zsh meld python3-venv
	sudo apt install unrar vlc variety gnome-tweaks
	sudo apt install build-essential cmake python3-dev    # YouCompleteMe dependencies
	sudo apt install openjdk-8-jdk

install-ohmyzsh:
	rm -rf ~/.oh-my-zsh
	cd /tmp && \
	curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh && \
	chmod +x install.sh && \
	sh install.sh

install-vim-plugins:
	git submodule update --init --recursive

install-fzf:
	# reminder for the future: Debian 9+/Ubuntu 19.10+ --> sudo apt-get install fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

install-albert:
	# https://software.opensuse.org/download.html?project=home:manuelschneid3r&package=albert
	sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list" && \
	curl https://build.opensuse.org/projects/home:manuelschneid3r/public_key | sudo apt-key add - && \
	sudo apt-get update && \
	sudo apt-get install -y albert

install-insync:
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ACCAF35C
	sudo sh -c 'echo "deb http://apt.insync.io/ubuntu $(shell lsb_release -cs) non-free contrib" > /etc/apt/sources.list.d/insync.list'
	sudo apt-get update
	sudo apt-get install insync

#--------------------------------------------------

setup-terminal:
	dconf reset -f /org/gnome/terminal/
	dconf load /org/gnome/terminal/ < `pwd`/gnome-terminal/terminal_dconf_dump.txt

# utility backup task
dump-terminal-settings:
	dconf dump /org/gnome/terminal/ > gnome-terminal/terminal_dconf_dump.txt

setup-zsh-as-default-sh:
	chsh -s `which zsh`

setup-zsh:
	rm -f ~/.zshrc ~/.zsh-custom
	ln -s `pwd`/zsh/zshrc ~/.zshrc
	ln -s `pwd`/zsh/custom ~/.zsh-custom

setup-vim:
	rm -rf ~/.vim ~/.vimrc
	ln -s `pwd`/vim ~/.vim
	ln -s ~/.vim/vimrc ~/.vimrc

setup-git:
	rm -f ~/.gitconfig
	ln -s `pwd`/git/gitconfig ~/.gitconfig


setup-gnome-keybindings:
	gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot '<Primary><Shift><Alt>dollar'
	gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip '<Shift><Alt>dollar'
	gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '<Primary><Shift><Alt>percent'
	gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip '<Shift><Alt>percent'
	# custom key binding
	gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \[\'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/\'\]
	# toggle Albert key binding
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Albert toggle"
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "albert toggle"
	gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>space"

reminder-for-optionals:
	@echo "========= Optionals not run ==========="
	@echo "make fix-terminal-bell"
	@echo "make fix-nautilus-typeahead"
	@echo "make install-gnome-ext-hidetopbar"
	@echo "make setup-gnome-ext-hidetopbar"
	@echo "make install-sbt"
	@echo "make install-virtualbox"
	@echo "make install-youtube-to-mp3"
	@echo "make install-latex-env"

fix-terminal-bell:
	sudo mv /usr/share/sounds/ubuntu/stereo/bell.ogg /usr/share/sounds/ubuntu/stereo/bell_original.ogg
	sudo cp /usr/share/sounds/ubuntu/stereo/message.ogg /usr/share/sounds/ubuntu/stereo/bell.ogg

fix-nautilus-typeahead:
	# https://www.omgubuntu.co.uk/2018/05/enable-nautilus-type-ahead-search-ubuntu
	sudo add-apt-repository ppa:lubomir-brindza/nautilus-typeahead
	sudo apt dist-upgrade

install-gnome-ext-hidetopbar:
	# https://extensions.gnome.org/extension/545/hide-top-bar/
	# https://medium.com/@ankurloriya/install-gnome-extension-using-command-line-736199be1cda
	rm -rf ~/.local/share/gnome-shell/extensions/hidetopbar@mathieu.bidon.ca
	mkdir -p ~/.local/share/gnome-shell/extensions/
	cd ~/.local/share/gnome-shell/extensions/ && \
	git clone https://github.com/mlutfy/hidetopbar.git hidetopbar@mathieu.bidon.ca && \
	cd hidetopbar@mathieu.bidon.ca && \
	make schemas && \
	cd .. && \
	gnome-shell-extension-tool -e hidetopbar@mathieu.bidon.ca
	@echo "--------- Please, restart the current Gnome session. ------------"

setup-gnome-ext-hidetopbar:
	# https://askubuntu.com/questions/490939/configure-gnome-shell-extensions-from-command-line
	# Sensitivity: Do not show panel when mouse approaches edge of the screen
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/hidetopbar@mathieu.bidon.ca/schemas/ set org.gnome.shell.extensions.hidetopbar mouse-sensitive false
	# Intellihide: Only hide panel when window takes the place
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/hidetopbar@mathieu.bidon.ca/schemas/ set org.gnome.shell.extensions.hidetopbar enable-active-window false
	gsettings --schemadir ~/.local/share/gnome-shell/extensions/hidetopbar@mathieu.bidon.ca/schemas/ set org.gnome.shell.extensions.hidetopbar enable-intellihide false

install-sbt:
	sudo echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
	sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
	sudo apt-get update
	sudo apt-get install sbt

install-virtualbox:
	sudo sh -c 'echo "deb https://download.virtualbox.org/virtualbox/debian $(shell lsb_release -cs) contrib" > /etc/apt/sources.list.d/virtualbox.list'
	curl -s https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
	sudo apt-get update
	@echo "Checkout latest VirtualBox version. https://www.virtualbox.org/wiki/Linux_Downloads\nVirtualbox package to install (eg: virtualbox-6.0):"
	@read vbox_pkg; \
	sudo apt-get install $$vbox_pkg

install-youtube-to-mp3:
	# https://www.mediahuman.com/repository.html
	sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 7D19F1F3
	sudo add-apt-repository https://www.mediahuman.com/packages/ubuntu
	sudo apt-get update
	sudo apt-get install youtube-to-mp3

install-latex-env:
	sudo apt install texstudio
	@echo "Installing https://launchpad.net/ubuntu/$(shell lsb_release -cs)/+package/texlive"
	@echo "Installing https://launchpad.net/ubuntu/$(shell lsb_release -cs)/+package/texlive-lang-english"
	@echo "Installing https://launchpad.net/ubuntu/$(shell lsb_release -cs)/+package/texlive-lang-italian"
	@echo "Installing https://launchpad.net/ubuntu/$(shell lsb_release -cs)/+package/texlive-fonts-extra"
	@echo "Installing https://launchpad.net/ubuntu/$(shell lsb_release -cs)/+package/texlive-extra-utils"
	sudo apt install texlive
	sudo apt install texlive-lang-english texlive-lang-italian
	sudo apt install texlive-fonts-extra
	sudo apt install texlive-extra-utils
