![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/logo.gif)

:rocket: The next generation of `cd` method with visual filter

## Description

`cd` command is one of the frequently used commands. Nevertheless, it is very inconvenient. `cd` interpret path (`/home/john/dir1`, `../../dir2`) only. `cd` does not accept the directory name (`dir3`). The new `cd` command I have to hack interpret this. Take the log every time that you want to move, and to complement the directory path based on that log.

:warning: [`cdinterface`](https://github.com/b4b4r07/cdinterface) is deprecated and was merged into this enhancd. 

***DEMO:***

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/demo.gif)

## Features

- It is possible to go to the directory where you have visited in the past.
- If a directory name is duplicated, it can be selected interactively with visual filter such as [peco](https://github.com/peco/peco).
- If the argument is not given, it is possible to select the directory where you want to go.
- Work on Bash, Zsh and Fish

## Requirements

- visual filter
	- [peco](https://github.com/peco/peco)
	- [fzf](https://github.com/junegunn/fzf)
	- [gof](https://github.com/mattn/gof)
	- [hf](https://github.com/hugows/hf)

## Usage

	$ cd <directroy>

## Installation

	$ git clone https://github.com/b4b4r07/cdinterface
	$ source cdinterface/cdinterface.sh

## License

[MIT](https://raw.githubusercontent.com/b4b4r07/dotfiles/master/doc/LICENSE-MIT.txt)

## Author

[BABAROT](http://tellme.tokyo) a.k.a. b4b4r07
