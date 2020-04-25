# enhancd-fish initialization hook
#
# You can use the following variables in this file:
# * $package       package name
# * $path          package path
# * $dependencies  package dependencies

# set variables
source $path/init.fish
if not set -q ENHANCD_ROOT; set -gx ENHANCD_ROOT $path; end
