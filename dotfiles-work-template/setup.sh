#! /bin/bash

PWD=$(git rev-parse --show-toplevel)

01_setup_git() {
    set -x
    rm -f ~/.gitconfig-work
    ln -s "${PWD}/git/gitconfig" ~/.gitconfig-work
    set +x
}


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