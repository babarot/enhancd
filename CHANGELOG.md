# Changelog

## [v2.5.2](https://github.com/babarot/enhancd/compare/v2.5.1...v2.5.2) - 2025-01-24
### Bug fixes
- Do not quote multiple lines to deal as single line by @babarot in https://github.com/babarot/enhancd/pull/210
### Others
- Update README.md to fix typo in FZF_CTRL_T_COMMAND by @timfee in https://github.com/babarot/enhancd/pull/213
- Single results are still showing the filter #207 by @augustocdias in https://github.com/babarot/enhancd/pull/221
- Use CDPATH if set by @jbro in https://github.com/babarot/enhancd/pull/219
- fix: parent directory containing spaces (#222) by @iamKunal in https://github.com/babarot/enhancd/pull/229
- doc: Add install instructions for zi by @papanito in https://github.com/babarot/enhancd/pull/223

## [v2.5.1](https://github.com/babarot/enhancd/compare/v2.5.0...v2.5.1) - 2023-04-11
### Bug fixes
- fix fish errors by @peeviddy in https://github.com/babarot/enhancd/pull/204
### Others
- Make checking of system status code more robust by @babarot in https://github.com/babarot/enhancd/pull/202

## [v2.5.0](https://github.com/babarot/enhancd/compare/v2.4.1...v2.5.0) - 2023-04-03
### New Features
- Allow to pipe multiple dirs to cd by @babarot in https://github.com/babarot/enhancd/pull/197
- Support dot-feature in fish and add `ENHANCD_ARG_SINGLE_DOT` by @babarot in https://github.com/babarot/enhancd/pull/198
- Add 'format' label to format custom input before passing cd by @babarot in https://github.com/babarot/enhancd/pull/192
### Refactorings
- Format awk scripts by @babarot in https://github.com/babarot/enhancd/pull/201
### Others
- Remove completion feature from enhancd by @babarot in https://github.com/babarot/enhancd/pull/191
- Drastically update around GH workflows by @babarot in https://github.com/babarot/enhancd/pull/199

## [v2.4.1](https://github.com/babarot/enhancd/compare/v2.4.0...v2.4.1) - 2023-03-31
- Use tagpr workflow to make tag and update version file by @babarot in https://github.com/babarot/enhancd/pull/193
- Update all environment name by @babarot in https://github.com/babarot/enhancd/pull/195

## [v2.4.0](https://github.com/babarot/enhancd/compare/v2.3.2...v2.4.0) - 2023-03-30
- Fix awk error by @babarot in https://github.com/babarot/enhancd/pull/190
- Add new feature on cd `.` by @babarot in https://github.com/babarot/enhancd/pull/188

## [v2.3.2](https://github.com/babarot/enhancd/compare/v2.3.1...v2.3.2) - 2023-03-27
- Add workflow to make release automated by @babarot in https://github.com/babarot/enhancd/pull/187

## [v2.3.1](https://github.com/babarot/enhancd/compare/v2.3.0...v2.3.1) - 2023-03-27
- Import existing labels by @github-actions in https://github.com/babarot/enhancd/pull/185
- fish: Do not change directory if Ctrl-C pressed in fuzzy search by @LordFlashmeow in https://github.com/babarot/enhancd/pull/175
- Update log structure logic by @babarot in https://github.com/babarot/enhancd/pull/186

## [v2.3.0](https://github.com/babarot/enhancd/compare/v2.2.4...v2.3.0) - 2023-03-25
- Fix builtin cd arguments by @ponko2 in https://github.com/babarot/enhancd/pull/93
- Add fish support by @gazorby in https://github.com/babarot/enhancd/pull/99
- Fix ENHANCD_ROOT by @gazorby in https://github.com/babarot/enhancd/pull/102
- Fixes typo in README by @derphilipp in https://github.com/babarot/enhancd/pull/105
- Import existing labels by @github-actions in https://github.com/babarot/enhancd/pull/115
- Fix cd back to ~/ when aborting fuzzy selection with fish shell by @gazorby in https://github.com/babarot/enhancd/pull/114
- Add antigen support  by @CHNB128 in https://github.com/babarot/enhancd/pull/116
- Update fish support by @gazorby in https://github.com/babarot/enhancd/pull/139
- Add git root inside a git repo by @gazorby in https://github.com/babarot/enhancd/pull/111
- Prevent sources deletion by @gazorby in https://github.com/babarot/enhancd/pull/125
- Fix awk scripts paths in fish functions by @gazorby in https://github.com/babarot/enhancd/pull/141
- fish: do not rely on fisher variable to find the plugin root by @d3dave in https://github.com/babarot/enhancd/pull/143
- Fix trailing newline in variable passed to awk when changing to relative path by @d3dave in https://github.com/babarot/enhancd/pull/144
- Fish fixes by @d3dave in https://github.com/babarot/enhancd/pull/145
- Use function instead of alias in Fish by @kidonng in https://github.com/babarot/enhancd/pull/146
- Use `command` prefix in built-in command by @cappyzawa in https://github.com/babarot/enhancd/pull/142
- Fix command prefix by @cappyzawa in https://github.com/babarot/enhancd/pull/147
- Fix ENHANCD_COMPLETION_BEHAVIOUR/BEHAVIOR misnamed variable by @LordFlashmeow in https://github.com/babarot/enhancd/pull/151
- Make README toc link work by @leader22 in https://github.com/babarot/enhancd/pull/162
- zsh: Fix handling of directory names containing spaces by @d3dave in https://github.com/babarot/enhancd/pull/148
- Take backup before running cd command by @babarot in https://github.com/babarot/enhancd/pull/165
- Revert "Take backup before running cd command" by @babarot in https://github.com/babarot/enhancd/pull/166
- Add Fig as an installation method to the README by @brendanfalk in https://github.com/babarot/enhancd/pull/173
- docs: added installation information for oh-my-zsh by @iToXiQ in https://github.com/babarot/enhancd/pull/174
- Add option to abbreviate home directory to ~ when searching by @d3dave in https://github.com/babarot/enhancd/pull/149
- Remove unneeded const variable by @babarot in https://github.com/babarot/enhancd/pull/176
- Refactor init by @babarot in https://github.com/babarot/enhancd/pull/178
- Refactoring src/sources.sh by @babarot in https://github.com/babarot/enhancd/pull/179
- Refactor filter  by @babarot in https://github.com/babarot/enhancd/pull/180
- Refactor on fuzzy function by @babarot in https://github.com/babarot/enhancd/pull/181
- Refactor filepath by @babarot in https://github.com/babarot/enhancd/pull/182
- LTSV by @babarot in https://github.com/babarot/enhancd/pull/183
- Refactoring branch by @babarot in https://github.com/babarot/enhancd/pull/177

## [v2.2.4](https://github.com/babarot/enhancd/compare/v2.2.3...v2.2.4) - 2019-05-30
- Fix builtin cd arguments by @ponko2 in https://github.com/babarot/enhancd/pull/91
- Bump up and some minor changes by @babarot in https://github.com/babarot/enhancd/pull/92

## [v2.2.3](https://github.com/babarot/enhancd/compare/v2.2.1...v2.2.3) - 2019-05-27
- v2.2.2: Refactor and allow developers to easily maintain (etc.) by @babarot in https://github.com/babarot/enhancd/pull/49
- Fix issue that init routine runs in global scope by @usami-k in https://github.com/babarot/enhancd/pull/50
- Unalias error by @nexeck in https://github.com/babarot/enhancd/pull/51
- add: skip mkdir and touch if exist by @vintersnow in https://github.com/babarot/enhancd/pull/55
- Fix that shwordsplit doesn't work properly. by @asakasa in https://github.com/babarot/enhancd/pull/56
- add $ENHANCD_HOME_ARG by @crhg in https://github.com/babarot/enhancd/pull/61
- Always return true in history.sh __enhancd::history::list by @HaleTom in https://github.com/babarot/enhancd/pull/71
- add ENHANCD_HYPHEN_NUM env var, custom "cd -" num by @AknEp in https://github.com/babarot/enhancd/pull/65
- FreeBSD awk throws errors if the fifos are closed too early by @aperum in https://github.com/babarot/enhancd/pull/60
- Add dockerfile by @babarot in https://github.com/babarot/enhancd/pull/73
- Fix that shwordsplit doesn't work properly. by @kampka in https://github.com/babarot/enhancd/pull/74
- Fixes #80 by @emres in https://github.com/babarot/enhancd/pull/81
- Fix the check of awk command existence by @kan-bayashi in https://github.com/babarot/enhancd/pull/82
- Update installation guide by @babarot in https://github.com/babarot/enhancd/pull/86
- Support default option such as -P by @babarot in https://github.com/babarot/enhancd/pull/88
- Add new tab completion feature by @babarot in https://github.com/babarot/enhancd/pull/90

## [v2.2.1](https://github.com/babarot/enhancd/commits/v2.2.1) - 2016-10-16
- Ignore directory jump list by @domidimi in https://github.com/babarot/enhancd/pull/31
- Use absolute path to avoid user alias in https://github.com/babarot/enhancd/pull/29
- Release 2.2.0 by @babarot in https://github.com/babarot/enhancd/pull/34
- Add escape in gsub by @usami-k in https://github.com/babarot/enhancd/pull/35
- Fix typo in readme by @lukechilds in https://github.com/babarot/enhancd/pull/38
- Make "__enhancd::cd()" arguments "-" and ".." configurable by shell vars by @key-amb in https://github.com/babarot/enhancd/pull/37
- Add an environment variable ENHANCD_DOT_SHOW_FULLPATH by @acro5piano in https://github.com/babarot/enhancd/pull/42
- Add documentation for ENHANCD_DOT_ARG, ENHANCD_HYPHEN_ARG by @key-amb in https://github.com/babarot/enhancd/pull/43
- Introduce ENHANCD_DISABLE_HOME config option not to use filter to cd without argument by @key-amb in https://github.com/babarot/enhancd/pull/44
- Improve performance and do a bit of refactoring (v2.2.1) by @babarot in https://github.com/babarot/enhancd/pull/40
- Fix wrong directory name when ENHANCD_DOT_SHOW_FULLPATH=1 by @acro5piano in https://github.com/babarot/enhancd/pull/45
