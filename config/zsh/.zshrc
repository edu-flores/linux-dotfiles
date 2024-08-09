# +============================+
#
#
#   ███████╗███████╗██╗  ██╗
#   ╚══███╔╝██╔════╝██║  ██║
#     ███╔╝ ███████╗███████║
#    ███╔╝  ╚════██║██╔══██║
#   ███████╗███████║██║  ██║
#   ╚══════╝╚══════╝╚═╝  ╚═╝
#
#
# +============================+

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Bindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-word
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward

# Theme
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions
HISTFILE=~/.zsh/.histfile
HISTSIZE=1000
HISTDUP=erase
SAVEHIST=$HISTSIZE
setopt appendhistory          # Append to history file instead of overwriting
setopt sharehistory           # Share history across all sessions
setopt hist_ignore_space      # Ignore commands prefixed with a space
setopt hist_ignore_all_dups   # Remove all duplicate entries from history
setopt hist_save_no_dups      # Don't save duplicate commands in history
setopt hist_ignore_dups       # Ignore consecutive duplicate commands
setopt hist_find_no_dups      # Skip duplicates during history search
setopt interactive_comments   # Allow comments in interactive shell

# Styling
autoload -Uz compinit && compinit
export LS_COLORS="di=34:ln=36:so=32:pi=35:ex=31:bd=44;37:cd=44;37:su=41;30:sg=46;30:tw=42;30:ow=43;30"
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"

# Aliases
alias ls="eza --icons --hyperlink --group-directories-first"
alias ll="eza --long --all --icons --hyperlink --group-directories-first --bytes --git --time-style='+%d %B %Y, %I:%M %p'"
alias ld="ls --only-dirs"
alias lf="ls --only-files"
alias lt="ls --tree --git-ignore"
alias cat="bat --paging=never"
alias less="bat --paging=always"
alias grep="rg"
alias cd="z"
alias Windows="sudo grub-reboot 1 && sudo shutdown -r now"

# Initialize zoxide
eval "$(zoxide init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
