#!/usr/bin/env zsh

# Command Execution Timer
# https://github.com/olets/command-execution-timer
# MIT License
# Copyright (c) 2009-2014 Robby Russell and contributors (see https://github.com/robbyrussell/oh-my-zsh/contributors)
# Copyright (c) 2014-2017 Ben Hilburn <bhilburn@gmail.com>
# Copyright (c) 2019-2020 Roman Perepelitsa <roman.perepelitsa@gmail.com> and contributors (see https://github.com/romkatv/powerlevel10k/contributors)
# Copyright (c) 2020 Henry Bley-Vroman <olets@olets.dev>

# Show duration of the last command if takes at least this many seconds.
typeset -g COMMAND_EXECUTION_TIMER_THRESHOLD=${COMMAND_EXECUTION_TIMER_THRESHOLD:-3}
# Round durations under 1 second to this many decimal places. Zero means round to seconds.
typeset -gi COMMAND_EXECUTION_TIMER_PRECISION=${COMMAND_EXECUTION_TIMER_PRECISION:-0}
# Run command_execution_timer__print_duration_after_command_output in a precmd hook
typeset -gi COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT=${COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT:-0}
# Execution time color. Default: do not colorize.
typeset -g COMMAND_EXECUTION_TIMER_FOREGROUND=${COMMAND_EXECUTION_TIMER_FOREGROUND-}
# Duration format. Default <days>d <hours>h <minutes>m <seconds>s.
typeset -g COMMAND_EXECUTION_TIMER_FORMAT=${COMMAND_EXECUTION_TIMER_FORMAT:-'d h m s'}
# Prefix
typeset -g COMMAND_EXECUTION_TIMER_PREFIX=${COMMAND_EXECUTION_TIMER_PREFIX-}
# Version
typeset -gr COMMAND_EXECUTION_TIMER_VERSION=2.0.0

command_execution_timer__format() {
  emulate -LR zsh

  local -F raw=${1:-$COMMAND_EXECUTION_TIMER_DURATION_SECONDS}
  (( raw )) || return

  local text

  if (( raw < 60 )); then
    if (( !COMMAND_EXECUTION_TIMER_PRECISION )); then
      local -i sec=$((raw + 0.5))
    else
      local -F $COMMAND_EXECUTION_TIMER_PRECISION sec=raw
    fi
    text=${sec}s
  else
    local -i d=$((raw + 0.5))

    case $COMMAND_EXECUTION_TIMER_FORMAT in
      "H:M:S")
        text=${(l.2..0.)$((d % 60))}
        if (( d >= 60 )); then
          text=${(l.2..0.)$((d / 60 % 60))}:$text
          if (( d >= 36000 )); then
            text=$((d / 3600)):$text
          elif (( d >= 3600 )); then
            text=0$((d / 3600)):$text
          fi
        fi
        ;;
      'd h m s')
        text="$((d % 60))s"
        if (( d >= 60 )); then
          text="$((d / 60 % 60))m $text"
          if (( d >= 3600 )); then
            text="$((d / 3600 % 24))h $text"
            if (( d >= 86400 )); then
              text="$((d / 86400))d $text"
            fi
          fi
        fi
        ;;
      *)
        'builtin' 'print' "Command Execution Timer: Invalid \`COMMAND_EXECUTION_TIMER_FORMAT\`: $COMMAND_EXECUTION_TIMER_FORMAT" >&2
        return 1
        ;;
    esac
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

  if (( COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT )); then
    command_execution_timer__print_duration_after_command_output
  fi
}

append_command_execution_duration() {
  emulate -LR zsh

  command_execution_timer__print_duration_after_command_output
  'builtin' 'print' "Command Execution Timer: \`append_command_execution_duration\` is deprecated. Use the new name \`command_execution_timer__print_duration_after_command_output\` instead."
}

command_execution_timer__print_duration_after_command_output() {
  emulate -LR zsh

  (( COMMAND_EXECUTION_TIMER_DURATION_SECONDS >= COMMAND_EXECUTION_TIMER_THRESHOLD )) || return
  [[ -n $COMMAND_EXECUTION_DURATION ]] || return

  local text=$COMMAND_EXECUTION_TIMER_PREFIX$COMMAND_EXECUTION_DURATION
  [[ -n $COMMAND_EXECUTION_TIMER_FOREGROUND ]] && text="%F{$COMMAND_EXECUTION_TIMER_FOREGROUND}$text%f"
  'builtin' 'print' -P $text
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
