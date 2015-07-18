![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/logo.gif)

:rocket: The next generation of `cd` method with visual filter

## :rocket: Description

`cd` command is one of the frequently used commands. Nevertheless, it is very inconvenient. `cd` interpret path (`/home/john/dir1`, `../../dir2`) only. `cd` does not accept the directory name (`dir3`). The new `cd` command I have to hack interpret this. Take the log every time that you want to move, and to complement the directory path based on that log.

:warning: [`cdinterface`](https://github.com/b4b4r07/cdinterface) is deprecated and was merged into this enhancd. 

***DEMO:***

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/demo.gif)

## :rocket: Features

- It is possible to go to the directory where you have visited in the past.
- If a directory name is duplicated, it can be selected interactively with visual filter such as [peco](https://github.com/peco/peco).
- If the argument is not given, it is possible to select the directory where you want to go.
- Work on Bash, Zsh and Fish :fish:

## :rocket: Requirements

- visual filter
	- [peco](https://github.com/peco/peco)
	- [fzf](https://github.com/junegunn/fzf)
	- [gof](https://github.com/mattn/gof)
	- [hf](https://github.com/hugows/hf)

## :rocket: Usage

	$ cd <directroy>

The FILTER environment variable specifies the visual filter command such as [this](#requirements) you want to use. It is likely the only environment variable you'll need to set when starting enhancd.

	$ FILTER=peco; export FILTER

Since the `$FILTER` variable can be a list, enhancd will use `$FILTER` to mean the first element unless otherwise specified.

	$ FILTER=fzf:peco:hf:gof
	$ export FILTER

## :rocket: Installation

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/installation.png)

	$ curl -L git.io/enhancd | sh

Paste that at a Terminal prompt.

## :rocket: License

[MIT](https://raw.githubusercontent.com/b4b4r07/dotfiles/master/doc/LICENSE-MIT.txt) © BABAROT (a.k.a. b4b4r07)
