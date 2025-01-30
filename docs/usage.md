# Usage

After executing a command, `COMMAND_EXECUTION_DURATION_SECONDS` will be set to the command duration in seconds and `COMMAND_EXECUTION_DURATION` will be set to the formatted duration.

```shell
# with the default configuration

% sleep 2
% echo $COMMAND_EXECUTION_TIMER_DURATION_SECONDS && echo $COMMAND_EXECUTION_DURATION
2.0377490520
2s
%
```

## Automatically append the duration

Command Execution Timer can automatically print a command duration after command output, when the duration is longer than `COMMAND_EXECUTION_TIMER_THRESHOLD` (read more at [Options](./options)).

To enable this feature, set `COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT` to a non-zero integer:

```shell
# .zshrc
COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT=1
# load command-execution-timer
```

```shell
# with the default configuration

% sleep 2 && echo done
done
% sleep 3 && echo done
done
3s
%
```

The hook's duration message is independent of and should not conflict with a customized prompt.

If you need more control, leave `COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT` set to zero (`0`, the default) and call the function `command_execution_timer__print_duration_after_command_output` in with `precmd` hook.

To enable the hook, add the following to your `.zshrc`:

```shell
# .zshrc
# ---snip---
autoload -Uz add-zsh-hook

my-command-execution-timer-precmd() {
  # …
  command_execution_timer__print_duration_after_command_output
  # …
}

add-zsh-hook precmd my-command-execution-timer-precmd
```

## Formatter

Use the function `command_execution_timer__format` to format an arbitrary number of seconds.

```shell
# with the default

% command_execution_timer__format 10.5
11s
```
