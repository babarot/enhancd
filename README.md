![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/logo.gif)

The next generation of `cd` method with visual filter :sparkles:

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

	Choose any one from among these.

## :rocket: Usage

Under Zsh or Bourne shells such as sh and bash, you would use `enhancd.sh`. Under [fish shell](http://fishshell.com), `enhancd.fish`.

	$ sh="$(basename $SHELL)"
	$ source "$sh"/enhancd."$sh"
	$ #       ^- with bash, bash/enhancd.bash
	$ #          with zsh,  zsh/enhancd.zsh
	$ #          with fish, fish/enhancd.fish

Because enhancd functions must be executed in the context of the current shell, you should run something like above command.

The basic usage of the `cd` command that has been implemented by `enhancd` is the same as the normal builtin `cd` command.

	$ cd <directroy>

If no arguments are given, enhancd `cd` command will display a list of the directory you've visited once, encourage you to filter the directory that you want to move.

	$ cd
	  ...
	  /Users/b4b4r07/src/github.com/b4b4r07/enhancd/zsh
	  /Users/b4b4r07/src/github.com/b4b4r07/gotcha
	  /Users/b4b4r07/src/github.com/b4b4r07/blog/public
	  /Users/b4b4r07/src/github.com/b4b4r07/blog
	  /Users/b4b4r07/src/github.com/b4b4r07/link_test
	  /Users/b4b4r07/src/github.com/b4b4r07
	  /Users/b4b4r07/Dropbox/etc/dotfiles
	  /Users/b4b4r07/src/github.com/b4b4r07/enhancd
	> /Users/b4b4r07
	  247/247
	> _

The FILTER environment variable specifies the visual filter command such as [this](#requirements) you want to use. It is likely the only environment variable you'll need to set when starting enhancd.

	$ FILTER=peco; export FILTER

Since the `$FILTER` variable can be a list, enhancd will use `$FILTER` to mean the first element unless otherwise specified.

	$ FILTER=fzf:peco:hf:gof
	$ export FILTER

## :rocket: Installation

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/installation.png)

	$ curl -L git.io/enhancd | sh

Paste that at a Terminal prompt.

***NOTE:***

If you want to use older versions of enhancd ([dca011aa34](https://github.com/b4b4r07/enhancd/tree/dca011aa34957bf88ea6edbdf7c84b8a5b0157b5)), set BRANCH as old and run this command:

	$ curl -L git.io/enhancd | BRANCH=old sh

## :rocket: License

[MIT](https://raw.githubusercontent.com/b4b4r07/dotfiles/master/doc/LICENSE-MIT.txt) © BABAROT (a.k.a. b4b4r07)
