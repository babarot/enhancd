[version-badge]: https://img.shields.io/github/tag/b4b4r07/enhancd.svg
[version-link]: https://github.com/b4b4r07/enhancd/tags
[sponsors-badge]: https://img.shields.io/github/sponsors/b4b4r07?logo=github&color=lightyellow
[sponsors-link]: https://github.com/sponsors/b4b4r07
[repostatus-badge]: https://www.repostatus.org/badges/latest/active.svg
[repostatus-link]: https://www.repostatus.org/#active
[awk-link]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html
[license-link]: https://b4b4r07.mit-license.org

<div align="center">

enhan/cd
===

[:rocket:](#usage) [:rocket:](#installation) [:rocket:](#configuration)

[![][version-badge]][version-link] [![][repostatus-badge]][repostatus-link] [![][sponsors-badge]][sponsors-link]

enhancd is ***an enhanced cd command*** integrated with a command line fuzzy finder based on UNIX concept.

Typing “cd” in your console, enhancd provides you a new window to visit a directory. The basic UX of enhancd is almost same as builtin cd command but totally differenent in that you can choose where to go from the list of visited directories in the past. You can select the directory you want to visit using your favorite command line interactive filter (e.g. fzf). It just extends original cd command but brings you completely new experience.

</div>

<!--

Naming:

- enhan/cd
- enhanc<sup>e</sup>d
- enhan<sup>/</sup>cd

Features:

- Go to the visited directory in the past
- Easy to filter, using your favorite filter
- Work on Bash, Zsh and fish (cross-shell compatibility)
- Go back to a specific parent directory like [zsh-bd](https://github.com/Tarrasch/zsh-bd)
- Inside a git repo, the first list element is the git root directory
- Fuzzy search in a similar name directory
- Support standard input (`echo $HOME | cd` is acceptable)
- Custom options (user-defined option is acceptable)
-->

<!-- vim-markdown-toc GFM -->

* [Getting Started](#getting-started)
* [Usage](#usage)
  * [Hyphen (`-`)](#hyphen--)
  * [Double-dot (`..`)](#double-dot-)
  * [Single-dot (`.`)](#single-dot-)
  * [Piping](#piping)
* [Options](#options)
* [Installation](#installation)
  * [Manual](#manual)
  * [Using package manager](#using-package-manager)
* [Configuration](#configuration)
* [Known issues](#known-issues)
* [References](#references)
  * [Interactive filter commands](#interactive-filter-commands)
  * [Versus](#versus)
* [License](#license)

<!-- vim-markdown-toc -->

## Getting Started

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/4442708/229307417-50cf53de-594f-4a19-8547-9820d3af2f1c.gif">
  <source media="(prefers-color-scheme: light)" srcset="https://user-images.githubusercontent.com/4442708/229307415-32cb36ee-491d-47c5-b852-e94d802e9584.gif">
  <img alt="demo" src="https://user-images.githubusercontent.com/4442708/229307417-50cf53de-594f-4a19-8547-9820d3af2f1c.gif">
</picture>

Trying enhancd on the current shell, you need to run this command:

```bash
source ./init.sh
```

After that, `cd` is aliased to `__enhancd::cd` so you can use enhancd feature by typing `cd` as usual.

Using enhancd feature requires a command line fuzzy finder tool (as known as an interactive filter), for example, [fzf](https://github.com/junegunn/fzf). The `ENHANCD_FILTER` is the command name for interactive filters. It is a colon-separated list of executables. Each arguments can be also included to the list. It searches from the top of the list and uses the first installed one. A default value is `fzy:fzf:peco:sk:zf`.

Changing the order of each executables in the list, you can change the interactive filter command used by enhancd. Let’s configure what’s your favorite one!

```console
$ export ENHANCD_FILTER="fzf --height 40%:fzy"
```

## Usage

The usage of `cd` command powered by `enhancd` is almost same as built-in `cd` command.

```console
$ cd [-|..|.] <dir>
```

Argument | Behavior
---|---
 (none) | List all directories visited in the past. The `HOME` is always shown at a top of the list as builtin `cd` does. <br> <img width="600" alt="" src="https://user-images.githubusercontent.com/4442708/229298754-9dcd8e18-5777-4b23-bdcf-1aa4e06ac92b.png">
`<dir>` (exists in cwd) | Go to `dir` without the filter command (same as builtin `cd`) <br> <img width="600" alt="" src="https://user-images.githubusercontent.com/4442708/229298751-ed509919-4ebc-4b59-90d9-bb7792aa9fd0.png">
`<dir>` (not exists in cwd) | Find directories matched with `dir` or being similar to `dir` and then pass them to the filter command. A directory named "afx" is not in the current directory but enhancd `cd` can show where to go from the visited log. <br> <img width="600" alt="" src="https://user-images.githubusercontent.com/4442708/229298749-ec8c0bca-100f-4b8a-9d21-510ce1666831.png">
`-` | List latest 10 directories <br> <img width="600" alt="" src="https://user-images.githubusercontent.com/4442708/229298748-ad6380ff-4498-4b30-9f8a-46b792ca4669.png">
`..` | List all parent directories of cwd <br> <img width="600" alt="" src="https://user-images.githubusercontent.com/4442708/229298747-039a2d06-2e1a-4b27-b009-e78a9c74c6ea.png">
`.` | List all sub directories in cwd <br> <img width="600" alt="" src="https://user-images.githubusercontent.com/4442708/229298744-b6f8cab1-654b-4197-855b-9f1d84c4c933.png">

### Hyphen (`-`)

List latest 10 directories. This is useful for choosing the directory recently visited only. The number of directories shown as the choices can be changed as you like by editing `ENHANCD_HYPHEN_NUM` (Defaults to `10`).

```console
$ cd -
❯ enhancd
  2/10
> /Users/babarot/src/github.com/b4b4r07/enhancd
  /Users/babarot/src/github.com/b4b4r07/enhancd/src
```

To disable this feature, set `ENHANCD_ENABLE_HYPHEN` to `false`.

### Double-dot (`..`)

List all parent directories of the current working directory to quickly go back to any directory instead of typing `cd ../../..` redundantly.

Let's say you're in `~/src/github.com/b4b4r07/enhancd`. The result of `cd ..` will be:

```console
$ cd ..
❯ _
  6/6
> /Users/babarot/src/github.com/b4b4r07
  /Users/babarot/src/github.com
  /Users/babarot/src
  /Users/babarot
  /Users
  /
```

To disable this feature, set `ENHANCD_ENABLE_DOUBLE_DOT` to `false`.

### Single-dot (`.`)

List all sub directories recursively located under the current directory. The built-in `cd` command does nothing even if a dot (`.`) is passed. Whereas, in enhancd `cd`, it's useful for visiting any sub directory easily (the example below is that if you're in "enhancd" directory):

```console
$ cd .
❯ _
  8/8
> .github/
  .github/ISSUE_TEMPLATE/
  .github/workflows/
  conf.d/
  functions/
  functions/enhancd/
  functions/enhancd/lib/
  src/
```

This would be very useful to find a directory you want to visit within current directory. It uses `find` command internally to list directories but it would be good to install `fd` ([sharkdp/fd](https://github.com/sharkdp/fd)) command. It'll be more fast and also be included hidden directories into the list if `fd` is used.

To disable this feature, set `ENHANCD_ENABLE_SINGLE_DOT` to `false`.

### Piping

:bulb: Zsh only.

enhancd allows you to pass one or multiple directory paths to cd commands like this:

```conosle
$ (paths) | cd
```

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/4442708/229368007-071958e1-77a6-4fd1-b371-535d1dac46f6.gif">
  <source media="(prefers-color-scheme: light)" srcset="https://user-images.githubusercontent.com/4442708/229368002-dd1c0c4c-6b53-4908-8b88-e00dc4e884ff.gif">
  <img alt="piping" src="https://user-images.githubusercontent.com/4442708/229368007-071958e1-77a6-4fd1-b371-535d1dac46f6.gif" width="600">
</picture>

## Options

```console
$ cd --help
Usage: cd [OPTIONS] [dir]

OPTIONS:
  -h, --help          Show help message
  -q                  (default) quiet, no output or use of hooks
  -s                  (default) refuse to use paths with symlinks
  -L                  (default) retain symbolic links ignoring CHASE_LINKS
  -P                  (default) resolve symbolic links as CHASE_LINKS

Version: 2.3.0
```

In enhancd, all options are defined at a configuration file ([config.ltsv](https://github.com/b4b4r07/enhancd/blob/master/config.ltsv)). This mechanism allows you to add what you want as new option or delete unneeded default options. It uses [LTSV](http://ltsv.org/) (Labeled Tab-Separated Values) format.

For example, let's say you want to use [`ghq list`](https://github.com/x-motemen/ghq) as custom inputs for `cd` command. In this case, all you have to do is just to add this one line to your any `config.ltsv`:

```tsv
short:-G	long:--ghq	desc:Show ghq path	func:ghq list --full-path	condition:which ghq
```

Label | Description
---|---
short (`*`) | a short option (e.g. `-G`)
long (`*`) | a long option (e.g. `--ghq`)
desc | a description for the option
func (`*`) | a command which returns directory list (e.g. `ghq list --full-path`)
condition | a command which determine that the option should be implemented or not (e.g. `which ghq`)
format | a string which indicates how to format a line selected by the filter before passing cd command. `%` is replaced as a selected line and then passed to cd command (e.g. `$HOME/src/%`). This is useful for the case that input sources for the interactive filter are not a full-path.

> **Note**: `*`: A required key. But either `short` or `long` is good enough.

<!-- <img width="600" alt="" src="https://user-images.githubusercontent.com/4442708/229298741-236f2920-cde2-4184-9fd3-72849af7a223.png"> -->

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://user-images.githubusercontent.com/4442708/229365175-aecfe844-cbd7-4ee2-87a6-ea8471ac9b6f.gif">
  <source media="(prefers-color-scheme: light)" srcset="https://user-images.githubusercontent.com/4442708/229365177-6c8d6056-9ba3-4f22-ba28-48f3991f9f98.gif">
  <img alt="options" src="https://user-images.githubusercontent.com/4442708/229365175-aecfe844-cbd7-4ee2-87a6-ea8471ac9b6f.gif" width="600">
</picture>

enhancd loads these `config.ltsv` files located in:

1. `$ENHANCD_ROOT/config.ltsv`
2. `$ENHANCD_DIR/config.ltsv`
3. `$HOME/.config/enhancd/config.ltsv`

Thanks to this feature, it's easy to add your custom option as you hope.

## Installation

### Manual

enhancd is consists of a bunch of shell scripts. Running this command to clone repo and to run an entrypoint script enables you to try it out.

```bash
git clone https://github.com/b4b4r07/enhancd && source enhancd/init.sh
```

### Using package manager

Using [AFX](https://github.com/b4b4r07/afx) for installing and managing shell plugins is heavily recommended now because it's better solution to manage enhancd and your favorite interactive filter at the same way.

```yaml
github:
- name: b4b4r07/enhancd
  description: A next-generation cd command with your interactive filter
  owner: b4b4r07
  repo: enhancd
  plugin:
    env:
      ENHANCD_FILTER: >
        fzf --preview 'exa -al --tree --level 1 --group-directories-first --git-ignore
        --header --git --no-user --no-time --no-filesize --no-permissions {}'
        --preview-window right,50% --height 35% --reverse --ansi
        :fzy
        :peco
    sources:
    - init.sh
- name: junegunn/fzf
  description: A command-line fuzzy finder
  owner: junegunn
  repo: fzf
  command:
    build:
      steps:
        - ./install --bin --no-update-rc --no-key-bindings
    link:
    - from: 'bin/fzf'
    - from: 'bin/fzf-tmux'
  plugin:
    sources:
    - shell/completion.zsh
    env:
      FZF_DEFAULT_COMMAND: fd --type f
      FZF_DEFAULT_OPTS: >
        --height 75% --multi --reverse --margin=0,1
        --bind ctrl-f:page-down,ctrl-b:page-up,ctrl-/:toggle-preview
        --bind pgdn:preview-page-down,pgup:preview-page-up
        --marker="✚" --pointer="▶" --prompt="❯ "
        --no-separator --scrollbar="█"
        --color bg+:#262626,fg+:#dadada,hl:#f09479,hl+:#f09479
        --color border:#303030,info:#cfcfb0,header:#80a0ff,spinner:#36c692
        --color prompt:#87afff,pointer:#ff5189,marker:#f09479
      FZF_CTRL_T_COMMAND: rg --files --hedden --follow --glob "!.git/*"
      FZF_CTRL_T_OPTS: --preview "bat --color=always --style=header,grid --line-range :100 {}"
      FZF_ALT_C_COMMAND: fd --type d
      FZF_ALT_C_OPTS: --preview "tree -C {} | head -100"
```

then,

```console
$ afx install
```

For more details, see [the full documentation](https://babarot.me/afx/).

<details><summary>Other installations are here!</summary>

<br>

<table>

<tr><td> <strong>Case</strong> </td><td> <strong>Installation</strong> </td></tr>

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

1. Run cloning on the console.

   ```console
   $ git clone https://github.com/b4b4r07/enhancd.git /path/to/enhancd
   ```

2. Add this line to your bashrc.

   ```bash
   # ~/.bashrc
   source /path/to/enhancd/init.sh
   ```

</td>
</tr>

<tr>
<td rowspan="2"> Zsh </td>
<td>

[`zplug`](https://github.com/zplug/zplug) (powerful plugin manager for zsh):

Add this line to your zshrc

```bash
# .zshrc
zplug "b4b4r07/enhancd", use:init.sh
```

and then run this command.

```
$ zplug install
```

</td>
</tr>
<tr>
<!-- <td> Zsh </td> -->
<td>

[`oh-my-zsh`](https://github.com/ohmyzsh/ohmyzsh) user:

Clone repo,

```console
$ git clone https://github.com/b4b4r07/enhancd.git $ZSH_CUSTOM/plugins/enhancd
```

and then load as a plugin in your zshrc.

```bash
# .zshrc
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

</details>

## Configuration

<details>
<summary><strong><code>ENHANCD_DIR</code></strong></summary>

A directory to have `enhancd.log` and `config.ltsv`. It defaults to `~/.enhancd`.

</details>

<details>
<summary><strong><code>ENHANCD_FILTER</code></strong></summary>

A list of executable commands (interactive filter such as `fzf`) concatenated with '`:`' like `PATH`. For example:

```bash
export ENHANCD_FILTER="/usr/local/bin/sk:fzf --ansi:fzy:non-existing-filter"
```

The command found by searching in order from the first is used as an interactive filter of enhancd. If there is nothing any commands, it only provides a functionality as a built-in `cd` command.

</details>

<details>
<summary><strong><code>ENHANCD_COMMAND</code></strong></summary>

A command name to trigger enhancd `cd` command. It defaults to `cd`. By default, enhancd aliases `cd` to enhancd one. So you want to prevent it, you need to set this environemnt variable.

After set, you need to set restart your shell to apply the changes.

```console
$ echo $ENHANCD_COMMAND
cd
$ export ENHANCD_COMMAND=ecd
$ source /path/to/init.sh
```

</details>

<details>
<summary><strong><code>ENHANCD_ENABLE_DOUBLE_DOT</code></strong></summary>

Enable to list parent directories when `..` is given. Defaults to `true`.

ref: [Double-dot (`..`)](#double-dot-)

</details>

<details>
<summary><strong><code>ENHANCD_ENABLE_SINGLE_DOT</code></strong></summary>

Enable to list sub directories in the current directory when `.` is given. Defaults to `true`.

ref: [Single-dot (`.`)](#single-dot-)

> **Note**
> Added in [#188](https://github.com/b4b4r07/enhancd/pull/188) [#198](https://github.com/b4b4r07/enhancd/pull/198)

</details>

<details>
<summary><strong><code>ENHANCD_ENABLE_HYPHEN</code></strong></summary>

Enable to list visited directories limited latest 10 cases when `-` is given. Defaults to `true`.

ref: [Single-dot (`.`)](#single-dot-)

</details>

<details>
<summary><strong><code>ENHANCD_ENABLE_HOME</code></strong></summary>

Enable to use the interactive filter when no argument is given. When set it to `false`, `cd` just changes the current working directory to home directory. Defaults to `true`.

</details>

<details>
<summary><strong><code>ENHANCD_ARG_DOUBLE_DOT</code></strong></summary>

You can customize the double-dot (`..`) argument for enhancd by this environment variable.
Default is `..`.

If you set this variable any but `..`, it gives you the _double-dot_ behavior with that argument; i.e. upward search of directory hierarchy.
Then `cd ..` changes current directory to parent directory without interactive filter.

In other words, you can keep original `cd ..` behavior by this option.

</details>

<details>
<summary><strong><code>ENHANCD_ARG_SINGLE_DOT</code></strong></summary>

You can customize the single-dot (`.`) argument for enhancd by this environment variable.
Default is `.`.

</details>

<details>
<summary><strong><code>ENHANCD_ARG_HYPHEN</code></strong></summary>

A string to trigger a hyphen behavior. Default is `-`.

If you set this variable any but `-`, it gives you a _hyphen_ behavior with that argument; i.e. backward search of directory-change history.
Then `cd -` changes current directory to `$OLDPWD` without interactive filter.

In other words, you can keep the original `cd -` behavior by setting this option.

</details>

<details>
<summary><strong><code>ENHANCD_ARG_HOME</code></strong></summary>

You can customize to trigger the argumentless `cd` behavior by giving the string specified by this environment variable as an argument. Default is empty string.

If you set this variable any but empty string, it gives you the behavior of `cd` with no argument; i.e. backward search of the whole directory-change history.
Then `cd` with no argument changes current directory to `$HOME` without interactive filter.

In other words, you can keep original behavior of `cd` with no argument by setting this option.

</details>

<details>
<summary><strong><code>ENHANCD_HYPHEN_NUM</code></strong></summary>

A variable to specify how many lines to show up in the list when a hyphen behavior. Default is `10`.

</details>

<details>
<summary><strong><code>ENHANCD_HOOK_AFTER_CD</code></strong></summary>

Default is empty. You can run any commands after changing directory with enhancd (e.g. set `ls` to this variable => same as `cd && ls`).

</details>

<details>
<summary><strong><code>ENHANCD_USE_ABBREV</code></strong></summary>

Set this to `true` to abbreviate the home directory prefix to `~` when performing an interactive search.
Using the example shown previously, all entries when searching will be shown as follows:

<table>

<tr><td align="center"> <strong>false</strong> </td><td align="center"> <strong>true</strong> </td></tr>

<tr>
<td>

<!--
```console
$ cd -
❯ _
  10/10
  /Users/babarot/src
> /Users/babarot/src/github.com/b4b4r07/enhancd/src
  /Users/babarot/enhancd
  /Users/babarot/src/github.com/b4b4r07/dotfiles
  /Users/babarot/src/github.com/b4b4r07/dotfiles/.config/nvim/lua/plugins
  /Users/babarot/src/github.com/b4b4r07/enhancd/functions/enhancd/lib
  /Users/babarot/src/github.com/b4b4r07/tmux-git-prompt
  /Users/babarot/.tmux/plugins/tmux-git-prompt
  /Users/babarot/.tmux/plugins/tmux-colors-solarized
  /Users/babarot/.afx/github.com/b4b4r07
```
-->

```console
$ cd -
❯ _
  10/10
  /Users/babarot/src
> /Users/babarot/src/github.com/b4b4..
  /Users/babarot/enhancd
  /Users/babarot/src/github.com/b4b4..
  /Users/babarot/src/github.com/b4b4..
  /Users/babarot/src/github.com/b4b4..
  /Users/babarot/src/github.com/b4b4..
  /Users/babarot/.tmux/plugins/tmux-..
  /Users/babarot/.tmux/plugins/tmux-..
  /Users/babarot/.afx/github.com/b4b..
```

</td>
<td>

```console
$ cd -
❯ _
  10/10
  ~/src
> ~/src/github.com/b4b4..
  ~/enhancd
  ~/src/github.com/b4b4..
  ~/src/github.com/b4b4..
  ~/src/github.com/b4b4..
  ~/src/github.com/b4b4..
  ~/.tmux/plugins/tmux-..
  ~/.tmux/plugins/tmux-..
  ~/.afx/github.com/b4b..
```

</td>
</tr>

</table>

Default is `false` (disable).

</details>

## Known issues

**Enhancd complete (fish)**:

On fish shell, you can use <kbd>alt+f</kbd> to trigger `enhancd` when typing a command, the selected item will be appended to the commandline

- Fish version
  - Because of how fish piping works, it's not possible to pipe to cd like : `ls / | cd`

## References

### Interactive filter commands

The "visual filter" (interactive filter) is what is called "Interactive Grep Tool" according to [percol](https://github.com/mooz/percol) that is a pioneer in interactive selection to the traditional pipe concept on UNIX. Some candidates of an interactive filter are listed on here.

Name | Stars | Language | Activity
---|---|---|---
[junegunn/fzf][fzf-link]              | ![][fzf-star]     | ![][fzf-lang]     | ![][fzf-last]    
[mooz/percol][percol-link]            | ![][percol-star]  | ![][percol-lang]  | ![][percol-last] 
[peco/peco][peco-link]                | ![][peco-star]    | ![][peco-lang]    | ![][peco-last]   
[jhawthorn/fzy][fzy-link]             | ![][fzy-star]     | ![][fzy-lang]     | ![][fzy-last]    
[mattn/gof][gof-link]                 | ![][gof-star]     | ![][gof-lang]     | ![][gof-last]    
[garybernhardt/selecta][selecta-link] | ![][selecta-star] | ![][selecta-lang] | ![][selecta-last]
[mptre/pick][pick-link]               | ![][pick-star]    | ![][pick-lang]    | ![][pick-last]   
[lotabout/skim][skim-link]            | ![][skim-star]    | ![][skim-lang]    | ![][skim-last]   
[natecraddock/zf][zf-link]            | ![][zf-star]      | ![][zf-lang]      | ![][zf-last]     

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

### Versus

Similar projects.

- [wting/autojump](https://github.com/wting/autojump)
- [gsamokovarov/jump](https://github.com/gsamokovarov/jump)
- [rupa/z](https://github.com/rupa/z)
- [skywind3000/z.lua](https://github.com/skywind3000/z.lua)
- [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)
- [changyuheng/zsh-interactive-cd](https://github.com/changyuheng/zsh-interactive-cd)
- [clvv/fasd](https://github.com/clvv/fasd) (archived)

(However, the basic concept of `enhancd` is totally different from these directory-jump tools)

## License

[MIT][license-link]
