# Files and directories
alias f="fzf"
alias vf='nvim "$(fzf)"'
alias ff='find . -type f 2>/dev/null | fzf'
alias cf='cd "$(find . -type d 2>/dev/null | fzf)"'

# Command history
alias fh='history | fzf'
alias fhc='eval "$(history | fzf | sed "s/ *[0-9]* *//")"'

# Git helpers
alias fgc='git checkout "$(git branch --all | grep -v "HEAD" | sed "s/.* //" | fzf)"'
alias fgl='git log --oneline --decorate | fzf'
alias fgd='git diff "$(git log --oneline | fzf | cut -d" " -f1)"'
alias fgs='git stash list | fzf | cut -d: -f1 | xargs -r git stash show -p'

# Processes
alias fps='ps aux | fzf'

# Safer kill helper:
# - defaults to SIGTERM (graceful)
# - use fk9 for SIGKILL if needed
function fk() {
  local pid
  pid="$(ps -ef | fzf | awk "{print \$2}")" || return 1
  [[ -n "$pid" ]] || return 1
  kill "$pid"
}

function fk9() {
  local pid
  pid="$(ps -ef | fzf | awk "{print \$2}")" || return 1
  [[ -n "$pid" ]] || return 1
  kill -9 "$pid"
}

# Extras
alias fp='fzf --preview "bat --style=numbers --color=always {} | head -200"'
alias fz='zoxide query -l | fzf'   # requires zoxide
alias fm='man -k . | fzf | awk "{print \$1}" | xargs -r man'
alias fa='alias | fzf'

