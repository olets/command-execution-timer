#!/usr/bin/env zsh

# command-execution-timer
# https://github.com/olets/command-execution-timer
# MIT License
# Copyright (c) 2009-2014 Robby Russell and contributors (see https://github.com/robbyrussell/oh-my-zsh/contributors)
# Copyright (c) 2014-2017 Ben Hilburn <bhilburn@gmail.com>
# Copyright (c) 2019 Roman Perepelitsa <roman.perepelitsa@gmail.com> and contributors (see https://github.com/romkatv/powerlevel10k/contributors)
# Copyright (c) 2020-present Henry Bley-Vroman <olets@olets.dev>

# Show duration of the last command if takes at least this many seconds.
typeset -g COMMAND_EXECUTION_TIMER_THRESHOLD=${COMMAND_EXECUTION_TIMER_THRESHOLD:-3}
# Show this many fractional digits. Zero means round to seconds.
typeset -gi COMMAND_EXECUTION_TIMER_PRECISION=${COMMAND_EXECUTION_TIMER_PRECISION:-0}
# Execution time color. Default: do not colorize.
typeset -g COMMAND_EXECUTION_TIMER_FOREGROUND=${COMMAND_EXECUTION_TIMER_FOREGROUND-}
# Duration format. Default <days>d <hours>h <minutes>m <seconds>s.
typeset -g COMMAND_EXECUTION_TIMER_FORMAT=${COMMAND_EXECUTION_TIMER_FORMAT:-'d h m s'}
# Prefix
typeset -g COMMAND_EXECUTION_TIMER_PREFIX=${COMMAND_EXECUTION_TIMER_PREFIX-}

command_execution_timer__format() {
  emulate -LR zsh

  local -F raw=${1:-$COMMAND_EXECUTION_TIMER_DURATION_SECONDS}
  (( raw )) || return

  if (( raw < 60 )); then
    if (( !COMMAND_EXECUTION_TIMER_PRECISION )); then
      local -i sec=$((raw + 0.5))
    else
      local -F $COMMAND_EXECUTION_TIMER_PRECISION sec=raw
    fi
    local text=${sec}s
  else
    local -i d=$((raw + 0.5))
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

  'echo' $text
}

_command_execution_timer__preexec() {
  emulate -LR zsh

  _command_execution_timer__start=EPOCHREALTIME
}

_command_execution_timer__precmd() {
  emulate -LR zsh

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
  emulate -LR zsh

  (( COMMAND_EXECUTION_TIMER_DURATION_SECONDS >= COMMAND_EXECUTION_TIMER_THRESHOLD )) || return
  [[ -n $COMMAND_EXECUTION_DURATION ]] || return

  local text=$COMMAND_EXECUTION_TIMER_PREFIX$COMMAND_EXECUTION_DURATION
  [[ -n $COMMAND_EXECUTION_TIMER_FOREGROUND ]] && text="%F{$COMMAND_EXECUTION_TIMER_FOREGROUND}$text%f"
  'print' -P $text
}

_command_execution_timer__init() {
  emulate -LR zsh

  'builtin' 'setopt' prompt_subst
  typeset -gF _command_execution_timer__start
  'builtin' 'autoload' -Uz add-zsh-hook
  add-zsh-hook preexec _command_execution_timer__preexec
  add-zsh-hook precmd _command_execution_timer__precmd
}

_command_execution_timer__init

unfunction -m _command_execution_timer__init
