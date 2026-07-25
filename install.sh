#!/bin/bash

# =====================================================
# Configuração de Logs
# =====================================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }

# =====================================================
# Detecção do Sistema Operacional
# =====================================================
OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
    IS_MACOS=true
    info "Sistema detectado: macOS"
elif [ "$OS" = "Linux" ]; then
    IS_FEDORA=true
    info "Sistema detectado: Linux"
else
    echo "Sistema operacional $OS não suportado."
    exit 1
fi

is_installed() {
    command -v "$1" &>/dev/null
}

# =====================================================
# Instalação - Fedora (DNF)
# =====================================================
install_fedora() {
    if ! is_installed dnf; then
        echo "Erro: Este sistema não utiliza 'dnf'."
        exit 1
    fi

    # Habilita o COPR do Starship se o binário ainda não existir
    if ! is_installed starship; then
        info "Habilitando o repositório COPR atim/starship para o Starship..."
        sudo dnf copr enable -y atim/starship
    fi

    local packages=(
        "stow"
        "zsh"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "git"
        "curl"
        "tmux"
        "neovim"
        "fzf"
        "zoxide"
        "eza"
        "atuin"
        "wl-clipboard"
    )

    local to_install=()

    for pkg in "${packages[@]}"; do
        if rpm -q "$pkg" &>/dev/null; then
            warn "Pacote '$pkg' já está instalado."
        else
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        info "Instalando pacotes via dnf: ${to_install[*]}"
        sudo dnf install -y "${to_install[@]}"
    else
        success "Todos os pacotes do Fedora já estão instalados!"
    fi
}

# =====================================================
# Instalação - macOS (Homebrew)
# =====================================================
install_macos() {
    if ! is_installed brew; then
        info "Homebrew não encontrado. Instalando..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [ -f "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

    local brew_formulae=(
        "stow"
        "zsh"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
        "git"
        "tmux"
        "neovim"
        "fzf"
        "zoxide"
        "eza"
        "starship"
        "atuin"
        "carapace"
    )

    local to_install=()

    for formula in "${brew_formulae[@]}"; do
        if brew list "$formula" &>/dev/null; then
            warn "Fórmula '$formula' já está instalada."
        else
            to_install+=("$formula")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        info "Instalando fórmulas via brew: ${to_install[*]}"
        brew install "${to_install[@]}"
    else
        success "Todas as fórmulas do Homebrew já estão instaladas!"
    fi
}

# =====================================================
# Troca do Shell Padrão para ZSH
# =====================================================
setup_default_shell() {
    info "Configurando o ZSH como shell padrão..."

    ZSH_PATH="$(which zsh)"

    if [ -z "$ZSH_PATH" ]; then
        echo "Erro: Zsh não foi encontrado no sistema."
        return 1
    fi

    if [ "$SHELL" = "$ZSH_PATH" ]; then
        success "Zsh já é o seu shell padrão ($SHELL)."
        return 0
    fi

    if ! grep -qxF "$ZSH_PATH" /etc/shells; then
        info "Adicionando $ZSH_PATH ao /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi

    info "Alterando o shell padrão para $ZSH_PATH..."
    if [ "$IS_FEDORA" = true ]; then
        sudo chsh -s "$ZSH_PATH" "$USER"
    else
        chsh -s "$ZSH_PATH"
    fi

    if [ $? -eq 0 ]; then
        success "Shell padrão alterado para ZSH com sucesso!"
    else
        warn "Falha ao alterar o shell automático. Execute manualmente: sudo chsh -s $ZSH_PATH $USER"
    fi
}

# =====================================================
# Execução Principal
# =====================================================
main() {
    if [ "$IS_FEDORA" = true ]; then
        install_fedora
    elif [ "$IS_MACOS" = true ]; then
        install_macos
    fi

    echo ""
    setup_default_shell

    echo ""
    success "Setup de pacotes concluído!"
}

main
