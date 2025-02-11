# Options

Name | Type | Description | Default
---|---|---|---
`COMMAND_EXECUTION_TIMER_THRESHOLD` | Float | `command_execution_timer__print_duration_after_command_output` is silent if the duration is less than this. | `3`
`COMMAND_EXECUTION_TIMER_PRECISION` | Integer[^1] | Round durations under 1 second to this many decimal places in the formatted `$COMMAND_EXECUTION_DURATION`. | `0`
`COMMAND_EXECUTION_TIMER_PRINT_DURATION_AFTER_COMMAND_OUTPUT` | Integer | If non-zero, print commands' durations after their output, if the duration is longer than `COMMAND_EXECUTION_TIMER_THRESHOLD` | `0`
`COMMAND_EXECUTION_TIMER_FOREGROUND` | Color value[^2] | `command_execution_timer__print_duration_after_command_output` text color | none, will use your terminal's foreground color
`COMMAND_EXECUTION_TIMER_FORMAT` | `"d h m s"` or `"H:M:S"` | Format `COMMAND_EXECUTION_DURATION` according to this scheme. Ignored if `COMMAND_EXECUTION_TIMER_PRECISION` is non-zero or `$COMMAND_EXECUTION_TIMER_DURATION_SECONDS` is less than 60 - in those cases, `"d h m s"` is always used. | `"d h m s"`
`COMMAND_EXECUTION_TIMER_PREFIX` | String[^3] | Prepended to `command_execution_timer__print_duration_after_command_output` output | none

For example, to print the duration of at-least-`COMMAND_EXECUTION_TIMER_THRESHOLD`-second commands in yellow with a blank line separating the command output and the duration,

```shell
# .zshrc
# ---snip---
COMMAND_EXECUTION_TIMER_FOREGROUND=yellow
COMMAND_EXECUTION_TIMER_PREFIX=$'\nTook '
```

Result

```shell
% sleep 3 && echo done
done

Took 3s # (this line would be yellow)
%
```

&nbsp;



[^1]: Maximum precision is limited by the shell. Zsh is precise to the tenth of a nanosecond, so the highest meaningful `COMMAND_EXECUTION_TIMER_PRECISION` value is 10.

[^2]: Colors can be one of zsh's eight color names (`black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan` and `white`; see http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting), an integer 1-255 for an 8-bit color (see https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit), or a #-prefixed 3- or 6-character hexadecimal value for 24-bit color (e.g. `#fff`, `#34d5eb`). Support depends on your terminal emulator.

[^3]: `COMMAND_EXECUTION_TIMER_PREFIX` is printed with [prompt expansion](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html). Test with `print -P $COMMAND_EXECUTION_TIMER_PREFIX`.
