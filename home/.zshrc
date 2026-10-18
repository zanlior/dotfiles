# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Aliases

# Fedora package aliases. No Arch package manager or AUR helper on this branch.
alias i='sudo dnf install'
alias r='sudo dnf remove'
alias u='sudo dnf upgrade --refresh'
alias U='sudo dnf upgrade --refresh'
alias icc='sudo dnf clean packages'

#System 
alias s='sudo'
alias status='sudo systemctl status' 
alias enable='sudo systemctl enable' 
alias start='sudo systemctl start' 
alias stop='sudo systemctl stop'
alias disable=' sudo systemctl disable'
alias sleep='systemctl suspend'


#Utility 
alias v='nvim'
alias ls='eza -a'
alias du='dust'
alias gparted=' sudo gparted & disown'

#Config
alias ezsh='nvim ~/.zshrc'
alias ehypr='nvim  ~/.config/hypr/hyprland.lua'
alias ekitty='nvim ~/.config/kitty/kitty.conf'

#Misc
alias show='nitch'
alias vf='nvim $(fzf)'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> Codex installer >>>
export PATH="@@HOME@@/.local/bin:$PATH"
# <<< Codex installer <<<
