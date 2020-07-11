# Command Execution Timer ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/command-execution-timer)

A zsh plugin for timing, working with, and displaying the time an interactive shell command takes to execute.

## Installation

### Manual installation

Clone this repo, and then `source` the `command_execution_timer.zsh` file in your `.zshrc`.

### Installation with a plugin manager

Follow the standard installation procedure for your plugin manager. If you run into trouble open an issues. For Oh My Zsh use the `command_execution_timer.plugin.zsh` file, otherwise use the `command_execution_time.zsh` file. With Zplugin/Zinit, do not use `wait`.

## Usage

After executing a command, `COMMAND_EXECUTION_DURATION` will be set to the formatted duration. If the command executed in less time than the configured threshold, `COMMAND_EXECUTION_DURATION` is not set.

```shell
# with the default configuration

% sleep 2
% echo $COMMAND_EXECUTION_DURATION

% sleep 3
% echo $COMMAND_EXECUTION_DURATION
3s
% echo $COMMAND_EXECUTION_DURATION

% [[ -n $COMMAND_EXECUTION_DURATION ]] && echo true
%
```

Command Execution Timer ships with a hook for automatically appending the command duration. To enable it, add the following to your `.zshrc`:

```shell
# .zshrc
# ---snip---
autoload -Uz add-zsh-hook
add-zsh-hook precmd append_command_execution_duration
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

## Options

Name | Description | Default
---|---|---
`COMMAND_EXECUTION_TIMER_THRESHOLD` | Show duration of the last command if takes at least this many seconds. | `3`
`COMMAND_EXECUTION_TIMER_PRECISION` | Show this many fractional digits. Zero means round to seconds. | `0`
`COMMAND_EXECUTION_TIMER_FOREGROUND` | Color value* |
`COMMAND_EXECUTION_TIMER_FORMAT` | Supported values: `"d h m s"`, `"H:M:S"` | `"d h m s"`
`COMMAND_EXECUTION_TIMER_PREFIX` | Prompt string** prepended to the formatted duration |

\* Colors can be one of zsh's eight color names (`black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan` and `white`; see http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting), an integer 1-255 for an 8-bit color (see https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit), or a #-prefixed 3- or 6-character hexadecimal value for 24-bit color (e.g. `#fff`, `#34d5eb`). Support depends on your terminal emulator.

\** Will be evaluted as in `print -P $COMMAND_EXECUTION_TIMER_PREFIX`.

For example,

```shell
# .zshrc
# ---snip---
COMMAND_EXECUTION_TIMER_PREFIX=$'\nTook '
COMMAND_EXECUTION_TIMER_FOREGROUND=yellow
autoload -Uz add-zsh-hook
add-zsh-hook precmd append_command_execution_duration
```

```shell
% sleep 3 && echo done
done

Took 3s
% # the "Took 3s" would be yellow
```

## Acknowledgments

Forked from [Powerlevel10k](https://github.com/romkatv/powerlevel10k).

## Contributing

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/git-prompt-kit/issues) to see if your topic has been discussed before or if it is being worked on. Discussing in an Issue before opening a Pull Request means future contributors only have to search in one place.

## License

This project is released under the [MIT license](http://opensource.org/licenses/MIT).
For the full text of the license, see the [LICENSE](LICENSE) file.
