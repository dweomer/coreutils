#!/bin/sh
# make sure 'mv -i a b' does its job with a positive response

# Copyright (C) 2001-2025 Free Software Foundation, Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

. "${srcdir=.}/tests/init.sh"; path_prepend_ ./src
print_ver_ mv

for i in a b; do
  echo $i > $i || framework_failure_
done
echo y > y || framework_failure_
echo n > n || framework_failure_

mv -i a b < y >/dev/null 2>&1 || fail=1

# Make sure out contains the prompt.
case "$(cat b)" in
  a) ;;
  *) fail=1 ;;
esac

# Ensure that mv -i a b works properly with 'n' and 'y' responses,
# when a and b are hard links to the same file.
rm -f a b
echo a > a
ln a b
mv -i a b < y 2>err && fail=1
test -r a || fail=1
test -r b || fail=1
printf "mv: 'a' and 'b' are the same file\n" > exp
compare exp err || fail=1

Exit $fail
