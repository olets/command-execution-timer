# Command Execution Timer ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/command-execution-timer)

A zsh plugin for timing, working with, and displaying the time an interactive shell command takes to execute.

- [Installation](#installation)
- [Usage](#usage)
  - [Hook](#hook)
  - [Formatter](#formatter)
- [Options](#options)
- [Acknowledgments](#acknowledgments)
- [Contributing](#contributing)
- [License](#license)

## Installation

### Installation with a plugin manager

Follow the standard installation procedure for your plugin manager. If you run into trouble open an issues. For Oh My Zsh use the `command-execution-timer.plugin.zsh` file, otherwise use the `command-execution-timer.zsh` file. With Zplugin/Zinit, do not use `wait`.

### Installation with a package manager

You can install Command Execution Timer with Homebrew. Run

```shell
brew install olets/tap/command-execution-timer
```

and follow the installation instructions.

### Manual installation

Clone this repo, and then `source` the `command-execution-timer.zsh` file in your `.zshrc`.

## Usage

After executing a command, `COMMAND_EXECUTION_DURATION_SECONDS` will be set to the command duration in seconds and `COMMAND_EXECUTION_DURATION` will be set to the formatted duration.

```shell
# with the default configuration

% sleep 2
% echo $COMMAND_EXECUTION_TIMER_DURATION_SECONDS && echo $COMMAND_EXECUTION_DURATION
2.0377490520
2s
%
```

### Hook


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

### Formatter

Use the function `command_execution_timer__format` to format an arbitrary number of seconds.

```shell
# with the default

% command_execution_timer__format 10.5
11s
```

## Options

Name | Type | Description | Default
---|---|---|---
`COMMAND_EXECUTION_TIMER_THRESHOLD` | Float | `append_command_execution_duration` is silent if the duration is less than this. | `3`
`COMMAND_EXECUTION_TIMER_PRECISION` | Integer* | Show this many decimal places in the formatted `$COMMAND_EXECUTION_DURATION` if the duration is under a minute. Zero means round to seconds. | `0`
`COMMAND_EXECUTION_TIMER_FOREGROUND` | Color value** | `append_command_execution_duration` text color | none, will use your terminal's foreground color
`COMMAND_EXECUTION_TIMER_FORMAT` | `"d h m s"` or `"H:M:S"` | Format. Ignored if `COMMAND_EXECUTION_TIMER_PRECISION` is non-zero. | `"d h m s"`
`COMMAND_EXECUTION_TIMER_PREFIX` | String*** | Prepended to `append_command_execution_duration` output | none

\* Maximum precision is limited by the shell. Zsh is precise to the tenth of a nanosecond, so the highest meaningful `COMMAND_EXECUTION_TIMER_PRECISION` value is 10.

\** Colors can be one of zsh's eight color names (`black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan` and `white`; see http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting), an integer 1-255 for an 8-bit color (see https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit), or a #-prefixed 3- or 6-character hexadecimal value for 24-bit color (e.g. `#fff`, `#34d5eb`). Support depends on your terminal emulator.

\*** `COMMAND_EXECUTION_TIMER_PREFIX` is printed with [prompt expansion](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html). Test with `print -P $COMMAND_EXECUTION_TIMER_PREFIX`.

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

## Acknowledgments

Command Execution Timer began as a fork of [Powerlevel10k](https://github.com/romkatv/powerlevel10k)'s command duration segment.

## Contributing

Thanks for your interest. With the caveat that the intention is to keep the core work in line with Powerlevel10k, contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/git-prompt-kit/issues) to see if your topic has been discussed before or if it is being worked on. Discussing in an Issue before opening a Pull Request means future contributors only have to search in one place.

## License

This project is released under the [MIT license](http://opensource.org/licenses/MIT).
For the full text of the license, see the [LICENSE](LICENSE) file.
