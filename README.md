[version-badge]: https://img.shields.io/github/tag/b4b4r07/enhancd.svg
[version-link]: https://github.com/b4b4r07/enhancd/releases
[awk-link]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html
[license-link]: https://b4b4r07.mit-license.org

<div align="center">

# enhan/cd

<!-- [![][version-badge]][version-link] -->

enhancd is ***an enhanced cd command*** integrated with an UNIX interactive filter.

Typing "cd" in your console, enhancd provides you a new directory moving. Basic concept is almost similar with the original cd command but totally differenent in that you can choose where to go from the list of visited directories in the past. You can select the directory you want to move using your favorite interactive filter (e.g. fzf). It just extends original cd but brings you completely new experience.

[Getting Started](#getting-started) •
[Installation](#installation) •
[Configuration](#configuration) •
[References](#references)

[![][version-badge]][version-link] ![](https://img.shields.io/github/commit-activity/m/b4b4r07/enhancd)
===

</div>

`cd` command is one of the frequently used commands.

Nevertheless, it is not so easy to handle unfortunately. A directory path given as an argument to `cd` command must be a valid path that exists and is able to resolve. In other words, you cannot pass a partial path such as "dir" (you are in `/home/babarot`, dir is `/home/babarot/work/dir`) to `cd` command.

The new cd command called "enhancd" enhanced the flexibility and usability for a user. enhancd will memorize all directories visited by a user and use it for the pathname resolution. If the log of enhancd have more than one directory path with the same name, enhancd will pass the candidate directories list to the filter within the ENHANCD_FILTER environment variable in order to narrow it down to one directory.

Thanks to this mechanism, the user can intuitively and easily change the directory you want to go.

- Go to the visited directory in the past
- Easy to filter, using your favorite filter
- Work on Bash, Zsh and fish (cross-shell compatibility)
- Go back to a specific parent directory like [zsh-bd](https://github.com/Tarrasch/zsh-bd)
- Inside a git repo, the first list element is the git root directory
- Fuzzy search in a similar name directory
- Support standard input (`echo $HOME | cd` is acceptable)
- Custom options (user-defined option is acceptable)

![demo](https://user-images.githubusercontent.com/4442708/227760682-3db43c23-c31e-454f-9e9c-003c3eb7a693.gif)

## Getting Started

### Usage

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
  /home/babarot/src/github.com/b4b4r07/enhancd/zsh
  /home/babarot/src/github.com/b4b4r07/gotcha
  /home/babarot/src/github.com/b4b4r07/blog/public
  /home/babarot/src/github.com/b4b4r07/blog
  /home/babarot/src/github.com/b4b4r07/link_test
  /home/babarot/src/github.com/b4b4r07
  /home/babarot/Dropbox/etc/dotfiles
  /home/babarot/src/github.com/b4b4r07/enhancd
> /home/babarot
  247/247
> _
```

The ENHANCD_FILTER variable is specified as a list of one or more visual filter command such as [this](#heartbeat-requirements) separated by colon (`:`) characters.

It is likely the only environment variable you'll need to set when starting enhancd.

```console
$ export ENHANCD_FILTER=peco
```

Since the `$ENHANCD_FILTER` variable can be a list, enhancd will use `$ENHANCD_FILTER` to mean the first element unless otherwise specified.

```console
$ export ENHANCD_FILTER=fzy:fzf:peco
```

Also,

<details>
<summary><strong>Hyphen (<code>-</code>)</strong></summary>

When enhancd takes a hyphen (`-`) string as an argument, it searchs from the last 10 directory items in the log. With it, you can search easily the directory you used last.

```console
$ cd -
  /home/babarot/Dropbox/etc/dotfiles
  /home/babarot/Dropbox
  /home/babarot/src/github.com
  /home/babarot/src/github.com/b4b4r07/cli
  /home
  /home/babarot/src
  /home/babarot/src/github.com/b4b4r07/enhancd
  /home/babarot/src/github.com/b4b4r07/gotcha
  /home/babarot/src/github.com/b4b4r07
> /home/babarot/src/github.com/b4b4r07/portfolio
  10/10
> _
```

Then, since the current directory will be delete from the candidate, you just press Enter key to return to the previous directory after type `cd -` (`$PWD` is `/home/babarot`, `$OLDPWD` is `/home/babarot/src/github.com/b4b4r07/portfolio`).

![](https://raw.githubusercontent.com/b4b4r07/screenshots/master/enhancd/cd_hyphen.gif)

</details>

<details>
<summary><strong>Double-dot (<code>..</code>)</strong></summary>

From the beginning, `..` means the directory's parent directory, that is, the directory that contains it. When enhancd takes a double-dot (`..`) string as an argument, it behaves like a [zsh-bd](https://github.com/Tarrasch/zsh-bd) plugin. In short, you can jump back to a specific directory, without doing `cd ../../..`.

For example, when you are in `/home/babarot/src/github.com/b4b4r07/enhancd`, type `cd ..` in your terminal:

```console
$ cd ..
  /
  home
  babarot
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

```console
$ cd --help
usage: cd [OPTIONS] [dir]

OPTIONS:
  -h, --help       Show help message
```

Those options are defined at [config.ltsv](https://github.com/b4b4r07/enhancd/blob/master/config.ltsv). You can add your custom option by writting the config file with [LTSV format](http://ltsv.org/).

The default config is below:

```tsv
short:-h	long:--help	desc:Show help message	func:	condition:
```

For example, let's say you want to use [`ghq list`](https://github.com/x-motemen/ghq) as custom source for cd command, all you have to do is adding this one line to `config.ltsv`:

```tsv
short:-G	long:--ghq	desc:Show ghq path	func:ghq list --full-path	condition:which ghq
```

enhancd will load these `config.ltsv` from the top of the list:

- `${ENHANCD_ROOT}/config.ltsv`
- `${ENHANCD_DIR}/config.ltsv`
- `${HOME}/.config/enhancd/config.ltsv`

### Enhancd complete (fish)

On fish shell, you can use <kbd>alt+f</kbd> to trigger `enhancd` when typing a command, the selected item will be appended to the commandline

## Installation

<table>

<tr><td> <strong>Case</strong> </td><td> <strong>Way</strong> </td></tr>

<tr>
<td>

Git (for Trial)

</td>
<td>

```console
$ git clone https://github.com/b4b4r07/enhancd
$ source enhancd/init.sh
```

</td>
</tr>

<tr>
<td>

All (bash/zsh/fish)

</td>

<td>

Using CLI package manager "[afx](https://github.com/b4b4r07/afx)". YAML for the installation is here:

```yaml
github:
  - name: b4b4r07/enhancd
    description: A next-generation cd command with your interactive filter
    owner: b4b4r07
    repo: enhancd
    plugin:
      env:
        ENHANCD_FILTER: fzf --height 25% --reverse --ansi:fzy
      sources:
        - init.sh
```

then,

```console
$ afx install
```

</td>
</tr>

<tr>
<td>

Fig

</td>
<td>

Install `enhancd` with [Fig](https://fig.io) on zsh, bash, or fish with just one click.

<a href="https://fig.io/plugins/other/enhancd" target="_blank"><img src="https://fig.io/badges/install-with-fig.svg" /></a>

</td>
</tr>

<tr>
<td>

Bash

</td>
<td>

Almost same as Git case. But plus one more actions.

```console
# add enhancd to your bash profile (or sourced file of choice)
$ echo "source ~/enhancd/init.sh"  >> ~/.bash_profile
```

```console
# reload your bash profile
$ source ~/.bash_profile
```

</td>
</tr>
<tr>
<td>

Zsh

</td>
<td>

Also if you use zsh as your shell, you can install this via [zplug](https://github.com/zplug/zplug) which is powerfull plugin mananger for zsh:

```bash
zplug "b4b4r07/enhancd", use:init.sh
```

You can also use it with [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh):

```console
$ git clone https://github.com/b4b4r07/enhancd.git $ZSH_CUSTOM/plugins/enhancd
```

and then load as a plugin in your `.zshrc`:

```bash
plugins+=(enhancd)
```

</td>
</tr>
<tr>
<td>

Fish

</td>
<td>

System Requirements:

- [Fish](https://fishshell.com/) ≥ 3.0

Install with [Fisher](https://github.com/jorgebucaran/fisher):

```console
$ fisher install b4b4r07/enhancd
```


</td>
</tr>

</table>

## Configuration

<table>

<tr><td> <strong>Variable</strong> </td><td> <strong>Description</strong> </td></tr>

<tr><td>

`ENHANCD_DIR`

</td><td>

The ENHANCD_DIR variable is a base directory path.

It defaults to `~/.enhancd`.

</td></tr>

<tr><td>

`ENHANCD_FILTER`

</td><td>

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

</td></tr>

<tr><td>

`ENHANCD_COMMAND`

</td><td>

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

</td></tr>
<tr><td>

`ENHANCD_DISABLE_DOT`

</td><td>

If you don't want to use the interactive filter, when specifing a double dot (`..`), you should set not zero value to `$ENHANCD_DISABLE_DOT`. Defaults to 0.

</td></tr>

<tr><td>

`ENHANCD_DISABLE_HYPHEN`

</td><td>

This option is similar to `ENHANCD_DISABLE_DOT`. Defaults to 0.

</td></tr>
<tr><td>

`ENHANCD_DISABLE_HOME`

</td><td>

If you don't want to use the interactive filter when you call `cd` without an argument, you can set any value but `0` for `$ENHANCD_DISABLE_HOME`. Defaults to `0`.

</td></tr>
<tr><td>

`ENHANCD_DOT_ARG`

</td><td>

You can customize the double-dot (`..`) argument for enhancd by this environment variable.
Default is `..`.

If you set this variable any but `..`, it gives you the _double-dot_ behavior with that argument; i.e. upward search of directory hierarchy.
Then `cd ..` changes current directory to parent directory without interactive filter.

In other words, you can keep original `cd ..` behavior by this option.

</td></tr>

<tr><td>

`ENHANCD_HYPHEN_ARG`

</td><td>

You can customize the hyphen (`-`) argument for enhancd by this environment variable.
Default is `-`.

If you set this variable any but `-`, it gives you the _hyphen_ behavior with that argument; i.e. backward search of directory-change history.
Then `cd -` changes current directory to `$OLDPWD` without interactive filter.

In other words, you can keep original `cd -` behavior by this option.

</td></tr>

<tr><td>

`ENHANCD_HYPHEN_NUM`

</td><td>

You can customize the number of rows by "cd -"
Default is `10`.

This is passed to `head` comand as `-n` option.

</td></tr>

<tr><td>

`ENHANCD_HOME_ARG`

</td><td>

You can customize to trigger the argumentless `cd` behavior by giving the string specified by this environment variable as an argument.
Default is empty string.

If you set this variable any but empty string, it gives you the behavior of `cd` with no argument; i.e. backward search of the whole directory-change history.
Then `cd` with no argument changes current directory to `$HOME` without interactive filter.

In other words, you can keep original behavior of `cd` with no argument by this option.

</td></tr>

<tr><td>

`ENHANCD_HOOK_AFTER_CD`

</td><td>

Default is empty. You can run any commands after changing directory with enhancd (e.g. `ls`: like `cd && ls`).

</td></tr>

<tr>
<td>

`ENHANCD_COMPLETION_KEYBIND`

</td>
<td>

Default is <kbd>Tab</kbd> (`^I`). See [#90](https://github.com/b4b4r07/enhancd/issues/90).

</td>

</tr>
<td>

`ENHANCD_COMPLETION_BEHAVIOR`

</td>
<td>

Default is the word of `default` (Regular completion). See [#90](https://github.com/b4b4r07/enhancd/issues/90).

It can be taken following words:

- default
- list (dir list with `$ENHANCD_FILTER`)
- history (dir history list with `$ENHANCD_FILTER`)

</td>
</tr>

<tr>
<td>

`ENHANCD_FILTER_ABBREV`

</td>
<td>

Set this to `1` to abbreviate the home directory prefix to `~` when performing an interactive search.
Using the example shown previously, all entries when searching will be shown as follows:

```console
$ cd
  ...
  ~/src/github.com/b4b4r07/enhancd/zsh
  ~/src/github.com/b4b4r07/gotcha
  ~/src/github.com/b4b4r07/blog/public
  ~/src/github.com/b4b4r07/blog
  ~/src/github.com/b4b4r07/link_test
  ~/src/github.com/b4b4r07
  ~/Dropbox/etc/dotfiles
  ~/src/github.com/b4b4r07/enhancd
> ~
  247/247
> _
```

Default is 0 (disable).

</td>
</tr>
</table>

## Uknown issues

- Fish version
  - Because of how fish piping works, it's not possible to pipe to cd like : `ls / | cd`

## References

The "visual filter" (interactive filter) is what is called "Interactive Grep Tool" according to [percol](https://github.com/mooz/percol) that is a pioneer in interactive selection to the traditional pipe concept on UNIX.

Interactive filter | Stars | Activity | Language
---|---|---|---
[junegunn/fzf][fzf-link]              | ![][fzf-star] | ![][fzf-last] | ![][fzf-lang]
[mooz/percol][percol-link]            | ![][percol-star] | ![][percol-last] | ![][percol-lang]
[peco/peco][peco-link]                | ![][peco-star] | ![][peco-last] | ![][peco-lang]
[jhawthorn/fzy][fzy-link]             | ![][fzy-star] | ![][fzy-last] | ![][fzy-lang]
[mattn/gof][gof-link]                 | ![][gof-star] | ![][gof-last] | ![][gof-lang]
[garybernhardt/selecta][selecta-link] | ![][selecta-star] | ![][selecta-last] | ![][selecta-lang]
[mptre/pick][pick-link]               | ![][pick-star] | ![][pick-last] | ![][pick-lang]
[lotabout/skim][skim-link]            | ![][skim-star] | ![][skim-last] | ![][skim-lang]
[natecraddock/zf][zf-link]            | ![][zf-star] | ![][zf-last] | ![][zf-lang]

[fzf-link]: https://github.com/junegunn/fzf
[fzf-star]: https://img.shields.io/github/stars/junegunn/fzf
[fzf-last]: https://img.shields.io/github/last-commit/junegunn/fzf
[fzf-lang]: https://img.shields.io/github/languages/top/junegunn/fzf

[percol-link]: https://github.com/mooz/percol
[percol-star]: https://img.shields.io/github/stars/mooz/percol
[percol-last]: https://img.shields.io/github/last-commit/mooz/percol
[percol-lang]: https://img.shields.io/github/languages/top/mooz/percol

[peco-link]: https://github.com/peco/peco
[peco-star]: https://img.shields.io/github/stars/peco/peco
[peco-last]: https://img.shields.io/github/last-commit/peco/peco
[peco-lang]: https://img.shields.io/github/languages/top/peco/peco

[fzy-link]: https://github.com/jhawthorn/fzy
[fzy-star]: https://img.shields.io/github/stars/jhawthorn/fzy
[fzy-last]: https://img.shields.io/github/last-commit/jhawthorn/fzy
[fzy-lang]: https://img.shields.io/github/languages/top/jhawthorn/fzy

[gof-link]: https://github.com/mattn/gof
[gof-star]: https://img.shields.io/github/stars/mattn/gof
[gof-last]: https://img.shields.io/github/last-commit/mattn/gof
[gof-lang]: https://img.shields.io/github/languages/top/mattn/gof

[selecta-link]: https://github.com/garybernhardt/selecta
[selecta-star]: https://img.shields.io/github/stars/garybernhardt/selecta
[selecta-last]: https://img.shields.io/github/last-commit/garybernhardt/selecta
[selecta-lang]: https://img.shields.io/github/languages/top/garybernhardt/selecta

[pick-link]: https://github.com/mptre/pick
[pick-star]: https://img.shields.io/github/stars/mptre/pick
[pick-last]: https://img.shields.io/github/last-commit/mptre/pick
[pick-lang]: https://img.shields.io/github/languages/top/mptre/pick

[skim-link]: https://github.com/lotabout/skim
[skim-star]: https://img.shields.io/github/stars/lotabout/skim
[skim-last]: https://img.shields.io/github/last-commit/lotabout/skim
[skim-lang]: https://img.shields.io/github/languages/top/lotabout/skim

[zf-link]: https://github.com/natecraddock/zf
[zf-star]: https://img.shields.io/github/stars/natecraddock/zf
[zf-last]: https://img.shields.io/github/last-commit/natecraddock/zf
[zf-lang]: https://img.shields.io/github/languages/top/natecraddock/zf

## Versus

Similar projects are below:

(But the basic concept of `enhancd` is totally different from jump tool)

- https://github.com/wting/autojump
- https://github.com/gsamokovarov/jump
- https://github.com/rupa/z
- https://github.com/skywind3000/z.lua
- https://github.com/ajeetdsouza/zoxide
- https://github.com/changyuheng/zsh-interactive-cd
- https://github.com/clvv/fasd (archived)

## License

[MIT][license-link] :copyright:
