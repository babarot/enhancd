# enhancd-fish initialization hook
#
# You can use the following variables in this file:
# * $package       package name
# * $path          package path
# * $dependencies  package dependencies

# set variables
set -gx ENHANCD_FILTER

if ! set -q ENHANCD_COMMAND; set -gx ENHANCD_COMMAND "cd"; end
if ! set -q ENHANCD_ROOT; set -gx ENHANCD_ROOT $path; end
if ! set -q ENHANCD_DIR; set -gx ENHANCD_DIR $HOME/.enhancd; end
if ! set -q ENHANCD_DISABLE_DOT; set -gx ENHANCD_DISABLE_DOT 0; end
if ! set -q ENHANCD_DISABLE_HYPHEN; set -gx ENHANCD_DISABLE_HYPHEN 0; end
if ! set -q ENHANCD_DISABLE_HOME; set -gx ENHANCD_DISABLE_HOME 0; end

if ! set -q ENHANCD_DOT_ARG; set -gx ENHANCD_DOT_ARG ".."; end
if ! set -q ENHANCD_HYPHEN_ARG; set -gx ENHANCD_HYPHEN_ARG "-"; end
if ! set -q ENHANCD_HYPHEN_NUM; set -gx ENHANCD_HYPHEN_NUM 10; end
if ! set -q ENHANCD_HOME_ARG; set -gx ENHANCD_HOME_ARG ""; end
if ! set -q ENHANCD_USE_FUZZY_MATCH; set -gx ENHANCD_USE_FUZZY_MATCH 1; end

if ! set -q ENHANCD_COMPLETION_DEFAULT; set -gx ENHANCD_COMPLETION_DEFAULT 1; end
if ! set -q ENHANCD_COMPLETION_BEHAVIOUR; set -gx ENHANCD_COMPLETION_BEHAVIOUR "default"; end

set -gx ENHANCD_COMPLETION_KEYBIND "^I";

set -gx _ENHANCD_VERSION "2.2.4"
set -gx _ENHANCD_SUCCESS 0
set -gx _ENHANCD_FAILURE 60

# Set the filters if empty
if [ -z "$ENHANCD_FILTER" ]
    set -gx ENHANCD_FILTER "fzy:fzf-tmux:fzf:peco:percol:gof:pick:icepick:sentaku:selecta"
end

# make a log file and a root directory
if ! [ -d "$ENHANCD_DIR" ]
    mkdir -p "$ENHANCD_DIR"
end

if ! [ -f "$ENHANCD_DIR/enhancd.log" ]
    touch "$ENHANCD_DIR/enhancd.log"
end

# Remove bash/zsh sources
if [ -d "$ENHANCD_ROOT/src" ]
    rm -rf "$ENHANCD_ROOT/src"
end

if [ -f "$ENHANCD_ROOT/init.sh" ]
    rm -f "$ENHANCD_ROOT/init.sh"
end

# alias to enhancd
eval "alias $ENHANCD_COMMAND 'enhancd'"