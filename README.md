# Brett’s Dotfiles

A portable setup for:

- **Zsh** (Oh My Zsh + Powerlevel10k)
- **tmux** (Catppuccin, plugins via TPM)
- **Neovim** (Kickstart-based config)
- **Alacritty**
- Managed with **GNU Stow**

This repo is meant to live in **`~/dotfiles`**.  
The `bootstrap.sh` script symlinks everything into place.

---

## 1. Requirements (install these first)

### Homebrew
Install from https://brew.sh  
Check with:

```bash
which brew
````

### Core tools

Install with brew if versions are good on brew otherwise install manually:

```bash
brew install git zsh tmux neovim alacritty stow ripgrep fd
```

### Fonts (for Powerlevel10k)

Install a Nerd Font (recommended: JetBrainsMono):

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

Set this font in Alacritty or terminal.

### Oh My Zsh + Powerlevel10k

```bash
# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### NVM (Node version manager)

Create the NVM dir:

```bash
mkdir -p ~/.nvm
```

Install NVM if needed:

```bash
brew install nvm
```

---

## 2. Setup

Clone into **`~/dotfiles`**:

```bash
cd ~
git clone git@github.com:brettearle/dotfiles.git
cd ~/dotfiles
```

Run bootstrap:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

This stows:

* `~/.zshrc`, `~/.p10k.zsh`
* `~/.tmux.conf`
* `~/.config/nvim`
* `~/.config/alacritty`

---

## 3. After setup

### Open a new terminal

* Zsh should load Powerlevel10k
* `$PATH` should include Homebrew and NVM
* Alacritty should load your theme

### Test tools

```bash
tmux
nvim
brew --version
rg --version
```

---

## 4. Common reminders

* Always run `stow` from **`~/dotfiles`**, targeting home:

  ```bash
  cd ~/dotfiles
  stow -t ~ zsh tmux nvim alacritty
  ```

* Never edit files inside `~/.config` directly — edit files in `~/dotfiles` instead.

* Add secrets or machine-specific settings in `~/.zshrc.local` (ignored by git):

  ```zsh
  [ -f ~/.zshrc.local ] && source ~/.zshrc.local
  ```

* Install TPM once if tmux plugins don't load:

  ```bash
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ```

---

## 5. Undo (optional)

```bash
cd ~/dotfiles
stow -t ~ -D zsh tmux nvim alacritty
```


