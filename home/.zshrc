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

# Pacman
alias i='sudo pacman -S'
alias r='sudo pacman -R'
alias rns='sudo pacman -Rns'
alias u='sudo pacman -Sy'
alias U='sudo pacman -Syu'
alias s='sudo pacman -Ss'
alias icc='sudo pacman -Scc'

#Paru
alias yay='paru'
alias pi='paru -S' 
alias ps='paru -Ss'
alias pr='paru -R'
alias pu=' paru -Sy'
alias pU='paru -Syu'
alias prns='paru -Rns'
alias pcc='paru -Scc'

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
alias ls='exa -a'
alias du='dust'
alias gparted=' sudo gparted & disown'

#Config
alias ezsh='nvim ~/.zshrc'
alias ehypr='nvim  ~/.config/hypr/hyprland.conf'
alias ekitty='nvim ~/.config/kitty/kitty.conf'

#Misc
alias show='nitch'
alias vf='nvim $(fzf)'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> Codex installer >>>
export PATH="@@HOME@@/.local/bin:$PATH"
# <<< Codex installer <<<
