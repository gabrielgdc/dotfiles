# =====================================================
# OS Detection
# =====================================================

IS_MACOS=false
IS_LINUX=false

if [[ "$(uname -s)" == "Darwin" ]]; then
  IS_MACOS=true
elif [[ "$(uname -s)" == "Linux" ]]; then
  IS_LINUX=true
fi

# =====================================================
# ZSH Plugins
# =====================================================

plugins=(git)

# =====================================================
# Package Manager / Binary Environment
# =====================================================

if $IS_MACOS; then
  # Homebrew no macOS (Apple Silicon / Intel)
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# =====================================================
# ZSH Enhancements (Autosuggestions & Highlighting)
# =====================================================

if $IS_MACOS; then
  # Caminhos do Homebrew no macOS
  [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

elif $IS_LINUX; then
  # Caminhos padrão do Fedora (DNF)
  [ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# =====================================================
# Starship Prompt
# =====================================================

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
command -v starship &>/dev/null && eval "$(starship init zsh)"

# =====================================================
# Zoxide
# =====================================================

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# =====================================================
# Atuin
# =====================================================

command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# =====================================================
# Eza (Modern ls)
# =====================================================

if command -v eza &>/dev/null; then
  alias ls="eza -l --icons --git -a"
  alias l="eza -l --icons --git -a"
  alias lt="eza --tree --level=2 --long --icons --git"
  alias ltree="eza --tree --level=2 --icons --git"
fi

# =====================================================
# Carapace Completion Engine
# =====================================================

if command -v carapace &>/dev/null; then
  autoload -U compinit && compinit
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
fi

# =====================================================
# TMUX Auto Start
# =====================================================

# Inicia o Tmux apenas se ele estiver instalado e em sessões interativas no terminal
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ -t 0 ]; then
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

# Copiar para a clipboard (Cross-platform)
f() {
  local selected_file
  selected_file="$(find . -type f -not -path '*/.*' | fzf)"

  if [ -n "$selected_file" ]; then
    if $IS_MACOS; then
      echo "$selected_file" | pbcopy
    elif command -v xclip &>/dev/null; then
      echo "$selected_file" | xclip -selection clipboard
    elif command -v wl-copy &>/dev/null; then
      echo "$selected_file" | wl-copy
    else
      echo "$selected_file"
      echo "Aviso: Nenhum utilitário de clipboard (xclip/wl-clipboard) encontrado."
    fi
  fi
}

fv() {
  local selected_file
  selected_file="$(find . -type f -not -path '*/.*' | fzf)"
  [ -n "$selected_file" ] && nvim "$selected_file"
}
