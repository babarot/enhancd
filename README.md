[version-badge]: https://img.shields.io/badge/latest-v2.2.2-e64d56.svg?style=flat-square
[version-link]: https://github.com/b4b4r07/enhancd/releases
[travis-badge]: https://img.shields.io/travis/b4b4r07/enhancd/master.svg?style=flat-square
[travis-link]: https://travis-ci.org/b4b4r07/enhancd
[awk-link]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html
[license-link]: http://b4b4r07.mit-license.org

[![][travis-badge]][travis-link] [![][version-badge]][version-link]

<a href="top"></a>

<p align="center">
<img src="https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/logo.gif">
</p>

<p align="center">
<b><a href="#memo-description">Description</a></b>
|
<b><a href="#trollface-features">Features</a></b>
|
<b><a href="#heartbeat-requirements">Requirements</a></b>
|
<b><a href="#mag-usage">Usage</a></b>
<br>
<b><a href="#package-installation">Installation</a></b>
|
<b><a href="#wrench-configuration">Configuration</a></b>
|
<b><a href="#books-references">References</a></b>
|
<b><a href="#ticket-license">License</a></b>
</p>

<br>

:rocket: enhancd <sup>v2</sup> is ...

> A next-generation `cd` command with an interactive filter :sparkles:

## :memo: Description

`cd` command is one of the frequently used commands.

Nevertheless, it is not so easy to handle unfortunately. A directory path given as an argument to `cd` command must be a valid path that exists and is able to resolve. In other words, you cannot pass a partial path such as "dir" (you are in `/home/lisa`, dir is `/home/lisa/work/dir`) to `cd` command.

The new cd command called "enhancd" enhanced the flexibility and usability for a user. enhancd will memorize all directories visited by a user and use it for the pathname resolution. If the log of enhancd have more than one directory path with the same name, enhancd will pass the candidate directories list to the filter within the ENHANCD_FILTER environment variable in order to narrow it down to one directory.

Thanks to this mechanism, the user can intuitively and easily change the directory you want to go.

***DEMO:***

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/demo.gif)

## :trollface: Features

- Go to the visited directory in the past
- Easy to filter, using your favorite filter
- Work on Bash and Zsh (Full compatible)
- Go back to a specific parent directory like [zsh-bd](https://github.com/Tarrasch/zsh-bd)
- Fuzzy search in a similar name directory
- Support standard input (`echo $HOME | cd` is acceptable)
- Custom options (user-defined option is acceptable)

### Fuzzy search

You can fuzzy-search a directory name you want to run `cd`. For example, a word "text" is expand to "test" and "txt".

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/fuzzy.gif)

## :heartbeat: Requirements

- An interactive filter
	- [**fzy**](https://github.com/jhawthorn/fzy) *=> recommend*
	- [**percol**](https://github.com/mooz/percol)
	- [**peco**](https://github.com/peco/peco)
	- [**fzf**](https://github.com/junegunn/fzf)
	- ...

	Choose any one from among these.

## :mag: Usage

Under Zsh or Bourne shells such as sh and bash, you just source `init.sh` into your shell:

```console
$ source ./init.sh
```

Because enhancd functions must be executed in the context of the current shell, you should run something like above command.

The basic usage of the `cd` command that has been implemented by `enhancd` is the same as the normal builtin `cd` command.

```console
$ cd [-|..] <directory>
```

If no arguments are given, enhancd `cd` command will display a list of the directory you've visited once, encourage you to filter the directory that you want to move.

```console
$ cd
  ...
  /home/lisa/src/github.com/b4b4r07/enhancd/zsh
  /home/lisa/src/github.com/b4b4r07/gotcha
  /home/lisa/src/github.com/b4b4r07/blog/public
  /home/lisa/src/github.com/b4b4r07/blog
  /home/lisa/src/github.com/b4b4r07/link_test
  /home/lisa/src/github.com/b4b4r07
  /home/lisa/Dropbox/etc/dotfiles
  /home/lisa/src/github.com/b4b4r07/enhancd
> /home/lisa
  247/247
> _
```

The ENHANCD_FILTER variable is specified as a list of one or more visual filter command such as [this](#requirements) separated by colon (`:`) characters.

It is likely the only environment variable you'll need to set when starting enhancd.

```console
$ ENHANCD_FILTER=peco; export ENHANCD_FILTER
```

Since the `$ENHANCD_FILTER` variable can be a list, enhancd will use `$ENHANCD_FILTER` to mean the first element unless otherwise specified.

```console
$ ENHANCD_FILTER=fzy:fzf:peco
$ export ENHANCD_FILTER
```

Also, 

<details>
<summary><strong>Hyphen (`-`)</strong></summary>

When enhancd takes a hyphen (`-`) string as an argument, it searchs from the last 10 directory items in the log. With it, you can search easily the directory you used last.

```console
$ cd -
  /home/lisa/Dropbox/etc/dotfiles
  /home/lisa/Dropbox
  /home/lisa/src/github.com
  /home/lisa/src/github.com/b4b4r07/cli
  /home
  /home/lisa/src
  /home/lisa/src/github.com/b4b4r07/enhancd
  /home/lisa/src/github.com/b4b4r07/gotcha
  /home/lisa/src/github.com/b4b4r07
> /home/lisa/src/github.com/b4b4r07/portfolio
  10/10
> _	
```

Then, since the current directory will be delete from the candidate, you just press Enter key to return to the previous directory after type `cd -` (`$PWD` is `/home/lisa`, `$OLDPWD` is `/home/lisa/src/github.com/b4b4r07/portfolio`).

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/cd_hyphen.gif)

</details>

<details>
<summary><strong>Double-dot (`..`)</strong></summary>

From the beginning, `..` means the directory's parent directory, that is, the directory that contains it. When enhancd takes a double-dot (`..`) string as an argument, it behaves like a [zsh-bd](https://github.com/Tarrasch/zsh-bd) plugin. In short, you can jump back to a specific directory, without doing `cd ../../..`.

For example, when you are in `/home/lisa/src/github.com/b4b4r07/enhancd`, type `cd ..` in your terminal:

```console
$ cd ..
  /
  home
  lisa
  src
  github.com
> b4b4r07
  6/6
> _
```

When moving to the parent directory, the current directory is removed from the candidate.

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/bd.gif)

</details>

### Options

:new: v2.2.0~

You can make the option that you thought for your enhancd from 2.2.0 or above.

```console
$ cd --help
usage: cd [OPTIONS] [dir]

OPTIONS:
  -h, --help       Show help message
  -V, --version    Show version information
  -G, --ghq        Filter ghq list

```

Those options are defined at [config.ltsv](https://github.com/b4b4r07/enhancd/blob/master/src/custom/config.ltsv). As it is written in this json, the user have to make a directory list file or script that generate the list like [this script](https://github.com/b4b4r07/enhancd/blob/master/src/custom/sources/ghq.sh).　Of cource, you can disable those options if you do not like it.

## :package: Installation

Give me a trial!

- Install with [zplug](https://github.com/b4b4r07/zplug):

	enhancd can be installed by adding following to your `.zshrc` file in the same function you're doing your other `zplug load` calls in.

	```console
	$ zplug "b4b4r07/enhancd", use:init.sh
	```

- Install with `git clone`:

	```console
	$ git clone https://github.com/b4b4r07/enhancd
	$ source /path/to/enhancd/init.sh
	```

## :wrench: Configurations

<details>
<summary><strong><code>ENHANCD_DIR</code></strong></summary>

The ENHANCD_DIR variable is a base directory path. It defaults to `~/.enhancd`.

</details>

<details>
<summary><strong><code>ENHANCD_FILTER</code></strong></summary>

1. What is ENHANCD_FILTER?

	The ENHANCD_FILTER is an environment variable. It looks exactly like the PATH variable containing with many different filters such as [peco](https://github.com/peco/peco) concatenated using '`:`'.

2. How to set the ENHANCD_FILTER variable?

	Setting the ENHANCD_FILTER variable is exactly like setting the PATH variable. For example:

	```console
	$ export ENHANCD_FILTER="/usr/local/bin/peco:fzf:non-existing-filter"
	```

	This above command will hold good till the session is closed. In order to make this change permanent, we need to put this command in the appropriate profile file. The ENHANCD_FILTER command in this example is set with 3 components: `/usr/local/bin/peco` followed by `fzf` and the `not-existing-filter`.

	enhancd narrows the ENHANCD_FILTER variable down to one. However, the command does not exist can not be the candidate.
	
	Let us try to test this ENHANCD_FILTER variable.

	```console
	$ cd
	```

	If cd command does not return error, the settings of ENHANCD_FILTER is success.
	
3. How to find the value of the ENHANCD_FILTER variable?

	```console
	$ echo $ENHANCD_FILTER
	/usr/local/bin/peco:fzf:non-existing-filter
	```

</details>

<details>
<summary><strong><code>ENHANCD_COMMAND</code></strong></summary>

The ENHANCD_COMMAND environment variable is to change the command name of enhancd `cd`. It defaults to `cd`.

When the command name is changed, you should set new command name to ENHANCD_COMMAND, export it and restart your shell (reload `init.sh`).

```console
$ echo $ENHANCD_COMMAND
cd
$ export ENHANCD_COMMAND=ecd
$ source /path/to/init.sh
```

The ENHANCD_COMMAND may only hold one command name. Thus, in the previous example, it is true that enhancd `cd` command name is `ecd`, but it is not `cd` (`cd` is turned into original `builtin cd`).

Besides putting a setting such as this one in your `~/.bash_profile` or `.zshenv` would be a good idea:

```bash
ENHANCD_COMMAND=ecd; export ENHANCD_COMMAND
```

</details>

<details>
<summary><strong><code>ENHANCD_DOT_SHOW_FULLPATH</code></strong></summary>

The ENHANCD_DOT_SHOW_FULLPATH environment variable is to set whether to show the full path or not when executing Double-dot. It defaults to `0`.

```console
$ export ENHANCD_DOT_SHOW_FULLPATH=1
$ cd ..
  /
  /home
  /home/lisa
  /home/lisa/src
  /home/lisa/src/github.com
> /home/lisa/src/github.com/b4b4r07
  6/6
> _
```

</details>

<details>
<summary><strong><code>ENHANCD_DISABLE_DOT</code></strong></summary>

If you don't want to use the interactive filter, when specifing a double dot (`..`), you should set not zero value to `$ENHANCD_DISABLE_DOT`. Defaults to 0.

</details>

<details>
<summary><strong><code>ENHANCD_DISABLE_HYPHEN</code></strong></summary>

This option is similar to `ENHANCD_DISABLE_DOT`. Defaults to 0.

</details>

<details>
<summary><strong><code>ENHANCD_DISABLE_HOME</code></strong></summary>

If you don't want to use the interactive filter when you call `cd` without an argument, you can set any value but `0` for `$ENHANCD_DISABLE_HOME`. Defaults to `0`.

</details>

<details>
<summary><strong><code>ENHANCD_DOT_ARG</code></strong></summary>

You can customize the double-dot (`..`) argument for enhancd by this environment variable.  
Default is `..`.

If you set this variable any but `..`, it gives you the _double-dot_ behavior with that argument; i.e. upward search of directory hierarchy.
Then `cd ..` changes current directory to parent directory without interactive filter.

In other words, you can keep original `cd ..` behavior by this option.

</details>

<details>
<summary><strong><code>ENHANCD_HYPHEN_ARG</code></strong></summary>

You can customize the hyphen (`-`) argument for enhancd by this environment variable.  
Default is `-`.

If you set this variable any but `-`, it gives you the _hyphen_ behavior with that argument; i.e. backward search of directory-change history.
Then `cd -` changes current directory to `$OLDPWD` without interactive filter.

In other words, you can keep original `cd -` behavior by this option.

</details>

<details>
<summary><strong><code>ENHANCD_HOOK_AFTER_CD</code></strong></summary>

Default is empty. You can run any commands after changing directory with enhancd (e.g. `ls`: like `cd && ls`).

</details>

<details>
<summary><strong><code>ENHANCD_USE_FUZZY_MATCH</code></strong></summary>

Default is 1 (enable). See [#33](https://github.com/b4b4r07/enhancd/issues/33).

</details>

## :books: References

The "visual filter" (interactive filter) is what is called "Interactive Grep Tool" according to [percol](https://github.com/mooz/percol) that is a pioneer in interactive selection to the traditional pipe concept on UNIX.

- **percol** :point_right: [percol adds flavor of interactive selection to the traditional pipe concept on UNIX](https://github.com/mooz/percol)
- **peco** :point_right: [Simplistic interactive filtering tool](https://github.com/peco/peco)
- **fzf** :point_right: [:cherry_blossom: fzf is a blazing fast command-line fuzzy finder written in Go](https://github.com/junegunn/fzf)
- **fzy** :point_right: [:mag: A better fuzzy finder](https://github.com/jhawthorn/fzy)
- **gof** :point_right: [gof - Go Fuzzy](https://github.com/mattn/gof)
- **selecta** :point_right: [Selecta is a fuzzy text selector for files and anything else you need to select](https://github.com/garybernhardt/selecta/)
- **pick** :point_right: [Pick is "just like Selecta, but faster"](https://robots.thoughtbot.com/announcing-pick)
- **icepick** :point_right: [icepick is a reimplementation of Selecta in Rust](https://github.com/felipesere/icepick)
- **sentaku** :point_right: [Utility to make sentaku (selection, 選択(sentaku)) window with shell command](https://github.com/rcmdnk/sentaku)
- **hf** :point_right: [hf is a command line utility to quickly find files and execute a command](https://github.com/hugows/hf)

## :ticket: License

[MIT][license-link] :copyright: b4b4r07
