#! /bin/bash

PWD=$(git rev-parse --show-toplevel)

01_setup_git() {
    set -x
    rm -f ~/.gitconfig-work
    ln -s "${PWD}/git/gitconfig" ~/.gitconfig-work
    set +x
}

02_setup_cursor() {
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

# zshrc-startup.zsh is already sourced by root dotfiles repo. no need to setup it here.

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