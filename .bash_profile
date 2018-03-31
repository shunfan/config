BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
REVERSE=$(tput rev)
RESET=$(tput sgr0)

function current_time() {
  echo "[$(date +"%I:%M %p")]"
}

# Source: https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/git.zsh#L61-L74
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo "${YELLOW} (${ref#refs/heads/} $(parse_git_dirty)${YELLOW})${RESET}"
}

# Source: https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/git.zsh#L11-L30
function parse_git_dirty() {
  local STATUS=''
  STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
  if [[ -n $STATUS ]]; then
    echo "${RED}✗${RESET}"
  else
    echo "${GREEN}✓${RESET}"
  fi
}

function node_version() {
  local NODE_VERSION=''
  NODE_VERSION=$(command node -v | awk '{gsub(/v/, "", $1); print $1}')
  echo "(Node ${GREEN}${NODE_VERSION}${RESET})"
}

function java_version() {
  local JAVA_VERSION=''
  JAVA_VERSION=$(command java -version 2>&1 >/dev/null | head -n 1 | awk -F '"' '{print $2}')
  echo "(Java ${GREEN}${JAVA_VERSION}${RESET})"
}

function docker_status() {
  if docker ps >/dev/null 2>&1; then
    echo "(Docker ${GREEN}●${RESET})"
  else
    echo "(Docker ${RED}●${RESET})"
  fi
}

function mongodb_status() {
  # Source: https://stackoverflow.com/a/31563972
  if [[ "$(command ps -ef | grep mongod | grep -v grep | wc -l | tr -d ' ')" != "0" ]]; then
    echo "(MongoDB ${GREEN}●${RESET})"
  else
    echo "(MongoDB ${RED}●${RESET})"
  fi
}

# Source: https://www.kirsle.net/wizards/ps1.html
export PS1="\
${BOLD}${RESET}\
${WHITE}┌─${RESET} \
${WHITE}\$(current_time) \u@\h${RESET} \
${BLUE}\w${RESET}\
\$(git_current_branch) \$(node_version) \$(java_version) \$(docker_status) \$(mongodb_status)\
\n\[${WHITE}\]└─\[${RESET}\] \
\[${YELLOW}\]%\[${RESET}\] "

# Other sources
source ~/.git-completion.bash

# Alias
alias config="vim ~/.bash_profile"
alias dev="cd ~/Developer"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# macOS
alias reset_launchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH
