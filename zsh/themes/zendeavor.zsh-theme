#
# A theme supporting vcs info.
#
# based on theme by:
#   James McGlashan <james.mcglashan@affinityvision.com.au>
#
# shamelessly recycled by:
#   zendeavor <<j dot s dot mcgee at gmail dot com>>

zstyle ':vcs_info:*' enable git

function +vi-git-status {
  # Untracked files.
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    hook_com[unstaged]='%F{red}●%f'
  fi
}

function prompt_zendeavor_help {
  cat <<EOH
This prompt is color-scheme-able.  You can invoke it thus:

  prompt zendeavor [<user-color>] [<host-color>] [<path-color>] [<archey-color>]

The default colors are cyan and blue respectively.  This theme is
intended for use with a black background.
EOH
}

function prompt_zendeavor_precmd {
  vcs_info
}

function prompt_zendeavor_setup {
  local hc pc dc nc
  [[ -n $SSH_TTY ]] && hc=magenta || hc=blue
  hc=${2:-$hc}
  pc=${3:-'green'}
  dc=${4:-'none'}
  nc="%F{$1}"

  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  autoload -Uz add-zsh-hook vcs_info

  add-zsh-hook precmd prompt_zendeavor_precmd

  zstyle ':vcs_info:*' enable bzr git hg svn
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr '%F{g}●%f'
  zstyle ':vcs_info:*' unstagedstr '%F{y}●%f'
  zstyle ':vcs_info:*' formats '%F{g}%b%c%u%F{n}'
  zstyle ':vcs_info:*' actionformats "%b%c%u|%F{c}%a%f"
  zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b|%F{c}%r%f'
  zstyle ':vcs_info:git*+set-message:*' hooks git-status

  PROMPT='%(#.%F{r}.%F{c})'"%n on %F{c}%l%F{$dc}@%F{$hc%}%m%F{$dc}:%F{g}%~%F{r}%(?.. [%?])%F{$dc} %F{m}[%h]%F{$dc} %F{y}%D{%-K:%M%P %-f/%m}%F{$dc} 
  %F{$pc}%(?.. -%j-)%F{$dc} %F{c}%#%F{$dc} "
  RPROMPT='${vcs_info_msg_0_}%{$reset_color%}'
	SPROMPT='zsh: correct %F{r}%R%f to %F{g}%r%f [nyae]? '
  PROMPT2="%F{m}%U%_%u%F{$dc} %F{c}»%F{$dc}%F{g}%F{$dc} "
}

function prompt_zendeavor_preview {
  if (( ! $#* )); then
    prompt_preview_theme zendeavor
    print
    prompt_preview_theme zendeavor red green blue magenta
  else
    prompt_preview_theme zendeavor "$@"
  fi
}

prompt_zendeavor_setup "$@"

# vim: set ft=zsh:

