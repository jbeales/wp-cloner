#! /usr/bin/env sh

# This script is a simple tool generating slug from a string passed via a pipe
# or as an argument.
#
# Please check https://github.com/Mayeu/slugify for more details.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# From: https://github.com/Mayeu/slugify

VERSION=1.0.2

# This is the magic
to_slug() {
  # Forcing the POSIX local so alnum is only 0-9A-Za-z
  export LANG=POSIX
  export LC_ALL=POSIX
  # Keep only alphanumeric value
  sed -e 's/[^[:alnum:]]/-/g' |
  # Keep only one dash if there is multiple one consecutively
  tr -s '-'                   |
  # Lowercase everything
  tr A-Z a-z                  |
  # Remove last dash if there is nothing after
  sed -e 's/-$//'
}

# Consume stdin if it exist
if test -p /dev/stdin; then
  read -r input
fi

# Now check if there was input in stdin
if test -n "${input}"; then
  echo "${input}" | to_slug
  exit
# No stdin, let's check if there is an argument
elif test -n "${1}"; then
  echo "${1}" | to_slug
  exit
else
  # Otherwise we return
  name=$(basename "${0}")
  echo "version 1.0.0"
  echo "Usage: ${name} text"
  echo "       echo text | ${name}"
  exit
fi