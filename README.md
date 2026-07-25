# Installation

## 1. Clone the Repository

Clone the repository into your home directory:

```bash
git clone https://github.com/gabrielgdc/dotfiles.git
```

## 2. Install Packages and Dependencies

Run the bootstrap script to install all required packages, configure the environment, and set Zsh as the default shell:

```bash
chmod +x install.sh
./install.sh
```

## 3. Apply Dotfiles with GNU Stow

```bash
# (Optional) Preview the symbolic links that will be created
stow -nv */

# Apply all dotfiles
stow */
```

> **Note:** If Stow reports conflicts (for example, an existing `~/.zshrc`), remove the conflicting file and run the command again.

```bash
rm ~/.zshrc
stow */
```
