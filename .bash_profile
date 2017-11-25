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
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    echo "${RED}✗${RESET}"
  else
    echo "${GREEN}✓${RESET}"
  fi
}

function docker_status() {
  if docker ps > /dev/null 2>&1; then
    echo "(Docker ${GREEN}●${RESET})"
  else
    echo "(Docker ${RED}●${RESET})"
  fi
}

function current_time() {
  echo "($(date +"%I:%M %p"))"
}

# Source: https://www.kirsle.net/wizards/ps1.html
export PS1="${BOLD}${RESET}${WHITE}┌─${RESET} ${WHITE}\u@\h${RESET} ${BLUE}\w${RESET}\$(git_current_branch) \$(docker_status) \$(current_time)\n${WHITE}└─${RESET} ${YELLOW}%${RESET} "

source ~/.git-completion.bash
