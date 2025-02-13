#!/usr/bin/env zsh

# Tests require ztr 2.x
# https://github.com/olets/zsh-test-runner

# Run the test suite by
# sourcing this file
#
# ```
# . <path to this file>
# ```

function main() {
  emulate -LR zsh

  {
    local cmd_dir=${0:A:h}
    local -a results
    local ztr_path=${ztr_path:-$ZTR_PATH}

  	if [[ -z $ztr_path ]]; then
  		printf "You must provide \$ztr_path\n"
  		return 1
  	fi

    . $cmd_dir/command-execution-timer.zsh
  	. $ztr_path

    local -A saved_config=(
      [COMMAND_EXECUTION_TIMER_THRESHOLD]=$COMMAND_EXECUTION_TIMER_THRESHOLD
      [COMMAND_EXECUTION_TIMER_PRECISION]=$COMMAND_EXECUTION_TIMER_PRECISION
      [COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT]=$COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT
      [COMMAND_EXECUTION_TIMER_FOREGROUND]=$COMMAND_EXECUTION_TIMER_FOREGROUND
      [COMMAND_EXECUTION_TIMER_FORMAT]=$COMMAND_EXECUTION_TIMER_FORMAT
      [COMMAND_EXECUTION_TIMER_PREFIX]=$COMMAND_EXECUTION_TIMER_PREFIX
    )

  	# defaults
  	function apply_default_config() {
      COMMAND_EXECUTION_TIMER_THRESHOLD=3
      COMMAND_EXECUTION_TIMER_PRECISION=0
      COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT=0
      COMMAND_EXECUTION_TIMER_FOREGROUND=
      COMMAND_EXECUTION_TIMER_FORMAT='d h m s'
      COMMAND_EXECUTION_TIMER_PREFIX=
    }

    function test1:format() {
      results+=( "$(command_execution_timer__format 999999)" )
      ztr queue '[[ $results[1] == "11d 13h 46m 39s" ]]' \
        'Can format duration in d h m s'

      COMMAND_EXECUTION_TIMER_FORMAT='H:M:S'
      results+=( "$(command_execution_timer__format 999999)" )
      command_execution_timer__format 999999 && ztr queue '[[ $results[2] == "277:46:39" ]]' \
        'Can format duration in H:M:S'
      COMMAND_EXECUTION_TIMER_FORMAT='d h m s'
    }

    function test2:precision() {
      # sleep's precision is such that this pattern only works to COMMAND_EXECUTION_TIMER_PRECISION=2

      _command_execution_timer__preexec
      'command' 'sleep' 0.1
      _command_execution_timer__precmd
      results+=( "$COMMAND_EXECUTION_DURATION" )
      ztr queue '[[ $results[3] == 0s ]]' \
        'Can round duration to configured precision (pt 1)'

      COMMAND_EXECUTION_TIMER_PRECISION=1
      _command_execution_timer__preexec
      'command' 'sleep' 0.06
      _command_execution_timer__precmd
      results+=( "$COMMAND_EXECUTION_DURATION" )
      ztr queue '[[ $results[4] == 0.1s ]]' \
        'Can round duration to configured precision (pt 2)'

      COMMAND_EXECUTION_TIMER_PRECISION=2
      _command_execution_timer__preexec
      'command' 'sleep' 0.006
      _command_execution_timer__precmd
      results+=( "$COMMAND_EXECUTION_DURATION" )
      ztr queue '[[ $results[5] == 0.01s ]]' \
        'Can round duration to configured precision (pt 3)'
    }

    function test3:hook() {
      COMMAND_EXECUTION_TIMER_PRECISION=0
      COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT=1
      COMMAND_EXECUTION_TIMER_THRESHOLD=0.00001
      _command_execution_timer__preexec
      'command' 'sleep' 0.1
      results+=( "$(_command_execution_timer__precmd)" )
      ztr queue '[[ $results[6] == 0s ]]' \
        'Can automatically print duration after command output'
    }

    # restore user config
    function restore_user_config() {
      COMMAND_EXECUTION_TIMER_THRESHOLD=$saved_config[COMMAND_EXECUTION_TIMER_THRESHOLD]
      COMMAND_EXECUTION_TIMER_PRECISION=$saved_config[COMMAND_EXECUTION_TIMER_PRECISION]
      COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT=$saved_config[COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT]
      COMMAND_EXECUTION_TIMER_FOREGROUND=$saved_config[COMMAND_EXECUTION_TIMER_FOREGROUND]
      COMMAND_EXECUTION_TIMER_FORMAT=$saved_config[COMMAND_EXECUTION_TIMER_FORMAT]
      COMMAND_EXECUTION_TIMER_PREFIX=$saved_config[COMMAND_EXECUTION_TIMER_PREFIX]
    }

    apply_default_config

    ztr clear-queue
    ztr clear-summary
    test1:format
    test2:precision
    test3:hook
    ztr run-queue

    restore_user_config
  } always {
    unfunction -m apply_default_config
    unfunction -m test1:format
    unfunction -m test2:precision
    unfunction -m test3:hook
    unfunction -m restore_user_config
  }
}

main $@
