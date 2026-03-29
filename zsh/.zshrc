# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

eval "$(/opt/homebrew/bin/brew shellenv)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gabriel/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gabriel/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gabriel/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gabriel/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# ZSH Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship configuration
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Zoxide configuration
eval "$(zoxide init zsh)"
alias cd='z' # Aliases to use zoxide navigation instead of default cd navigation

# Atuin configuration
eval "$(atuin init zsh)"

# Eza
alias ls="eza -l --icons --git -a"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# Carapace configuration
autoload -U compinit && compinit
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# Auto Start with TMUX
if [ -z "$TMUX" ]; then
    tmux new-session -A -s main
fi

alias xconf="cd ~/.config"

cx() { cd "$@" && l; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)" }
