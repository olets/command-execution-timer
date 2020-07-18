#!/usr/bin/env bash
# shellcheck disable=SC2155
# SC2155: Declare and assign separately to avoid masking return values.

# command-execution-timer
# https://github.com/olets/command-execution-timer
# Henry Bley-Vroman
# MIT License - 2020


# Show duration of the last command if takes at least this many seconds.
export COMMAND_EXECUTION_TIMER_THRESHOLD=${COMMAND_EXECUTION_TIMER_THRESHOLD:-3}
# Show this many fractional digits. Zero means round to seconds.
declare -i COMMAND_EXECUTION_TIMER_PRECISION=${COMMAND_EXECUTION_TIMER_PRECISION:-0}
export COMMAND_EXECUTION_TIMER_PRECISION
# Execution time color. Default: do not colorize.
export COMMAND_EXECUTION_TIMER_FOREGROUND=${COMMAND_EXECUTION_TIMER_FOREGROUND-}
# Duration format. Default <days>d <hours>h <minutes>m <seconds>s.
export COMMAND_EXECUTION_TIMER_FORMAT=${COMMAND_EXECUTION_TIMER_FORMAT:-'d h m s'}
# Prefix
export COMMAND_EXECUTION_TIMER_PREFIX=${COMMAND_EXECUTION_TIMER_PREFIX-}

# shellcheck disable=SC2120
# SC2120: function references arguments, but none are ever passed.
command_execution_timer__format() {
  local raw=${1:-${COMMAND_EXECUTION_TIMER_DURATION_SECONDS:-}}
  [[ -n $raw ]] || return

  # shellcheck disable=SC2071
  # SC2071: > is for string comparisons. Use -gt instead.
  # Need support float
  if [[ $raw < 60 ]]; then
    if ! (( COMMAND_EXECUTION_TIMER_PRECISION )); then
      # printf rounds 0.5 down!
      local raw_adjusted=$raw
      [[ $raw_adjusted < 1 ]] && raw_adjusted=$(echo "$raw + 0.01" | bc)

      local -i sec=$('printf' "%.f" "$raw_adjusted")
    else
      local sec=$('printf' "%.${COMMAND_EXECUTION_TIMER_PRECISION}f" "$raw")
    fi
    local text=${sec}s
  else
    # printf rounds 0.5 down!
    local raw_adjusted=$raw
    [[ $raw_adjusted < 1 ]] && raw_adjusted=$(echo "$raw + 0.01" | bc)

    local -i d=$('printf' "%.f" "$raw_adjusted")

    if [[ $COMMAND_EXECUTION_TIMER_FORMAT == "H:M:S" ]]; then
      local text=$('printf' "%02.f" $((d % 60)))
      if (( d >= 60 )); then
        text=$('printf' "%02.f" $((d / 60 % 60))):$text
        if (( d >= 3600 )); then
          text=$('printf' "%03.f" $((d / 3600))):$text
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

  'echo' "$text"
}

_command_execution_timer__preexec() {
  _command_execution_timer__start=${EPOCHREALTIME:-$(date +%s)}
}

_command_execution_timer__precmd() {
  # shellcheck disable=SC2071
  # Need support float
  # SC2071: > is for string comparisons. Use -gt instead.
	if [[ $_command_execution_timer__start > 0 ]]; then
    local end_time=${EPOCHREALTIME:-$(date +%s)}
    export COMMAND_EXECUTION_TIMER_DURATION_SECONDS=$(echo "$end_time - $_command_execution_timer__start" | bc)
    export COMMAND_EXECUTION_DURATION=$(command_execution_timer__format)
  else
    unset COMMAND_EXECUTION_TIMER_DURATION_SECONDS
    unset COMMAND_EXECUTION_DURATION
  fi
  _command_execution_timer__start=0
}

append_command_execution_duration() {
  ! [[ $COMMAND_EXECUTION_TIMER_DURATION_SECONDS < $COMMAND_EXECUTION_TIMER_THRESHOLD ]] || return
  [[ -n $COMMAND_EXECUTION_DURATION ]] || return

  local text=$COMMAND_EXECUTION_TIMER_PREFIX$COMMAND_EXECUTION_DURATION
  [[ -n $COMMAND_EXECUTION_TIMER_FOREGROUND ]] && text="\033[${COMMAND_EXECUTION_TIMER_FOREGROUND}m${text}\033[0m"
  'printf' "%b\n" "$text"
}

export _command_execution_timer__start

_command_execution_timer__init() {
  # `dirname $BASH_SOURCE` but symlink-friendly
  # https://stackoverflow.com/a/246128/1241736
  # CC BY-SA 4.0
  local dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  # /end CC BY-SA 4.0

  # shellcheck disable=SC1090
  # SC1090: Can't follow non-constant source. Use a directive to specify location.
  . "${dir}/bash-preexec/bash-preexec.sh"
  preexec_functions+=(_command_execution_timer__preexec)
  precmd_functions+=(_command_execution_timer__precmd)
}

_command_execution_timer__init
