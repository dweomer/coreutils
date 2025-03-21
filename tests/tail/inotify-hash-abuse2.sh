#!/bin/sh
# Exercise an abort-inducing flaw in inotify-enabled tail -F.
# Like inotify-hash-abuse, but without a hard-coded "9".

# Copyright (C) 2009-2025 Free Software Foundation, Inc.

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
print_ver_ tail

# Terminate any background tail process
cleanup_() { kill $pid 2>/dev/null && wait $pid; }

# Speedup the non inotify case
fastpoll='-s.1 --max-unchanged-stats=1'

for mode in '' '---disable-inotify'; do
  touch f || framework_failure_

  tail $mode $fastpoll -F f & pid=$!

  for i in $(seq 200); do
    kill -0 $pid || break;
    touch g
    mv g f
  done

  # Ensure tail hasn't aborted
  kill -0 $pid || fail=1

  cleanup_
done

Exit $fail
