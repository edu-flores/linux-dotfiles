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

# Bindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-word
bindkey "^[[3~" delete-char
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions
HISTFILE=~/.zsh_history
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

# Completions
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
alias cat="bat --paging=never --style=plain"
alias more="bat --paging=always"
alias grep="rg"
alias df="duf --only=local"
alias find="fd"
alias editpick='file=$(fd --type f --hidden | fzf --preview="bat --color=always {}") && [ -n "$file" ] && nano "$file"'
alias Windows="sudo grub-reboot 1 && sudo shutdown -r now"

# Customize fzf style
export FZF_DEFAULT_OPTS="--height 70% --reverse"
export FZF_CTRL_T_COMMAND="fd --type f"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Initialize zoxide
eval "$(zoxide init --cmd cd zsh)"

# Theme
eval "$(oh-my-posh init zsh --config ~/.config/omp/theme.toml)"
