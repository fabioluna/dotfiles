source /Users/fabioluna/.oh-my-zsh/custom/aliases_fzf.zsh
[[ -r /Users/fabioluna/.oh-my-zsh/custom/aliases_tv.zsh ]] && source /Users/fabioluna/.oh-my-zsh/custom/aliases_tv.zsh

# Eza
alias ls='eza -G  --color auto --icons -a -s type'
alias ll='eza -l --color always --icons -a -s type'

# NVIM
if command -v nvim >/dev/null 2>&1; then
  alias -g vim=nvim
fi

# Docker Clean
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '
alias up='docker-compose up -d'
alias down='docker-compose down'

# Python Virtualenv
alias pyenv='source .venv/bin/activate'

# Zoxide with fzf configuration
alias zi='zi'
function zi() {
  cd "$(zoxide query -i)"
}

# SSH Tonder
alias tonder-sandbox='kitty +kitten ssh -i ~/.ssh/zplit-stage.pem ubuntu@34.193.40.196'
alias tonder-stage='kitty +kitten ssh -i ~/.ssh/zplit-stage.pem ubuntu@35.170.231.17'
alias tonder-prod='kitty +kitten ssh -i ~/.ssh/zplit-stage.pem ubuntu@34.195.238.2'
alias tonder-dev='kitty +kitten ssh -i ~/.ssh/tonder-dev ubuntu@34.236.234.57'

# Newsboat
alias nb='newsboat'

# Sesh
alias ws='sesh connect "$(sesh list | fzf --height 40%)"'

# Atuin
alias ah='atuin search --interactive'
