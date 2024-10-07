
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

## Hook


Command Execution Timer ships with a hook for automatically appending the command duration. To enable it, add the following to your `.zshrc`:

```shell
# .zshrc
# ---snip---
autoload -Uz add-zsh-hook
add-zsh-hook precmd command_execution_timer__print_duration_after_command_output
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

The hook's duration message is independent of and will not conflict with a customized prompt.

## Formatter

Use the function `command_execution_timer__format` to format an arbitrary number of seconds.

```shell
# with the default

% command_execution_timer__format 10.5
11s
```
