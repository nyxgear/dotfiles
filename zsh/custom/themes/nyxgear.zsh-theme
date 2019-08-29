setopt prompt_subst

export LSCOLORS=ExGxFxDxCxHxHxCbCeEbEb

ZSH_THEME_GIT_PROMPT_PREFIX=" on ("
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "

PROMPT=$'%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg[green]%}%~%{$reset_color%}% $(git_super_status) \n$ '
RPROMPT=''

