# [v2.0.0](https://github.com/olets/command-execution-timer/compare/v1.0.1...v2.0.0) (2024-10-07)

## Migrating

This major version ships breaking changes. Notably:

- The hook function is now `command_execution_timer__print_duration_after_command_output`. Previously it was `append_command_execution_duration`. See Docs > Usage.

- The default `COMMAND_EXECUTION_TIMER_PREFIX` is now nothing. Previously it was `"Took "`. See Docs > Options.

## Staying on v1.x

See Docs > Installation > Legacy versions.

## Changes

### Bug Fixes

* **prompt substitution:** turn on ([8995ab9](https://github.com/olets/command-execution-timer/commit/8995ab90a3d32bfe2b0f5c20548d980a64697a3d))

### Features

* **command_execution_timer__format:** error on invalid COMMAND_EXECUTION_TIMER_FORMAT ([e36ebbd](https://github.com/olets/command-execution-timer/commit/e36ebbd3152bb10e19d05cdda32dce37a51de6ab))
* **command_execution_timer__print_duration_after_command_output:** replaces append_command_execution_duration ([d6f0b7a](https://github.com/olets/command-execution-timer/commit/d6f0b7a49d12e0042ca61a7c070d25a7f3325be0))
* **COMMAND_EXECUTION_TIMER_PREFIX:** no default ([044474b](https://github.com/olets/command-execution-timer/commit/044474b7778a4fb2c571ccc2d2dcae8ddbea6da0))
* **formatter:** support passing in a value ([a2a0a49](https://github.com/olets/command-execution-timer/commit/a2a0a4940a2cedd60dee87dbc86ef84fad9c3e47))
* **formatting, hook:** prefix+foreground in hook, not formatted str ([0191220](https://github.com/olets/command-execution-timer/commit/01912207ba9a8134b994aee20aeff616c72a0861))
* **homebrew:** bump formulae on release, with github actions ([2e37d10](https://github.com/olets/command-execution-timer/commit/2e37d10c0724998f368b40af204e02d608612ef3))
* **threshold:** only applies to hook ([ba2550b](https://github.com/olets/command-execution-timer/commit/ba2550bdb7968245d3f92055f2fdec5a0ff1b152))
* **version:** add variable ([48b1a91](https://github.com/olets/command-execution-timer/commit/48b1a91c2d7afe531d9b56981874068b2fe62e06))



# [v1.0.1](https://github.com/olets/command-execution-timer/compare/v1.0.0...v1.0.1) (2020-07-11)

### Bug fixes

* **plugin:** correct path ([7da2bb5](https://github.com/olets/command-execution-timer/commit/7da2bb5eb9ba20fce548a7e3c27c372020a94bce))


# v1.0.0 (2020-07-11)

### Features

- zsh support
- available on Homebrew
- `COMMAND_EXECUTION_DURATION` variable
- options `COMMAND_EXECUTION_TIMER_THRESHOLD`, `COMMAND_EXECUTION_TIMER_PRECISION`, `COMMAND_EXECUTION_TIMER_FOREGROUND`, `COMMAND_EXECUTION_TIMER_FORMAT`, `COMMAND_EXECUTION_TIMER_PREFIX`
- `append_command_execution_duration` hook
