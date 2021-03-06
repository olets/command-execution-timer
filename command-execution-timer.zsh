# command-execution-timer
# https://github.com/olets/git-prompt-kit
#
# Forked from https://github.com/romkatv/powerlevel10k

# Show duration of the last command if takes at least this many seconds.
typeset -g COMMAND_EXECUTION_TIMER_THRESHOLD=${COMMAND_EXECUTION_TIMER_THRESHOLD:-3}
# Show this many fractional digits. Zero means round to seconds.
typeset -g COMMAND_EXECUTION_TIMER_PRECISION=${COMMAND_EXECUTION_TIMER_PRECISION:-0}
# Execution time color. Default: do not colorize.
typeset -g COMMAND_EXECUTION_TIMER_FOREGROUND=${COMMAND_EXECUTION_TIMER_FOREGROUND-}
# Duration format. Default <days>d <hours>h <minutes>m <seconds>s.
typeset -g COMMAND_EXECUTION_TIMER_FORMAT=${COMMAND_EXECUTION_TIMER_FORMAT:-'d h m s'}
# Prefix
typeset -g COMMAND_EXECUTION_TIMER_PREFIX=${COMMAND_EXECUTION_TIMER_PREFIX-'Took '}

command_execution_timer__format() {
  (( $+COMMAND_EXECUTION_TIMER_DURATION_SECONDS )) || return
  (( COMMAND_EXECUTION_TIMER_DURATION_SECONDS >= COMMAND_EXECUTION_TIMER_THRESHOLD )) || return

  if (( COMMAND_EXECUTION_TIMER_DURATION_SECONDS < 60 )); then
    if (( !COMMAND_EXECUTION_TIMER_PRECISION )); then
      local -i sec=$((COMMAND_EXECUTION_TIMER_DURATION_SECONDS + 0.5))
    else
      local -F $COMMAND_EXECUTION_TIMER_PRECISION sec=COMMAND_EXECUTION_TIMER_DURATION_SECONDS
    fi
    local text=${sec}s
  else
    local -i d=$((COMMAND_EXECUTION_TIMER_DURATION_SECONDS + 0.5))
    if [[ $COMMAND_EXECUTION_TIMER_FORMAT == "H:M:S" ]]; then
      local text=${(l.2..0.)$((d % 60))}
      if (( d >= 60 )); then
        text=${(l.2..0.)$((d / 60 % 60))}:$text
        if (( d >= 36000 )); then
          text=$((d / 3600)):$text
        elif (( d >= 3600 )); then
          text=0$((d / 3600)):$text
        fi
      fi
    else
      local text="$((d % 60))s"
      if (( d >= 60 )); then
        text="$((d / 60 % 60))m $text"
        if (( d >= 3600 )); then
          text="$((d / 3600 % 24))h $text"
          if (( d >= 86400 )); then
            text="$((d / 86400))d $text"
          fi
        fi
      fi
    fi
  fi

  text="$COMMAND_EXECUTION_TIMER_PREFIX$text"
  [[ -n $COMMAND_EXECUTION_TIMER_FOREGROUND ]] && text="%F{$COMMAND_EXECUTION_TIMER_FOREGROUND}$text%f"
  'print' -P $text
}

_command_execution_timer__preexec() {
  _command_execution_timer__start=EPOCHREALTIME
}

_command_execution_timer__precmd() {
	if (( _command_execution_timer__start )); then
    typeset -gF COMMAND_EXECUTION_TIMER_DURATION_SECONDS=$((EPOCHREALTIME - _command_execution_timer__start))
    typeset -g COMMAND_EXECUTION_DURATION=$(command_execution_timer__format)
  else
    unset COMMAND_EXECUTION_TIMER_DURATION_SECONDS
    unset COMMAND_EXECUTION_DURATION
  fi
  _command_execution_timer__start=0
}

append_command_execution_duration() {
  [[ -n $COMMAND_EXECUTION_DURATION ]] && 'print' $COMMAND_EXECUTION_DURATION
}

typeset -gF _command_execution_timer__start
'builtin' 'autoload' -Uz add-zsh-hook
add-zsh-hook preexec _command_execution_timer__preexec
add-zsh-hook precmd _command_execution_timer__precmd

