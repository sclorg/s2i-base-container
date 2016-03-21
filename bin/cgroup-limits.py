#!/usr/bin/python

"""
Script for parsing cgroup information

This script will read some limits from the cgroup system and parse
them, printing out "VARIABLE=VALUE" on each line for every limit that is
successfully read. Output of this script can be directly fed into
bash's export command. Recommended usage from a bash script:

    set -o errexit
    export_vars=$(cgroup-limits.py)
    export $export_vars

Variables currently supported:
    MAX_MEMORY_LIMIT_IN_BYTES
        Maximum possible limit MEMORY_LIMIT_IN_BYTES can have. This is
        currently constant value of 9223372036854775807.
    MEMORY_LIMIT_IN_BYTES
        Maximum amount of user memory in bytes. If this value is set
        to the same value as MAX_MEMORY_LIMIT_IN_BYTES, it means that
        there is no limit set. The value is taken from
        /sys/fs/cgroup/memory/memory.limit_in_bytes
    NUMBER_OF_CORES
        Number of detected CPU cores that can be used. This value is
        calculated from /sys/fs/cgroup/cpuset/cpuset.cpus
"""

from __future__ import print_function
import sys

env_vars = {}


def _read_file(path):
    try:
        with open(path, 'r') as f:
            return f.read().strip()
    except IOError:
        return None


def get_memory_limit():
    """
    Read memory limit, in bytes.
    """

    limit = _read_file('/sys/fs/cgroup/memory/memory.limit_in_bytes')
    if limit is None:
        print("Warning: Can't detect memory limit from cgroups",
              file=sys.stderr)
        return
    env_vars['MEMORY_LIMIT_IN_BYTES'] = limit


def get_number_of_cores():
    """
    Read number of CPU cores.
    """

    core_count = 0

    line = _read_file('/sys/fs/cgroup/cpuset/cpuset.cpus')
    if line is None:
        print("Warning: Can't detect number of CPU cores from cgroups",
              file=sys.stderr)
        return

    for group in line.split(','):
        core_ids = list(map(int, group.split('-')))
        if len(core_ids) == 2:
            core_count += core_ids[1] - core_ids[0] + 1
        else:
            core_count += 1

    env_vars['NUMBER_OF_CORES'] = str(core_count)

if __name__ == "__main__":
    get_memory_limit()
    get_number_of_cores()

    print("MAX_MEMORY_LIMIT_IN_BYTES=9223372036854775807")
    for item in env_vars.items():
        print("=".join(item))
