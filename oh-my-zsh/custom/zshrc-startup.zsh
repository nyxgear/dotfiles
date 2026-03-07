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

# source the work zshrc-startup.zsh if it exists
source ~/.dotfiles-work/oh-my-zsh/custom/zshrc-startup-work.zsh 2>/dev/null || true

