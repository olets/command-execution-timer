# Installation

## Installation with a plugin manager

You can install Command Execution Timer with a zsh plugin manager, including those built into frameworks such as Oh-My-Zsh (OMZ) and prezto. Each has their own way of doing things. Read your package manager's documentation or the [zsh plugin manager plugin installation procedures gist](https://gist.github.com/olets/06009589d7887617e061481e22cf5a4a).

After adding the plugin to the manager, it will be available in all new terminals. To use it in an already-open terminal, restart zsh in that terminal:

```shell
exec zsh
```

## Installation with a package manager

You can install Command Execution Timer with Homebrew. Run

```shell
brew install olets/tap/command-execution-timer
```

and follow the logged installation instructions.

## Manual installation

Clone this repo, and then `source` the `command-execution-timer.zsh` file in your `.zshrc`.

## Pinning a specific major version

The standard installation installs the latest version. If a new major version is released,
upgrading Command Execution Timer will automatically move you to it.

That may not be what you want.

You can specify which major version you want to use.

### Plugin manager

Use your manager to install Command Execution Timer from branch `v1` to pin v1.x, or branch `v2` to pin v2.x. Method varies by plugin manager.

### Homebrew

If you previously installed the default Homebrew formula, uninstall it

```shell:no-line-numbers
brew uninstall --force command-execution-timer
```

Then,

- to pin v2.x, run

    ```shell:no-line-numbers
    brew install olets/tap/command-execution-timer@2
    ```

- or, to pin v1.x, run

    ```shell:no-line-numbers
    brew install olets/tap/command-execution-timer@1
    ```

and follow the post-install instructions logged to the terminal.

### Manual

Either download the latest v1.x or v2.x's archive from <https://github.com/olets/command-execution-timer/releases>, or clone the relevant major version branch:
- to pin v2.x, clone the `v2` branch:
    ```shell:no-line-numbers
    git clone https://github.com/olets/command-execution-timer --single-branch --branch v2 --depth 1
    ```
    
- to pin v1.x, clone the `v1` branch:
    ```shell:no-line-numbers
    git clone https://github.com/olets/command-execution-timer --single-branch --branch v1 --depth 1
    ```
