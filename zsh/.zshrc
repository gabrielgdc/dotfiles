# =====================================================
# ZSH Plugins
# =====================================================

plugins=(git)

# =====================================================
# Homebrew
# =====================================================

# Load Homebrew environment variables and PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# =====================================================
# Google Cloud SDK
# =====================================================

if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
fi

if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
fi

# =====================================================
# ZSH Enhancements
# =====================================================

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# =====================================================
# Starship Prompt
# =====================================================

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# =====================================================
# Zoxide
# =====================================================

eval "$(zoxide init zsh)"
alias cd='z'

# =====================================================
# Atuin
# =====================================================

eval "$(atuin init zsh)"

# =====================================================
# Eza (Modern ls)
# =====================================================

alias ls="eza -l --icons --git -a"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# =====================================================
# Carapace Completion Engine
# =====================================================

autoload -U compinit && compinit
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# =====================================================
# TMUX Auto Start
# =====================================================

if [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi

# =====================================================
# Aliases
# =====================================================

alias xconf="cd ~/.config"

# =====================================================
# Functions
# =====================================================

cx() {
  cd "$@" && l
}

fcd() {
  cd "$(find . -type d -not -path '*/.*' | fzf)" && l
}

f() {
  echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy
}

fv() {
  nvim "$(find . -type f -not -path '*/.*' | fzf)"
}