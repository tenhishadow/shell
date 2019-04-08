# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] &&  . /etc/bashrc

# get current branch in git repo
function parse_git_branch() {
  BRANCH=$( git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' )
  [[ ! "${BRANCH}" == "" ]] && STAT=$( parse_git_dirty ) && echo "[${BRANCH}${STAT}]"
}

# get current status of git repo
function parse_git_dirty {
  status=$( git status 2>&1 | tee )
  dirty=$( echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?" )
  untracked=$( echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?" )
  ahead=$( echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?" )
  newfile=$( echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?" )
  renamed=$( echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?" )
  deleted=$( echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?" )
  bits=''
  if [ "${renamed}" == "0" ]
    then bits=">${bits}"
  elif [ "${ahead}" == "0" ]
    then bits="*${bits}"
  elif [ "${newfile}" == "0" ]
    then bits="+${bits}"
  elif [ "${untracked}" == "0" ]
    then bits="?${bits}"
  elif [ "${deleted}" == "0" ]
    then bits="x${bits}"
  elif [ "${dirty}" == "0" ]
    then bits="!${bits}"
  elif [ ! "${bits}" == "" ]
    then echo " ${bits}"
  else
    echo ""
  fi
}

export PS1="\[\e[33m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]\[\e[31m\]:\[\e[m\]\[\e[36m\]\W\[\e[m\]\[\e[31;43m\]\`parse_git_branch\`\[\e[m\]\[\e[32m\]\\$\[\e[m\] "
