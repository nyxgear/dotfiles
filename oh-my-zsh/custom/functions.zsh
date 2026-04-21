#!/bin/bash

function set_token_to_keychain() {
    local token_name=$1
    local token_comment=$2
    security add-generic-password -a "$USER" -s "$token_name" -j "$token_comment" -U -p
    echo "Token set to keychain: $token_name"
}

function get_token_from_keychain() {
    local token_name=$1
    security find-generic-password -w -s "$token_name" -a "$USER"
}

function set_github_token {
	set_token_to_keychain "github-token" "GitHub Token"
}

function export_github_token {
	local token=$(get_token_from_keychain "github-token")
	export GITHUB_TOKEN=$token
	echo "GITHUB_TOKEN exported. echo \$GITHUB_TOKEN"
}

function set_pulumi_config_passphrase {
	set_token_to_keychain "pulumi-config-passphrase" "Pulumi Config Passphrase"
}

function export_pulumi_config_passphrase {
	local passphrase=$(get_token_from_keychain "pulumi-config-passphrase")
	export PULUMI_CONFIG_PASSPHRASE=$passphrase
	echo "PULUMI_CONFIG_PASSPHRASE exported. echo \$PULUMI_CONFIG_PASSPHRASE"
}

is_internet_available() {
    ping -q -c1 google.com &>/dev/null && echo "1" || echo "0"
}

update_plugin_from_git() {
    plugin_url=$1
    plugin_directory=$ZSH_CUSTOM/plugins/$(basename $plugin_url)
    if [ ! -d "$plugin_directory" ]; then
        echo "- Cloning $plugin_url"
        git clone --depth 1 $plugin_url $plugin_directory
    else
        echo "- Pulling $plugin_url"
        git -C $plugin_directory pull
    fi
}

update_packages() {
    # Note: this update_packages function is not called automatically and has to be invoked manually.
    # TODO: check 
    # https://github.com/TamCore/autoupdate-oh-my-zsh-plugins
    # https://github.com/ptavares/zsh-auto-update-plugins
    internet_available="$(is_internet_available)"
    if [ $internet_available -eq 1 ]; then

        update_plugin_from_git "https://github.com/marlonrichert/zsh-autocomplete"

        update_plugin_from_git "https://github.com/zsh-users/zsh-syntax-highlighting"

    fi

    wait
}

docker_clean_containers() {
    docker ps -q -a | xargs -I id sh -c 'docker stop id && docker rm id' 
}

# Restart Docker for Mac
# https://forums.docker.com/t/restart-docker-from-command-line/9420/8
docker_restart() {
    docker ps -q | xargs -I id sh -c 'docker stop id && docker rm id' && 
        test -z "$(docker ps -q 2>/dev/null)" && 
        osascript -e 'quit app "Docker"' && 
        open -g /Applications/Docker.app && 
        while ! docker system info > /dev/null 2>&1; do sleep 1; done && 
        # docker system prune -f --volumes
}

docker_watch() {
    watch -n 5 'docker ps --format "table {{.Names}}\t{{.Status}}" -a'
}

k8_pods_watch() {
    watch -n 5 "kubectl get pods | grep $1"
}
