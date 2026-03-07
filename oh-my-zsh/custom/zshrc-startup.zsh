# sourced by ~/.zshrc
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/bin:$PATH

# export PATH=/Users/stefano.cilloni/Library/Python/3.9/bin:$PATH

# GO PATH
# https://go.dev/doc/install
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# aliases
alias l='ls -lah'
alias k=kubectl
alias d=docker
alias tf=terraform
alias weather='f(){ curl v2.wttr.in"$@";  unset -f f; }; f'


# https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#enable-shell-autocompletion
source <(kubectl completion zsh)
complete -F __start_kubectl k


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


# source the work zshrc-startup.zsh if it exists
source ~/.dotfiles-work/oh-my-zsh/custom/zshrc-startup-work.zsh 2>/dev/null || true

