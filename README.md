![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/logo.gif)

enhancd <sup>v2</sup> is ...

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
	- [percol](https://github.com/mooz/percol)
	- [peco](https://github.com/peco/peco)
	- [fzf](https://github.com/junegunn/fzf)
	- [gof](https://github.com/mattn/gof)
	- ...

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

The ENHANCD_FILTER environment variable specifies the visual filter command such as [this](#requirements) you want to use. It is likely the only environment variable you'll need to set when starting enhancd.

	$ ENHANCD_FILTER=peco; export ENHANCD_FILTER

Since the `$ENHANCD_FILTER` variable can be a list, enhancd will use `$ENHANCD_FILTER` to mean the first element unless otherwise specified.

	$ ENHANCD_FILTER=fzf:peco:gof
	$ export ENHANCD_FILTER

## :rocket: Installation

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/installation.png)

	$ curl -L git.io/enhancd | sh

Paste that at a Terminal prompt.

To specify installation location for enhancd:

	$ curl -L git.io/enhancd | PREFIX=~/somewhere sh

PREFIX defaults to "`~/.enhancd`".

### What's inside?

1. Grab enhancd.sh from github.com by using `git`, `curl` or `wget`
2. Add `source /path/to/enhancd.sh` to config file whose you use as the login shell

### Uninstallation

	$ rm -r ~/.enhancd

***NOTE:***

If you want to use older versions of enhancd (v1: [dca011aa34](https://github.com/b4b4r07/enhancd/tree/dca011aa34957bf88ea6edbdf7c84b8a5b0157b5)), set BRANCH as old and run this command:

	$ curl -L git.io/enhancd | BRANCH=v1 sh

## :rocket: References

The "visual filter" is what is called "Interactive Grep Tool" according to [percol](https://github.com/mooz/percol) that is a pioneer in interactive selection to the traditional pipe concept on UNIX. 

- **percol** :point_right: [percol adds flavor of interactive selection to the traditional pipe concept on UNIX](https://github.com/mooz/percol)
- **peco** :point_right: [Simplistic interactive filtering tool](https://github.com/peco/peco)
- **hf** :point_right: [hf is a command line utility to quickly find files and execute a command](https://github.com/hugows/hf)
- **fzf** :point_right: [fzf is a blazing fast command-line fuzzy finder written in Go](https://github.com/junegunn/fzf)
- **gof** :point_right: [gof - Go Fuzzy](https://github.com/mattn/gof)
- **selecta** :point_right: [Selecta is a fuzzy text selector for files and anything else you need to select](https://github.com/garybernhardt/selecta/)
- **pick** :point_right: [Pick is "just like Selecta, but faster"](https://robots.thoughtbot.com/announcing-pick)
- **icebick** :point_right: [icepick is a reimplementation of Selecta in Rust](https://github.com/felipesere/icepick)
- **sentaku** :point_right: [Utility to make sentaku (selection, 選択(sentaku)) window with shell command](https://github.com/rcmdnk/sentaku)

## :rocket: License

[MIT](https://raw.githubusercontent.com/b4b4r07/dotfiles/master/doc/LICENSE-MIT.txt) :copyright: BABAROT (a.k.a. b4b4r07)
