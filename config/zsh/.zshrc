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
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

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
SAVEHIST=1000
setopt appendhistory

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
