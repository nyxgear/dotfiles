#! /bin/bash

# NODE: All functions in this file are idempotent.

PWD=$(git rev-parse --show-toplevel)

01_install_ohmyzsh(){
    set -x
    rm -rf ~/.oh-my-zsh
    unset ZSH
    echo 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    set +x
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

02_setup_zsh(){
    set -x
	rm -rf ~/.zshrc ~/.zsh-custom
	ln -s ${PWD}/zsh/zshrc ~/.zshrc
    # symlink all zsh files in oh-my-zsh/custom to ~/.oh-my-zsh/custom so they are automatically sourced
    for file in ${PWD}/oh-my-zsh/custom/*.zsh; do
        rm -rf ~/.oh-my-zsh/custom/$(basename $file)
        ln -s $file ~/.oh-my-zsh/custom/$(basename $file)
    done
    chsh -s $(which zsh)
    set +x
}

03_setup_git() {
    set -x
    
    rm -f ~/.gitconfig
    ln -s "${PWD}/git/gitconfig" ~/.gitconfig
    
    # this will/could be setup later
    if [ ! -f ~/.gitconfig-work ]; then
        touch ~/.gitconfig-work
    fi

    rm -f ~/.gitignore
    ln -s "${PWD}/git/gitignore" ~/.gitignore
    
    set +x
}

04_setup_vim() {
    set -x
	rm -rf ~/.vim ~/.vimrc
    ln -s "${PWD}/vim" ~/.vim
    ln -s "${PWD}/vim/vimrc" ~/.vimrc
    set +x
}

05_setup_cursor() {
    set -x

    mkdir -p ~/.cursor/rules ~/.cursor/skills

    for file in "${PWD}"/cursor/rules/*.mdc; do
        [ -f "$file" ] || continue
        ln -sf "$file" ~/.cursor/rules/$(basename "$file")
    done

    for file in "${PWD}"/cursor/skills/*/SKILL.md; do
        [ -f "$file" ] || continue
        skill_dir=$(basename "$(dirname "$file")")
        mkdir -p ~/.cursor/skills/"${skill_dir}"
        ln -sf "$file" ~/.cursor/skills/"${skill_dir}"/SKILL.md
    done

    set +x
}


10_install_brew() {
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    set -x
    rm -f ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    set +x
}

11_reminder_brew_apps() {
    echo "Reminder to install apps with brew:"
    echo
    echo "brew install git"
    echo "brew install vim"
    echo "brew install jq"
    echo "brew install yq"
    echo "brew install htop"
    echo "brew install tmux"
    echo
    echo "----------------------------------------"
    echo
    echo "brew install kubectl"
    echo "brew install fzf"
    echo "brew install bat"
    # echo "brew install git-delta"
    # echo "brew install fd"
    # echo "brew install exa"
    # echo "brew install ripgrep"
    # echo "brew install delta"
    echo
}

12_reminder_brew_gui_apps() {
    echo "Reminder to install GUIs apps with brew:"
    echo
    echo "brew install --cask obsidian"
    echo "brew install --cask rectangle"
    echo "brew install --cask zoom"
    echo "brew install --cask slack"
    echo "brew install --cask jetbrains-toolbox"
    echo "brew install --cask docker"
    echo "brew install --cask docker-compose"
    echo "brew install --cask spotify"
    echo "brew install --cask firefox"
    echo "brew install --cask visual-studio-code"
    echo "brew install --cask bitwarden"
    echo "brew install --cask cursor"
    echo "brew install --cask session-manager-plugin" # useful for AWS SSM
    echo "brew install --cask hashicorp/tap/vault"
    echo
}


main() {
    functions=$(grep -E '^[0-9]+_(setup_|install_|reminder_).*' setup.sh | cut -d'(' -f1 | tr '()' ' ' | sort)

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