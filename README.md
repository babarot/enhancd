[version-badge]: https://img.shields.io/github/tag/b4b4r07/enhancd.svg
[version-link]: https://github.com/b4b4r07/enhancd/releases
[awk-link]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html
[license-link]: https://b4b4r07.mit-license.org

<div align="center">

enhan/cd
===

[![][version-badge]][version-link] ![](https://img.shields.io/github/commit-activity/m/b4b4r07/enhancd)

enhancd is ***an enhanced cd command*** integrated with a command line fuzzy finder based on UNIX concept.

Typing “cd” in your console, enhancd provides you a new window to visit a directory. The basic UX of enhancd is almost same as builtin cd command but totally differenent in that you can choose where to go from the list of visited directories in the past. You can select the directory you want to visit using your favorite command line interactive filter (e.g. fzf). It just extends original cd command but brings you completely new experience.

<!--
[Getting Started](#getting-started) •
[Installation](#installation) •
[Configuration](#configuration) •
[References](#references)
-->

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
  * [Basics](#basics)
  * [Arguments](#arguments)
    * [Hyphen (`-`)](#hyphen--)
    * [Double-dot (`..`)](#double-dot-)
    * [Single-dot (`.`)](#single-dot-)
* [Options](#options)
* [Installation](#installation)
  * [Manual](#manual)
  * [Using package manager](#using-package-manager)
* [Configuration](#configuration)
* [Known issues](#known-issues)
* [References](#references)
* [Versus](#versus)
* [License](#license)

<!-- vim-markdown-toc -->

## Getting Started

![demo](https://user-images.githubusercontent.com/4442708/227760682-3db43c23-c31e-454f-9e9c-003c3eb7a693.gif)

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

### Basics

The usage of `cd` command powered by `enhancd` is almost same as built-in `cd` command.

```console
$ cd [-|..|.] <dir>
```

Argument | Behavior
---|---
 (none) | List all directories visited in the past. The `HOME` is always shown at a top of the list as builtin `cd` does. <br> <img width="500" alt="no-arg" src="https://user-images.githubusercontent.com/4442708/228423384-6bb527f1-e6f3-442a-9a04-3da50a46de76.png">
`<dir>` (exists in cwd) | Go to `dir` without the filter command (same as builtin `cd`) <br> <img width="500" alt="exist" src="https://user-images.githubusercontent.com/4442708/228421666-1a7f1cad-7e8d-4111-9e8e-04f215835d9f.png">
`<dir>` (not exists in cwd) | Find directories matched with `dir` or being similar to `dir` and then pass them to the filter command. A directory named "afx" is not in the current directory but enhancd `cd` can show where to go from the visited log. <br> <img width="500" alt="not-exist" src="https://user-images.githubusercontent.com/4442708/228421661-e66e4ae5-fa0d-4dfc-a235-d914e249810c.png">
`-` | List latest 10 directories <br> <img width="500" alt="hyphen" src="https://user-images.githubusercontent.com/4442708/228717962-40189613-3d0f-4b21-a84c-81f5d6b429d5.png">
`..` | List all parent directories of cwd <br> <img width="500" alt="double-dot" src="https://user-images.githubusercontent.com/4442708/228717954-58681d3e-0797-4328-bc3a-ae4da4f1abdb.png">
`.` | List all sub directories in cwd <br> <img width="500" alt="single-dot" src="https://user-images.githubusercontent.com/4442708/228717947-097e408b-10e8-4db2-9998-ee676fbf072a.png">

### Arguments

#### Hyphen (`-`)

List latest 10 directories. This is useful for choosing the directory recently visited only. The number of directories shown as the choices can be changed as you like by editing `ENHANCD_HYPHEN_NUM` (Defaults to `10`).

```console
$ cd -
❯ enhancd
  2/10
> /Users/babarot/src/github.com/b4b4r07/enhancd
  /Users/babarot/src/github.com/b4b4r07/enhancd/src
```

To disable this feature (revert to the original behavior on `cd -`), please set `ENHANCD_DISABLE_HYPHEN` to `0`.

#### Double-dot (`..`)

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

To disable this feature (revert to the original behavior on `cd ..`), please set `ENHANCD_DISABLE_DOT` to `0`.

#### Single-dot (`.`)

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

To disable this feature (revert to the original behavior on `cd .`), please set `ENHANCD_DISABLE_DOT_CURRENT` to `0`.

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
short | a short option (e.g. `-G`)
long | a long option (e.g. `--ghq`)
desc | a description for the option
func | a command which returns directory list (e.g. `ghq list --full-path`)
condition | a command which determine that the option should be implemented or not (e.g. `which ghq`)

<img width="600" alt="ghq-soruce" src="https://user-images.githubusercontent.com/4442708/228717958-c0535b20-404f-4e21-aa69-efb5c31ed30d.png">

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

<tr><td> <strong>Case</strong> </td><td> <strong>Way</strong> </td></tr>

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
$ echo "source ~/enhancd/init.sh" >> ~/.bash_profile
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

</details>

## Configuration

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
<summary><strong><code>ENHANCD_DISABLE_DOT</code></strong></summary>

If you don't want to use the interactive filter, when specifing a double dot (`..`), you should set not zero value to `$ENHANCD_DISABLE_DOT`. Defaults to 0 (enable).

</details>

<details>
<summary><strong><code>ENHANCD_DISABLE_DOT_CURRENT</code></strong></summary>

If you don't want a feature to find sub directories in cwd, when specifing a single dot (`.`), you should set not zero value to `$ENHANCD_DISABLE_DOT_CURRENT`. Defaults to 0 (enable).

</details>

<details>
<summary><strong><code>ENHANCD_DISABLE_HYPHEN</code></strong></summary>

This option is similar to `ENHANCD_DISABLE_DOT`. Defaults to 0 (enable).

</details>

<details>
<summary><strong><code>ENHANCD_DISABLE_HOME</code></strong></summary>

If you don't want to use the interactive filter when you call `cd` without an argument, you can set any value but `0` for `$ENHANCD_DISABLE_HOME`. Defaults to 0 (enable).

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
<summary><strong><code>ENHANCD_HYPHEN_NUM</code></strong></summary>

You can customize the number of rows by "cd -"
Default is `10`.

This is passed to `head` comand as `-n` option.

</details>

<details>
<summary><strong><code>ENHANCD_HOME_ARG</code></strong></summary>

You can customize to trigger the argumentless `cd` behavior by giving the string specified by this environment variable as an argument.
Default is empty string.

If you set this variable any but empty string, it gives you the behavior of `cd` with no argument; i.e. backward search of the whole directory-change history.
Then `cd` with no argument changes current directory to `$HOME` without interactive filter.

In other words, you can keep original behavior of `cd` with no argument by this option.

</details>

<details>
<summary><strong><code>ENHANCD_HOOK_AFTER_CD</code></strong></summary>

Default is empty. You can run any commands after changing directory with enhancd (e.g. `ls`: like `cd && ls`).

</details>

<details>
<summary><strong><code>ENHANCD_COMPLETION_KEYBIND</code></strong></summary>

Default is <kbd>Tab</kbd> (`^I`). See [#90](https://github.com/b4b4r07/enhancd/issues/90).

</details>

<details>
<summary><strong><code>ENHANCD_COMPLETION_BEHAVIOR</code></strong></summary>

Default is the word of `default` (Regular completion). See [#90](https://github.com/b4b4r07/enhancd/issues/90).

It can be taken following words:

- default
- list (dir list with `$ENHANCD_FILTER`)
- history (dir history list with `$ENHANCD_FILTER`)

</details>

<details>
<summary><strong><code>ENHANCD_FILTER_ABBREV</code></strong></summary>

Set this to `1` to abbreviate the home directory prefix to `~` when performing an interactive search.
Using the example shown previously, all entries when searching will be shown as follows:

```console
$ cd -
❯ _
  10/10
  ~/src
> ~/src/github.com/b4b4r07/enhancd/src
  ~/enhancd
  ~/src/github.com/b4b4r07/dotfiles
  ~/src/github.com/b4b4r07/dotfiles/.config/nvim/lua/plugins
  ~/src/github.com/b4b4r07/enhancd/functions/enhancd/lib
  ~/src/github.com/b4b4r07/tmux-git-prompt
  ~/.tmux/plugins/tmux-git-prompt
  ~/.tmux/plugins/tmux-colors-solarized
  ~/.afx/github.com/b4b4r07
```

Default is 0 (disable).

</details>

## Known issues

**Enhancd complete (fish)**:

On fish shell, you can use <kbd>alt+f</kbd> to trigger `enhancd` when typing a command, the selected item will be appended to the commandline

- Fish version
  - Because of how fish piping works, it's not possible to pipe to cd like : `ls / | cd`

## References

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

## Versus

Similar projects.

(But the basic concept of `enhancd` is totally different from jump tool)

- [wting/autojump](https://github.com/wting/autojump)
- [gsamokovarov/jump](https://github.com/gsamokovarov/jump)
- [rupa/z](https://github.com/rupa/z)
- [skywind3000/z.lua](https://github.com/skywind3000/z.lua)
- [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)
- [changyuheng/zsh-interactive-cd](https://github.com/changyuheng/zsh-interactive-cd)
- [clvv/fasd](https://github.com/clvv/fasd) (archived)

## License

[MIT][license-link]
