#! /bin/bash

PWD=$(git rev-parse --show-toplevel)

# the number is a dependency order

01_setup_git() {
    set -x
    
    rm -f ~/.gitconfig
    ln -s "${PWD}/git/gitconfig" ~/.gitconfig
    
    if [ ! -f ~/.gitconfig-work ]; then
        touch ~/.gitconfig-work
    fi

    rm -f ~/.gitignore
    ln -s "${PWD}/git/.gitignore" ~/.gitignore
    
    set +x
}

01_setup_vim() {
    set -x
	rm -rf ~/.vim ~/.vimrc
    ln -s "${PWD}/vim" ~/.vim
    ln -s ~/.vim/.vimrc ~/.vimrc
    set +x
}

01_setup_zsh(){
    set -x
	rm -f ~/.zshrc ~/.zsh-custom
	ln -s ${PWD}/zsh/zshrc ~/.zshrc
    # ln -s ${PWD}/zsh/custom ~/.zsh-custom
    # rm ~/.zshrc
# ln -s ~/Code/personal/dotfiles/zsh/zshrc ~/.zshrc
# ln -s ~/Code/personal/dotfiles/zsh/oh-my-zsh/custom.zsh ~/.oh-my-zsh/custom/custom.zsh
# ln -s ~/Code/personal/dotfiles/zsh/oh-my-zsh/powerlevel10k.zsh ~/.oh-my-zsh/custom/powerlevel10k.zsh
    ln -s ${PWD}/zsh/custom/themes/nyxgear.zsh-theme ~/.oh-my-zsh/custom/themes/nyxgear.zsh-theme
    ln -s ${PWD}/zsh/init.zsh ~/.oh-my-zsh/custom/init.zsh
    # ln -s ${PWD}/zsh/init.sh ~/.oh-my-zsh/custom/init.sh
    chsh -s /usr/local/bin/zsh


    set +x
}


01_install_brew() {
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    set -x
    rm -f ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    set +x
}


# brew install zsh
# brew install git
# brew install vim
# brew install nvm



#gui apps
# brew install --cask zoom
# brew install --cask slack
# brew install --cask jetbrains-toolbox
# brew install docker
# brew install docker-compose

# brew install --cask spotify
# brew install --cask firefox
# brew install --cask visual-studio-code
# brew install --cask session-manager-plugin  # useful for AWS SSM

# brew install kubectl
# brew install kubecolor/tap/kubecolor
# brew install jq

# brew install --cask obsidian



# brew tap hashicorp/tap
# brew install hashicorp/tap/vault







main() {
    # list of functions
    functions=$(grep -E '^[0-9]+_(setup_|install_).*' setup.sh | cut -d'(' -f1 | tr '()' ' ' | sort)

    echo "Available functions:"
    for func in $functions; do
        echo "- $func"
    done

    while true; do
        read -p "Run functions (comma-separated): " function_names
        IFS=',' read -ra FUNCS <<< "$function_names" # Split input into array

        for func in "${FUNCS[@]}"; do
            func=$(echo "$func" | tr -d ' ') #trim
            if declare -f "$func" > /dev/null; then
                echo "--- Running '$func'"
                $func
                echo "--- Done with '$func'"
            else
                echo "--- '$func' not found."
            fi
        done
    done
}

main