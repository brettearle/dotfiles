# --- Powerlevel10k instant prompt (keep at the very top) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Homebrew (do this early so PATH is sane) ---
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- Go ---
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
alias air='$(go env GOPATH)/bin/air'
export PATH=$HOME/.go/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$PATH:/usr/local/go/bin

# --- Deno ---
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"

# --- Extra PATH bits (after brew shellenv so we don't clobber it) ---
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# --- Function path (for any custom completions/functions) ---
fpath+=(${ZDOTDIR:-$HOME}/.zsh_functions)

# --- Oh My Zsh setup ---
export ZSH="$HOME/.oh-my-zsh"

POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PRESET='dracula'
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  virtualenv
)

source "$ZSH/oh-my-zsh.sh"

# --- Completions / extras ---
autoload bashcompinit && bashcompinit
if command -v brew >/dev/null 2>&1; then
  AZ_COMP="$(brew --prefix 2>/dev/null)/etc/bash_completion.d/az"
  [[ -f "$AZ_COMP" ]] && source "$AZ_COMP"
fi

[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Powerlevel10k config file ---
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# --- Your tmux wrapper ---
tmux() {
  # If any arguments are passed, just call real tmux with them
  if [ "$#" -gt 0 ]; then
    command tmux "$@"
    return
  fi

  # No args: smart attach-or-create behaviour
  local SESSION_NAME="main"

  # If session exists, attach
  if command tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    command tmux attach -t "$SESSION_NAME"
    return
  fi

  # Otherwise, create session with 3 windows
  command tmux new-session -d -s "$SESSION_NAME" -n nvim
  command tmux new-window  -t "$SESSION_NAME":2 -n zsh
  command tmux new-window  -t "$SESSION_NAME":3 -n serv

  # Start on window 1
  command tmux select-window -t "$SESSION_NAME":1

  # Attach
  command tmux attach -t "$SESSION_NAME"
}


